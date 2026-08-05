#!/usr/bin/env Rscript
# =============================================================================
# 06_frequentist_compare.R
#
# An exact-likelihood frequentist fit alongside the Bayesian one.
#
# This is a DIAGNOSTIC, not a gate. Different likelihood approximations and
# different priors can legitimately give different pooled estimates and
# different heterogeneity estimates, and there is no theorem requiring the
# Bayesian between-cohort SD to exceed the frequentist one. No agreement
# tolerance is imposed on real data and no run fails on a discrepancy.
#
# The `model` argument is deliberately NOT passed to rma.glmm. It is not
# relevant for measure PLO, warns as such, and returns identical estimates for
# UM.FS and UM.RS. Random versus equal effects is controlled by `method`.
# =============================================================================

frequentist_compare <- function(d, bayes_summaries, cfg) {
  fq <- cfg$frequentist
  out <- list()

  exact <- tryCatch(
    metafor::rma.glmm(measure = fq$measure, xi = d$n_employed,
                      ni = d$n_outcome_observed, method = fq$method),
    error = function(e) structure(list(err = conditionMessage(e)), class = "failed")
  )

  approx_es <- tryCatch(
    metafor::escalc(measure = fq$measure, xi = d$n_employed,
                    ni = d$n_outcome_observed, add = 0.5, to = "only0"),
    error = function(e) NULL
  )
  approx <- if (is.null(approx_es)) structure(list(err = "escalc failed"), class = "failed") else
    tryCatch(metafor::rma(yi, vi, data = approx_es,
                          method = fq$approximate_secondary$method,
                          test = fq$approximate_secondary$test),
             error = function(e) structure(list(err = conditionMessage(e)),
                                           class = "failed"))

  # Any cohort receiving the continuity correction is flagged. The Bayesian
  # model needs none, so this is a known and visible source of divergence
  # rather than an unexplained one.
  n_corrected <- sum(d$n_employed == 0 | d$n_employed == d$n_outcome_observed)

  row <- function(label, m) {
    if (inherits(m, "failed")) {
      return(data.frame(model = label, pooled_proportion = NA_real_,
                        ci_lo = NA_real_, ci_hi = NA_real_, tau_logit = NA_real_,
                        i2 = NA_real_, k = NA_integer_, note = m$err,
                        stringsAsFactors = FALSE))
    }
    pr <- tryCatch(stats::predict(m, transf = metafor::transf.ilogit),
                   error = function(e) NULL)
    data.frame(
      model = label,
      pooled_proportion = if (is.null(pr)) stats::plogis(as.numeric(m$b)) else pr$pred,
      ci_lo = if (is.null(pr)) NA_real_ else pr$ci.lb,
      ci_hi = if (is.null(pr)) NA_real_ else pr$ci.ub,
      tau_logit = sqrt(m$tau2 %||% NA_real_),
      i2 = m$I2 %||% NA_real_,
      k = m$k, note = "", stringsAsFactors = FALSE)
  }

  tab <- rbind(
    row("rma.glmm exact binomial-normal (comparator to the Bayesian model)", exact),
    row("rma on logit-transformed proportions (approximate secondary)", approx)
  )

  bp <- bayes_summaries[bayes_summaries$quantity == "pooled_proportion", ]
  bt <- bayes_summaries[bayes_summaries$quantity == "between_cohort_sd", ]
  tab <- rbind(data.frame(
    model = "brms binomial-logit (primary)",
    pooled_proportion = bp$median, ci_lo = bp$q_lo, ci_hi = bp$q_hi,
    tau_logit = bt$median, i2 = NA_real_, k = bp$n_draws * 0L + NA_integer_,
    note = "", stringsAsFactors = FALSE), tab)

  tab$n_cohorts_continuity_corrected <- n_corrected
  tab$comparison_is_a_gate <- FALSE
  tab$sample_status <- cfg$sample_status

  # Differences are DESCRIBED, not judged. A large gap is a prompt to
  # investigate data, likelihood, priors, convergence and zero-event handling.
  ex <- tab[tab$model == names(which.max(table(tab$model))) , ]
  diff_tab <- data.frame(
    quantity = c("pooled_proportion", "tau_logit"),
    brms = c(tab$pooled_proportion[1], tab$tau_logit[1]),
    rma_glmm = c(tab$pooled_proportion[2], tab$tau_logit[2]),
    stringsAsFactors = FALSE
  )
  diff_tab$absolute_difference <- abs(diff_tab$brms - diff_tab$rma_glmm)
  diff_tab$interpretation <- "descriptive only; not a pass/fail criterion"
  diff_tab$sample_status <- cfg$sample_status

  list(table = tab, differences = diff_tab)
}
