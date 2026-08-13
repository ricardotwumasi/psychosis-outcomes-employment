# Batch F07 — internal contradictions found in the sources

Every contradiction below is recorded against its report, with what the paper prints, what
the arithmetic gives, and where to look. Where the contradiction affects a result, that
result carries `conflict_status = unresolved` in `extraction_outcomes.csv` and is blocked
from every synthesis (D12.3d). Candidate resolutions are recorded as candidates only:
under prompt rule 14 my own reconstruction is not an authority, however convincing the
arithmetic.

---

## drake2015 — every cell of the competitive-employment row disagrees with its column N

**Blocks:** all seven `drake2015_szsud_t*_paidcomp` results.

Table 3, "Functional status", row "Competitive job past y (yes)", p. 207. The column
headings state one N per year. The row prints a count and a percentage per year:

| Column | Printed N | Printed count | Printed % | count/N | Denominator implied by the printed % |
|---|---|---|---|---|---|
| Baseline | 150 | 20 | 14% | 13.3% | ~143 |
| 1 Year | 133 | 23 | 16% | 17.3% | ~144 |
| 2 Year | 129 | 17 | 12% | 13.2% | ~142 |
| 3 Year | 131 | 22 | 16% | 16.8% | ~138 |
| 4 Year | 72 | 15 | 16% | 20.8% | ~94 |
| 5 Year | 70 | 20 | 23% | 28.6% | ~87 |
| 6 Year | 85 | 20 | 20% | 23.5% | ~100 |
| 7 Year | 90 | 27 | 28% | 30.0% | ~96 |

No cell reconciles. At years 4 to 7 the denominator implied by the printed percentage
**exceeds** the number said to have been interviewed that year, which cannot be true of a
proportion of interviewed participants. The printed percentages are the figures the paper
itself quotes elsewhere ("competitive employment (14%–28%)", Abstract p. 202 and
Discussion p. 206), so they are not typographical slips in the table alone.

The same pattern affects other rows of Table 3 (for example ">80% Days independent living
past y": 47 of 72 is 65%, printed 48%), so the cause is probably variable-specific
denominators that are never printed. That is a reconstruction, not a resolution.

**Consequence.** The denominator is unrecoverable. `n_employed` is recorded, `n_assessed`
holds the printed column N, and `n_outcome_observed` and `reported_percentage_base` are
blank. The triage note's "27/90 at 7y" is not what the paper reports.

## drake2015 — the ascertainment window is 6 months in the Methods and a year in the table

**Blocks:** the same seven results (recorded in the same `conflict_note`).

- Measures, Recovery Score, p. 204: "competitive employment: worked in an integrated work
  setting that paid at least minimum wage and was contracted to the individual directly
  rather than to a program or mental health agency, **for at least 1 day in the past 6
  months**".
- Table 3, p. 207, row label: "Competitive job **past y** (yes)".

Table 3 distinguishes the two labels deliberately elsewhere ("Full remission in past 6
mo", "Abstinence past 6 mo" against "Hospital stay past y", "Homeless past y"), so the
"past y" label is unlikely to be shorthand for six months. Six-month and twelve-month
period prevalences are different estimands. `ascertainment_window_months = 12` is recorded
from the table the count comes from, and this contradiction is flagged on the row.

---

## domenicano2025 — the 24-month denominator has three incompatible values

**Blocks:** `domenicano2025_cohort_t24m_unclear` and `domenicano2025_cohort_t24m_eet`.

- Results 3.2, p. 4: "A total of 139 (102 M, 79.1%) and **104 individuals (78 M, 76.5%)**
  were eligible, respectively for the 12 and 24 month follow up".
- Figure 1, p. 4, final box: "**101 patients (76M, 25F)** eligible for 2-year follow-up
  analysis".
- Table 2, p. 7: 24-month columns headed "Total N = 101, Male N = 76 (75.2%), Female
  N = 25 (24.7%)".
- Figure 1's own arithmetic: 139 (102M, 37F) minus discharged 23 (15M, 8F) minus dropped
  out 14 (11M, 3F) = **102 (76M, 26F)**.

The 12-month figures agree exactly across all three places (139; 102M; 37F), so 104 is not
a different quantity such as "eligible" against "assessed". Every percentage in Table 2's
24-month columns is computed on 101 (47/101 = 46.5%, 33/76 = 43.4%, 14/25 = 56.0%), so 101
is the base the authors used.

**Candidate resolution, not applied:** 102 is arithmetically required by Figure 1's own
subtractions, so 101 and 104 would both be errors and the female count would be 26.

## domenicano2025 — the 12-month male NEET cell is impossible

**Blocks:** `domenicano2025_cohort_t12m_eet`.

Table 2, p. 7, 12-month columns, row "NEET (yes)": Total **35 (25.2)**, Male **50 (24.5)**,
Female **10 (27.0)**.

- 50 + 10 = 60 against a printed total of 35.
- 24.5% of the male N of 102 is 25.0, and the total 35 minus the female 10 is also 25.

**Candidate resolution, not applied:** 50 is a typesetting error for 25, which is required
independently by the total and by the cell's own percentage. The 35 is the numerator of the
derived EET count, so the row is blocked until an author confirms.

## domenicano2025 — the number screened is 219 in the text and 232 in the figure

Does not block a result, but it is a discrepancy in the flow.

- Results 3.1, p. 3: "a total of **219 patients** were admitted to the FEP program in
  Ferrara, but only 174 met the study criteria".
- Figure 1, p. 4: "**232 eligible patients**", minus no psychosis diagnosis 29, CHR 11,
  age range 18 (58 in total) = 174.

232 − 58 = 174 reconciles; 219 − 58 = 161 does not.

## domenicano2025 — the employment categories do not sum to their own N

Does not block a result on its own, but it means the completeness of employment
ascertainment is unestablished.

| Timepoint | Student | Employed | NEET | Sum | Stated N |
|---|---|---|---|---|---|
| Admission (Table 1, p. 5) | 55 | 63 | 59 | 177 | 174 |
| 12 months (Table 2, p. 7) | 25 | 49 | 35 | 109 | 139 |
| 24 months (Table 2, p. 7) | 16 | 47 | 22 | 85 | 101 |

At admission the categories overlap by 3; at follow-up 30 and 16 participants are in none
of the three. Since NEET is by definition the complement of education, employment and
training, the only coherent readings are that the missing people were in *training* (which
the tables never report) or that employment status was not recorded for them. The report
does not say which. See `unresolved_queries.md`.

## domenicano2025 — recruitment end date

Abstract, p. 1: "admitted to the EIS in Ferrara between 2012 and **February 27th, 2025**".
Methods 2.2, p. 3: "consecutively admitted to the FEP program in Ferrara from 2012 to
**February 17th, 2025**". Immaterial to any result; recorded for completeness.

---

## cook2016 — no internal contradiction found

Table 2 (p. 1010) reconciles throughout: 148/449 = 32.9%, 83/234 = 35.5%, 65/215 = 30.2%,
and 83 + 65 = 148. The NSTW row reconciles likewise (35 + 24 = 59; 59/449 = 13.1%). The
limits on this report are missing counts for the 24-month comparisons and a calendar rather
than elapsed follow-up basis, neither of which is a contradiction.

## detore2019 — no internal contradiction found

51/68 = 75.0% matches the printed 75%, which is the only extracted result, and Table 3's
group sizes (33 disclosed, 18 not) sum to 51, as do Table 4's job-type counts (18 + 12 + 3
= 33; 13 + 1 + 4 = 18). Three defects elsewhere in the report do not touch the extracted
result but are recorded:

- Table 4, p. 315, "Job preference": the Match and No-match counts sum to 31 and 17, not to
  the 33 and 18 stated in the column headings, and the printed percentages confirm those
  smaller bases (24/31 = 77.42%, 7/17 = 41.18%). Two participants per group are unaccounted
  for.
- Results 3.3, p. 314 misreads that same block: "participants who disclosed were more
  likely to obtain jobs that matched their preferred type of work (77.4%) than those who
  did not disclose (22.6%)". 22.6% is the disclosed group's *no-match* percentage; the
  non-disclosing group's match rate is 41.2%.
- Table 4, p. 315 gives the job-tenure comparison as t = 14.64, df = 48.36, p = .010, which
  no t distribution admits and which the printed means and standard deviations (32.55, SD
  35.81 against 12.50, SD 17.30) do not produce; t is about 2.6.

## falk2016 — no internal contradiction found

The age-standardised rates, their confidence intervals and the baseline characteristics are
mutually consistent, and the education percentages reconcile on the number with education
recorded (men 84/400 = 21.0%, women 95/322 = 29.5%). The obstacle here is that the reported
quantity is a standardised rate, not that the report disagrees with itself.

## fulford2018 — no internal contradiction, but the percentages are not proportions

Table 1, p. 371 prints "SURF work or school baseline 39.8%". With the baseline N of 404
given in the footnote, 39.8% is not n/404 for any integer n (160/404 = 39.6%, 161/404 =
39.85%). This is not a contradiction so much as evidence that the printed value is the mean
of a composite aggregated across 6-month blocks rather than a proportion of participants,
which is exactly why no count may be back-calculated from it.
