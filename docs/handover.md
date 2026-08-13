# Handover — start here

**Rewritten 12 August 2026, documents swept for staleness 13 August 2026** for whoever
picks this up next.

Read this, then `docs/extraction_qa_report.md`, then `config/codebook.md`. Everything
else is detail.

Two documents are deliberately **not** brought up to date and carry a stale-warning
header instead, because rewriting them is itself an open task: `docs/data_requests.md`
(task 2) and `docs/Human_extraction_check.md`, which records a human check of the **pilot
only** and must not be read as covering Stage F.

---

## Where the project is

**Stage F is finished. All 75 non-pilot reports are extracted.** The shards are written,
verified and **not merged**. Stage G is next, and it starts with the merge.

All gates pass:

```
/opt/anaconda3/bin/python3 scripts/check_folder.py   exit 0   90 screened studies, readable PDFs
/opt/anaconda3/bin/python3 scripts/check_shard.py    exit 0   13 shards structurally sound
Rscript R/01_validate_data.R .                       exit 0   0 warnings
Rscript tests/testthat.R                             exit 0   90 pass, 0 fail, 0 skip, 0 warn
```

`data/extraction_*.csv` still holds **only the 15-report pilot**. Nothing from Stage F is
in it. `sample_status` is `DEFINITIVE EXTRACTION IN PROGRESS - NOT FOR INFERENCE` and
stamps every output. **No estimate from anything currently in `data/` may be quoted.**

**Nothing is committed.** The whole of this work is in the working tree.

### What Stage F produced

In `data/stage_f_shards/F01..F13/`, copied out of the session scratchpad, which is
session-scoped and would otherwise have taken the lot with it.

| | |
|---|---|
| Reports | 75 |
| Cohorts | 65 |
| Arms | 104 |
| Results | 208 |
| Risk-of-bias rows | 1,491 |
| Results blocked `conflict_status = unresolved` | **50 of 208** |
| Reports with no recoverable count (`report_quantifiable = no`) | **27 of 75** |
| Cohorts `selected` on employment criteria | 18 |
| Cohorts `unclear` | 5 |
| Cohorts `none` | 42 |

Three prompt versions produced these, and `data/batch_ledger.csv` records which produced
which shard: **v1** for F01–F02, **v2** for F03–F05, **v3** for F06–F13. The differences
are real (v2 added the risk-of-bias domain vocabulary, v3 added `calendar_end_common` and
the rule that `conflict_status = resolved` needs an authority), so do not treat the
thirteen shards as having been produced under identical instructions.

---

## The four open tasks, in order

### 1. Stage G — merge, overlap audit, verify

**The merge is not a concatenation.** Work through these in order.

**a. Apply the shard `manifest_changes.csv` files.** Every shard has one and they are not
yet applied. They carry the corrections that Stage F established by reading the papers,
including the three `pending` dispositions. `data/inclusion_manifest.csv` still says
`pending` for `killackey2019`, `chan2020` and `benson2022`; all three were adjudicated to
`include` in the shards. Until these are applied the manifest understates what is known.

**b. Add the cohorts Stage F created.** Refutations of the manifest's provisional
`cohort_id` produced cohorts that exist in shards but not in the manifest:
`hk_standard_care_2000`, `hk_easy_fep_2001_2003`, `hk_easy_ext_rct`,
`headspace_hep_fep_au`, `headspace_hep_uhr_au`, `fi_registers_scz`, `fi_registers_nonaff`,
`tallinn_fep_tau`, `glasgow_edinburgh_2006`. Each has its evidence in the shard.

**c. Merge deterministically and fail loud** on a duplicate `report_id` or `result_id`, or
on a cohort given conflicting attributes by two batches. `scripts/check_shard.py` already
checks within a shard; it does **not** check across shards, and cross-shard duplication is
the risk the merge introduces.

**d. Global overlap audit across all batches.** Sites, recruitment dates, programme and
trial names, registries, author overlap, sample sizes. Matching `cohort_id` cannot find
overlap nobody has recognised. Every candidate pair goes to human adjudication and is
never merged automatically. Stage F already found two by reading: `hartford_ips_rct` is an
EIDP site so it overlaps `eidp_usa`, and `hk_easy_fep_2001_2003` near-certainly shares its
2001–02 entrants with `hk_easy_2001`.

**e. Two derived rows still need writing under D14.** The rule was ratified *after* the
batches ran, so the counts it permits are **not in the shards**:

- **`jirapramukpitak2022` 189/549** at 12 months, from 146/372 and 43/177, verified cell
  by cell in F08. This is the one to do first: the cohort is
  `employment_selection_status = none`, which makes it one of the few eligible for the
  primary pool at all.
- **F10's two derived rows** carry their components in prose with
  `derivation_component_result_ids` left blank, because the old rule rejected them.

**f. Validate, then the human verification.** `Rscript R/01_validate_data.R .` and the
test suite must pass on the merged data. Then independent **human** verification of every
value that can move a result into or out of the primary pool, and every risk-of-bias
judgement. `data/extraction_provenance.csv` exists to carry that ledger and is **empty**.
A second agent is not a second human and nothing here treats it as one. `twumasi2026` is
guarantor-authored and must be checked by a non-author.

**g. Build the pool** and print the attrition in both result rows and distinct cohorts. If
it is sparse, apply D11.3 as written: the primary fit for that horizon stops and nothing
else does. That rule was written before any of these counts were seen and it holds.

### 2. Author queries (task #12)

`docs/data_requests.md` is still the old narrative list and needs rewriting as send-ready
per-report emails. Stage F multiplied the inputs: **50 results are blocked on unresolved
published contradictions**, each with its candidate resolution already recorded in
`conflict_note` and the shard's `unresolved_queries.md`. The highest-value requests
identified by the batches:

- `solmi2022` — a 21,551-person national register cohort reporting percentages only. By
  far the largest single loss in the review.
- `basaraba2023` — the paid-employment component separated from its EET composite would
  give `ontracky_ny` a `paid_any` result at two landmarks.
- `hui2026` — the denominator behind "158/219", which F08 refuted; the table's
  percentages are row percentages, so it establishes no denominator at all.
- `ayesaarriola2020` — the 10-year denominators, which exist only as 35/0.327 and 22/0.244.
- `moncrieff2025` (RADAR) — a paid-only numerator; it is the only F10 cohort passing D9 as
  a whole recruited cohort at a landmark horizon.

**Contact details go in `private/contact_log.csv`, gitignored.** The public manifest
carries only `data_request_status`, `data_request_date`, `data_response_date`. Do not put
author emails in the repository. Emails are drafted for the team to send; nothing is sent
from here.

### 3. A PROSPERO version 5.0 amendment — D13 and D14 are not registered

**This is the most criticisable gap in the review as it stands, and it was created by
Stage F.** Version 4.0 was submitted on 12 August 2026 carrying D9 to D12. D13 and D14
were settled *after* that submission, during extraction. **Both admit evidence to the
primary pool, and both were made after the affected results had been seen.** No registry
version records either.

That combination is exactly what a registry amendment exists to disclose. The deviations
log labels both honestly and states the sequence, but an internal document is not the
registry. `docs/prospero_amendment_draft.md` has not been extended to cover them and
needs a new section for each, stating the timing plainly rather than softening it.

D12.7 and D12.8 also postdate the submission. They are schema bookkeeping that changes no
result's eligibility, so they are lower priority, but the amendment should mention them
for completeness.

### 4. The clean frozen commit

The last governance item. Pin data, code, config, prompts, environment and PDF hashes.
`sample_status` becomes `full` only after the author-response window closes, human
verification is complete with adjudications recorded, and final validation passes.

---

## Rules that are easy to get wrong

These each cost real rework already.

1. **`keep()` in `build_primary_pool` counts `NA` as removed.** A clause on a column that
   is blank or absent silently empties the pool while the log shows a filter working
   normally. Every clause is guarded by `need_cols()`. Keep it that way.
2. **`paid_any` means *any* paid work.** Not competitive-only, not sheltered-only, not
   above a threshold. Sheltered and welfare-remunerated placements are **not** paid work:
   SAP 3.1 excludes benefit remuneration, which is why `jump_norway`'s work placements and
   `nakamura2025`'s Type B work are excluded. `rautio2016` remains the worked example of an
   unidentifiable `paid_any`.
3. **A reporting base is not an observed denominator.** `darjee2017` is the original case;
   Stage F added many. Printed percentages prove what the authors divided by, never that
   the outcome was observed for that many people.
4. **Never back-calculate a count from a percentage.** This is absolute and D14 did not
   soften it. Several Stage F reports print a percentage beside a denominator that would
   yield a whole number; every one was refused. Blank plus a note beats a confident wrong
   value.
5. **Attrition is not post-randomisation subgroup selection** (D12.3c). It lives in
   `n_outcome_observed`, `missing_data_method`, RoB and the bounding analyses.
6. **Being a component is a relationship, not a property** (D12.2). `component_only` is
   only for fragments meaningless alone.
7. **`conflict_status = unresolved` blocks a result from every synthesis**, and `resolved`
   requires an **authority** — an author reply or an authorship-group ruling. An
   extractor's own reconstruction, however convincing the arithmetic, is not one. This was
   applied against F05's `strassnig2018` call and is now rule 14 of the extraction prompt.
8. **Cohort-level selection and analysis-level restriction are different facts.** A cohort
   recruited on employment criteria is `employment_selection_status = selected`; an
   analysis whose denominator is restricted to the baseline-unemployed is
   `analysis_selection_status`. Both bar a result and the review records them separately.
   `tsiachristas2016` and `solmi2022` are the cases.
9. **Only time measured from cohort entry can take a landmark horizon.** Four barred
   values now exist and they mean different things: `since_onset_mean`,
   `chronological_age`, `calendar_end_common` (D12.8, a shared end date) and
   `since_baseline_mean` (a mean or median elapsed follow-up). Two batches in a row reached
   for whichever was nearest; the horizon was barred correctly each time but the record
   said something untrue about the source.
10. **The migration scripts are idempotent and must stay so.** Run any of them twice and
    confirm the second run is a no-op. `build_batches.py` additionally refuses to rewrite a
    batch that has already run.
11. **The report universe is 90 and it is frozen.** `DATA_EXTRACTION_FINAL.xlsx` and the
    90 PDFs are the authority, not `data/`. The search closed **9 June 2026**. If any
    document still says the search closes 2 June 2025 or that an update is outstanding, it
    is stale. The six off-list reports stay off-list; re-entry needs a documented
    screening-list amendment under D10.1, not a status change and not a search rerun.

---

## Open questions for the authorship group

Raised by extraction, not settled by it. None blocks the merge; all are recorded in the
shards' `unresolved_queries.md`.

- **Which instrument appraises a single-arm proportion drawn from a trial.** F07 applied
  `rob2` only where the report itself presents a randomised between-arm comparison of the
  employment outcome, and `jbi_prevalence` to every other proportion. Consistent, but
  undefined by the schema.
- **Whether `component_only` fragments need risk-of-bias rows at all.** F03 argued not, as
  they have no estimand and enter no pool.
- **Whether D12.8's bar should carry a dispersion condition.** `xu2020`'s mean cannot span
  two horizon bands; `andersen2026`'s does. F13 raised it.
- **Whether a duration threshold inside the follow-up window is `paid_intensity_threshold`.**
  F13 coded `zhang2017` and `turner2019` that way.
- **Vocabulary gaps**: no `missing_data_method` value for full information maximum
  likelihood; no `ascertainment` value for a duration outcome; no region value for
  Southeast Asia.

---

## Map of what matters

| File | What it is |
|---|---|
| `data/stage_f_shards/F01..F13/` | **The Stage F output.** Unmerged. Each holds five extraction tables, `report_cohort_map.csv`, `provenance.csv`, `manifest_changes.csv`, `inconsistencies.md`, `unresolved_queries.md`, `COMPLETE` |
| `data/batch_ledger.csv` | Which model, prompt version, prompt hash and PDF hashes produced each shard |
| `docs/extraction_qa_report.md` | State of every adjudication. §7 is the governance gate |
| `docs/methods_deviations.md` | D1–D14. **D13 and D14 both admit evidence and were made after the affected results were seen**; both say so explicitly |
| `config/codebook.md` | v0.3. How to fill the tables |
| `config/prompts/extraction_v1..v3.md` | The versioned extraction prompts, hashed into the ledger |
| `config/analysis.yml` | Pool gates, horizons, sparse-data rule, the two executable sensitivities |
| `config/vocabularies.yml` | Every controlled vocabulary, including `rob_domain` (D12.7) |
| `R/lib_data.R` | Validation, the derived-count rules (D14) and the single `build_primary_pool` |
| `data/extraction_provenance.csv` | Field-level provenance and the human-verification ledger. **Empty** |
| `scripts/check_shard.py` | Shard structural check. Does **not** check across shards |
| `scripts/build_batches.py` | The batch planner. Preserves run fields; refuses to rewrite a batch that ran |
| `DATA_EXTRACTION_FINAL.xlsx`, `dissertation_shared_folder/Data Extraction Papers` | **The authoritative report universe, frozen.** Search closed 9 June 2026 |

---

## What is deliberately not done

- **The merge.** Deliberately left to Stage G, with the manifest changes and new cohorts
  above.
- **Independent human verification.** Required before the freeze, not before extraction.
  `data/extraction_provenance.csv` is empty and is the ledger for it.
- **Author correspondence sent.** Drafts are task 2; sending is the team's.
- **Any model fit.** The primary fit is stopped by the prespecified sparse-data rule
  (D11.3), written before the counts were seen.
- **`rob_overall` as a moderator.** Suspended, not deleted (D12.6).
- **`isrep_rct` documentary confirmation.** Coded `selected` on authorship-group
  adjudication; Fowler et al. 2009b is paywalled and not held, and the data says so.
