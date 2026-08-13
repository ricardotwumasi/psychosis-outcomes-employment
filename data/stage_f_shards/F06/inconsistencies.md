# Batch F06 internal inconsistencies

Every internal contradiction found while extracting the six F06 reports, with what the
paper prints, what the arithmetic gives, and where. Contradictions that bear on an
extracted result carry a decision on `conflict_status`; those that do not are recorded
anyway, because a checker needs to know they were seen and judged rather than missed.

Batch: F06. Extractor: claude-opus-5. Date: 12 August 2026.

---

## baltazar2022

### B1. The employment figure exists in four mutually inconsistent forms. Does not block: only one of them is an observation

| Where | Figure |
|---|---|
| Abstract, p. 1319 | "From 15 to 25% might have been employed (supported or competitive employment)" |
| Results, Social outcomes, p. 1321 | "six held jobs on the regular market" of 43 with observed occupational status (14.0%) |
| Results, Social outcomes, p. 1321 | "Based on this source of information, a maximum of 28 patients (26%) were potentially employed" |
| Discussion, p. 1324 | "a maximum estimated of 25% potentially holding supported or regular jobs" |
| Discussion, p. 1324 | "14.8% to 25.9% of the living cohort might have been employed" |

The three percentage-based figures are extrapolations from who was and was not covered by
the public medication-insurance plan, on a base of the 108 alive; the count of six is the
only observed employment measure, on the 43 whose occupational status was recorded. They
are not estimates of the same quantity, so this is not strictly a contradiction about one
result, but the four figures disagree among themselves as well (15-25% against 26% against
25% against 14.8-25.9%), and the abstract's range is not reproduced anywhere in the body.

**Decision:** extract only the observed 6/43; `conflict_status = none`. The manifest note
already directs that the abstract's range not be used, and this confirms it. Recorded here
so that a reader who sees "15 to 25%" in the abstract and 14.0% in the extraction knows the
difference was noticed.

### B2. Table 1's suicide count is typed as a decimal and sits on a different base from the text

Table 1, p. 1322 prints "Total deaths by suicide n (%) 14.0 (10.1)" under a "Deaths
(n = 138)" heading, while the text (p. 1323) says "at least 9.9% of the cohort died by
suicide" and the abstract says "Fourteen (9.9%) died by suicide". 14/142 = 9.86%, 14/138 =
10.14%. The whole cohort is 142, and 138 appears only in Table 1's death block. Similarly,
"Total deaths by medical illness n (%) 17.0 (12.0)" is 17/142 = 11.97%.

**Decision:** does not touch the employment result. No effect on extraction.

### B3. Marital status: 91% in the text against 78.9% in the table

Text, p. 1321: "The majority of patients were male (71%) and single (91%) at first
admission (T1)". Table 1, p. 1322: "Single at first admission (109/138) % 78.9". 109/138 =
79.0%. The 91% is not reproducible from any denominator in the paper; 109/120 would give
90.8%, but no such base appears.

**Decision:** moderator not extracted (marital status is not a review moderator). No effect.

---

## bell2018

### B4. The 12-month competitive employment denominator. BLOCKS the VR+CG result

| Where | VR+CG | VR+CR |
|---|---|---|
| Results, Employment Outcome, p. 4 | 9 / **38** | 9 / **36** |
| Table 2, "Competitive Hours 12", p. 3 | N = **30** | N = **36** |
| Table 3, "Ever Employed", p. 4 | 10 of **30** | 11 of **36** |
| Table 3, 12-month QLS column, p. 4 | N = **27** | N = **29** |
| Results, Retention, p. 2, 12-month retention | **71%** of 38 = 27.0 | **74%** of 39 = 28.9 |
| Table 1, randomised, p. 3 | **38** | **39** |

The VR+CR arm is denominated on 36 consistently in the text and both tables. The VR+CG arm
is denominated on 38 in the text and on 30 in both tables, so the two arms of one printed
chi-square test sit on different kinds of denominator: 38 is the number randomised to VR+CG,
36 is not the number randomised to VR+CR (which is 39). Either the text's 9/38 or the
tables' 30 is wrong for this arm.

**Candidate resolution, which is the extractor's reconstruction and NOT an authority under
prompt rule 14:** vocational data came from programme records (available for 30 in VR+CG and
36 in VR+CR), interviews were completed by 27 and 29 respectively, and the text
inadvertently used the randomised n for VR+CG alone.

**Decision:** `bell2018_cg_t12m_paidcomp` takes `conflict_status = unresolved` with
`n_outcome_observed` blank and `n_assessed = 30`. `bell2018_cr_t12m_paidcomp` takes
`conflict_status = none`, because that arm's own numbers are consistent across three
locations, with the mismatch recorded in its notes. Raised for the authors in
`unresolved_queries.md`.

### B5. "All participants were unemployed" against 32 participants described as working at baseline

Methods, Participants, p. 6: "All participants were unemployed, though a few were earning
money through informal work."

Results, Sample Characteristics, p. 2: "At baseline 30 (39%) had not begun their vocational
rehabilitation service at intake but were in process; 24 (31%) had just begun working in
Incentive Therapy; 15 (19.5%) were in SE though none were currently working; 6 (8%) had
begun working in Compensated Work Therapy at the VA, and 2 (2.6%) were working casual jobs a
few hours a week."

30 + 24 + 15 + 6 + 2 = 77, so the second passage is an exhaustive partition of the sample,
and 32 of the 77 (24 + 6 + 2) are described as working at baseline in paid placements or
casual jobs. Incentive Therapy is described elsewhere in the same paper as "an in-house work
placement that pays half minimum wage" and Compensated Work Therapy as "paid work placements
through contracts", so those are paid. "All participants were unemployed" is true only under
a competitive-employment reading of "unemployed".

**Decision:** `n_employed_baseline` and `perc_employed_baseline` are left BLANK for all four
bell2018 rows, with the contradiction quoted in the notes. Recording either 0 or 32 would
assert one side of a contradiction. This does not block the outcome rows, which concern
12-month status, so `conflict_status` is unaffected.

### B6. Supported employment versus transitional work at 12 months: percentages with no counts

Results, p. 5: "41.2% of participants receiving Supported Employment (SE) attained
employment over 12 months compared with 16.7% of those in transitional employment a
significant difference." Table 1 gives SE n = 42 and Transitional Work n = 35 at baseline.
41.2% of 42 = 17.3 and 16.7% of 35 = 5.8, neither of which is an integer, so the
percentages are computed on some other base, probably the 66 with 12-month vocational data.

**Decision:** not extracted. Back-calculating a count from a percentage is forbidden, and
this is additionally a post-randomisation subgroup split.

---

## bhullar2018

### B7. The 132 partition two different ways

Fig. 1, p. 174: 132 at baseline, of whom 68 participated at 10 years, with "Died (n = 1)"
and "Refused to Participate or Unable to be Contacted (n = 67)"; of the 68, "Missing Outcome
(n = 3)" leaves 65 analysed. So 1 + 67 + 68 = 136, which is wrong; read as intended,
68 participated and 64 did not (1 died, 63 refused or were uncontactable), giving
68 + 64 = 132. The text supports the second reading: "Follow-up data were not available for
48% (64/132) of participants" (Limitations, p. 179).

But the Results (p. 173) then say "We did not find evidence of significant differences in
baseline sociodemographic or clinical characteristics when we compared participants (n = 65)
and non-participants (n = 67)", where 65 + 67 = 132 and "non-participants" silently absorbs
the 3 who participated but were excluded for a missing outcome. The same label therefore
denotes 64 people in one place and 67 in another.

**Decision:** does not affect the numerator or the denominator of either extracted result
(65 is used consistently for both). `conflict_status = none`. `n_assessed = 68` and
`n_alive_eligible = 131` are recorded from Fig. 1 on the reading the text confirms.

### B8. The same paper measures vocational status twice, on two different constructs, without reconciling them

Table 2, p. 175: "Employment status | Employed 35 (53.8) | Unemployed 30 (46.2)" at 10-year
follow-up. Results, pp. 175-176: "32 had been in part/full-time employment throughout the
year", where "occupational activity" is defined as "engagement in work and/or school".

35 and 32 are not inconsistent (35 employed at the follow-up point, 32 in work or school for
all 52 weeks of the preceding year), but the paper never states the relationship between its
two vocational measures, and the second is described in the Results in employment language
("had been in part/full-time employment throughout the year") while its definition in the
Methods explicitly includes school.

**Decision:** extracted as two separate results with different constructs and different
ascertainment, which is what the schema is for. `conflict_status = none` on both. Flagged
because an extractor reading only the Results would take 32/65 to be an employment figure.

---

## blackman2025

### B9. The ascertainment window appears only in the Discussion

Methods 2.1, p. 2: "Participants later self-reported their employment status by phone
interview. Paid work of any kind and amount was considered as being employed."
Discussion, p. 5: "The binary employment outcome variable (any or no work within the last
year) was designed to be robust to the limitations of retrospective self-report."

Read on the Methods alone the outcome is point prevalence; read with the Discussion it is
period prevalence over a year. The statements are not numerically contradictory, and the
Discussion is the more specific, so it governs.

**Decision:** `ascertainment = period_prevalence`, `ascertainment_window_months = 12`,
`conflict_status = none`. Recorded here because a checker working from the Methods alone
would code point prevalence, which would wrongly admit the result to the point-prevalence
estimand.

**No arithmetic inconsistency was found in this report.** Table 1's counts reconcile
exactly: 29 + 27 = 56 employed at follow-up, 9 + 27 = 36 employed at the initial visit, and
59 + 29 + 9 + 27 = 124.

---

## bonnesen2026

### B10. Table 1's sex counts sum to 2,597 against a stated total of 2,598. Does not block

Table 1, "Total N = 2,598": Female 1,049 (40.4), Male 1,548 (59.6). 1,049 + 1,548 = **2,597**.
The printed percentages are computed on 2,598 (1,049/2,598 = 40.38%, 1,548/2,598 = 59.58%),
so one person is missing from the counts, not from the base. Every other partition in Table 1
sums to exactly 2,598: age 1,001 + 748 + 849; civil status 2,174 + 278 + 146; baseline
employment 564 + 2,034; diagnosis 1,046 + 1,552; primary healthcare 1,463 + 848 + 287;
somatic hospitalisation 1,940 + 658; psychiatric hospitalisation 1,101 + 675 + 822; somatic
outpatient 996 + 1,069 + 533; psychiatric outpatient 807 + 789 + 461 + 541.

**Decision:** affects the sex moderator only. `n_female = 1,049` with
`n_female_denominator = 2,598` is recorded, because 2,598 is demonstrably the base the
authors divided by, with this discrepancy noted on both outcome rows.

### B11. Table 2's civil-status subgroups sum to 502 against a printed total of 505. Judged NOT to block

Table 2 (3-year follow-up), p. 6, prints "Total 505 (19.6)" and then, by civil status:
Unmarried 393 (18.4), Married/registered partnership 81 (29.1), Divorced/widowed 28 (19.2).
393 + 81 + 28 = **502**. The implied denominators are also short: 393/0.184 = 2,136,
81/0.291 = 278, 28/0.192 = 146, summing to about 2,560 against the table's stated n = 2,577.

Every other partition in Table 2 sums to exactly 505: sex 299 + 206; age 222 + 132 + 151;
baseline employment 221 + 284; diagnosis 308 + 197; primary healthcare 263 + 189 + 53;
somatic hospitalisation 409 + 96; psychiatric hospitalisation 260 + 126 + 119; somatic
outpatient 204 + 202 + 99; psychiatric outpatient 83 + 176 + 124 + 122. The text prints 505
independently. Table 3 (5-year) is fully consistent: all ten partitions sum to exactly 539.

**This is the hansen2024 pattern (D12.3d), and the decision not to apply it needs stating.**
In hansen2024 the subgroup shortfall attaches to the partition that constitutes the total. Here
nine partitions of the same total agree exactly and one is 3 short, with its denominators
17 short in the same direction, which is what missing civil-status data on about 17 people,
3 of them attached, would look like. That reconstruction is the extractor's and is not an
authority, so it is not recorded as `resolved` either.

**Decision:** `conflict_status = none` on `bonnesen2026_cohort_t36m_paidoredu`, with the
discrepancy quoted in the row's own `notes` so it cannot travel silently, and JBI item 8
downgraded to `unclear` for that result and left at `yes` for the 5-year result. **A checker
who judges that D12.3d applies should set `conflict_status = unresolved` on the 3-year row;
the practical consequence is limited, because the construct is `paid_or_education` and the
result cannot enter the primary pool in any case.** Raised in `unresolved_queries.md`.

### B12. Fig. 1's final box is labelled "Alive at 5-year follow-up, n = 2,493"

The 84 removed at that step comprise 16 who "died between 3 and 5 years" and 68 with "no
5 year-follow-up data", so 2,493 is the number alive *and observed*; the number alive at
5 years is 2,577 − 16 = 2,561. The label conflates survival with observation.

**Decision:** `n_alive_eligible = 2,561` on the 5-year row, derived by subtracting two
printed integers, with the derivation and the mislabelling recorded in the row's notes. This
matters for the SAP section 6 bounding analyses, which divide by `n_alive_eligible`.

### B13. Title against Methods on the geographical scope

The title calls the study "a population-based **national** registry study"; the Methods
identify the population as "all individuals aged 18 to 35 years residing in the **Central
Region of Denmark**". The data sources are national registers, but the cohort is regional.

**Decision:** `region` and `setting` recorded from the Methods; noted in the cohort's
`overlap_notes`, because a reader assessing overlap with whole-country Danish register
cohorts needs to know which is true.

---

## conus2017

### B14. The MVSI is given two different definitions in the same paper

Methods, Baseline and outcome characteristics, p. 1091, for the **entry** rating: patients
were rated as "working at entry" on the MVSI "if they fulfilled following criteria: having a
job (full-time or part-time) or being a student at school or university for at least the
previous 4 weeks."

Methods, Outcome definitions, p. 1091, for the **endpoint** rating: "occupational/vocational
status as measured by the MVSI [i.e., paid or unpaid full- or part-time employment, being an
active student in school or university, or head of household with employed partner
(homemaker), or full- or part-time volunteer]".

The endpoint definition admits unpaid employment, homemakers and volunteers; the entry
definition does not. The 4-week qualifier appears only on the entry definition. The same
instrument therefore counts different things at baseline (48.0%, n = 316) and at endpoint
(44.7%, 255/571), and the apparent fall in vocational engagement is measured on a widening
definition.

**Decision:** the endpoint result is extracted as `vocational_activity` on the endpoint
definition, quoted in full. `perc_employed_baseline` and `n_employed_baseline` are left
BLANK, both because the entry construct is a work-or-study composite rather than paid
employment and because its denominator is not printed. `conflict_status = none`: the two
definitions describe two different ratings rather than contradicting each other about one
result, but the comparison the paper draws between them is not sound.

### B15. The endpoint is not the timepoint in the title

Title and Abstract: "18-months remission"; "The files of 661 FEP patients treated for up to
18 months between 1998 and 2000 were assessed."
Methods, p. 1091: outcome was taken "at the time of discharge (either at the end of
18 months of treatment or on the basis of the last file-entry if patients moved out of
catchment area, disengaged or had died)".
Data analysis, p. 1091: "As length of time in service varied from less than 1 week to
208 weeks, time in service was entered into the first step of the model."
Table 1, p. 1093: "Length of time in service (in weeks) M (SD) 63.3 (34.2)", i.e. a mean of
14.6 months against a nominal 18.
Limitations, p. 1097: "outcome was based on file entries at 18 months or on the last file
entry in case of disengagement or movement outside the catchment area, which explains the
variability in treatment duration."

**Decision:** `followup_months = 18` with `followup_basis = unclear`, which bars the result
from every landmark horizon. Taken at face value, "18 months" would be assigned to the
24-month band under D11.1 on the strength of a label. `calendar_end_common` was not used
because there is no shared calendar end date; see `unresolved_queries.md`, item U7, which
proposes the missing vocabulary value.

### B16. Three functional measures, three denominators, one of which is never explained

Results, p. 1092: "Data found in the file on functional recovery were considered reliable in
only 556 patients. On the MVSI, 44.7% (n = 255, N = 571) were engaged in meaningful
employment. On the MLCI, 83.0% (n = 463, N = 558) were living independently ... 44.2%
(n = 246, N = 556) who had achieved functional recovery."

571 > 558 > 556 is coherent if the combined measure needs both components, but the sentence
introducing the paragraph states that functional-recovery data were reliable "in only 556
patients", which does not sit with a vocational rating on 571. Symptom remission uses a
fourth denominator, 655.

**Decision:** the MVSI result is extracted on its own N = 571 and no denominator is borrowed
across measures. `analysis_sample_id = mvsi_571` records which sample the row sits on.
`conflict_status = none`; the denominators are internally orderable and each is printed
beside its own measure.
