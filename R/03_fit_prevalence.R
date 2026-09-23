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

#' Which D11.3 route a pool takes, counted in DISTINCT COHORTS.
#'
#' Rows are the wrong unit: two results from one cohort are one cohort's worth
#' of evidence, and a random-effects model over one cohort estimates nothing
#' about between-cohort variation however many rows it is given. The previous
#' check counted rows, so one cohort with two rows was sent to the model.
#'
#'   0 cohorts                      no estimate
#'   1 cohort                       exact binomial interval, labelled as one
#'                                  cohort's observed proportion
#'   >= min_cohorts_for_model       the model; below small_k_threshold it is
#'                                  flagged small_k and prior sensitivity is
#'                                  required alongside it
#'
#' A count between 2 and min_cohorts_for_model (possible only if the minimum is
#' ever raised above 2) is no estimate, since no rule admits it to either route.
d11_3_route <- function(d, cfg) {
  sp <- cfg$sparse_data
  if (!identical(sp$one_cohort_method, "exact_binomial")) {
    stop("sparse_data.one_cohort_method is '", sp$one_cohort_method,
         "'; only exact_binomial is implemented", call. = FALSE)
  }
  k <- length(unique(d$cohort_id))
  route <- if (k >= sp$min_cohorts_for_model) "model"
           else if (k == 1L) "exact_binomial"
           else "no_estimate"
  small_k <- identical(route, "model") && k < sp$small_k_threshold
  list(route = route, k = k, small_k = small_k,
       prior_sensitivity_required = small_k &&
         isTRUE(sp$small_k_requires_prior_sensitivity))
}

#' One cohort's observed proportion with a Clopper-Pearson interval.
#'
#' This is NOT a meta-analysis and is never labelled as one. If more than one
#' row survives for the single cohort, something upstream has failed to apply
#' pool.one_result_per_cohort, and choosing a row here would be a second,
#' unlogged selection rule; so it stops.
exact_binomial_estimate <- function(d, cfg, horizon) {
  if (nrow(d) != 1L) {
    stop("D11.3 at horizon ", horizon, ": one cohort (", d$cohort_id[1],
         ") but ", nrow(d), " result rows. build_primary_pool should leave one ",
         "result per cohort; refusing to pick a row here.", call. = FALSE)
  }
  bt <- stats::binom.test(d$n_employed, d$n_outcome_observed,
                          conf.level = cfg$reporting$interval_prob)
  list(estimate = d$n_employed / d$n_outcome_observed,
       lo = bt$conf.int[1], hi = bt$conf.int[2])
}

#' Estimate for one pool under D11.3.
#'
#' @param priors a prior settings list with the fields of priors.primary.
#' @param analysis label carried into the fit name, so a grid or sensitivity
#'   fit has its own seed and cache entry.
fit_prevalence <- function(pool, cfg, cache_dir = NULL, horizon = pool$horizon,
                           priors = cfg$priors$primary, analysis = "primary") {
  d <- pool$data
  r <- d11_3_route(d, cfg)
  base <- list(horizon = horizon, analysis = analysis, route = r, data = d)

  if (identical(r$route, "no_estimate")) {
    return(c(base, list(status = "no_estimate",
                        reason = sprintf("%d cohort(s) at horizon %s; D11.3 gives no estimate",
                                         r$k, horizon))))
  }
  if (identical(r$route, "exact_binomial")) {
    return(c(base, list(status = "exact_binomial",
                        exact = exact_binomial_estimate(d, cfg, horizon))))
  }

  nested <- needs_nesting(d)
  fit_id <- paste0("prevalence_", horizon,
                   if (!identical(analysis, "primary")) paste0("_", analysis),
                   if (nested) "_nested" else "")
  pr <- prevalence_priors(cfg, priors = priors, nested = nested)

  fit <- fit_model(
    formula = prevalence_formula(nested = nested),
    data = d, priors = pr,
    cfg = cfg, fit_id = fit_id, cache_dir = cache_dir
  )

  dr <- posterior::as_draws_df(fit)
  summaries <- prevalence_summaries(dr, cfg)
  summaries$horizon <- horizon
  summaries$analysis <- analysis
  summaries$k_cohorts <- r$k
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

  c(base, list(status = "ok", fit = fit, fit_id = fit_id, prior_hash = prior_hash(pr),
               summaries = summaries, diagnostics = diag, ppc = ppc, nested = nested))
}

#' A horizon's label in words, with the follow-up actually observed in a pool.
#'
#' The band label alone misleads at the open-ended band: "10 years or more"
#' printed as "at 10 years" hides that a cohort in it may have been followed for
#' twenty. The observed range of the pooled cohorts is therefore always
#' appended, e.g. "10 years or more (observed 120 to 240 months)".
horizon_label <- function(cfg, horizon, d) {
  lab <- cfg$horizons$bands[[horizon]]$label %||% horizon
  fu <- if (!is.null(d) && "followup_months" %in% names(d))
          stats::na.omit(d$followup_months) else numeric(0)
  if (!length(fu)) return(paste0(lab, " (no cohorts pooled)"))
  r <- range(fu)
  paste0(lab, " (observed ",
         if (r[1] == r[2]) sprintf("%g months", r[1])
         else sprintf("%g to %g months", r[1], r[2]), ")")
}

#' One row of pooled_by_horizon.csv (or sensitivity_by_horizon.csv).
#'
#' Every route gives a row, so a horizon with no estimate is a visible row with
#' a reason rather than an absence. The method column says in words what the
#' number is, because an exact interval for one cohort and a pooled posterior
#' look alike in a table.
pooled_row <- function(res, cfg) {
  na <- NA_real_
  out <- data.frame(
    horizon = res$horizon,
    horizon_label = horizon_label(cfg, res$horizon, res$data),
    analysis = res$analysis,
    k_cohorts = res$route$k, n_results = nrow(res$data),
    method = NA_character_, estimate = na,
    interval_prob = cfg$reporting$interval_prob,
    interval_type = cfg$reporting$primary_interval,
    interval_lo = na, interval_hi = na,
    predictive_new_cohort_lo = na, predictive_new_cohort_hi = na,
    tau_median = na, tau_lo = na, tau_hi = na,
    small_k = res$route$small_k,
    prior_sensitivity_required = res$route$prior_sensitivity_required,
    note = "", sample_status = cfg$sample_status, stringsAsFactors = FALSE)
  if (identical(res$status, "no_estimate")) {
    out$method <- "no estimate"
    out$note <- res$reason
  } else if (identical(res$status, "exact_binomial")) {
    out$method <- "exact binomial (Clopper-Pearson): one cohort's observed proportion, NOT a meta-analysis"
    out$interval_type <- "clopper_pearson"
    out$estimate <- res$exact$estimate
    out$interval_lo <- res$exact$lo; out$interval_hi <- res$exact$hi
    out$note <- "no between-cohort variation is estimable from one cohort"
  } else {
    s <- res$summaries
    p <- s[s$quantity == "pooled_proportion", ]
    nw <- s[s$quantity == "new_cohort_true_proportion", ]
    tu <- s[s$quantity == "between_cohort_sd", ]
    out$method <- "Bayesian binomial-logit random-effects (brms), posterior median"
    out$estimate <- p$median
    out$interval_lo <- p$q_lo; out$interval_hi <- p$q_hi
    out$predictive_new_cohort_lo <- nw$q_lo; out$predictive_new_cohort_hi <- nw$q_hi
    out$tau_median <- tu$median; out$tau_lo <- tu$q_lo; out$tau_hi <- tu$q_hi
    if (res$route$small_k) {
      out$note <- sprintf("small k (%d < %d): tau is largely prior-driven; read with prior_sensitivity.csv",
                          res$route$k, cfg$sparse_data$small_k_threshold)
    }
  }
  out
}

#' Best- and worst-case bounds for outcomes that were never observed.
#'
#' Every alive and eligible participant whose employment was not observed is
#' assumed unemployed (worst) or employed (best). The denominator is
#' n_alive_eligible, the same one prop_unobserved in lib_data.R uses: a death is
#' not a missing outcome, so n_entered would count the dead as unobserved
#' workers. A cohort that does not report n_alive_eligible keeps its observed
#' counts, and the number of cohorts actually bounded is returned so a bound
#' that moved nothing is not read as reassurance.
missing_outcome_bound_data <- function(d, case = c("worst", "best")) {
  case <- match.arg(case)
  den <- suppressWarnings(as.integer(d$n_alive_eligible))
  has <- !is.na(den) & den > 0L
  if (any(den[has] < d$n_outcome_observed[has])) {
    stop("n_alive_eligible is below n_outcome_observed for ",
         paste(d$result_id[has & den < d$n_outcome_observed], collapse = ", "),
         "; the validator should have refused this", call. = FALSE)
  }
  unobs <- ifelse(has, den - d$n_outcome_observed, 0L)
  d$n_employed <- as.integer(d$n_employed + if (case == "best") unobs else 0L)
  d$n_outcome_observed <- as.integer(d$n_outcome_observed + unobs)
  attr(d, "n_cohorts_bounded") <- length(unique(d$cohort_id[unobs > 0L]))
  d
}

#' Per-cohort observed proportions, for the forest plot and for a reader who
#' wants to see the inputs rather than trust the pooled number.
prevalence_study_table <- function(pool, cfg) {
  d <- pool$data
  if (!nrow(d)) return(NULL)
  # One table covers every horizon, so the horizon is a column; without it the
  # t120m attrition trail could not be read against the pool it produced.
  out <- data.frame(
    horizon = pool$horizon,
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

# --- leave one cohort out (POST HOC, deviation D15) --------------------------

LOCO_STATUS <- paste0(
  "POST HOC: prompted by prior-data conflict and posterior predictive misfit ",
  "in the provisional fit of 23 September 2026 (deviation D15); does not ",
  "replace the prespecified primary")

#' Leave each cohort out of a horizon's primary pool in turn.
#'
#' NOT PRESPECIFIED. config/analysis.yml deferred this until k >= 5; it is run
#' here because the provisional fit showed the pooled estimate drawn toward the
#' prior at t12m and one t120m cohort outside its new-cohort interval, and a
#' reader should be able to see how much any one cohort moves the estimate.
#'
#' Each reduced pool goes through fit_prevalence(), so D11.3 routes it exactly
#' as it would any pool: two or more cohorts remaining is the model, one is that
#' cohort's exact binomial interval. At k = 2 that means NO refit: the two rows
#' are the two cohorts' own exact intervals, which are what a reader should see
#' before any pooled number from two cohorts. Every model fit is named
#' loco_<cohort>, so it has its own seed, its own cache entry and its own
#' diagnostics row.
#'
#' The predictive check asks, of each left-out cohort, how surprising its
#' observed count is under the fit that never saw it: the new-cohort posterior
#' predictive at its own denominator, summarised by ppc_p_two_sided(). Unlike the
#' in-sample checks, the cohort cannot have been absorbed by its own effect.
#'
#' @return list(rows, fits, ppc): rows for leave_one_cohort_out.csv, the model
#'   fits for the diagnostics gate, and rows for ppc_loco.csv (NULL where no
#'   model was fitted).
leave_one_cohort_out <- function(hp, cfg, cache_dir = NULL, horizon = hp$horizon) {
  d <- hp$data
  cohorts <- sort(unique(d$cohort_id))
  if (length(cohorts) < 2L) return(NULL)
  rows <- list(); fits <- list(); ppc <- list()
  for (cid in cohorts) {
    held <- d[d$cohort_id == cid, , drop = FALSE]
    fr <- fit_prevalence(list(data = d[d$cohort_id != cid, , drop = FALSE],
                              horizon = horizon),
                         cfg, cache_dir, horizon = horizon,
                         analysis = paste0("loco_", gsub("[^A-Za-z0-9]+", "_", cid)))
    pr <- pooled_row(fr, cfg)
    rows[[cid]] <- data.frame(
      horizon = horizon, horizon_label = pr$horizon_label,
      dropped_cohort_id = cid, k_remaining = fr$route$k, method = pr$method,
      estimate = pr$estimate, interval_type = pr$interval_type,
      interval_lo = pr$interval_lo, interval_hi = pr$interval_hi,
      predictive_new_cohort_lo = pr$predictive_new_cohort_lo,
      predictive_new_cohort_hi = pr$predictive_new_cohort_hi,
      tau_median = pr$tau_median, tau_lo = pr$tau_lo, tau_hi = pr$tau_hi,
      fit_id = fr$fit_id %||% NA_character_,
      note = if (identical(fr$status, "exact_binomial"))
               sprintf("k = %d: the remaining cohort's own exact interval, not a refit", length(cohorts))
             else pr$note,
      analysis_status = LOCO_STATUS, stringsAsFactors = FALSE)
    if (!identical(fr$status, "ok")) next
    fits[[cid]] <- fr
    yrep <- brms::posterior_predict(
      fr$fit, newdata = transform(held, cohort_id = paste0("loco_new_", seq_len(nrow(held)))),
      allow_new_levels = TRUE, sample_new_levels = "gaussian")
    a <- (1 - cfg$reporting$interval_prob) / 2
    ppc[[cid]] <- data.frame(
      horizon = horizon, dropped_cohort_id = cid, result_id = held$result_id,
      fit_id = fr$fit_id, n_employed = held$n_employed,
      n_outcome_observed = held$n_outcome_observed,
      observed = held$n_employed / held$n_outcome_observed,
      predictive_lo = apply(yrep, 2, stats::quantile, a) / held$n_outcome_observed,
      predictive_hi = apply(yrep, 2, stats::quantile, 1 - a) / held$n_outcome_observed,
      ppc_p_two_sided = vapply(seq_len(nrow(held)), function(i)
        ppc_p_two_sided(yrep[, i], held$n_employed[i]), numeric(1)),
      form = "new_cohort, fitted without this cohort",
      analysis_status = LOCO_STATUS, stringsAsFactors = FALSE)
  }
  bind <- function(x) if (length(x)) do.call(rbind, x) else NULL
  list(rows = bind(rows), fits = fits, ppc = bind(ppc))
}
