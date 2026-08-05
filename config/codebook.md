# Extraction codebook

**Review:** Employment Rates and Moderators in Psychosis (PROSPERO CRD420251008448)
**Version:** 0.1, 5 August 2026

Read this before extracting anything. The statistical analysis plan (`docs/statistical_analysis_plan.md`) explains *why* the fields are what they are; this document explains *how* to fill them in.

**Before you commit any extraction, run:**

```
Rscript R/01_validate_data.R
```

It checks every rule below and stops on the first violation, naming the column, the row and the permitted values. It is quicker to run it than to have an error found three weeks later.

---

## The four when-in-doubt rules

These resolve most questions.

1. **Record the paper's own wording and let a reviewer categorise.** Every categorical field has a `_verbatim` companion or a `notes` column. If the paper says "engaged in remunerative activity", put that in the verbatim field and pick the closest category. Do not paraphrase into a category and lose the original.
2. **Never impute a denominator.** If a paper reports "42 per cent employed" with no usable denominator, leave `n_employed` and `n_outcome_observed` blank and say so in `notes`. Do not back-calculate from a percentage: rounding makes the reconstructed count wrong, and a wrong count is worse than a missing one because the model believes it.
3. **Never compute a percentage. Record the count.** The analysis needs numerators and denominators, not proportions.
4. **Flag rather than guess.** A blank field with a note is recoverable. A confidently wrong value is not.

---

## Table structure

Five linked CSV files in `data/`. They are linked, not one wide sheet, because a single row per publication cannot represent a study with three arms measured at four timepoints without either repeating study-level fields twelve times or inventing unbounded numbers of columns.

```
extraction_reports.csv    one row per publication
      |
      +-- extraction_cohorts.csv   one row per group of participants
                |
                +-- extraction_arms.csv      one row per arm within a cohort
                          |
                          +-- extraction_outcomes.csv   one row per RESULT
                                    |
                                    +-- extraction_rob.csv   one row per RoB domain judgement
```

**A report is not a cohort.** This distinction is the single most important thing in this codebook. One group of participants can produce many papers: OPUS, AESOP, RAISE, the Chicago Follow-up Study, the Northern Finland Birth Cohort and the Nordic registers all do. If you treat each paper as an independent study, the same people are counted several times and every confidence interval comes out too narrow.

### Known multi-report cohorts

Watch for these. The list is not exhaustive; add to it as you find more.

| Cohort | Typical markers |
|---|---|
| OPUS trial (Denmark) | Nordentoft, Albert, Hansen, Stürup, Melau; 1998 to 2000 recruitment; 1, 2, 5, 10, 20 year follow-ups |
| Northern Finland Birth Cohort 1966 | Majuri, Jääskeläinen, Isohanni, Miettunen |
| Danish national registers | Sturup, Pedersen, Bonnesen, Twumasi; whole-population linkage |
| Finnish national registers | Hakulinen, Suvisaari; often case-control against matched controls |
| Swedish national registers | Falk, Topor, Strålin |
| AESOP and AESOP-10 (UK) | Morgan, Fearon, Dazzan; London, Nottingham, Bristol |
| RAISE-ETP and OnTrackNY (USA) | Kane, Nossel, Robinson, Dixon |
| Chicago Follow-up Study | Harrow, Jobe, Jones; 20-year prospective |
| Hong Kong JCEP / EASY | Chan, Chang, Hui, Chen |
| EPPIC / Orygen (Australia) | Killackey, McGorry, Cotton |

If two reports share a cohort, they share a `cohort_id`. Give the cohort a stable slug such as `opus_denmark` or `nfbc1966`, not the first author's name.

---

## `extraction_reports.csv`

One row per publication in the source folder.

| Column | Required | Notes |
|---|---|---|
| `report_id` | yes | Lowercase author plus year, e.g. `hansen2024`. A letter suffix disambiguates: `hansen2024b` |
| `first_author` | yes | Surname only |
| `year` | yes | Publication year |
| `doi` | no | Blank if the paper has none |
| `title` | no | |
| `journal` | no | |
| `source_filename` | yes | Exact filename in `Data Extraction Papers/` |
| `eligibility_status` | yes | See vocabulary below |
| `exclusion_reason` | yes | `not_applicable` unless status is `exclude` |
| `cohort_id` | no | Blank until the cohort is identified |
| `cohort_overlap_notes` | no | Free text. Say which other report shares the sample |
| `notes` | no | |

**`eligibility_status`**

| Value | When |
|---|---|
| `include` | Meets all criteria and contributes at least one result |
| `exclude` | Assessed and does not meet criteria. `exclusion_reason` becomes required |
| `linked_report` | The participants are eligible, but the result used comes from another report of the same cohort |
| `supplement_only` | Supplementary material for another paper, not an article in its own right |
| `duplicate` | The same article appears more than once in the folder |
| `pending` | Not yet adjudicated |

**`exclusion_reason`**: `wrong_population`, `wrong_outcome`, `wrong_design`, `no_extractable_data`, `secondary_psychosis`, `duplicate_report`, `not_applicable`.

---

## `extraction_cohorts.csv`

One row per group of participants.

| Column | Required | Notes |
|---|---|---|
| `cohort_id` | yes | Stable slug, e.g. `opus_denmark` |
| `cohort_name` | yes | The name as published, e.g. "OPUS trial". If unnamed, `unnamed: <city/service>, <recruitment years>` |
| `design` | yes | See below |
| `country_iso3` | yes | Three-letter code; `MULTI` for multinational |
| `region` | yes | See `config/vocabularies.yml` |
| `country_income_level` | yes | `high`, `upper_middle`, `lower_middle`, `low` |
| `income_year` | no | Which World Bank classification year you used. It changes |
| `diagnosis_group` | yes | `fep`, `schizophrenia`, `psychosis_mixed`, `chr`, `smi_mixed` |
| `diagnostic_instrument` | no | SCID, ICD-10 codes, CASH, OPCRIT, register diagnosis |
| `diagnosis_confirmed` | no | How diagnosis was verified |
| `perc_qualifying_diagnosis` | no | Percentage with a qualifying psychosis diagnosis. Needed when the sample is mixed |
| `first_episode` | no | `yes`, `no`, `mixed` |
| `subgroup_extractable` | no | `yes`/`no`. Whether a psychosis subgroup can be pulled out of a mixed sample |
| `setting` | yes | `eip`, `community_smh`, `inpatient`, `registry`, `forensic`, `mixed_unclear` |
| `recruitment_start` / `recruitment_end` | no | Years |
| `overlap_notes` | no | Other cohorts this one may share participants with |

**`design`**: `prospective_cohort`, `retrospective_cohort`, `register_cohort`, `rct`, `cluster_rct`, `non_randomised_trial`, `cross_sectional`, `other`.

`setting` is **single-valued**. The old schema had three yes/no flags for first-episode, community and inpatient, and the one extracted study had all three set to 1, which carries no information at all. Pick the one that best describes where participants were recruited, and use `mixed_unclear` honestly when you cannot.

---

## `extraction_arms.csv`

One row per arm. An observational cohort has exactly one arm, with `arm_id = cohort` and `arm_type = cohort`.

| Column | Required | Notes |
|---|---|---|
| `cohort_id` | yes | Must exist in `extraction_cohorts.csv` |
| `arm_id` | yes | Short slug unique within the cohort: `cohort`, `tau`, `ips`, `ips_plus_cr` |
| `arm_type` | yes | See below |
| `intervention_name` | no | Required when `arm_type` is `intervention` or `control_active` |
| `intervention_description` | no | One sentence |
| `cluster_randomised` | no | `yes`, `no`, `unclear` |
| `n_clusters` | no | Number of sites or teams, if cluster randomised |
| `icc_reported` | no | Intracluster correlation, if given |
| `baseline_unemployed_required` | no | `yes`/`no`. **Critical.** See below |
| `baseline_wants_work_required` | no | `yes`/`no` |
| `n_entered` | no | Number randomised or entering this arm |

**`arm_type`**

| Value | Meaning |
|---|---|
| `cohort` | The whole observational cohort. **The only type in the primary prevalence pool** |
| `control_tau` | Trial arm receiving treatment as usual, no active vocational component |
| `control_active` | Trial arm receiving an active comparator, which may itself be vocational |
| `intervention` | Trial arm receiving the intervention under test |
| `subgroup` | A non-randomised subgroup reported separately |

**Why `baseline_unemployed_required` matters.** Vocational trials usually enrol only people who are unemployed and want to work. Their follow-up employment rate is therefore not comparable to a cohort's: the denominator has been selected. Always record this, for cohorts as well as trials.

---

## `extraction_outcomes.csv`

**One row per result.** A result is one construct, measured on one arm, at one timepoint. A paper reporting competitive employment and any paid employment at 12 and 24 months for two arms produces eight rows.

| Column | Required | Notes |
|---|---|---|
| `result_id` | yes | Unique, e.g. `hansen2024_cohort_t120m_paidany` |
| `report_id` | yes | Must exist in `extraction_reports.csv` |
| `cohort_id` | yes | Must exist in `extraction_cohorts.csv` |
| `arm_id` | yes | The pair (`cohort_id`, `arm_id`) must exist in `extraction_arms.csv` |
| `followup_months` | yes | **Months, not years.** 5 years is 60 |
| `outcome_construct` | yes | See below |
| `outcome_verbatim` | yes | The paper's own definition, quoted |
| `ascertainment` | yes | See below |
| `n_employed` | yes | Count, not a percentage |
| `n_outcome_observed` | yes | **The primary denominator.** Those whose status was actually observed |
| `n_assessed` | no | Approached and assessed |
| `n_alive_eligible` | no | Alive and still eligible at this timepoint |
| `n_entered` | no | Randomised or entering the cohort |
| `denominator_basis` | no | Which of the above the paper's own analysis used |
| `missing_data_method` | no | How the paper handled missing outcomes |
| `source_locator` | yes | **Required.** e.g. `Table 2, p. 1147`. Field-level, not row-level |
| `adjusted_effect` / `adjusted_se` / `adjusted_measure` | no | For cluster trials or covariate-adjusted results |
| `mean_age`, `perc_female`, `perc_post_secondary`, `perc_employed_baseline` | no | Arm-level moderators |
| `notes` | no | |

### The five denominators

This is the part most often got wrong. Record whichever the paper gives; leave the rest blank.

```
n_entered            100 people entered the cohort
n_alive_eligible      94 alive and still eligible at 12 months
n_assessed            81 were approached and assessed
n_outcome_observed    78 had employment status actually recorded   <-- the denominator we model
n_employed            19 of those 78 were employed
```

A proportion computed on each of these answers a different question, which is why one generic `n_analysed` is not enough.

### `outcome_construct`

| Value | Meaning |
|---|---|
| `paid_any` | **The primary construct.** Any work for pay: competitive, supported or sheltered |
| `paid_competitive` | Open labour market, at or above minimum wage, not reserved for people with disabilities |
| `paid_supported_sheltered` | Supported or sheltered work only |
| `paid_or_education` | Paid work **or** enrolment in education or training |
| `vocational_activity` | Any vocational activity including unpaid and voluntary |
| `education_only` | Education or training only |
| `unclear` | The paper does not define what it counted |

**Education is not employment in this review.** A paper reporting "in work or education" is `paid_or_education`, a secondary outcome. If the paper also gives paid work separately, extract that too as its own row. This matters: combining work with education produces a number that tracks a country's education system rather than its labour market.

### `ascertainment`

| Value | Meaning | Primary pool |
|---|---|---|
| `point_prevalence` | Employed **at** the timepoint | Yes |
| `period_prevalence` | Employed during a window, e.g. a tax year | No, sensitivity only |
| `any_time_during_followup` | Ever employed across the whole follow-up | No |
| `unclear` | Cannot be determined | No |

Registers very often report `period_prevalence` ("employed in the year preceding the index date") while looking like point prevalence. Read the methods, not the table heading. Getting this wrong inflates the pooled estimate.

---

## `extraction_rob.csv`

One row per domain judgement, per result. Risk of bias attaches to a **result**, not to a paper: one report can contribute both a prevalence estimate and a treatment effect, and those need different instruments.

| Column | Required |
|---|---|
| `rob_assessment_id` | yes |
| `result_id` | yes |
| `rob_tool` | yes |
| `rob_tool_version` | no |
| `domain` | yes |
| `signalling_responses` | no |
| `judgement` | yes |
| `rationale` | no, but strongly expected |
| `source_location` | no |
| `assessor` | yes |
| `checker` | no |
| `bias_direction` | no |

**Choose the instrument by what the result is**, not by what the study is:

| The result is | Instrument |
|---|---|
| A prevalence from an observational cohort | `jbi_prevalence` |
| An effect from a randomised comparison | `rob2` |
| An effect from a non-randomised intervention study | `robins_i` |

Judgements are validated against the instrument and are never mixed:

- `jbi_prevalence`: `yes`, `no`, `unclear`, `not_applicable`
- `rob2`: `low`, `some_concerns`, `high`
- `robins_i`: `low`, `moderate`, `serious`, `critical`, `no_information`

`some_concerns` is a RoB 2 category and is **not** valid for ROBINS-I. The existing supplementary table in the MSc material makes exactly this mistake, which is why those judgements are being redone rather than reused.

---

## Fields you must never type

These are computed in `R/lib_data.R` and the validator rejects the file if it finds them as columns: `p_obs`, `horizon`, `followup_years`, `prop_unobserved`.

If code can answer, code answers. A typed percentage that disagrees with its own numerator and denominator is a silent error nobody catches.

---

## Worked example

Hansen et al. 2024, the 20-year OPUS follow-up.

`extraction_reports.csv`
```
hansen2024,Hansen,2024,10.1017/S0033291724002678,"Use and discontinuation of antipsychotic medication...",Psychological Medicine,S0033291724002678a.pdf,include,not_applicable,opus_denmark,"Shares participants with hansen2024b and all other OPUS reports",
```

`extraction_cohorts.csv`
```
opus_denmark,OPUS trial,rct,DNK,europe_north,high,2024,fep,ICD-10 F20-F29,clinical interview,100,yes,yes,community_smh,1998,2000,"20-year follow-up of the OPUS randomised trial"
```

`extraction_arms.csv`
```
opus_denmark,cohort,cohort,,,no,,,no,no,547
```
Note: where a trial is being used as a whole-cohort prevalence source at long follow-up, and the original allocation is no longer meaningful, record one `cohort` arm and explain in `intervention_description`. If the arms remain distinct at that timepoint, record them separately instead and let the analysis decide.

`extraction_outcomes.csv`
```
hansen2024_cohort_t240m_paidany,hansen2024,opus_denmark,cohort,240,paid_any,"in paid employment at 20-year follow-up",point_prevalence,<count>,<count>,,,,outcome_observed,complete_case,"Table 3, p. 4379",,,,...
```

Values shown as `<count>` must be read from the paper. They are deliberately not filled in here so that this example cannot be copied as data.

---

## Common mistakes

| Mistake | Why it matters |
|---|---|
| One row per paper instead of one row per result | Loses every timepoint and arm but one |
| Treating each paper as an independent study | Counts the same participants repeatedly and narrows every interval |
| Putting years in `followup_months` | A 5 becomes five months instead of sixty |
| Back-calculating a count from a percentage | Rounding makes it wrong, and the model treats it as exact |
| Counting "work or education" as employment | Different construct, different estimand |
| Reading `period_prevalence` as `point_prevalence` | Inflates the pooled estimate |
| Using `some_concerns` with ROBINS-I | Mixes two instruments' scales |
| Leaving `source_locator` blank | Nobody can check the value, including you in six weeks |
