#!/usr/bin/env Rscript
# =============================================================================
# 02_prior_predictive.R
#
# Runs the model with sample_prior = "only" BEFORE any posterior exists, and
# checks it against the criteria prespecified in config/analysis.yml.
#
# The requirement is COVERAGE, not agreement: a proportion has no null of zero,
# so a directional criterion would be meaningless. A criterion chosen after
# seeing the prior predictive is unfalsifiable, which is why these live in a
# config file that is hashed into the analysis identifier.
#
# Prior predictive draws are NOT put through the posterior convergence gates.
# There is no posterior to converge to, and applying R-hat thresholds designed
# for a posterior would flag a healthy prior sample as a failure.
# =============================================================================

prior_predictive_check <- function(d, cfg, cache_dir = NULL) {
  pp <- cfg$prior_predictive

  # Include small denominators and a zero-event-prone case alongside the real
  # ones, so the priors are shown to behave where the data are thinnest rather
  # than only where they are comfortable.
  d_check <- d
  extra <- unlist(pp$extra_denominators)
  if (length(extra)) {
    synth <- d[rep(1L, length(extra)), , drop = FALSE]
    synth$n_outcome_observed <- as.integer(extra)
    synth$n_employed <- 0L
    synth$cohort_id <- paste0("synthetic_", extra)
    synth$result_id <- paste0("synthetic_", extra)
    d_check <- rbind(d, synth)
  }

  fit <- fit_model(
    formula = prevalence_formula(nested = FALSE),
    data = d_check,
    priors = prevalence_priors(cfg),
    cfg = cfg, fit_id = "prior_predictive", sample_prior = "only",
    cache_dir = cache_dir
  )

  dr <- posterior::as_draws_df(fit)
  mu <- dr$b_Intercept
  tau <- dr$sd_cohort_id__Intercept
  p_pool <- stats::plogis(mu)
  p_new <- stats::plogis(mu + stats::rnorm(length(mu), 0, tau))

  yrep <- brms::posterior_predict(fit)
  p_rep <- sweep(yrep, 2, d_check$n_outcome_observed, "/")

  a <- (1 - pp$anchor_interval_prob) / 2
  ci <- stats::quantile(p_pool, c(a, 1 - a))

  checks <- list()
  for (anch in unlist(pp$anchors_p)) {
    checks[[length(checks) + 1L]] <- data.frame(
      criterion = sprintf("anchor %.3f inside the central %.0f%% prior interval",
                          anch, 100 * pp$anchor_interval_prob),
      value = anch,
      bound = sprintf("[%.3f, %.3f]", ci[1], ci[2]),
      pass = anch >= ci[1] && anch <= ci[2], stringsAsFactors = FALSE)
  }

  nci <- unlist(pp$new_cohort_interval)
  mass <- mean(p_new >= nci[1] & p_new <= nci[2])
  checks[[length(checks) + 1L]] <- data.frame(
    criterion = sprintf("at least %.0f%% of new-cohort prior mass in [%.2f, %.2f]",
                        100 * pp$new_cohort_min_mass, nci[1], nci[2]),
    value = mass, bound = as.character(pp$new_cohort_min_mass),
    pass = mass >= pp$new_cohort_min_mass, stringsAsFactors = FALSE)

  med <- stats::median(p_rep)
  mr <- unlist(pp$obs_median_range)
  checks[[length(checks) + 1L]] <- data.frame(
    criterion = sprintf("median simulated observed proportion in [%.2f, %.2f]",
                        mr[1], mr[2]),
    value = med, bound = sprintf("[%.2f, %.2f]", mr[1], mr[2]),
    pass = med >= mr[1] && med <= mr[2], stringsAsFactors = FALSE)

  above <- mean(p_rep > pp$obs_max_mass_above$threshold)
  checks[[length(checks) + 1L]] <- data.frame(
    criterion = sprintf("at most %.0f%% of simulated mass above %.2f",
                        100 * pp$obs_max_mass_above$max_mass,
                        pp$obs_max_mass_above$threshold),
    value = above, bound = as.character(pp$obs_max_mass_above$max_mass),
    pass = above <= pp$obs_max_mass_above$max_mass, stringsAsFactors = FALSE)

  tab <- do.call(rbind, checks)
  tab$sample_status <- cfg$sample_status

  list(table = tab, verdict = all(tab$pass), fit = fit,
       implied = data.frame(
         quantity = c("pooled_proportion_prior_median",
                      "pooled_proportion_prior_lo",
                      "pooled_proportion_prior_hi",
                      "tau_prior_median"),
         value = c(stats::median(p_pool), ci[1], ci[2], stats::median(tau)),
         stringsAsFactors = FALSE))
}
