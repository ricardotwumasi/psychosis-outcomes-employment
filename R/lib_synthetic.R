# =============================================================================
# lib_synthetic.R
#
# A generated extraction, for ENGINEERING fits only.
#
# An engineering fit bypasses every gate, so it may not see real employment
# outcomes. This builds a small extraction that passes validate_extraction and
# exercises every D11.3 route and both named sensitivity analyses:
#
#   t12m   three cohorts in the primary pool (model, small k), one of them a
#          safeguarded trial so trial_derived_excluded differs from the
#          primary, plus one cohort with unclear selection so
#          unclear_selection_included differs too
#   t24m   two cohorts, one reported twice, so one result per cohort is
#          applied before counting (model, k = 2)
#   t60m   one cohort (exact binomial)
#   t120m  nothing (no estimate)
#
# resolve_fit_mode() refuses SYNTHETIC_DATA outside engineering mode, so none
# of this can reach a provisional or definitive table.
# =============================================================================

synthetic_extraction <- function(cfg) {
  #            cohort    report     months  employed  observed  alive  design                 selection
  spec <- data.frame(
    cohort_id = c("syn_01", "syn_02", "syn_03", "syn_04", "syn_05", "syn_05", "syn_06", "syn_07"),
    report_id = c("syn2001", "syn2002", "syn2003", "syn2004", "syn2005", "syn2006", "syn2007", "syn2008"),
    followup_months = c(12L, 12L, 12L, 12L, 24L, 20L, 24L, 60L),
    n_employed = c(25L, 70L, 30L, 30L, 40L, 35L, 20L, 12L),
    n_outcome_observed = c(100L, 200L, 150L, 80L, 120L, 118L, 90L, 60L),
    n_alive_eligible = c(120L, 240L, 170L, 95L, 140L, 140L, NA, 70L),
    stringsAsFactors = FALSE)
  n <- nrow(spec)
  coh <- unique(spec$cohort_id)
  design <- ifelse(coh == "syn_03", "rct", "prospective_cohort")
  trial <- coh == "syn_03"
  selection <- ifelse(coh == "syn_04", "unclear", "none")

  reports <- data.frame(
    report_id = spec$report_id, first_author = "Synthetic",
    year = 2000L + seq_len(n), doi = NA_character_, title = NA_character_,
    journal = NA_character_, source_filename = paste0(spec$report_id, ".pdf"),
    eligibility_status = "include", exclusion_reason = "not_applicable",
    report_quantifiable = "yes", cohort_id = spec$cohort_id,
    cohort_overlap_notes = NA_character_, notes = "SYNTHETIC",
    stringsAsFactors = FALSE)
  cohorts <- data.frame(
    cohort_id = coh, cohort_name = paste("Synthetic", coh), design = design,
    country_iso3 = "GBR", region = "europe_west", country_income_level = "high",
    income_year = 2022L, diagnosis_group = "fep",
    diagnostic_instrument = "ICD-10", diagnosis_confirmed = "clinical interview",
    perc_qualifying_diagnosis = 100, first_episode = "yes",
    subgroup_extractable = "yes", setting = "eip",
    recruitment_start = 2010L, recruitment_end = 2014L,
    overlap_notes = NA_character_,
    employment_selection_status = selection,
    employment_selection_reason = ifelse(selection == "unclear",
                                         "incomplete_reporting", "not_applicable"),
    employment_selection_verbatim = "synthetic eligibility statement",
    employment_selection_source = "Methods, Participants",
    stringsAsFactors = FALSE)
  arms <- data.frame(
    cohort_id = coh, arm_id = "cohort", arm_type = "cohort",
    analysis_selection_status = "none", analysis_selection_reason = "not_applicable",
    intervention_name = NA_character_, intervention_description = NA_character_,
    cluster_randomised = "no", n_clusters = NA_integer_, icc_reported = NA_real_,
    baseline_unemployed_required = "no", baseline_wants_work_required = "no",
    all_original_arms_included = ifelse(trial, "yes", "not_applicable"),
    post_randomisation_selection = ifelse(trial, "no", "not_applicable"),
    employment_targeted_intervention = ifelse(trial, "no", "not_applicable"),
    common_construct_across_arms = ifelse(trial, "yes", "not_applicable"),
    selective_reweighting = ifelse(trial, "no", "not_applicable"),
    n_entered = 300L, stringsAsFactors = FALSE)
  outcomes <- data.frame(
    result_id = paste0(spec$report_id, "_cohort_t", spec$followup_months, "m_paidany"),
    report_id = spec$report_id, cohort_id = spec$cohort_id, arm_id = "cohort",
    analysis_sample_id = NA_character_,
    followup_months = spec$followup_months, followup_basis = "since_baseline",
    measurement_age_years = NA_real_, mean_years_since_onset = NA_real_,
    reported_percentage_base = NA_integer_, outcome_construct = "paid_any",
    outcome_verbatim = "in paid employment", result_role = "reported",
    conflict_status = "none", conflict_note = NA_character_,
    derivation_mutually_exclusive = NA_character_,
    derivation_exhaustive = NA_character_, derivation_zero_separable = NA_character_,
    ascertainment = "point_prevalence", ascertainment_window_months = NA_real_,
    n_employed = spec$n_employed, n_outcome_observed = spec$n_outcome_observed,
    n_assessed = spec$n_outcome_observed, n_alive_eligible = spec$n_alive_eligible,
    n_entered = 300L, denominator_basis = "outcome_observed",
    missing_data_method = "complete_case", source_locator = "synthetic",
    derivation_component_result_ids = NA_character_,
    derivation_justification = NA_character_, checked_by = NA_character_,
    adjusted_measure = NA_character_, adjusted_effect = NA_real_, adjusted_se = NA_real_,
    mean_age = 30, perc_female = 40,
    n_female = NA_integer_, n_female_denominator = NA_integer_,
    perc_post_secondary = 30,
    n_post_secondary = NA_integer_, n_post_secondary_denominator = NA_integer_,
    perc_employed_baseline = 20,
    n_employed_baseline = NA_integer_, n_employed_baseline_denominator = NA_integer_,
    notes = "SYNTHETIC", stringsAsFactors = FALSE)
  report_cohort_map <- data.frame(
    report_id = spec$report_id, cohort_id = spec$cohort_id,
    relationship = "describes", contributes_results = "yes",
    notes = NA_character_, stringsAsFactors = FALSE)

  dat <- list(reports = reports, cohorts = cohorts, arms = arms,
              outcomes = outcomes, rob = NULL, manifest = NULL,
              report_cohort_map = report_cohort_map)
  # The analysis identifier hashes the input shas, so a synthetic run gets its
  # own identifier and can never share a cache or directory with a real one.
  dat$shas <- c(synthetic = digest::digest(dat, algo = "sha256"))
  dat
}
