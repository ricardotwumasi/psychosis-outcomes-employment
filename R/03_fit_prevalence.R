#!/usr/bin/env Rscript
# =============================================================================
# 03_fit_prevalence.R
#
# The primary model: pooled proportion in paid employment among observational
# cohorts at the landmark horizon.
#
# Nesting is decided by the DATA, not by a count threshold. If any cohort
# contributes more than one result the within-cohort term is added, because
# dependence is a property of the design rather than of how many clusters
# happen to be available to estimate the component.
# =============================================================================

fit_prevalence <- function(pool, cfg, cache_dir = NULL, horizon = pool$horizon) {
  d <- pool$data
  if (nrow(d) < 2L) {
    return(list(status = "skipped",
                reason = sprintf("only %d result(s) in the pool at horizon %s; a random-effects model needs at least 2",
                                 nrow(d), horizon)))
  }

  nested <- needs_nesting(d)
  fit_id <- paste0("prevalence_", horizon, if (nested) "_nested" else "")

  fit <- fit_model(
    formula = prevalence_formula(nested = nested),
    data = d, priors = prevalence_priors(cfg, nested = nested),
    cfg = cfg, fit_id = fit_id, cache_dir = cache_dir
  )

  dr <- posterior::as_draws_df(fit)
  summaries <- prevalence_summaries(dr, cfg)
  summaries$horizon <- horizon
  summaries$k_cohorts <- length(unique(d$cohort_id))
  summaries$k_results <- nrow(d)
  summaries$nested <- nested

  diag <- fit_diagnostics(fit, fit_id)
  diag$escalations <- attr(fit, "escalations") %||% NA_integer_
  diag$pass <- diagnostics_pass(diag, cfg)
  diag$failure_reason <- diagnostics_failure_reason(diag, cfg)

  ppc <- tryCatch(posterior_predictive_check(fit, d, cfg),
                  error = function(e) list(per_result = NULL,
                                           overall = data.frame(
                                             form = "error", coverage = NA_real_,
                                             nominal = NA_real_,
                                             note = conditionMessage(e))))

  list(status = "ok", fit = fit, fit_id = fit_id, summaries = summaries,
       diagnostics = diag, ppc = ppc, data = d, nested = nested)
}

#' Per-cohort observed proportions, for the forest plot and for a reader who
#' wants to see the inputs rather than trust the pooled number.
prevalence_study_table <- function(pool, cfg) {
  d <- pool$data
  if (!nrow(d)) return(NULL)
  out <- data.frame(
    cohort_id = d$cohort_id, report_id = d$report_id, result_id = d$result_id,
    n_employed = d$n_employed, n_outcome_observed = d$n_outcome_observed,
    proportion = d$n_employed / d$n_outcome_observed,
    followup_months = d$followup_months,
    outcome_construct = d$outcome_construct,
    design = d$design, country_iso3 = d$country_iso3,
    stringsAsFactors = FALSE
  )
  # Wilson interval rather than Wald: at a proportion near zero, which this
  # data set genuinely contains, Wald intervals run below zero.
  z <- stats::qnorm(1 - (1 - cfg$reporting$interval_prob) / 2)
  n <- out$n_outcome_observed; p <- out$proportion
  den <- 1 + z^2 / n
  centre <- (p + z^2 / (2 * n)) / den
  half <- z * sqrt(p * (1 - p) / n + z^2 / (4 * n^2)) / den
  out$ci_lo <- pmax(0, centre - half)
  out$ci_hi <- pmin(1, centre + half)
  out$sample_status <- cfg$sample_status
  out[order(out$proportion), ]
}
