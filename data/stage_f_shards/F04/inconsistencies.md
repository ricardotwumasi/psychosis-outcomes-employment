# Batch F04: internal contradictions found in the sources

Every entry gives the report, what the paper prints, what the arithmetic gives, and where.
Entries marked **RECONCILED** are apparent contradictions that resolve on reading; they are
recorded so that a checker does not have to rediscover them. Entries marked **BLOCKING**
would set `conflict_status = unresolved`. **No result in this batch is blocked.**

---

## clarke2023

### 1. Table 1 baseline column uses two different percentage bases, neither of which is its own heading

**Location:** Table 1 "Participant demographics, clinical characteristics, and QoL", baseline
column, p. 773.

The column is headed **N = 145**, and its counts sum to 145 (24 + 121 in paid work / not in
paid work; 101 + 44 male / female; the eight diagnostic categories sum to 145). But:

| Printed | Count | On 145 | On 146 |
|---|---|---|---|
| Currently in paid work, 16.44% | 24 | 16.55% | **16.44%** |
| Not currently in paid work, 82.88% | 121 | 83.45% | **82.88%** |
| Male, 69.18% | 101 | 69.66% | **69.18%** |
| Female, 30.34% | 44 | **30.34%** | 30.14% |

So three entries are computed on 146, the number randomised in the parent trial, and one on
145, the number analysed here after "We excluded a further participant from our analysis due
to missing QoL data" (Results, p. 772). The two employment percentages sum to 99.32%, not 100%.

**Effect on this extraction:** none on the result, which comes from the **follow-up** column.
It does determine which denominator was used for the baseline-employment moderator:
`n_employed_baseline = 24` is recorded on a denominator of **146**, because that is the base
its printed percentage reproduces and because killackey2019 Table 1 (p. 78) prints the same 24
as 16.4% of 146.

### 2. Two arithmetically impossible entries in the same table

- "Bipolar disorder 20 (13.87)" reproduces on neither base: 20/145 = 13.79%, 20/146 = 13.70%.
- "Brief psychotic disorder 1 (.07)" should be 0.69% on 145 (or 0.68% on 146). A decimal place
  is lost.

Neither touches the employment result.

### 3. RECONCILED: the follow-up column is internally consistent

37 + 63 = 100 with both percentages exact (37.00, 63.00), and the three quality-of-life
clusters in Table 4 (p. 775) give 13 of 31 + 18 of 48 + 6 of 21 = **37 of 100**, each cluster
percentage reproducing exactly. The result 37/100 is corroborated twice within the report.

---

## killackey2019

### 4. Abstract prints 48.0% where the Results print 48% for 29/60 (= 48.3%)

**Location:** Abstract, p. 76 ("the TAU group (48.0%)"); Results, Primary outcome, p. 78
("48%, 29/60").

29/60 = 48.33%. The abstract's "48.0%" is the Results' unrounded "48%" carried into a
one-decimal format, not a different number. The IPS figure is exact in both places
(47/66 = 71.21%, printed 71.2%).

**Not blocking:** the numerator and denominator are printed explicitly and are not in dispute.
`conflict_status` stays `none`.

### 5. RECONCILED: 100 (clarke2023) versus 102 (killackey2019) with 18-month data

killackey2019 reports 18-month missingness of 23.3% (n = 17) in IPS and 37.0% (n = 27) in TAU,
implying 56 + 46 = **102** participants with 18-month data (p. 78). clarke2023 analyses **100**
(p. 772). The difference is explained by clarke2023's own two additional requirements: one
participant excluded for missing quality-of-life data at baseline, and complete 18-month
WHOQoL-BREF data required for the clustering. clarke2023's own Table 4 gives 54 vocational-arm
and 46 TAU participants, and the TAU figure matches killackey2019's 46 exactly.

---

## harrow2017

### 6. RECONCILED: "22 not on antipsychotics" at 20 years versus Table 1's 14

**Location:** Results 3.2, p. 270 ("16 of the 22 schizophrenia patients not on
antipsychotics"); Table 1, p. 268 (20-year row: Antipsychotics In Treatment 62% (36),
No Mental Health Treatment 14% (8), No Antipsychotics 24% (14)).

The three Table 1 categories partition the patients assessed at each wave: at 20 years
36 + 8 + 14 = **58**, and each printed percentage reproduces on 58 (62.1%, 13.8%, 24.1%).
The 22 of Results 3.2 is therefore 8 + 14: everyone not prescribed antipsychotics, whether or
not they were in mental health treatment at all. 36 + 22 = 58, which matches "From among the
70 patients with schizophrenia, 58 were followed up at the 20-year period" (p. 268).
No contradiction. The same partition reproduces at every one of the six waves (denominators
57, 65, 64, 61, 58, 58), none of which the table states.

### 7. Table 1 never states its denominators, and they change at every wave

**Location:** Table 1, p. 268. Recovered denominators are 57, 65, 64, 61, 58 and 58 for the
2, 4.5, 7.5, 10, 15 and 20-year waves. The table is headed only "Percent of schizophrenia
patients on antipsychotic medications and percent not in treatment", and the reader is left to
infer that the base is those assessed at each wave rather than the 70 recruited. It is a
reporting-base problem, not an arithmetic contradiction, and it does not affect the extracted
20-year counts, whose denominators are stated explicitly in the text.

### 8. Abstract says six follow-ups; the Method says five or six

**Location:** Abstract, p. 267 ("followed up 6 times over 20 years"); Method, p. 268
("followed up on 5 or 6 subsequent occasions over a 20 year period", and of the 70
schizophrenia patients, 30 assessed at all six, 32 at five, 2 at four and 6 at fewer than
four). The abstract overstates completeness. No numerical result depends on it.

---

## jones2024

### 9. Table 1 race counts sum to 255 against N = 256, and LC1's race row is one short of its own class size

**Location:** Table 1, p. 2448; Results, Sample, p. 2447.

LC1 is headed n = 105 and its race row reads "104/0". Across the three classes the race counts
give 183 White and 72 Black = 255. The text states "the majority of the sample was White
(71.5%, 183/256)", so the White count is consistent with 256 and the Black count is one short.
Other rows of the same table are also short of their class sizes without any missing-data
footnote: premorbid work sums to 92, 67 and 70 against 105, 73 and 78; premorbid social sums to
90, 64 and 68. The degrees of freedom betray the same thing (parental social class F(2, 223)
implies 226 with data; years of education F(2, 245) implies 248). Missing data are present
throughout and are never quantified.

**Effect on this extraction:** none. jones2024 contributes no result, because it reports no
employment count at any timepoint.

---

## khare2022 and khare2022b (same cohort)

### 10. The proportion with a schizophrenia-spectrum diagnosis is given three ways

| Report | Printed | Denominator |
|---|---|---|
| khare2022b, Abstract, p. 237 | 90% schizophrenia-schizoaffective | 150 |
| khare2022, Abstract, p. 1 | 92% schizophrenia | 150 |
| khare2022, Method 2.1, p. 2 | 91.7% schizophrenia-schizoaffective | 133 (the MoCA subsample) |

122 of 133 = 91.7% exactly (schizophrenia 114 + schizoaffective 8, khare2022 Table 2 footnote,
p. 4), so the third figure is checkable. The 90% and 92% figures for the same 150 people are
not reconcilable with each other, and neither is broken down. `perc_qualifying_diagnosis` is
recorded as **90**, the figure given by the report that supplies the extracted result. The
difference is immaterial to the 50% population threshold but is recorded because the field
feeds the diagnosis gate.

### 11. khare2022's abstract attaches a follow-up rate to the wrong denominator

**Location:** khare2022, Introduction, p. 2: "approximately 90% of the 150 participants either
employed (40% at baseline, 49.5% at follow-up) or unemployed at both assessments."

The 49.5% is khare2022b's follow-up rate, which is computed on the **107** who completed the
follow-up, not on the 150 (khare2022b, Results, p. 239: 53 of 107 = 49.53%). Read literally,
the sentence invites 49.5% x 150 = 74, a number that exists nowhere. The 40% baseline figure
is on 150; khare2022b's own baseline figure for the same cohort is 43.9%, on the 107.

**Effect on this extraction:** this is exactly the trap the manifest flagged. The extracted
count is **not** taken from any percentage: it is the sum of two printed integer cells,
45 + 8 = 53, on the printed denominator of 107, and the derived value is then checked against
the printed 49.5%.

### 12. RECONCILED: three different baseline employment rates for one cohort

40% of 150 (khare2022b, Introduction, p. 238, citing the baseline report), 43.9% of the 107
follow-up completers (khare2022b, Results, p. 239), and 50 of 133 = 37.6% in khare2022's MoCA
subsample (Table 4, p. 4: 21 of 66 younger and 29 of 67 older). These are three different
subsamples of one cohort, not three estimates of one quantity. None is labelled as such in
either report.

### 13. RECONCILED: khare2022's follow-up subsample of 94

Table 5 (p. 5) reports 51 younger and 43 older participants with follow-up work status = 94,
which is 73 who repeated the MoCA plus the 21 "interviewed over the phone [who] provided
employment data but could not be evaluated with the MoCA" (Method 2.1, p. 2). Internally
consistent; a different denominator from khare2022b's 107 because 133 rather than 150 entered
this report.
