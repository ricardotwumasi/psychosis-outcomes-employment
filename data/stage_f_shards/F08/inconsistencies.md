# Batch F08: internal contradictions found in the sources

Every item gives the report, what the paper prints, what the arithmetic gives, and the exact
location. Items that block a result carry `conflict_status = unresolved` on that result and are
marked **BLOCKS**. Items that do not block a result are recorded because they bear on the
risk-of-bias reporting domains and on how much weight the numbers will carry.

---

## greenwood2025 (EYE-2 trial)

**I1. The Results text rounds an adjusted difference that Table 2 prints exactly.**
Table 2 (p. 149) gives the adjusted difference for education and training as **27.59** days.
The Results text (p. 149) says the intervention was associated with "**30** more days in
education and training". Rounding, not a contradiction of substance, but it is the figure a
reader of the narrative would carry away and it is 9 per cent higher than the table's.
Does not block: the table value is extracted.

**I2. Two of the three "probability mean days higher" values do not sit comfortably with their
own confidence intervals. NOT A CONTRADICTION, an observation for a reviewer.**
Table 2 (p. 149) pairs each adjusted difference with a bootstrap probability that the mean is
higher for intervention participants:

| Row | Difference | 95% CI | Printed probability | Normal approximation to the printed CI |
|---|---|---|---|---|
| Stable independent living | 5.73 | -1.79 to 13.25 | 98% | about 93% |
| Paid and unpaid employment | 7.56 | -35.64 to 50.76 | 77% | about 63% |
| Education and training | 27.59 | 1.52 to 53.68 | 99% | about 98% |

The employment row differs by 14 percentage points. This is not necessarily an error: the
analysis is bootstrap-based, so if the intervals are percentile intervals on a skewed
distribution the probability need not agree with a normal approximation. It is recorded because
a reader cannot tell which quantity is being reported, and because it is the row this review
cares about. Raised with the authors at U2. Does not block: the row carries no count anyway.

---

## hakulinen2019 (Danish registers)

**I3. None of the three odds ratios in the Abstract matches Table 1's value for the age it
names.**
The Abstract (p. 1343) states: "Schizophrenia diagnosis between ages 15 and 25 (n = 9448) was
associated with higher odds of not being employed (**at the age of 30: OR 39.4, 95% CI
36.5-42.6**), having no secondary or higher education (**7.4, 7.0-7.8**), and living alone
(**7.6, 7.2-8.1**)."
Table 1 (p. 1348), Age 30, Model 1 (sex and birth year adjusted), gives:

| Outcome | Abstract, "at the age of 30" | Table 1, Age 30, Model 1 |
|---|---|---|
| Not employed | 39.4 (36.5-42.6) | **38.24 (34.93-41.87)** |
| Low education | 7.4 (7.0-7.8) | **7.72 (7.25-8.22)** |
| Not cohabiting | 7.6 (7.2-8.1) | **7.11 (6.62-7.64)** |

The education figure is close to the Results text's age-35 value, "at the age of 35: OR 7.4, 95%
CI 7.0-7.9" (p. 1348), except that the abstract prints the upper bound as 7.8 rather than 7.9;
the other two appear nowhere else in the paper. No adjustment model in Table 1 reproduces the
abstract's numbers. Does not block an extracted result, because the extracted rows are the
absolute proportions and not the odds ratios, but it is why the statistical-analysis and
reporting judgements for this report are unfavourable.

**I4. The rehospitalisation percentage does not match its own counts.**
Results, Sample (p. 1346): "Out of the 9448 individuals who were diagnosed with schizophrenia
before the age of 25, a total of **6328 (69%)** were rehospitalized with schizophrenia after the
25th birthday." 6328 / 9448 = **66.98%**, which rounds to 67, not 69. For 69% the count would
have to be about 6519. Does not block: the subgroup is not extracted.

**I5. The Online Appendix is cited but absent.** Results, Sample (p. 1346) refers the reader to
"Online Appendix Tables 1 and 2" for the descriptive statistics, the numbers of participants and
the labour market outcomes, and Sensitivity analyses (p. 1348) to "Online Appendix Table 3". No
appendix is present in the held PDF, which is the 9-page article ending in the reference list,
and no supplement for this report is in `dissertation_shared_folder/supplements/`. This is the
single reason the report has no denominator: every denominator in it lives in the missing
appendix. Recorded here as a cited-but-absent table under the prompt's stop-and-say-so rule.

---

## hakulinen2020 (Finnish registers)

**No internal contradiction found.** Recorded positively because this is the one report in the
batch whose employment arithmetic reconciles completely. Every printed figure in the Results
sentence on p. 251 checks out against Table 1 (p. 252): 968/6939 = 13.95% against a printed 14%,
11,335/34,565 = 32.79% against 33%, 3,875/9,047 = 42.83% against 43%, 112,259/172,825 = 64.96%
against 65% and 31,242/45,235 = 69.07% against 69%. The three case-group sizes sum to the stated
total (6,939 + 34,565 + 9,047 = 50,551), and every control count in Table 1 is exactly five times
its case count in the same row, as the 1:5 matching requires.

One presentational point, not a contradiction: the file is named
`hakulinen-et-al-2019-...` although the article is Psychiatric Services 2020;71:250-255. It was
published online on 14 November 2019, which explains the filename.

---

## hui2026 (Hong Kong JCEP)

**I6. The percentage base changes between the baseline table and the follow-up table, without
saying so. This is the trap in this report.**
Table 2 (p. 289), baseline, row "Occupational status, n(%)": Employed **45 (37.2%)** deprived and
**85 (75.2%)** non-deprived; Unemployed **76 (62.8%)** and **28 (24.8%)**. Those are within-group
percentages: 45/121 = 37.2%, 85/113 = 75.2%, and each pair sums to 100% within its column.
Table 3 (p. 291), four years, row "Unemployed, n (%)": **40 (65.6%)** deprived and **21 (34.4%)**
non-deprived. Those are **not** within-group percentages. 40/112 = 35.7% and 21/107 = 19.6%.
They are percentages of the 61 unemployed **across** the two groups: 40 + 21 = 61, 40/61 = 65.6%,
21/61 = 34.4%, and the two sum to 100% across the row rather than down the column.
Consequence: anyone reading Table 3 the way Table 2 is written would conclude that 65.6% of the
112 deprived participants, that is 73 people, were unemployed at four years. The published table
gives no warning that its base has changed. This is why `reported_percentage_base` for that
result is 61 and why `n_outcome_observed` is blank. Does not block a result, because no result
row asserts a count.

**I7. The two chi-square statistics in Table 1's income rows are transposed.**
Table 1 (p. 287) gives, for monthly **household** income (101/20 deprived against 60/53
non-deprived), X2(1) = **98.29**; and for monthly **personal** income (84/37 against 7/106),
X2(1) = **25.12**. Recomputing both 2x2 tables on n = 234 gives the opposite assignment:
household income yields **25.12** and personal income yields **98.27**. The values are each
other's. Does not block a result; it bears on the statistical-analysis judgement.

---

## jackel2025 (Vivantes Berlin IPS trial)

**I8. Table 1's total-sample count for the main psychosis diagnosis is wrong, and its own arm
counts prove it.**
Table 1 (p. 5), Main diagnosis, row F2x: Total sample (N = 94) **50 (63.8)**, IPS (N = 48) **28
(58.3)**, TAU (N = 46) **32 (69.6)**. But 28 + 32 = **60**, and 63.8% of 94 = **59.97**, which
rounds to 60. The other two diagnosis rows behave correctly: F1x.5 is 13 + 10 = 23 with 23/94 =
24.5% as printed, and F3x is 7 + 4 = 11 with 11/94 = 11.7% as printed. With F2x at 60 the three
rows sum to 94 exactly and the percentages sum to 100.0; with F2x at 50 they sum to 84. The
printed **50 is a typographical error for 60**.
This one matters for eligibility, because F2x is the schizophrenia-spectrum share and
`perc_qualifying_diagnosis` is recorded from it. The cohort row records 63.8, the percentage,
which is consistent with the arm counts and with the other two rows; the discrepant 50 is
recorded here rather than used. Does not block: the diagnosis gate passes on either reading, and
passes even more comfortably once F3x is added.

**I9. The CONSORT flow does not reconcile at one box, and only at that box.**
Figure 1 (p. 6): "Assessed for eligibility (n = 502)"; "Not eligible (n = 369; 73.5%)" made up
of 237 + 82 + 50 = 369; "Eligible for randomization (n = **119**)"; "Not randomized (n = 23;
4.6%)"; "Randomized (n = 110)".
502 - 369 = **133**, not 119. And 119 - 23 = 96, not 110. But **133 - 23 = 110**, exactly as
shown. Every step from 110 downwards also reconciles: 56 + 54 = 110; 56 - 8 = 48 and 54 - 8 = 46,
which are Table 1's arm sizes; 48 - 2 = 46 and 46 - 2 = 44, which are the analysed sizes. The
single wrong number is **119, which should be 133**. Does not block any outcome denominator,
since none of them descends through that box.

**I10. BLOCKS. The same two counts are given two different minimum durations.**
Table 2 (p. 7), row label: "**EET at least one day**, n (%)" with IPS 38 (82.6) and TAU 26
(59.1).
Abstract (p. 1), describing exactly those numbers: "The percentage of participants in EET **for
at least 1 week** in the follow-up was 83% (38/46) versus 59% (26/44)."
A day and a week define different results. The counts agree, so what is contradicted is the
construct rather than the number. Neither statement is corrected anywhere. A candidate
resolution exists, since the operational definition of competitive employment requires the
participant to "hold the job for at least 1 day" (Methods 2.4.1, p. 3), which fits Table 2's
label; but that is a reconstruction and not an authority, so under prompt rule 14 the status
stays `unresolved`. **Blocks `jackel2025_ips_t12m_eetany` and `jackel2025_tau_t12m_eetany`.**
The primary outcome rows are unaffected: Abstract, Aims 1.1 and Results 3.2 all say "at least 15
h per week for at least 1 week", consistently.

**I11. BLOCKS. The education subsample cannot contain the people Table 3 says it does not
contain.**
Results 3.4 (p. 4): "Excluding all participants who never received education or training during
the follow-up period, we compared the two subsamples IPS (N = 25) versus TAU (N = 29) in
education/training." On that definition every one of the 25 and 29 received education or
training during follow-up.
Table 3 (p. 7), row "Education/training at least one day, n (%)": IPS **17 (68.0)**, TAU **11
(37.9)**. So 8 of the 25 and 18 of the 29 did not. Both statements cannot be true.
A second, separate denominator failure sits in the same paragraph: "In the IPS-education group,
78.6% (**11/14**) succeeded in continuing or resuming education/training compared to 33.3%
(**6/18**) of the participants in the TAU-education group". The denominators 14 and 18 are never
defined and match neither the subsample sizes (25 and 29) nor the counts in Table 3 (17 and 11).
**Blocks `jackel2025_ipsedu_t12m_edutrain` and `jackel2025_tauedu_t12m_edutrain`.**

**I12. The denominator moves between Table 1 and the text for the same baseline variables.**
Table 1 (p. 5) is computed on the post-T0 sample: total 94, IPS 48, TAU 46. The Discussion
(p. 8) recomputes the same baseline variables on the ITT sample: "only a few participants were in
competitive employment (IPS 15.2% vs. TAU 13.6%) or in education/training (IPS 17.4% vs. TAU
18.2%)". Checking each against the counts:

| Variable | Table 1 | Discussion | Discussion implies |
|---|---|---|---|
| IPS competitive employment | 7 (14.6% of 48) | 15.2% | 7 of 46 |
| TAU competitive employment | 6 (13.0% of 46) | 13.6% | 6 of 44 |
| IPS education/training | **9** (18.8% of 48) | 17.4% | **8** of 46 |
| TAU education/training | 8 (17.4% of 46) | 18.2% | 8 of 44 |

Three of the four are the same count on the smaller denominator, which is consistent. The IPS
education/training count is not: it moves from 9 to 8, which would require one of the two IPS
participants excluded after baseline to have been in education or training. That is entirely
possible and is probably what happened, but the paper never says so, and a reader comparing the
table with the text sees a count change without explanation. The extracted moderator counts use
Table 1's own denominators, which is why `n_female_denominator` is 48 and 46 while
`n_outcome_observed` is 46 and 44. Does not block.

**I13. A baseline percentage and a baseline total both fail by one or two.**
Results 3.1 (p. 4): "Participants with completed secondary education were twice as likely to be
in EET at baseline compared to those without: **20 participants (41.2%)** versus **9 (19.6%)**."
The denominators are Table 1's "Vocational training/higher education" split, 48 and 46. 9/46 =
19.57%, matching the printed 19.6%. But 20/48 = **41.67%**, not 41.2%. Separately, 20 + 9 = **29**
whereas Table 1's baseline EET total is 13 in competitive employment plus 17 in education or
training = **30**. Does not block.

**I14. The Discussion promotes a restricted subgroup result to a whole-arm one, and changes a
digit doing it.**
Results 3.2 (p. 4): "Adjusted for the 'NEET-status' at baseline, the EET rate decreased for both
groups: **71% (22/31)** in the IPS group and **40% (12/30)** in the control group at the 12-month
follow-up."
Discussion (p. 8): "After 12 months, **71%** of the IPS group was still in EET compared to
**39%** of the control group."
The Discussion drops the restriction to participants who were NEET at baseline, so it reads as a
whole-arm point prevalence at 12 months when it is the primary composite outcome computed on 31
and 30 people; and it prints 39% where the Results print 40%. There is no whole-arm
point-prevalence count anywhere in the report: Figure 2's monthly EET rates are a graph. Does not
block; the restricted subgroup is not extracted, for the reason recorded in the primary rows'
notes.

**I15. The eligibility criteria contradict the eligibility flow on vocational status.**
Section 2.2 (p. 2): "Young adults with EP who expressed interest in EET, **independent of their
education or vocational status**."
Figure 1 (p. 6), among the reasons for ineligibility: "Other, e.g. **are already enrolled in a
vocational training prior to study entry** (n = 50, 10%)."
If vocational status was irrelevant to eligibility, being enrolled in vocational training cannot
have made someone ineligible. This is why the cohort's employment-selection verbatim quotes both
and why the classification is `selected` rather than a partial or absent one. Does not block a
result; it decides the D9 gate.

**I16. The abstract labels a standard deviation as a standard error.**
Abstract (p. 1): "the total wages were higher in favor of the IPS group (mean = 10,242, SD =
13,437 versus mean = 5217, **SE** = 7871)". Table 2 (p. 7) prints both figures in a column headed
"Earnings in euro, mean (SD)": 10,242.33 (13,436.9) and 5216.56 (**7871.4**). The same quantity
is an SD in the table and an SE in the abstract. Trivial in itself; recorded because wages are a
registered outcome and someone may want the dispersion.

---

## jirapramukpitak2022 (Bangkok community health worker cohort)

**I17. A baseline percentage does not match its own counts.**
Table 2 (p. 7), History of psychiatric hospitalization, Total column: No **400 (72.9)**, Yes
**149 (29.1)**. 400 + 149 = 549, correct, and 400/549 = 72.86%, correct. But 149/549 =
**27.14%**, not 29.1%. The two printed percentages sum to 102.0. Both arm columns are correct
(375/485 = 77.3% and 110/485 = 22.7%; 25/64 = 39.1% and 39/64 = 60.9%), and 375 + 110 = 485 and
25 + 39 = 64, so only the total column's "Yes" percentage is wrong. Does not block: it is a
covariate, not the outcome.

**I18. One row of the baseline table silently has 42 fewer participants than the rest.**
Table 2 (p. 7), Psychiatric hospitalization in the past year: No **487 (96.1)**, Yes **20 (3.9)**.
487 + 20 = **507**, not 549. The percentages confirm that 507 is the base: 487/507 = 96.06% and
20/507 = 3.94%. The arm columns do the same: non-LICM 435 + 9 = 444 with 435/444 = 98.0% and
9/444 = 2.03%; LICM 52 + 11 = 63 with 52/63 = 82.5% and 11/63 = 17.5%; and 444 + 63 = 507. So 42
participants are missing from this variable, and the table neither says so nor prints a
variable-specific n. Every other row of Table 2 sums to 549. Recorded because it shows this
paper's tables do carry unstated per-variable missingness. **It does not affect the extracted
outcome**: in Table S3 the employment Yes and No cells sum to exactly 372 and 177, so employment
status was recorded for all 549 at one year.

**I19. The Results text and Table 3 disagree on a confidence interval and a p value.**
Table 3 (p. 8), Later stage, Any psychiatric ER visit: ATE 0.19, 95% CI **0.03-0.36**, p =
**0.023**.
Results (p. 9), same estimate: "0.19 (95%CI **-0.03**-0.36, p = **0.017**)". The interval either
does or does not include zero, and the two p values are different. Not an employment outcome, so
it does not block; it bears on the reporting judgement, since the same pair of numbers appears
twice in one paper with different values.

**I20. The single-largest marital-status percentage is off by a point.**
Table 2 (p. 7): Single **214 (40.0)**, echoed in the Results as "The majority were single
(40.0%)". 214/549 = **38.98%**. The two arm columns are right (173/485 = 35.7% and 41/64 = 64.1%)
and 173 + 41 = 214, so again only the total percentage is wrong. Does not block.

**I21. An interpretive point, not a contradiction: the denominator includes people who died.**
Table S3's employment cells sum to the full stratum sizes of 372 and 177, so employment status is
recorded for every analysed participant. But 8 participants (1.5%) died during the follow-up
year, and the ethics statement records that legally authorised representatives "provided
information on behalf of the participants later in the study period if they were unable to do so
for other reasons such as worsening symptoms, being hospitalized or death". A decedent therefore
sits in the denominator, almost certainly counted as not employed. That keeps ascertainment
complete, which is a real strength, at the cost of a handful of people for whom "employment
status at one year" has no meaning. It is a defensible choice and it is recorded so that the
apparent 100 per cent ascertainment is not read as more than it is.
