# Extraction codebook

**Review:** Employment Rates and Moderators in Psychosis (PROSPERO CRD420251008448)
**Version:** 0.2 decision specification, 11 August 2026

**Version 0.3, 12 August 2026.** The implementation gate recorded in v0.2 is **closed**: the CSV headers, `config/vocabularies.yml`, `config/analysis.yml`, the validator, the pool builder and the tests now implement these rules, and `Rscript R/01_validate_data.R .` plus `Rscript tests/testthat.R` both pass against them.

**Stage F is complete and the governance gate is closed apart from the frozen commit.** The search closed 9 June 2026 and the report universe is frozen at the 90 screened reports (`DATA_EXTRACTION_FINAL.xlsx` and the 90 PDFs are authoritative). SAP v0.2 and the Stage B adjudications are ratified and the PROSPERO amendment is submitted as version 4.0.

**Rules added after v0.3 was written, during Stage F. Read these before using this document as a specification:**

- **D12.7** — risk-of-bias domain slugs are a controlled vocabulary (`rob_domain`), and every domain of the chosen instrument is required for every result.
- **D12.8** — `followup_basis` gained `calendar_end_common` and `since_baseline_mean`. Four values now bar a horizon and they mean different things.
- **D13** — the 50 per cent diagnosis rule is sufficient on its own for a whole `smi_mixed` cohort; subgroup extractability is not an additional requirement.
- **D14** — a whole-analysis-unit count may be derived by summing across mutually exclusive subgroups that exhaust the observed-case analysis population, with their denominators summing exactly to the derived one. `conflict_status = resolved` requires an authority, never an extractor's own reconstruction.

Changes in v0.3, all from the pilot rechecks and all recorded in `docs/methods_deviations.md` D12: the intensity-band rule was **rewritten** after it was disproved, `paid_intensity_threshold` and `paid_or_education` were added, `component` became `component_only`, and `followup_basis` and `conflict_status` were introduced.

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

### `report_cohort_map.csv` is the authority for the report-to-cohort relation

`extraction_reports.csv` carries a single `cohort_id` column, which **cannot express one report describing two independently recruited cohorts**. `data/report_cohort_map.csv` is the authoritative many-to-many table, and the validator requires that every (report, cohort) pair producing a result appears in it.

| Column | Notes |
|---|---|
| `report_id`, `cohort_id` | Both must exist in their own tables |
| `relationship` | `describes`, `secondary_analysis`, `validation_sample`, `overlaps_with` |
| `contributes_results` | `yes`/`no` |
| `notes` | |

`validation_sample` matters: `leighton2019` validates a prediction model on the OPUS cohort, and its OPUS figures must **not** be pooled alongside `hansen2024`.

**Extraction batches are formed from the connected components of this map**, so every report bearing on one result-selection decision is read together. A report separated from its cohort siblings cannot make that decision correctly.

### Parallel cohorts get separate cohort identifiers

Two independently recruited samples described in one report are **two cohorts**, not two `subgroup` arms of one. Reserve `subgroup` for a post-hoc split of a single recruited sample.

`dayabandara2026` is the case: its first-episode and recurrent-episode cohorts have mutually exclusive prospectively applied entry definitions and a separate a-priori sample-size target each, so they cannot share participants. Coding them as two subgroup arms lost the 12-month result entirely, and produced a spurious "99/240" that belongs to neither sample.

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
| `employment_selection_status` | yes for primary eligibility | `none`, `selected`, `unclear`. See below |
| `employment_selection_reason` | yes when selected or unclear | Concise classification: baseline status, work intention/readiness, vocational-service entry, placement, prior employment failure, other, or incomplete reporting |
| `employment_selection_verbatim` | yes for primary eligibility | Eligibility or recruitment wording copied from the source |
| `employment_selection_source` | yes for primary eligibility | Page, table, supplement or protocol location supporting the classification |

**`design`**: `prospective_cohort`, `retrospective_cohort`, `register_cohort`, `rct`, `cluster_rct`, `non_randomised_trial`, `cross_sectional`, `other`.

`setting` is **single-valued**. The old schema had three yes/no flags for first-episode, community and inpatient, and the one extracted study had all three set to 1, which carries no information at all. Pick the one that best describes where participants were recruited, and use `mixed_unclear` honestly when you cannot.

### Employment-related selection

Selection is classified for the recruited sample, before looking at the employment proportion. Use `selected` when eligibility, enrolment or the analysed denominator is restricted by baseline employment or unemployment, wanting or readiness to work, an employment goal, vocational-service eligibility or participation, current vocational placement, or previous employment failure. Use `none` only after sufficiently complete eligibility and recruitment information has been checked. If the methods are incomplete, use `unclear`; absence of a reported restriction is not automatically evidence of absence.

Only `none` can enter the primary prevalence pool. `selected` remains eligible for intervention-effect synthesis or a separately labelled selected-population analysis. `unclear` is excluded from the primary and included only in a named sensitivity analysis. Record the decision from eligibility information, never from whether the observed employment rate looks unusually high or low.

---

## `extraction_arms.csv`

One row per arm or whole-cohort analysis unit. `arm_type = cohort` means the whole recruited cohort and does **not** imply an observational parent design. An observational study normally has one such row. A trial-derived whole-cohort row is permitted only under the safeguards below; allocated trial arms remain separate rows.

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
| `baseline_unemployed_required` | yes for primary eligibility during schema transition | `yes`, `no`, `unclear`. Detailed component of the cohort-level selection decision |
| `baseline_wants_work_required` | yes for primary eligibility during schema transition | `yes`, `no`, `unclear`. Includes an explicit work goal or readiness requirement only when supported by the source |
| `all_original_arms_included` | required for a trial-derived whole cohort | `yes`, `no`, `not_applicable`, `unclear` |
| `post_randomisation_selection` | required for a trial-derived whole cohort | `yes`, `no`, `not_applicable`, `unclear` |
| `employment_targeted_intervention` | required for a trial-derived whole cohort | `yes`, `no`, `not_applicable`, `unclear` |
| `n_entered` | no | Number randomised or entering this arm |

**`arm_type`**

| Value | Meaning |
|---|---|
| `cohort` | The whole recruited cohort, whether the parent design is observational or an eligible merged trial. **The only arm type in the primary prevalence pool** |
| `control_tau` | Trial arm receiving treatment as usual, no active vocational component |
| `control_active` | Trial arm receiving an active comparator, which may itself be vocational |
| `intervention` | Trial arm receiving the intervention under test |
| `subgroup` | A non-randomised subgroup reported separately |

The two baseline flags do not by themselves define eligibility. They are retained as auditable components, but `employment_selection_status` also covers positive selection into a job or placement, vocational-service entry, readiness, employment goals and other employment-related restrictions.

A trial-derived whole cohort may use `arm_type = cohort` only when every original allocation group is represented without omission or selective reweighting, the same outcome construct and ascertainment apply across groups, no post-randomisation subgroup has been selected, and the experimental intervention was not specifically intended to change employment. Merging arms does not erase treatment history. Record the parent design in `extraction_cohorts.csv` and explain the treatment mixture in `intervention_description`. If any condition is `no` or `unclear`, keep the allocated arms separate and route them to the intervention synthesis.

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
| `followup_basis` | yes | `since_baseline`, `since_onset_mean`, `chronological_age`, `unclear`. **Only `since_baseline` is assigned to a horizon.** A mean time since onset, or a measurement at a fixed chronological age, is not an elapsed follow-up: `rautio2016` measures at age 44-45 and its "210 months" is a cohort mean over follow-ups running from 5 to over 20 years |
| `result_role` | yes | `reported`, `derived`, `component_only`. See below |
| `conflict_status` | yes | `none`, `unresolved`, `resolved`. `unresolved` blocks the result from every synthesis; `conflict_note` then required |
| `outcome_construct` | yes | See below |
| `outcome_verbatim` | yes | The paper's own definition, quoted |
| `ascertainment` | yes | See below |
| `n_employed` | no; required to enter a count model | Count, not a percentage. Leave blank when unrecoverable and explain in `notes` |
| `n_outcome_observed` | no; required to enter a count model | **The primary denominator.** Those whose status was actually observed. Leave blank when unrecoverable |
| `n_assessed` | no | Approached and assessed |
| `n_alive_eligible` | no | Alive and still eligible at this timepoint |
| `n_entered` | no | Randomised or entering the cohort |
| `denominator_basis` | no | Which of the above the paper's own analysis used |
| `missing_data_method` | no | How the paper handled missing outcomes |
| `source_locator` | yes | **Required.** e.g. `Table 2, p. 1147`. Field-level, not row-level |
| `adjusted_effect` / `adjusted_se` / `adjusted_measure` | no | For cluster trials or covariate-adjusted results |
| `mean_age`, `perc_female`, `perc_post_secondary`, `perc_employed_baseline` | no | Arm-level moderators. **Record counts where the source gives counts** (see below); type a percentage only where the source prints nothing else |
| `n_female` / `n_female_denominator` | no | Counts behind `perc_female` |
| `n_post_secondary` / `n_post_secondary_denominator` | no | Counts behind `perc_post_secondary` |
| `n_employed_baseline` / `n_employed_baseline_denominator` | no | Counts behind `perc_employed_baseline` |
| `ascertainment_window_months` | required for period prevalence | Length of the measurement window; use the source definition when it is not an integer number of months |
| `derivation_component_result_ids` | required for a derived count summed from components | Result IDs used; blank for a directly reported count or a complement |
| `derivation_justification` | required for any derived count | The arithmetic and where its parts came from |
| `derivation_mutually_exclusive` / `derivation_exhaustive` | required for a derived count | `yes` for both, or the count may not be derived |
| `derivation_zero_separable` | required when the derived construct is `paid_any` | `yes`. See the derived-counts section |
| `checked_by` | required for a derived count | Who independently checked the arithmetic against the source |

### Moderator percentages: record counts, and each with its own denominator

Codebook rule 3 says never compute a percentage. That is about the **outcome**, and it stands. Moderators are handled by recording the counts and letting `derive_moderator_percentages()` in `R/lib_data.R` compute the percentage, so the value stays checkable against the source:

- counts present → the percentage is **derived**;
- counts absent → type the percentage the source prints, which is the only thing available;
- **both** present and disagreeing by more than a percentage point → the run **stops**. It is not averaged and the typed value is not silently overwritten.

**Each moderator has its own denominator.** Sex, education and baseline employment are routinely reported on different subsets of one sample, so `n_female_denominator` and `n_post_secondary_denominator` are separate fields and must not be assumed equal.
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

### `outcome_construct`: planned definitive vocabulary

**This migration is done.** `config/vocabularies.yml` carries the values below, the pilot rows were migrated, and all 208 Stage F results were extracted against them. The heading is kept because the rationale still explains the vocabulary: the legacy `paid_supported_sheltered` label conflated support context with labour-market type, and `paid_or_education` does not reveal whether training is included, which is why D12.1 keeps both it and `paid_or_education_or_training`.

| Value | Meaning |
|---|---|
| `paid_any` | **The only primary construct.** Any current work for wages or salary, including competitive and paid sheltered work |
| `paid_competitive` | Paid work in the open labour market. An IPS-supported mainstream job is competitive; support does not make it sheltered |
| `paid_sheltered_noncompetitive` | Paid work in a segregated, reserved or otherwise non-competitive setting |
| `paid_intensity_threshold` | Paid work at or above a stated intensity threshold, e.g. "employed for at least 25% of working days". **Precisely defined, so not `unclear`; but not `paid_any` either**, because it excludes everyone below the threshold. Record the threshold and its window in `outcome_verbatim` |
| `paid_or_education_or_training` | The source's full EET composite, naming paid work, education **and** training |
| `paid_or_education` | A paid-work-or-education composite where the source does **not** include training |
| `education_only` | Education without paid employment, where separable |
| `training_only` | Training without paid employment, where separable. A paid apprenticeship is employment, not training-only |
| `education_or_training` | Education or training combined when the source does not separate them |
| `vocational_activity` | Any vocational activity including unpaid and voluntary |
| `unclear` | The paper does not define what it counted |

**Why both `paid_or_education` and `paid_or_education_or_training` exist.** v0.2 deleted the first on the ground that it does not reveal whether training is included. Applying that literally would force Hansen's "working or studying at the 20-year follow-up" and Tarricone's "full time study was considered employment" to be coded as composites naming training, which those papers do not. Deleting the value forces a misstatement; keeping both obtains the distinction by making the extractor choose. Neither enters the primary pool.

**Education and training are registered outcomes, but they are not paid employment.** Extract paid employment, education and training as separate rows whenever the source permits. Preserve EET or education-or-training as a composite row when that is what the source reports. Never split a composite by assumption, and never add overlapping categories.

### Derived counts, and the one that nearly went wrong

`result_role` is `reported`, `derived` or `component_only`.

**Being used as a component is a relationship, not a property of the result.** A directly reported competitive-employment count is a valid secondary result in its own family *and* may contribute to a derived `paid_any` total; it stays `reported`. Nothing is double counted, because each pool is construct-specific. Reserve `component_only` for fragments with no independent meaning on their own, such as a single intensity band.

A `derived` row requires `derivation_justification` always, and where it names components in `derivation_component_result_ids` the validator additionally requires:

- every component exists, and none is the derived row itself;
- components share `cohort_id`, `arm_id`, `followup_months`, `ascertainment` **and `ascertainment_window_months`** (two period-prevalence counts over different windows measure different things);
- components share **one** denominator, and the derived row sits on that same denominator;
- `derivation_mutually_exclusive` = `yes` and `derivation_exhaustive` = `yes`;
- the sum is **recomputed in R** and must equal the typed value;
- an independent check, recorded in `checked_by`.

**`derivation_zero_separable`, and why it exists.** When the derived construct is `paid_any`, zero work must be separable from every category containing positive paid work. Derive `paid_any` from intensity bands **only** when the categories are mutually exclusive and exhaustive *and* that separability holds. If a residual category combines zero work with positive low-intensity work, **`paid_any` is not identified**: leave its numerator unrecoverable, record the bounds in `notes`, and keep any exact threshold-defined result as `paid_intensity_threshold`.

This rule replaces an earlier one that said the opposite. `rautio2016` bands working days as `<25.0%`, `25.0-49.9%`, `50.0-74.9%`, `>=75.0%`. The lowest band is `<25.0%`, **not `0%`**, so it pools people who never worked with people who worked 1 to 24.9 per cent of working days. Summing the three bands above the threshold gives an exact 18 of 161 at `paid_intensity_threshold`; the number in *any* paid work is bounded only by 18 ≤ paid_any ≤ 161. Deriving `paid_any` there would have put a fabricated number, carrying a plausible value, straight into the primary estimand.

### Unresolved published conflicts

`conflict_status` is `none`, `unresolved` or `resolved`. **`unresolved` blocks the result from every synthesis** until an author reply resolves it, or permanently if none comes; `conflict_note` is then required.

A note in `notes` is not enough. A numerically complete row stays analytically usable and will enter a pool silently, which is exactly the risk in `hansen2024`, where Table 2's subgroups sum to 99 against a printed total of 105 and that total is the `paid_any` numerator for OPUS.

Supported and sheltered employment are not synonyms. Code by the nature of the job. A mainstream paid job obtained with IPS or job-coaching support is `paid_competitive`; a reserved or segregated paid placement is `paid_sheltered_noncompetitive`. If the paper does not establish the labour-market setting or remuneration, use `unclear` and preserve its wording.

### `ascertainment`

| Value | Meaning | Primary pool |
|---|---|---|
| `point_prevalence` | Employed **at** the timepoint | Yes |
| `period_prevalence` | Employed during a defined window, e.g. a tax year | No; separate period-prevalence synthesis |
| `any_time_during_followup` | Ever employed across the whole follow-up | No; separate cumulative-attainment synthesis |
| `unclear` | Cannot be determined | No |

Registers very often report `period_prevalence` ("employed in the year preceding the index date") while looking like point prevalence. Read the methods, not the table heading, and record the window. Period prevalence is a different estimand rather than a looser version of point prevalence. Getting this wrong inflates the pooled estimate.

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
| A prevalence from an eligible whole cohort, irrespective of parent design | `jbi_prevalence` |
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
opus_denmark,OPUS trial,rct,DNK,europe_north,high,2024,fep,ICD-10 F20-F29,clinical interview,100,yes,yes,community_smh,1998,2000,"20-year follow-up of the OPUS randomised trial",none,,"published eligibility criteria contain no employment-related restriction","Methods, participants section"
```

`extraction_arms.csv`
```
opus_denmark,cohort,cohort,,,no,,,no,no,yes,no,no,547
```
Note: OPUS can pass the employment-selection gate because the recruited sample was not selected on wanting work or entry into vocational services. A whole-cohort trial row is nevertheless valid only when all original arms and the other safeguards above are verified. The allocation remains meaningful provenance even when the prevalence result is reported for the merged cohort.

`extraction_outcomes.csv`
```
hansen2024_cohort_t240m_paidany_period,hansen2024,opus_denmark,cohort,240,paid_any,"full-time or part-time work for at least half of the preceding year",period_prevalence,<count>,<count>,,,,outcome_observed,complete_case,"source table and page to verify",,,,...
```

Values shown as `<count>` must be read from the paper. They are deliberately not filled in here so that this example cannot be copied as data. The example passes the population-selection gate but fails the primary outcome gate because the employment measure is period prevalence and the follow-up is 240 months. A point-prevalence work-or-education result would fail the construct gate instead.

---

## Common mistakes

| Mistake | Why it matters |
|---|---|
| One row per paper instead of one row per result | Loses every timepoint and arm but one |
| Treating each paper as an independent study | Counts the same participants repeatedly and narrows every interval |
| Putting years in `followup_months` | A 5 becomes five months instead of sixty |
| Back-calculating a count from a percentage | Rounding makes it wrong, and the model treats it as exact |
| Counting "work or education" as employment | Different construct, different estimand |
| Substituting competitive-only or sheltered-only for `paid_any` | Changes the numerator while retaining the primary label |
| Treating supported employment as sheltered by definition | Support context and labour-market setting are different properties |
| Coding missing eligibility information as no employment selection | Converts uncertainty into eligibility |
| Reading `period_prevalence` as `point_prevalence` | Inflates the pooled estimate |
| Using `some_concerns` with ROBINS-I | Mixes two instruments' scales |
| Leaving `source_locator` blank | Nobody can check the value, including you in six weeks |
