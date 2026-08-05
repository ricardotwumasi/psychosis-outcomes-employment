# Minimal valid extraction tables, and helpers to break one thing at a time.
#
# Each test breaks exactly one field, so a failure names the rule that broke
# rather than leaving you to work out which of several changes was responsible.

PROJ <- Sys.getenv("PROJ_ROOT", unset = normalizePath(file.path(testthat::test_path(), "..", "..")))

source(file.path(PROJ, "R", "lib_config.R"))
source(file.path(PROJ, "R", "lib_data.R"))
source(file.path(PROJ, "R", "lib_summaries.R"))

test_cfg <- function() load_config(PROJ)

fixture <- function() {
  reports <- data.frame(
    report_id = c("alpha2020", "beta2021", "gamma2022"),
    first_author = c("Alpha", "Beta", "Gamma"), year = c(2020L, 2021L, 2022L),
    doi = NA_character_, title = NA_character_, journal = NA_character_,
    source_filename = c("a.pdf", "b.pdf", "c.pdf"),
    eligibility_status = "include", exclusion_reason = "not_applicable",
    cohort_id = c("coh_a", "coh_b", "coh_b"),
    cohort_overlap_notes = NA_character_, notes = NA_character_,
    stringsAsFactors = FALSE
  )
  cohorts <- data.frame(
    cohort_id = c("coh_a", "coh_b"),
    cohort_name = c("Cohort A", "Cohort B"),
    design = c("prospective_cohort", "register_cohort"),
    country_iso3 = c("GBR", "DNK"),
    region = c("europe_west", "europe_north"),
    country_income_level = "high", income_year = 2022L,
    diagnosis_group = c("fep", "schizophrenia"),
    diagnostic_instrument = "ICD-10", diagnosis_confirmed = "clinical interview",
    perc_qualifying_diagnosis = 100, first_episode = c("yes", "no"),
    subgroup_extractable = "yes", setting = c("eip", "registry"),
    recruitment_start = 2010L, recruitment_end = 2014L,
    overlap_notes = NA_character_, stringsAsFactors = FALSE
  )
  arms <- data.frame(
    cohort_id = c("coh_a", "coh_b"), arm_id = "cohort", arm_type = "cohort",
    intervention_name = NA_character_, intervention_description = NA_character_,
    cluster_randomised = "no", n_clusters = NA_integer_, icc_reported = NA_real_,
    baseline_unemployed_required = "no", baseline_wants_work_required = "no",
    n_entered = c(120L, 500L), stringsAsFactors = FALSE
  )
  outcomes <- data.frame(
    result_id = c("alpha2020_cohort_t12m_paidany", "beta2021_cohort_t12m_paidany",
                  "gamma2022_cohort_t12m_paidany"),
    report_id = c("alpha2020", "beta2021", "gamma2022"),
    cohort_id = c("coh_a", "coh_b", "coh_b"), arm_id = "cohort",
    followup_months = 12L, outcome_construct = "paid_any",
    outcome_verbatim = "in paid employment", ascertainment = "point_prevalence",
    n_employed = c(30L, 100L, 90L), n_outcome_observed = c(100L, 400L, 380L),
    n_assessed = c(105L, 420L, 400L), n_alive_eligible = c(110L, 460L, 460L),
    n_entered = c(120L, 500L, 500L), denominator_basis = "outcome_observed",
    missing_data_method = "complete_case",
    source_locator = "Table 2, p. 5", adjusted_measure = NA_character_,
    adjusted_effect = NA_real_, adjusted_se = NA_real_,
    mean_age = 30, perc_female = 40, perc_post_secondary = 30,
    perc_employed_baseline = 20, notes = NA_character_, stringsAsFactors = FALSE
  )
  list(reports = reports, cohorts = cohorts, arms = arms, outcomes = outcomes,
       rob = NULL, manifest = NULL)
}
