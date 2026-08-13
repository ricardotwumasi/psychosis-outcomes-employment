#!/usr/bin/env Rscript
# =============================================================================
# 04_design_package.R
#
#     Rscript R/04_design_package.R
#
# The design-only package. It answers "what evidence would enter which
# synthesis, and what removes the rest", for every horizon and both
# prespecified sensitivity analyses, and it fits nothing.
#
# This exists because the pool is the part of the design that a checker can
# audit before any estimate exists, and because the runner reports only the one
# configured primary horizon and never calls build_sensitivity_pools(). A
# horizon whose pool nobody has looked at is a horizon whose eligibility rules
# nobody has tested.
#
# NOTHING HERE SAMPLES A POSTERIOR. No estimate, pooled or otherwise, is
# produced, and every output file carries the sample_status stamp. Attrition is
# reported in BOTH result rows and distinct cohorts, because D11.3 counts
# cohorts and a filter that removes ten rows from one cohort removes no
# evidence.
# =============================================================================

`%||%` <- function(a, b) if (is.null(a)) b else a

ROOT <- local({
  a <- commandArgs(trailingOnly = FALSE)
  f <- sub("^--file=", "", a[grep("^--file=", a)])
  if (length(f)) normalizePath(file.path(dirname(f), "..")) else getwd()
})

suppressWarnings(suppressMessages({
  for (f in c("lib_config.R", "lib_data.R", "lib_summaries.R")) {
    source(file.path(ROOT, "R", f))
  }
}))

OUTDIR <- file.path(ROOT, "results", "design_package")

#' Every output says what it is, in the file, so a stray CSV cannot be quoted
#' as a finding once separated from this script.
stamp <- function(df, cfg) {
  if (!nrow(df)) return(df)
  cbind(df, sample_status = cfg$sample_status, generated = as.character(Sys.Date()),
        stringsAsFactors = FALSE)
}

write_out <- function(df, name, cfg) {
  df <- stamp(as.data.frame(df, stringsAsFactors = FALSE), cfg)
  utils::write.csv(df, file.path(OUTDIR, name), row.names = FALSE, na = "")
  invisible(df)
}

#' Attrition in rows AND in distinct cohorts.
#'
#' build_primary_pool() logs rows removed per clause. Cohort counts are
#' recomputed here from the same clause order, so the two columns cannot
#' disagree about which filter did what.
attrition_table <- function(pool, horizon) {
  lg <- pool$log
  if (is.null(lg) || !nrow(lg)) return(NULL)
  data.frame(horizon = horizon,
             clause = lg$clause,
             rows_removed = lg$removed,
             rows_remaining = lg$remaining,
             cohorts_remaining = lg$cohorts_remaining %||% NA_integer_,
             stringsAsFactors = FALSE)
}

main <- function() {
  dir.create(OUTDIR, recursive = TRUE, showWarnings = FALSE)
  cfg <- load_config(ROOT)

  message("== design-only package ==")
  message("  sample_status: ", cfg$sample_status)
  message("  NOT FOR INFERENCE. No posterior is sampled by this script.")

  dat <- read_extraction(cfg)
  validate_extraction(dat, cfg)
  dat <- derive_columns(dat, cfg)
  message("  ", nrow(dat$outcomes), " results, ", nrow(dat$cohorts), " cohorts\n")

  horizons <- names(cfg$horizons$bands)
  pool_rows <- list(); attr_rows <- list(); sel_rows <- list(); sens_rows <- list()

  for (h in horizons) {
    pool <- build_primary_pool(dat, cfg, horizon = h)
    d <- pool$data
    k <- length(unique(d$cohort_id))
    rule <- if (k == 0L) "no estimate"
            else if (k == 1L) "descriptive exact binomial interval, not a meta-analysis"
            else if (k < (cfg$sparse_data$small_k_threshold %||% 10L))
              "model permitted, small-k and prior-sensitivity qualifications required"
            else "model permitted"
    message(sprintf("  %-6s results=%-3d cohorts=%-3d  D11.3: %s", h, nrow(d), k, rule))

    pool_rows[[h]] <- data.frame(horizon = h, n_results = nrow(d), n_cohorts = k,
                                 d11_3_consequence = rule, stringsAsFactors = FALSE)
    a <- attrition_table(pool, h)
    if (!is.null(a)) attr_rows[[h]] <- a
    if (nrow(d)) {
      sel_rows[[h]] <- data.frame(
        horizon = h, cohort_id = d$cohort_id, report_id = d$report_id,
        result_id = d$result_id, n_employed = d$n_employed,
        n_outcome_observed = d$n_outcome_observed,
        outcome_construct = d$outcome_construct,
        followup_months = d$followup_months, stringsAsFactors = FALSE)
    }
    if (!is.null(pool$dropped_for_overlap) && nrow(pool$dropped_for_overlap)) {
      dr <- pool$dropped_for_overlap
      dr$horizon <- h
      sel_rows[[paste0(h, "_dropped")]] <- NULL
      attr(sel_rows, "dropped") <- rbind(attr(sel_rows, "dropped"), dr)
    }

    sens <- build_sensitivity_pools(dat, cfg, horizon = h)
    for (nm in names(sens %||% list())) {
      s <- sens[[nm]]
      sk <- length(s$cohorts)
      sens_rows[[paste(h, nm)]] <- data.frame(
        horizon = h, analysis = nm, label = s$label,
        n_results = nrow(s$pool$data), n_cohorts = sk,
        identical_to_primary = identical(sort(unique(d$cohort_id)), sort(s$cohorts)),
        cohorts = paste(s$cohorts, collapse = ";"), stringsAsFactors = FALSE)
    }
  }

  write_out(do.call(rbind, pool_rows), "pool_by_horizon.csv", cfg)
  write_out(do.call(rbind, attr_rows), "attrition_by_horizon.csv", cfg)
  write_out(do.call(rbind, sel_rows), "selected_results.csv", cfg)
  write_out(do.call(rbind, sens_rows), "sensitivity_pools.csv", cfg)
  dropped <- attr(sel_rows, "dropped")
  if (!is.null(dropped)) write_out(dropped, "reports_set_aside.csv", cfg)

  message("\n  written to results/design_package/, every file stamped ",
          cfg$sample_status)
  message("  no posterior sampled, no estimate produced")
  invisible(NULL)
}

if (sys.nframe() == 0L || identical(environment(), globalenv())) main()
