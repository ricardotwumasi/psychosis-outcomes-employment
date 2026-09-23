#!/usr/bin/env Rscript
# =============================================================================
# 00_run_all.R
#
#     Rscript R/00_run_all.R
#
# The runner distinguishes four classes of check and does not conflate them:
#
#   data checks        schema and vocabulary validation
#   design checks      is the pool coherent, is the sample labelled honestly
#   model checks       prior predictive, posterior predictive
#   sampling checks    R-hat, ESS, divergences, treedepth, E-BFMI
#
# Sampling diagnostics validate sampling. They say nothing about whether the
# estimand, the outcome definition or the sampling frame is right, and nothing
# in this runner should be read as implying otherwise.
#
# Nothing is skipped silently. A deliberate skip writes a row with a reason and
# is printed in the closing summary.
#
# Every horizon in horizons.bands is estimated, each under D11.3 on DISTINCT
# cohorts: no estimate at 0, an exact binomial interval at 1, the model at 2 or
# more. Where the model runs, the two named sensitivity pools, the
# missing-outcome bounds, the frequentist comparison and priorsense run too,
# and below small_k_threshold the one-at-a-time prior grid runs alongside.
# =============================================================================

`%||%` <- function(a, b) if (is.null(a)) b else a

ROOT <- local({
  a <- commandArgs(trailingOnly = FALSE)
  f <- sub("^--file=", "", a[grep("^--file=", a)])
  if (length(f)) normalizePath(file.path(dirname(f), "..")) else getwd()
})

suppressWarnings(suppressMessages({
  for (f in c("lib_config.R", "lib_data.R", "lib_summaries.R", "lib_model.R",
              "lib_synthetic.R", "01_validate_data.R", "02_prior_predictive.R",
              "03_fit_prevalence.R", "06_frequentist_compare.R")) {
    source(file.path(ROOT, "R", f))
  }
  library(brms); library(posterior); library(metafor)
}))

# The no-posterior guard (resolve_fit_mode and assert_may_fit) lives in
# lib_config.R, where its modes and gates are documented and tested. The mode
# is resolved at the start of main(), so conflicting variables stop the run
# before anything is read, and assert_may_fit runs before ANY sampling,
# including the prior predictive.

SKIPS <- new.env(parent = emptyenv()); SKIPS$rows <- list()
note_skip <- function(step, reason) {
  SKIPS$rows[[length(SKIPS$rows) + 1L]] <-
    data.frame(step = step, status = "skipped", reason = reason,
               stringsAsFactors = FALSE)
  message("  [skip] ", step, ": ", reason)
}

main <- function() {
  t0 <- Sys.time()
  cfg <- load_config(ROOT)
  sel <- resolve_fit_mode()
  mode <- sel$mode
  message("== configuration ==")
  message("  seed ", cfg$seed, ", primary horizon ", cfg$horizons$primary)
  message("  sample_status: ", cfg$sample_status)
  message("  fit mode: ", mode, if (sel$synthetic) " (SYNTHETIC DATA)" else "")

  ## ---- data checks ---------------------------------------------------------
  message("\n== data checks ==")
  dat <- if (sel$synthetic) synthetic_extraction(cfg) else read_extraction(cfg)
  validate_extraction(dat, cfg)
  dat <- derive_columns(dat, cfg)
  message("  validation passed: ", nrow(dat$outcomes), " results, ",
          nrow(dat$cohorts), " cohorts")

  aid <- analysis_id(cfg, dat$shas)

  ## ---- the guard -----------------------------------------------------------
  # Before anything is written or sampled. A prior predictive fit is still a
  # fit, and a design-only run previously sampled and cached one before
  # refusing; a refused provisional run would also have left a provisional_
  # directory of stamped tables with no fit behind them. The design tables a
  # design-only run used to write here are produced by R/04_design_package.R.
  message("\n== fit guard ==")
  gate <- assert_may_fit(cfg, mode)
  # Each mode has its own namespace. The prefix is on the directory rather than
  # inside a file, so the separation survives someone copying a table out of
  # it, and every table ALSO carries result_status for when it does not.
  prefix <- switch(mode, engineering = "engineering_synthetic_",
                   provisional = "provisional_", "run_")
  run_dir <- file.path(ROOT, "results", paste0(prefix, aid))
  tab_dir <- file.path(run_dir, "tables"); diag_dir <- file.path(run_dir, "diagnostics")
  for (p in c(tab_dir, diag_dir)) dir.create(p, recursive = TRUE, showWarnings = FALSE)
  # Split by mode, so an engineering or provisional fit can never be served
  # from cache to a definitive run with the same analysis identifier.
  cache_dir <- file.path(ROOT, ".cache", "fits", mode, aid)
  message("  analysis_id ", aid, "  (worktree ", worktree_status(cfg), ")")

  # Every table written by this runner goes through here, so none can leave
  # without sample_status and result_status.
  write_tab <- function(df, path) {
    if (is.null(df)) return(invisible(NULL))
    if (nrow(df) && !"sample_status" %in% names(df)) df$sample_status <- cfg$sample_status
    utils::write.csv(stamp_result_status(df, mode), path, row.names = FALSE)
  }

  ## ---- design checks -------------------------------------------------------
  message("\n== design checks ==")
  pool <- build_primary_pool(dat, cfg)
  message("  primary pool: ", nrow(pool$data), " results from ",
          length(unique(pool$data$cohort_id)), " cohorts at ", pool$horizon)
  pool$log$sample_status <- cfg$sample_status
  write_tab(pool$log, file.path(tab_dir, "pool_construction.csv"))
  if (!is.null(pool$dropped_for_overlap)) {
    write_tab(pool$dropped_for_overlap, file.path(tab_dir, "reports_set_aside.csv"))
    message("  ", nrow(pool$dropped_for_overlap),
            " report(s) set aside by the result-selection rule, named in reports_set_aside.csv")
  }
  st <- prevalence_study_table(pool, cfg)
  if (!is.null(st)) write_tab(st, file.path(tab_dir, "study_table.csv"))

  diagnostics <- list()
  expected_fits <- character(0)
  keep_fit <- function(res) {
    expected_fits <<- c(expected_fits, res$fit_id)
    diagnostics[[length(diagnostics) + 1L]] <<- res$diagnostics
  }

  ## ---- model checks: prior predictive --------------------------------------
  message("\n== model checks: prior predictive ==")
  if (nrow(pool$data) < 2L) {
    note_skip("prior_predictive", "fewer than 2 results in the primary-horizon pool")
  } else {
    expected_fits <- c(expected_fits, "prior_predictive")
    pp <- prior_predictive_check(pool$data, cfg, cache_dir)
    write_tab(pp$table, file.path(tab_dir, "prior_predictive.csv"))
    write_tab(pp$implied, file.path(tab_dir, "prior_predictive_implied.csv"))
    for (i in seq_len(nrow(pp$table))) {
      message(sprintf("  [%s] %s", if (pp$table$pass[i]) "pass" else "FAIL",
                      pp$table$criterion[i]))
    }
    if (!pp$verdict) {
      stop("prior predictive check FAILED. The criteria are prespecified in ",
           "config/analysis.yml and are not renegotiated after seeing the ",
           "result. Revise the priors in a dated amendment, or explain the ",
           "failure. See tables/prior_predictive.csv.", call. = FALSE)
    }
    message("  prior predictive verdict: pass")
  }

  ## ---- every horizon, under D11.3 ------------------------------------------
  pooled_rows <- list(); sens_rows <- list(); grid_rows <- list()
  summaries <- list(); ppc_overall <- list(); ppc_per <- list()
  fq_tabs <- list(); fq_diffs <- list(); ps_rows <- list()
  grid <- prior_grid_settings(cfg)

  for (h in names(cfg$horizons$bands)) {
    message("\n== prevalence at ", h, " ==")
    hp <- if (identical(h, cfg$horizons$primary)) pool
          else build_primary_pool(dat, cfg, horizon = h)
    res <- fit_prevalence(hp, cfg, cache_dir, horizon = h)
    pooled_rows[[h]] <- pooled_row(res, cfg)
    r <- pooled_rows[[h]]
    message(sprintf("  k = %d cohorts, %s", r$k_cohorts, r$method))
    if (!is.na(r$estimate)) {
      message(sprintf("  estimate %.3f [%.3f, %.3f]%s", r$estimate, r$interval_lo,
                      r$interval_hi, if (isTRUE(r$small_k)) "  (small k)" else ""))
    }
    if (identical(res$status, "no_estimate")) note_skip(paste0("prevalence_", h), res$reason)
    if (!identical(res$status, "ok")) next

    keep_fit(res)
    summaries[[h]] <- res$summaries
    if (!is.null(res$ppc$overall)) ppc_overall[[h]] <- cbind(horizon = h, res$ppc$overall)
    if (!is.null(res$ppc$per_result)) ppc_per[[h]] <- cbind(horizon = h, res$ppc$per_result)

    ## frequentist diagnostic comparison, at every fitted horizon. It is the
    ## same comparison as before; nothing in it was specific to one horizon.
    fq <- frequentist_compare(res$data, res$summaries, cfg)
    fq_tabs[[h]] <- cbind(horizon = h, fq$table)
    fq_diffs[[h]] <- cbind(horizon = h, fq$differences)

    ## priorsense power-scaling on the primary fit. An error is recorded as a
    ## skip with its message, never swallowed.
    ps <- tryCatch({
      x <- as.data.frame(priorsense::powerscale_sensitivity(
        res$fit, variable = c("b_Intercept", "sd_cohort_id__Intercept")))
      cbind(horizon = h, fit_id = res$fit_id, x)
    }, error = function(e) {
      note_skip(paste0("priorsense_", h), conditionMessage(e)); NULL
    })
    if (!is.null(ps)) ps_rows[[h]] <- ps

    ## one-at-a-time prior grid and the weak set, required below small k
    if (isTRUE(res$route$prior_sensitivity_required)) {
      for (nm in names(grid)) {
        g <- if (identical(nm, "primary")) res
             else fit_prevalence(hp, cfg, cache_dir, horizon = h,
                                 priors = grid[[nm]], analysis = paste0("prior_", nm))
        if (!identical(nm, "primary")) keep_fit(g)
        gr <- pooled_row(g, cfg)
        pr <- grid[[nm]]
        grid_rows[[paste(h, nm)]] <- cbind(
          gr[c("horizon", "k_cohorts")], setting = nm,
          varied = if (nm %in% c("primary", "weak")) nm
                   else sub("^grid_(.*)_[^_]+$", "\\1", nm),
          intercept_mean = pr$intercept_mean, intercept_sd = pr$intercept_sd,
          tau_sd = pr$tau_sd,
          gr[c("estimate", "interval_lo", "interval_hi", "predictive_new_cohort_lo",
               "predictive_new_cohort_hi", "tau_median", "tau_lo", "tau_hi",
               "sample_status")],
          prior_hash = g$prior_hash, stringsAsFactors = FALSE)
      }
    }

    ## named sensitivity pools and missing-outcome bounds, same D11.3 logic
    sens <- build_sensitivity_pools(dat, cfg, horizon = h)
    variants <- lapply(sens, function(s) list(label = s$label, pool = s$pool))
    for (case in c("worst", "best")) {
      d2 <- missing_outcome_bound_data(res$data, case)
      variants[[paste0("missing_outcome_", case)]] <- list(
        label = sprintf("unobserved alive-and-eligible participants all %s",
                        if (case == "worst") "unemployed" else "employed"),
        pool = list(data = d2, horizon = h),
        n_bounded = attr(d2, "n_cohorts_bounded"))
    }
    for (nm in names(variants)) {
      v <- variants[[nm]]
      vd <- v$pool$data
      same <- identical(vd[c("cohort_id", "n_employed", "n_outcome_observed")],
                        res$data[c("cohort_id", "n_employed", "n_outcome_observed")])
      # An identical data set is the primary fit; refitting it under another
      # name would only report the same posterior as if it were corroboration.
      sv <- if (same) res else fit_prevalence(v$pool, cfg, cache_dir, horizon = h,
                                             analysis = nm)
      if (!same && identical(sv$status, "ok")) keep_fit(sv)
      row <- pooled_row(sv, cfg)
      row$analysis <- nm
      row <- cbind(row[c("horizon", "analysis")], label = v$label,
                   identical_to_primary = same,
                   n_cohorts_bounded = v$n_bounded %||% NA_integer_,
                   row[setdiff(names(row), c("horizon", "analysis"))],
                   stringsAsFactors = FALSE)
      if (same) row$note <- paste0("identical data to the primary pool; the primary fit is reported",
                                   if (nzchar(row$note)) paste0("; ", row$note) else "")
      sens_rows[[paste(h, nm)]] <- row
    }
  }

  pooled <- do.call(rbind, pooled_rows)
  write_tab(pooled, file.path(tab_dir, "pooled_by_horizon.csv"))
  bind <- function(x) if (length(x)) do.call(rbind, x) else NULL
  write_tab(bind(summaries), file.path(tab_dir, "pooled_proportion.csv"))
  write_tab(bind(sens_rows), file.path(tab_dir, "sensitivity_by_horizon.csv"))
  write_tab(bind(grid_rows), file.path(tab_dir, "prior_sensitivity.csv"))
  write_tab(bind(ps_rows), file.path(tab_dir, "priorsense_powerscale.csv"))
  write_tab(bind(fq_tabs), file.path(tab_dir, "frequentist_comparison.csv"))
  write_tab(bind(fq_diffs), file.path(tab_dir, "frequentist_differences.csv"))
  write_tab(bind(ppc_overall), file.path(diag_dir, "ppc_overall.csv"))
  write_tab(bind(ppc_per), file.path(diag_dir, "ppc_per_result.csv"))
  if (any(pooled$prior_sensitivity_required) && !length(grid_rows)) {
    stop("a small-k horizon requires prior sensitivity but no grid row was ",
         "produced", call. = FALSE)
  }

  ## ---- moderators ----------------------------------------------------------
  message("\n== moderators (primary horizon) ==")
  mod_rows <- list()
  for (nm in names(cfg$moderators)) {
    r <- moderator_reportable(pool$data, cfg, nm)
    mod_rows[[length(mod_rows) + 1L]] <- data.frame(
      moderator = nm, tier = cfg$moderators[[nm]]$tier,
      status = r$status, n_cohorts = r$n_cohorts %||% NA_integer_,
      reason = r$reason,
      estimate = NA_real_, q_lo = NA_real_, q_hi = NA_real_,
      sample_status = cfg$sample_status, stringsAsFactors = FALSE)
  }
  mods <- do.call(rbind, mod_rows)
  write_tab(mods, file.path(tab_dir, "moderator_slopes.csv"))
  message("  ", sum(mods$status == "not reported"), " of ", nrow(mods),
          " moderators below the reportability threshold and correctly not reported")

  ## ---- sampling diagnostics ------------------------------------------------
  message("\n== sampling checks ==")
  if (length(diagnostics)) {
    dg <- do.call(rbind, diagnostics)
    dg$sample_status <- cfg$sample_status
    write_tab(dg, file.path(diag_dir, "fit_diagnostics.csv"))
    for (i in seq_len(nrow(dg))) {
      message(sprintf("  [%s] %s  rhat %.4f  ess_bulk %.0f  div %d  esc %d%s",
                      if (dg$pass[i]) "pass" else "FAIL", dg$fit_id[i],
                      dg$max_rhat[i], dg$min_ess_bulk[i], dg$num_divergent[i],
                      dg$escalations[i],
                      if (nzchar(dg$failure_reason[i]))
                        paste0("  <- ", dg$failure_reason[i]) else ""))
    }
    # Every expected posterior fit must have a diagnostics row. A fit that
    # never ran is a visible missing row, not an absence.
    posterior_fits <- setdiff(expected_fits, "prior_predictive")
    missing <- setdiff(posterior_fits, dg$fit_id)
    if (length(missing)) {
      stop("expected fits with no diagnostics row: ",
           paste(missing, collapse = ", "), call. = FALSE)
    }
    if (!all(dg$pass)) {
      stop("sampling diagnostics failed for: ",
           paste(dg$fit_id[!dg$pass], collapse = ", "), call. = FALSE)
    }
  } else {
    note_skip("sampling_diagnostics", "no posterior fits were run")
  }

  ## ---- manifest ------------------------------------------------------------
  files <- list.files(run_dir, recursive = TRUE, full.names = TRUE)
  manifest <- data.frame(
    analysis_id = aid,
    fit_mode = mode, synthetic_data = sel$synthetic, git_tag = gate$tag,
    source_commit = tryCatch(system2("git", c("-C", shQuote(ROOT), "rev-parse", "HEAD"),
                                     stdout = TRUE), error = function(e) NA_character_),
    worktree = worktree_status(cfg),
    config_sha256 = cfg$.sha_analysis, vocab_sha256 = cfg$.sha_vocab,
    r_version = R.version.string,
    brms_version = as.character(utils::packageVersion("brms")),
    cmdstan_version = tryCatch(as.character(cmdstanr::cmdstan_version()),
                               error = function(e) NA_character_),
    os = Sys.info()[["sysname"]], arch = R.version$arch,
    generated = format(Sys.time(), "%Y-%m-%dT%H:%M:%S%z"),
    file = sub(paste0("^", run_dir, "/"), "", files),
    sha256 = vapply(files, function(f) digest::digest(file = f, algo = "sha256"),
                    character(1)),
    bytes = file.info(files)$size,
    row.names = NULL, stringsAsFactors = FALSE
  )
  write_tab(manifest, file.path(run_dir, "run_manifest.csv"))

  ## ---- closing summary -----------------------------------------------------
  message("\n== summary ==")
  message("  elapsed ", round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1), "s")
  message("  outputs in results/", basename(run_dir))
  if (length(SKIPS$rows)) {
    sk <- do.call(rbind, SKIPS$rows)
    write_tab(sk, file.path(run_dir, "skipped_steps.csv"))
    message("  ", nrow(sk), " step(s) skipped, recorded in skipped_steps.csv:")
    for (i in seq_len(nrow(sk))) message("    - ", sk$step[i], ": ", sk$reason[i])
  } else {
    message("  no steps skipped")
  }
  message("\n  ", cfg$sample_status)
  message("  ", result_status_label(mode))
  invisible(TRUE)
}

if (!interactive()) {
  ok <- tryCatch({ main(); TRUE },
                 error = function(e) { message("\nRUN FAILED: ", conditionMessage(e)); FALSE })
  quit(status = if (ok) 0L else 1L)
}
