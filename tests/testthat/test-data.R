# Tests encode WHY a rule exists, not just that the code does something.
# Each name states the consequence of the rule being wrong.

cfg <- test_cfg()

test_that("a numerator above its denominator is rejected, because a proportion above one is an impossible outcome and not a formatting question", {
  d <- fixture()
  d$outcomes$n_employed[1] <- 150L  # denominator is 100
  expect_error(validate_extraction(d, cfg), "n_employed")
})

test_that("denominators must nest, because observed cannot exceed assessed and a violation means two different populations have been mixed", {
  d <- fixture()
  d$outcomes$n_outcome_observed[1] <- 200L  # assessed is 105
  expect_error(validate_extraction(d, cfg), "n_outcome_observed")
})

test_that("a value outside a controlled vocabulary stops the run rather than being coerced to NA, because a silently dropped value is indistinguishable from a value the paper never reported", {
  d <- fixture()
  d$cohorts$setting[1] <- "Community"  # correct level is community_smh, lower case
  err <- expect_error(validate_extraction(d, cfg))
  msg <- conditionMessage(err)
  expect_match(msg, "setting")            # names the column
  expect_match(msg, "row 1")              # names the row
  expect_match(msg, "community_smh")      # names the permitted values
})

test_that("a result whose employment was ascertained at any point during follow-up never enters the primary pool, because period and point prevalence are different estimands and pooling them inflates the estimate", {
  d <- fixture()
  d$outcomes$ascertainment[1] <- "any_time_during_followup"
  d <- derive_columns(d, cfg)
  pool <- build_primary_pool(d, cfg)
  expect_false("alpha2020_cohort_t12m_paidany" %in% pool$data$result_id)
  # and the exclusion is COUNTED, not silent
  expect_true(any(pool$log$clause == "point prevalence" & pool$log$removed > 0))
})

test_that("employment combined with education never enters the primary pool, because that composite tracks a country's education system rather than its labour market", {
  d <- fixture()
  d$outcomes$outcome_construct[1] <- "paid_or_education"
  d <- derive_columns(d, cfg)
  pool <- build_primary_pool(d, cfg)
  expect_false("alpha2020_cohort_t12m_paidany" %in% pool$data$result_id)
})

test_that("a trial arm never contributes to the primary prevalence intercept, because trial eligibility conditions the denominator on wanting work", {
  d <- fixture()
  d$arms$arm_type[1] <- "control_tau"
  d <- derive_columns(d, cfg)
  pool <- build_primary_pool(d, cfg)
  expect_false("coh_a" %in% pool$data$cohort_id)
  expect_true(any(pool$log$clause == "cohort arm, not a trial arm" & pool$log$removed > 0))
})

test_that("two reports of one cohort contribute one result, and the report set aside is NAMED, because an invisible deduplication cannot be audited", {
  d <- derive_columns(fixture(), cfg)
  pool <- build_primary_pool(d, cfg)
  # coh_b has two reports (beta2021 n=400, gamma2022 n=380)
  expect_equal(sum(pool$data$cohort_id == "coh_b"), 1L)
  expect_false(is.null(pool$dropped_for_overlap))
  expect_true("gamma2022" %in% pool$dropped_for_overlap$dropped_report_id)
  # largest analysis population wins under the prespecified order
  expect_equal(pool$data$report_id[pool$data$cohort_id == "coh_b"], "beta2021")
})

test_that("a follow-up outside the landmark window is excluded whatever else it satisfies, because a pooled estimate mixing 6 months with 20 years has no single meaning", {
  d <- fixture()
  d$outcomes$followup_months[1] <- 6L
  d <- derive_columns(d, cfg)
  pool <- build_primary_pool(d, cfg)
  expect_false("coh_a" %in% pool$data$cohort_id)
})

test_that("the horizon band is assigned from the config windows, so changing the landmark changes the analysis in one place", {
  expect_equal(assign_horizon(c(12, 24, 60, 240, 3), cfg),
               c("t12m", "t24m", "t60m", "t120m", NA_character_))
})

test_that("a derived column typed by an extractor is rejected, because a typed percentage that disagrees with its own counts is an error nobody catches", {
  d <- fixture()
  d$outcomes$p_obs <- 0.3
  expect_error(derive_columns(d, cfg), "p_obs")
})

test_that("a missing source locator stops the run, because a value nobody can trace back cannot be checked by a second reviewer", {
  d <- fixture()
  d$outcomes$source_locator[2] <- NA_character_
  expect_error(validate_extraction(d, cfg), "source_locator")
})

test_that("an outcome referencing an arm belonging to a different cohort is rejected, because the pair is what identifies an arm", {
  d <- fixture()
  d$arms$arm_id[1] <- "other"     # coh_a now has no arm called 'cohort'
  expect_error(validate_extraction(d, cfg), "cohort_id\\+arm_id")
})

test_that("an excluded report must carry a reason, because an exclusion without one cannot be defended in a PRISMA flow", {
  d <- fixture()
  d$reports$eligibility_status[1] <- "exclude"
  expect_error(validate_extraction(d, cfg), "exclusion_reason")
})

test_that("attrition is not derived as entered minus observed, because death, emigration and non-response are different things", {
  d <- derive_columns(fixture(), cfg)
  # prop_unobserved is relative to alive_eligible, not to entered
  expect_equal(d$outcomes$prop_unobserved[1], 1 - 100 / 110)
  expect_false(isTRUE(all.equal(d$outcomes$prop_unobserved[1], 1 - 100 / 120)))
})
