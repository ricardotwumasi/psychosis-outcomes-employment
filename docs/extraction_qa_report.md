# Extraction QA report

**Review:** Employment Rates and Moderators in Psychosis (PROSPERO CRD420251008448)
**Status at 12 August 2026:** Stages A-F complete. **Stage F is finished: all 75
non-pilot reports are extracted**, into 13 verified shards that are **not yet merged**.
Stage B rechecks applied and adjudicated by the authorship group. PROSPERO amendment
submitted as **version 4.0**. The governance gate in §7 is closed apart from the frozen
commit. Stage G is next: merge, overlap audit, human verification.
**Sample status stamped on every output:** `DEFINITIVE EXTRACTION IN PROGRESS - NOT FOR INFERENCE`

Nothing in this document is a review finding.

---

## 1. Gates

| Gate | Command | Status |
|---|---|---|
| Folder | `/opt/anaconda3/bin/python3 scripts/check_folder.py` | exit 0, 90 screened studies with readable PDFs |
| Shards | `/opt/anaconda3/bin/python3 scripts/check_shard.py` | exit 0, 13 shards structurally sound |
| Schema and vocabulary | `Rscript R/01_validate_data.R .` | exit 0, 0 warnings |
| Tests | `Rscript tests/testthat.R` | 90 pass, 0 fail, 0 skip, 0 warn |

Re-run 13 August 2026 after the protection checkpoint. The interpreter is written
out because bare `python3` depends on PATH; see `docs/environment.md`. The shard
gate now defaults to `data/stage_f_shards`, so this row is a statement about the
shards in the repository rather than about a scratchpad copy.

The validator and tests run against the **pilot data only**, because the Stage F shards
are not merged. They are not evidence that the Stage F rows validate in place. The shard
gate is a separate, weaker check: it verifies structure, not extraction quality.

The test entry point did not run at all before 11 August 2026: it derived the project
root from `sys.frame(1)$ofile`, which is unset under `Rscript`, so the documented
command failed before reaching a single test. Fixed; see `docs/environment.md`.

### 1.1 What `check_shard.py` does and does not check

It checks, per shard: file completeness; headers identical to `data/`; that the reports
present match the batch ledger; risk-of-bias domain slugs against `rob_domain` and every
domain present for every appraised result; duplicate `result_id`s; and that every derived
count equals the sum of its named components.

It does **not** check across shards. **Cross-shard duplication is the risk the merge
introduces and nothing has looked for it yet.** It also deliberately does not trust the
`COMPLETE` marker: one batch wrote its marker and then died, another died before writing
one, so the marker is checked against the ledger rather than believed.

---

## 2. The primary pool is empty, and why that is not yet a finding about the review

The data currently in the repository is the **15-report purposive engineering pilot**,
not the review. Its reports were chosen deliberately to exercise hard cases: zero-event
cells, multi-report cohorts, internally inconsistent publications, register period
prevalence, employment-selected samples. It is not a sample of the literature and no
estimate from it may be quoted.

Attrition at the 12-month landmark, counted in both result rows and distinct cohorts:

| Clause | Rows | Cohorts |
|---|---|---|
| all extracted results | 69 | 13 |
| report eligible | 69 | 13 |
| not a component-only fragment | 66 | 13 |
| **no unresolved conflict in the source** | 61 | 13 |
| **no employment-related selection at recruitment** | 41 | 10 |
| **no employment-related analytic restriction** | 41 | 10 |
| whole recruited cohort, not an allocated arm | 30 | 10 |
| **trial-derived whole-cohort safeguards** | 24 | 9 |
| point prevalence | 19 | 7 |
| **outcome construct (paid_any)** | 2 | 2 |
| eligible diagnosis group | 2 | 2 |
| at least half the sample has a qualifying diagnosis | 2 | 2 |
| horizon t12m | **0** | **0** |

`carstairs_1992` now survives the diagnosis gate, which it did not before the
conditional `smi_mixed` rule in §3.2.

Both surviving `paid_any` point-prevalence whole-cohort rows fail for reasons that have
nothing to do with the new rules:

- `thomson2023_cohort_t240m_paidany` — 240 months, and the paper states **no
  denominator** at all.
- `twumasi2026_cohort_t0m_paidany` — 21,930/65,630, but this is the **baseline**
  characteristic at month 0, not a follow-up outcome.

Both prespecified sensitivity analyses return **0 cohorts**, as expected: admitting
`unclear` selection or excluding trial-derived cohorts cannot rescue rows that fail on
horizon and construct.

**Action taken, per the prespecified rule (D11.3):** the primary meta-analytic fit
stops. Nothing else stops, and no rule was relaxed after seeing these counts. The rule
itself was written and committed before the counts were produced.

**What this does and does not tell us.** The pilot contains no eligible 12-month
`paid_any` point prevalence. That was anticipated in `docs/pilot_report.md` before the
v0.2 rules were implemented. Whether the review has an analysable primary estimand is
decided by the 75 reports not yet read, not by this table.

---

## 3. Adjudications, separated by what kind of thing each one is

The previous version of this section mixed three different kinds of item and
invited the authorship group to "approve" all of them. That was wrong: facts
established directly from the papers are not a matter for a vote. Recast on
12 August 2026 into the three categories, with the authorship-group decisions of
that date recorded against each.

### 3.1 Source-supported corrections — RATIFIED, not matters for approval

These are established from the papers themselves. Ratified 12 August 2026.

| Item | Correction | Established by |
|---|---|---|
| `lin2026` `arm_type` | `intervention` → **`cohort`** | Single-arm open-label study. `cohort` means the whole recruited **analysis unit** and does not imply an observational design. Parent `design` stays `non_randomised_trial` and the PP1M treatment provenance is retained |
| `lin2026` `post_randomisation_selection` | `yes` → **`not_applicable`** | 521 enrolled → 474 in the employment analysis set, then declining observed-case denominators, is **missing outcome data**, not selection of an allocation-defined subgroup (D12.3c) |
| `rautio2016` construct | `paid_any` → **`paid_intensity_threshold`** | The `<25%` band does not distinguish zero working days from 1–24.9%, so `paid_any` is unidentified with bounds 18 ≤ paid_any ≤ 161. The exact 18/161 rests on three `component_only` rows and can never substitute for `paid_any` |
| `darjee2017` denominator | 137 rejected; `n_outcome_observed` blank, `n_entered = 169` | The printed percentages establish 169 as the authors' **reporting base**, but that arithmetic does not establish employment observation for all 169 |

**Three amendments to the `lin2026` write-up**, all applied:

1. **"All four safeguards" was inaccurate — there are five fields.** The three
   *allocation-related* ones are not applicable to a single-arm study. The other two
   remain applicable and are both `no`: `employment_targeted_intervention` (a licensed
   antipsychotic, no vocational component) and `selective_reweighting` ("No imputation
   methods were employed", Methods 2.4, p. 3).
2. **This change does not admit `lin2026` to the primary pool.** Its results are
   `paid_competitive`; the primary construct is exclusively `paid_any`
   (`config/analysis.yml`, `pool.outcome_construct`).
3. **The complete-cohort bounds are not currently executable**, because
   `n_alive_eligible` is missing. The attrition informs risk of bias and the reading of
   the available-case result, but **521 must not silently substitute** for the
   alive-and-eligible denominator SAP §6 requires.

**Two implementation corrections applied with the ratification:**

- `rautio2016` temporal fields. `followup_months` is now **blank** (the schema permits
  this for a non-baseline anchor), `measurement_age_years = 44.5`,
  `mean_years_since_onset = 17.5`, and the result is renamed from `t210m` to
  `age44_45`. Combining a mean-since-onset figure with an age-anchored measurement in
  one field was the original error.
- `darjee2017`. The 158 survivors are recorded as `n_alive_eligible` on the **endpoint**
  rows; a new structured field `reported_percentage_base = 169` holds the reporting base
  **distinct from** `n_outcome_observed`; and the "voluntary employment" versus
  "supported work" ambiguity is now copied onto the endpoint row itself.
  `outcome_construct = unclear` stands for that supported-work result. Neither the
  endpoint nor the cumulative row may enter a count model without an observed
  denominator.

### 3.2 Schema decisions — RATIFIED

| Decision | Ruling |
|---|---|
| Where employment-related selection attaches | It can attach to the **analysis unit** as well as to recruitment. New `analysis_selection_status` / `analysis_selection_reason` on `extraction_arms.csv`, gated separately in the pool builder and logged as its own clause |
| Nested diagnostic samples | **One participant family, nested analysis units.** Two cohort identifiers would falsely inflate the cohort count and risk treating overlapping participants as independent |
| Non-baseline time anchors | `followup_months` may be blank when `followup_basis` is not `since_baseline`; `measurement_age_years` is then required. Only `since_baseline` is assigned to a horizon |

**`carstairs_1992`, and the SAP/configuration inconsistency it exposed.** The 169 with
schizophrenia are **nested within** the 241-person hospital cohort, not separately
recruited, so the existing single cohort with `cohort` and `sz` analysis units is
structurally correct and stands.

But the configuration contradicted the SAP. SAP §7 admits a sample when at least 50 per
cent carry a qualifying diagnosis, and the whole cohort is 70 per cent schizophrenia —
yet `smi_mixed` was barred by label from `pool.diagnosis_groups`, while the
diagnostically pure 169 could not substitute because a nested subgroup is not a whole
recruited cohort. The cohort was excluded twice over by rules that the SAP does not
impose.

**Resolved in favour of the prespecified 50 per cent rule.** `diagnosis_groups_conditional:
[smi_mixed]` now admits a mixed cohort when **both** `perc_qualifying_diagnosis` ≥ 50
**and** `subgroup_extractable = yes`. `chr` remains excluded unconditionally. The 169
stay a nested subgroup.

### 3.3 Unresolved factual questions — blocked, not voted on

These need author clarification or conservative blocking. There is no version of these
that the authorship group should settle by preference.

| Item | Handling |
|---|---|
| `croatia_rlai` 77/205 vs 77/257 | **Both `conflict_status = unresolved`.** 77/257 remains the competing whole-cohort reading; 77/205 now sits on the `pension_excluded` analysis unit. Neither may be selected as the definitive endpoint denominator before author clarification |
| `croatia_rlai` 30/154 vs 30/142 | **Newly blocked.** The row carried `conflict_status = none` despite the text reporting 30/142 against Table 6's 30/154. Reconciliation with another already-disputed denominator is not sufficient grounds to select 154 |
| `opus_1998` `post_randomisation_selection` | **Stays `unclear`.** The contrast with `lin2026` is the point: Lin identifies its analysis set and its missingness explicitly, whereas Hansen simultaneously describes 496 entering, register data for "all trial participants" numbering 416, and Table 2 as the "entire sample" of 416, with the missing 80 unexplained. That does not establish ordinary attrition rather than selective eligibility, linkage failure, death or emigration. If the authors confirm 416 reflects only register availability with no analytic selection, it becomes `no` |
| `hansen2024` Table 2 totals | **Blocked.** Subgroups sum to 99 and 52 against printed totals of 105 and 54 |

**`opus_1998` analysis samples.** OPUS carries four nested populations that were being
conflated: **578** recruited, **496** diagnostic, **416** register analysis, **143**
clinically reassessed in `hansen2024`, and **174** reassessed in `hansen2024b`. A new
`analysis_sample_id` field on `extraction_outcomes.csv` now names which population each
result belongs to. The OPUS employment rows remain blocked or non-primary regardless,
being period prevalence with unresolved numerator conflicts.

### 3.4 Resolved without an author, on new evidence

**`isrep_rct`: `unclear` → `selected`, reason `baseline_employment_status`.** The
recheck could reach only `unclear`, because `fowler2019` states no eligibility criteria
at all and defers to Fowler et al. 2009b. The authorship group supplied the criterion
from the ISREP primary analysis: eligibility required **being currently unemployed or
engaged in fewer than 16 hours per week of paid employment or education**, corroborated
by the original trial report's account of recruitment on a history of unemployment and
poor social outcome. That meets the SAP §2.1 definition directly.

**The provenance caveat travels with the value in the data.** Fowler 2009b is paywalled
and is **not held in this repository**, so `employment_selection_source` records this as
an authorship-group adjudication citing the ISREP primary analysis, explicitly not
verifiable against any PDF currently held, with the exact printed wording pending
documentary confirmation. The SRT and TAU arms are allocated intervention arms and do
not enter the prevalence intercept in any case.

## 4. Corrections applied from the human reviewer check

| Report | Human reviewer said | Recheck outcome |
|---|---|---|
| `hansen2024` | 416 assessed, missing from the extraction | **Confirmed** in four places. It is the denominator of Table 2 only; 143 is the clinical-interview sample (Tables 1 and 3) and must not be substituted. `n_entered = 496` added |
| `rautio2016` | perc_female missing; n_entered unclear; consider the under-25% band | 71/161 confirmed and recorded **as counts**; `n_entered = 161` confirmed (12,058 is the birth cohort, not the entered count); the band premise corrected as in 3.3 |
| `christensen2019` | Selection is desire for work, not baseline unemployment | **Confirmed exactly.** "All eligible participants expressed a clear desire in competitive employment or education" (p. 1233). Work history was a *stratification* variable; roughly half of each arm had ≥2 months' paid work in the previous 5 years. Cohort is `selected` / `work_intention_or_readiness` |
| `darjee2017` | 137 denominator is an inference | **Confirmed**, and 169 is recorded only as the reporting base — see 3.3. `n_outcome_observed` is blank on all four rows |
| `tarricone2017` | 163 should be 135 | **Confirmed.** Corrected. Also: the construct is not `paid_any` at all, because "Full time study was considered employment" (p. 523) |

---

## 5. New published inconsistencies found, for the author-query file

Beyond the eight already in `docs/evidence_reconciliation.md` §4. High priority marked.

| Report | Inconsistency |
|---|---|
| **`hansen2024`** | **HIGH, now BLOCKED.** Table 2, p. 4379: `Any work` subgroups 84 + 15 = 99 against the printed total **105**; `Work` 49 + 3 = 52 against **54**. Every cell matches its own percentage, so total and parts cannot both be right. This is the `paid_any` numerator for `opus_1998`. `hansen2024b`'s equivalent rows do sum correctly |
| **`hansen2024`** | The step from 496 entered to 416 with register data is never explained |
| **`tarricone2017`** | 75 described as "53% of those still in contact"; 75/135 = 55.6%. Also "high follow-up rate (91%)" against the Abstract's 82.8% (=135/163) |
| **`fowler2019`** | Abstract says 50 (86%) followed up; Method, Table 1 and the CONSORT diagram all give 66 of 77, and 86% only works for 66/77 |
| **`christensen2019`** | The denominators for the 18-month employment-or-education outcome are never printed; 112/243 = 46.1% against the printed 59.9%. Implied interview denominators 187/171/170 against a flowchart giving 186/170/165, and the flowchart lists 243 in an arm that randomised 239. Interview rows sum to 521 against a stated 522 |
| **`dayabandara2026`** | Abstract "43% to 53% in FEC, stable for REC at 42%" matches nothing in Table 4. **43 and 42 are the REC employed *counts*** printed as percentages; 53 is the FEC baseline *unemployed* percentage. Table 4 itself is internally consistent; the corruption is confined to the prose |
| **`mihaljevicpeles2016`** | Pensioners omitted stated as 71 in the text but 52 in Table 7's caption; only 52 reconciles with the analysed n of 205 |
| **`lin2026`** | Fig. 1 labels observed-case proportions "% of total cohort"; month 18 is 127/280 = 45.4%, but as a share of the cohort it is 127/474 = 26.8%. The Abstract says 474 enrolled; Methods says 521 enrolled and 474 analysed |
| **`twumasi2026`** | "38,160 (69.1%)" — 38,160/65,630 = 58.1%. The three printed counts sum to 50,440 (the switcher subsample), not the 65,630 the model is said to use. "550 (1.0%) competing events" against Table 1's 9,690 deaths + 1,540 emigrations. Baseline employment categories cover only 58.7% of the cohort with no residual category |
| `cunningham2025`, `twumasi2026` | Count mismatches consistent with **disclosure rounding** (Stats NZ base-3; Danish ±10). Recorded as rounding, **not** as error |

`twumasi2026` is guarantor-authored: an internal correction, not an external query, and
must be checked by a non-author.

---

## 6. Structural findings carried into Stage F

1. **`dayabandara2026` split into two cohorts** (`nhsl_colombo_fep` n=122,
   `nhsl_colombo_rec` n=118). The previously recorded 99/240 belongs to neither: it is
   57+42 employed over the two recruited totals, mixing an observed-case numerator with
   a denominator including 30 missing and 2 deaths. Correct figures are 57/102 and
   42/108.
2. **`dayabandara2026` construct is `unclear`.** Table 4's "Employed" row is never
   defined. Supplementary File-1 is cited but not held — added to the supplement chase.
3. **`majuri2021`** is `selected` at *result* level (denominator restricted to
   psychiatric disability pensioners) while its parent cohort `nfbc1966` is `none`.
   Handled by the `subgroup` arm mechanism, which keeps the cohort classification
   truthful and still keeps the result out of the primary pool.

---

## 7. Stage F outcome, and what a human needs to check in it

All 75 non-pilot reports were read between 12 and 13 August 2026, in 13 batches formed
from connected components of the report-cohort graph. Output is in
`data/stage_f_shards/F01..F13/` and is **not merged**.

| | |
|---|---|
| Reports | 75 |
| Cohorts | 65 |
| Arms | 104 |
| Results | 208 |
| Risk-of-bias rows | 1,491 |
| Results blocked `conflict_status = unresolved` | **50 of 208** |
| Reports with no recoverable count (`report_quantifiable = no`) | **27 of 75** |
| Cohorts `selected` / `unclear` / `none` on employment criteria | 18 / 5 / 42 |

### 7.1 Three prompt versions, and why that matters

`data/batch_ledger.csv` records which prompt produced which shard: **v1** for F01-F02,
**v2** for F03-F05, **v3** for F06-F13. The differences are substantive, not editorial:
v2 added the risk-of-bias domain vocabulary (D12.7), v3 added `calendar_end_common`
(D12.8) and the rule that `conflict_status = resolved` requires an authority. **The
thirteen shards were therefore not produced under identical instructions**, and a
reviewer comparing them should know that before reading a difference as a disagreement.
F02's domain slugs were remapped after the fact, position to position; F09's
`liangrong2021` rows were recoded to `since_baseline_mean`; F05's `strassnig2018` rows
were reverted from `resolved` to `unresolved`. All three are recorded in the shards.

### 7.2 Two rulings that admit evidence, made after the results were seen

Both were surfaced by extraction, put to the authorship group with the affected result
named, and ratified. Both are labelled post-hoc in `docs/methods_deviations.md` rather
than presented as prospective. **These are the two items in this review most exposed to
the charge of data-driven decision-making and a human should read both entries in full.**

- **D13.** The implementation required an `smi_mixed` cohort to meet the 50 per cent
  diagnosis rule **and** have an extractable subgroup; SAP section 7 requires only the
  first. `carstairs_1992` met both, so the pilot never exposed the difference.
  `khare2022b` did: 90 per cent schizophrenia-spectrum, a whole recruited cohort, no
  extractable subgroup. Its 53/107 at 12 months now enters the primary pool.
- **D14.** D12.2 required derived components to share one denominator, which silently
  forbade summing across mutually exclusive subgroups whose denominators sum to the
  whole. Two batches hit it independently and withheld correct counts.

### 7.3 What is not checked, and must be

1. **Cross-shard duplication.** `check_shard.py` works within a shard only.
2. **The global overlap audit.** Not run. Stage F found two overlaps by reading that no
   `cohort_id` match would have caught: `hartford_ips_rct` is an EIDP site and so overlaps
   `eidp_usa`, and `hk_easy_fep_2001_2003` near-certainly shares its 2001-02 entrants with
   `hk_easy_2001`.
3. **Every extraction judgement.** Nothing in Stage F has been checked by a human. The
   agents' arithmetic reconciliations are recorded in each shard's `inconsistencies.md`
   precisely so a checker need not redo them, but they are not thereby verified.
4. **Two derived rows that D14 permits do not exist yet**, because the rule postdates the
   batches: `jirapramukpitak2022`'s 189/549, and F10's two rows whose components are named
   only in prose.
5. **The three `pending` dispositions.** `killackey2019`, `chan2020` and `benson2022` were
   all adjudicated to `include` in the shards, but `data/inclusion_manifest.csv` still
   says `pending` until the shard `manifest_changes.csv` files are applied.

### 7.4 Refutations of the manifest's own triage notes

Stage F contradicted the provisional notes often enough that they should not be trusted
without a read. Examples a checker can use to calibrate: `chang2016`/`chang2016b` are not
`hk_easy_2001`; `hui2026`'s "158/219" rests on row percentages that establish no
denominator; `drake2015` is not employment-selected and its "27/90" reconciles with
nothing at any of eight timepoints; `andersen2024` is two prospectively defined cohorts,
not one; `unknown2022` is a full article, not a supplement; `mcgurk2016`'s "seeking work"
does not appear in the paper.

---

## 8. The governance gate

Three of the four items are closed. Stage F has run.

1. ~~**D8 search update run and the report universe frozen.**~~ **Closed 12 August 2026.**
   The search was already complete. 2 June 2025 was the close date of an *earlier*
   search; the executed search closes **9 June 2026**. `DATA_EXTRACTION_FINAL.xlsx` and
   the 90 PDFs in `dissertation_shared_folder/Data Extraction Papers` are the
   authoritative report universe, and the PRISMA flow of 3 August 2026 confirms n = 90.
   The universe is frozen, so batching is fixed. See D8.
2. ~~**Authorship ratification of SAP v0.2 and of the Stage B adjudications**~~ in §3
   above: the `croatia_rlai` granularity compromise, `opus_1998`
   `post_randomisation_selection = unclear`, `isrep_rct` `unclear`, the `lin2026`
   single-arm reclassification, and the `carstairs_1992` nesting. **Done.**
3. ~~**PROSPERO amendment submitted.**~~ **Done, version 4.0, 12 August 2026.** The
   search-date field is amended to 9 June 2026.
4. **A clean frozen commit** pinning data, code, config, prompts, environment and PDF
   hashes. **Still open.** This is now the only item between here and the end of the
   review that is not extraction work.

Author correspondence and independent human verification are **pre-freeze** requirements.
They were not prerequisites for starting extraction and both are now outstanding.

---

## 9. Not yet done

- **The Stage G merge**, in the order set out in `docs/handover.md`: apply the shard
  `manifest_changes.csv` files, add the nine cohorts Stage F created, merge and fail loud
  on collisions, then the global overlap audit.
- Independent **human** verification of every pool-determining field and every RoB
  judgement. A second agent is not a second human and this report does not treat it as
  one. `extraction_provenance.csv` exists to carry that ledger; it is empty.
- Author queries sent, and the response window closed. 50 blocked results and 27
  unquantifiable reports now feed this.
- The clean frozen commit pinning data, code, config, prompts, environment and PDF
  hashes.
- **Any model fit.** The primary fit is stopped by the prespecified sparse-data rule
  (D11.3). Written before any of these counts were seen, it now looks like the operative
  outcome rather than a contingency.

---

## 10. Open schema questions raised by extraction

Raised by Stage F, not settled by it. None blocks the merge. Each is recorded in the
relevant shard's `unresolved_queries.md`.

1. Which instrument appraises a **single-arm proportion drawn from a trial**. F07 applied
   `rob2` only where the report itself presents a randomised between-arm comparison of the
   employment outcome, and `jbi_prevalence` otherwise. Consistent, but undefined.
2. Whether **`component_only` fragments need risk-of-bias rows** at all, having no
   estimand and entering no pool.
3. Whether **D12.8's bar should carry a dispersion condition**: `xu2020`'s mean cannot
   span two horizon bands, `andersen2026`'s does.
4. Whether a **duration threshold inside the follow-up window** is
   `paid_intensity_threshold`.
5. **Vocabulary gaps**: no `missing_data_method` value for full information maximum
   likelihood; no `ascertainment` value for a duration outcome; no region value for
   Southeast Asia.
