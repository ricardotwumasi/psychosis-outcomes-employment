# Stage F extraction prompt, version 3

**Version 3, 12 August 2026.** Hash this file into `data/batch_ledger.csv`
(`prompt_file`, `prompt_sha256`) for every batch it drives. Changing this file means a
new version and a new hash, never an edit in place, because the ledger has to be able to
say which wording produced which shard.

**Changed from version 1:** risk-of-bias domain slugs are now a controlled vocabulary.
Batches F01 and F02 ran under version 1 and independently coined incompatible slugs for
the same JBI checklist, because version 1 did not say. Neither shard was wrong; the
schema was.

**Changed from version 2:** `followup_basis` gains `calendar_end_common`, and rule 13
below is new. Batches F03 to F05 ran under version 2.

---

## What you are doing

You are extracting one batch of reports for a systematic review of employment outcomes in
psychosis. You will be given a batch id, a list of report ids with their PDF paths, and a
shard directory. You read the papers and write the extraction tables.

**Read first, in this order:** `config/codebook.md` (how to fill every field),
`docs/statistical_analysis_plan.md` §§2, 3, 4, 6, 7 (why the fields are what they are),
`docs/methods_deviations.md` D9 to D12 (the rules that override anything older).

Where a source and the codebook disagree, the codebook wins. Where the codebook and
`docs/methods_deviations.md` disagree, the deviations log wins: it is more recent.
The Stage F section of `~/.claude/plans/hello-claude-let-s-continue-mellow-cake.md` is
**stale in two places** and must not be followed: its intensity-band rule is reversed by
D12.3, and its `component` value is now `component_only`.

## Where your output goes

Everything to `<shard_dir>/`, nothing to `data/`. Batches must never race, and a shard is
merged only once it is marked complete and validates standalone.

| File | Contents |
|---|---|
| `extraction_reports.csv`, `extraction_cohorts.csv`, `extraction_arms.csv`, `extraction_outcomes.csv`, `extraction_rob.csv` | Same headers as `data/`, your rows only |
| `report_cohort_map.csv` | The confirmed report↔cohort rows for what you read |
| `provenance.csv` | One row per (`result_id`, `field`) for every primary-determining field |
| `manifest_changes.csv` | `report_id`, `field`, `old`, `new`, `reason` for any manifest correction |
| `inconsistencies.md` | Every internal contradiction: report id, what the paper prints, what the arithmetic gives, exact location |
| `unresolved_queries.md` | What an author would have to answer, per report |
| `COMPLETE` | Written last, and only if every report in the batch is done |

## The rules that are not negotiable

1. **Never back-calculate a count from a percentage.** Blank plus a note beats a
   confident wrong value. If the paper prints 46% and no denominator, the numerator is
   unrecoverable, and that is the finding.
2. **Never type a percentage** into a count column, and never type `p_obs`, `horizon`,
   `followup_years`, `prop_unobserved` or any `perc_*` field. Those are computed.
3. **`source_locator` on every row.** Page, table or figure number, and enough of it that
   a checker finds the value without rereading the paper.
4. **`outcome_verbatim` is quoted, never paraphrased.** It is the evidence that the
   construct coding is right.
5. **`paid_any` means *any* paid work.** Not competitive-only, not sheltered-only, not
   above a threshold. Substituting a competitive-employment count for `paid_any` changes
   the numerator while keeping the label, which is the error D12.3a exists to stop.
6. **Intensity bands (D12.3).** Derive `paid_any` from bands only when the categories are
   mutually exclusive and exhaustive **and zero work is separable from every category
   containing positive paid work**. A residual band of `<25%` pools people who never
   worked with people who worked 1 to 24.9%, so `paid_any` is **not identified**: record
   the bounds, leave the numerator blank, keep any exact threshold-defined result as
   `paid_intensity_threshold`. Set `derivation_zero_separable` truthfully.
7. **A reporting base is not an observed denominator.** Printed percentages prove what the
   authors divided by, not that the outcome was observed for that many people. That goes
   in `reported_percentage_base`; `n_outcome_observed` stays blank unless the paper says
   it was observed.
8. **Attrition is not post-randomisation subgroup selection (D12.3c).** Loss to follow-up
   belongs in `n_outcome_observed`, `missing_data_method`, risk of bias and the bounding
   analyses. Reading it as subgroup selection would fail every study in the review.
9. **Being a component is a relationship, not a property (D12.2).** A reported competitive
   count can feed a derived `paid_any` *and* stay a valid secondary result. Use
   `component_only` only for fragments with no independent meaning, such as a lone
   intensity band.
10. **`conflict_status = unresolved` where a source contradicts itself** about a result.
    That blocks the result from every synthesis. A note alone is not enough, because a
    numerically complete row stays usable and enters a pool silently.
11. **Two separately recruited samples in one report get two `cohort_id`s** and two rows
    in `report_cohort_map.csv`, not two `subgroup` arms.
12. **Employment selection (D9) decides the primary pool.** Code `none`, `selected` or
    `unclear` with the source wording and its location. Selection includes baseline
    employment status, wanting or readiness to work, an employment goal, vocational
    eligibility or placement, and previous employment failure. Only `none` enters the
    primary synthesis. If the paper does not say, it is `unclear`, not `none`.

13. **A shared calendar end date is not an elapsed follow-up (D12.8).** Where every
    participant is followed from entry to one common end date, elapsed follow-up varies
    across the cohort and the printed figure is its mean. Code `followup_basis =
    calendar_end_common`, not `since_baseline` and not `unclear`. It is barred from every
    landmark horizon, for the same reason as a mean time since onset: a mean of 4.5 to
    23.5 years spans two bands. Use `unclear` only where the report genuinely does not
    establish what the timepoint is measured from, because `unclear` is read as poor
    reporting in the risk-of-bias and missing-evidence assessments.
14. **`conflict_status = resolved` needs an authority, not an inference.** The vocabulary
    requires it to record *on whose authority* the contradiction was resolved. An author
    reply or an authorship-group ruling is an authority. Your own reconstruction, however
    convincing the arithmetic, is not: record it as the candidate resolution in
    `conflict_note` and in `unresolved_queries.md`, and leave the status `unresolved`.

## Risk of bias, in the same pass

Identify the estimand **first**, then apply exactly one versioned instrument:
`jbi_prevalence` for a whole-cohort prevalence, `rob2` for a randomised effect,
`robins_i` for a non-randomised effect. Never assess under two speculatively. Leave
`checker` blank: that is Stage G's, and it is a human's.

**Domain slugs are a controlled vocabulary. Do not invent them.** Take them verbatim
from `rob_domain` in `config/vocabularies.yml`, which lists the complete set for each
instrument. The validator rejects any slug outside it.

**Every domain of the chosen instrument is required for every result**, each with its
own `rationale` and `source_location`. The validator rejects a result that is missing
one. If a domain genuinely does not apply, say so with the instrument's own
`not_applicable` judgement and a rationale. Do not omit the row: an absent domain is an
unasked question, and once the appraisal is summarised it is indistinguishable from a
favourable answer.

## Your batch may share a cohort with another report

Check the batch note in `data/batch_ledger.csv`. If your batch carries reports on one
cohort, or shares a cohort with a report already extracted in `data/extraction_*.csv`,
read those rows before selecting a result. The result-selection rule (SAP §§4 and 5,
D11.1 and D11.2) picks **one** result per cohort per horizon: nearest the landmark
first, ties to the longer horizon, then the SAP §5 order. You cannot apply it to a report
you have not seen, which is why components are batched whole.

Where a batch note says a report has **no confirmed cohort** and was batched on a triage
hint, the hint asserts nothing. Confirm it or refute it from the paper and write the
confirmed row either way.

## Stop and say so

Write it to `unresolved_queries.md` and leave the field blank rather than guessing, when:
the PDF is unreadable or truncated; a table is cited but absent; the construct is never
defined; the denominator shifts between table and text; or the follow-up is a mean time
since onset or a fixed chronological age rather than time from cohort entry (D12.3b,
which is not assignable to a landmark horizon at all).

A blank with a note is a usable finding. A plausible-looking wrong number is not
recoverable once it is in the pool.
