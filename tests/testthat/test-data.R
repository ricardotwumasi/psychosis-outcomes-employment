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

test_that("an allocated trial arm never contributes to the primary prevalence intercept, because the estimand is the whole recruited cohort and an arm is a randomly assigned part of it", {
  d <- fixture()
  d$arms$arm_type[1] <- "control_tau"
  d <- derive_columns(d, cfg)
  pool <- build_primary_pool(d, cfg)
  expect_false("coh_a" %in% pool$data$cohort_id)
  expect_true(any(pool$log$clause == "whole recruited cohort, not an allocated arm" &
                    pool$log$removed > 0))
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

# --- v0.2: the employment-selection gate (D9) --------------------------------

test_that("a cohort recruited on employment-related criteria never enters the primary pool, because a rate conditioned on wanting work does not estimate employment in the psychosis population", {
  d <- fixture()
  d$cohorts$employment_selection_status[1] <- "selected"
  d$cohorts$employment_selection_reason[1] <- "work_intention_or_readiness"
  d <- derive_columns(d, cfg)
  pool <- build_primary_pool(d, cfg)
  expect_false("coh_a" %in% pool$data$cohort_id)
  expect_true(any(pool$log$clause == "no employment-related selection at recruitment" &
                    pool$log$removed > 0))
})

test_that("a cohort whose selection is unclear is excluded from the primary pool, because treating incomplete reporting as absence of selection converts missing information into eligibility", {
  d <- fixture()
  d$cohorts$employment_selection_status[1] <- "unclear"
  d$cohorts$employment_selection_reason[1] <- "incomplete_reporting"
  d <- derive_columns(d, cfg)
  expect_false("coh_a" %in% build_primary_pool(d, cfg)$data$cohort_id)
})

test_that("a blank employment_selection_status stops the run rather than quietly dropping the cohort, because a blank and a `none` must never filter the same way", {
  d <- fixture()
  d$cohorts$employment_selection_status[1] <- NA_character_
  expect_error(validate_extraction(d, cfg), "employment_selection_status")
})

test_that("a classification with no source wording is rejected, because `none` asserts that eligibility was read and the quotation is the only evidence it was", {
  d <- fixture()
  d$cohorts$employment_selection_verbatim[1] <- NA_character_
  expect_error(validate_extraction(d, cfg), "employment_selection_verbatim")
})

test_that("a pool clause whose column is absent stops the run, because filtering on a missing column empties the pool while the log shows a filter working normally", {
  d <- derive_columns(fixture(), cfg)
  d$cohorts$employment_selection_status <- NULL
  expect_error(build_primary_pool(d, cfg), "not present")
})

# --- v0.2: trial-derived whole-cohort safeguards -----------------------------

test_that("a trial-derived cohort whose intervention targeted employment is excluded, because its prevalence is the effect of the intervention rather than the cohort's own rate", {
  d <- fixture()
  d$cohorts$design[1] <- "rct"
  d$arms$all_original_arms_included[1] <- "yes"
  d$arms$post_randomisation_selection[1] <- "no"
  d$arms$employment_targeted_intervention[1] <- "yes"
  d$arms$common_construct_across_arms[1] <- "yes"
  d$arms$selective_reweighting[1] <- "no"
  d <- derive_columns(d, cfg)
  pool <- build_primary_pool(d, cfg)
  expect_false("coh_a" %in% pool$data$cohort_id)
  expect_true(any(pool$log$clause == "trial-derived whole-cohort safeguards" &
                    pool$log$removed > 0))
})

test_that("a trial-derived cohort meeting every safeguard DOES enter the primary pool, because D9 replaced the design gate and OPUS was the case that exposed it", {
  d <- fixture()
  d$cohorts$design[1] <- "rct"
  d$arms$all_original_arms_included[1] <- "yes"
  d$arms$post_randomisation_selection[1] <- "no"
  d$arms$employment_targeted_intervention[1] <- "no"
  d$arms$common_construct_across_arms[1] <- "yes"
  d$arms$selective_reweighting[1] <- "no"
  d <- derive_columns(d, cfg)
  expect_true("coh_a" %in% build_primary_pool(d, cfg)$data$cohort_id)
})

test_that("an unverified safeguard is not a satisfied one, so `unclear` keeps a trial-derived cohort out of the primary pool", {
  d <- fixture()
  d$cohorts$design[1] <- "rct"
  d$arms$all_original_arms_included[1] <- "unclear"
  d$arms$post_randomisation_selection[1] <- "no"
  d$arms$employment_targeted_intervention[1] <- "no"
  d$arms$common_construct_across_arms[1] <- "yes"
  d$arms$selective_reweighting[1] <- "no"
  d <- derive_columns(d, cfg)
  expect_false("coh_a" %in% build_primary_pool(d, cfg)$data$cohort_id)
})

# --- v0.2: derived counts and their components -------------------------------

test_that("a component-only fragment never enters the pool, because an intensity band has no analytical meaning on its own", {
  d <- fixture()
  d$outcomes$result_role[1] <- "component_only"
  d <- derive_columns(d, cfg)
  pool <- build_primary_pool(d, cfg)
  expect_false("alpha2020_cohort_t12m_paidany" %in% pool$data$result_id)
  expect_true(any(pool$log$clause == "not a component-only fragment" &
                    pool$log$removed > 0))
})

test_that("a derived count that disagrees with its own components is rejected, because the model would otherwise treat a wrong sum as an exact observation", {
  d <- fixture()
  comp <- d$outcomes[1, ]
  comp$result_id <- "alpha2020_cohort_t12m_band1"
  comp$result_role <- "component_only"
  comp$n_employed <- 11L          # the derived row says 30, so 11 + 12 = 23 != 30
  comp2 <- comp
  comp2$result_id <- "alpha2020_cohort_t12m_band2"
  comp2$n_employed <- 12L
  d$outcomes <- rbind(d$outcomes, comp, comp2)
  d$outcomes$result_role[1] <- "derived"
  d$outcomes$derivation_justification[1] <- "sum of the two reported intensity bands"
  d$outcomes$derivation_component_result_ids[1] <-
    "alpha2020_cohort_t12m_band1;alpha2020_cohort_t12m_band2"
  d$outcomes$derivation_mutually_exclusive[1] <- "yes"
  d$outcomes$derivation_exhaustive[1] <- "yes"
  d$outcomes$derivation_zero_separable[1] <- "yes"
  expect_error(validate_extraction(d, cfg), "components sum to 23")
})

test_that("a derived count whose components sum correctly is accepted, so the intensity-band rule is usable rather than merely safe", {
  d <- fixture()
  comp <- d$outcomes[1, ]
  comp$result_id <- "alpha2020_cohort_t12m_band1"
  comp$result_role <- "component_only"
  comp$n_employed <- 18L
  comp2 <- comp
  comp2$result_id <- "alpha2020_cohort_t12m_band2"
  comp2$n_employed <- 12L         # 18 + 12 = 30, the derived row
  d$outcomes <- rbind(d$outcomes, comp, comp2)
  d$outcomes$result_role[1] <- "derived"
  d$outcomes$derivation_justification[1] <- "sum of the two reported intensity bands"
  d$outcomes$derivation_component_result_ids[1] <-
    "alpha2020_cohort_t12m_band1;alpha2020_cohort_t12m_band2"
  d$outcomes$derivation_mutually_exclusive[1] <- "yes"
  d$outcomes$derivation_exhaustive[1] <- "yes"
  d$outcomes$derivation_zero_separable[1] <- "yes"
  expect_true(validate_extraction(d, cfg))
})

test_that("a derived count with no stated arithmetic is rejected, because a complement has no components to check and the justification is the only record of what was done", {
  d <- fixture()
  d$outcomes$result_role[1] <- "derived"
  expect_error(validate_extraction(d, cfg), "derivation_justification")
})

# --- v0.2: horizons, moderators, sensitivities -------------------------------

test_that("18 months goes to the 24-month band, because it sits in both windows and the tie rule was fixed prospectively rather than by yaml ordering", {
  expect_equal(assign_horizon(18, cfg), "t24m")
  expect_equal(assign_horizon(17, cfg), "t12m")
  expect_equal(assign_horizon(c(9, 30, 48, 108), cfg),
               c("t12m", "t24m", "t60m", "t120m"))
})

test_that("a moderator percentage is computed from its own counts, so a value the source never printed is still checkable against the source", {
  d <- fixture()
  d$outcomes$perc_female <- NA_real_
  d$outcomes$n_female[1] <- 71L
  d$outcomes$n_female_denominator[1] <- 161L
  d <- derive_columns(d, cfg)
  expect_equal(round(d$outcomes$perc_female[1], 1), 44.1)
})

test_that("a typed percentage contradicting its own counts stops the run rather than being averaged or silently overwritten", {
  d <- fixture()
  d$outcomes$perc_female[1] <- 90
  d$outcomes$n_female[1] <- 71L
  d$outcomes$n_female_denominator[1] <- 161L
  expect_error(derive_columns(d, cfg), "perc_female")
})

test_that("each moderator uses its own denominator, because sex, education and baseline employment are routinely reported on different subsets of one sample", {
  d <- fixture()
  d$outcomes$perc_female <- NA_real_
  d$outcomes$perc_post_secondary <- NA_real_
  d$outcomes$n_female[1] <- 50L
  d$outcomes$n_female_denominator[1] <- 100L
  d$outcomes$n_post_secondary[1] <- 10L
  d$outcomes$n_post_secondary_denominator[1] <- 40L   # a different denominator
  d <- derive_columns(d, cfg)
  expect_equal(d$outcomes$perc_female[1], 50)
  expect_equal(d$outcomes$perc_post_secondary[1], 25)
})

test_that("the two named sensitivity analyses actually run and report their own cohort sets, because a configuration flag no code reads is not a sensitivity analysis", {
  d <- fixture()
  d$cohorts$employment_selection_status[1] <- "unclear"
  d$cohorts$employment_selection_reason[1] <- "incomplete_reporting"
  d <- derive_columns(d, cfg)
  primary <- build_primary_pool(d, cfg)
  sens <- build_sensitivity_pools(d, cfg)
  expect_true(all(c("unclear_selection_included", "trial_derived_excluded") %in%
                    names(sens)))
  # admitting `unclear` recovers the cohort the primary gate excluded
  expect_false("coh_a" %in% primary$data$cohort_id)
  expect_true("coh_a" %in% sens$unclear_selection_included$cohorts)
})

test_that("pool attrition is counted in distinct cohorts as well as rows, because ten results from one cohort are one cohort's worth of evidence", {
  d <- derive_columns(fixture(), cfg)
  pool <- build_primary_pool(d, cfg)
  expect_true("cohorts_remaining" %in% names(pool$log))
  # the fixture has 3 results across 2 cohorts, deduplicated to 2 results
  expect_equal(pool$n_cohorts, 2L)
  expect_equal(tail(pool$log$cohorts_remaining, 1), 2L)
})

# --- v0.2: the report-to-cohort map ------------------------------------------

test_that("a report-cohort pair that produced a result must appear in the map, because batching is built from the map and a report separated from its cohort siblings cannot make a result-selection decision", {
  d <- fixture()
  d$report_cohort_map <- d$report_cohort_map[d$report_cohort_map$report_id != "gamma2022", ]
  expect_error(validate_extraction(d, cfg), "report_id\\+cohort_id")
})

test_that("a map entry naming an unknown cohort is rejected, because a dangling identifier would put a report in the wrong extraction batch", {
  d <- fixture()
  d$report_cohort_map$cohort_id[1] <- "coh_does_not_exist"
  expect_error(validate_extraction(d, cfg), "cohort_id")
})

test_that("one report may map to several cohorts, because a single publication can describe two independently recruited samples", {
  d <- fixture()
  # alpha2020 additionally describes coh_b: the many-to-many case the old
  # single cohort_id column on extraction_reports.csv could not express
  d$report_cohort_map <- rbind(d$report_cohort_map, data.frame(
    report_id = "alpha2020", cohort_id = "coh_b", relationship = "describes",
    contributes_results = "no", notes = NA_character_, stringsAsFactors = FALSE))
  expect_true(validate_extraction(d, cfg))
})

# --- v0.2b: errors the first round of tests did NOT catch --------------------
# These three encode the semantic failures found by the Stage B rechecks, which
# passed every structural test while being substantively wrong.

test_that("a derived paid_any is rejected when zero work is not separable from its components, because a residual band of '<25%' pools people who never worked with people who worked 1-24.9% and the number in ANY paid work is then not identified at all", {
  d <- fixture()
  comp <- d$outcomes[1, ]
  comp$result_id <- "alpha2020_band_25_49"; comp$result_role <- "component_only"
  comp$n_employed <- 18L
  d$outcomes <- rbind(d$outcomes, comp)
  d$outcomes$result_role[1] <- "derived"
  d$outcomes$n_employed[1] <- 18L
  d$outcomes$derivation_justification[1] <- "sum of bands above the 25% threshold"
  d$outcomes$derivation_component_result_ids[1] <- "alpha2020_band_25_49"
  d$outcomes$derivation_mutually_exclusive[1] <- "yes"
  d$outcomes$derivation_exhaustive[1] <- "yes"
  d$outcomes$derivation_zero_separable[1] <- "no"   # the lowest band is "<25%", not "0%"
  expect_error(validate_extraction(d, cfg), "derivation_zero_separable")
})

test_that("the same derivation IS accepted for a threshold construct, because summing bands above a stated threshold is exact even when any-paid-work is not identified", {
  d <- fixture()
  comp <- d$outcomes[1, ]
  comp$result_id <- "alpha2020_band_25_49"; comp$result_role <- "component_only"
  comp$n_employed <- 18L; comp$outcome_construct <- "paid_intensity_threshold"
  d$outcomes <- rbind(d$outcomes, comp)
  d$outcomes$result_role[1] <- "derived"
  d$outcomes$outcome_construct[1] <- "paid_intensity_threshold"
  d$outcomes$n_employed[1] <- 18L
  d$outcomes$derivation_justification[1] <- "sum of bands above the 25% threshold"
  d$outcomes$derivation_component_result_ids[1] <- "alpha2020_band_25_49"
  d$outcomes$derivation_mutually_exclusive[1] <- "yes"
  d$outcomes$derivation_exhaustive[1] <- "yes"
  d$outcomes$derivation_zero_separable[1] <- "no"
  expect_true(validate_extraction(d, cfg))
})

test_that("a threshold-defined construct never enters the primary pool, because excluding everyone below the threshold changes the numerator while a paid-employment label is retained", {
  d <- fixture()
  d$outcomes$outcome_construct[1] <- "paid_intensity_threshold"
  d <- derive_columns(d, cfg)
  expect_false("alpha2020_cohort_t12m_paidany" %in% build_primary_pool(d, cfg)$data$result_id)
})

test_that("a timepoint that is a mean time since onset gets no horizon, because assigning a cohort to a landmark band on the strength of an average mixes age-anchored with time-anchored measurements", {
  d <- fixture()
  d$outcomes$followup_months[1] <- 12L
  d$outcomes$followup_basis[1] <- "since_onset_mean"
  d <- derive_columns(d, cfg)
  expect_true(is.na(d$outcomes$horizon[1]))
  expect_false("coh_a" %in% build_primary_pool(d, cfg)$data$cohort_id)
  # a chronological-age measurement is likewise not an elapsed follow-up
  expect_equal(assign_horizon(c(12, 12), cfg,
                              c("since_baseline", "chronological_age")),
               c("t12m", NA_character_))
})

test_that("a result its own source contradicts is blocked from every synthesis, because a note leaves the row numerically complete and it would enter a pool silently", {
  d <- fixture()
  d$outcomes$conflict_status[1] <- "unresolved"
  d$outcomes$conflict_note[1] <- "Table 2 subgroups sum to 99 against a printed total of 105"
  d <- derive_columns(d, cfg)
  pool <- build_primary_pool(d, cfg)
  expect_false("alpha2020_cohort_t12m_paidany" %in% pool$data$result_id)
  expect_true(any(pool$log$clause == "no unresolved conflict in the source" &
                    pool$log$removed > 0))
})

test_that("a blocked result must say what blocks it, because an unexplained block cannot be resolved by anyone later", {
  d <- fixture()
  d$outcomes$conflict_status[1] <- "unresolved"
  expect_error(validate_extraction(d, cfg), "conflict_note")
})

test_that("being a component is a relationship and not a disqualification, so a directly reported count can both contribute to a derived total and remain a valid secondary result in its own family", {
  d <- fixture()
  comp <- d$outcomes[1, ]
  comp$result_id <- "alpha2020_cohort_t12m_paidcomp"
  comp$outcome_construct <- "paid_competitive"
  comp$result_role <- "reported"          # NOT component_only
  comp$n_employed <- 30L
  d$outcomes <- rbind(d$outcomes, comp)
  d$outcomes$result_role[1] <- "derived"
  d$outcomes$derivation_justification[1] <- "the only paid category reported"
  d$outcomes$derivation_component_result_ids[1] <- "alpha2020_cohort_t12m_paidcomp"
  d$outcomes$derivation_mutually_exclusive[1] <- "yes"
  d$outcomes$derivation_exhaustive[1] <- "yes"
  d$outcomes$derivation_zero_separable[1] <- "yes"
  expect_true(validate_extraction(d, cfg))
})

test_that("a derived count reported on a different denominator from its components is rejected, because a sum over one denominator quoted against another is a different proportion", {
  d <- fixture()
  comp <- d$outcomes[1, ]
  comp$result_id <- "alpha2020_band"; comp$result_role <- "component_only"
  comp$n_employed <- 30L; comp$n_outcome_observed <- 90L   # derived row says 100
  d$outcomes <- rbind(d$outcomes, comp)
  d$outcomes$result_role[1] <- "derived"
  d$outcomes$derivation_justification[1] <- "single component"
  d$outcomes$derivation_component_result_ids[1] <- "alpha2020_band"
  d$outcomes$derivation_mutually_exclusive[1] <- "yes"
  d$outcomes$derivation_exhaustive[1] <- "yes"
  d$outcomes$derivation_zero_separable[1] <- "yes"
  expect_error(validate_extraction(d, cfg), "components share")
})

test_that("components measured over different ascertainment windows are not addable, because two period-prevalence counts over different windows measure different things", {
  d <- fixture()
  d$outcomes$ascertainment[1] <- "period_prevalence"
  d$outcomes$ascertainment_window_months[1] <- 12
  comp <- d$outcomes[1, ]
  comp$result_id <- "alpha2020_band"; comp$result_role <- "component_only"
  comp$n_employed <- 30L; comp$ascertainment_window_months <- 24   # different window
  d$outcomes <- rbind(d$outcomes, comp)
  d$outcomes$result_role[1] <- "derived"
  d$outcomes$derivation_justification[1] <- "single component"
  d$outcomes$derivation_component_result_ids[1] <- "alpha2020_band"
  d$outcomes$derivation_mutually_exclusive[1] <- "yes"
  d$outcomes$derivation_exhaustive[1] <- "yes"
  d$outcomes$derivation_zero_separable[1] <- "yes"
  expect_error(validate_extraction(d, cfg), "ascertainment_window_months")
})

test_that("a populated observed denominator must say what it is, because arithmetic agreement identifies the base a source divided by and not the process by which employment was observed", {
  d <- fixture()
  d$outcomes$denominator_basis[1] <- NA_character_   # n_outcome_observed = 100
  expect_error(validate_extraction(d, cfg), "denominator_basis")
})

# --- v0.3: analysis-unit selection, conditional diagnosis, age anchors -------

test_that("a cohort recruited without any employment criterion is still excluded when its ANALYSIS unit removes a work-capacity group, because the restriction attaches to the denominator rather than to recruitment", {
  d <- fixture()
  d$arms$analysis_selection_status[1] <- "selected"
  d$arms$analysis_selection_reason[1] <- "analytic_restriction"
  d <- derive_columns(d, cfg)
  pool <- build_primary_pool(d, cfg)
  expect_false("coh_a" %in% pool$data$cohort_id)
  # and it is logged as its own clause, distinct from the recruitment gate
  expect_true(any(pool$log$clause == "no employment-related analytic restriction" &
                    pool$log$removed > 0))
  expect_true(any(pool$log$clause == "no employment-related selection at recruitment" &
                    pool$log$removed == 0))
})

test_that("a mixed severe-mental-illness cohort enters when at least half carry a qualifying diagnosis AND a subgroup is extractable, because SAP section 7 sets a percentage rule and a label must not override it", {
  d <- fixture()
  d$cohorts$diagnosis_group[1] <- "smi_mixed"
  d$cohorts$perc_qualifying_diagnosis[1] <- 70
  d$cohorts$subgroup_extractable[1] <- "yes"
  d <- derive_columns(d, cfg)
  expect_true("coh_a" %in% build_primary_pool(d, cfg)$data$cohort_id)
})

# Superseded 12 August 2026 by D13. This test previously asserted that a mixed
# cohort with no extractable subgroup stays out, encoding an implementation that
# was stricter than SAP section 7. It is inverted rather than deleted, because
# the behaviour it guarded did change and the record should show that.
test_that("a mixed cohort above the threshold enters even with no extractable psychosis subgroup, because subgroup extractability is not a second condition and requiring it excluded whole cohorts the SAP admits", {
  d <- fixture()
  d$cohorts$diagnosis_group[1] <- "smi_mixed"
  d$cohorts$perc_qualifying_diagnosis[1] <- 70
  d$cohorts$subgroup_extractable[1] <- "no"
  d <- derive_columns(d, cfg)
  expect_true("coh_a" %in% build_primary_pool(d, cfg)$data$cohort_id)
})

test_that("clinical high risk is excluded unconditionally, however high its qualifying percentage, because SAP section 7 bars it outright rather than conditionally", {
  d <- fixture()
  d$cohorts$diagnosis_group[1] <- "chr"
  d$cohorts$perc_qualifying_diagnosis[1] <- 100
  d$cohorts$subgroup_extractable[1] <- "yes"
  d <- derive_columns(d, cfg)
  expect_false("coh_a" %in% build_primary_pool(d, cfg)$data$cohort_id)
})

test_that("an age-anchored result may leave followup_months blank but must give the age, because typing a cohort mean into an elapsed-time field to satisfy a validator is how a mean-since-onset figure came to sit beside an age-44-45 measurement", {
  d <- fixture()
  d$outcomes$followup_basis[1] <- "chronological_age"
  d$outcomes$followup_months[1] <- NA_integer_
  d$outcomes$measurement_age_years[1] <- 44.5
  expect_true(validate_extraction(d, cfg))
  d$outcomes$measurement_age_years[1] <- NA_real_
  expect_error(validate_extraction(d, cfg), "measurement_age_years")
})

test_that("a baseline-anchored result still requires followup_months, so relaxing the field for age anchors does not quietly make it optional everywhere", {
  d <- fixture()
  d$outcomes$followup_months[1] <- NA_integer_
  expect_error(validate_extraction(d, cfg), "followup_months")
})

# Risk-of-bias domain slugs. Added after the first two Stage F batches
# independently coined incompatible slugs for the same JBI checklist.

rob_fixture <- function(tool = "jbi_prevalence") {
  d <- fixture()
  domains <- cfg$vocab$rob_domain[[tool]]
  judgement <- cfg$vocab$rob_judgement[[tool]][[1]]
  d$rob <- data.frame(
    rob_assessment_id = paste0("rb", seq_along(domains)),
    result_id = d$outcomes$result_id[1],
    rob_tool = tool, rob_tool_version = "2020",
    domain = domains, signalling_responses = NA_character_,
    judgement = judgement, rationale = "stated in the source",
    source_location = "p. 3", assessor = "agent",
    checker = NA_character_, bias_direction = NA_character_,
    stringsAsFactors = FALSE
  )
  d
}

test_that("a domain slug outside the instrument's vocabulary is rejected, because two extractors coining q1_sample_frame and jbi1_sample_frame for one checklist produce shards no merge can reconcile and no domain-level summary can cross", {
  d <- rob_fixture()
  expect_true(validate_extraction(d, cfg))
  d$rob$domain[1] <- "q1_sample_frame"
  expect_error(validate_extraction(d, cfg), "domain")
})

test_that("a result missing one of its instrument's domains is rejected, because an absent domain is an unasked question and is indistinguishable from a favourable answer once the appraisal is summarised", {
  d <- rob_fixture()
  d$rob <- d$rob[-3, ]
  expect_error(validate_extraction(d, cfg), "missing the domain")
})

test_that("domain vocabularies do not leak between instruments, so a RoB 2 domain cannot be used to appraise a prevalence estimate", {
  d <- rob_fixture()
  d$rob$domain[1] <- "rob2_1_randomisation"
  expect_error(validate_extraction(d, cfg), "domain")
})

test_that("a cohort followed to one shared calendar end date is barred from every horizon, because a mean of 4.5-to-23.5-year follow-ups would place the cohort in a landmark band on the strength of an average spanning two of them", {
  expect_true(is.na(assign_horizon(139, cfg, "calendar_end_common")))
  # The same elapsed figure measured from entry is assignable, so the bar comes
  # from what the number represents and not from its size.
  expect_equal(assign_horizon(139, cfg, "since_baseline"), "t120m")
})

# The diagnosis gate (D13). The 50 per cent rule is sufficient on its own.

test_that("a mixed-SMI cohort above the diagnosis threshold enters the pool without an extractable subgroup, because requiring both is stricter than SAP section 7 and silently dropped a 90-per-cent-schizophrenia whole cohort", {
  d <- fixture()
  d$cohorts$diagnosis_group[1] <- "smi_mixed"
  d$cohorts$perc_qualifying_diagnosis[1] <- 90
  d$cohorts$subgroup_extractable[1] <- "no"
  d <- derive_columns(d, cfg)
  expect_true("coh_a" %in% build_primary_pool(d, cfg)$data$cohort_id)
})

test_that("a mixed-SMI cohort below the threshold stays out even when a subgroup is extractable, because a subgroup arm is not a whole recruited cohort and the primary estimand admits only whole cohorts", {
  d <- fixture()
  d$cohorts$diagnosis_group[1] <- "smi_mixed"
  d$cohorts$perc_qualifying_diagnosis[1] <- 30
  d$cohorts$subgroup_extractable[1] <- "yes"
  d <- derive_columns(d, cfg)
  expect_false("coh_a" %in% build_primary_pool(d, cfg)$data$cohort_id)
})

test_that("a median elapsed follow-up since entry is barred from every horizon, because 67 months would otherwise land inside the five-year window on the strength of a median spanning admissions from 2000 to 2013", {
  expect_true(is.na(assign_horizon(67, cfg, "since_baseline_mean")))
  expect_equal(assign_horizon(67, cfg, "since_baseline"), "t60m")
})

# Partition sums across subgroups (D14).

partition_fixture <- function() {
  d <- fixture()
  o <- d$outcomes
  base <- o[1, ]
  mk <- function(id, arm, emp, obs) {
    r <- base
    r$result_id <- id; r$arm_id <- arm
    r$n_employed <- emp; r$n_outcome_observed <- obs
    r$n_assessed <- obs; r$n_alive_eligible <- obs; r$n_entered <- obs
    r$result_role <- "reported"
    r$derivation_component_result_ids <- NA_character_
    r
  }
  a <- mk("part_a", "sub_a", 10L, 40L)
  b <- mk("part_b", "sub_b", 5L, 20L)
  tot <- mk("part_tot", "cohort", 15L, 60L)
  tot$result_role <- "derived"
  tot$derivation_component_result_ids <- "part_a;part_b"
  tot$derivation_mutually_exclusive <- "yes"
  tot$derivation_exhaustive <- "yes"
  tot$derivation_justification <- "sum of the two subgroups, Table 3"
  d$outcomes <- rbind(o[0, ], a, b, tot)
  d$arms <- rbind(d$arms[d$arms$cohort_id == "coh_a", ][0, ],
                  transform(d$arms[d$arms$cohort_id == "coh_a", ][1, ], arm_id = "sub_a"),
                  transform(d$arms[d$arms$cohort_id == "coh_a", ][1, ], arm_id = "sub_b"),
                  d$arms)
  d
}

test_that("subgroup denominators must sum exactly to the derived denominator, because a subgroup left out or counted twice is exactly what makes a partial sum look like a whole-cohort total", {
  d <- partition_fixture()
  expect_true(validate_extraction(d, cfg))
  d$outcomes$n_outcome_observed[d$outcomes$result_id == "part_tot"] <- 59L
  expect_error(validate_extraction(d, cfg), "sum")
})

test_that("a partition sum needs both exclusivity and exhaustiveness asserted, because without them the components are not known to cover the population and the total is a subtotal wearing a cohort's denominator", {
  d <- partition_fixture()
  d$outcomes$derivation_exhaustive[d$outcomes$result_id == "part_tot"] <- "no"
  expect_error(validate_extraction(d, cfg), "derivation_exhaustive")
})

test_that("a derivation resting on a disputed component is rejected, because summing a contradicted count launders the conflict into a clean-looking total", {
  d <- partition_fixture()
  d$outcomes$conflict_status[d$outcomes$result_id == "part_a"] <- "unresolved"
  d$outcomes$conflict_note[d$outcomes$result_id == "part_a"] <- "printed total disagrees"
  expect_error(validate_extraction(d, cfg), "unresolved")
})
