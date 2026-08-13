# Evidence reconciliation

**Date:** 5 August 2026, with a screening reconciliation added 11 August 2026 (section 8).
**Inputs:** the 93 PDFs staged in `dissertation_shared_folder/Data Extraction Papers/`, the PRISMA flow diagram dated 3 August 2026, and the MSc dissertation. From 11 August 2026, also `DATA_EXTRACTION_FINAL.xlsx`.
**Output:** `data/inclusion_manifest.csv`, one row per staged file, with an eligibility decision, a stable identifier and a cohort mapping.

This addresses the feasibility review's Stage 1: three counts disagreed and the number of independent studies was unknown.

> **Read section 8 first.** The screening spreadsheet surfaced on 11 August 2026
> and resolves the 92-versus-90 gap that sections 1 and 7 record as open. Counts
> in sections 1 to 3 are the 5 August position and have been corrected in place
> where they were stale.

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
 -1  duplicate file (wang2020, same DOI and identical extracted text to wang2020b)
 ---
 92 distinct reports
```

92 distinct reports against a PRISMA figure of 90. **Resolved on 11 August 2026;
see section 8.** The screening spreadsheet `DATA_EXTRACTION_FINAL.xlsx` is the
machine-readable ledger this section says is missing. It lists exactly 90
studies, matching the PRISMA figure. The folder held six files that were never on
that list, one of them the duplicate, and was missing three that were.

The correction to the 5 August wording: `wang2020` and `wang2020b` are the same
article but are **not** byte-identical. Their SHA-256 hashes differ, while the
text extracted from both is character-for-character identical (46,534 characters
over 7 pages) and the files differ by 297 bytes of download metadata. The
redundant copy was deleted on 11 August 2026.

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

Counts below are the live manifest at 11 August 2026. The 5 August draft of this
section read include=60 and exclude=25; `lin2026` and `jirapramukpitak2022` moved
to `include` once their supplements were retrieved, and the three `pending` rows
were added by the screening reconciliation in section 8.

| Status | n | Meaning |
|---|---|---|
| `include` | 62 | Contributes at least one extractable result |
| `exclude` | 23 | Assessed, cannot contribute |
| `linked_report` | 7 | Eligible participants, but another report of the cohort carries the result used |
| `duplicate` | 1 | Same article twice in the folder |
| `pending` | 3 | Screened in, PDF not yet held. See `docs/missing_pdfs.md` |
| **total** | **96** | |

The 62 included reports span **59 distinct cohorts**, out of 74 across the whole
manifest. Several cohorts still carry more than one included report (`jump_norway`, `hk_easy_2001`, `nfbc1966`, and `carstairs_1992`); the prespecified result-selection rule resolves duplicates within the same horizon, ascertainment and exact construct, and the reports not selected are named rather than dropped. A narrower construct never substitutes for `paid_any`.

### The main finding: a quarter of the evidence set has no extractable prevalence

**21 of 93 staged reports report employment in a form from which no numerator and denominator can be recovered.** This was not visible before the reconciliation and it materially changes what the review can deliver. The 5 August draft said 23 of 93; `lin2026` and `jirapramukpitak2022` have since been recovered from supplements.

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

**Internally inconsistent numbers.** **Eight** reports were known to print figures that cannot all be true when this section was written. **Stage F multiplied that count: 50 of its 208 results are now blocked as `conflict_status = unresolved`**, each with its candidate resolution recorded in `conflict_note` and in the shard's `inconsistencies.md`. The eight below are the pilot's; they are not the whole list, and `docs/handover.md` task 2 carries the Stage F additions. Each needs adjudication against the source, not a guess:

*This count was itself wrong until 11 August 2026, which is worth recording rather than quietly correcting. The prose said six, the table listed eight, and section 7 said seven. The table was right: six were found on 5 August, `twumasi2026` and `benson2022` were added later, and neither the sentence above it nor the action item below was updated. A file that catalogues other people's arithmetic errors is exactly the file that must not carry its own, so the discrepancy is noted here rather than overwritten.*

| Report | Inconsistency |
|---|---|
| `mihaljevicpeles2016` | Abstract says 77/257 employed, Results says 77/205 after excluding 71 disability pensioners |
| `strassnig2018` | Table 1 percentage column is misaligned with its row labels; the printed values are arithmetically impossible |
| `strassnig2017` | Schizophrenia shown as "60 (20.6%)" against n=80 |
| `tarricone2017` | 75 employed described as both 46 per cent of the total and 53 per cent of the 135 still in contact |
| `mucci2021` | Stated 35.4 per cent implies a denominator near 588, not the 618 reported as followed up |
| `martini2017` | 19 employed printed as 35.8 per cent, implying a denominator of 53 rather than the 45 who completed |
| `twumasi2026` | 38,160 engaged against a stated 69.1 per cent implies a denominator near 55,200, not 65,630 |
| `benson2022` | Table 3 relapse column prints full-time employment as 5.4 per cent, but 577/16,862 is 3.4 per cent, and that column's percentages sum to 102.0. The non-relapse column is consistent and its full-time figure is genuinely 5.4 per cent, so the value appears copied across. Counts are sound: both columns sum exactly to 16,862. Extract counts, not percentages (found 11 August 2026) |

**Derived counts requiring verification.** Four included results were obtained by the reading pass summing or subtracting published cells rather than reading a single figure: `unknown2022` (53 = 45 + 8), `khare2021` (287 = 257 + 30), `hui2026` (158 by subtraction), `hansen2024`. Codebook rule 2 forbids using a derived count without checking it against the source table.

**Zero and near-zero event cells**, which is why the analysis uses an exact binomial likelihood rather than a normal approximation with a continuity correction: `thomson2023` (no paid employment at all at 20 years), `darjee2017` (1 in supported work), `fowler2019` (0/24 in the non-affective TAU arm), `luo2019` (1/28 controls), `rautio2016` (several empty cells in Tables 2 and 3).

**Metadata errors in my own manifest, now corrected:**
- `bjornsdottir2022` is by Guðbrandsdóttir and Ingimarsson. The filename misled the hand-identification pass.
- `unknown2022` resolved via CrossRef to a "Supplemental Material for..." record, but the PDF is the full article. It needs the article DOI.

## 5. Ascertainment and construct, as found

Confirming that the analysis plan's separations were necessary rather than theoretical:

- **Composite employment, education or training**, retained as a separate registered vocational-participation outcome, is used by at least 15 included reports: `andersen2026`, `basaraba2023`, `bonnesen2026`, `fulford2018`, `jackel2025`, `leighton2019`, `leighton2019b`, `lindgren2020`, `mackinley2022`, `maguire2021`, `moncrieff2025`, `ringbom2023`, `twumasi2026`, and others. Education and training must be extracted separately when available and the original composite preserved when they are not. Had these results been pooled with paid-employment estimates, the pooled figure would have combined different constructs.
- **Period prevalence**, excluded from the primary pool and assigned its own synthesis, is used by at least 14 reports, mostly registers: `andersen2026`, `chang2016`, `cunningham2025`, `drake2015`, `fowler2019`, `gjerdalen2023`, `hakulinen2019`, `hansen2024`, `hansen2024b`, `harrow2017`, `nossel2018`, `rautio2016`, `ringbom2023`, `stralin2019`, `topor2019`.
- **Employment-related selection** is explicit in `cook2016`, `christensen2019`, `detore2019`, `evensen2017`, `martini2017`, `mcgurk2016`, `mervis2017`, `pedersen2025`, `petrakis2019`, `rodriguezpulido2021`, `yamaguchi2020` and `zhang2017`. This selection, rather than the parent design label, excludes a whole cohort from the primary prevalence estimand. Allocated trial arms remain outside the prevalence intercept for the separate reason that they do not represent the whole recruited cohort.

## 6. Conflict of interest

`twumasi2026` is a report by the review's guarantor. It should be extracted and appraised by someone else, and the arrangement stated in the manuscript.

## 7. Outstanding before Stage 7

1. ~~Obtain a Rayyan or Covidence export to close the 92-versus-90 gap.~~
   **Closed 11 August 2026.** `DATA_EXTRACTION_FINAL.xlsx` is the screening
   ledger and lists exactly 90 studies. See section 8.
2. ~~Locate the Sturup source (DOI `10.1017/S0033291722002021`).~~
   **Closed 11 August 2026.** The PDF was supplied, found not to be on the
   90-study screening list, and removed from the folder with the guarantor's
   agreement. It is Stürup et al., *Psychol Med* 2023;53:5033-41, a Danish
   register cohort of first-episode schizophrenia diagnosed 1995-2013, so it
   would probably have overlapped `dk_registers_1998` had it been eligible.
   Recorded in section 8. With the search now closed and the universe frozen, it
   could only re-enter through a documented screening-list amendment. The
   legacy `employment-pyschosis-extraction.csv` can now be retired rather than
   held pending, since its single `sturup2022` row is off the screening list and
   its outcome construct ("work as primary income source or registered student")
   is an EET composite that cannot enter the primary pool in any case.
3. ~~Obtain the three screened-in reports that have no PDF.~~
   **Closed 11 August 2026.** All 90 screened-in studies are held and readable,
   and `scripts/check_folder.py` exits 0. `killackey2019`, `chan2020` and
   `benson2022` all still need a full-text eligibility decision and remain
   `pending`. `chan2020` is the priority, since employment over ten years is its
   stated outcome and it probably belongs to `hk_easy_2001`, a cohort whose four
   other reports are all excluded as `no_extractable_data`. See
   `docs/missing_pdfs.md`.
4. Request supplementary tables or author data for `hakulinen2019`. `lin2026` and
   `jirapramukpitak2022` are resolved; see `docs/data_requests.md`.
5. Adjudicate the eight internally inconsistent reports listed above, and any further ones the definitive extraction finds. Each becomes a corresponding-author query in `docs/data_requests.md`.
6. ~~Run the search update, since the registered window closes 2 June 2025 and 2026
   reports are already in the set.~~ **Closed 12 August 2026.** No update was needed:
   2 June 2025 belongs to an earlier search and the executed search closes 9 June 2026,
   which covers the 2026 reports. The 90 screened reports are frozen as the report
   universe. The off-list studies in section 8 stay off-list under D10.1 and would need
   a documented screening-list amendment, not a search rerun.
7. Independently verify employment-selection status and recode the employment,
   education, training and EET constructs under SAP version 0.2 before importing
   the remaining reports.

---

## 8. Screening reconciliation, 11 August 2026

`DATA_EXTRACTION_FINAL.xlsx` (sheet "Prachee - Data Extraction") was supplied on
11 August 2026 and confirmed by the guarantor as the authoritative screening
list. It holds exactly 90 rows, every one marked INCLUDE: 67 "Both" and 23
"Disagreement Resolved". It is the machine-readable ledger section 1 records as
missing, and its 90 matches the PRISMA figure.

Each spreadsheet row was mapped to a manifest row on cleaned DOI first, then on
normalised title. The spreadsheet's DOI column needs cleaning: it carries
trailing record junk such as `    PT  - Article` and 18 rows have no DOI at all.
The mapping is now recorded in `data/inclusion_manifest.csv` as
`screening_list` and `screening_row`, so it is data rather than prose and cannot
silently change.

```
screened-in studies                        90
  PDF held and readable                    89   (87 at first pass, 2 retrieved same day)
  PDF not held                              1
staged files not on the screening list      6
```

**Three screened-in studies had no PDF.** They were added to the manifest as
`eligibility_status = pending`, `source_available = no`, so they were visible as
outstanding rather than absent. Two were retrieved the same day. Full citations
and the remaining request are in `docs/missing_pdfs.md`.

| report_id | DOI | Status | Why it matters |
|---|---|---|---|
| `killackey2019` | `10.1192/bjp.2018.191` | **held** | Parent trial report for `eppic_ips_rct`, previously represented only by `clarke2023`, its quality-of-life paper |
| `chan2020` | `10.1192/bjp.2019.161` | **held** | Ten-year employment is the stated outcome. Chan SKW is the Hong Kong EASY group, so probably `hk_easy_2001` |
| `benson2022` | `10.4088/PCC.21m03173` | outstanding | Same Janssen group and same VHA database as `lin2022`, restricted to relapse. Probable overlapping sample |

Both retrieved reports remain `pending`: the PDF is held, but the eligibility
decision requires reading the full text and belongs to the extraction stage.

Absence was confirmed rather than inferred from filenames: all held PDFs were
opened with PyMuPDF and their first two pages searched for each DOI and title.
None matched.

**A second metadata error, in the opposite direction to the twumasi alias.**
`benson2022` was first entered as `lin2022b` on the strength of Crossref, PubMed
and Europe PMC, all of which list Lin D as first author. The article of record
prints **Benson C first and Lin D second**. All three indexes carry an author
order identical to the sibling BMC Psychiatry paper `lin2022`, so the deposited
metadata appears to have been copied from it. The `report_id` follows the article
of record. This is recorded in the manifest `notes` so the discrepancy is not
silently reversed by someone checking PubMed. It is a reminder that a registry
record is not the article: two of the three studies missing at this pass had
metadata that disagreed with their own title page.

**Six staged files were never on the screening list.** Five had their PDFs
removed from the folder on 11 August 2026; their manifest rows are retained, with
`source_available = no`, because deleting the rows would erase the audit trail
and the PRISMA flow needs the count.

| report_id | Manifest status | Disposition |
|---|---|---|
| `bjornsdottir2022` | include | PDF removed. Off the screening list |
| `mackinley2022` | include | PDF removed. Off the screening list |
| `peralta2025` | include | PDF removed. Off the screening list |
| `brown2022` | exclude, wrong_outcome | PDF removed. Off the screening list |
| `wang2020` | duplicate | PDF removed. Redundant copy of `wang2020b` |
| `delpiccolo2024` | exclude, wrong_population | PDF retained as evidence for a documented full-text exclusion |
| (`Sturup_et_al_2022.pdf`) | never had a row | Supplied then removed. Off the screening list |

Three of these were `include` in the manifest, so this is a real change to the
evidence set, not bookkeeping. They entered the folder without a documented
screening decision, which under PRISMA they cannot. They are recorded here and
stay off the screening list. The search is closed and the universe frozen, so there
is no search update to reassess them at: re-entry for any of them, and for the
Stürup report, requires a documented screening-list amendment under D10.1.

**One accepted divergence.** Spreadsheet row 79 records `twumasi2026` under its
medRxiv preprint DOI `10.64898/2026.01.07.26343585`, while the manifest holds the
published *Psychological Medicine* DOI. Same paper. This is an explicit,
documented exception in `scripts/check_folder.py`; every other DOI disagreement
is reported as a fault.

**One title variance, resolved.** Spreadsheet row 90 has no DOI and reads "First
episode psychosis integrative treatment: A 20-year experience in Tallinn,
Estonia". No such paper exists. The only publication from that group is Peebo et
al., *Nord J Psychiatry* 2022;76:207-14 (`10.1080/08039488.2021.1946139`, PMID
34275409), which is held as `peebo2022`. The spreadsheet title is a hand-typed
paraphrase, consistent with its blank DOI field.

**Screening eligibility is not extractability.** This distinction still holds, but the
way the manifest expressed it was wrong and was corrected on 12 August 2026 under D10.2.
It previously carried 21 studies as `exclude` with reason `no_extractable_data`, which
conflated failing the eligibility criteria with meeting every criterion and printing only
a percentage. The screening sheet marks all 90 reports `INCLUDE` and no report was ever
excluded at full text, so those 21 are now `include` and the manifest reads **80 include,
7 linked_report, 3 pending, 0 exclude**, matching the published PRISMA figure of 90.

Extractability is now carried by `report_quantifiable` instead, where the loss is visible
at the numerator gate rather than hidden in an exclusion. Stage F settled it by reading:
**27 of the 75 non-pilot reports yield no recoverable count.** Reading 90 against the
number of usable results as an error would misstate the PRISMA flow.

### Keeping this true

`scripts/check_folder.py` re-runs the whole check: it verifies the recorded
screening mapping is complete and one-to-one, that every manifest row claiming a
PDF has one whose SHA-256 still matches, that no PDF on disk lacks a row, and
that every held PDF yields extractable page-one text so an image-only scan is
caught before an extraction agent meets it. It exits non-zero and names the
studies at fault. Run it before every extraction batch.

At 11 August 2026 it reports 87 of 90 held and exits 1, naming the three missing
reports. It will exit 0 once they are supplied.
