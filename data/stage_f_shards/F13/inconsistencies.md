# Batch F13 internal inconsistencies

Every internal contradiction found while extracting the five F13 reports, with what the
paper prints, what the arithmetic gives, and where. Contradictions that bear on an
extracted result carry a decision on `conflict_status`; those that do not are recorded
anyway, because a checker needs to know they were seen and judged rather than missed.

Batch: F13. Extractor: claude-opus-5. Date: 12 August 2026.

Two kinds of evidence are distinguished throughout, because they warrant different
actions. A contradiction between two **printed counts** of the same quantity, or between
printed counts and set arithmetic, blocks the result. A contradiction between a printed
count and an **inferential statistic** whose test is not fully specified is recorded and
appraised in risk of bias, but does not block the count.

---

## tsiachristas2016

### TS1. The stated outcome definition and the printed analysis population cannot both be right. BLOCKS both results

| Where | What it says |
|---|---|
| Methods, p. 3 | "becoming employed (ie, proportion of those unemployed at start of follow-up who became employed during follow-up)" |
| Methods, p. 3 | "resuming studying (ie, proportion of those not in education at start that were in education during follow-up)" |
| Table 5, p. 7 | "Becoming employed (n=1801)" |
| Table 5, p. 7 | "Resuming studying (n=1664)" |
| Table 1, p. 3 | Employment status missing for 48.62% of the 831 EIP and 50.98% of the 2843 non-EIP patients; employed 12.24% and 11.95%; students 9.96% and 6.08% |

Table 1's percentages are of the whole arm (the categories printed sum to less than 100
because the unemployed residual is not printed). They give, approximately:

- with any baseline employment record: about 427 of 831 EIP plus about 1,394 of 2,843
  non-EIP, so about **1,820** of 3,674;
- of those, employed at baseline about 442, students about 256, so **not employed and
  observed** is about **1,120**, or about **1,380** if students are counted as unemployed;
- **not in education and observed** is about **1,565**.

A complete-case analysis restricted to the baseline-unemployed cannot have n = 1,801, and
one restricted to those not in education cannot have n = 1,664. Both printed n values are
just below the roughly 1,820 with any baseline record, which is what one would expect if
the models were fitted to everyone with an observed change in status.

**Decision: `conflict_status = unresolved` on both rows.** The candidate resolution (the
models were fitted on all patients with two observations, not on the restricted
denominator the Methods describe) is recorded in `conflict_note` and in
`unresolved_queries.md` Q2, and is **not applied**: rule 14 requires an authority, and the
arithmetic above is approximate because only percentages are printed. Neither row carries
a count in any case, so nothing numerical is lost by blocking them; what is gained is that
the review does not describe the analysed population wrongly.

### TS2. The complete-case and imputed estimates differ materially. Does not block: both are printed and labelled

Probability ratio for becoming employed is 2.164 after multiple imputation (Table 3, p. 5)
and 1.989 on complete cases (Table 5, p. 7), on an outcome missing for about half the
sample. This is not a contradiction; it is recorded because it is the size of the
imputation's influence, and it is judged in `robinsi_5_missing_data`.

---

## turner2019

The most internally contradictory report in the batch. Four separate failures, three of
which block results.

### T1. The number of unoccupied participants who attained a productive role. BLOCKS two results

| Where | Figure |
|---|---|
| Abstract, p. 114 | "At follow-up, 50 per cent (n = 10) of unoccupied participants had attained a productive role" |
| Results, p. 119 | "eight participants (24 per cent) had attained a positive productive role by T2" |

The Results section is internally coherent and the Abstract is not consistent with it:

```
17 retained a role  +  8 attained  +  8 never had one  +  1 lost one   = 34 followed up
17 + 8 = 25                                        -> "25 out of 34 participants (74 per cent)"
8 of the 16 unoccupied at T1                       -> exactly the 50 per cent the Abstract prints
```

If 10 had attained a role the T2 total would be 27 of 34, not the printed 25 of 34; and
10 of the 21 unoccupied at baseline is 47.6 per cent, not 50.

**Decision: `conflict_status = unresolved` on `turner2019_unoccupied_t1_t18m_paidoredu_attained`
and on `turner2019_cohort_t18m_paidoredu_status`,** because the 25 is built from the
disputed 8. Candidate resolution, recorded and not applied: the Results value of 8 of 16 is
correct and the Abstract's n = 10 is an error.

### T2. The participation counts violate inclusion-exclusion. BLOCKS three results

Results, p. 119, in four consecutive sentences:

| Quantity | Printed |
|---|---|
| At least one month of paid employment **or** education | 27 (79%) |
| At least one month in paid employment | 21 (62%) |
| At least one month in formal education | 9 (27%) |
| Both paid employment and formal education | 4 (12%) |

21 + 9 - 4 = **26**, against a printed **27**. Every percentage divides by 34 exactly
(27/34 = 79.4, 21/34 = 61.8, 9/34 = 26.5, 4/34 = 11.8), so the denominator is not the
discrepancy: one of the four counts is wrong and the report does not say which.

**Decision: `conflict_status = unresolved` on all three participation rows.** All four
numbers are implicated and no rule identifies the faulty one. Candidate resolution,
recorded and not applied: "both" = 3 reconciles all four figures.

### T3. The sample size is 38 in two places and 39 in three. Recorded on every row; `n_entered` left blank

| Where | Figure |
|---|---|
| Abstract, p. 114 | "In total, 39 (20 men, 19 women) consented" |
| Results, p. 117 | "The final sample consisted of 20 men and 19 women" (= 39) |
| Results, p. 118 | "21 participants used IPS alone; nine participants used the WFM programme alone and nine participants used both interventions" (= 39) |
| Results, p. 119 | "In total, 34 of 38 (87 per cent) were followed up" |
| Discussion, p. 120 | "The sample size of 38 participants would be considered small" |

34/39 = 87.2 per cent, which is the printed 87; 34/38 = 89.5 per cent, which is not.
Three independent corroborations point to 39. `n_entered` is nevertheless left **blank** on
the whole-cohort rows rather than asserting a value, and the discrepancy is carried in
`conflict_note`. It does not affect the analysed denominator of 34, which is printed
consistently.

### T4. The IPS engagement total does not equal its own components. Does not block: no result rests on it

Results, p. 118: "129 people were offered the interventions - 12 people were offered both;
72 were offered IPS alone (total offered IPS = 86); 45 people were invited to WFM alone
(total offered WFM = 57)".

72 + 12 = **84**, not 86; Table I's IPS columns (36 declined, 48 attended) also sum to 84.
The WFM arithmetic is right (45 + 12 = 57, and Table II gives 34 + 23 = 57), and the three
mutually exclusive groups sum correctly to 129. So 86 is the outlier. No extracted result
uses it; it is recorded because it is a fourth arithmetic failure in one short paper and it
informs `jbi8_statistical_analysis`.

---

## xu2020

### X1. Person-years do not match the mean follow-up. Does not block: person-years is not an extracted field

Results, p. 3 of 9: "Subjects were on average followed up for 10.4 +/- 0.3 years, with a
total of 686.8 person-years of follow up."

65 subjects at 10.4 years is **676** person-years, and 686.8 implies a mean of 10.57 years.
Three of the 65 had died before follow-up, which would reduce person-years rather than
increase them. The discrepancy is small and unexplained.

It is recorded because the mean follow-up is the field this batch's most consequential
coding decision rests on (`followup_basis = since_baseline`, `followup_months = 125`). At
10.57 years the result is 127 months rather than 125, which is in the same horizon band, so
nothing changes; but a checker asking why 125 was chosen should see that the two printed
figures disagree by about two months.

### X2. Denominators shift silently between sections. Recorded, does not block

The social-outcome counts sit on 62 (the 65 interviewed minus 3 deceased), diagnostic
stability on 55, readmissions on 59, depression on 62, WHODAS on 57, and baseline
characteristics on 118 and 65. None of these denominators is stated explicitly beside its
percentage; each has to be recovered from the arithmetic. For the employment result the
recovery is exact and unambiguous (34 + 23 + 5 = 62), which is why 62 is recorded as
`n_outcome_observed` rather than as a reporting base. The general practice is judged in
`jbi8_statistical_analysis`.

---

## yamaguchi2020

### Y1. No internal contradiction found

Every printed percentage in Table 2 reproduces exactly on the group denominators of 29 and
22, the group sizes sum to the stated 51, and the fidelity-group programme counts sum to
the stated 13. The gap between the 93 who met the inclusion criteria and the 51 analysed is
**unexplained**, not contradictory: the flow diagram that would explain it is in an online
supplement not held in this repository. That is recorded as incomplete reporting
(`analysis_selection_status = unclear`, `jbi2_participant_sampling = unclear`,
`jbi9_response_rate = no`) and as `unresolved_queries.md` Q9, not as a conflict.

---

## zhang2017

### Z1. A reported p value is not reproducible from the printed counts. Does NOT block the counts

Results, Employment Rates, p. 7106165020p5: "The employment rate of the ISE group was
significantly higher than that of the TVR group (p = .002), and significantly more
participants in the ISE group were employed than in the IPS group (p = .002)."

| Comparison | Counts | Two-sided chi-square on those counts |
|---|---|---|
| ISE v TVR | 34/54 against 18/54 | p ~ 0.002, which **reproduces** the printed value |
| ISE v IPS | 34/54 against 27/54 | p ~ 0.17, which does **not** reproduce the printed .002 |

The two comparisons are given the same p value although their effect sizes differ by a
factor of more than two.

**Decision: `conflict_status = none` on all three arm rows.** This is deliberately treated
differently from turner2019's contradictions. The counts themselves are printed identically
in the Abstract and the Results and are consistent with their percentages; what fails to
reproduce is an inferential statistic whose test is not fully specified ("We used x2 to
analyze the employment rates of the three groups at different intervals ... In all post hoc
comparisons, an a value of .05 with Bonferroni adjustment was used"), and a post-hoc
comparison drawn from a repeated-measures model over the 7-, 11- and 15-month assessments
would not equal a 2x2 chi-square on the final counts. Blocking a printed, doubly
corroborated count on a recomputation that assumes a test the authors may not have used
would be resolving by inference in the opposite direction. It is judged instead in
`rob2_5_selective_reporting`, which is `high`, and raised as `unresolved_queries.md` Q11.

### Z2. The text contradicts Table 2 on the direction of the BPRS result. Does not block: not an employment outcome

Results, Assessment Scores, p. 7106165020p5: "The ISE group had significantly higher scores
on the BPRS, the GAF, and the PWI, but not the CGSS, than the IPS and TVR groups."

Table 2 gives BPRS at 15 months as ISE 23.11, IPS 23.46, TVR 23.87, so the ISE group scores
**lowest**, at every follow-up. On the Brief Psychiatric Rating Scale a lower score means
fewer symptoms, so the Discussion's interpretation (ISE improved symptoms) matches the table
and the Results sentence does not. Recorded because it bears on the reliability of the
report's own descriptions of its tables, which is part of the `rob2_5_selective_reporting`
judgement.

### Z3. Convenience sampling alongside concealed randomisation. Not a contradiction, recorded to prevent one being read in

"The participants were recruited by convenience sampling" (Discussion, limitations,
p. 7106165020p6) concerns how the 162 were recruited into the trial; "assigned to the ISE,
IPS, or TVR condition using the concealed randomization feature in IBM SPSS Statistics"
(Method, p. 7106165020p2) concerns allocation after recruitment. The two are compatible and
are recorded in different fields: recruitment in the cohort's selection classification,
allocation in `rob2_1_randomisation`.

---

## Summary of blocking decisions

| Result | `conflict_status` | Why |
|---|---|---|
| `tsiachristas2016_eip_t36m_unclearemp` | unresolved | TS1 |
| `tsiachristas2016_eip_t36m_eduonly` | unresolved | TS1 |
| `turner2019_cohort_t18m_paidoredu_status` | unresolved | T1 |
| `turner2019_cohort_t18m_paidthresh_participation` | unresolved | T2 |
| `turner2019_cohort_t18m_eduonly_participation` | unresolved | T2 |
| `turner2019_cohort_t18m_paidoredu_participation` | unresolved | T2 |
| `turner2019_unoccupied_t1_t18m_paidoredu_attained` | unresolved | T1 |
| `xu2020_cohort_t125m_*` (3 rows) | none | X1 and X2 do not bear on the employment counts |
| `yamaguchi2020_*` (2 rows) | none | No contradiction found |
| `zhang2017_*` (3 rows) | none | Z1 concerns a p value, not the counts |

Seven of the fifteen F13 results are blocked from every synthesis.
