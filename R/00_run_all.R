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
# =============================================================================

`%||%` <- function(a, b) if (is.null(a)) b else a

ROOT <- local({
  a <- commandArgs(trailingOnly = FALSE)
  f <- sub("^--file=", "", a[grep("^--file=", a)])
  if (length(f)) normalizePath(file.path(dirname(f), "..")) else getwd()
})

suppressWarnings(suppressMessages({
  for (f in c("lib_config.R", "lib_data.R", "lib_summaries.R", "lib_model.R",
              "01_validate_data.R", "02_prior_predictive.R",
              "03_fit_prevalence.R", "06_frequentist_compare.R")) {
    source(file.path(ROOT, "R", f))
  }
  library(brms); library(posterior); library(metafor)
}))

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
  message("== configuration ==")
  message("  seed ", cfg$seed, ", primary horizon ", cfg$horizons$primary)
  message("  sample_status: ", cfg$sample_status)

  ## ---- data checks ---------------------------------------------------------
  message("\n== data checks ==")
  dat <- read_extraction(cfg)
  validate_extraction(dat, cfg)
  dat <- derive_columns(dat, cfg)
  message("  validation passed: ", nrow(dat$outcomes), " results, ",
          nrow(dat$cohorts), " cohorts")

  aid <- analysis_id(cfg, dat$shas)
  run_dir <- file.path(ROOT, "results", paste0("run_", aid))
  tab_dir <- file.path(run_dir, "tables"); diag_dir <- file.path(run_dir, "diagnostics")
  for (p in c(tab_dir, diag_dir)) dir.create(p, recursive = TRUE, showWarnings = FALSE)
  cache_dir <- file.path(ROOT, ".cache", "fits", aid)
  message("  analysis_id ", aid, "  (worktree ", worktree_status(cfg), ")")

  ## ---- design checks -------------------------------------------------------
  message("\n== design checks ==")
  pool <- build_primary_pool(dat, cfg)
  message("  primary pool: ", nrow(pool$data), " results from ",
          length(unique(pool$data$cohort_id)), " cohorts at ", pool$horizon)
  pool$log$sample_status <- cfg$sample_status
  write.csv(pool$log, file.path(tab_dir, "pool_construction.csv"), row.names = FALSE)
  if (!is.null(pool$dropped_for_overlap)) {
    write.csv(pool$dropped_for_overlap,
              file.path(tab_dir, "reports_set_aside.csv"), row.names = FALSE)
    message("  ", nrow(pool$dropped_for_overlap),
            " report(s) set aside by the result-selection rule, named in reports_set_aside.csv")
  }
  st <- prevalence_study_table(pool, cfg)
  if (!is.null(st)) write.csv(st, file.path(tab_dir, "study_table.csv"), row.names = FALSE)

  diagnostics <- list()
  expected_fits <- character(0)

  ## ---- model checks: prior predictive --------------------------------------
  message("\n== model checks: prior predictive ==")
  if (nrow(pool$data) < 2L) {
    note_skip("prior_predictive", "fewer than 2 results in the pool")
  } else {
    expected_fits <- c(expected_fits, "prior_predictive")
    pp <- prior_predictive_check(pool$data, cfg, cache_dir)
    write.csv(pp$table, file.path(tab_dir, "prior_predictive.csv"), row.names = FALSE)
    write.csv(pp$implied, file.path(tab_dir, "prior_predictive_implied.csv"),
              row.names = FALSE)
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

  ## ---- primary fit ---------------------------------------------------------
  message("\n== primary prevalence model ==")
  res <- fit_prevalence(pool, cfg, cache_dir)
  if (identical(res$status, "skipped")) {
    note_skip("prevalence_primary", res$reason)
  } else {
    expected_fits <- c(expected_fits, res$fit_id)
    write.csv(res$summaries, file.path(tab_dir, "pooled_proportion.csv"),
              row.names = FALSE)
    diagnostics[[length(diagnostics) + 1L]] <- res$diagnostics
    if (!is.null(res$ppc$overall)) {
      res$ppc$overall$sample_status <- cfg$sample_status
      write.csv(res$ppc$overall, file.path(diag_dir, "ppc_overall.csv"),
                row.names = FALSE)
    }
    if (!is.null(res$ppc$per_result)) {
      write.csv(res$ppc$per_result, file.path(diag_dir, "ppc_per_result.csv"),
                row.names = FALSE)
    }
    p <- res$summaries[res$summaries$quantity == "pooled_proportion", ]
    message(sprintf("  pooled proportion %.3f [%.3f, %.3f]  (k = %d cohorts, nested = %s)",
                    p$median, p$q_lo, p$q_hi, p$k_cohorts, res$nested))
    message("  ", cfg$sample_status)

    ## ---- frequentist diagnostic comparison ---------------------------------
    message("\n== frequentist comparison (diagnostic, not a gate) ==")
    fq <- frequentist_compare(pool$data, res$summaries, cfg)
    write.csv(fq$table, file.path(tab_dir, "frequentist_comparison.csv"),
              row.names = FALSE)
    write.csv(fq$differences, file.path(tab_dir, "frequentist_differences.csv"),
              row.names = FALSE)
    print(fq$differences[c("quantity", "brms", "rma_glmm", "absolute_difference")],
          row.names = FALSE)
  }

  ## ---- moderators ----------------------------------------------------------
  message("\n== moderators ==")
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
  write.csv(mods, file.path(tab_dir, "moderator_slopes.csv"), row.names = FALSE)
  message("  ", sum(mods$status == "not reported"), " of ", nrow(mods),
          " moderators below the reportability threshold and correctly not reported")

  ## ---- sampling diagnostics ------------------------------------------------
  message("\n== sampling checks ==")
  if (length(diagnostics)) {
    dg <- do.call(rbind, diagnostics)
    dg$sample_status <- cfg$sample_status
    write.csv(dg, file.path(diag_dir, "fit_diagnostics.csv"), row.names = FALSE)
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
  write.csv(manifest, file.path(run_dir, "run_manifest.csv"), row.names = FALSE)

  ## ---- closing summary -----------------------------------------------------
  message("\n== summary ==")
  message("  elapsed ", round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1), "s")
  message("  outputs in results/run_", aid)
  if (length(SKIPS$rows)) {
    sk <- do.call(rbind, SKIPS$rows)
    write.csv(sk, file.path(run_dir, "skipped_steps.csv"), row.names = FALSE)
    message("  ", nrow(sk), " step(s) skipped, recorded in skipped_steps.csv:")
    for (i in seq_len(nrow(sk))) message("    - ", sk$step[i], ": ", sk$reason[i])
  } else {
    message("  no steps skipped")
  }
  message("\n  ", cfg$sample_status)
  invisible(TRUE)
}

if (!interactive()) {
  ok <- tryCatch({ main(); TRUE },
                 error = function(e) { message("\nRUN FAILED: ", conditionMessage(e)); FALSE })
  quit(status = if (ok) 0L else 1L)
}
