# Verification wave 1: brief for the checking team

**Created 13 August 2026. Wave 1 closes 18 August 2026.**

## Check against the tag, not against `main`

```
git checkout stage-g-merge
```

`stage-g-merge` pins the merged, validated, **explicitly non-inferential** baseline.
Work against that exact tag. `main` will move while you are checking, and a checker
reviewing a moving target cannot say what they checked.

Record every check in `data/extraction_provenance.csv`, which already contains the
full denominator: **6,773 rows, one per (result, field) that can matter**, with
`verifier` blank. Each row carries `verification_tier` and `source_version`, and
`source_version` is `stage-g-merge` for every row in this wave.

**A blank is not an omission, it is the point.** Blanks are never deleted. Completion
is a fraction by tier, never a claim that checking is done.

| Tier | Rows | What it covers |
|---|---|---|
| 0 | 323 | Everything needed to fix the primary pool and the D11.3 action |
| 1 | 522 | Report eligibility, report-to-cohort mapping, cohort identity, overlap |
| 2 | 4,437 | Remaining prevalence families and horizon-defining fields |
| 5 | 1,491 | Result-level risk-of-bias domains |

**Tier 5 will not be finished by 18 August and is not promised.** It is required
before any risk-of-bias analysis, GRADE, interpretation or release, and not before the
primary intercept fit provided risk of bias stays outside that model.

## What the baseline contains

90 reports, 78 cohorts, 131 arms, **278 results**, 1,491 risk-of-bias rows. The
validator and all 90 tests pass on it. The provisional primary pool at twelve months
is **k = 3, none of it verified**.

Read `results/design_package/` before you start. It holds the pool at all four
horizons, both prespecified sensitivity analyses, the selected results, and
filter-by-filter attrition in **both** result rows and distinct cohorts. Every file is
stamped `DEFINITIVE EXTRACTION IN PROGRESS - NOT FOR INFERENCE`. No posterior has been
sampled on any of this.

## Tier 0 target list, in priority order

These decide the primary pool. Do these first.

1. **The four candidate rows.**
   - `khare2022b_cohort_t12m_paidany`, 53/107
   - `khare2021_cohort_t12m_paidany`, 287/456
   - `andersen2024_fep_cohort_t12m_paidany`, 205/578
   - `mayoralvanson2019_cohort_t12m_paidany`, 36/156, currently out of the pool and the
     nearest to entering it
2. **The three derived rows' components.** Recompute the arithmetic against the source,
   independently. Every derived row in the baseline carries a blank or explicitly
   pending `checked_by`, because no human has checked one yet.
3. **`andersen2024`: does "employment" establish remuneration?** If it cannot be
   established, the construct is recoded `unclear` under SAP 3.1 and the row leaves the
   pool. This is `REQ-andersen2024-1`.
4. **`khare2021`: the denominator, 456 or 459, and the construct.** Two students and one
   volunteer were removed and their statuses appear observed. A substantial minority of
   the numerator worked in family businesses without separate wages. `REQ-khare2021-1`
   and `REQ-khare2021-2`.
5. **`khare2022b`: the D13 fields.** `perc_qualifying_diagnosis` = 90, and whether
   "employed" requires remuneration in every case.
6. **`mayoralvanson2019`: the analysis selection.** How were the 157 chosen? This is
   the single field keeping the row out.
7. **`employment_selection_status` and `analysis_selection_status` on every candidate
   cohort and arm.**
8. **`andersen2024`: the cohort split and the 9-month versus 12-month selection.** The
   report carries both, and which one the review selected is a pool-determining choice.

**Tier 0 attribution, stated exactly, because an earlier draft had it reversed:**
`perc_qualifying_diagnosis` **90 per cent belongs to `khare2022b` / `pune_public`**;
**59.3 per cent belongs to `khare2021` / `pune_private`**.

## Assignment rules

- **The two Pune cohorts go to different checkers.** They are the top item on
  `docs/overlap_audit_queue.md` and both are in the pool; one person's reading of the
  recruitment description must not be the only thing separating them.
- **`twumasi2026` is checked by a named non-author.** It is co-authored by the review
  team, so its check is not arm's length unless the checker is outside it.
- A second automated agent is not a second human, and nothing in this process treats
  one as such.

## What to do when you disagree with an extracted value

Record the disagreement, do not edit the merged table. Fill `verified_value`,
`agreement` and `adjudication` in the provenance ledger. Corrections are applied
through the merge inputs and the merge is rerun, because the merged tables are a
function of the frozen shards, the manifest and relationship changes, and this ledger.
Hand-editing a merged table breaks that and the correction is lost at the next merge.

The shards under `data/stage_f_shards/` are **immutable**. Nothing writes to them
again.
