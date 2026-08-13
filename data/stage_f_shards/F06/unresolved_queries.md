# Batch F06 unresolved queries

What an author, or in two cases the authorship group, would have to answer before the
affected field can be filled or the affected decision can be relied on. Ordered by report,
with the two schema-level questions last.

Batch: F06. Extractor: claude-opus-5. Date: 12 August 2026.

---

## baltazar2022

**U1. Was any of the 43 in supported or sheltered *paid* work at 27-31 years, and is
"occupational therapy" unpaid?**
The text prints three categories for the 43 observed (no occupation 29, jobs on the regular
market 6, occupational therapy 8), while Fig. 1's legend carries a fourth employment
category, "Supervised", which the arithmetic forces to zero at this timepoint. The derived
`paid_any` of 6/43 rests on two readings: that the Supervised category is empty, and that
occupational therapy carries no remuneration. Both follow from the printed counts and from
the authors' own framing of employment as "supported or competitive employment" (Abstract),
but neither is stated. *Field affected:* `n_employed` on
`baltazar2022_cohort_t348m_paidany`. *If the answer is that some of the 8 were paid,* the
numerator rises and the derivation must be withdrawn, leaving `paid_any` bounded
6 ≤ x ≤ 14.

**U2. The derived `paid_any` count has not been independently checked.**
`checked_by = unchecked_pending_stage_g`, which records the fact rather than asserting a
check that did not happen. The codebook requires an independent check of the arithmetic for
any derived count, and a single automated extractor produced both the component row and the
derived row. *Action:* a human checker at Stage G must recompute 29 + 6 + 8 = 43 against
p. 1321 and Fig. 1 and either fill `checked_by` or reject the row. This is the only derived
count in the batch.

**U3. What is the distribution of elapsed follow-up, and were occupational data collected on
one date?**
The paper gives 27-31 years and a single review date (2014); `followup_months = 348` is the
midpoint of that range and is not a reported figure. *Field affected:* `followup_months`.
Not resolvable from the report, and not consequential while
`followup_basis = calendar_end_common` bars the result from every horizon.

---

## bell2018

**U4. Is the VR+CG 12-month competitive employment denominator 38 or 30?**
See `inconsistencies.md` B4. The text gives 9/38, both tables give 30, retention gives 27.
The comparator arm is denominated on 36 throughout. *Field affected:* `n_outcome_observed`
on `bell2018_cg_t12m_paidcomp`, currently blank, with the result blocked by
`conflict_status = unresolved`. *Candidate resolution, recorded as a reconstruction and not
as an authority (prompt rule 14, D12.3d):* the observed denominator is 30, 27 is the
12-month interview completion count, and 38 is the randomised n used for this arm alone in
error. An author reply, or an authorship-group ruling, is what would move the status to
`resolved`.

**U5. How many participants were in any paid work, including Incentive Work Therapy and
Compensated Work Therapy, at 12 months?**
Both of those placements are paid ("pays half minimum wage"; "paid work placements through
contracts"), so `paid_any` exceeds the competitive count, but Table 2 reports only means of
hours and earnings. *Field affected:* no `paid_any` row could be created for this cohort at
all. The cohort is employment-selected and so cannot enter the primary pool regardless, but
the count would be usable in the selected-population analysis.

**U6. Was employment status at baseline 0 or 32?**
See `inconsistencies.md` B5: "All participants were unemployed" against an exhaustive
baseline partition placing 32 of 77 in paid placements or casual work. *Fields affected:*
`n_employed_baseline`, `perc_employed_baseline`, left blank on all four bell2018 rows.

---

## bhullar2018

**U7. How is "Employed" in Table 2 defined, and over what reference period?**
The paid_any result for this cohort (35/65) comes from a two-level sociodemographic row with
no instrument, no definition and no reference period, in a paper that defines its other
vocational measure carefully. The only definitional evidence is that student, homemaker and
retired were separate and unused categories. *Field affected:* `outcome_construct` on
`bhullar2018_cohort_t120m_paidany`, coded `paid_any`, and JBI item 7, judged `unclear` for
that result. *If the answer is that the category was derived from the same Life Chart
Schedule item as occupational activity,* the construct becomes `paid_or_education` and the
cohort loses its only primary-pool-eligible result.

**U8. How many participants engaged in any occupational activity, rather than 52 weeks of
it?**
The dichotomy is at 52 of 52 weeks, so the residual "<52 weeks" band pools people with no
activity at all with people active for 1 to 51 weeks; any-activity prevalence is bounded
32 ≤ x ≤ 65 and is not identified (D12.3). The authors hold the underlying weeks variable.
*Field affected:* no unthresholded numerator exists for
`bhullar2018_cohort_t120m_paidoredu`.

**U9. What is the actual distribution of elapsed follow-up, and what were the PEPP
programme's own admission criteria?**
Eligibility required "at least 10 years"; the mean and maximum are not reported, though the
floor is enough to fix the horizon. Separately, the programme's inclusion criteria are cited
to refs 57 and 58 and not reproduced, so the `employment_selection_status = none`
classification rests on the four criteria as printed. *Fields affected:* `followup_months`
precision; `employment_selection_status`. **The same limitation applies to baltazar2022,
which also refers fuller criteria to earlier reports, and to blackman2025, whose parent CTNB
protocols are not described.** All three were coded `none` on the criteria as printed, and a
Stage G checker should verify against Malla 2003 (PEPP) and Nicole 1992 (IUSMM) before the
primary pool is built. Coding them `unclear` instead would move bhullar2018's 35/65 out of
the primary pool, which is the only F06 result currently eligible for it.

---

## blackman2025

**U10. How many people were approached, and how many of those with baseline data could not
be traced?**
"Because not all participants with baseline data were able to be contacted for follow-up ...
our data may be susceptible to sampling bias", but the source sample size is never given.
*Fields affected:* `n_entered` and `n_alive_eligible`, both blank; JBI items 1, 5 and 9. No
response rate can be computed for this cohort at all.

**U11. Does the exclusion of the four retired participants fall under D9?**
Recruitment carries no employment criterion, but the analysed denominator does: "Those who
reported they were 'retired' (n = 4) or for whom employment status was not able to be
determined (n = 1) at follow-up were not included in the cohort." Retirees are by definition
not employed, so removing them raises the reported proportion. Coded as
`analysis_selection_status = selected` with reason `analytic_restriction` at arm level,
following the convention set for mihaljevicpeles2016, with the cohort left at `none` so the
recruitment is not misstated. **This is a judgement the authorship group may wish to review:
if retirement is treated as a life-stage rather than an employment status, the arm becomes
`none` and 56/124 enters the primary pool at no horizon anyway, since
`followup_basis = calendar_end_common` already bars it.** The practical stake is therefore
low here but high as a precedent for other cohorts that exclude pensioners.

**U12. Were all 124 recontacted within one campaign, and what were the actual recontact
dates?**
The interval is 8.6 ± 4.0 years, range 2-19, measured from each participant's own initial
visit. `calendar_end_common` was assigned on the reading that a single recontact campaign
produced the spread; the report does not print the campaign dates. *Field affected:*
`followup_basis`. `since_baseline` is wrong under any reading, because a mean of 8.6 years
over a 2-19 year range spans three landmark bands.

---

## bonnesen2026

**U13. Why do Table 2's civil-status counts sum to 502 against a printed total of 505?**
See `inconsistencies.md` B11. The likeliest explanation is missing civil-status data on
about 17 people, 3 of them attached to employment or education, but the report does not say
so and does not report missing covariate data anywhere. *Field affected:*
`conflict_status` on `bonnesen2026_cohort_t36m_paidoredu`, currently `none`.
**An authorship-group ruling on whether D12.3d applies here would settle it; the extractor's
reading is that nine agreeing partitions plus the text outweigh one short partition, but
that reading is a reconstruction and is offered as such.**

**U14. How many were in paid employment alone, without the education component?**
DREAM distinguishes labour-market contribution and flexible-job benefits from state
educational grants, so the components are separable in the data but are not reported
separately: "Employment and education were combined into a single outcome category." The
same applies at baseline. *Field affected:* no `paid_any` row exists for this cohort at
either timepoint, and no baseline paid-employment moderator either. This is a large,
well-ascertained register cohort whose loss to the primary pool is entirely a reporting
choice, so it belongs in the missing-evidence assessment (SAP section 12).

**U15. What was the mean age of the cohort?**
Only bands are printed (18-21, 22-25, 26-35). *Field affected:* `mean_age`, blank on both
rows, so this cohort cannot contribute to the age moderator.

---

## conus2017

**U16. At what elapsed time was each patient's endpoint vocational status rated, and how
many were rated at or near 18 months?**
The endpoint is discharge or last file entry; time in service ran from under 1 week to
208 weeks with a mean of 63.3 weeks. A distribution, or a restriction to patients rated
between 9 and 30 months, would let this cohort contribute to a landmark horizon. *Field
affected:* `followup_basis`, coded `unclear`, which bars every horizon. This is the single
largest loss in the batch: 661 patients from a mandated-catchment epidemiological cohort.

**U17. Over what window was the endpoint MVSI rated?**
The 4-week qualifier is stated only for the entry rating. *Field affected:*
`ascertainment_window_months`, blank; `ascertainment`, coded `point_prevalence` on the basis
that the rating is taken at the discharge point.

**U18. How many were in *paid* employment at endpoint?**
The MVSI composite counts unpaid employment, students, homemakers and volunteers together
with paid work, and the authors defend the breadth explicitly. *Field affected:* no
`paid_any` row exists for this cohort.

---

## Schema questions for the authorship group

**U19. `followup_basis` has no value for an endpoint that varies by participant without a
shared calendar end date.** conus2017 is the case: every participant is followed from
service entry to their *own* discharge or last file entry, so elapsed follow-up runs from
under 1 week to 208 weeks and the printed "18 months" is a maximum treatment duration.
- `since_baseline` is wrong: it would assign the cohort to the 24-month band under D11.1 on
  the strength of a label.
- `calendar_end_common` (D12.8) is factually wrong: there is no shared end date, and the
  spread comes from differential disengagement rather than from staggered entry.
- `unclear` blocks the horizon correctly but carries the misdescription D12.8 was written to
  avoid: the report is entirely clear about what it measured, and `unclear` is read as poor
  reporting in the risk-of-bias and missing-evidence assessments.

`unclear` was used, as the least wrong of three imperfect options, with the reasoning written
into the row's `notes` and into `inconsistencies.md` B15. **A fourth value, for example
`variable_endpoint_individual` ("measured from cohort entry to each participant's own
discharge, disengagement or last record, so elapsed follow-up varies and the figure recorded
is a nominal maximum or a cohort mean"), would describe it correctly and bar it from every
horizon exactly as D12.8 does.** Differential disengagement is common in service-based
cohorts, so this will recur; D12.8 itself was added for the same reason after
`andersen2026`. Recommended as a candidate D12.9, applied in the same non-retroactive way:
it changes no result's eligibility, only whether a clearly reported study is described as
unclear.

**U20. Is a derived count permitted when no independent checker exists at Stage F?**
The codebook requires `checked_by` on every derived count, but Stage F is run by a single
automated extractor and Stage G's checker "is a human's". `baltazar2022_cohort_t348m_paidany`
therefore carries `checked_by = unchecked_pending_stage_g`, which will fail any validator
rule that requires a name. **Either the validator should accept an explicit
not-yet-checked sentinel, so that the gap is visible in the data rather than papered over
with a plausible-looking value, or derived counts should be deferred to Stage G entirely.**
Recording a false check to satisfy a required field is the one option that must not be
taken.
