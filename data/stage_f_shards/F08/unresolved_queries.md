# Batch F08: unresolved queries

What an author, or the authorship group, would have to answer. Grouped by report, then two
schema questions and one process point that belong to the review rather than to any paper.

---

## greenwood2025 (EYE-2 trial)

**U1. To the authors: the observed employment counts, by arm, at 12 months.**
The trial reports employment only as an adjusted difference in mean days, estimated on
multiply-imputed data in the 232 of 1027 who consented to the societal interview. Ask for the
number of participants in any paid employment and the number whose employment status was
observed, by arm, at 12 months; and for paid employment separated from unpaid, since Table 2's
row is "Paid and unpaid employment" and the review's primary construct is paid work only. Note
that the trial is cluster randomised, so a cluster-adjusted estimate is needed for any pooled
comparison, not raw counts alone. This request is already listed in `docs/data_requests.md`
section C and this extraction adds nothing to it except the paid/unpaid distinction, which the
earlier note did not carry.

**U2. To the authors: what the "probability mean days higher" column reports.**
Table 2 pairs each adjusted difference with a probability. For the employment row that
probability is 77% while a normal approximation to the printed confidence interval gives about
63%, and for stable accommodation it is 98% against about 93%; the education row agrees. Ask
whether the intervals are percentile bootstrap intervals and the probabilities are the
proportion of bootstrap replicates above zero, which would explain the difference on a skewed
distribution, or whether one of the two is computed differently. See inconsistencies.md I2.

**U3. To the review: the ascertainment vocabulary has no value for a duration.**
"Days in employment over 12 months" is neither a point prevalence nor a period prevalence nor
ever-employed: it is a duration, and SAP 2.3 registers job tenure as a separate outcome with its
own designation. `period_prevalence` with a 12-month window was recorded as the least wrong
value, because the days were counted within a defined 12-month window, and the row carries no
count so it cannot enter any pool by accident. A `duration` value, or an explicit instruction to
use `period_prevalence` for duration measures, would stop the next extractor guessing
differently. This is the same class of gap as F06 raised for `followup_basis`.

---

## hakulinen2019 (Danish registers)

**U4. To the review, before any author request: the appendix is not in the evidence set.**
Every denominator in this report lives in Online Appendix Tables 1 to 3, which the article cites
and the held PDF does not contain, and no supplement for this report is in
`dissertation_shared_folder/supplements/`. The manifest note and `docs/data_requests.md` both
describe the appendix's contents in detail, so someone has read it, but nothing in the repository
records where that copy is. `data/supplement_provenance.csv` notes in passing that the Springer
ESM `127_2019_1756_MOESM1_ESM.docx` returns HTTP 200, so it is retrievable. It should be
retrieved and logged before the author request goes out, so that the request can name the exact
rows.

**U5. To the authors: exact employment counts by age, for the schizophrenia group.**
The existing request in `docs/data_requests.md` stands unchanged and its reasoning is confirmed:
back-calculating from a whole-number percentage on a denominator near 9,444 carries a rounding
uncertainty of roughly plus or minus 47 against a binomial standard error of about 33, so the
reconstruction error would exceed the sampling error it replaces. **Two things should be added to
the request, because both mean that exact counts alone will not make this report usable in the
primary pool.** First, the outcome is measured at fixed chronological ages, so it is not an
elapsed follow-up and cannot be assigned to a landmark horizon (D12.3b); ask whether time since
first diagnosis is available, which would make the data assignable. Second, the AKM measure is
the single most important employment status of the year judged on the main source of income, so
someone whose main income is a disability pension counts as outside the labour market even if
they did paid work; ask whether any paid employment during the year can be identified separately.

**U6. To the authors: which model produced the Abstract's age-30 odds ratios?**
None of the three matches Table 1's Age 30 Model 1 values, and no other model in the paper
reproduces them. See inconsistencies.md I3. This does not affect an extracted count, but it
should be resolved before any of this paper's estimates are quoted.

---

## hakulinen2020 (Finnish registers)

**U7. To the review: `calendar_end_common` does not quite describe this follow-up.**
The vocabulary defines `calendar_end_common` as measurement where "every participant is followed
to one shared calendar end date". Here the anchor is the end of **each participant's own
diagnosis year**, not one date shared by the cohort: someone first hospitalised in 1988 is
measured at the end of 1988 and someone in 2015 at the end of 2015. The failure mode is
identical, in that elapsed follow-up varies across the cohort (from under a week to nearly twelve
months) and the timepoint is not an elapsed time, and the value blocks every horizon correctly,
which is why it was used rather than `unclear`. But the definition as written is literally false
of this study. Suggest widening it to "a calendar anchor rather than a fixed elapsed time,
whether shared across the cohort or defined relative to each participant's entry year". Register
studies do this constantly, so it will recur, and `unclear` would misreport a perfectly clear
paper as poorly reported, which is exactly what D12.8 was written to prevent.

**U8. To the authors: the year-by-year employment counts behind Figure 1.**
Table 1 already prints the denominator for every year from -10 to +10 for each group. Only the
diagnosis year's proportions are printed as counts; every other year exists only as a line in
Figure 1. Since the denominators are already published, the numerators alone would give this
cohort usable results at 12, 24, 60 and 120 months, which would be among the largest contributions
to the review at every horizon. This is the highest-value author request in the batch and it is
not currently in `docs/data_requests.md`. Note that even year 1 would be an elapsed 12 to 24
months rather than exactly 12, for the reason in U7, so ask also whether employment can be given
at fixed elapsed intervals from the index hospitalisation.

---

## hui2026 (Hong Kong JCEP)

**U9. To the authors: the employed count and its denominator at four years.**
Table 3 prints only "Unemployed, n (%) 40 (65.6%) / 21 (34.4%)" with the percentages taken across
the two deprivation groups rather than within them, so no employed count and no denominator is
established. Ask for: the number employed and the number whose employment status was actually
observed at four years, for the deprived group, the non-deprived group and the two combined; and
what "employed" counted, since Methods says only "employment status (employed or not)" and it is
not stated whether part-time, sheltered or supported work, or student status, were included.
**Candidate values to put to them, which this extraction did not use:** if employment status was
observed for all 112 and all 107, the complement of the printed unemployed counts gives 72/112
and 86/107, totalling 158/219. Three things support that reading and one refutes it, all set out
in the result's notes; the refuting one is that this paper reports t(213), t(215) and t(206) to
t(208) against a stated n of 234 elsewhere, so its column headers are demonstrably not the
denominator of every variable, and it never prints a per-variable n. Ask them to confirm or
correct 72, 86 and the denominators.

**U10. To the authors: is a whole-cohort figure available?**
120 of the 360 randomised were excluded from this analysis for not receiving early intervention,
so nothing here is a whole recruited cohort and nothing can enter the prevalence intercept. The
parent trial report (Hui et al., Psychological Medicine 2023;53:2339-2351, this paper's reference
28) covers all 360 and may carry employment for the whole cohort. It is not in the frozen
screening set, so it cannot be added to the review, but it may answer the question and it should
be checked before the request is sent.

---

## jackel2025 (Vivantes Berlin IPS trial)

**U11. To the authors: one day or one week?** Table 2 labels a row "EET at least one day" and the
Abstract describes the same counts, 38/46 and 26/44, as EET "for at least 1 week in the
follow-up". Both results are blocked until this is answered. See inconsistencies.md I10. The
candidate resolution, that Table 2's label is right because competitive employment is
operationally defined as holding the job "for at least 1 day", is a reconstruction and cannot
settle it under prompt rule 14.

**U12. To the authors: how were the education/training subsamples defined, and what are the
denominators 14 and 18?** Section 3.4 says the subsamples exclude everyone who never received
education or training during follow-up, yet Table 3 reports only 17 of 25 and 11 of 29 in
education or training for at least one day; and the same paragraph reports 11/14 and 6/18 for a
further outcome using denominators that appear nowhere else. Both education rows are blocked
until this is answered. See inconsistencies.md I11.

**U13. To the authors: arm-level competitive-employment counts at 12 months.**
This is an IPS trial whose stated target is competitive employment, and it reports no
paid-employment-only count for either arm at any timepoint. The employment subgroup analysis is
given as chi-square 4.47, p = 0.03, OR 3.5, CI 1.07 to 11.4, with no numerators; the monthly EET
rates are a figure. Ask for the number in competitive employment, and the number in any paid
employment including sheltered or supported work, by arm, both at 12 months and at any time
during the follow-up, each with its denominator. Without them this trial can contribute only to
the EET family and never to the paid-employment family. This report is not currently in
`docs/data_requests.md` and should be added.

**U14. To the authors: the corrected F2x count in Table 1.** The total-sample cell prints 50
where its own arm counts give 28 + 32 = 60 and its own percentage of 63.8 gives 60. Confirm 60.
See inconsistencies.md I8.

---

## jirapramukpitak2022 (Bangkok community health worker cohort)

**U15. To the authorship group, a schema ruling: may a whole-cohort count be summed from an
exhaustive partition into subgroup arms?**
This is the one place in the batch where a usable result exists and was not recorded.
Table S3 gives early stage **146/372** and later stage **43/177**, both verified cell by cell.
The two strata are mutually exclusive by definition (one or fewer past relapses against more than
one), exhaustive of the analysed cohort (372 + 177 = 549, exactly the number analysed), and
measured on the same construct, ascertainment, window and timepoint. Their sum, **189/549**, is
the whole-cohort twelve-month period prevalence and would be the report's contribution to the
period-prevalence synthesis.
It is not recorded, because D12.2 requires the components of a derived count to share `arm_id`
and to sit on one common denominator, and the validator enforces both. Two subgroups that
partition a cohort necessarily share neither: they have different arm identities and denominators
of 372 and 177, and the derived row would sit on 549. Naming no components in order to slip past
the check would break the codebook while satisfying the validator, so it was not done.
The rule reads as though it was written for summing outcome **categories** within one arm, such
as full-time plus part-time, where a shared denominator is exactly the right requirement. A
partition into **subgroups** is a different operation with a different safety condition: that the
subgroups do not overlap and omit nobody, which SAP section 5 rule 3 already contemplates when it
speaks of "two subgroups whose combined count is not recoverable". Suggested ruling: allow a
derived whole-cohort row whose components partition the cohort, requiring that the component
denominators sum exactly to the derived denominator and that `derivation_mutually_exclusive` and
`derivation_exhaustive` are both asserted, and keeping the shared-denominator rule for
within-arm category sums. Until that is decided, this cohort contributes two nested subgroup
results rather than one whole-cohort result, which SAP section 5 rule 3 permits, so no evidence
is lost, only aggregated differently.

**U16. To the authors: how many of the community-identified participants had a psychotic
disorder?**
277 of the 551 recruited, about 50.5 per cent, came from medical records with a treated ICD-10
F20-F29 diagnosis. The other 274 were found by community key informants using a psychosis
screening questionnaire or from a survey report of lifetime psychotic symptoms, and the WMH-CIDI
was used to assess "history of psychotic symptoms and service utilization" rather than to make a
diagnosis. The SAP section 7 threshold is 50 per cent with a stated diagnostic criterion, so this
cohort sits within a percentage point of the gate and the answer decides its eligibility. Ask how
many of the community-identified participants met criteria for a psychotic disorder on the CIDI,
and whether any diagnostic confirmation was made. If the answer is most of them, the cohort is
comfortably eligible; if it is few, the whole-cohort figure fails the diagnosis gate and only a
diagnostic subgroup would remain.

**U17. To the authors: the 42 participants missing from one baseline row.**
Table 2's "Psychiatric hospitalization in the past year" row has a base of 507 rather than 549,
unannounced. Confirm which participants are missing and whether the same missingness affects any
other variable. It does **not** affect employment, since Table S3's cells sum to the full strata,
but it shows the tables carry unstated per-variable missingness and a checker should know.

**U18. To the review: log the supplement.**
`docs/data_requests.md` lists this report under "Resolved from supplements", but no supplement
file for it exists in `dissertation_shared_folder/supplements/` and no row exists in
`data/supplement_provenance.csv`. Additional file 1 was re-retrieved during this extraction from
`https://static-content.springer.com/esm/art%3A10.1186%2Fs12888-022-03888-1/MediaObjects/12888_2022_3888_MOESM1_ESM.docx`
(HTTP 200, sha256 `34ddddbbf0dc1d4e406298e0994c69e0c511b7d7ae1452de4fc101045d79f894`) and every
extracted cell was read from it. It should be filed with the other supplements and logged, so
that a checker can reach the same table without repeating the retrieval.

---

## Batch-level

**U19. The region vocabulary has no value for Southeast Asia.**
Thailand is in neither the enumerated `asia_east` list (China, Japan, Korea, Taiwan, Hong Kong,
Mongolia) nor the enumerated `asia_south` list (India, Pakistan, Bangladesh, Sri Lanka, Nepal).
`asia_east` was recorded for `bangkok_licm` on the ground that the World Bank groups Thailand
under "East Asia and Pacific" and the schema already uses World Bank classifications for
`country_income_level`, so the two moderators at least agree with each other. An `asia_southeast`
value would be better, and the review will need it again for Indonesia, Vietnam, Malaysia, the
Philippines and Singapore. Whichever way it is settled, the choice should be made once rather
than per batch, because region is a planned moderator.

**U20. Was splitting `fi_registers` into two cohort_ids right?**
hakulinen2020 describes three separately ascertained national case groups, each with its own
matched control group, each analysed separately, with no participant in more than one and no
pooled analysis anywhere in the paper. Prompt rule 11 and D12.5 point to separate cohort_ids, and
that is what was recorded: `fi_registers_scz` and `fi_registers_nonaff`, with the bipolar group
given no cohort at all because it fails SAP section 7. The counter-reading is that one register
extraction was categorised three ways, which would make them subgroup arms of one `smi_mixed`
cohort of 50,551 (82.1 per cent of whom carry a qualifying psychosis diagnosis). **The decision
has no consequence for any synthesis**, because both cohorts are blocked from every horizon by
`calendar_end_common` and by the only extractable timepoint being year 0. It is flagged so that
whoever merges the shard knows the manifest's single `fi_registers` identifier was changed
deliberately and on descriptive grounds alone. If a later batch turns out to need
`fi_registers` for a different Finnish register report, no clash arises: the ledger shows the
identifier appears only in F08.

**U21. Nothing in this shard has been independently checked.**
`checker` is blank on all 143 risk-of-bias rows and every `verifier` field in provenance.csv is
empty, which is correct because Stage G is a human's. It is stated here rather than left implicit
because two of the three counts extracted in this batch, hakulinen2020's 968/6939 and
11,335/34,565, would be among the larger denominators in the review if they ever became
horizon-eligible, and because the three counts NOT extracted are the ones most likely to be
challenged: a checker should look first at hui2026's blank numerator, at hakulinen2019's blank
numerator, and at jirapramukpitak2022's unrecorded 189/549.
