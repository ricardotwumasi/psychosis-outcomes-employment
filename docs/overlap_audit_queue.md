# Global overlap audit queue

**Created 13 August 2026, at the `stage-g-merge` baseline. For human adjudication.**

Two cohorts that share participants are one cohort for the random effect. Treating
them as two counts the same people twice and narrows every interval. Matching
`cohort_id` cannot find an overlap nobody has recognised, so this queue exists.

**Nothing here is ever merged automatically.** Each pair is decided by a human, the
decision is recorded with its evidence, and the decision is made **before** anyone
looks at a pooled estimate. A merge decision taken after seeing what it does to the
number is not a merge decision.

This queue does not block the merged baseline, which is explicitly non-inferential.
**It blocks the pool freeze.** No horizon may be frozen while a pair on this queue
that could change its k is unresolved.

## How to record a decision

Append the adjudication to this file with the date, the adjudicator and the evidence
consulted. If a pair is merged, the correction goes through the merge inputs
(`data/stage_g_reconciliation.csv` or the relationship map), never by hand editing a
merged table, and the merge is rerun.

---

## 1. The Pune pair: `pune_public` and `pune_private` — HIGHEST PRIORITY

**Why first.** Both are in the provisional twelve-month primary pool, which stands at
k = 3. If they are one cohort, k falls to 2 and the pool loses a third of its
evidence. At this k the decision is consequential in a way it would not be at k = 30.

**What the shards say.** They are distinct sites in distinct sectors: `pune_public` is
the public-hospital cohort reported by `khare2022` and `khare2022b`; `pune_private` is
the private-sector cohort reported by `khare2021`, recruited across Ahmednagar and
Pune sites. The initial evidence therefore supports keeping them separate.

**What a human must establish.** Whether any participant appears in both. The reports
do not state it either way, and both are from the same investigator group in the same
city over overlapping years. The recruitment windows are not printed in `khare2021`,
which is `REQ-khare2021-4` in `docs/data_requests.md`.

**Assign the two cohorts to different checkers**, so that one person's reading of the
recruitment description is not the only thing separating them.

**Status: adjudicated, distinct cohorts.** Adjudicated by the review team and confirmed by the
guarantor on 23 September 2026: `pune_public` and `pune_private` are separate cohorts with no
shared participants, and both stay in the twelve-month pool as two cohorts. `REQ-khare2021-4`
(recruitment windows) drew no reply, so the adjudication rests on the sites and sectors the
reports describe; that is recorded as a limitation of the k = 2 twelve-month pool, both of whose
cohorts come from one investigator group.

---

## 2. `hartford_ips_rct` and `eidp_usa`

**Why.** The Hartford IPS trial site is an Employment Intervention Demonstration
Program site, so its participants may be inside the EIDP 449. Stage F found this by
reading rather than by identifier matching.

**What a human must establish.** Which six of the eight EIDP sites joined the
supplemental study (`REQ-cook2016-4`), and whether the `detore2019` participants are
among them.

**Consequence.** Neither cohort currently reaches the twelve-month primary pool, so
this does not move k today. It would matter for the intervention synthesis and for any
horizon that later admits either cohort.

**Status: open.**

---

## 3. `hk_easy_fep_2001_2003` and `hk_easy_2001`

**Why.** `hk_easy_2001` is 148 EASY entrants from 1 July 2001 to 30 June 2002 with a
schizophrenia-spectrum diagnosis. `hk_easy_fep_2001_2003` is 700 EASY enrollees from
July 2001 to August 2003. Both are described as territory-wide consecutive enrolment,
so the first is almost certainly inside the second. **Neither report says so.**

**Current handling.** Recorded as separate cohorts with reciprocal `overlaps_with`
rows, and their results must never be pooled. If an author confirms the overlap they
must be treated as one cohort for the random effect.

**Consequence.** Neither contributes a usable employment count at present, because
`hk_easy_2001` has no extractable numerator at any timepoint. The decision becomes
live the moment `REQ-chan2020-1` is answered.

**Status: open.**

---

## 4. `headspace_hep_fep_au` and `headspace_hep_uhr_au`

**Why.** The programme admits ultra-high-risk young people "who do not go on to
develop a psychotic disorder", which implies some do transition. The report does not
say whether a transitioning participant is re-entered in the FEP cohort or how many
transitioned, so the two cohorts cannot be verified as disjoint.

**Consequence.** `headspace_hep_fep_au` carries `andersen2024` 205 of 578, which is
one of the three provisional twelve-month primary rows. The UHR cohort is barred from
the primary estimand outright, so an overlap would not add a cohort; it would mean the
FEP denominator includes people counted in a cohort the review treats separately, and
it bears on how the FEP cohort is described.

**What a human must establish.** The answer to `REQ-andersen2024-3`.

**Status: open.**

---

## Pairs deliberately not queued

| Pair | Why it is not an open question |
|---|---|
| `nhsl_colombo_fep` and `nhsl_colombo_rec` | Two parallel cohorts of one pilot report, prospectively defined as first-episode against relapsing, and mutually exclusive by construction. Recorded in `report_cohort_map.csv`. |
| `fi_registers_scz` and `fi_registers_nonaff` | Three separately ascertained national case groups, each with its own matched controls, analysed separately, with no participant in more than one and no pooled analysis in the source. |
| `jump_norway` reports | Five reports of one cohort, already mapped to a single `cohort_id`. Not an overlap question but a report-to-cohort one, and settled. |
| `opus_1998` and `national_eden` | `leighton2019` validates a prediction model on OPUS participants; the relationship is recorded as `validation_sample` and its figures must not be pooled alongside `hansen2024`. Recorded, not open. |
