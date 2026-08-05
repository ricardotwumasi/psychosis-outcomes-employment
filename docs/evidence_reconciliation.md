# Evidence reconciliation

**Date:** 5 August 2026
**Inputs:** the 93 PDFs staged in `dissertation_shared_folder/Data Extraction Papers/`, the PRISMA flow diagram dated 3 August 2026, and the MSc dissertation.
**Output:** `data/inclusion_manifest.csv`, one row per staged file, with an eligibility decision, a stable identifier and a cohort mapping.

This addresses the feasibility review's Stage 1: three counts disagreed and the number of independent studies was unknown.

---

## 1. The three counts, reconciled

| Source | Count | What it actually is |
|---|---|---|
| PRISMA, 3 August 2026 | 90 | Reports included after full-text screening |
| Staged PDF folder | 93 files | A file inventory, not an evidence set |
| MSc dissertation | 115 | Reports meeting criteria at an earlier, superseded screening round |

The 93 files resolve as follows:

```
93 files staged
 -1  duplicate file (wang2020, byte-identical content and DOI to wang2020b)
 ---
 92 distinct reports
```

92 distinct reports against a PRISMA figure of 90. The residual difference of two is **not resolved** and cannot be from the files alone: no machine-readable screening ledger exists, and the PRISMA counts survive only as PNG images. Two plausible explanations are that two reports were added to the folder after the flow diagram was drawn, or that the diagram undercounts. **A Rayyan or Covidence export is required to close this**, and until it exists the review cannot state a defensible included-report count.

The dissertation's 115 predates the current screening round and is superseded. It is not a discrepancy to reconcile, but it should be reported as a screening-round difference rather than left to look like one.

## 2. Reports are not studies

**93 files map to 74 distinct cohorts.** Twelve cohorts produced more than one report:

| Cohort | Reports | n |
|---|---|---|
| JUMP, six Norwegian counties | `evensen2017`, `evensen2019`, `gjerdalen2023`, `klungsyr2021`, `lystad2017` | 5 |
| Hong Kong EASY, 2001-03 intake | `chan2019`, `chan2022`, `chang2016`, `chang2016b` | 4 |
| Northern Finland Birth Cohort 1966 | `majuri2021`, `majuri2023`, `rautio2016` | 3 |
| Yuli Hospital therapeutic community, Taiwan | `wang2020`, `wang2020b`, `wang2020c` | 3 |
| headspace Early Psychosis, Australia | `andersen2024`, `brown2022` | 2 |
| PAFIP, Cantabria | `ayesaarriola2020`, `mayoralvanson2019` | 2 |
| OnTrackNY | `basaraba2023`, `nossel2018` | 2 |
| State Hospital Carstairs, 1992-93 | `darjee2017`, `thomson2023` | 2 |
| OPUS trial, 1998-2000 | `hansen2024`, `hansen2024b` | 2 |
| Chicago Follow-up Study | `harrow2017`, `jones2024` | 2 |
| Regional Mental Hospital, Pune | `khare2022`, `unknown2022` | 2 |
| Suffolk County Mental Health Project | `strassnig2017`, `strassnig2018` | 2 |

Treating these 93 reports as independent studies would have counted the JUMP participants five times and the Hong Kong EASY cohort four times. This is exactly the pseudo-replication the analysis plan's cohort-level random effect prevents.

**Two near-misses worth recording**, both genuinely distinct despite appearances:

- `khare2021` (Pune **private** hospitals, n=550) and `khare2022`/`unknown2022` (Pune **public** hospital, n=150) share a research team and a city but are different samples.
- `opus_1998` (OPUS trial, recruited 1998-2000) and `opus_2014` (OPUS Aarhus/Aalborg, inclusion 2014-2019) are different waves of the same service and do not share participants.

**One hidden overlap:** `leighton2019` is a prediction-model paper developed on National EDEN and **validated on the OPUS trial cohort**. Its OPUS validation figures (173/553) must not be pooled alongside `hansen2024`, which reports the same participants.

## 3. Eligibility

| Status | n | Meaning |
|---|---|---|
| `include` | 60 | Contributes at least one extractable result |
| `exclude` | 25 | Assessed, cannot contribute |
| `linked_report` | 7 | Eligible participants, but another report of the cohort carries the result used |
| `duplicate` | 1 | Same article twice in the folder |

The 60 included reports span **57 distinct cohorts**. Three cohorts still carry two included reports each (`jump_norway`, `hk_easy_2001`, `nfbc1966`, and `carstairs_1992`); the prespecified result-selection rule resolves these at analysis time and the reports not selected are named in the output rather than dropped.

### The main finding: a quarter of the evidence set has no extractable prevalence

**23 of 93 reports (25 per cent) report employment in a form from which no numerator and denominator can be recovered.** This was not visible before the reconciliation and it materially changes what the review can deliver.

The forms this takes:

| Form | Examples |
|---|---|
| Percentages with no numerator, or a shrinking or unstated denominator | `blackman2025`, `falk2016`, `fulford2018`, `solmi2022`, `topor2019`, `peebo2022`, `rodriguezpulido2021`, `lin2022` |
| Counts exist but only in an online appendix not held locally | `hakulinen2019`, `lin2026`, `jirapramukpitak2022` |
| Employment reported only as a mean duration or income, never as a prevalence | `wang2020b`, `wang2020c`, `chan2022`, `shimada2022`, `klungsyr2021`, `majuri2023` |
| Employment only as a component of a composite, not separable | `chang2016b`, `jones2024` |
| Employment only as an adjusted model estimate | `greenwood2025`, `tsiachristas2016` |
| No employment measure at all | `brown2022`, `stouten2019` |

Three of these are recoverable by **writing to authors or retrieving supplements**, which the registered protocol already commits to ("Authors will be asked to provide any required data not available in published reports"). That should be actioned: `hakulinen2019`, `lin2026` and `jirapramukpitak2022` are large, informative cohorts lost for want of a supplementary table.

Only two reports were excluded on classical grounds: `delpiccolo2024` (clinical high risk population, and 6-month follow-up) and `brown2022` (no employment measure).

## 4. Data-quality problems found during reading

These are recorded because each one would otherwise become a silent error in the extraction.

**Internally inconsistent numbers.** Six reports print figures that cannot all be true. Each needs adjudication against the source before extraction, not a guess:

| Report | Inconsistency |
|---|---|
| `mihaljevicpeles2016` | Abstract says 77/257 employed, Results says 77/205 after excluding 71 disability pensioners |
| `strassnig2018` | Table 1 percentage column is misaligned with its row labels; the printed values are arithmetically impossible |
| `strassnig2017` | Schizophrenia shown as "60 (20.6%)" against n=80 |
| `tarricone2017` | 75 employed described as both 46 per cent of the total and 53 per cent of the 135 still in contact |
| `mucci2021` | Stated 35.4 per cent implies a denominator near 588, not the 618 reported as followed up |
| `martini2017` | 19 employed printed as 35.8 per cent, implying a denominator of 53 rather than the 45 who completed |
| `twumasi2026` | 38,160 engaged against a stated 69.1 per cent implies a denominator near 55,200, not 65,630 |

**Derived counts requiring verification.** Four included results were obtained by the reading pass summing or subtracting published cells rather than reading a single figure: `unknown2022` (53 = 45 + 8), `khare2021` (287 = 257 + 30), `hui2026` (158 by subtraction), `hansen2024`. Codebook rule 2 forbids using a derived count without checking it against the source table.

**Zero and near-zero event cells**, which is why the analysis uses an exact binomial likelihood rather than a normal approximation with a continuity correction: `thomson2023` (no paid employment at all at 20 years), `darjee2017` (1 in supported work), `fowler2019` (0/24 in the non-affective TAU arm), `luo2019` (1/28 controls), `rautio2016` (several empty cells in Tables 2 and 3).

**Metadata errors in my own manifest, now corrected:**
- `bjornsdottir2022` is by Guðbrandsdóttir and Ingimarsson. The filename misled the hand-identification pass.
- `unknown2022` resolved via CrossRef to a "Supplemental Material for..." record, but the PDF is the full article. It needs the article DOI.

## 5. Ascertainment and construct, as found

Confirming that the analysis plan's separations were necessary rather than theoretical:

- **Composite work-or-education**, which the plan treats as a secondary construct, is used by at least 15 included reports: `andersen2026`, `basaraba2023`, `bonnesen2026`, `fulford2018`, `jackel2025`, `leighton2019`, `leighton2019b`, `lindgren2020`, `mackinley2022`, `maguire2021`, `moncrieff2025`, `ringbom2023`, `twumasi2026`, and others. Had these been pooled with paid-employment estimates, the pooled figure would have been a composite of two different things.
- **Period prevalence**, excluded from the primary pool, is used by at least 14 reports, mostly registers: `andersen2026`, `chang2016`, `cunningham2025`, `drake2015`, `fowler2019`, `gjerdalen2023`, `hakulinen2019`, `hansen2024`, `hansen2024b`, `harrow2017`, `nossel2018`, `rautio2016`, `ringbom2023`, `stralin2019`, `topor2019`.
- **Baseline selection on being unemployed and wanting work**, the reason trial arms are excluded from the primary estimand, is explicit in `cook2016`, `christensen2019`, `detore2019`, `evensen2017`, `martini2017`, `mcgurk2016`, `mervis2017`, `pedersen2025`, `petrakis2019`, `rodriguezpulido2021`, `yamaguchi2020` and `zhang2017`.

## 6. Conflict of interest

`twumasi2026` is a report by the review's guarantor. It should be extracted and appraised by someone else, and the arrangement stated in the manuscript.

## 7. Outstanding before Stage 7

1. Obtain a Rayyan or Covidence export to close the 92-versus-90 gap and produce a defensible PRISMA.
2. Locate the Sturup source (DOI `10.1017/S0033291722002021`). It is **not** among the 93 staged PDFs; the only Stürup hit is `hansen2024`, on which they are a co-author. The legacy `employment-pyschosis-extraction.csv` is retained unchanged until this is resolved.
3. Request supplementary tables or author data for `hakulinen2019`, `lin2026` and `jirapramukpitak2022`.
4. Adjudicate the seven internally inconsistent reports listed above.
5. Run the search update, since the registered window closes 2 June 2025 and 2026 reports are already in the set.
