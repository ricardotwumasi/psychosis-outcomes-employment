# Batch F03: internal contradictions found in the sources

Every contradiction found while extracting the six F03 reports, with what the paper prints,
what the arithmetic gives, and where. Entries marked **BLOCKING** carry
`conflict_status = unresolved` on the affected result rows.

---

## benson2022

### B1. **BLOCKING.** Table 3 full-time employment, relapse cohort: 577 counted, 5.4 per cent printed

**Location:** Table 3, "Non-Health Care Societal Burden Among the Matched Cohorts", Employment
status block, Relapse Cohort column (n = 16,862). PDF p. 5 (the appended `21m03173T3.gif`).

**What the paper prints:** `Full-time employment 577 (5.4)`.

**What the arithmetic gives:** 577 / 16,862 = **3.42 per cent**, not 5.4.

**Which value is wrong, and how that is established:**

| Row | Count | Printed % | Count / 16,862 |
|---|---|---|---|
| Full-time employment | 577 | 5.4 | **3.42** |
| Part-time employment | 284 | 1.7 | 1.68 |
| Unemployed | 12,721 | 75.4 | 75.44 |
| Retired | 2,661 | 15.8 | 15.78 |
| Self-employed | 68 | 0.4 | 0.40 |
| Missing data | 551 | 3.3 | 3.27 |
| **Sum** | **16,862** | **102.0** | **99.99** |

The six counts sum to exactly the printed cohort n of 16,862, and the other five percentages
each reproduce their own count. The printed percentages sum to 102.0, and the excess is exactly
the 2.0 points by which 5.4 exceeds 3.4. The value 5.4 is also what the adjacent Nonrelapse
column prints for the same row (908 / 16,862 = 5.39, correct there), so the cell reads as a
copied percentage. The count is therefore very probably right and the percentage wrong.

**Why it is still blocking.** D12.3d resolves a published self-contradiction by an author reply,
not by an extractor's arithmetic. The relapse cohort's `..._fulltime` component row and the
derived `benson2022_relapse_mostrecent_paidany` row both carry `conflict_status = unresolved`
with this note. The nonrelapse column contains no contradiction and is not blocked.

### B2. Table 1 cancer count in the nonrelapse cohort is impossible

**Location:** Table 1, "Demographic and Baseline Clinical Characteristics of the Study
Population", Comorbidities of interest, Cancer row, Nonrelapse Cohort column. PDF p. 3.

**What the paper prints:** `587,581 (3.4)`.

**What the arithmetic gives:** the cohort is 16,862 veterans, so a count of 587,581 is
impossible; 3.4 per cent of 16,862 is 573.

Not blocking, because cancer is not an extracted variable. Recorded because it is a second
arithmetic or typesetting failure in the same article's tables, and it bears on how much weight
B1's printed percentage can carry. The same tables also drop parentheses ("3,021 (17.9",
"4,099 24.3)").

---

## mayoralvanson2019

### M1. Table 3 changes its percentage base between its two rows

**Location:** Table 3, "Employment status ... Baseline and 1 year of follow-up", p. 1186.

| | Employed | Unemployed | Inactive | Temp. disability | Count sum | Printed % sum |
|---|---|---|---|---|---|---|
| Baseline | 49 (31.4) | 69 (44.2) | 30 (19.2) | 8 (5.1) | **156** | 99.9 |
| 1Y follow-up | 36 (22.9) | 71 (45.2) | 28 (17.8) | 21 (13.4) | **156** | 99.3 |

**What the arithmetic gives:** the baseline percentages reproduce only on a base of **156**
(49/156 = 31.41; 49/157 = 31.21, which would print 31.2). The one-year percentages reproduce
only on a base of **157** (36/157 = 22.93; 36/156 = 23.08, which would print 23.1). Both rows'
counts sum to 156, on a study sample the paper states as 157.

**Reading adopted:** one male patient has no baseline employment status recorded (see M2), and
one male patient committed suicide during the follow-up year (Results 3.2, p. 1185), leaving 156
alive and classified at one year. The extraction records `n_employed = 36`,
`n_outcome_observed = 156` (the sum of the four one-year categories),
`n_alive_eligible = 156`, `n_entered = 157` and `reported_percentage_base = 157`, so both the
observed denominator and the authors' own base are recoverable by a checker. Not blocking: the
numerator 36 is printed unambiguously and no two printed numbers disagree about it.

**Consequence for the manifest:** the triage note reads "36/157 at 12m". 157 is the reporting
base, not the observed denominator. Corrected in `manifest_changes.csv`.

### M2. Table 1's baseline unemployment cell implies a male base of 99, not 100

**Location:** Table 1, "Employment situation (unemployed)", p. 1185.

**What the paper prints:** entire sample `69 (44.23)`, male group `47 (47.47)`, female group
`22 (38.60)`, under column headers `N = 157`, `n = 100`, `n = 57`.

**What the arithmetic gives:** 47 / 100 = 47.0, not 47.47; 47 / **99** = 47.47. 22 / 57 = 38.60
(correct). 69 / 157 = 43.95, not 44.23; 69 / **156** = 44.23. So one male has no baseline
employment status, which is consistent with the baseline base of 156 in M1. The male and female
subgroups do sum correctly to the total (47 + 22 = 69).

---

## nossel2018

### N1. Three different values for the six-month sample size

**Location:** Results text p. 866; Table 2 "Timing of discharge among 325 participants in
coordinated specialty care, by follow-up period" p. 866; Table 3 "Change in outcomes over time
among 325 participants" p. 867.

| Source | Value | What it is called |
|---|---|---|
| Results text, p. 866 | **260** | "the 260 clients with data at six-month follow-up" |
| Table 3, p. 867 | **261** | "N at follow-up" for the 3-to-6-month contrast |
| Table 2, p. 866 | **262** | start of the 6-9 month period (325 - 17 discharged - 46 censored) |

**What the arithmetic gives:** Table 2 is internally consistent (325 - 17 - 46 = 262;
262 - 16 - 50 = 196; 196 - 20 - 43 = 133). The printed six-month percentages fit 260 or 261 but
not 262: 77 / 260 = 29.6 and 77 / 261 = 29.5 both print as 30, while 77 / 262 = 29.4 would print
as 29.

**Reading adopted:** `n_outcome_observed = 260`, taken from the sentence that also supplies the
numerator and that explicitly says "with data at six-month follow-up"; `n_alive_eligible = 262`
from Table 2. Not blocking: the three figures plausibly describe three different quantities
(observed employment data, model contribution, and still enrolled and uncensored), and no two of
them are offered as the same quantity.

### N2. Sample size against the programme's own quality-improvement count (explained by the paper)

The paper reports 325 study participants against a quality-improvement count of 334 enrolled and
329 retained at three months, and explains it: "The slight lag between the time of
deidentification and the QI report explains why there were 325 individuals in this study and 329
in the QI report" (Results, p. 866). Recorded as resolved by the source; no action.

---

## ayesaarriola2020

### A1. Table 1's denominators change from row to row and are never printed

**Location:** Table 1, "Comparison of baseline and 10-year follow-up characteristics between male
and female FEP patients", pp. 3-4 (column headers `N = 114` male, `N = 95` female).

**What the arithmetic gives**, taking the printed count over the printed percentage:

| Row | Male count (%) | Implied male base | Female count (%) | Implied female base |
|---|---|---|---|---|
| Baseline: Unemployed | 54 (47.4) | 114 | 27 (28.4) | 95 |
| Baseline: Children | 15 (14.0) | 107 | 36 (40.0) | 90 |
| Baseline: SES of parents (low) | 63 (55.8) | 113 | 50 (53.2) | 94 |
| **10Y: Unemployed** | **35 (32.7)** | **107** | **22 (24.4)** | **90** |
| 10Y: Diagnosis schizophrenia | 84 (84.0) | 100 | 53 (63.9) | 83 |
| 10Y: Tobacco | 70 (61.4) | 114 | 43 (45.3) | 95 |

At least five different denominators are in use across one table and none of them is printed.

**Consequence, and it is the decisive one for this report.** The baseline unemployment row does
sit on the printed 114 and 95, so baseline employed is recoverable by complement as 114 - 54 = 60
males and 95 - 27 = 68 females, and the Results text confirms the complement ("were employed
(72% vs. 53%)", against 100 - 28.4 = 71.6 and 100 - 47.4 = 52.6). The **10-year** row does not:
its denominators of 107 and 90 exist only as 35 / 0.327 and 22 / 0.244, which is a
back-calculation from a printed percentage. The 10-year employment count is therefore
**unrecoverable**, `report_quantifiable = no`, and no result row is written.

### A2. Recovery percentages contradict the denominator the same sentence states

**Location:** Results, "Sex differences in relapses and recovery across time", p. 2.

**What the paper prints:** "Recovery information at 10-year reassessments was available for 171
patients (75 female and 96 male). Of these patients, 26 females (36.6%) and 21 males (22.3%)
showed symptomatic and functional recovery at 1-year follow-up; 36 females (50%) and 28 males
(30.8%) at 3-year follow-up; and 35 females (46.7%) and 33 males (34.4%) at 10-year follow-up."

**What the arithmetic gives:** only the 10-year figures use the stated 75 and 96 (35/75 = 46.67;
33/96 = 34.38). The 1-year figures require 71 and 94 (26/71 = 36.6; 21/94 = 22.3) and the 3-year
figures require 72 and 91 (36/72 = 50.0; 28/91 = 30.8). "Of these patients" is therefore not
true of two of the three timepoints.

Recovery is not an extracted outcome, so this is not blocking. It is recorded because it is the
same defect as A1 in a different place, and it means no unprinted denominator in this report can
be assumed.

---

## lin2022

### L1. Three of the five printed standardised mean differences do not match their own percentages

**Location:** Abstract; Results, "Non-healthcare societal outcomes", p. 4; Figure 2a, p. 6.

For two proportions the standardised mean difference is
(p1 - p2) / sqrt([p1(1-p1) + p2(1-p2)] / 2).

| Outcome | Printed | SMD recomputed from the printed percentages |
|---|---|---|
| Unemployed 69.2 vs 41.1 | 0.81 | 0.59 |
| Divorced 35.0 vs 27.7 | 0.67 | 0.16 |
| Homeless 28.2 vs 7.2 | 0.57 | 0.57 (matches) |
| Incarcerated 0.4 vs 0.1 | 0.47 | 0.06 |
| Premature death 14.2 vs 11.9 | < 0.1 | 0.07 (matches) |

The incarceration figure is the clearest: an absolute difference of three cases per thousand
cannot produce a standardised difference of 0.47.

Not blocking, because this report contributes no result. Recorded because the review will cite
these two sibling reports together, and because it bears on how much confidence the descriptive
statistics of this author group's tables can carry (compare B1 and B2).

### L2. No missing-data category, where the sibling report has one

lin2022 reports unemployment as a bare percentage (Figure 2a, 69.2 per cent) with no denominator
and no missing-data category. benson2022 uses the same Veterans Benefits Administration
employment field on the same source cohort and reports 3.3 and 3.0 per cent missing as an
explicit category, with percentages computed on the full matched cohort including the missing.
lin2022 never says whether its base includes veterans with no employment record. Not an
arithmetic contradiction inside one paper, but a contradiction between two reports of one cohort
that leaves lin2022's base undetermined. It is why `reported_percentage_base` is left blank
rather than assumed to be 102,207.

---

## basaraba2023

No internal contradiction found. Every printed percentage reproduces its own printed
positive/total pair (431/1038 = 41.5; 530/874 = 60.6; 397/555 = 71.5; 186/265 = 70.2), the
demographic counts sum to the stated total (341 + 949 + 8 = 1298), the text's stated range of
70.1 to 72.0 per cent from 6 months onward is exactly what the table shows, and 1038 is 80.0 per
cent of 1298 as the described 20 per cent holdout implies.

---

## A schema observation, not a source contradiction

`extraction_rob.csv` requires all nine JBI domains for every result. basaraba2023 contributes
eight timepoints of one construct on one arm, so it generates 72 domain rows whose judgements
differ only on `jbi5_coverage_of_sample` and `jbi9_response_rate`, which are the two that
genuinely change with the timepoint. The batch has written them all rather than omit any, since
an absent domain is indistinguishable from a favourable answer. Stage G may wish to consider
whether a result-set-level appraisal with per-result overrides would carry the same information.
