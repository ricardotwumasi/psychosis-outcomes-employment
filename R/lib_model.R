# =============================================================================
# lib_model.R
#
# Model formulas, priors, and the fitting wrapper.
#
# All moderators are passed to brms as PRE-BUILT NUMERIC COLUMNS, never as R
# factors. With `0 + Intercept` in the formula, model.matrix sees no intercept
# and gives a factor full dummy coding, which over-parameterises the model
# while still producing plausible-looking output. Building the columns here
# also makes the coefficient names deterministic, so set_prior(coef = ...)
# cannot silently fail to match.
# =============================================================================

BACKEND <- "cmdstanr"

# --- design matrix -----------------------------------------------------------

#' Numeric moderator columns, scaled in the fixed clinical units from config.
#'
#' Centring and units come from config, NOT from the data in hand. Recentring
#' on whichever cohorts are in a given fit would silently change what the
#' coefficient means and what its prior implies, so a pilot fit and a full fit
#' would not be comparable.
build_moderator_columns <- function(d, cfg, moderator) {
  m <- cfg$moderators[[moderator]]
  if (is.null(m)) stop("unknown moderator '", moderator, "'", call. = FALSE)

  if (m$kind == "continuous") {
    raw <- d[[moderator]]
    if (is.null(raw)) stop("column '", moderator, "' not present in the data",
                           call. = FALSE)
    x <- if (identical(m$transform, "log2_months_over_12")) {
      log2(pmax(d$followup_months, 1) / m$centre)
    } else {
      (raw - m$centre) / m$unit
    }
    out <- data.frame(x)
    names(out) <- paste0("z_", moderator)
    return(list(data = out, terms = names(out), levels = NULL))
  }

  lv <- sort(unique(stats::na.omit(d[[moderator]])))
  ref <- m$reference
  if (!ref %in% lv) {
    # A reference level absent from the data would silently shift the intercept
    # onto whichever level sorted first.
    stop("reference level '", ref, "' of moderator '", moderator,
         "' does not occur in the data; observed levels: ",
         paste(lv, collapse = ", "), call. = FALSE)
  }
  non_ref <- setdiff(lv, ref)
  out <- as.data.frame(lapply(non_ref, function(l) as.integer(d[[moderator]] == l)))
  names(out) <- paste0("mod_", moderator, "_", non_ref)
  list(data = out, terms = names(out), levels = c(ref, non_ref))
}

#' Whether a moderator has enough cohorts to be reported at all.
#'
#' Cochrane Handbook chapter 10: meta-regression should generally not be
#' considered with fewer than ten studies. A moderator below threshold returns
#' status "not reported" with blank estimates rather than a fragile number.
moderator_reportable <- function(d, cfg, moderator) {
  m <- cfg$moderators[[moderator]]
  r <- cfg$reportability
  if (is.null(d[[moderator]])) {
    return(list(ok = FALSE, status = "not reported",
                reason = "moderator column absent from the extraction"))
  }
  present <- !is.na(d[[moderator]])
  k <- length(unique(d$cohort_id[present]))
  if (m$kind == "continuous") {
    if (k < r$min_cohorts_continuous) {
      return(list(ok = FALSE, status = "not reported", n_cohorts = k,
                  reason = sprintf("%d cohorts, below the minimum of %d", k,
                                   r$min_cohorts_continuous)))
    }
    return(list(ok = TRUE, status = "ok", n_cohorts = k, reason = ""))
  }
  tab <- table(d[[moderator]][present])
  too_small <- names(tab)[tab < r$min_cohorts_per_level]
  if (length(too_small)) {
    return(list(ok = FALSE, status = "not reported", n_cohorts = k,
                reason = sprintf("levels below the minimum of %d per level: %s",
                                 r$min_cohorts_per_level,
                                 paste(too_small, collapse = ", "))))
  }
  list(ok = TRUE, status = "ok", n_cohorts = k, reason = "")
}

# --- formulas ----------------------------------------------------------------

#' Primary prevalence formula.
#'
#' `(1 | cohort_id)` groups on the independent sampling unit, not the
#' publication. The binomial likelihood supplies within-cohort sampling
#' variability exactly, with no continuity correction and no normal
#' approximation to a proportion near a boundary.
#'
#' @param nested add a within-cohort term. Required whenever a cohort
#'   legitimately contributes more than one result, regardless of how many
#'   cohorts do: dependence is a property of the design, not of how many
#'   clusters happen to be available to estimate the component.
prevalence_formula <- function(moderator_terms = character(0), nested = FALSE) {
  rhs <- c("0", "Intercept", moderator_terms, "(1 | cohort_id)")
  if (nested) rhs <- c(rhs, "(1 | cohort_id:result_id)")
  brms::bf(stats::as.formula(paste(
    "n_employed | trials(n_outcome_observed) ~", paste(rhs, collapse = " + ")
  )))
}

#' Intervention formula, preserving the within-study randomised comparison.
#'
#' A study-specific baseline means the treatment coefficient is a within-study
#' contrast. Pooling arm-class means across studies would discard randomisation
#' and is never fitted here.
intervention_formula <- function() {
  brms::bf(n_employed | trials(n_outcome_observed) ~
             0 + Intercept + arm_intervention + (1 | cohort_id))
}

#' Whether the data force the nested form.
needs_nesting <- function(d) {
  any(table(d$cohort_id) > 1L)
}

# --- priors ------------------------------------------------------------------

#' Priors for a prevalence model.
#'
#' The intercept prior is a prior on the pooled PROPORTION: plogis(-1.1) = 0.25
#' with an implied 95 per cent interval of 0.065 to 0.615. normal(0, 10) on a
#' logit is not uninformative for a proportion, it piles mass at 0 and 1.
#'
#' Slope priors are specified on the full nominal contrast and divided by the
#' nominal span, so an arbitrary unit choice cannot implicitly change the
#' regularisation.
prevalence_priors <- function(cfg, moderator = NULL, priors = cfg$priors$primary,
                              nested = FALSE) {
  p <- c(
    brms::set_prior(sprintf("normal(%g, %g)", priors$intercept_mean,
                            priors$intercept_sd),
                    class = "b", coef = "Intercept"),
    brms::set_prior(sprintf("normal(0, %g)", priors$tau_sd),
                    class = "sd", group = "cohort_id")
  )
  if (nested) {
    p <- c(p, brms::set_prior(sprintf("normal(0, %g)", priors$tau_sd),
                              class = "sd", group = "cohort_id:result_id"))
  }
  if (!is.null(moderator)) {
    sc <- moderator_scale(cfg, moderator, priors)
    p <- c(p, brms::set_prior(sprintf("normal(0, %g)", sc$prior_sd), class = "b"))
  }
  p
}

intervention_priors <- function(cfg, priors = cfg$priors$primary) {
  c(
    brms::set_prior(sprintf("normal(%g, %g)", priors$intercept_mean,
                            priors$intercept_sd),
                    class = "b", coef = "Intercept"),
    brms::set_prior(sprintf("normal(0, %g)", priors$treatment_lor_sd),
                    class = "b", coef = "arm_intervention"),
    brms::set_prior(sprintf("normal(0, %g)", priors$tau_sd),
                    class = "sd", group = "cohort_id")
  )
}

# --- fitting -----------------------------------------------------------------

#' Fit a brms model with the adapt_delta escalation ladder.
#'
#' Refits at successively higher adapt_delta while divergences remain, and
#' records how many escalations were needed. The count is reported rather than
#' hidden, because a model that needed 0.999 to sample cleanly is telling you
#' something about its geometry.
#'
#' @param sample_prior "no" for a posterior fit, "only" for a prior predictive.
fit_model <- function(formula, data, priors, cfg, fit_id,
                      sample_prior = "no", cache_dir = NULL) {
  s <- cfg$sampling
  ladder <- unlist(s$adapt_delta_ladder)

  if (!is.null(cache_dir)) {
    cache_file <- file.path(cache_dir, paste0(fit_id, ".rds"))
    if (file.exists(cache_file)) {
      message("  [cache] ", fit_id)
      return(readRDS(cache_file))
    }
  }

  run <- function(adapt_delta) {
    suppressMessages(suppressWarnings(brms::brm(
      formula = formula, data = data, family = stats::binomial(link = "logit"),
      prior = priors, sample_prior = sample_prior,
      chains = s$chains, cores = min(s$chains, parallel::detectCores()),
      warmup = s$iter_warmup, iter = s$iter_warmup + s$iter_sampling,
      control = list(adapt_delta = adapt_delta, max_treedepth = s$max_treedepth),
      seed = fit_seed(cfg, fit_id), backend = BACKEND, refresh = 0, silent = 2
    )))
  }

  n_divergent <- function(f) {
    np <- brms::nuts_params(f)
    sum(np$Value[np$Parameter == "divergent__"])
  }

  fit <- run(ladder[1])
  escalations <- 0L
  for (ad in ladder[-1]) {
    if (n_divergent(fit) == 0) break
    message("  [escalate] ", fit_id, " to adapt_delta = ", ad)
    fit <- run(ad)
    escalations <- escalations + 1L
  }
  attr(fit, "escalations") <- escalations
  attr(fit, "fit_id") <- fit_id

  if (!is.null(cache_dir)) {
    dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
    saveRDS(fit, file.path(cache_dir, paste0(fit_id, ".rds")))
  }
  fit
}

# --- posterior predictive ----------------------------------------------------

#' Posterior predictive check, in both replication forms.
#'
#' With one row per cohort the CONDITIONAL check is close to vacuous, because
#' the cohort effect has by construction absorbed that cohort. The NEW-COHORT
#' form is the informative one and is the one plotted. Both are returned so a
#' reader can see the difference rather than be told about it.
posterior_predictive_check <- function(fit, d, cfg) {
  prob <- cfg$reporting$interval_prob
  a <- (1 - prob) / 2

  yrep_cond <- brms::posterior_predict(fit)
  yrep_new <- brms::posterior_predict(fit, allow_new_levels = TRUE,
                                      sample_new_levels = "gaussian",
                                      newdata = transform(d, cohort_id = paste0("new_", seq_len(nrow(d)))))

  summarise <- function(yrep, form) {
    p_rep <- sweep(yrep, 2, d$n_outcome_observed, "/")
    lo <- apply(p_rep, 2, stats::quantile, a)
    hi <- apply(p_rep, 2, stats::quantile, 1 - a)
    obs <- d$n_employed / d$n_outcome_observed
    data.frame(
      form = form, cohort_id = d$cohort_id, result_id = d$result_id,
      observed = obs, lower = lo, upper = hi,
      inside = obs >= lo & obs <= hi,
      bayes_p = vapply(seq_along(obs), function(i) mean(p_rep[, i] >= obs[i]),
                       numeric(1)),
      stringsAsFactors = FALSE
    )
  }

  per_result <- rbind(summarise(yrep_cond, "conditional"),
                      summarise(yrep_new, "new_cohort"))
  overall <- stats::aggregate(inside ~ form, per_result, mean)
  names(overall)[2] <- "coverage"
  overall$nominal <- prob
  list(per_result = per_result, overall = overall)
}
