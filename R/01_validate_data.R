#!/usr/bin/env Rscript
# =============================================================================
# 01_validate_data.R
#
# Validates the extraction tables and builds the primary pool. Run this before
# committing any extraction:
#
#     Rscript R/01_validate_data.R
#
# It stops on the first violation, naming the column, the row and the permitted
# values. Exits non-zero on failure so it can be wired into CI or a hook.
# =============================================================================

suppressWarnings(suppressMessages({
  root <- if (nzchar(Sys.getenv("PROJ_ROOT"))) Sys.getenv("PROJ_ROOT") else getwd()
  source(file.path(root, "R", "lib_config.R"))
  source(file.path(root, "R", "lib_data.R"))
}))

main <- function(root = getwd(), out_dir = NULL) {
  cfg <- load_config(root)
  cat("configuration loaded and validated\n")

  dat <- read_extraction(cfg)
  cat(sprintf("read: %d reports, %d cohorts, %d arms, %d results, %d rob rows\n",
              nrow(dat$reports), nrow(dat$cohorts), nrow(dat$arms),
              nrow(dat$outcomes),
              if (is.null(dat$rob)) 0L else nrow(dat$rob)))

  validate_extraction(dat, cfg)
  cat("schema and vocabulary validation passed\n")

  dat <- derive_columns(dat, cfg)
  cat("derived columns computed\n")

  # Cohort grouping is PRINTED for human review and never deduplicated
  # silently. A wrong cohort mapping is invisible in the results but changes
  # every interval, so a person has to look at it.
  multi <- names(which(table(dat$reports$cohort_id[
    !is.na(dat$reports$cohort_id) & nzchar(dat$reports$cohort_id)]) > 1L))
  if (length(multi)) {
    cat("\ncohorts with more than one report, FOR HUMAN REVIEW:\n")
    for (k in multi) {
      rs <- dat$reports$report_id[which(dat$reports$cohort_id == k)]
      cat(sprintf("  %-24s %s\n", k, paste(rs, collapse = ", ")))
    }
  }

  pool <- build_primary_pool(dat, cfg)
  cat(sprintf("\nprimary pool at horizon %s: %d results from %d cohorts\n",
              pool$horizon, nrow(pool$data), length(unique(pool$data$cohort_id))))
  cat("\npool construction:\n")
  print(pool$log, row.names = FALSE)

  if (!is.null(pool$dropped_for_overlap)) {
    cat("\nreports set aside by the result-selection rule (named, not dropped silently):\n")
    print(pool$dropped_for_overlap[c("cohort_id", "kept_report_id",
                                     "dropped_report_id")], row.names = FALSE)
  }

  if (!is.null(out_dir)) {
    dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
    pool$log$sample_status <- cfg$sample_status
    utils::write.csv(pool$log, file.path(out_dir, "pool_construction.csv"),
                     row.names = FALSE)
    if (!is.null(pool$dropped_for_overlap)) {
      utils::write.csv(pool$dropped_for_overlap,
                       file.path(out_dir, "reports_set_aside.csv"), row.names = FALSE)
    }
    chars <- merge(dat$cohorts, dat$outcomes, by = "cohort_id", all.x = TRUE)
    chars$sample_status <- cfg$sample_status
    utils::write.csv(chars, file.path(out_dir, "study_characteristics.csv"),
                     row.names = FALSE)
  }

  if (nrow(pool$data) == 0L) {
    cat("\nNOTE: the primary pool is empty at this horizon. That is a finding, ",
        "not necessarily an error: check pool_construction.csv to see which ",
        "clause removed the rows.\n", sep = "")
  }

  invisible(list(cfg = cfg, dat = dat, pool = pool))
}

# sys.nframe() is 0 only at top level. source() from another script creates a
# frame, so this block runs when the file is invoked as a script and not when
# 00_run_all.R sources it for its functions. The previous guard tested
# globalenv(), which is also true under source() and made the runner quit here.
if (sys.nframe() == 0L && !interactive()) {
  args <- commandArgs(trailingOnly = TRUE)
  root <- if (length(args) >= 1L) args[1] else getwd()
  out <- if (length(args) >= 2L) args[2] else NULL
  ok <- tryCatch({ main(root, out); TRUE },
                 error = function(e) { cat("\nVALIDATION FAILED\n", conditionMessage(e),
                                           "\n", sep = ""); FALSE })
  quit(status = if (ok) 0L else 1L)
}
