# =============================================================================
# lib_summaries.R
#
# Posterior summaries and sampling diagnostics.
#
# Estimation is primary (Dienes 2021). A decision is an additional statement
# about a posterior, never a substitute for reporting it.
#
# Back-transformation is always draw-wise. Transforming a summary is wrong for
# any quantity whose summary is not equivariant under the transformation, and
# the highest-density interval is exactly such a quantity.
# =============================================================================

#' Highest density interval from draws.
hdi <- function(x, prob = 0.95) {
  x <- sort(x[is.finite(x)])
  n <- length(x)
  if (n < 2L) return(c(lower = NA_real_, upper = NA_real_))
  m <- max(1L, floor(n * prob))
  if (m >= n) return(c(lower = x[1], upper = x[n]))
  w <- x[(m + 1L):n] - x[1L:(n - m)]
  i <- which.min(w)
  c(lower = x[i], upper = x[i + m])
}

#' Estimation summary for any posterior quantity. No decision.
#'
#' The median and equal-tailed quantiles are invariant under a monotone
#' transformation, so they may be computed on either scale. The HDI is NOT, so
#' when this is called on back-transformed draws the HDI it returns is the one
#' on that scale, which is the correct one to report.
estimate_summary <- function(draws, prob = 0.95) {
  draws <- draws[is.finite(draws)]
  if (!length(draws)) {
    return(data.frame(median = NA_real_, sd = NA_real_, q_lo = NA_real_,
                      q_hi = NA_real_, hdi_lower = NA_real_, hdi_upper = NA_real_,
                      n_draws = 0L))
  }
  a <- (1 - prob) / 2
  q <- unname(stats::quantile(draws, c(a, 0.5, 1 - a)))
  h <- hdi(draws, prob)
  data.frame(median = q[2], sd = stats::sd(draws), q_lo = q[1], q_hi = q[3],
             hdi_lower = unname(h[["lower"]]), hdi_upper = unname(h[["upper"]]),
             n_draws = length(draws), stringsAsFactors = FALSE)
}

#' Whether a posterior is asymmetric enough for the HDI to add information.
#'
#' The analysis plan reports ONE headline interval. The HDI is reported only
#' where it differs materially from the equal-tailed interval, rather than
#' carrying both everywhere and adding complexity that changes no conclusion.
hdi_adds_information <- function(s, rel_tol = 0.05) {
  if (any(is.na(c(s$q_lo, s$q_hi, s$hdi_lower, s$hdi_upper)))) return(FALSE)
  w_et <- s$q_hi - s$q_lo
  if (!is.finite(w_et) || w_et <= 0) return(FALSE)
  w_hdi <- s$hdi_upper - s$hdi_lower
  abs(w_et - w_hdi) / w_et > rel_tol
}

#' Summaries of the pooled proportion, its heterogeneity and a new cohort.
#'
#' @param dr a draws data frame from posterior::as_draws_df().
#' @param intercept name of the intercept column.
#' @param sd_par name of the between-cohort SD column.
#'
#' The new-cohort quantity is the LATENT TRUE proportion in a new exchangeable
#' cohort. It is not the predictive distribution of an observed count, which
#' would additionally carry binomial sampling variability, and it is labelled
#' as such wherever it is reported.
prevalence_summaries <- function(dr, cfg, intercept = "b_Intercept",
                                 sd_par = "sd_cohort_id__Intercept") {
  prob <- cfg$reporting$interval_prob
  stopifnot(intercept %in% names(dr))
  mu <- dr[[intercept]]
  tau <- if (sd_par %in% names(dr)) dr[[sd_par]] else rep(0, length(mu))

  p_pool <- stats::plogis(mu)
  p_new <- stats::plogis(mu + stats::rnorm(length(mu), 0, tau))
  z <- stats::qnorm(1 - (1 - prob) / 2)

  out <- rbind(
    cbind(quantity = "pooled_proportion", scale = "proportion",
          estimate_summary(p_pool, prob)),
    cbind(quantity = "pooled_logit", scale = "logit",
          estimate_summary(mu, prob)),
    cbind(quantity = "between_cohort_sd", scale = "logit",
          estimate_summary(tau, prob)),
    cbind(quantity = "new_cohort_true_proportion", scale = "proportion",
          estimate_summary(p_new, prob)),
    cbind(quantity = "true_proportion_range_lower", scale = "proportion",
          estimate_summary(stats::plogis(mu - z * tau), prob)),
    cbind(quantity = "true_proportion_range_upper", scale = "proportion",
          estimate_summary(stats::plogis(mu + z * tau), prob))
  )
  out$report_hdi <- vapply(seq_len(nrow(out)),
                           function(i) hdi_adds_information(out[i, ]), logical(1))
  if (!isTRUE(cfg$reporting$hdi_when_asymmetric)) out$report_hdi <- FALSE
  out$sample_status <- cfg$sample_status
  rownames(out) <- NULL
  out
}

#' Directional probabilities, reported only where a threshold is justified.
#'
#' `reporting.directional_thresholds` is empty unless an external clinical or
#' policy rationale has been written into the analysis plan. A threshold
#' invented to produce a categorical answer is not reported.
directional_probabilities <- function(dr, cfg, intercept = "b_Intercept") {
  th <- cfg$reporting$directional_thresholds
  if (!length(th)) {
    return(data.frame(threshold = numeric(0), p_below = numeric(0),
                      stringsAsFactors = FALSE))
  }
  p_pool <- stats::plogis(dr[[intercept]])
  data.frame(threshold = unlist(th),
             p_below = vapply(unlist(th), function(t) mean(p_pool < t), numeric(1)),
             stringsAsFactors = FALSE)
}

#' Robustness region for a slope.
#'
#' Rather than handing the reader one manufactured threshold, this reports the
#' range of smallest effect sizes of interest over which the verdict is
#' unchanged, so they can see what threshold would be needed to flip it.
robustness_region <- function(draws, cfg) {
  g <- cfg$reporting$slope_sesoi_grid
  grid <- seq(g$from, g$to, by = g$by)
  verdict <- vapply(grid, function(s) {
    p_in <- mean(draws > -s & draws < s)
    if (p_in > 0.95) "negligible" else if (mean(abs(draws) > s) > 0.95) "exceeds" else "undecided"
  }, character(1))
  data.frame(sesoi = grid, verdict = verdict, stringsAsFactors = FALSE)
}

# --- sampling diagnostics ----------------------------------------------------

#' One row of sampling diagnostics for a fitted brms model.
#'
#' Covers every parameter the conclusions rest on, not a hand-picked few: the
#' worst R-hat and worst ESS across all variables are reported together with
#' the variable responsible, so a badly behaved coefficient cannot hide behind
#' a well behaved intercept.
fit_diagnostics <- function(fit, fit_id) {
  dr <- posterior::as_draws_df(fit)
  vars <- setdiff(names(dr), c(".chain", ".iteration", ".draw"))
  vars <- vars[vapply(dr[vars], function(x) is.numeric(x) && stats::var(x) > 0, logical(1))]

  s <- posterior::summarise_draws(
    posterior::subset_draws(posterior::as_draws(fit), variable = vars),
    "rhat", "ess_bulk", "ess_tail", "mcse_mean"
  )

  np <- brms::nuts_params(fit)
  getnp <- function(what) {
    v <- np$Value[np$Parameter == what]
    if (!length(v)) NA_real_ else v
  }
  div <- getnp("divergent__")
  td <- getnp("treedepth__")
  energy <- getnp("energy__")
  max_td <- tryCatch(fit$fit@stan_args[[1]]$control$max_treedepth, error = function(e) NULL)
  if (is.null(max_td)) max_td <- 10L

  ebfmi <- tryCatch({
    ch <- np$Chain[np$Parameter == "energy__"]
    vapply(split(energy, ch), function(e) {
      if (length(e) < 2L) return(NA_real_)
      sum(diff(e)^2) / length(e) / stats::var(e)
    }, numeric(1))
  }, error = function(e) NA_real_)

  data.frame(
    fit_id = fit_id,
    n_variables_audited = length(vars),
    max_rhat = max(s$rhat, na.rm = TRUE),
    worst_rhat_variable = s$variable[which.max(s$rhat)],
    min_ess_bulk = min(s$ess_bulk, na.rm = TRUE),
    worst_ess_bulk_variable = s$variable[which.min(s$ess_bulk)],
    min_ess_tail = min(s$ess_tail, na.rm = TRUE),
    max_mcse_mean = max(s$mcse_mean, na.rm = TRUE),
    num_divergent = if (all(is.na(div))) NA_integer_ else as.integer(sum(div)),
    num_max_treedepth = if (all(is.na(td))) NA_integer_ else as.integer(sum(td >= max_td)),
    min_ebfmi = if (all(is.na(ebfmi))) NA_real_ else min(ebfmi, na.rm = TRUE),
    stringsAsFactors = FALSE
  )
}

#' The diagnostics gate. A conjunction: no criterion is decorative.
diagnostics_pass <- function(d, cfg) {
  g <- cfg$diagnostics
  ok <- d$max_rhat < g$max_rhat &
    d$min_ess_bulk > g$min_ess_bulk &
    d$min_ess_tail > g$min_ess_tail &
    d$num_divergent <= g$max_divergent &
    d$num_max_treedepth <= g$max_treedepth_hits &
    d$min_ebfmi > g$min_ebfmi
  # An NA diagnostic is a failure, not a pass. A quantity that could not be
  # computed is not evidence that it was acceptable.
  ok & !is.na(ok)
}

#' Human-readable reason a diagnostics row failed, for the runner's summary.
#'
#' Named in the same order as diagnostics_pass(), so a failure message and the
#' gate can never disagree about which criterion was violated.
diagnostics_failure_reason <- function(d, cfg) {
  g <- cfg$diagnostics
  failed <- c(
    if (!isTRUE(d$max_rhat < g$max_rhat))
      sprintf("max_rhat %.4f not < %.2f (%s)", d$max_rhat, g$max_rhat,
              d$worst_rhat_variable),
    if (!isTRUE(d$min_ess_bulk > g$min_ess_bulk))
      sprintf("min_ess_bulk %.0f not > %d (%s)", d$min_ess_bulk, g$min_ess_bulk,
              d$worst_ess_bulk_variable),
    if (!isTRUE(d$min_ess_tail > g$min_ess_tail))
      sprintf("min_ess_tail %.0f not > %d", d$min_ess_tail, g$min_ess_tail),
    if (!isTRUE(d$num_divergent <= g$max_divergent))
      sprintf("%d divergent transitions", d$num_divergent),
    if (!isTRUE(d$num_max_treedepth <= g$max_treedepth_hits))
      sprintf("%d max-treedepth hits", d$num_max_treedepth),
    if (!isTRUE(d$min_ebfmi > g$min_ebfmi))
      sprintf("min_ebfmi %.3f not > %.2f", d$min_ebfmi, g$min_ebfmi)
  )
  if (!length(failed)) "" else paste(failed, collapse = "; ")
}
