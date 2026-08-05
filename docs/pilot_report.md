# Pilot report

**Run:** `results/run_ebc5fe8b5ab5`, 5 August 2026
**Sample:** 15 purposively selected reports. `PURPOSIVE PILOT - NOT FOR INFERENCE`

The pilot's purpose was to prove the schema, the validators and the pipeline on real data. It did that, and it also surfaced four problems with the analysis plan that need deciding before full extraction. Those are the useful output; the pooled number is not.

---

## 1. What ran

```
15 reports  ->  12 cohorts  ->  26 arms  ->  66 extracted results
```

Every stage completed. Elapsed time 14.6 seconds for one horizon, one primary fit and the prior predictive; the full inventory with prior grids, cross-validation and 200-replicate simulation scenarios has **not** been benchmarked and no runtime claim is made for it.

| Check class | Result |
|---|---|
| Data validation | Passed after three fixes, below |
| Design checks | Pool built, 3 reports set aside by the selection rule and named |
| Prior predictive | 6 of 6 prespecified criteria passed |
| Primary fit | R-hat 1.0023, bulk ESS 3701, 0 divergences, 0 treedepth hits, 0 escalations |
| Posterior predictive | Coverage 1.00 against nominal 0.95 in both replication forms, which at k = 2 is uninformative rather than reassuring |
| Moderators | 11 of 11 correctly returned `not reported` |

## 2. The headline finding: 66 results reduce to 2

| Clause | Removed | Remaining |
|---|---|---|
| all extracted results | | 66 |
| report eligible | 0 | 66 |
| observational design | 27 | 39 |
| cohort arm, not a trial arm | 18 | 21 |
| point prevalence | 5 | 16 |
| paid employment construct | 5 | 11 |
| eligible diagnosis group | 1 | 10 |
| at least half with a qualifying diagnosis | 0 | 10 |
| horizon t12m | 5 | 5 |
| numerator and denominator recoverable | 0 | 5 |
| non-zero denominator | 0 | 5 |
| one result per cohort | 3 | 2 |

The pilot was chosen for hard cases, and hard cases are exactly what the primary pool excludes, so a small pool was expected. But **45 of 66 results are lost to the first two clauses alone**, and that is worth examining before extracting 75 more reports.

The two survivors:

| Report | Employed | Observed | Proportion | Construct |
|---|---|---|---|---|
| `mihaljevicpeles2016` | 77 | 257 | 0.300 | paid_competitive |
| `chen2023` | 45 | 65 | 0.692 | paid_any |

**Neither number should be quoted, and the second is close to meaningless.** `chen2023`'s entire sample was already in a vocational placement at baseline by design, so 0.692 is a property of the selection, not of a clinical population. That it reached the primary pool at all is a defect in the pool rule, not a finding.

Pooled posterior 0.406 [0.201, 0.619]. It is prior-influenced at k = 2 and is reported here only to show the pipeline produces a number.

## 3. Four problems the pilot found

### 3.1 The pool rule excludes trials by design when it should exclude selection on employment

The rule currently drops any cohort whose `design` is `rct`. That removed 27 results including the OPUS 20-year follow-up, where both arms are merged, the original allocation is no longer meaningful, and participants were consecutively referred first-episode patients in a defined catchment who were **not** selected on wanting to work.

The exchangeability concern that justifies excluding trial arms is selection on employment-related eligibility, not randomisation as such. The schema already records exactly that, in `baseline_unemployed_required` and `baseline_wants_work_required`.

**Recommendation:** replace the design-based exclusion with a selection-based one. Admit an arm to the primary pool when `arm_type == "cohort"` and both selection flags are `no`, whatever the parent design. Under that rule OPUS at 20 years would qualify on selection grounds (it would still be excluded here, because its ascertainment is period prevalence), and `chen2023` would be correctly excluded, since its `baseline_wants_work_required` is `yes`.

This changes the estimand's population and needs authorship-group approval before full extraction.

### 3.2 Parallel cohorts reported together are forced into the wrong shape

`dayabandara2026` reports two separately recruited samples, first-episode and relapsing. Recorded as two `subgroup` arms of one cohort, they are excluded because `subgroup` is not a pool arm type, and 99/240 at 12 months with point-prevalence paid employment is lost.

They are not subgroups of one sample; they are two cohorts recruited in parallel at one site.

**Recommendation:** give separately recruited parallel samples distinct `cohort_id`s, and reserve `subgroup` for a post-hoc split of one recruited sample. Add this to the codebook.

### 3.3 The validator was stricter than the codebook

The codebook instructs an extractor to leave a count blank rather than back-calculate it from a percentage. The validator required `n_employed` and `n_outcome_observed` on every row, so it rejected exactly the rows the codebook asks for.

Fixed: those two fields are now optional. A row recording "this result exists and has no recoverable count" is real data that feeds the missing-evidence assessment, and `build_primary_pool()` drops and counts it visibly.

### 3.4 A denominator was mis-assigned, and the nesting check caught it

`darjee2017`'s any-time-during-follow-up figures reconcile against the whole 169-person subgroup, but the extraction carried `n_assessed = 137` onto those rows. 137 describes the end-of-follow-up social outcomes and does not apply. The nesting check (`observed <= assessed`) fired and named the rows. Data corrected.

This is the check earning its place: nothing in the numbers looks wrong until you ask which population each denominator describes.

## 4. The frequentist comparison behaved as a diagnostic should

| Quantity | brms | rma.glmm | Difference |
|---|---|---|---|
| Pooled proportion | 0.406 | 0.488 | 0.082 |
| tau (logit) | 0.723 | 0.810 | 0.087 |

Had the earlier draft's 0.02 agreement tolerance been kept as a gate, this run would have failed and stopped before producing any output. It should not have: at k = 2 the weakly informative prior is doing exactly the work it was specified to do, pulling the estimate toward 0.25 and away from a maximum-likelihood fit that has two points to work with. The Bayesian estimate being lower and its tau smaller is the prior behaving as designed.

This vindicates the feasibility review's insistence that the comparison be descriptive. It is recorded in `tables/frequentist_differences.csv` with `comparison_is_a_gate = FALSE`.

## 5. Data-quality problems confirmed in the source papers

Every inconsistency the reconciliation predicted was confirmed on close reading, and two more were found:

| Report | Problem |
|---|---|
| `hansen2024` | Table 2 subgroups sum to 52 and 99 against stated totals of 54 and 105. Within-column percentages all check out, so the totals are the suspect figures |
| `mihaljevicpeles2016` | Three incompatible denominators (257, 205, 186), and the text says 71 disability pensioners while Table 7 implies 52 |
| `tarricone2017` | 75 employed described as both 46% of 163 and 53% of 135; only the first is arithmetic |
| `twumasi2026` | Three mutually incompatible denominators: 38,160/65,630 is 58.1% not the stated 69.1%, and the published category counts sum to 50,440 |
| `darjee2017` | Abstract says one person in voluntary employment; results say one in supported work and none in paid unsupported work |
| `fowler2019` | Abstract says 50 followed up; method, table and arithmetic all give 66 of 77 |
| `dayabandara2026` | Abstract and discussion percentages contradict Table 4. The REC 12-month employed **count** of 42 appears to have been carried into the prose as "42%" |
| `christensen2019` | Interview-dependent denominators imply 187/171/170 against a flowchart giving 186/170/165, and the flowchart lists 243 in an arm that randomised 239 |

Eight of fifteen reports contain a published inconsistency. That is a finding about the literature, and it should be reported in the manuscript rather than quietly resolved.

## 6. Zero-event handling

Three zero or near-zero cells were recorded honestly rather than dropped: `thomson2023` (no paid employment at 20 years), `darjee2017` (one person in supported work), `fowler2019` (0 of 24 in the non-affective control arm). None entered the primary pool at this horizon, so the exact binomial likelihood was not exercised on a zero. **It still needs to be**, on a horizon where a zero-event cohort qualifies, before the pipeline is trusted for the full analysis.

## 7. Extraction effort, for the KURF estimate

Two parallel agents extracted 15 reports and produced 66 results in roughly 16 minutes of wall time each, reading 15 full-text PDFs and one supplement. That is machine time, not the human checking time the protocol requires, and it is the human check that governs the KURF workload. The pilot does not estimate it.

**Every field determining inclusion or the primary estimate still requires independent human verification.** The four derived counts flagged during extraction (`rautio2016` 18 by summation, `cunningham2025` 744 by summation, `chen2023` 45 by summation, `dayabandara2026` denominators by subtraction) are the priority, along with all eight inconsistencies in section 5.

## 8. Conflict of interest

`twumasi2026` was extracted with `CONFLICT OF INTEREST: authored by the review guarantor` on every row. Its extraction and risk-of-bias appraisal must be independently verified by a co-author who is not an author of that paper before any definitive analysis.

## 9. What to do next

1. Decide 3.1 (selection-based rather than design-based pool rule). Blocks full extraction.
2. Decide 3.2 (parallel cohorts) and update the codebook.
3. Exercise the pipeline on a horizon containing a zero-event cohort.
4. Obtain the screening export, run the search update, send the author requests in `docs/data_requests.md`.
5. Independently verify the pilot extraction, starting with the derived counts and the eight inconsistent reports.
6. Benchmark the full fit inventory before making any runtime claim.
