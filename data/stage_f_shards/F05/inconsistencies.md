# Batch F05: internal contradictions found in the sources

Batch `F05`. Extractor `claude-opus-5`, 12 August 2026, under `config/prompts/extraction_v2.md`.
Every entry gives the report, what the paper prints, what the arithmetic gives, and the exact location.

---

## I1. strassnig2017, Table 1: employment counts, percentages and the text are mutually irreconcilable

**Location:** Table 1, p. 182; Results section 3, p. 182; Discussion, p. 183; Abstract, p. 180.

| What the paper prints | Where | What the arithmetic gives |
|---|---|---|
| Gainful employment, SCZ: `60 (20.6%)`, n = 80 | Table 1, p. 182 | 60/80 = 75.0%, not 20.6%. 20.6% of 80 = 16.5 |
| Gainful employment, BP: `23 (53.4%)`, n = 48 | Table 1, p. 182 | 23/48 = 47.9%, not 53.4%. 53.4% of 48 = 25.6 |
| "In the entire sample, 32.9% were employed" | Results section 3, p. 182 | The two printed **counts** give 83/128 = 64.8%. The two printed **percentages** give 0.206x80 + 0.534x48 = 42.1, and 42.1/128 = 32.9%, so the text agrees with the percentages and not with the counts |
| "66/80 of the SCZ patients were both unemployed and living dependently" | Discussion, p. 183 | Leaves at most 14 of 80 schizophrenia participants employed **or** living independently, which contradicts both the count reading (60 employed) and the percentage reading (16.5 employed, 21 or 22 living independently) |
| "The analysis sample consisted of 122 participants with SCZ ad BP" | Abstract, p. 180 | Results section 3 says "The final sample included 128 patients with complete data (80 SCZ; 48 BP)", and 80 + 48 = 128 |
| Residential independence, SCZ `21 (27.8%)`, BP `32 (76.7%)` | Table 1, p. 182 | 21/80 = 26.3% and 32/48 = 66.7%. Neither reproduces |
| chi-square for employment `26.3`, for residence `52.0` | Table 1, p. 182 | Recomputed from the printed counts: 19.0 and 20.2 |

**Consequence.** No employment numerator is recoverable for strassnig2017 without back-calculating
from a percentage, which the codebook forbids. `n_employed` and `n_outcome_observed` are blank,
`reported_percentage_base = 128`, and `conflict_status = unresolved`, which blocks the row from every
synthesis. `report_quantifiable = no`.

**Note on the travelling numbers.** The pair `27.8%` / `76.7%` printed against *Residential
independence* here is the same pair printed against *Employed* in strassnig2018 Table 1, where it
also matches nothing. The two tables appear to share a corrupted percentage column.

---

## I2. strassnig2018, Table 1: the percentage column of the two functioning rows is shifted by one row

**Location:** Table 1, p. 12 of the author manuscript (Schizophr Res 2018;197:150-155).

| Row | Printed | 
|---|---|
| Residentially Independent | SCZ `40 (24.7%)` (n = 146), BP `60 (52.9%)` (n = 87) |
| Employed | SCZ `36 (27.8%)` (n = 146), BP `46 (76.7%)` (n = 87) |

Arithmetic:

- 36/146 = **24.66%**, which is the `24.7%` printed one row above, on Residentially Independent.
- 46/87 = **52.87%**, which is the `52.9%` printed one row above.
- 40/146 = 27.4% and 60/87 = 69.0%, so the pair printed against Employed (27.8%, 76.7%) matches
  neither row; it is byte-identical to the residence pair in strassnig2017 Table 1.
- The unaffected rows of the same table are internally consistent: Sex/Male 88/146 = 60.3% and
  43/87 = 49.4%; Race/White 105/146 = 71.9% and 78/87 = 89.7%. All four reproduce exactly.

**Resolution taken.** In favour of the **counts**, 36 of 146 and 46 of 87, because they reproduce
two percentages printed in the same table exactly and no alternative count appears anywhere in the
report. `conflict_status = resolved` on both outcome rows, with the full arithmetic in
`conflict_note`. The resolution rests on extractor arithmetic alone; no author was contacted, and
`checker` is blank for Stage G. **This is a judgement call and it differs in kind from `hansen2024`,
which is blocked as `unresolved` because there two printed *counts* disagreed (99 against 105) and
no arithmetic could adjudicate between them.** See `unresolved_queries.md` Q1 for the author query
that would settle it.

## I3. strassnig2018, Table 1: the printed chi-square statistics do not reproduce, on any reading

**Location:** Table 1, p. 12.

| Comparison | Printed | Recomputed from the printed counts |
|---|---|---|
| Employed, SCZ vs BP | chi-square 39.6 | 19.0 (36/146 against 46/87) |
| Residentially Independent, SCZ vs BP | chi-square 64.1 | 38.5 (40/146 against 60/87) |

No alternative reading of the table reproduces either value, including the shifted-percentage
reading adopted in I2. This anomaly is **not** resolved and is recorded in the risk-of-bias
appraisal (`jbi8_statistical_analysis` = `unclear` for both strassnig2018 results). It does not
change the extracted counts, because the chi-square is not an input to any of them.

---

## I4. wang2020c: the recruited total is given three different ways

**Location:** Abstract, p. 1; Methods, Participants, p. 3; Results, p. 4; Table 1, p. 5.

| What the paper prints | Where |
|---|---|
| "All 525 stable patients with schizophrenia in the therapeutic community ... were recruited between 2013 and 2015" | Abstract, p. 1 |
| "All 550 residents present in the therapeutic community of Yuli Hospital from January 2013 to December 2015 were recruited for this study" | Methods, Participants, p. 3 |
| "At the baseline, 525 residents ... participated in this study" | Results, p. 4 |
| `N = 525` | Table 1, p. 5 |

The 25-person difference is never explained. `550` is also exactly the number wang2020b reports as
entering its GEE analysis after excluding 11 (9 deaths, 2 discharges) from 561, which raises the
possibility that the wrong figure was carried across from the sibling paper. wang2020c separately
states that "no subjects were proclaimed dead or discharged to their homes", which cannot be
reconciled with wang2020b's 9 deaths over an overlapping window in the same community.

**Consequence.** No employment numerator or denominator is extracted from either wang report for
other reasons (see I5), so the discrepancy does not block a count. It is recorded because it bears
on the cohort's denominators if an author reply ever supplies employment counts.

## I5. wang2020c, Table 1: the column headings are shifted by one relative to the data

**Location:** Table 1, p. 5. Headings read `Remission (n = 124)` | `Nonremission (n = 401)` | `Total`.

The data are in the order **Total | Remission | Nonremission**:

- Gender: `343 (65.3%)` in the first column. 343/525 = 65.3% (the total), and the Results text says
  "The majority of the patients were men (65.3%)". The second and third columns are 70/124 = 56.5%
  and 273/401 = 68.1%.
- Initial employment type: first column 323 + 68 + 134 = **525**; second column 48 + 23 + 53 = **124**;
  third column 275 + 45 + 81 = **401**. The three column sums identify the columns unambiguously.
- Age: `51.8` in the first column matches the Results text's "The average age of the patients was
  51.8 years"; the remission group is younger (49.38) than the non-remission group (52.55), which is
  the direction the reported t = 3.17 requires.

The shift is systematic and fully determined, so every value in the table is recoverable. It is
recorded because the moderator values would otherwise be read off the wrong groups.

---

## I6. andersen2024: the outcome is labelled NEET but its operational definition omits training

**Location:** Methods, Vocational outcome measures, p. 877; Table 2, p. 880.

The paper prints: "NEET is defined as not being in full- or part-time education and not being in
full- or part-time employment." Training is not named, and the four Table 2 categories are NEET,
Working, Studying, Studying and working, with no training category.

D12.1 states that `paid_or_education_or_training` "is reserved for composites that name all three,
such as NEET". The label here points to that value; the source's own operational definition points
to `paid_or_education`. **The definition was followed** and the complement-of-NEET rows are coded
`paid_or_education`, under codebook when-in-doubt rule 1 (record the paper's own wording). Neither
value enters the primary pool, so nothing in the primary estimate turns on it, but the choice should
be adjudicated before the secondary EET synthesis is run.

---

## I7. andersen2026: mean follow-up duration is given as 11.1 years in the text and 11.6 in the table

**Location:** Results section 3.2, p. 51 ("varied from 4.5 to 23.5 years with a mean of 11.1 years
(SD = 5.5)"); Table 2, p. 52 ("Follow-up duration in years, mean (SD): EOP 11.6 (5.5)"); Abstract,
p. 48 ("mean = 11 years"); Strengths and limitations, p. 55 ("an average of 11 years").

11.6 was used, because Table 2's figure is the EOP-group value and the text may be describing the
combined sample (the HC mean in Table 2 is 10.6). The choice is not decision-critical: the result's
`followup_basis` is `unclear`, so it cannot be assigned to a landmark horizon whichever mean is
right.

## I8. andersen2026: proportion with any psychiatric inpatient day, 93.4% in the text against 83.4% in the table

**Location:** Results section 3.2, p. 51 ("During follow-up, 93.4% of EOP participants ... had at
least one psychiatric inpatient stay"); Table 2, p. 52 ("Any psychiatric inpatient day: 171 (83.4%)",
n = 205). 171/205 = 83.41%, so the table is internally consistent and the text is not.

This is not an employment outcome and does not affect any extracted count. It is recorded because it
is the second arithmetic discrepancy in the same report and it is why
`jbi8_statistical_analysis` is judged `unclear` for all three andersen2026 results.

---

## Checks that PASSED, recorded so the absence of an entry is not read as an absence of checking

- **andersen2024, Table 2, p. 880.** At every timepoint the four vocational categories sum exactly to
  the printed n minus the printed Missing, and every printed percentage reproduces on that
  denominator. Baseline 763 + 263 + 380 + 137 = 1543 = 1574 - 31; 9 months 309 + 177 + 174 + 91 = 751 =
  843 - 92; 12 months 246 + 143 + 127 + 62 = 578 = 643 - 65. The UHR panel reproduces likewise.
- **andersen2026, Table 2, p. 52.** 106 + 43 + 49 = 198, and 53.5%, 21.7% and 24.8% each reproduce on
  198. The Discussion's "46% were in competitive employment or education" reproduces as 92/198 =
  46.5%, and Table 3's column headings (106 and 92) agree with Table 2.
- **andersen2026, Table 1, p. 51.** The ICD-10 diagnostic categories sum to 205 and each percentage
  reproduces.
- **strassnig2018, Table 1.** Sex and race counts and percentages reproduce exactly on 146 and 87,
  which is what establishes that the counts column, and not the percentage column, is the reliable one.
