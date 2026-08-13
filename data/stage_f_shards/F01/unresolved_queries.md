# Batch F01: questions only an author can answer

All five reports come from one Hong Kong group (Chan SKW, Chang WC, Hui CLM, Chen EYH,
University of Hong Kong / EASY programme), so Q1 to Q6 could go in a single approach.
Four of the five reports are eligible evidence that the review cannot use for want of a
count, which is the D10.2 case: they belong in the missing-evidence assessment, not in an
exclusion box.

---

## chang2016 (Chang et al. 2016, J Affect Disord 200:1-5) - BLOCKING

**Q1. Does "sustained employment" include full-time students?**
Methods 2.2 (p. 2) defines it as "maintained full-time work/study or part-time work for 12
consecutive months in the third year of follow-up", while Table 1 footnote b and Table 2
footnote e both define it as full-time or part-time work with no mention of study. Which is
the numerator behind 111 and 21? If study is included, how many of each count were in
full-time education and not in paid work? Until this is answered both results are blocked
(`conflict_status = unresolved`) because they cannot be assigned to an outcome family.

**Q2. What is the denominator behind "111 (30.0)"?**
The column is headed n = 374, but 111/374 = 29.7% and no integer numerator over 374 gives
30.0%; 111/370 does, and the printed chi-square of 4.6 reproduces at 370 and not at 374.
Was vocational status unavailable for four schizophrenia patients? Please give the number
of patients in each diagnostic subgroup for whom employment status at 36 months was
actually ascertained. Without it `n_outcome_observed` stays blank and neither result can
enter a count model.

**Q3. Is there a whole-sample sustained-employment figure, and a 12-month or 24-month one?**
111 + 21 = 132 of 420 is not printed and has not been derived here, because the two
components sit on different subgroups with different (and in one case contradicted)
denominators. Please confirm the whole-sample count and its denominator. More importantly,
36 months falls in **no** prespecified landmark band for this review (the 24-month band
closes at 30 months, the 5-year band opens at 48), so **as published this report cannot
contribute to any horizon**. Monthly outcome data were collected for all 36 months; a count
employed at 12 months, or at 24 months, would be usable where the 36-month figure is not.

**Q4. Supplementary Table S1** (baseline characteristics, cited on p. 3) is not in the PDF
held. All moderator fields are consequently blank. The main text gives, without a clear
label, age 19.7 for psychotic mania against 21.1 for schizophrenia; whether that is age at
entry or age at onset is not stated, so it has not been recorded. Please supply S1, or at
least age, sex and education by subgroup.

---

## chan2020 (Chan et al. 2020, Br J Psychiatry 217:491-497)

**Q5. How many patients were in employment at the 10-year assessment?**
This is the review's highest-value missing number in the batch: employment is the paper's
stated outcome, over ten years, in a territory-wide first-episode cohort, and no count of
employed people appears anywhere. What is reported is monthly employment histories reduced
to (a) hierarchical-cluster membership (good employment cluster: early intervention 98 of
145, standard care 76 of 145) and (b) mean months of full-time employment. A trajectory
cluster is not a prevalence and has not been recorded as one. Please supply, for the early
intervention and standard care samples separately, the number employed at 12 months, at 24
months and at 10 years, with the number for whom status was observed at each.

Note for whoever asks: the paper's own construct would still not be `paid_any`. It counts
"full-time or part-time competitive paid employment or full-time education" and states that
"supported employment, volunteer work, working at a rehabilitation centre and part-time
education were not included" (p. 492). That is `paid_or_education` with paid sheltered and
supported work deliberately excluded, so it can never substitute for any paid employment.
A count that separates paid work from full-time education would be worth asking for.

**Q6. Six exclusions or five?** p. 492 says six patients were excluded and each group then
consisted of 145, but p. 493 gives 110 to 107 in early intervention and 104 to 102 in
standard care, which is five. chan2022's analysed 209 = 107 + 102 supports five. Which is
right, and what is each group's post-exclusion N?

---

## chan2019 (Chan et al. 2019, Schizophr Res 204:65-71)

**Q7. Employment status was collected but never reported.** Methods 2.3 (p. 66) states that
"demographic information including age, gender, education level, employment status were
obtained" at the 10-year interview, yet no employment count or rate appears in the paper.
Please supply the number employed at the 10-year interview and the number for whom status
was recorded (n = 107 analysed).

Also: months of unemployment in this report explicitly "includ[es] period of unemployment
and rehabilitation" (table footnotes, pp. 67-68), so time in a rehabilitation setting is
counted as not employed. If any count is supplied, the review needs to know whether paid
rehabilitation placements were treated the same way.

---

## chan2022 (Chan et al. 2022, Asian J Psychiatry 71:103087)

**Q8. Any count behind the months of employment?** Table 2 (p. 4) reports mean months of
employment and unemployment over 10 years by relapse group, and the RFS work subscale as a
1 to 7 rating, but no count of employed people at any timepoint. Please supply the number
employed at the 10-year interview for the analysed 209, or by relapse group.

---

## chang2016b (Chang et al. 2016, Schizophr Res 173:79-83)

**Q9. How many were in competitive employment at 12 months?** Functional remission required
SOFAS > 60, RFS subscale thresholds **and** being "engaged in competitive employment
(full-time or part-time work or studying)" at both 6 and 12 months, and only the composite
is counted (31 of 156, 19.9%). The employment component alone is never reported. This is a
12-month randomised follow-up, so a count would fall squarely in the primary landmark band.
Please supply the number in competitive employment at 12 months, by allocated arm and
overall, with the denominator, and separating paid work from studying, since this report
counts full-time study as "competitive employment" and the review does not.

**Q10. Trial recruitment dates and full eligibility criteria.** The methods are deferred to
Chang et al. 2015 (Br J Psychiatry 206:492-500), which is not in the batch. Because this
report's own eligibility statement is incomplete, `employment_selection_status` is recorded
as `unclear` under D9 rather than `none`, which keeps this cohort out of the primary pool
and admits it only to a named sensitivity analysis. Obtaining Chang et al. 2015 would
almost certainly settle it, and would also give the recruitment window needed to decide
whether this trial sample overlaps any other Hong Kong cohort.

---

## Cohort-structure questions for the review team, not the authors

**Q11. Do the two EASY samples share participants?** `hk_easy_2001` (chan2019, chan2020,
chan2022) is 148 EASY entrants of 1 July 2001 to 30 June 2002 with a schizophrenia-spectrum
diagnosis. `hk_easy_fep_2001_2003` (chang2016) is 700 EASY enrollees of July 2001 to August
2003. Both are described as territory-wide consecutive enrolment, so the first is almost
certainly inside the second, but **neither report says so**. They are recorded as separate
cohorts with reciprocal `overlaps_with` rows, and their results must never be pooled. If an
author confirms the overlap, `hk_easy_2001` results (if any are ever obtained) and
`hk_easy_fep_2001_2003` results must be treated as one cohort for the random effect.

**Q12. Is Chang et al. 2015 (the parent RCT, Br J Psychiatry 206:492-500) in the screened
set?** It is cited by both chang2016b and chan2020 (reference 16) and would supply Q10.
If it is not among the 90, it cannot be reinstated without a documented screening-list
amendment (D10.1); it can still be read as a source of methods for a report that is in the
set.

---

## Convention established by this batch, flagged for Stage G

`extraction_rob.csv` had no rows before F01, so this shard sets the JBI domain naming:
`jbi1_sample_frame`, `jbi2_participant_sampling`, `jbi3_sample_size`,
`jbi4_subjects_setting_described`, `jbi5_coverage_of_sample`,
`jbi6_condition_identification`, `jbi7_condition_measurement`, `jbi8_statistical_analysis`,
`jbi9_response_rate`, with the checklist question itself in `signalling_responses`. If
another batch has already chosen different slugs, one of the two must be renamed before the
shards merge; there is no vocabulary for `domain` in `config/vocabularies.yml` to arbitrate.
