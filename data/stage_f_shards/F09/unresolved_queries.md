# Batch F09, unresolved queries

What an author, or in two cases the authorship group, would have to answer. Grouped by report, then
a section for queries that belong to the review rather than to any one paper. Each query says what
is currently recorded, so a blank is never mistaken for an oversight.

---

## khare2021

**Q1. Does "working" require personal remuneration, and how were family-business workers treated?**
The construct is coded `paid_any` on the strength of two things: the analysis deliberately excluded
the one participant "working as a volunteer" and the two full-time students, and monthly earnings
were obtained for every worker. But Methods 2.3.2 (p. 473-474) says "To calculate monthly income of
participants working in family-run businesses who were not paid separate wages, total family income
was divided by the number of family members working, adjusting for the amount of time the
participant worked", and Table 1 (p. 475) shows 97 of the 257 employed at both assessments worked
for family, rising to 83 of 132 rural participants. So a substantial minority of the numerator did
not receive wages in their own right. A reviewer applying `paid_any` strictly as wages or salary
received personally would recode this `unclear`, which would remove the only result this batch
contributes to the primary pool. **Currently recorded:** `paid_any`, with the caveat in the result
notes and in the JBI item 6 rationale. **Needed:** the authors' own statement of whether unpaid
family labour was counted as working, and if so how many of the 287.

**Q2. Recruitment response rate.** Were the site agreement rates of 99.2 per cent (Ahmednagar) and
81.4 per cent (Pune) computed on patients *informed* about the study or on patients *referred to the
interviewers*? The methods say the number informed "was not tracked", which makes the first reading
impossible. See `inconsistencies.md` item 1. **Currently recorded:** JBI item 9 `unclear`.

**Q3. Recruitment dates.** Neither the recruitment window nor the calendar dates of the baseline and
follow-up assessments are printed; the reader is referred to Khare et al. 2020. **Currently
recorded:** `recruitment_start` and `recruitment_end` blank. Obtaining Khare et al. 2020 would
close this and would also supply the baseline sample's characteristics on the 550 rather than the
459.

**Q4. Diagnostic subgroup counts.** Supplementary Table 3 "provides a similar comparison of
participants in the three diagnostic groups", which probably contains work status by diagnosis and
would allow a schizophrenia-spectrum-only proportion to be extracted. The supplement is not held.
**Currently recorded:** `subgroup_extractable = unclear`. Under D13 this does not gate anything,
since 59.3 per cent carry a qualifying diagnosis, but a diagnosis-restricted figure would be a
valuable sensitivity input.

---

## leighton2019

**Q5. The full EDEN inclusion and exclusion criteria (blocking a `none` selection code).** The
article states only that "participants were aged 14-35 years with a first presentation of psychotic
symptoms in EDEN" and adds "The inclusion and exclusion criteria for all three studies have been
provided in the appendix (p 1)". The online appendix is not part of the PDF held. Under D9, silence
in an incompletely reported methods section is `unclear`, not `none`. **Currently recorded:**
`employment_selection_status = unclear`, reason `incomplete_reporting`. **Needed:** appendix p 1, or
Birchwood et al. 2014 (Early Interv Psychiatry 8:59-67), the National EDEN cohort profile. This is
the single cheapest fix in the batch: if the criteria contain no employment restriction, national_eden
becomes `none`. It would still not enter the primary pool, because the construct is an EET composite,
but it would move the cohort out of the sensitivity-only category for every EET synthesis.

**Q6. Is a paid-employment-only count recoverable for EDEN?** The report gives only the EET
composite. EDEN recorded "In paid employment at baseline" and "Main income source is salary or wage"
as candidate predictors (Figure 1, pp. e263-e264), so the underlying data distinguish paid work from
education and training. **Currently recorded:** no `paid_any` row for national_eden. **Needed:** a
data request to the EDEN custodian (Birchwood, University of Warwick, named in the Data sharing
statement) for the 12-month paid-employment count and denominator.

**Q7. Baseline characteristics.** The EDEN, Scottish and OPUS sample comparison is in appendix p 2.
**Currently recorded:** every moderator blank for national_eden.

---

## leighton2019b

**Q8. What does EET mean operationally?** Neither this report nor leighton2019 defines it. Nothing
states whether employment must be paid, what hours qualify, whether voluntary work counts, or from
what source the status was taken. This affects three cohorts across two reports (national_eden,
crisp_glasgow, glasgow_edinburgh_2006) and 495 of the 807 + 75 + 67 people involved. **Currently
recorded:** JBI item 6 `unclear` for all three; construct `paid_or_education_or_training` on the
strength of the label alone. **Needed:** the operational definition, and ideally the paid-work-only
split, from Gumley (University of Glasgow), named as custodian of the Scottish datasets.

**Q9. Eligibility criteria for the 79-patient 2006-2009 cohort (blocking a `none` selection code).**
The article prints no inclusion or exclusion criteria for this cohort at all, deferring to S1 File
and to reference 28 (Gumley et al. 2014, Br J Psychiatry 205:60-67). Neither is held. **Currently
recorded:** `employment_selection_status = unclear`, reason `incomplete_reporting`. S1 File is
supplementary material to a PLOS ONE article and is freely available; retrieving it would close this.

**Q10. The 8 and 12 participants without a 12-month EET outcome.** 75 of 83 and 67 of 79 have the
outcome; the report does not say why the others do not, or how they differed. **Currently
recorded:** JBI item 5 `yes` for CR:ISP (90 per cent coverage) and `unclear` for the 2006-09 cohort
(85 per cent, uncharacterised).

---

## liangrong2021

**Q11. What ends an individual patient's follow-up?** This is the query that matters. Length of
follow-up runs from 0.2 to 16.8 years with a median of 5.6, and the report never states the rule.
Patients were "followed up at least once every 2-3 months after first discharge", the study was
carried out January 2018 to March 2019, and admissions ran January 2000 to December 2013, which
rules out a common calendar end date (that would give a minimum of about 4 years, not 0.2). Without
the rule, the 170 employment statuses are measured at unknown and wildly different elapsed times.
**Currently recorded:** `followup_basis` set to a value barred from every horizon, JBI item 7 `no`,
and the full reasoning in the result notes. **Needed:** the definition of the endpoint, and ideally
the employment status at a fixed elapsed time.

**Q12. Were patients who were both at school and in paid work counted as employed?** The three
categories are mutually exclusive, so anyone in both is counted once. With a median age of 18 at the
end of follow-up and 52.3 per cent at school, part-time student employment could be material and
would be invisible in the 70. **Currently recorded:** `paid_any` = 70/170, with the caveat in the
result notes and in JBI item 6. If students in paid work were classified as "At school", 70
understates any paid work and the true `paid_any` is bounded by 70 and 159.

**Q13. What does "employed" mean here?** Remuneration is never mentioned. **Currently recorded:**
`paid_any` on the strength of the word "employed" and the explicitly contrasting category "dropped
out of school or unemployed".

---

## lindgren2020

**Q14. How many were recruited to the Helsinki Early Psychosis Study?** 67 had baseline cognitive
data and 54 had both baseline cognitive and 1-year clinical data, but the recruited cohort size is
never printed. **Currently recorded:** `n_entered` blank, JBI item 5 `no`. Without it the SAP
section 6 complete-cohort bounding analyses cannot be run for this cohort at all.

**Q15. Is the working-only count recoverable?** The outcome is "working (full-time or part-time
work) or studying and not being on sick leave", a composite that also excludes people who hold a job
but are signed off. The underlying data must separate the components, since the definition names
them separately. **Currently recorded:** `paid_or_education` = 26/53, no `paid_any` row. **Needed:**
the count working, the count studying, and the count on sick leave from a job, at the 1-year
interview.

**Q16. The Table 1 remission row.** 28/53 is printed as 51.9 per cent, which is 28/54. Which is
right? See `inconsistencies.md` item 13. This does not touch the employment row, but it bears on how
much confidence the table carries.

---

## luo2019

**Q17. Were all participants unemployed at baseline (blocking a `selected` or `none` decision)?**
The outcome is framed throughout as *re*-employment, and the Kaplan-Meier analysis treats every
participant as at risk from day 0, "censored at 365 days if the event did not occur during the full
12 months of follow-up", which implies none was in paid work at entry. The paper never says so.
Table 1 reports only lifetime "Previous work experience" (Never 14, Ever 16 in each arm), which is
not baseline employment status. **Currently recorded:**
`employment_selection_status = unclear`, reason `incomplete_reporting`, and
`baseline_unemployed_required = unclear` on both arms. If the authors confirm that baseline
unemployment was required or that the analysed sample was wholly unemployed, this becomes `selected`
with reason `baseline_employment_status`. Either way the arms stay out of the primary pool.

**Q18. The operational content of inclusion criteria (4) and (5).** "significant functional
impairment" and "one or more indicators of a need for continuous high level of services" are
defined only by reference to the ACT Manual (Allness and Knoedler, 2003) "see details in the online
Supplementary materials", which are not in the PDF held. ACT admission criteria customarily include
inability to obtain or maintain employment, which if present here would make this squarely
employment-related selection. **Currently recorded:** as for Q17. Retrieving the Supplementary
materials would close both.

**Q19. Employment status *at* 12 months, for either arm.** The report gives only cumulative
attainment over the window and mean days worked. **Currently recorded:** `ascertainment =
any_time_during_followup`, so the result is excluded from both the point-prevalence and the
period-prevalence syntheses. A 12-month point prevalence would be usable in the intervention
synthesis at matched follow-up.

**Q20. What is "transitional employment"?** Six of the ten ACT re-employments were "in transitional
employment", which is never defined. It is paid, since all ten "returned to wage-earning
employment", but the labour-market setting is not established, so it cannot be classified as
competitive or as sheltered. **Currently recorded:** `outcome_construct = unclear` for that row,
with the wording preserved.

**Q21. Was the control arm's single re-employed patient competitive or transitional?** The
sub-classification is printed for the ACT arm only. **Currently recorded:** RoB 2 selective
reporting `high` for the two sub-count rows, which are marked descriptive-only.

**Q22. How was employment verified?** The report states that relapse days were "recorded based on
reports of the patient and his/her family members at the time of assessment" but says nothing
equivalent for re-employment days. **Currently recorded:** RoB 2 outcome measurement
`some_concerns`.

---

## For the authorship group, not for an author

**Q23. `followup_basis` has no value for a median elapsed follow-up that varies across the cohort.**
liangrong2021 is a fourth form of the failure D12.3b names, and it is not any of the three the
vocabulary covers. Its anchor *is* cohort entry, so `since_baseline` is literally true and would let
a 67-month median into the 5-year horizon, which is exactly what the rule exists to prevent.
`calendar_end_common` is refuted by the data (admissions spanning 2000 to 2013 with a 0.2-year
minimum follow-up cannot share an end date). `unclear` would misreport a study that prints its
range, median and interquartile range as poor reporting, which is the error D12.8 was written to
correct. `since_onset_mean` is the only value whose definition covers "a mean or **median** time ...
across a cohort whose individual follow-ups differ", and that is precisely the mechanism here, but
its anchor is illness onset rather than cohort entry.

**Recorded as `since_onset_mean`**, with `mean_years_since_onset` left blank rather than filled with
a figure the paper does not give, and with the full reasoning in the result notes. Both candidate
values bar the horizon identically, so no result's eligibility turns on the choice; what turns on it
is whether the review describes this study accurately. **Proposal:** add
`since_baseline_median_varying` (or similar) to `followup_basis`, defined as measured from cohort
entry but summarised as a mean or median over individual follow-ups that differ materially, and
barred from every horizon exactly as `calendar_end_common` is. This will recur: naturalistic
retrospective cohorts routinely report a median follow-up rather than a landmark.

**Q24. `checked_by` is blank on the one derived count in this shard.** The codebook makes
`checked_by` required for a derived count ("Who independently checked the arithmetic against the
source"). No independent human has checked `khare2021_cohort_t12m_paidany` = 257 + 30 = 287, because
that is Stage G's job and Stage G has not run. The existing `rautio2016` derived row in
`data/extraction_outcomes.csv` also carries a blank `checked_by`, and the validator does not enforce
the field, so the shard passes. Recorded here rather than filled with a placeholder that would read
as a completed check. **Needed:** a human to verify the four cells against Results 3.1 (p. 474) and
Table 1 (p. 475) before this row enters the primary estimate. It is currently the *only* result in
this batch that reaches the primary pool.

**Q25. `glasgow_edinburgh_2006` is a new cohort_id and is not in the manifest.** It does not appear
in `data/inclusion_manifest.csv`, `data/extraction_cohorts.csv`, or the `cohort_ids` field of the F09
row in `data/batch_ledger.csv` (which lists seven cohorts, not eight). It must be added to all three
on merge. See `manifest_changes.csv`.

**Q26. This shard's `report_cohort_map.csv` contains one deliberate cross-shard reference.** The row
`leighton2019, opus_1998, validation_sample, no` names a cohort that lives in `data/`, not in this
shard, so the map alone does not resolve standalone. The other five tables validate standalone; the
map resolves on merge. Removing the row to make the shard self-contained would delete precisely the
record the batch brief asked for, so it stays.

**Q27. Per-task token budget (CLAUDE.md rule 6) was exceeded.** The 10,000-token per-task budget is
not attainable for a six-report extraction that requires reading four governing documents plus six
full papers. Surfaced rather than passed over in silence, per rule 12.
