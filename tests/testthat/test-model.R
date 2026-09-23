# Tests for the fit guard, D11.3, the exact interval, priors and the fit cache.
#
# As in test-data.R, each name states the consequence of the rule being wrong.
# Nothing here reads the real extraction. The one test that samples does so on
# the synthetic extraction with a handful of iterations.

source(file.path(PROJ, "R", "lib_model.R"))
source(file.path(PROJ, "R", "lib_synthetic.R"))
source(file.path(PROJ, "R", "03_fit_prevalence.R"))

cfg <- test_cfg()
full_cfg <- within(cfg, sample_status <- "full")
no_mode <- c(ENGINEERING_FIT = "", PROVISIONAL_FIT = "", DEFINITIVE_RUN = "",
             SYNTHETIC_DATA = "")
env_with <- function(...) { e <- no_mode; v <- c(...); e[names(v)] <- v; e }

# --- the guard ---------------------------------------------------------------

test_that("a definitive fit is refused while sample_status is not full, because a pooled number from an unfinished extraction would be read as the result", {
  expect_error(assert_may_fit(cfg, "definitive", worktree = "clean", tags = "v1"),
               "sample_status")
})

test_that("a definitive fit is refused from a dirty worktree, because its inputs could not be reproduced from the commit it names", {
  expect_error(assert_may_fit(full_cfg, "definitive", worktree = "dirty", tags = "v1"),
               "worktree is 'dirty'")
})

test_that("a definitive fit is refused with no tag at HEAD, because a result must name something a reader can check out", {
  expect_error(assert_may_fit(full_cfg, "definitive", worktree = "clean",
                              tags = character(0)), "no git tag")
})

test_that("a definitive fit with every gate satisfied is allowed and records its tag, so the refusals above are the gates and not a guard that refuses everything", {
  g <- assert_may_fit(full_cfg, "definitive", worktree = "clean", tags = "v1.0")
  expect_equal(g$tag, "v1.0")
})

test_that("a provisional fit is refused on a dirty tree, because a pre-freeze number that cannot be regenerated is worse than none", {
  expect_error(assert_may_fit(cfg, "provisional", worktree = "dirty", tags = "pre1"),
               "REFUSING A PROVISIONAL FIT")
  expect_error(assert_may_fit(cfg, "provisional", worktree = "clean",
                              tags = character(0)), "no git tag")
})

test_that("a provisional fit does not require sample_status full, because its purpose is to run before the freeze, and it is stamped as such", {
  g <- assert_may_fit(cfg, "provisional", worktree = "clean", tags = "pre1")
  expect_equal(g$tag, "pre1")
  expect_equal(stamp_result_status(data.frame(x = 1), "provisional")$result_status,
               "PROVISIONAL, PRE-FREEZE - NOT FOR CITATION")
})

test_that("a design-only run refuses to sample, because no mode variable means nobody has decided to fit", {
  expect_error(assert_may_fit(full_cfg, "design_only", worktree = "clean", tags = "v1"),
               "REFUSING TO SAMPLE")
})

test_that("two mode variables set at once are refused, because letting one silently win turned a stale ENGINEERING_FIT into an ungated definitive run", {
  expect_error(resolve_fit_mode(env_with(
    ENGINEERING_FIT = "i-understand-this-is-not-a-result", DEFINITIVE_RUN = "yes",
    SYNTHETIC_DATA = "1")), "More than one mode")
  expect_error(resolve_fit_mode(env_with(PROVISIONAL_FIT = "pre-freeze",
                                         DEFINITIVE_RUN = "yes")), "More than one mode")
  expect_equal(resolve_fit_mode(no_mode)$mode, "design_only")
  expect_equal(resolve_fit_mode(env_with(PROVISIONAL_FIT = "pre-freeze"))$mode,
               "provisional")
})

test_that("a mistyped mode value is refused rather than treated as unset, because falling back quietly is the silent win in another form", {
  expect_error(resolve_fit_mode(env_with(PROVISIONAL_FIT = "yes")), "accepted value")
})

test_that("synthetic data is refused outside engineering and engineering is refused without it, so generated numbers never carry a real stamp and an ungated fit never sees real outcomes", {
  expect_error(resolve_fit_mode(env_with(PROVISIONAL_FIT = "pre-freeze",
                                         SYNTHETIC_DATA = "1")), "engineering mode only")
  expect_error(resolve_fit_mode(env_with(
    ENGINEERING_FIT = "i-understand-this-is-not-a-result")), "SYNTHETIC_DATA=1")
  expect_true(resolve_fit_mode(env_with(
    ENGINEERING_FIT = "i-understand-this-is-not-a-result",
    SYNTHETIC_DATA = "1"))$synthetic)
})

test_that("a git failure is never reported as a clean worktree, because a broken git would otherwise pass the reproducibility gate", {
  not_a_repo <- tempfile("norepo"); dir.create(not_a_repo)
  expect_false(identical(worktree_status(list(.root = not_a_repo)), "clean"))
  expect_true(is.na(head_tags(list(.root = not_a_repo))))
})

# --- D11.3 -------------------------------------------------------------------

test_that("D11.3 counts cohorts and not rows, so two results from one cohort take the exact binomial path and never reach a random-effects model", {
  d <- data.frame(cohort_id = c("c1", "c1"), result_id = c("r1", "r2"),
                  n_employed = c(10L, 12L), n_outcome_observed = c(50L, 55L))
  r <- d11_3_route(d, cfg)
  expect_equal(r$k, 1L)
  expect_equal(r$route, "exact_binomial")
  # and with two rows still present it refuses to pick one itself
  expect_error(exact_binomial_estimate(d, cfg, "t12m"), "refusing to pick")
})

test_that("the pool leaves one row for a cohort reported twice, so the one-cohort path gets its single result and fits nothing", {
  d <- fixture()
  d$outcomes$ascertainment[1] <- "any_time_during_followup"  # remove coh_a
  d <- derive_columns(d, cfg)
  pool <- build_primary_pool(d, cfg)
  expect_equal(nrow(pool$data), 1L)
  res <- fit_prevalence(pool, cfg)
  expect_equal(res$status, "exact_binomial")
  row <- pooled_row(res, cfg)
  expect_match(row$method, "NOT a meta-analysis")
  expect_true(is.na(row$tau_median))
})

test_that("zero cohorts give a visible no-estimate row, not an absent one", {
  pool <- list(data = fixture()$outcomes[0, ], horizon = "t120m")
  res <- fit_prevalence(pool, cfg)
  expect_equal(res$status, "no_estimate")
  expect_equal(pooled_row(res, cfg)$method, "no estimate")
})

test_that("two cohorts reach the model and are flagged small k with prior sensitivity required, because tau from two cohorts is mostly prior", {
  d <- data.frame(cohort_id = c("c1", "c2"), n_employed = 1:2, n_outcome_observed = 10L)
  r <- d11_3_route(d, cfg)
  expect_equal(r$route, "model")
  expect_true(r$small_k)
  expect_true(r$prior_sensitivity_required)
})

test_that("the one-cohort interval is exactly binom.test's Clopper-Pearson interval at the configured level, so a reader can reproduce it with one line", {
  d <- data.frame(cohort_id = "c1", result_id = "r1", n_employed = 7L,
                  n_outcome_observed = 43L)
  e <- exact_binomial_estimate(d, cfg, "t60m")
  bt <- stats::binom.test(7, 43, conf.level = cfg$reporting$interval_prob)
  expect_identical(c(e$lo, e$hi), as.numeric(bt$conf.int))
  expect_equal(e$estimate, 7 / 43)
})

# --- priors and cache --------------------------------------------------------

test_that("the model brms builds carries the configured primary priors, because a prior that fails to attach falls back to a brms default without any error", {
  d <- data.frame(cohort_id = c("c1", "c2", "c3"), result_id = c("r1", "r2", "r3"),
                  n_employed = c(10L, 20L, 15L), n_outcome_observed = c(50L, 60L, 55L))
  m <- suppressMessages(brms::brm(prevalence_formula(), data = d,
                                  family = stats::binomial(), prior = prevalence_priors(cfg),
                                  backend = "cmdstanr", empty = TRUE))
  ps <- brms::prior_summary(m)
  p <- cfg$priors$primary
  b <- ps$prior[ps$class == "b" & ps$coef == "Intercept"]
  sd_ <- ps$prior[ps$class == "sd" & ps$group == "cohort_id" & ps$coef == ""]
  expect_equal(b, sprintf("normal(%g, %g)", p$intercept_mean, p$intercept_sd))
  expect_equal(sd_, sprintf("normal(0, %g)", p$tau_sd))
})

test_that("the fit cache key changes when the priors change, so a grid fit can never be served the primary posterior from cache", {
  k_primary <- fit_cache_key("prevalence_t12m", prevalence_priors(cfg))
  k_weak <- fit_cache_key("prevalence_t12m",
                          prevalence_priors(cfg, priors = cfg$priors$weak))
  expect_false(identical(k_primary, k_weak))
  expect_identical(k_primary, fit_cache_key("prevalence_t12m", prevalence_priors(cfg)))
})

test_that("the prior grid varies one hyperparameter at a time and omits beta_full_sd, so a moved estimate is attributable and no identical model is reported as a sensitivity", {
  g <- prior_grid_settings(cfg)
  base <- cfg$priors$primary
  for (nm in setdiff(names(g), c("primary", "weak"))) {
    changed <- names(base)[!mapply(identical, g[[nm]][names(base)], base)]
    expect_length(changed, 1L)
    expect_false(identical(changed, "beta_full_sd"))
  }
  expect_true(all(c("primary", "weak") %in% names(g)))
})

test_that("worst- and best-case bounds bracket the observed proportion and leave a cohort without n_alive_eligible untouched, so a bound cannot invent attrition", {
  d <- data.frame(cohort_id = c("c1", "c2"), result_id = c("r1", "r2"),
                  n_employed = c(20L, 30L), n_outcome_observed = c(80L, 100L),
                  n_alive_eligible = c(100L, NA))
  w <- missing_outcome_bound_data(d, "worst")
  b <- missing_outcome_bound_data(d, "best")
  expect_equal(w$n_employed[1] / w$n_outcome_observed[1], 20 / 100)
  expect_equal(b$n_employed[1] / b$n_outcome_observed[1], 40 / 100)
  expect_equal(w[2, c("n_employed", "n_outcome_observed")],
               d[2, c("n_employed", "n_outcome_observed")], ignore_attr = TRUE)
  expect_equal(attr(w, "n_cohorts_bounded"), 1L)
})

# --- one real fit ------------------------------------------------------------

test_that("a two-cohort synthetic fit runs end to end, uses the configured priors, and counts treedepth hits against the limit it was sampled with", {
  skip_if(nzchar(Sys.getenv("SKIP_SLOW_TESTS")), "SKIP_SLOW_TESTS is set")
  skip_if_not(requireNamespace("cmdstanr", quietly = TRUE), "cmdstanr unavailable")
  c2 <- cfg
  c2$sampling$chains <- 2L; c2$sampling$iter_warmup <- 300L
  c2$sampling$iter_sampling <- 300L; c2$sampling$max_treedepth <- 9L
  dat <- derive_columns(synthetic_extraction(c2), c2)
  pool <- build_primary_pool(dat, c2, horizon = "t24m")
  expect_equal(length(unique(pool$data$cohort_id)), 2L)
  res <- fit_prevalence(pool, c2)
  expect_equal(res$status, "ok")
  expect_true(res$route$small_k)
  ps <- brms::prior_summary(res$fit)
  expect_equal(ps$prior[ps$class == "b" & ps$coef == "Intercept"],
               sprintf("normal(%g, %g)", c2$priors$primary$intercept_mean,
                       c2$priors$primary$intercept_sd))
  # not the old hard-coded 10
  expect_equal(res$diagnostics$max_treedepth, 9L)
  row <- pooled_row(res, c2)
  expect_true(row$interval_lo < row$estimate && row$estimate < row$interval_hi)
  expect_true(row$predictive_new_cohort_hi - row$predictive_new_cohort_lo >
                row$interval_hi - row$interval_lo)
})
