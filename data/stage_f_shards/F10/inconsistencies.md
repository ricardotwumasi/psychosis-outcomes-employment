# Batch F10 — internal contradictions found in the source reports

Every entry gives the report, what the paper prints, what the arithmetic gives, and the exact
location. Entries marked **BLOCKING** carry `conflict_status = unresolved` on the affected result
rows under D12.3d, which bars those results from every synthesis until an author reply resolves
them. Entries not marked blocking are recorded because they bear on risk of bias or on the
trustworthiness of the numbers around them, but they do not themselves contradict an extracted
result.

Nothing below has been resolved. Under `extraction_v3` rule 14 and D12.3d, a resolution needs an
authority — an author reply or an authorship-group ruling — and this extractor's arithmetic is not
one. Candidate resolutions are recorded in `conflict_note` and in `unresolved_queries.md`.

---

## 1. maguire2021 — the migrant work-or-study rate is printed twice, differently **BLOCKING**

| Source | Value |
|---|---|
| Table 3, p. 1394 | `Employed or studying at discharge — Migrants: 137, 46.8%` |
| Results, Functioning, p. 1395 | "At the time of discharge, **47.3%** of migrants were either working or studying compared to 50.6% of Australian-born young people" |

137 / 293 = 46.76 per cent, which rounds to Table 3's 46.8 and not to 47.3. For 47.3 per cent the
numerator would have to be 138.6 people. The Australian-born figure agrees exactly between the two
places (457 / 903 = 50.61 per cent, printed as 50.6 in both), so this is not a systematic difference
between what the table and the text report.

Affects `maguire2021_migrants_discharge_paidoreduc` and, through it, the derived whole-cohort row
`maguire2021_cohort_discharge_paidoreduc` (594 / 1196).

## 2. maguire2021 — Table 1's employment block does not sum to the cohort (not blocking)

The Employment rows of Table 1 (p. 1392) print Home duties 10, Unemployed 507, Employed 187, Student
442, Student not attending school (cell garbled, see below). Those counts sum to 1183, not the 1196
with complete data. Every printed percentage in the block is consistent with a denominator of 1183
(507/1183 = 42.9, 187/1183 = 15.8, 442/1183 = 37.4, 10/1183 = 0.8, 37/1183 = 3.1), so 13 people
appear to have no recorded baseline employment status, which the text does not mention.

Consequence for the extraction: `perc_employed_baseline` is typed as the printed 15.8 and
`n_employed_baseline_denominator` is left **blank**, because establishing 1183 requires
reconstruction from percentages, which codebook rule 2 forbids.

## 3. maguire2021 — typographical corruption in Table 1 (not blocking)

Four cells of Table 1 (p. 1392) are printed with the count and the percentage transposed or run
together, which is why no count from these rows is used without a cross-check:

- `Male 58.5 (700)` for the total cohort but `Male 56.7 ((512)` for the Australian-born;
- `Separated ... 0.4 (0.4)` for the Australian-born, where a count is expected;
- `De facto husband or wife 12.1 (145)` total but `18.9 (18.8)` for migrants;
- `Home duties 0/8 (10)`, where `0/8` is a corrupted `0.8`;
- `Student not attending school 3.1 (37.4)`, where the count 37 and the percentage 3.1 have been
  merged.

## 4. maguire2021 — abstract and text disagree on the proportion male (not blocking)

Abstract, p. 1389: "Of these, 58.1% were male." Results, p. 1392: "There was a larger proportion of
male (58.5%) than female (41.5%)". Table 1 gives 700 male of 1196, which is 58.53 per cent. The
abstract's 58.1 per cent corresponds to a denominator of about 1205.

## 5. martini2017 — three incompatible denominators for the same 19 people **BLOCKING**

| Source | Statement | Implied denominator |
|---|---|---|
| Materials and methods, Statistical analysis, p. 37 | "those who obtained any kind of paid work ... (EG), n=19, and those who did not (UG), n=26" | 45 |
| Materials and methods, Study design, p. 37 | "Of the 53 participants, 45 were followed up for 18 months" | 45 |
| Results, Sociodemographic data, p. 38 | "A total of 45 patients completed the study; of those, 19 (**35.8%**) acquired a job" | 53 (19/53 = 35.85%) |
| Discussion, p. 39 | "35.8% of all individuals gaining some work experience" | 53 |
| Results, Job acquisition analysis, p. 38 | "Three individuals remained employed for less than 6 months (**6.8%**); six (**13.6%**) ... and 10 (**22.7%**) for more than 12 months" | **44** (3/44 = 6.82, 6/44 = 13.64, 10/44 = 22.73) |

19 / 45 = 42.2 per cent, which is printed nowhere. The third base of 44 is the finding that the
triage note did not have: it shows the reporting is not internally consistent at all, rather than
having one identifiable slip. The duration bands themselves sum to 19 (3 + 6 + 10), matching the EG
size, so it is the denominator and not the numerator that moves.

Affects `martini2017_cohort_t18m_paidthreshold30d`. **No denominator was reconstructed and no count
was back-calculated from any of the three percentages.**

## 6. martini2017 — minor percentage slips (not blocking)

Table 1, p. 38: `Female 5 (26.4)` for the employed group, where 5/19 = 26.32 per cent; the
unemployed column prints 8 (30.8), where 8/26 = 30.77 per cent, so the female row rounds
inconsistently with its neighbour. Results, p. 38: "15 (93.7%) individuals from EG met the remission
criteria" — 15/16 = 93.75 per cent, so the remission denominator at endpoint is 16 rather than 19,
which the text does not say until the Symptomatic changes paragraph ("Among the EG (n=16)").

## 7. mcgurk2016 — the E-VR cells print 12/26 beside 48 per cent **BLOCKING**

Table 3, p. 54:

| Row | E-VR cell | Printed % | 12/26 | 12/25 |
|---|---|---|---|---|
| Any competitive work (yes) | 12/26 | 48% | 46.15% | 48.00% |
| Any paid work (yes) | 12/26 | 48% | 46.15% | 48.00% |
| Any work activity (yes) | 13/26 | 50% | 50.00% | — |

Both employment cells for E-VR print 48 per cent against a count that gives 46.2 per cent, so this is
systematic within the arm rather than a single rounding slip; 12/25 gives exactly 48.00 per cent.
A denominator of 25 for E-VR is not invented: Table 1, p. 51, reports "Any competitive work past 5
years" for E-VR as 23 yes and 2 no, summing to 25 rather than 26. Every TSW cell is internally
consistent (16/28 = 57.1 against 57 per cent; 17/28 = 60.7 against 61; 21/28 = 75.0 against 75).

Affects `mcgurk2016_evr_t36m_paidcomp` and `mcgurk2016_evr_t36m_paidany`.

## 8. mcgurk2016 — the Discussion's whole-sample percentages do not match the table **BLOCKING**

Discussion, p. 55: "vocational outcomes were relatively good, with **54%** of total sample obtaining
competitive work and **67%** involved in some work related activity over the course of the study."

From Table 3, p. 54: competitive 12 + 16 = 28 of 54 = **51.9 per cent**; any work activity
13 + 21 = 34 of 54 = **63.0 per cent**. Neither printed figure is reproducible from the printed arm
counts. 54 per cent of 54 is 29.2 people and 67 per cent is 36.2 people, so no whole number of
participants gives either figure on a denominator of 54.

Affects both competitive rows and both work-activity rows.

## 9. mcgurk2016 — TSW exposure rate printed as both 89 and 92 per cent (not blocking)

Results, p. 52: "Among the 28 participants randomized to TSW, 25 (89%) were exposed to the cognitive
training", and the abstract agrees (89 per cent). Discussion, strengths, p. 55: "rates of exposure to
the TSW program were excellent (**92%**)." 25/28 = 89.3 per cent; 92 per cent would require 25.8
people. This is an intervention-fidelity figure, not an employment result, so it blocks nothing, but
it is recorded because it is the third arithmetic slip in the same report.

## 10. mervis2017 — ANCOVA degrees of freedom cannot come from 64 participants (not blocking)

Results, p. 132: "significant differences emerged at follow up for both the DAS (F(1, **84**) = 3.51,
p = 0.027) and the TSRQ (F(1, 84) = 2.87, p = 0.032)", and "IVIP group had better WBI than SG at post
(F(1, 84) = 4.07, p = 0.011)". An ANCOVA on 64 participants with one covariate has about 61 error
degrees of freedom, not 84. The RM-MANOVA is separately printed as F(7, 47). The employment outcome
itself is reported as plain counts (14/29 and 6/35) and is unaffected, which is why this does not
block, but it means the analysed sample size cannot be verified from the statistics reported.

## 11. mervis2017 — the outcome is named two different things (not blocking as a conflict; recorded as a construct failure)

The same number is described as service enrolment in one place and as obtaining a job in another:

- 2.5.1.3, p. 131: "the number of participants **in** supported employment was tallied";
- 2.6, p. 131: "percentage of those who **enrolled in** supported employment (SE) by time of follow-up";
- Results, p. 132: "nearly half of the IVIP group went on to **secure** supported employment";
- Results, p. 132: "no significant attrition in the IVIP group's supported employment **enrollment status**".

This is not recorded as `conflict_status = unresolved`, because the two numbers do not disagree —
14/29 and 6/35 are internally consistent with their printed percentages. It is recorded instead as
`outcome_construct = unclear`: the report does not establish what was counted, which the codebook
routes to `unclear` with the wording preserved rather than to a conflict. An author query is filed.

## 12. moncrieff2025 — the 190 participants with an employment outcome are split three different ways **BLOCKING**

| Source | Relapsed | Not relapsed | Total |
|---|---|---|---|
| Table 2, p. 676 (`Rate of employment, education and training`) | 8/**66** | 30/**124** | 190 |
| Results text, p. 674 ("available for 70.7% ... and 77.2%") applied to the printed group sizes 82 and 171 | **58** | **132** | 190 |
| Table 4, p. 676 (`Changes in employment, education and training status`) | **57** | **132** | **189** |

The text percentages are demonstrably not loose rounding. The same sentence reproduces Table 2's
other denominators exactly:

| Measure | Text % | × group size | Table 2 n |
|---|---|---|---|
| SFS | 67.1 / 74.5 | 55.0 / 127.4 | 55 / **129** |
| MANSA | 64.6 / 71.4 | 53.0 / 122.1 | 53 / 122 |
| PANSS | 42.7 / 44.4 | 35.0 / 75.9 | 35 / 76 |
| **EET** | **70.7 / 77.2** | **58.0 / 132.0** | **66 / 124** |

MANSA and PANSS agree exactly in both cells, SFS agrees in one and is two out in the other, and EET
is eight out in both, in opposite directions. Eight people are attributed to the relapsed group in
Table 2 that the text attributes to the non-relapsed group, which changes both printed rates
(8/58 = 13.8 per cent rather than 12.1; 30/132 = 22.7 per cent rather than 24.2).

Affects `moncrieff2025_relapsed_t24m_eet`, `moncrieff2025_notrelapsed_t24m_eet` and the derived
whole-cohort row `moncrieff2025_cohort_t24m_eet` (38 / 190).

Recorded because it is the reason the block is not obviously fatal, and therefore the reason it must
be a block rather than a note: the group **total** is unaffected, since 66 + 124 = 58 + 132 = 190 and
8 + 30 = 38 either way. A numerically complete 38/190 would enter the EET pool silently and look
right. It is blocked because a report that misallocates eight people between its own analysis groups
has not established that the numerators 8 and 30 are correctly allocated either.

## 13. moncrieff2025 — Table 1's baseline employment percentage (not blocking)

Table 1, p. 675, relapsed column: "In employment, education or training 21/80 (**25.3%**)" and "Not
in employment, education or training 59/80 (73.8%)". 21/80 = 26.25 per cent; 59/80 = 73.75 per cent,
which matches. The two printed percentages sum to 99.1 rather than 100. 21/83 would give 25.3 per
cent. The counts 21 and 59 sum to their own denominator of 80, so the counts are self-consistent and
the percentage is the error.

## 14. majuri2023 — Table 1's socioeconomic-status column does not sum to its own header (not blocking)

Table 1, p. 70, `Schizophrenia (n = 29)` column for men. The socioeconomic-status cells are Farmer 1,
Entrepreneur 0, Upper white collar 1, Lower white collar 2, Manual worker 4, Student 2, Pensioner 14,
Other 4, Unknown 0, which sum to **28**, against a printed column header of **29**. Every printed
percentage in the block is consistent with a denominator of 28 (1/28 = 3.6, 2/28 = 7.1, 4/28 = 14.3,
14/28 = 50.0). One man is unaccounted for.

Recorded rather than blocking because no result row is created from this table at all. It is one of
four reasons the Statistics Finland occupational categories were not summed into a `paid_any` count;
the others are recorded in `manifest_changes.csv` and in the report's `notes`.
