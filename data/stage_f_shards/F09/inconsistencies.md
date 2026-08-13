# Batch F09, internal inconsistencies

Every contradiction found while reading the six reports, with what the paper prints, what the
arithmetic gives, and where. Ordered by report. Each entry states whether it touches an extracted
result, because only a contradiction *about a result* sets `conflict_status = unresolved`.

**No result in this shard carries `conflict_status = unresolved`.** Every numerator and denominator
extracted here reproduces against its own printed percentage. The contradictions below sit beside
the extracted results rather than inside them, and each says so explicitly.

---

## khare2021

### 1. The recruitment response rate contradicts itself (does not touch the result)

Two sentences in the same paragraph of Methods 2.2 Procedures, p. 473:

> "The number of outpatients informed about the study was not tracked."

> "A higher proportion of outpatients agreed to participate at Ahmednagar site (99.2%) than in
> Pune (81.4%)."

An agreement proportion needs a denominator of people asked. If the number informed was not
tracked, 99.2 per cent and 81.4 per cent cannot have been computed on it. The likeliest
reconciliation is that the percentages are of those *referred to the interviewers by the
psychiatrists*, a smaller set than those informed, but the paper does not say so.

Effect: none on 287/456. Recorded against JBI item 9, which is judged `unclear` for this reason.

### 2. Job-change reasons: one percentage does not reproduce (does not touch the result)

Results 3.2, p. 474. Of 29 who changed jobs: 12 (41.5%), 5 (17.2%), 5 (17.2%), 4 (13.8%), 3 (10.3%).
The counts sum to 29 exactly and four of the five percentages reproduce, but 12/29 = 41.4 per cent,
not 41.5. A rounding slip; the five printed percentages then sum to 100.0 rather than 99.9.

Effect: none. Different table, different question.

### 3. 119 against 118 independent employers (does not touch the result)

Table 1 (p. 475) gives "Type of employer: Independent 119" among the 257 employed at both
assessments. Results 3.2 (p. 474) says "Participants who were working for independent employers at
baseline and follow-up (n = 118; 34.7%)". These are close but not identical measures, employer type
at follow-up against employer type at both assessments, so this may not be an error at all. Recorded
because a checker will notice it.

Effect: none.

### 4. What is *not* inconsistent, checked because the triage note said VERIFY

The four-cell partition reconciles perfectly and in two independent ways:

| Cell | Count | % printed | % recomputed on 456 |
|---|---|---|---|
| Working at both assessments | 257 | 56.4 | 56.36 |
| Not working at either | 148 | 32.4 | 32.46 |
| Working at baseline, not follow-up | 21 | 4.6 | 4.61 |
| Not working at baseline, employed at follow-up | 30 | 6.6 | 6.58 |
| **Total** | **456** | **100.0** | **100.01** |

Table 1 (p. 475) reproduces the same partition split by residence: 148 = 112 + 36, 51 = 35 + 16,
257 = 125 + 132, and 272 + 184 = 456, with every one of the six percentages reproducing on its own
column denominator. The Table 1 row "working at either assessment 51" equals the text's 21 + 30.
The abstract's "over 60% employed at baseline and follow-up assessment" holds both ways
(287/456 = 62.9 per cent at follow-up, 278/456 = 61.0 at baseline), and "Among participants who were
unemployed at baseline, 16.9% started working at follow-up" holds too: 30/(148+30) = 16.85 per cent.

---

## leighton2019

### 5. The OPUS arm sizes do not sum to the OPUS sample size (does not touch the extracted result)

Methods, p. e263:

> "The OPUS trial (NCT00157313) was a randomised controlled trial of 578 patients with first-episode
> psychosis... OPUS assessed standard (n=272) versus specialised assertive intervention integrated
> treatment (n=275; January, 1998, to December, 2000)."

272 + 275 = **547**, not 578. Every OPUS denominator elsewhere in the report is 578 (338/578,
518/578, 553/578, 226/578, all with percentages that reproduce on 578), so the arm figures are the
odd ones out. 547 is the number randomised in the published OPUS trial, and 578 is the
schizophrenia-spectrum sample including F21 that `hansen2024b` uses; `hansen2024` uses 496.

Effect: none on anything in this shard, because no OPUS result is extracted from leighton2019.
Recorded because it bears on `opus_1998`, where a 496 / 547 / 578 denominator question is already
live in `hansen2024`'s existing rows.

### 6. The stated range of missing outcome data does not match Table 1 (does not touch the result)

Results, p. e265 says of the training cohort: "15-39% of patients were missing outcomes data ... at
1 year for training cohorts". Table 1 on the same page gives the complete-data counts, from which
the missing fractions are:

| Outcome | Complete | Missing of 1027 |
|---|---|---|
| Symptom remission | 673 | 34.5% |
| Social recovery | 829 | 19.3% |
| Vocational recovery | 807 | 21.4% |
| Quality of life | 729 | 29.0% |

The range is 19 to 35 per cent, not 15 to 39. The same sentence's Scottish figure, "19-61%", does
not reproduce either: on the 162 Scottish patients the missing fractions are 19.1 per cent
(remission) and 12.3 per cent (vocational), with quality of life reported on 47 of 79 rather than of
162. The OPUS figure "4-61%" does reproduce (4.3 to 60.9 per cent on 578).

Effect: none on 436/807. Both the numerator and the denominator are printed directly in Table 1 and
436/807 = 54.0 per cent matches the printed 54 per cent exactly.

### 7. What is *not* inconsistent: the Scottish figure is exactly leighton2019b's two cohorts

This is the batch's most important arithmetic and it is a match, not a contradiction. leighton2019
Table 1 (p. e265) prints, for its pooled Scottish validation sample, vocational recovery 59/142 and
symptom remission 66/131. leighton2019b Table 1 (p. 6) prints its two cohorts separately:

| | CR:ISP (n=83) | Glasgow/Edinburgh (n=79) | Sum | leighton2019 "Scottish" |
|---|---|---|---|---|
| EET / vocational recovery | 32 / 75 | 27 / 67 | **59 / 142** | 59 / 142 |
| Period remission | 33 / 67 | 33 / 64 | **66 / 131** | 66 / 131 |

Both numerators and both denominators match exactly, and leighton2019's own text corroborates the
denominators ("In the Scottish studies, 131 (81%) of 162 patients had complete symptom remission
outcome data, 142 (88%) had complete vocational recovery outcome data"). The quality-of-life row
completes the picture: leighton2019 reports it on "47 (59%) of 79", the 2006-09 cohort alone, which
is the only one of the two that used WHOQOL.

Effect: decisive. It proves leighton2019's Scottish figures are the same participants as
leighton2019b's, so they are recorded as `validation_sample` with `contributes_results = no` and no
result row is created for them from leighton2019.

---

## leighton2019b

### 8. Highest educational attainment: one category percentage rounds the wrong way (does not touch the result)

Table 1, p. 6, training cohort: College 19 (23). On the education denominator of 80 (83 less 3
missing), 19/80 = 23.75 per cent, which rounds to 24, not 23. The other four categories reproduce
(14/80 = 17.5 to 18, 17/80 = 21.25 to 21, 21/80 = 26.25 to 26, 9/80 = 11.25 to 11), and the five
counts sum to 80 exactly, so the counts are sound and the percentage is truncated rather than
rounded.

Effect: none. The extraction records counts, not the printed percentages.

### 9. No inconsistency in the extracted outcome rows

32/75 = 42.7 per cent against a printed 43, and 27/67 = 40.3 per cent against a printed 40. Both
reproduce.

---

## liangrong2021

### 10. "Eleven patients were excluded from the follow-up sample" is ambiguous (does not change the denominator)

Methods, p. 3 states that 276 patients were included, that "Regular follow-up had been completed for
170 patients, with 106 patients being excluded", and separately that "Eleven patients were excluded
from the follow-up sample due to the change in diagnosis". Read literally, the second sentence would
remove 11 from the 170 and leave 159. It does not: Table 2 (p. 4) and Table 4 (p. 6) both carry
n = 170, 276 - 106 = 170 exactly, and "the diagnoses had been modified to others" is listed as one of
the four reasons for the 106. So the 11 are inside the 106.

Effect: none. The denominator 170 is confirmed by two tables and by subtraction. Recorded because
the wording could easily be read the other way.

### 11. The title says 6-year, the data say a 5.6-year median over a 0.2 to 16.8 year range

The title is "A Naturalistic Study of 6-year Follow-Up in China". The abstract (p. 1) says "a median
follow-up period of 5.6 years", and Table 2 (p. 4) gives length of follow-up as range 0.2 to 16.8,
median 5.6, IQR 3.0 to 7.7. The title's "6-year" is a rounded median presented as though it were a
design feature. The report never states what ends an individual patient's follow-up, so the spread
is unexplained as well as large.

Effect: **this is the reason the result cannot enter a landmark horizon.** 5.6 years is 67.2 months,
which falls inside the 48 to 78 month window for the 5-year horizon, so a `since_baseline` coding
would have placed the cohort in a landmark band on the strength of a median spanning from under one
year to nearly seventeen. `followup_basis` is set to a barred value; see the result notes and
`unresolved_queries.md` for the vocabulary gap this exposes.

### 12. What is *not* inconsistent

Table 4 (p. 6) reconciles exactly: 89 + 70 = 159, 159 + 11 = 170, and 52.3, 41.2, 93.5 and 6.5 per
cent all reproduce on 170. The admission table reconciles too (126 + 34 + 7 + 2 + 1 = 170, and
34 + 7 + 2 + 1 = 44 against a printed 44 readmitted, 25.9 per cent). Table 2's categorical counts all
sum to 170. This report's arithmetic is the cleanest in the batch; its problem is entirely the
timepoint.

---

## lindgren2020

### 13. Table 1's remission row does not reproduce, while the employment row does

Table 1, p. 4, "1-year" block:

| Row | Printed | Recomputed |
|---|---|---|
| Remission | 28/53 (51.9%) | 28/53 = **52.8%**; 28/54 = 51.9% |
| **Working or studying** | **26/53 (49.1%)** | **26/53 = 49.06%, consistent** |
| Hospital treatment during follow-up | 9/54 (16.7%) | 9/54 = 16.67%, consistent |
| Using antipsychotics | 42/54 (77.8%) | 42/54 = 77.78%, consistent |

The remission row's printed percentage is the one computed on 54 while its printed fraction says 53,
so the two cannot both be right. Every other row in the block, including the employment row this
extraction uses, reproduces on its own printed denominator.

Effect: none on 26/53, which is internally consistent. Recorded because it shows the table is not
uniformly reliable, which is why JBI item 8 carries the observation even though it is judged `yes`
for this result.

### 14. The recruited cohort size is never printed (a gap, not a contradiction)

Results, p. 3: "Baseline cognitive testing data were available from 67 FEP patients and 1-year
clinical data from 54 FEP patients (Table 1), while 1-year cognitive data were available from 39
individuals." Nothing states how many were recruited to the Helsinki Early Psychosis Study, so the
54 is a data-availability subset of an unknown whole.

Effect: `n_entered` is left blank. The SAP section 6 complete-cohort worst-case and best-case bounds
cannot be computed for this cohort, and the attrition-as-moderator analysis has nothing to use.

---

## luo2019

### 15. Table 1's test statistics do not match its own means, in three rows (does not touch the result)

Table 1, p. 973, with n = 30 per group:

| Row | ACT | Control | Printed t | Comment |
|---|---|---|---|---|
| Age | 29.2 (4.3) | 30.2 (7.0) | -0.20 | a 1.0-year difference on these SDs gives t of about -0.66 |
| Years of education | 12.0 (3.5) | 11.1 (3.3) | -0.78 | ACT is *higher*, so an ACT-minus-control t should be positive, about +1.02 |
| Years duration of illness | 9.8 (3.6) | 7.5 (4.4) | -2.09 | magnitude is right, but the Results text on p. 972 gives the same comparison as **t = 2.09**, the opposite sign |

The duration-of-illness row is the clearest: the table and the text disagree on the sign of the same
statistic. None of the three affects a count.

Effect: none on 10/30 or 1/28. Recorded because it bears on the randomisation appraisal, where the
one imbalance the paper itself reports is the row whose statistic is inconsistently signed.

### 16. Marriage percentage truncated (does not touch the result)

Table 1, p. 973: ACT group Divorced 2 (6.6). 2/30 = 6.67 per cent, so 6.7. The counts sum to 30
correctly (27 + 1 + 2).

Effect: none.

### 17. What is *not* inconsistent, checked because of the near-zero cell

10/30 = 33.3 per cent and 1/28 = 3.57 per cent, matching the printed 33.3 and 3.6 exactly. The
control-arm accounting reconciles: "Of the 30 controls, 26 completed the study, one could not be
located after the baseline assessment, one moved out of the district after the baseline assessment,
and two could not be contacted after the 9-month assessment", so 26 + 1 + 1 + 2 = 30 and the modified
intention-to-treat denominator is 26 + 2 = 28. The readmission figures use the same denominators and
reconcile identically (1/30 = 3.3 per cent, 7/28 = 25.0 per cent). The competitive and transitional
sub-counts sum to the arm total: 4 + 6 = 10.

**One real limitation inside that reconciliation, recorded rather than treated as a contradiction:**
2 of the 28 controls were followed only to month 9 and their 12-month data are "regarded as
missing", yet they remain in the denominator of 28. For a cumulative *any time during follow-up*
outcome, those 2 contribute 9 months of exposure to a 12-month risk window. With a control numerator
of 1, this is not a rounding matter, and it is carried in the RoB 2 missing-data domain.
