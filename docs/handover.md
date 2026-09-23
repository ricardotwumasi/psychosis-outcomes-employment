# Handover: start here

**Rewritten 23 September 2026**, after the author window closed, the human verification was recorded, and the first provisional Bayesian fits were run. It is written for whoever picks this up next, human or model, with no other context.

Read this file, then `docs/methods_deviations.md` (D13 to D15), then `config/analysis.yml`. Everything else is detail.

---

## Where the project is, in one paragraph

This is a systematic review and Bayesian meta-analysis of the prevalence of any paid employment in people with psychosis, at landmark horizons of 12 months, 24 months, 5 years and 10 years or more (PROSPERO CRD420251008448).
- **Extraction** is merged: 90 reports, 78 cohorts and 278 results.
- **Human verification** covers every pool-determining field.
- **The author window** closed on 27 August 2026, and every prespecified non-response consequence is applied.
- **PROSPERO version 5.0** was submitted on 23 September 2026.

**Provisional, pre-freeze posteriors now exist** for the two horizons that have at least two cohorts. They are stamped `PROVISIONAL, PRE-FREEZE - NOT FOR CITATION`. They are not definitive, because the gates listed below are still open.

---

## The provisional results

Source: `results/provisional_8b1dfaa3e539/`, fitted from tag `provisional-fit-2026-09-23b` (commit `768ce61`) on a clean worktree.
- **Model:** binomial-logit random effects on cohorts, brms 2.23.0 with CmdStan 2.36.0.
- **Priors:** intercept normal(-1.1, 0.8) and tau half-normal(0, 0.5), unchanged from the SAP.
- **Diagnostics:** all 28 fits pass (R-hat < 1.01, ESS > 400, no divergences).
- **Prior predictive:** passes all six prespecified criteria.

| Horizon | Cohorts (D11.3) | Pooled proportion, posterior median [95% CrI] | New-cohort predictive | tau |
|---|---|---|---|---|
| 12 months | 2: khare2021 287/456, khare2022b 53/107 | 0.53 [0.30, 0.66] | [0.17, 0.78] | 0.43 |
| 24 months | 0 | no estimate | | |
| 5 years | 0 | no estimate | | |
| 10 years or more (observed 120 to 240 months) | 3: bhullar2018 35/65, xu2020 23/62, thomson2023 0/56 | 0.23 [0.09, 0.45] | [0.02, 0.78] | 1.10 |

**How to read them.** This follows the independent statistical review, and the wording matters more than the numbers.
- **12 months: two cohorts, one investigator group.** Both cohorts are from Pune, from one group, with mixed SMI samples admitted under D13. The observed proportions are 0.50 and 0.63.
  - The pooled median sits below the raw pooled proportion (0.60). It has been shrunk toward a prior centred on 0.25: pune_private lies above the prior's 95 per cent upper bound, and 37 per cent of the posterior mass lies above the prior's 95th percentile. With k = 2 the lower limit mainly reflects the prior (weak prior: 0.57 [0.13, 0.91]).
  - **Lead with the two cohort-level exact binomial intervals** (`tables/leave_one_cohort_out.csv`: 0.495 [0.40, 0.59] and 0.629 [0.58, 0.67]), not with the pooled figure.
  - Admitting the unclear-selection cohort (mayoralvanson2019) moves the estimate to 0.40 [0.22, 0.58]. That shift is as large as the prior's effect and belongs in the text.
- **10 years or more: the estimate depends on the forensic cohort.** thomson2023 is Carstairs, a high-security forensic cohort with 0 of 56 in paid work at 240 months. It halves the pooled proportion and triples tau.
  - Without it the estimate is 0.42 [0.24, 0.57], tau 0.38.
  - Fitted on the other two, the model predicts its 0/56 with a two-sided p of 0.001 (`diagnostics/ppc_loco.csv`).
  - priorsense flags a prior-data conflict: 67 per cent of the posterior tau mass lies above the prior's 95th percentile.
  - The pooled figure mixes community and forensic-detention populations and has no single population to generalise to.
  - The leave-one-cohort-out is **post hoc** (D15, not yet ratified) and does not replace the primary.
- **The predictive intervals are not headlines.** At k = 2 and 3 they are mostly the tau prior.
- **The frequentist comparators** (`tables/frequentist_comparison.csv`) cannot identify tau at this k. The two approaches do not validate each other.

The superseded first run, `results/superseded_provisional_76a8bb06ff87/` (tag `provisional-fit-2026-09-23`), is kept because it is the output that prompted D15.

---

## What changed on 23 September 2026 (commits `c83d9ff` to the handover commit)

1. **The final extraction sheet** (`dissertation_shared_folder/230926/extraction_outcomes_final.xlsx`) was ingested through `data/result_corrections.csv`, a new ledger that the merge applies after D14 under the three-state rule. It is not edited in by hand. The ledger has 58 rows.
   - The sheet was built from the 13 August commit, so it reverted the 18 August twumasi2026 block. That revert is rejected.
   - Every other departure from the sheet has its reason in the ledger: `resolved` rather than `none` for author-confirmed conflicts, thomson2023 recorded as 0/56 among the living, `chang2016` FES left unresolved, and vocabulary repairs.
2. **The merge is rerunnable again.** A dual-cohort note suffix is no longer read as a third value. Two runs produce byte-identical tables.
3. **The author window is closed** (`docs/data_requests.md`, closure section).
   - 7 reports replied and 8 did not.
   - andersen2024 is recoded `unclear` under its prespecified consequence, on every `paid_any` row, 9 months included, and leaves the pool.
   - mayoralvanson2019 stays out.
   - The Khare rows stay, with caveats.
4. **Human verification is recorded** in `data/extraction_provenance.csv`.
   - The checker is P. Bagri, a review co-author and the MSc reviewer, who is a non-author of every included report. It was a single-reviewer check against the PDFs, before 11 September 2026.
   - Tiers 0 to 2 are complete at 100 per cent: 5,264 agree, 10 corrected, 7 superseded by governance and 1 disagree.
   - Tier 5 (risk of bias) is at 0 per cent.
5. **PROSPERO v5.0** was submitted on 23 September 2026. The Pune pair is adjudicated as distinct cohorts.
6. **The model pipeline** now does the following:
   - fits every horizon under D11.3, counted in distinct cohorts;
   - fits both sensitivity pools, the prior grid, the weak prior, priorsense, the missing-outcome bounds and post hoc leave-one-cohort-out;
   - uses two-sided posterior predictive p-values and a left-out-cohort predictive check.
   - The guard has four modes (below). Tests: 186 pass, 0 fail, 0 skip.

---

## Gates: what is closed and what is open

| Phase 5 gate | State |
|---|---|
| PROSPERO v5.0 submitted | **Closed**: 23 September 2026. The returned version number is still to be recorded in `docs/methods_deviations.md`. |
| Author window closed, replies applied | **Closed** for every report the sheet or the guarantor names. **Open:** 65 reports are still `drafted` in the manifest, and whether those were sent is unknown. No current pool depends on them. |
| Every pool-determining field human-verified | **Closed** (tiers 0 to 2). It was single-reviewer; say so in the paper. |
| Overlap audit adjudicated | Pune pair **closed**. The others are open, and none of them touches a current pool. |
| Merged tables validate, `git diff --check`, clean tree | **Closed** at `provisional-fit-2026-09-23b`. |
| Model inventory implemented or formally deferred | **Closed**: deferrals with their reasons are in `config/analysis.yml` (`deferred_with_reason`). |
| Tier 5 risk of bias verified | **Open**, 0 of 1,491. The MSc appraisal assigned tools on different rules (RoB 2 on proportions from trials), so it is not the same check. This is needed before RoB analyses, GRADE or interpretation, but not before the intercept fit. |
| `sample_status: full` and the freeze tag | **Open.** Set it when the questions below are settled. |

---

## Open questions for the authorship group (decide before definitive)

1. **Is a high-security forensic cohort eligible for a prevalence of paid work?** thomson2023 passes every written gate. Whether detained patients belong in this estimand is an eligibility question, not a sensitivity one. The prespecified primary keeps it. Ratify D15, and decide whether a population rule is needed. Any such rule would be post hoc and must be labelled so.
2. **The hakulinen2020 author series.** The author supplied employment counts by year relative to first hospitalisation (−10 to +10, for example year 0 968/6,939 and year +10 398/3,801). The extraction sheet calls them "barred by calendar_end_common". If first hospitalisation is cohort entry, years +1, +2, +5 and +10 are landmark data from about 7,000 people, and would populate the empty 24-month and 5-year horizons. This needs a documented ruling, and new rows through `data/result_corrections.csv` if admitted. It is the largest potential change to any pool.
3. **mayoralvanson2019's denominator: 156 or 157.** The MSc extraction disagrees with ours. Resolve it against the PDF before the unclear-selection sensitivity analysis is reported.
4. **The 65 `drafted` requests.** Were they sent? If so, record `no_response`.
5. **The standing questions from Stage F**, still open:
   - which instrument appraises a single-arm proportion from a trial;
   - risk of bias for `component_only` fragments;
   - D12.8 dispersion;
   - duration thresholds;
   - vocabulary gaps (FIML, duration outcome, a Southeast Asia region).
6. **`outcome_construct` is still configured as a confirmatory moderator**, contrary to SAP 9.2. It is moot below 10 cohorts, but fix it before any moderator is reported.

---

## How to run things

The interpreters are `/opt/anaconda3/bin/python3` and `Rscript` (R 4.4.2).

```
/opt/anaconda3/bin/python3 scripts/merge_stage_g.py          # rebuild merged tables (idempotent; --check to dry-run)
PROVENANCE_SOURCE_VERSION=<label> /opt/anaconda3/bin/python3 scripts/build_provenance.py
Rscript R/01_validate_data.R .                                # schema and vocabulary
Rscript tests/testthat.R                                      # 186 pass
/opt/anaconda3/bin/python3 scripts/check_shard.py; /opt/anaconda3/bin/python3 scripts/check_folder.py
Rscript R/04_design_package.R                                 # pools and attrition, no sampling
```

**To make a correction:** add a row to `data/result_corrections.csv` giving table, key, field, old, new, authority, reason, source, date and actor. Then rerun the merge. Never edit a merged table by hand, because the next merge silently undoes it.

**Fit modes** (`R/lib_config.R`). Exactly one mode variable may be set; two are refused.

| Mode | Command | Gates | Output |
|---|---|---|---|
| design-only | `Rscript R/00_run_all.R` | refuses to sample | none |
| engineering | `ENGINEERING_FIT=i-understand-this-is-not-a-result SYNTHETIC_DATA=1 Rscript R/00_run_all.R` | synthetic data only | `results/engineering_synthetic_*` (gitignored) |
| provisional | `PROVISIONAL_FIT=pre-freeze Rscript R/00_run_all.R` | clean tree and a tag at HEAD | `results/provisional_<aid>/` |
| definitive | `DEFINITIVE_RUN=yes Rscript R/00_run_all.R` | `sample_status: full`, clean tree and a tag at HEAD | `results/run_<aid>/` |

**To promote to definitive:**
1. Settle the open questions above and verify tier 5.
2. Set `sample_status: "full"` in `config/analysis.yml`.
3. Commit, create the input-freeze tag, and run with `DEFINITIVE_RUN=yes`.
4. Have the output statistically reviewed.

The order is always: commit, then tag, then run.

---

## Rules that are easy to get wrong

These rules each cost real rework already.

1. **`keep()` in `build_primary_pool` counts `NA` as removed.** Every clause is guarded by `need_cols()`.
2. **`paid_any` means any paid work.** Sheltered and benefit-remunerated placements are not paid work (SAP 3.1).
3. **A reporting base is not an observed denominator**, and a count is never back-calculated from a percentage.
4. **`conflict_status = unresolved` blocks a result from every synthesis.** `resolved` requires an authority: an author reply or an authorship-group ruling.
5. **Only time from cohort entry can take a landmark horizon.** `since_onset_mean`, `chronological_age`, `calendar_end_common` and `since_baseline_mean` are all barred.
6. **D11.3 counts distinct cohorts, not rows.**
7. **A prespecified consequence is applied as written**, including to every row it logically covers. If only andersen2024's 12-month row had been recoded, its 9-month row would have entered the 12-month band.
8. **The report universe is 90 and it is frozen.** The search closed on 9 June 2026.

---

## Map of what matters

| File | What it is |
|---|---|
| `data/extraction_*.csv`, `data/inclusion_manifest.csv`, `data/report_cohort_map.csv` | The merged tables. Output of the merge; never edit them by hand. |
| `data/result_corrections.csv` | The post-merge corrections ledger, with the authority for every change |
| `data/stage_g_reconciliation.csv` | Overrides for shard manifest change rows only |
| `data/extraction_provenance.csv` | Field-level verification ledger, completion by tier |
| `data/stage_f_shards/` | The immutable Stage F output |
| `results/provisional_8b1dfaa3e539/` | The current provisional fit |
| `results/design_package/` | Design-only pools and attrition |
| `docs/methods_deviations.md` | D1 to D15. D13, D14 and D15 were made after the affected results were seen. |
| `docs/data_requests.md` | Requests, prespecified consequences, window closure |
| `docs/overlap_audit_queue.md` | Overlap adjudications |
| `docs/prospero_amendment_draft.md` | The text submitted as v5.0 |
| `config/analysis.yml` | Gates, horizons, priors, the sparse-data rule, sensitivities, deferrals |
| `dissertation_shared_folder/230926/` | The MSc dissertation and the final sheet (gitignored, never commit) |

The MSc dissertation (September 2026) did a narrative synthesis without pooling. Its landmark tables differ from this pipeline's pools in known and explained ways: it counts percentage-only, calendar-end, unresolved-conflict and period-like results that the SAP bars. Do not quote its counts as the review's.

---

## Commit cadence, tags and privacy

Commit per milestone, and push at least daily during active work. Commits are authored as `ricardotwumasi` with no assistant trailer.

Tags pin immutable states, and the record is always committed before its tag. The tags so far:
- `stage-g-merge`
- `provisional-fit-2026-09-23` (superseded)
- `provisional-fit-2026-09-23b`

The input-freeze tag is still to come.

Privacy scanning is per commit. Scan the staged index for email addresses (only the corresponding address in the README is permitted) and for any PDF, docx, xlsx, `private/` record, `CLAUDE.md` or internal memo. Before any push, audit every blob in `origin/main..HEAD`. Use non-force pushes and explicit staging only.
