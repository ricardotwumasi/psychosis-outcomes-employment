# Batch F01: internal contradictions found

Every contradiction below is inside a single source unless marked otherwise. Where a
contradiction bears on an extracted result it is also carried in `conflict_status` and
`conflict_note` in `extraction_outcomes.csv`, because a note alone does not block a
numerically complete row from entering a pool (D12.3d).

---

## chang2016 (the only report in the batch with an employment count)

### C1. BLOCKING. The definition of "sustained employment" contradicts itself

- Methods 2.2, p. 2: "Participants were classified as achieving sustained employment if
  they maintained **full-time work/study** or part-time work for 12 consecutive months in
  the third year of follow-up."
- Table 1, footnote b, p. 3: "Sustained employment was defined as maintaining **full-time
  or part-time work** for the last 12 months of the 3-year follow-up."
- Table 2, footnote e, p. 3: "Sustained employment was defined as maintained **full-time or
  part-time employment** in the last 12 months."

The Methods put full-time study inside the numerator; both table footnotes leave it out.
The result is therefore either `paid_or_education` or `paid_any`, which sit in different
outcome families and only one of which can reach the primary pool. The report gives no way
to choose, and no count of students is printed. Both result rows are coded
`paid_or_education` (the Methods wording, which is the operational definition) and blocked
with `conflict_status = unresolved`.

### C2. BLOCKING. The schizophrenia employment denominator is not the printed one

Table 1, p. 3, heads the schizophrenia column `n = 374` and prints sustained employment as
`111 (30.0)`.

- 111/374 = **29.7%**, not 30.0%.
- No integer numerator over 374 yields 30.0%: 112/374 = 29.9%, 113/374 = 30.2%.
- 111/370 = **30.0% exactly**, and 370 is the only integer base that does so.
- The printed chi-square for this comparison, 4.6, reproduces at a base of 370
  (chi-square 4.63) and not at 374 (4.85 uncorrected, 4.14 with continuity correction).
- Every other percentage in the same column reproduces exactly on 374 (38/374 = 10.2%,
  43/374 = 11.5%, 76/374 = 20.3%, 162/374 = 43.3%), as do their chi-squares (0.1, 2.5,
  5.0 all reproduce on 374 uncorrected).

So roughly four schizophrenia patients are absent from the employment denominator and the
report never says so. This is consistent with the report's own variable-specific
missingness: the printed t-test degrees of freedom differ by variable (416, 417, 418 for a
sample of 420). `n_employed = 111` is recorded; `n_outcome_observed` is left **blank**; 370
is recorded in `reported_percentage_base` only, as the base the authors divided by rather
than as an observed denominator.

### C3. The functional-remission chi-square reconciles with no denominator at all

Table 1, p. 3: functional remission 76 (20.3) for schizophrenia versus 17 (36.9) for
psychotic mania, chi-square 6.1.

- 76/374 = 20.32%, so the printed percentage needs a base of 374.
- A chi-square of 6.1 needs a base near 365 to 366 (374 gives 6.58 uncorrected, 5.65 with
  continuity correction; 370 gives 6.35).

No single denominator satisfies both. Functional remission is a composite and is not
extracted, but this shows the test statistics in this table are not uniformly reliable, and
it is the reason JBI item 8 is judged `unclear` rather than `yes`.

### C4. Minor. Table 2 gives baseline SOFAS a negative association with employment

Table 2, p. 3: for sustained employment, baseline SOFAS B = -0.03, OR 0.97 (0.96 to 0.99),
i.e. **better** baseline functioning predicting **lower** odds of sustained employment,
while the same table gives baseline SOFAS a positive coefficient for SOFAS at 36 months
(B = 0.19). The report never narrates the direction, so it cannot be established whether
this is a sign error. It affects no extracted count. (Recorded because the sign is a
plausible typesetting error and a checker will otherwise re-derive it.)

---

## chan2020

### C5. The exclusion arithmetic does not close

- p. 492: "A total of 148 matched pairs were identified. ... After reviewing the
  longitudinal diagnoses, **six patients were excluded** from the analysis ... As a result,
  **each group consisted of 145 patients**." Six exclusions split evenly means three per
  group, which is what 148 - 3 = 145 requires.
- p. 493: "The successful interview rates for the standard care and early intervention
  groups were 70.3% (N = 104) and 74.3% (N = 110) ... After excluding patients with
  non-schizophrenia-spectrum diagnoses, there were **102** patients in the standard care
  group and **107** in the early intervention group."

110 - 107 = 3 exclusions in early intervention but 104 - 102 = **2** in standard care, so
five exclusions, not six, and the standard care group cannot be 145. chan2022 corroborates
the five: it analyses 209 patients, which is 107 + 102, while also printing the
pre-exclusion 110 and 104 (see C7). No extracted count depends on this.

---

## chan2022

### C6. The interviewed subtotals do not sum to the stated total

p. 3: "A total of 209 patients, 70.6% of the total sample (EIS: N = 110, 74.3%; SCS = 104,
70.3%), completed the follow-up interview." 110 + 104 = **214**, not 209. The 209 is the
post-diagnostic-exclusion sample (Table 1 confirms: EIS 72 + 35 = 107, SCS 81 + 21 = 102),
while 110 and 104 are the pre-exclusion interview counts, so two different stages are
labelled as one.

### C7. Clinical remission percentages are computed on undisclosed smaller bases

Table 2, p. 4, prints clinical remission as 25 (56.8) for no relapse (n = 56), 32 (61.5)
for late relapse (n = 55) and 47 (51.6) for early relapse (n = 98). Those percentages imply
bases of 44, 52 and 91 respectively, summing to 187 against the analysed 209. Missing PANSS
data would explain it, but the report does not say so. No employment count is affected;
recorded because it is the same "column heading is not the denominator" pattern as C2 and
would matter if an author supplies employment counts from this table's denominators.

---

## chan2019

### C8. The predictor tables run on three different denominators

The analysed sample is stated as 107 (p. 67). Recovering the bases from the printed n and
per cent pairs:

- Table 1 (clinical remission), p. 67: 52 remitted and 45 non-remitted, total **97**
  (26/45 = 57.8%, 11/45 = 24.4%, 5/45 = 11.1% all confirm 45).
- Table 2 (functional recovery), p. 68: 40 and 66, total **106** (36/66 = 54.5%,
  9/66 = 13.6%).
- Table 3 (complete recovery), p. 68: 27 and 73, total **100** (41/73 = 56.2%,
  10/73 = 13.7%).

The headline rates are all computed on 107 (52/107 = 48.6%, 40/107 = 37.4%,
27/107 = 25.2%), so the tables and the text use different denominators for the same sample
and the report does not reconcile them. No employment count is affected.

---

## chang2016b

### C9. Table 1 diagnosis counts do not sum to the stated N

Table 1, p. 81, functionally non-remitted column (N = 125): schizophrenia-spectrum 105
(84.0), affective psychoses 8 (6.4), other psychotic disorders 13 (10.4). The counts sum to
**126** and the percentages to 100.8%.

### C10. The schizophrenia-spectrum footnote is one patient short of the column

Footnote c, p. 81: schizophrenia 94 + schizoaffective 5 + schizophreniform 28 = **127**,
against 23 + 105 = **128** in the columns. The affective (14 + 1 = 15) and other (3 + 9 + 2
= 14) footnotes both reconcile exactly, and 127 + 15 + 14 = 156 matches the analysed sample
while 128 + 15 + 14 = 157 does not, so the extra patient is in the non-remitted
schizophrenia-spectrum cell. C9 and C10 are the same single-patient discrepancy seen twice.
No employment count is affected, because chang2016b reports none.

---

## Cross-report, not a contradiction but a reconciliation

`chan2020` and `chan2022` describe the same 148 matched pairs; `chan2019` describes the
early intervention half of them. Taken together they fix the analysed EASY sample at 107
and the standard care sample at 102, which is what resolves C5 and C6. `chang2016` and
`chang2016b` describe two further, different EASY-derived samples; see
`unresolved_queries.md` Q7 for the overlap that neither report states.
