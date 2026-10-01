# Handover: start here

**Rewritten 1 October 2026**, after the inputs were frozen, the definitive models were fitted and independently reviewed, and a manuscript was drafted. It is written for whoever picks this up next, human or model, with no other context.

Read this file, then `docs/methods_deviations.md` (D13 to D16), then `config/analysis.yml`. Everything else is detail.

---

## Where the project is, in one paragraph

This is a systematic review and Bayesian meta-analysis of the prevalence of any paid employment in people with psychosis, at landmark horizons of 12 months, 24 months, 5 years and 10 years or more (PROSPERO CRD420251008448). **The analysis is final.** The author window closed on 27 August 2026 and no more data will arrive. The inputs are frozen at the tag `input-freeze-2026-10-01` (90 reports, 78 cohorts, 278 results), the definitive fits are in `results/run_ee868e185b4b/` at the tag `definitive-fit-2026-10-01`, and an independent statistical review found the computation correct and asked for no rerun. A complete manuscript draft exists but is not in this repository. What remains is for the authors: the items under "What is still open".

---

## The definitive results

Source: `results/run_ee868e185b4b/`, fitted from `input-freeze-2026-10-01` (commit `50301eb`) on a clean worktree.
- **Model:** binomial-logit random effects on cohorts, brms 2.23.0 with CmdStan 2.36.0.
- **Priors:** intercept normal(-1.1, 0.8) and tau half-normal(0, 0.5), unchanged from the SAP.
- **Diagnostics:** all 23 posterior fits pass (worst R-hat 1.005, minimum bulk ESS 1,415, no divergences). Six fits at 12 months needed one increase of adapt_delta.
- **Prior predictive:** passes all six prespecified criteria.
- **Pools:** identical to the provisional fits of 23 September.

| Horizon | Cohorts | Cohort results | Pooled, posterior median [95% CrI] | tau |
|---|---|---|---|---|
| 12 months | 2 | khare2021 287/456, khare2022b 53/107 | 0.53 [0.29, 0.66] | 0.43 |
| 24 months | 0 | | no estimate | |
| 5 years | 0 | | no estimate | |
| 10 years or more | 3 | bhullar2018 35/65, xu2020 23/62, thomson2023 0/56 | 0.23 [0.09, 0.45] | 1.10 |

Sensitivity and post hoc analyses (`tables/sensitivity_by_horizon.csv`, `tables/leave_one_cohort_out.csv`):

| Analysis | Status | Result |
|---|---|---|
| 12 months, unclear selection admitted (adds mayoralvanson2019 36/156) | Prespecified | 0.40 [0.22, 0.58], k = 3 |
| 12 months, missing-outcome bounds | Prespecified | **Not computable.** Neither cohort reports the number alive and eligible. |
| 10 years or more, missing-outcome bounds | Prespecified | 0.19 and 0.26. Only one of three cohorts could be bounded. |
| 10 years or more, without thomson2023 | Post hoc, D15 | 0.42 [0.24, 0.57], tau 0.38 |
| 5 years, interval-aware timing (hakulinen2020 year +5, 552/5,297) | Post hoc, D16 | 0.104 [0.096, 0.113], one cohort's exact interval, not a meta-analysis |
| 10 years or more, interval-aware timing (adds year +10, 398/3,801) | Post hoc, D16 | 0.20 [0.09, 0.38], k = 4 |

**How to read them.** This follows the two independent statistical reviews (23 September and 1 October). The wording matters more than the numbers.
- **Quote posterior estimates to two decimals.** Independent recomputation agrees on every pooled median within 0.001, but interval limits differ in the third decimal, which is Monte Carlo error.
- **12 months is three clinics in two neighbouring districts, from one research group.** The private cohort (khare2021) was recruited at one hospital in Pune and one in Ahmednagar, the public cohort (khare2022b) at one hospital in Pune. Both are mixed SMI samples of people already attending outpatient services. An earlier version of this file said "both from Pune"; that was wrong.
  - **Both cohorts qualify only under D13.** Neither has an extractable diagnostic subgroup (`subgroup_extractable` is `unclear` and `no`), so under the pre-D13 reading the 12-month pool would be empty. D13 was made after the public cohort's result had been seen. Say so wherever the 12-month result is reported. "12 months" is time since enrolment.
  - **Lead with the two cohort-level exact intervals** (0.495 [0.40, 0.59] and 0.629 [0.58, 0.67]), not the pooled figure.
  - The pooled median sits below the crude 0.60 mainly because the prior is centred on 0.25, and partly because a random-effects model weights the two cohorts more equally than their sizes (the weak prior and the frequentist comparator both give about 0.57). Its lower limit is below both cohorts' own lower limits. tau is its prior. The weak prior gives 0.57 [0.13, 0.91].
  - The missing-outcome rows in the output are identical to the primary because no cohort could be bounded. That is not robustness: 17 and 29 per cent of entrants were not observed.
- **10 years or more depends on the forensic cohort.** thomson2023 is Carstairs, recruited in high-security care, with 0 of 56 in paid work at 240 months. It was retained under the population rule as written (guarantor's ruling, 1 October).
  - Give the pooled figure and the figure without it in adjacent sentences. Do not describe the exclusion as a correction.
  - The model fitted to the other two predicts its 0/56 with a two-sided p of 0.001.
  - The tau prior restrains heterogeneity: 67 per cent of posterior tau mass lies above the prior's 95th percentile, and the weak prior gives [0.005, 0.83].
  - The pooled figure mixes early intervention, adolescent inpatient and forensic cohorts and has no single target population.
- **D15 and D16 are post hoc**, made after pooled results were seen, and replace nothing. Say so every time either appears.
  - D16's counts were seen before its rule was written and were not human-verified.
  - The 5-year figure is one cohort's proportion. Never call it a meta-analysis.
  - The four-cohort figure is an average over cohorts, not participants. It does not corroborate the three-cohort primary.
  - The rule can admit annual register data only at the two wide, late bands. The year it could not admit at 12 months, +1, is 720/6,546 (11 per cent), far below the 12-month pool. Show the whole Finnish series.
- **New-cohort predictive intervals and the frequentist comparators belong in a supplement.** At this k the first are mostly the tau prior, and the second cannot identify tau and validate nothing.
- **Certainty is very low at both horizons**, with no route to anything higher.
- **Do not write "no dependable benchmark exists".** The search covers reports from 2016, and 70 of 80 author requests went unanswered. Write "we found none".

The provisional outputs are kept as the record: `results/provisional_8b1dfaa3e539/` (tag `provisional-fit-2026-09-23b`) and `results/superseded_provisional_76a8bb06ff87/`, the run that prompted D15.

---

## What changed on 1 October 2026

1. **The guarantor's five rulings** are in `docs/project_decisions_2026-10-01.md`: thomson2023 retained and D15 ratified; the Finnish series staged; mayoralvanson2019 on 156 observed with 157 as the reporting base; all 65 remaining requests recorded as sent (10 responded, 70 did not); risk of bias checked by AI.
2. **D16** was adopted as a post hoc sensitivity. The code is `interval_aware_rows()` and `interval_aware_data()` in `R/lib_data.R`; it substitutes an admitted observation into its cohort's extracted row and runs `build_primary_pool()`. `data/author_supplied_counts.csv` is a hashed input read only by this analysis.
3. **Risk of bias.** All 1,491 existing judgements were checked against sources by AI, with 187 corrected. The one pooled result with no appraisal (thomson2023) was appraised and independently checked. The table holds 1,500 rows. The audit is in `docs/rob_verification/`.
4. **`data/rob_additions.csv`** is a new merge input, for appraisal rows added after the batches ran. The corrections ledger can change a field but cannot add a row.
5. **`outcome_construct`** is no longer configured as a moderator, which contradicted SAP 9.2.
6. **The inputs were frozen**, `sample_status` set to `full`, and the definitive run made.
7. **Tests:** 204 R expectations and 11 merge tests pass, none skipped.

---

## What is still open

None of these blocks the analysis. Each is for the authorship group.

**For the manuscript** (the draft lists each as `[TO CONFIRM]`):
1. Funding statement, ethics statement, contributor roles, declarations of interests, and how the guarantor's own included report (`twumasi2026`, in no pool) was handled.
2. The PROSPERO version numbers as returned for the two 2026 amendments, to be recorded in `docs/methods_deviations.md` as well.
3. The full search strings, the screening tool and the number of screeners. None is in this repository.
4. The certainty-of-evidence ratings, which were drafted from the analysis and have not been made by the review team.
5. Whether D15, D16 and the AI checking of risk of bias need a further registry amendment. D16 and the AI checking are not registered.

**Scientific loose ends, stated in the draft as limitations:**
6. **The Pune cohorts' number alive and eligible.** If it can be recovered from khare2021 and khare2022b, the 12-month missing-outcome bounds become computable. That would be a data change after the freeze and needs a new freeze tag and run.
7. **thomson2023's denominator.** The paper's Table 1 gives 66 consenting participants; the 56 used here is from the author's reply, and the correspondence is not in the project. The paper also reports 8 of 72 in "supported work style placement" with remuneration not stated, so they are not counted as paid work.
8. **The ayesaarriola2020 reply** (60 or 65 of 197 employed, at 8 to 16 years) is not a landmark result and has not been re-extracted into the tables.
9. **95 results outside every pool have no risk-of-bias appraisal**, and 410 RoB 2 and ROBINS-I rows have no signalling-question record. Neither is used in any synthesis here.
10. **Three overlap pairs** in `docs/overlap_audit_queue.md` are unadjudicated. None touches a pool.
11. **Small data inconsistencies** that touch no pool: `leighton2019b` has `eligibility_status` reading `include (unchanged)`; `hansen2024b` is labelled differently in the manifest and the reports table; `drake2015` has a publication year before the search window; D10.1 still quotes superseded disposition counts.
12. **The standing Stage F questions**: which instrument appraises a single-arm proportion from a trial; risk of bias for `component_only` fragments; D12.8 dispersion; duration thresholds; vocabulary gaps.

---

## The manuscript

A complete draft for *The Lancet Psychiatry* exists in `manuscript/`, which is gitignored and never committed: an unpublished paper does not belong in a public repository.

- **A second statistical review read the assembled draft against the result tables** on 1 October. It confirmed every quoted estimate and asked for thirteen corrections of description, all applied.
- **Every result number is generated.** `manuscript/build/build.R results/run_ee868e185b4b` writes `numbers.csv`, the tables and the figures from the definitive tables. The section files carry `{{keys}}`, and `manuscript/build/assemble.py` refuses to build if a key is missing, then renders `manuscript.docx` and `supplement.docx` with pandoc.
- **`manuscript/OUTSTANDING.md`** lists everything an author must supply or confirm.
- The MSc dissertation (September 2026) did a narrative synthesis without pooling, and counts results the SAP bars. Do not quote its counts as the review's.

---

## How to run things

The interpreters are `/opt/anaconda3/bin/python3` and `Rscript` (R 4.4.2).

```
/opt/anaconda3/bin/python3 scripts/merge_stage_g.py          # rebuild merged tables (idempotent; --check to dry-run)
PROVENANCE_SOURCE_VERSION=<label> /opt/anaconda3/bin/python3 scripts/build_provenance.py
Rscript R/01_validate_data.R .                                # schema and vocabulary
Rscript tests/testthat.R                                      # 204 pass
/opt/anaconda3/bin/python3 -m unittest tests/test_merge_stage_g.py   # 11 pass
/opt/anaconda3/bin/python3 scripts/check_shard.py; /opt/anaconda3/bin/python3 scripts/check_folder.py
Rscript R/04_design_package.R                                 # pools and attrition, no sampling
```

**To reproduce the definitive results:** check out `input-freeze-2026-10-01` and run `DEFINITIVE_RUN=yes Rscript R/00_run_all.R`. The analysis identifier hashes the commit, the configuration and the inputs, so it will be `ee868e185b4b` again.

**To make a correction:** add a row to `data/result_corrections.csv` giving table, key, field, old, new, authority, reason, source, date and actor. Then rerun the merge. Never edit a merged table by hand, because the next merge silently undoes it. The ledger holds one row per table, key and field; a later ruling on the same field replaces the row, and the earlier text stays in git. To add a risk-of-bias row, add it to `data/rob_additions.csv`.

**Any change to an input, the configuration or the code after the freeze needs a new freeze:** commit, create a new tag, run. The order is always commit, then tag, then run. The run directory is named by the new identifier, so the current results are never overwritten.

**Fit modes** (`R/lib_config.R`). Exactly one mode variable may be set; two are refused.

| Mode | Command | Gates | Output |
|---|---|---|---|
| design-only | `Rscript R/00_run_all.R` | refuses to sample | none |
| engineering | `ENGINEERING_FIT=i-understand-this-is-not-a-result SYNTHETIC_DATA=1 Rscript R/00_run_all.R` | synthetic data only | `results/engineering_synthetic_*` (gitignored) |
| provisional | `PROVISIONAL_FIT=pre-freeze Rscript R/00_run_all.R` | clean tree and a tag at HEAD | `results/provisional_<aid>/` |
| definitive | `DEFINITIVE_RUN=yes Rscript R/00_run_all.R` | `sample_status: full`, clean tree and a tag at HEAD | `results/run_<aid>/` |

---

## Rules that are easy to get wrong

These rules each cost real rework already.

1. **`keep()` in `build_primary_pool` counts `NA` as removed.** Every clause is guarded by `need_cols()`.
2. **`paid_any` means any current work for wages or salary, and it includes paid supported and paid sheltered work** (SAP 3.1). It excludes education, unpaid training, volunteering, benefits, and any activity whose remuneration cannot be established. A competitive-only or sheltered-only count cannot stand in for it. An earlier version of this file said sheltered placements are not paid work; that was wrong, and the SAP, the codebook and the vocabulary are the authority.
3. **A reporting base is not an observed denominator**, and a count is never back-calculated from a percentage.
4. **`conflict_status = unresolved` blocks a result from every synthesis.** `resolved` requires an authority: an author reply or an authorship-group ruling.
5. **Only time from cohort entry can take a landmark horizon.** `since_onset_mean`, `chronological_age`, `calendar_end_common` and `since_baseline_mean` are all barred. D16 is the one, post hoc, labelled exception, and it applies in a sensitivity pool only.
6. **D11.3 counts distinct cohorts, not rows.**
7. **A prespecified consequence is applied as written**, including to every row it logically covers.
8. **The report universe is 90 and it is frozen.** The search closed on 9 June 2026.
9. **A sensitivity row identical to the primary is not corroboration.** Check why it is identical before describing it.
10. **Tests of the guard must not read the repository's own status.** They build their own unfinished and full configurations.

---

## Map of what matters

| File | What it is |
|---|---|
| `data/extraction_*.csv`, `data/inclusion_manifest.csv`, `data/report_cohort_map.csv` | The merged tables. Output of the merge; never edit them by hand. |
| `data/result_corrections.csv` | The post-merge corrections ledger, with the authority for every change |
| `data/rob_additions.csv` | Risk-of-bias rows added after the batches ran |
| `data/author_supplied_counts.csv` | The Finnish register series; read only by the D16 sensitivity |
| `data/author_response_reconciliation.csv` | De-identified summaries of the author replies in the contact workbook |
| `data/stage_g_reconciliation.csv` | Overrides for shard manifest change rows only |
| `data/extraction_provenance.csv` | Field-level verification ledger, completion by tier |
| `data/stage_f_shards/` | The immutable Stage F output |
| `results/run_ee868e185b4b/` | **The definitive fit** |
| `results/provisional_8b1dfaa3e539/` | The 23 September provisional fit, kept as the record |
| `results/design_package/` | Design-only pools and attrition |
| `docs/methods_deviations.md` | D1 to D16. D13 to D16 were made after the affected data or results were seen. |
| `docs/project_decisions_2026-10-01.md` | The guarantor's five rulings and the validation of that record |
| `docs/rob_verification/` | The risk-of-bias audit |
| `docs/data_requests.md` | Requests, prespecified consequences, window closure |
| `docs/overlap_audit_queue.md` | Overlap adjudications |
| `docs/prospero_amendment_draft.md` | The text submitted as v5.0 |
| `config/analysis.yml` | Gates, horizons, priors, the sparse-data rule, sensitivities, deferrals |
| `manuscript/` | The draft paper and its build (gitignored, never commit) |
| `dissertation_shared_folder/` | The MSc dissertation, the final sheet and the source PDFs (gitignored, never commit) |

---

## Commit cadence, tags and privacy

Commit per milestone. Commits are authored as `ricardotwumasi` with no assistant trailer.

Tags pin immutable states, and the record is always committed before its tag:
- `stage-g-merge`
- `provisional-fit-2026-09-23` (superseded) and `provisional-fit-2026-09-23b`
- `input-freeze-2026-10-01`: the frozen inputs, code and configuration
- `definitive-fit-2026-10-01`: the definitive results

Privacy scanning is per commit. Scan the staged index for email addresses (only the corresponding address in the README is permitted), for local absolute paths, and for any PDF, docx, xlsx, `private/` record, `manuscript/` file, `CLAUDE.md` or internal memo. Before any push, audit every blob in `origin/main..HEAD`. Use non-force pushes and explicit staging only. Recipient names, addresses and correspondence never go in the repository; de-identified summaries of what authors supplied do.
