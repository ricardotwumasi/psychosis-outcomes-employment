# =============================================================================
# apply_stage_b.py
#
#     python3 scripts/apply_stage_b.py --check
#     python3 scripts/apply_stage_b.py
#
# Applies the Stage B recheck findings to the pilot extraction tables. Every
# value below was read from a source PDF by a recheck pass and is recorded here
# with the wording and location that justify it, so the transformation is
# auditable and rerunnable rather than a set of hand edits. Idempotent.
#
# Findings are in the scratchpad as stageB_batch1.md and stageB_batch2.md.
#
# TWO RECHECK CALLS WERE CHANGED, and both are recorded here rather than
# silently applied, because each decides whether a cohort can enter the primary
# pool:
#
#   1. lin2026 arm_type: `intervention` -> `cohort`.
#      SAP 2.1 keeps "individually allocated intervention, active-control and
#      treatment-as-usual arms" out of the prevalence intercept, because each is
#      a randomly assigned PART of a recruited whole. PP1M-AsiaPac is
#      single-arm: there is no allocation, so the arm IS the recruited cohort,
#      which is what codebook `arm_type = cohort` means. Leaving it as
#      `intervention` would exclude the cohort by a rule written for a situation
#      that does not arise here.
#
#   2. lin2026 post_randomisation_selection: `yes` -> `not_applicable`.
#      The recheck answered `yes` because 474 of 521 enrolled provided
#      employment data and the observed-case denominators fall from 390 to 280.
#      That is ATTRITION, not selection of a post-randomisation subgroup.
#      Of the five safeguard fields, the three ALLOCATION-RELATED ones
#      (all_original_arms_included, post_randomisation_selection,
#      common_construct_across_arms) are not applicable to a single-arm study,
#      which has no allocation groups. The other two remain applicable and are
#      both answered `no`: employment_targeted_intervention (PP1M is a licensed
#      antipsychotic with no vocational component) and selective_reweighting
#      ("No imputation methods were employed", Methods 2.4, p. 3).
#      Reading attrition as subgroup selection would fail every study in the
#      review, since all have attrition, and would do so on a gate that is not
#      designed to carry it: missing outcome data is handled by
#      n_outcome_observed and by the prespecified missing-outcome bounding
#      analyses (SAP section 6).
#      The concern itself is real and is NOT discarded: these are completer
#      denominators, so the available-case assumption is doing real work. It is
#      recorded in `notes` and in missing_data_method, where the bounding
#      analyses will act on it.
#
# Both are flagged for the authorship group in docs/extraction_qa_report.md.
# =============================================================================
import argparse
import csv
import os
import sys

DATA = "data"

# --- cohort-level employment selection ---------------------------------------
# (status, reason, verbatim, source)
SELECTION = {
    "nz_idi": (
        "none", "not_applicable",
        "We previously identified a retrospective cohort of 2412 13- to 25-year-old individuals diagnosed with FEP between 2009 and 2012. To develop this cohort we used health record data (specifically specialist mental health service use and diagnosis data) held in the Statistics New Zealand Integrated Data Infrastructure (IDI) to identify individuals with a first recorded diagnosis of psychosis between the ages of 13 and 25 during the study period. | Exclusions: We excluded cohort members who had spent more than a quarter of the follow-up period (the 5 years post diagnosis) abroad or who had died during this period.",
        "Method, Study population, pp. 1-2"),
    "dk_registers_1998": (
        "none", "not_applicable",
        "The source population included all individuals residing in Denmark who received a first-time diagnosis of a nonaffective psychotic disorder (ICD-10 codes F20-F29). The date of the first registered F20-F29 diagnosis was defined as the cohort entry date. To ensure complete temporal alignment between medication exposure and employment data, we restricted the cohort to individuals with index diagnosis dates between January 1, 1998, and December 31, 2023 ... Individuals were excluded if they died or emigrated within 2 years of cohort entry.",
        "Methods, Study population, p. 2"),
    "bologna_fep": (
        "none", "not_applicable",
        "This study is part of the Bologna West First Episode Psychosis project (Bo-FEP), an incidence FEP study of all patients between 18 and 64 years, who had a contact with Bologna West Community Mental Health Centers (CMHCs) from January 2002 to December 2009. | We carried out a 12 months follow-up of all first episode psychosis patients identified in the study period.",
        "Methods, Setting and service description, p. 522; Study design, p. 523"),
    # RATIFIED 12 August 2026. The cohort-level value is `none`: recruitment was
    # unselected, and the baseline 74/362 belongs to that whole cohort. The
    # pension exclusion is a property of the ANALYSIS UNIT, carried by the
    # `pension_excluded` subgroup arm and its analysis_selection_status. An
    # earlier version coded the cohort `selected`, which misstated recruitment.
    "croatia_rlai": (
        "none", "not_applicable",
        "Both, inpatients and outpatients were considered, as long as a change in treatment was indicated. Patients were included irrespective of the reason for the treatment change (e.g. lack of response, side effects, etc.). Eligible patients were aged 18 years or older, met criteria of the diagnostic and statistical manual of mental disorders (4th edition) (DSM-IV) and international classification of diseases (ICD-10) for schizophrenia, schizoaffective disorder or other psychotic disorder, and signed an informed consent document for participation in the study. Patients were enrolled from 16 centres in Croatia, from June, 2007 until February, 2009. Excluded were patients who had a known hypersensitivity to risperidone.",
        "Subjects and Methods, Subjects, p. 264"),
    "kaisyuan_taiwan": (
        "selected", "vocational_service_entry",
        "The criteria for acceptance were PwS who (i) had been diagnosed, (ii) were first undergoing vocational training less than 3 months, (iii) could communicate in Chinese or Taiwanese Hokkien, and (iv) were conscious and able to express their personal opinions. | The participants were from a community rehabilitation center attached to a psychiatric hospital in southern Taiwan that provides vocational training. | For the study's baseline, 14, 31, and 20 participants were in supported employment, sheltered employment, and unpaid job training, respectively.",
        "Methods, Study Design and Participants, pp. 167-168; Results, Participants, pp. 170-171"),
    "pp1m_asiapac": (
        "none", "not_applicable",
        "Eligible patients were aged 18-50 years old and diagnosed with schizophrenia within the past 5 years (DSM-IV-TR criteria) ... Patients were enrolled after unsuccessful treatment with prior antipsychotics due to inefficacy, poor tolerability, safety issues, or non-compliance. Exclusions included treatment-resistant schizophrenia, medication-induced psychiatric disorders, recent substance use disorder, or clozapine/LAI use.",
        "Methods 2.2 Patient population, p. 2"),

    # ---- batch 1 ----
    "opus_1998": (
        "none", "not_applicable",
        "Participants were between 18 and 45 years old at the time of inclusion. They had been diagnosed with a first episode of schizophrenia spectrum disorders (F20, F22-25, F28-29) according to the International Classification of Diseases, 10th revision (ICD-10). Participants were excluded if they had received more than 3 months of treatment with antipsychotics before study inclusion. | Corroborated (hansen2024b, p. 2564): 'Participants were between 18 and 45 years of age and had not received more than 12 weeks of consecutive antipsychotic treatment.' Baseline employment was measured, not required: 'Working or studying 126 (30.3)' at baseline (Table 2, p. 4379), so 70% were not working or studying at entry and were retained.",
        "hansen2024, Methods, Study population and design, p. 4375; corroborated hansen2024b, Method, Settings, p. 2564"),
    "nfbc1966": (
        "none", "not_applicable",
        "This study is based on the NFBC 1966 study, which is a general population cohort study concerning 12,068 pregnant women and their 12,058 live-born children in 1966 in the provinces of Oulu and Lapland. This study includes individuals who were alive at the age of 16 years and living in Finland (n = 11,017) ... leading to a sample of 10,277. | Diagnosis of SSD was based on an individual's presence in the national register from 1982 to 2006 ... as well as follow-up of at least five years since the age of illness onset. | Corroborated (majuri2021, p. 1646): 'an unselected, general population sample based on 12,058 live-born children'.",
        "rautio2016, Methods 2.1 Sample, p. 63; corroborated majuri2021, Methods, Sample, p. 1646"),
    "carstairs_1992": (
        "none", "not_applicable",
        "A cohort of 169 patients ... with schizophrenia resident in the high-security State Hospital in Scotland, UK between 25 August 1992 and 13 August 1993, were identified from the 241 patients detained there at that time ... All patients had committed acts of serious violence and were admitted from criminal courts, less secure hospitals or from prison. | Corroborated (thomson2023, p. 3): 'a whole population cohort of 241 patients ... detained within the high secure State Hospital, Carstairs, Scotland'. Baseline employment was recorded, not required: 'Employment status when last in community - Employed 50 (29.6); Unemployed 119 (70.4)' (darjee2017 Table 1, p. 531).",
        "darjee2017, Methods, Sample, p. 526; corroborated thomson2023, Methods, Sample, p. 3"),
    # RESOLVED 12 August 2026, from `unclear` to `selected`. The recheck could
    # only reach `unclear` because fowler2019 states no criteria at all; the
    # authorship group supplied the criterion from the ISREP primary analysis.
    # The provenance caveat travels with the value: Fowler 2009b is paywalled
    # and is NOT held here, so the exact printed wording is still to be
    # confirmed documentarily.
    "isrep_rct": (
        "selected", "baseline_employment_status",
        "Eligibility required being currently unemployed or engaged in fewer than 16 hours per week of paid employment or education. PROVENANCE: this criterion is NOT stated in fowler2019, the report held in this repository, which gives no eligibility criteria and defers to Fowler et al. 2009b, Psychol Med 39:1627-1636. The criterion was supplied by the authorship group on 12 Aug 2026 from the ISREP primary analysis via Cambridge Core, corroborated by the original trial report's account of recruitment on a history of unemployment and poor social outcome. Fowler 2009b is paywalled and NOT held here, so the exact printed wording is pending documentary confirmation when that paper is obtained.",
        "Authorship-group adjudication 12 Aug 2026, citing the ISREP primary analysis (Fowler et al. 2009b, Psychol Med 39:1627-1636). Not verifiable against any PDF currently held."),
    "ips_denmark_rct": (
        "selected", "work_intention_or_readiness",
        "Participants were eligible if they had a diagnosis of schizophrenia, schizotypal disorder, delusional disorder (ICD-10 F20-F29); bipolar disorder (F31); or recurrent depression (F33). All participants were adults (aged 18-64 years) living in 1 of 3 Danish cities ... All were assigned to early-intervention teams or community mental health services. ALL ELIGIBLE PARTICIPANTS EXPRESSED A CLEAR DESIRE IN COMPETITIVE EMPLOYMENT OR EDUCATION and spoke and understood Danish sufficiently well to participate without an interpreter. | NOT baseline unemployment: work history was a STRATIFICATION variable and Table 1 (p. 1236) shows roughly half of each arm had 2+ months of paid work in the previous 5 years. Additionally 100% of each arm sat in Danish labour-market match group 2 or 3, a work-capability classification (Table 1 footnote f).",
        "christensen2019, Methods, Eligibility Criteria, p. 1233"),
}

# --- the dayabandara2026 cohort split ----------------------------------------
# Two prospectively defined, mutually exclusive samples with separate a-priori
# sample-size targets. They cannot share participants by construction, so they
# are two cohorts and not two `subgroup` arms of one. Pilot finding 3.2.
SPLIT_PARENT = "nhsl_colombo"
SPLIT = {
    "fec": {
        "cohort_id": "nhsl_colombo_fep",
        "cohort_name": "unnamed: University Psychiatry Unit, National Hospital of Sri Lanka, first episode cohort (FEC), 2016-2019",
        "diagnosis_group": "fep", "first_episode": "yes", "n_entered": "122",
        "selection_extra": "The first episode cohort (FEC) included patients presenting for the first time to mental health services with a duration of untreated psychosis (DUP) under 12 months, without a period of remission in between, with sustained psychotic symptoms >=1 week.",
    },
    "rec": {
        "cohort_id": "nhsl_colombo_rec",
        "cohort_name": "unnamed: University Psychiatry Unit, National Hospital of Sri Lanka, recurrent/relapsing episode cohort (REC), 2016-2019",
        "diagnosis_group": "schizophrenia", "first_episode": "no", "n_entered": "118",
        "selection_extra": "The recurrent/relapsing episode cohort (REC) comprised patients with a prior diagnosis of schizophrenia presenting with a new episode or relapse.",
    },
}
SPLIT_SELECTION_COMMON = (
    "We recruited participants aged 15-60 years with a diagnosis of schizophrenia "
    "according to ICD-10 Research Diagnostic Criteria (World Health Organization, 1993) "
    "from inpatient and outpatient services. | We excluded patients with substance "
    "induced psychosis, schizoaffective disorder, other primary psychotic disorders, or "
    "significant organic brain disease (including alcohol-related brain damage, dementia, "
    "delirium, or intellectual disability). We included those with other psychiatric or "
    "medical comorbidities."
)
SPLIT_SELECTION_SOURCE = "Methods 2.1 Study design and setting, 2.2 Inclusion and exclusion criteria, 2.3 First episode and relapsing cohorts, all p. 2"

# --- arm-level trial safeguards ----------------------------------------------
# Keyed (cohort_id, arm_id). Observational cohorts answer `not_applicable`,
# which states that the question was considered rather than leaving a blank the
# pool filter would read as a failure.
SAFEGUARDS = {
    ("nz_idi", "cohort"):            ("not_applicable",) * 5,
    ("dk_registers_1998", "cohort"): ("not_applicable",) * 5,
    ("bologna_fep", "cohort"):       ("not_applicable",) * 5,
    ("croatia_rlai", "cohort"):      ("not_applicable",) * 5,
    ("kaisyuan_taiwan", "cohort"):   ("not_applicable",) * 5,
    ("nhsl_colombo_fep", "cohort"):  ("not_applicable",) * 5,
    ("nhsl_colombo_rec", "cohort"):  ("not_applicable",) * 5,
    # Single-arm open-label interventional study. No allocation groups exist, so
    # the three arm-merging safeguards do not arise; the intervention is a
    # licensed antipsychotic with no vocational component, and no weighting or
    # imputation was used ("No imputation methods were employed to preserve the
    # integrity of observed data", Methods 2.4, p. 3).
    ("pp1m_asiapac", "cohort"):      ("not_applicable", "not_applicable", "no",
                                      "not_applicable", "no"),
    # OPUS reports genuine merged whole-cohort figures: "Since the goals of this
    # study are unrelated to the treatment assignment in the OPUS trial, the
    # participants have been merged into one cohort" (hansen2024, p. 4375), with
    # both allocation groups present in the merged table. post_randomisation_
    # selection is `unclear` because the paper never explains how the "entire
    # sample of 416" arises from the 496 who entered: 80 people disappear
    # without a stated rule, and a survivor or linkage restriction cannot be
    # excluded. Silence gets `unclear` here for the same reason it does in the
    # population rule.
    ("opus_1998", "cohort"):         ("yes", "unclear", "no", "yes", "no"),
    ("nfbc1966", "cohort"):          ("not_applicable",) * 5,
    ("carstairs_1992", "cohort"):    ("not_applicable",) * 5,
}
SAFEGUARD_COLS = ["all_original_arms_included", "post_randomisation_selection",
                  "employment_targeted_intervention",
                  "common_construct_across_arms", "selective_reweighting"]

# The darjee2017 denominator adjudication, shared by both any-time rows.
#
# The distinction it turns on: arithmetic agreement establishes the REPORTING
# BASE a source divided by, not the observation process. 169 is demonstrably the
# base; nothing shows employment was observed for all 169, and the paper reports
# complete clinical and social records for only 137. So 169 goes in n_entered,
# n_outcome_observed stays blank, and 137 is not smuggled in as n_assessed
# either, because it describes case-record completeness across a whole domain
# rather than assessment of employment at this endpoint.
DARJEE_NOTE = (
    "DENOMINATOR ADJUDICATED 12 Aug 2026. The paper states NO denominator for any "
    "employment figure. 137 is a data-completeness statement about the clinical and "
    "social domain as a whole (Methods, Completeness of data, p. 528), not an "
    "employment denominator, and the printed percentages rule it out: 10/137 = 7.3% "
    "and 2/137 = 1.5% against the printed 5.9% and 1.2%, whereas 10/169 = 5.9% and "
    "2/169 = 1.2% match. "
    "BUT arithmetic agreement establishes the REPORTING BASE, not the observation "
    "process: it does not show that employment was observed for all 169, and the paper "
    "reports complete clinical and social records for only 137. n_outcome_observed is "
    "therefore left BLANK and 169 recorded as n_entered, the strongly implied "
    "percentage base, pending author confirmation. "
    "137 is NOT recorded as n_assessed: it denotes complete case-record follow-up "
    "across a domain, not assessment of employment at this endpoint. "
    "NOT every social-outcome percentage in that paragraph uses 169: the Abstract's "
    "'18 (12.7%) living independently' implies a base near 142. The employment "
    "percentages match 169; the paragraph as a whole does not use one base. "
    "CONSTRUCT is unclear because the measure is only 'Employment (in paid or unpaid "
    "work, and for how long)' (Methods, Social data, p. 528), so remuneration cannot "
    "be established, and the Abstract calls the same single person 'voluntary "
    "employment' while the Results call it 'supported work'."
)

# --- outcome-row corrections -------------------------------------------------
# Keyed result_id -> {column: value}. Each carries a note recording the source.
OUTCOME_FIXES = {
    "tarricone2017_cohort_t12m_paidoredu": {
        "n_outcome_observed": "135",
        "n_entered": "163",
        "notes": "CORRECTED 11 Aug 2026 (Stage B recheck, human reviewer): denominator was 163, the number RECRUITED. 'One hundred thirty five patients (105 natives and 30 migrants) were still receiving care at 12 months' (Results, Occupational outcome, p. 523); 135/163 = 82.8% matches the Abstract. Construct is paid_or_education because 'Full time study was considered employment' (Methods, Study design, p. 523), so this cannot enter the paid_any pool. PUBLISHED ERROR: 75 described as '53% of those still in contact', but 75/135 = 55.6% (p. 524).",
    },
    "tarricone2017_interrupted_t12m_paidoredu": {
        "notes": "Subgroup of those who interrupted work or study at FEP. Construct is paid_or_education: 'Full time study was considered employment' (Methods, p. 523).",
    },
    # hansen2024: 416 confirmed in four places. It is the denominator of Table 2
    # only (the register column); 143 is the clinical-interview sample and is
    # the denominator of Tables 1 and 3. Do not mix them.
    "hansen2024_cohort_t240m_paidany": {
        "n_entered": "496",
        "notes": "n_outcome_observed = 416 CONFIRMED (Stage B recheck): 'Register data on redeemed antipsychotics were available for all trial participants (n = 416)' (Abstract, p. 4374); Table 2 title p. 4379; Discussion p. 4382; Limitations p. 4383. Table 2 columns 296 + 120 = 416. 143 is the clinical-interview sample (Tables 1 and 3) and must not be substituted. PUBLISHED INCONSISTENCY: Table 2 'Any work' subgroups 84 + 15 = 99 against the printed total 105 (and 'Work' 49 + 3 = 52 against 54); every cell matches its own percentage, so total and parts cannot both be right. This is the paid_any numerator for opus_1998. UNEXPLAINED: the step from 496 entered to 416 with register data is never described.",
    },
    "hansen2024_cohort_t240m_paidcomp": {
        "n_entered": "496",
        "notes": "PUBLISHED INCONSISTENCY: Table 2 'Work' subgroups 49 + 3 = 52 against the printed total 54 (p. 4379).",
    },
    # rautio2016: the brief's premise was WRONG and the recheck corrected it.
    "rautio2016_cohort_age44_45_paidintensity25": {
        "outcome_construct": "paid_intensity_threshold",
        "result_role": "derived",
        "ascertainment_window_months": "24",
        "n_entered": "161",
        "n_female": "71",
        "n_female_denominator": "161",
        "derivation_component_result_ids": "rautio2016_cohort_age44_45_band_25_49;rautio2016_cohort_age44_45_band_50_74;rautio2016_cohort_age44_45_band_75plus",
        "derivation_justification": "Sum of the three printed working-day bands above the paper's 25% threshold (5 + 5 + 8 = 18), one shared denominator of 161, mutually exclusive. The paper prints '11.2%' but never prints the count 18, so this is a sum of printed counts and not a back-calculation from a percentage.",
        "notes": "CONSTRUCT CORRECTED 11 Aug 2026: this is NOT paid_any. The paper's measure is 'employed if they had been working for at least 25% of the working days' (Methods 2.2.1, p. 63). The lowest band is '<25.0%', NOT '0%', so it pools people with no working days at all together with people who worked 1-24.9% of working days. The number in ANY paid work is therefore NOT RECOVERABLE from this paper: bounds are 18 <= paid_any <= 161. Do not interpolate. Ascertainment is period prevalence over a 24-month window (1 Jan 2010 to 31 Dec 2011, at age 44-45), not point prevalence. followup_months is not a fixed post-onset horizon: follow-up since onset averaged 17.5 years and varied.",
    },
    # Superseded on 12 August 2026. The first version of this note recorded 169
    # as the observed denominator and claimed every other social-outcome
    # percentage in the paragraph matches 169. Both were wrong: arithmetic
    # agreement identifies the base the authors divided by, not the process by
    # which employment was observed, and the Abstract's "18 (12.7%) living
    # independently" implies a base near 142, not 169.
    "darjee2017_sz_t120m_paidsupp_ever": {
        "n_outcome_observed": "",
        "n_assessed": "",
        "n_entered": "169",
        "denominator_basis": "unclear",
        "notes": DARJEE_NOTE,
    },
    "darjee2017_sz_t120m_paidcomp_ever": {
        "n_outcome_observed": "",
        "n_assessed": "",
        "n_entered": "169",
        "denominator_basis": "unclear",
        "notes": DARJEE_NOTE,
    },
    "darjee2017_sz_t120m_paidcomp": {
        "n_outcome_observed": "", "n_assessed": "", "denominator_basis": "unclear",
    },
    "darjee2017_sz_t120m_paidsupp": {
        "n_outcome_observed": "", "n_assessed": "", "denominator_basis": "unclear",
    },
    "fowler2019_tau_t24m_paidany": {
        "notes": "PUBLISHED INCONSISTENCY: the Abstract states 50 (86%) followed up, but the Method, Table 1 and the CONSORT diagram all give 66 of 77 (37 TAU + 29 SRT), and 86% only works for 66/77.",
    },
    "christensen2019_ips_t18m_paidoredu": {
        "notes": "Denominator deliberately BLANK: the paper never prints the denominators for the 'Employment or education at some point' row (Table 2, p. 1237). 112/243 = 46.1%, not the printed 59.9%, so 243 is not the denominator. The composite is limited by interview participation because education was self-reported at the 18-month interview while employment came from DREAM with complete coverage. Implied interview denominators elsewhere are 187/171/170 (Table 3, p. 1238) against a flowchart giving 186/170/165, and the flowchart lists 243 in an arm that randomised 239. Author query raised.",
    },
    "lin2026_pp1m_t12m_paidcomp": {
        "denominator_basis": "outcome_observed",
        "missing_data_method": "complete_case",
        "n_entered": "521",
        "notes": "12-month landmark, Supplementary Table S3. ATTRITION IS INFORMATIVE: denominators are observed cases falling from 390 (month 3) to 280 (month 18); 521 enrolled, 474 provided employment data (Methods 2.2, p. 2). 'No imputation methods were employed' (Methods 2.4, p. 3). The available-case assumption is doing real work here and the prespecified missing-outcome bounding analyses (SAP section 6) apply. Employment defined as 'either full-time or part-time employment'; casual and sheltered work explicitly excluded to 'Others' (Table 1 footnote, p. 3).",
    },
}

# Employment construct for the dayabandara rows. The Table 4 'Employed' row is
# never defined anywhere in the paper, and codebook line 240 requires `unclear`
# with the wording preserved rather than a guess in either direction.
DAYABANDARA_CONSTRUCT_NOTE = (
    "CONSTRUCT UNCLEAR: the Table 4 'Employed' category is never defined. It is "
    "separated from 'Homemaker', which implies paid work, but remuneration and "
    "labour-market setting are never established (codebook l. 240). The only "
    "employment definition in the paper belongs to the recovery composite and is "
    "broader: 'gainful employment (employed, studying, volunteering, or meaningful "
    "household contribution) during the preceding 6 months' (Methods 2.5, p. 2). "
    "Supplementary File-1 (cited Methods 2.6, p. 2) is not held and should be "
    "obtained before the construct is finalised. "
    "DENOMINATOR DERIVED by exact subtraction of the printed 'Missing data' row; "
    "Table 4's four categories are mutually exclusive and sum exactly to the "
    "column N at every timepoint, so this is exact, not an imputation."
)


# --- period-prevalence measurement windows -----------------------------------
# Each is read off the outcome_verbatim already recorded, not inferred: the
# window is what distinguishes period prevalence from point prevalence, and
# without it a row cannot be placed in either synthesis. Recording the verbatim
# at extraction time is precisely what makes this recoverable without reopening
# the PDFs.
WINDOWS = {
    # "... 50% of the past year before the 20-year follow-up"
    "hansen2024_cohort_t240m_paidcomp": "12",
    "hansen2024_cohort_t240m_paidany": "12",
    "hansen2024_cohort_t240m_paidcomp_assessed": "12",
    "hansen2024_cohort_t240m_paidany_assessed": "12",
    "hansen2024b_cohort_t240m_paidcomp": "12",
    "hansen2024b_cohort_t240m_paidany": "12",
    # "... in the year following the end of the intervention"
    "fowler2019_tau_t24m_paidany": "12",
    "fowler2019_srt_t24m_paidany": "12",
    "fowler2019_tau_nonaff_t24m_paidany": "12",
    "fowler2019_srt_nonaff_t24m_paidany": "12",
    "fowler2019_tau_aff_t24m_paidany": "12",
    "fowler2019_srt_aff_t24m_paidany": "12",
    # "... employment for more than 6 months in year 5" / NEET in year 5
    "cunningham2025_cohort_t60m_paidany": "12",
    "cunningham2025_maori_t60m_paidany": "12",
    "cunningham2025_nonmaori_t60m_paidany": "12",
    "cunningham2025_cohort_t60m_paidoredu": "12",
    "cunningham2025_maori_t60m_paidoredu": "12",
    "cunningham2025_nonmaori_t60m_paidoredu": "12",
    # A person-week binary summed across the whole 10-year follow-up. The paper
    # itself says this is not point prevalence: it "represents the longitudinal
    # proportion across all person-weeks during follow-up, reflecting cumulative
    # engagement over time rather than point prevalence at cohort entry"
    # (Table 1 caption, p. 5).
    "twumasi2026_cohort_t120m_paidoredu_pw": "120",
}

# --- new component rows -------------------------------------------------------
# The three printed working-day bands above rautio2016's 25% threshold. They are
# `component` rows: real extracted evidence that can never enter a pool, because
# pooling a band alongside the total it feeds would count the same participants
# twice. Table 1, p. 63; the four bands sum to exactly 161.
NEW_COMPONENT_ROWS = [
    ("rautio2016_cohort_age44_45_band_25_49", "25.0-49.9%", "5"),
    ("rautio2016_cohort_age44_45_band_50_74", "50.0%-74.9%", "5"),
    ("rautio2016_cohort_age44_45_band_75plus", ">=75.0%", "8"),
]
COMPONENT_TEMPLATE_FROM = "rautio2016_cohort_age44_45_paidintensity25"


def read(name):
    with open(os.path.join(DATA, name), newline="", encoding="utf-8") as fh:
        rdr = csv.DictReader(fh)
        return list(rdr.fieldnames), list(rdr)


def write(name, header, rows):
    with open(os.path.join(DATA, name), "w", newline="", encoding="utf-8") as fh:
        w = csv.DictWriter(fh, fieldnames=header, lineterminator="\n")
        w.writeheader()
        for r in rows:
            w.writerow({k: r.get(k, "") for k in header})


def note_append(row, text):
    cur = (row.get("notes") or "").strip()
    if text in cur:
        return False
    row["notes"] = (cur + " | " + text) if cur else text
    return True


def main(check_only):
    changes = []
    ch, cohorts = read("extraction_cohorts.csv")
    ah, arms = read("extraction_arms.csv")
    oh, outcomes = read("extraction_outcomes.csv")
    mh, cmap = read("report_cohort_map.csv")

    # --- 1. split the dayabandara cohort -------------------------------------
    parent = [c for c in cohorts if c["cohort_id"] == SPLIT_PARENT]
    if parent:
        base = parent[0]
        for arm_id, spec in SPLIT.items():
            new = dict(base)
            new["cohort_id"] = spec["cohort_id"]
            new["cohort_name"] = spec["cohort_name"]
            new["diagnosis_group"] = spec["diagnosis_group"]
            new["first_episode"] = spec["first_episode"]
            new["overlap_notes"] = (
                "Split from the former single cohort `nhsl_colombo` on 11 Aug 2026. "
                "The FEC and REC are prospectively defined, mutually exclusive samples "
                "with separate a-priori sample-size targets ('The required sample size "
                "was 115 per cohort', Methods 2.2, p. 2), so they cannot share "
                "participants and are two cohorts rather than two subgroup arms.")
            new["employment_selection_status"] = "none"
            new["employment_selection_reason"] = "not_applicable"
            new["employment_selection_verbatim"] = (
                SPLIT_SELECTION_COMMON + " | " + spec["selection_extra"])
            new["employment_selection_source"] = SPLIT_SELECTION_SOURCE
            cohorts.append(new)
            changes.append("cohort split: added %s" % spec["cohort_id"])
        cohorts = [c for c in cohorts if c["cohort_id"] != SPLIT_PARENT]
        changes.append("cohort split: retired %s" % SPLIT_PARENT)

        # arms: the two subgroups become whole recruited cohorts
        for a in arms:
            if a["cohort_id"] == SPLIT_PARENT and a["arm_id"] in SPLIT:
                was = a["arm_id"]
                spec = SPLIT[was]
                a["cohort_id"] = spec["cohort_id"]
                a["arm_id"] = "cohort"
                a["arm_type"] = "cohort"
                a["n_entered"] = spec["n_entered"]
                changes.append("arm: %s/%s -> %s/cohort (arm_type cohort)"
                               % (SPLIT_PARENT, was, spec["cohort_id"]))
        # outcomes: repoint, and record the construct problem
        for o in outcomes:
            if o["cohort_id"] == SPLIT_PARENT:
                which = "fec" if "_fec_" in o["result_id"] else "rec"
                o["cohort_id"] = SPLIT[which]["cohort_id"]
                o["arm_id"] = "cohort"
                o["outcome_construct"] = "unclear"
                o["denominator_basis"] = "outcome_observed"
                note_append(o, DAYABANDARA_CONSTRUCT_NOTE)
                changes.append("outcome %s -> %s, construct unclear"
                               % (o["result_id"], SPLIT[which]["cohort_id"]))
        for m in cmap:
            if m["cohort_id"] == SPLIT_PARENT:
                m["cohort_id"] = SPLIT["fec"]["cohort_id"]
                cmap.append({"report_id": m["report_id"],
                             "cohort_id": SPLIT["rec"]["cohort_id"],
                             "relationship": "describes",
                             "contributes_results": "yes",
                             "notes": "second of two parallel samples in one report"})
                changes.append("report_cohort_map: dayabandara2026 now maps to both samples")
                break

    # --- 2. employment selection, per cohort ---------------------------------
    for c in cohorts:
        spec = SELECTION.get(c["cohort_id"])
        if not spec:
            continue
        if c.get("employment_selection_status") == spec[0]:
            continue
        c["employment_selection_status"] = spec[0]
        c["employment_selection_reason"] = spec[1]
        c["employment_selection_verbatim"] = spec[2]
        c["employment_selection_source"] = spec[3]
        changes.append("selection: %s -> %s / %s" % (c["cohort_id"], spec[0], spec[1]))

    # --- 3. lin2026 single-arm reclassification ------------------------------
    for a in arms:
        if a["cohort_id"] == "pp1m_asiapac" and a["arm_type"] == "intervention":
            a["arm_id"] = "cohort"
            a["arm_type"] = "cohort"
            a["n_entered"] = "521"
            changes.append("arm: pp1m_asiapac single-arm study -> arm_type cohort")
    for o in outcomes:
        if o["cohort_id"] == "pp1m_asiapac":
            o["arm_id"] = "cohort"

    # --- 4. trial safeguards --------------------------------------------------
    for a in arms:
        key = (a["cohort_id"], a["arm_id"])
        vals = SAFEGUARDS.get(key)
        if not vals:
            continue
        if all(a.get(col) == v for col, v in zip(SAFEGUARD_COLS, vals)):
            continue
        for col, v in zip(SAFEGUARD_COLS, vals):
            a[col] = v
        changes.append("safeguards: %s/%s" % key)

    # --- 4b. rautio2016 band component rows ----------------------------------
    have = {o["result_id"] for o in outcomes}
    tmpl = next((o for o in outcomes if o["result_id"] == COMPONENT_TEMPLATE_FROM), None)
    if tmpl is not None:
        for rid, label, n in NEW_COMPONENT_ROWS:
            if rid in have:
                continue
            row = dict(tmpl)
            row["result_id"] = rid
            row["result_role"] = "component_only"
            row["outcome_construct"] = "paid_intensity_threshold"
            row["outcome_verbatim"] = (
                "Working days during the last two years of follow-up, band '%s' "
                "(Table 1 row label). Employment defined as 'working for at least "
                "25%% of the working days'." % label)
            row["n_employed"] = n
            row["n_outcome_observed"] = "161"
            row["ascertainment"] = "period_prevalence"
            row["ascertainment_window_months"] = "24"
            row["source_locator"] = "Table 1, p. 63"
            row["derivation_component_result_ids"] = ""
            row["derivation_justification"] = ""
            row["notes"] = ("Component of the derived >=25%-of-working-days total. "
                            "Never enters a pool in its own right.")
            outcomes.append(row)
            changes.append("component row added: %s (n=%s)" % (rid, n))

    # --- 4c. period-prevalence windows ---------------------------------------
    for o in outcomes:
        w = WINDOWS.get(o["result_id"])
        if w and o.get("ascertainment_window_months") != w:
            o["ascertainment_window_months"] = w
            changes.append("window: %s = %s months" % (o["result_id"], w))

    # --- 5. outcome-row corrections ------------------------------------------
    for o in outcomes:
        fix = OUTCOME_FIXES.get(o["result_id"])
        if not fix:
            continue
        for col, val in fix.items():
            if col == "notes":
                if note_append(o, val):
                    changes.append("note: %s" % o["result_id"])
            elif o.get(col) != val:
                o[col] = val
                changes.append("fix: %s.%s = %s" % (o["result_id"], col, val))

    if not changes:
        print("nothing to do: Stage B batch 2 already applied")
        return 0
    for c in changes:
        print(("would apply: " if check_only else "applied: ") + c)
    if not check_only:
        write("extraction_cohorts.csv", ch, cohorts)
        write("extraction_arms.csv", ah, arms)
        write("extraction_outcomes.csv", oh, outcomes)
        write("report_cohort_map.csv", mh, cmap)
    else:
        print("\n--check: no files written")
    return 0


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true")
    args = ap.parse_args()
    os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    sys.exit(main(args.check))
