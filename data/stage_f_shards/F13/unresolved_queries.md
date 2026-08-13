# Batch F13 unresolved queries

What an author, or in two cases the authorship group, would have to answer before the
affected field can be filled or the affected decision can be relied on. Ordered by report,
with the schema-level questions last.

Batch: F13. Extractor: claude-opus-5. Date: 12 August 2026.

---

## tsiachristas2016

**Q1. Does online supplementary appendix 1 contain any employment-related sample-selection
step?**
The cohort is coded `employment_selection_status = none` on the main-text chain, which is
complete as printed: ICD-10 code plus care cluster plus HONOS item 6, then age 16 to 35,
then an observed HONOS score in 2010/2011, giving 3,674 of 15,709. But the Methods add that
"A detailed description of the sample selection criteria and sample identification is
presented in online supplementary appendix 1" (p. 2), and that appendix is **not held in
this repository**. *Field affected:* `employment_selection_status` on `oxford_ahsn`.
*If the appendix contains an employment-related step,* the cohort becomes `selected` and
the classification recorded here is wrong. This is a documentary check, not an author
query: the appendix is published with the article and can be retrieved.

**Q2. On which denominator were the probability ratios actually computed?**
The Methods define both outcomes on restricted denominators (those unemployed at the start
of follow-up; those not in education at the start), while the complete-case analysis prints
n = 1,801 and n = 1,664, which exceed the numbers who could satisfy those restrictions and
have a baseline record (about 1,380 and 1,565 from Table 1's percentages). *Fields
affected:* `conflict_status` on both rows, and `analysis_selection_status` on both arms.
*If the answer is that the models were fitted to everyone with two observations,* the
analytic restriction disappears and `analysis_selection_status` should become `none`, while
the outcome definitions printed in the Methods are wrong. Either way the conflict is
resolvable only by the authors (rule 14).

**Q3. What are the numerator and denominator for becoming employed, by group?**
No count is printed anywhere in the paper. A single table of counts would convert this
report from unquantifiable to quantifiable. *Fields affected:* `n_employed`,
`n_outcome_observed`; `report_quantifiable` on the report row. Recorded in the
missing-evidence assessment under D10.2.

---

## turner2019

**Q4. Which of the four participation counts is wrong, and did 8 or 10 unoccupied
participants attain a productive role?**
Two separate contradictions, both blocking. 21 + 9 - 4 = 26 against a printed 27; and the
Abstract's n = 10 against the Results' 8. Candidate resolutions are recorded in the
`conflict_note` fields ("both" = 3; and the Results' 8 is correct) and are deliberately
**not applied**, because rule 14 requires an authority rather than a reconstruction.
*Fields affected:* `conflict_status` and `n_employed` on all five turner2019 rows.
*Until answered,* this report contributes nothing to any synthesis.

**Q5 (turner2019). Does "productive role" include training, and what determined when the
follow-up interview happened?**
Two loose ends in one report. First, the construct is written as "paid employment or
education" where the results are reported (pp. 116 and 119) and as "paid employment or
formal education/training" in the data-analysis section (p. 117); the rows are coded
`paid_or_education` on the former, and would become `paid_or_education_or_training` on the
latter. Second, follow-up is "18 months (SD 12; range 2-44)" with no stated schedule and no
stated common end date, so `followup_basis` is coded `unclear`; if the authors confirm that
all follow-up interviews were completed by one date at the end of the grant, the correct
value is `calendar_end_common`. *Both values bar every horizon identically (D12.8), so this
changes the description, not the eligibility.*

---

## xu2020

**Q6. Was the follow-up conducted as a single interview campaign ending on one date?**
**This is the most consequential open question in F13.** `followup_basis = since_baseline`
with `followup_months = 125` is what admits the batch's only poolable result to the
10-year-or-more horizon. The reasoning is in the row notes: the anchor is cohort entry, the
report never states a shared end date, and the SD of 0.3 years keeps every plausible
individual follow-up inside the band. The counter-argument is quantitative and is recorded
rather than suppressed: all 118 were admitted during calendar 2006, and a single interview
campaign would make elapsed follow-up inherit the entry spread, giving an SD of about 0.29
years for admissions spread uniformly over a year, which is what is observed. *Field
affected:* `followup_basis` on all three xu2020 rows. *If the answer is that interviews ran
to one common end date,* the value becomes `calendar_end_common` and **all three results are
barred from every landmark horizon**, leaving the review with no 10-year contribution from
F13.

**Q7. What does "currently employed" count?**
Neither remuneration, hours, contract status nor labour-market setting is defined; the
question was asked by telephone of a proxy informant (a parent for 59 of 65 subjects) and
"economically self-sufficient" is recorded separately as a different variable. The construct
is coded `paid_any` on the unemployed / employed / in-school trichotomy, and the concern is
carried in `jbi7_condition_measurement = no`. *Field affected:* `outcome_construct` on
`xu2020_cohort_t125m_paidany`. *If unpaid family work or sheltered placements were counted,*
the construct is not `paid_any` and the result leaves the primary pool. *If only formal
waged employment was counted,* `paid_any` stands and may even understate.

**Q8. How many of the 53 not interviewed were alive at follow-up?**
`n_alive_eligible` is blank because only the interviewed group's vital status is known (3 of
65 had died). *Fields affected:* `n_alive_eligible`, and with it the complete-cohort
best-case and worst-case bounding analyses of SAP section 6, which cannot be executed for
this cohort as recorded. 118 must not silently substitute for the alive-and-eligible
denominator.

---

## yamaguchi2020

**Q9. Why were 42 of the 93 eligible clients not analysed?**
"During the recruitment period, 93 clients met the inclusion criteria, and 51 were included
in the analyses (see flow diagram available in the online supplement)" (p. 477). The online
supplement is **not held in this repository**. *Fields affected:* `analysis_selection_status`
(currently `unclear` / `incomplete_reporting`), `n_entered` (blank), and
`jbi2_participant_sampling`. *If the 42 were non-consenters or dropouts,*
`analysis_selection_status` becomes `none` and this is ordinary attrition under D12.3c; *if
any were excluded on an employment-related basis,* it becomes `selected` /
`analytic_restriction`. Like Q1 this is a documentary retrieval rather than an author query:
the supplement is published with the article.

---

## zhang2017

**Q10. How many participants dropped out of each arm, and how was employment status
obtained for them?**
The report prints no attrition figure of any kind for a 15-month three-arm trial, stating
only that "The participants (n = 162) were subject to intent-to-treat analyses on employment
rate ... The drop-out cases were also included". *Fields affected:* `n_outcome_observed`
(blank on all three arm rows), `missing_data_method` (`not_stated`), and
`rob2_3_missing_outcome_data` (`high`). *Until answered, these rows cannot enter the
intervention count model of SAP section 10.2,* because the model is
`n_employed | trials(n_outcome_observed)` and the review may not substitute an intent-to-treat
reporting base for an observed denominator (prompt rule 7). This is the single field that
would most increase what F13 contributes to the secondary estimand.

**Q11. Which test produced the reported p = .002 for ISE versus IPS, and over what window
was cumulative employment accumulated?**
Two questions about the same analysis. A two-sided chi-square on the printed 34/54 against
27/54 gives p ~ 0.17, not the printed .002, while the same .002 does reproduce for ISE
against TVR (34/54 against 18/54); the paper says only that chi-square was used "at
different intervals" with Bonferroni-adjusted post-hoc comparisons. Separately, "assessments
at the 7th month after joining the program were operationally adopted as the baseline for
the vocational outcomes including employment rate", so cumulative employment may have been
accumulated over months 7 to 15 rather than 0 to 15. *Fields affected:*
`rob2_5_selective_reporting` (`high`) and the interpretation of the cumulative window; the
counts themselves are not blocked, for the reasons set out in `inconsistencies.md` Z1.

---

## Schema-level questions for the authorship group

**S1. Does D12.8's bar apply when the mean follow-up cannot span two horizon bands?**
`andersen2026`, the case D12.8 was written for, has individual follow-ups of 4.5 to 23.5
years and a mean of 11.1, so the mean spans two landmark bands and assigning it would place
a cohort in a band on the strength of an average. `xu2020` has a mean of 10.4 years with an
SD of 0.3, so every plausible individual follow-up is inside one band. D12.8 as written is
categorical: `calendar_end_common` "is barred from every landmark horizon". F13 has applied
the rule's **trigger** rather than its consequence, coding `since_baseline` because the
report never states a shared end date, and has flagged the decision for verification (Q6).
*The authorship group may wish to decide whether the rule should carry a dispersion
condition* (for example, that a mean follow-up is assignable when its printed dispersion
keeps the cohort inside one band), or whether the categorical bar stands and this coding
must be revisited. Either answer is defensible; what is not defensible is deciding it after
seeing whether it changes the pooled estimate, so it is raised now, before merge.

**S2. Is a duration threshold inside the follow-up window a `paid_intensity_threshold`?**
D12.3a and the vocabulary describe `paid_intensity_threshold` with a proportion-of-working-
days example ("employed for at least 25% of working days"). F13 has applied the value to two
duration-based thresholds, on the reasoning that both exclude people below the threshold
while keeping a paid-employment label, which is the failure D12.3a names:

- `zhang2017`: "continuously held competitive employment at least 20 hr/wk for 2 mo or
  longer were considered employed" (an hours threshold and a duration threshold together);
- `turner2019`: "at least one month or more, in paid employment ... during the follow-up
  period".

The alternative coding is `paid_competitive` and `paid_any` respectively, with the threshold
recorded only in `outcome_verbatim`, which would put both into pools whose other members
count anyone with any paid work. *If the authorship group prefers the alternative,* two rows
in this shard change construct; no count changes. `yamaguchi2020`'s "working at least 1 day a
month at minimum wage or more" was judged to be an operational definition of employment
rather than an exclusionary threshold and is coded `paid_competitive`; the line between the
two cases is a judgement this shard has made explicitly rather than silently.

**S3. Two shard-level absences to note at merge.**
No `arm_type = cohort` row exists for `oxford_ahsn`, `jisef_japan` or `wuxi_ise_rct`. In each
case no whole-cohort employment count is printed, and for `wuxi_ise_rct` a merged row would
fail the SAP section 2.1 safeguard `employment_targeted_intervention` in any event, since
every arm received a vocational intervention. The pool builder will therefore find no
whole-cohort row for those three cohorts, which is correct rather than an omission.
