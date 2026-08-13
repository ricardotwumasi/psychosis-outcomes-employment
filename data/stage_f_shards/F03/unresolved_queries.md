# Batch F03: unresolved queries

What an author, or a further source, would have to answer before the blank or provisional value
becomes a number. One section per report, most consequential query first.

---

## benson2022 (us_vha, relapse and nonrelapse subgroups)

1. **Table 3, relapse cohort, full-time employment: is the count 577 or the percentage 5.4?**
   The six counts sum to exactly 16,862 and the other five percentages each check out, so 577
   looks correct and 5.4 looks like a cell copied from the nonrelapse column; but the review
   cannot resolve a published self-contradiction by its own arithmetic (D12.3d). Until the
   corresponding author (Dee Lin, Janssen Scientific Affairs) confirms which is right, the
   relapse-cohort full-time component and the derived `paid_any` total are blocked from every
   synthesis. **This is the single query in F03 whose answer changes a numerator.**
   A reply of "the counts are correct" would unblock 929 / 16,311.

2. **When was employment status measured?** The outcome is "based on the most recent nonmissing
   data during the study period", the study period runs 1 January 2013 to 30 September 2019 and
   includes the 12-month pre-index baseline, and the authors state that no temporality was
   applied between exposure and outcome. Could the authors give the distribution of the interval
   between the index date and the employment record, or restrict to records after the index
   date? Without it, `followup_basis` is `unclear`, `followup_months` is blank, `ascertainment`
   is `unclear`, and the result cannot be assigned to any landmark horizon.

3. **What do the six employment categories mean?** None of full-time, part-time, unemployed,
   retired, self-employed is defined, and the Veterans Benefits Administration Corporate Database
   field is updated only twice a year. Is "unemployed" actively seeking work or simply not
   employed? Are people on disability compensation coded unemployed or retired? This determines
   whether the `paid_any` derivation's assumption, that no non-paid category conceals paid work,
   holds exactly.

4. **Is the sex variable exhaustive?** Table 1 prints only "Male, n (%)". `n_female` is left
   blank rather than derived as 16,862 minus the male count, because the table does not show that
   male and female exhaust the field.

5. **Employment status for the unmatched cohort.** Could the authors report the employment-status
   distribution for the whole 119,343-veteran schizophrenia cohort, before relapse
   stratification and propensity matching? That, and only that, would give `us_vha` a
   whole-cohort result eligible for the primary prevalence estimand.

---

## lin2022 (us_vha)

1. **Counts behind Figure 2.** Figure 2a prints 69.2 per cent unemployed for the schizophrenia
   cohort with no numerator and no denominator. What is the count, and what is the denominator?

2. **What was the base?** Does the 69.2 per cent divide by the full matched cohort of 102,207, or
   by those with a non-missing employment record? The sibling benson2022 reports 3.3 per cent
   missing on the same field and divides by the full cohort, but lin2022 reports no missing
   category at all, so its base cannot be established. `reported_percentage_base` is left blank
   for this reason.

3. **The full employment-status distribution.** benson2022 shows the same administrative field
   has six categories. Could lin2022's authors report full-time, part-time, self-employed,
   retired and missing for the 102,207, as they did for the 16,862 in the sibling paper? That
   would turn this report from unquantifiable into a whole-cohort `paid_any` result on the
   largest sample in the batch. Until then the report contributes nothing:
   100 minus 69.2 is not employment, because retired (15.8 per cent in the sibling) and missing
   veterans would be counted as employed.

4. **Standardised mean differences.** Three of the five printed SMDs cannot be reproduced from
   the printed percentages (inconsistencies.md L1); which figures are correct?

---

## ayesaarriola2020 (pafip_spain)

1. **The denominators for Table 1's 10-year rows.** How many patients had employment status
   recorded at the 8-to-16-year reassessment? The percentages imply 107 men and 90 women, but
   that is a back-calculation from a printed percentage and cannot be used. With the printed
   denominators, this report would supply a `paid_any` numerator by complement at the 10-years-
   or-more horizon, exactly as it does at baseline. **This is the highest-value query in the
   batch by evidence recovered**: it would add a cohort to a horizon that currently has none from
   F03.

2. **Is the 10-year employment variable binary?** The Measures section describes employment
   status as "employed" versus "unemployed", and "Student (yes)" is a separate variable. Are
   students coded unemployed, and can a person be both a student and employed? The complement
   only yields paid employment if the variable is exhaustive and students are not counted as
   employed.

3. **A single follow-up time.** The reassessment window is 8 to 16 years and the paper gives no
   mean or median elapsed time, only "after an average period of 10 years". What is the mean and
   the distribution? Needed before the result could be assigned to the 108-months-or-more
   horizon rather than merely described.

---

## mayoralvanson2019 (pafip_spain)

1. **How were the 157 chosen?** "A subsample of 157 patients within PAFIP was selected for the
   present study", and the cross-reference for the criteria is a stray numeric "(15)" that
   cannot be resolved against the paper's author-year reference list. Which years does the
   subsample cover, and on what basis were these 157 selected from PAFIP? Because the answer is
   unknown, `analysis_selection_status` is `unclear` with reason `incomplete_reporting`, and the
   result is therefore **excluded from the primary pool and admitted only to the named
   sensitivity analysis** (D9), even though the cohort's own recruitment criteria carry no
   employment restriction. An answer of "consecutive PAFIP admissions in years X to Y" would move
   this to `none` and put the batch's only 12-month `paid_any` result into the primary pool.

2. **Which denominator does Table 3 use?** The baseline row's percentages divide by 156 and the
   one-year row's by 157, while both rows' counts sum to 156 (inconsistencies.md M1). How many
   patients had an employment status recorded at each timepoint?

3. **How is "Employed" defined?** The report never defines it. Does it include paid sheltered or
   supported work? Does "Temporary disability" remove from the employed count people who still
   hold a job but are on sick leave? On the coding adopted, it does, which makes 36 a lower bound
   on any-paid-employment in the sense of holding a job.

4. **Where did the employment data come from?** The methods name clinical records and Cantabria
   Health Service records but do not say which supplied employment status, nor who abstracted it.

---

## nossel2018 (ontracky_ny)

1. **The measurement window for work at follow-up.** The paper states only that "Data collected
   at admission refer to the 90 days prior to the assessment". Is employment at the 3-, 6-, 9-
   and 12-month assessments current status on the day, or any work in the preceding quarter?
   Coded `point_prevalence` on the strength of basaraba2023's footnote for the same OnTrackNY
   variable ("in school and/or employed at the time point"), but the confirmation should come
   from this report's own authors.

2. **Employed counts at 9 and 12 months.** The paper gives raw counts of employed only, in school
   only, and both at admission and at six months, but at 12 months only a model-estimated
   adjusted prevalence of the composite (Figure 1B) and a Kaplan-Meier cumulative probability.
   Could the authors give the same three-way counts and the denominator at 9 and 12 months? That
   would give `ontracky_ny` a `paid_any` result in the 9-to-18-month landmark window, which it
   currently lacks entirely. **Second highest-value query in the batch.**

3. **260, 261 or 262 at six months?** (inconsistencies.md N1.)

---

## basaraba2023 (ontracky_ny)

1. **Paid employment separately from education.** The reported outcome is a single composite of
   education, vocational training and any paid employment, so no paid-employment numerator can
   be recovered at any of the eight timepoints. Could the authors report the paid-employment
   component alone, at 12 and 24 months, on the same denominators? The underlying OnTrackNY form
   records work and school separately, as nossel2018 shows, so the data exist. **This would give
   `ontracky_ny` a `paid_any` result at both the 12- and 24-month landmarks and is the largest
   single recovery available in this batch.**

2. **The holdout set.** Rates are given for the training/cross-validation split only (1038 of
   1298); the holdout is described as showing "similar distributions" with no counts. Could the
   holdout counts, or the whole-sample counts, be reported? The analysed denominator would then
   be the whole recruited sample rather than a split of it.

3. **How was the holdout drawn?** The eMethods and eFigure 1 describing the split were not
   available with this PDF. The split is stated to be about 20 per cent and the training set
   spans 19 of 20 sites, which suggests it is not purely at random. Nothing suggests it is
   employment-related, so `analysis_selection_status` is `none`, but the supplement should be
   obtained before that is confirmed at Stage G.

---

## Outstanding within the review, not with an author

- **Independent arithmetic check of the derived counts.** `checked_by` is blank on both
  `benson2022_*_paidany` rows. The sums have been recomputed here (577 + 284 + 68 = 929;
  908 + 428 + 93 = 1,429; both denominators are the printed n minus the printed missing count)
  and the column totals reconcile exactly to 16,862, but the codebook requires an *independent*
  check and this batch cannot supply one. Stage G must.
- **`report_quantifiable` for `ayesaarriola2020` and `lin2022` is `no`.** Both are eligible
  evidence the review cannot use. They belong in the missing-evidence assessment, and the two
  author queries above are the only routes to recovering them.
