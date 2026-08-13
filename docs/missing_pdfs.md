# PDFs and supplements

> **Status 13 August 2026: extraction has since run without these.** The title formerly
> read "needed before extraction"; Stage F went ahead on 12-13 August and every report
> here was read from what was held. Nothing below blocked a read, but several items
> became the reason a count could not be recovered, so this file is now an input to the
> author queries rather than a prerequisite. Two findings from Stage F belong here:
> `hakulinen2019`'s Online Appendix is confirmed **absent** from the held PDF, so the
> "partially resolved" note below overstates what is in hand; and F08 re-retrieved
> `jirapramukpitak2022`'s Additional file 1 from Springer and verified its cells, with the
> SHA-256 logged in that shard.

## Supplement chase, 12 August 2026

Acquisition and provenance only: nothing was extracted, no eligibility was adjudicated,
and no newly found document was added to the evidence set. Full record in
`data/supplement_provenance.csv` (11 rows, SHA-256 for everything held).

### Retrieved

| Report | File | Note |
|---|---|---|
| `dayabandara2026` | `Dayabandara 2026 1-s2.0-S1876201826000158-mmc1.docx` | Supplementary File-1, DOI confirmed `10.1016/j.ajp.2026.104842`. Identity verified from its first line. **It is a statistical-methods appendix (CLMM/LMM specification) with no variable-definition section, so it probably does NOT define the Table 4 "Employed" category.** Inspected to heading level only |
| `dayabandara2026` | `Dayabandara 2026 1-s2.0-S1876201826000158-mmc2.zip` | A second supplement on the same PII, pairwise comparisons. Retrieved and hashed for completeness, not opened |

**Consequence:** `dayabandara2026`'s outcome construct stays `unclear`, and the
definition of "Employed" moves to the corresponding-author query list rather than being
resolvable from the supplement.

### Needs a human with a browser (free, no institutional access required)

Both are one click in a normal browser and were blocked only by bot protection, which
was not circumvented.

| Report | Where | Why the machine could not get it |
|---|---|---|
| `solmi2022` | `psychiatryonline.org/doi/suppl/10.1176/appi.ajp.21121189` | Cloudflare returns 403 to every non-browser client. The article cites Figures S4 and S5-S9, so the supplement **exists**. Highest-value item on this list |
| `fulford2018` | PMC5814802, `sbx096_suppl_supplementary_tables.doc` | PMC binaries sit behind a JavaScript proof-of-work challenge. Free, not paywalled |

### Needs institutional access

| Item | Status |
|---|---|
| **Fowler et al. 2009**, *Psychol Med* 39:1627-1636, `10.1017/S0033291709005467` | **Paywalled.** This is the ISREP parent trial paper, and `isrep_rct` cannot move off `employment_selection_status = unclear` without it. Worth knowing: Unpaywall, OpenAlex and Semantic Scholar all flag it green OA at Sussex figshare 23398958, but **that record holds zero files** and is a metadata-only stub, so all three are a false lead. UEA eprint 14137 is request-a-copy, 42826 is removed, no PMCID |

### Existence unverified, not confirmed absent

`peebo2022`, `rodriguezpulido2021`. Neither held full text contains a supplement
callout, but Taylor & Francis returns 403 on `/doi/suppl/`, so the negative could not be
confirmed. Recorded as `not_found`, deliberately **not** as `no_supplement_exists`.

### Confirmed to have no supplement

`falk2016`, `topor2019`, `lin2022`, `blackman2025` — each on two independent checks (no
callout in the held text, plus a publisher CDN probe validated against a live positive
control, or an absent `<supplementary-material>` element in the Europe PMC full-text
XML). **The group A author requests for these four stand as written**; there is no
supplement to recover the counts from.

---

# PDFs needed before extraction

**Status at 11 August 2026: complete. All 90 studies in
`DATA_EXTRACTION_FINAL.xlsx` are held and readable.**

`/opt/anaconda3/bin/python3 scripts/check_folder.py` exits 0.

This file is kept as the record of how the last three were obtained, and of two
metadata problems worth remembering.

---

## Obtained 11 August 2026

### Killackey et al. 2019, *British Journal of Psychiatry*

> Killackey E, Allott K, Jackson HJ, Scutella R, Tseng Y-P, Borland J,
> Proffitt T-M, Hunt S, Kay-Lambkin F, Chinnery G, Baksheev G, Alvarez-Jimenez M,
> McGorry PD, Cotton SM. Individual placement and support for vocational recovery
> in first-episode psychosis: randomised controlled trial.
> *Br J Psychiatry* 2019;214(2):76-82. `10.1192/bjp.2018.191`

Parent trial report for `eppic_ips_rct`, previously represented only by
`clarke2023`, its quality-of-life paper.

### Chan et al. 2020, *British Journal of Psychiatry*

> Chan SKW, Pang HH, Yan KK, Hui CLM, Suen YN, Chang WC, Lee EHM, Sham P,
> Chen EYH. Ten-year employment patterns of patients with first-episode
> schizophrenia-spectrum disorders: comparison of early intervention and standard
> care services. *Br J Psychiatry* 2020;217(3):491-497. `10.1192/bjp.2019.161`

Employment over ten years is the stated outcome. Chan SKW is the Hong Kong EASY
author group, so confirm whether this belongs to `hk_easy_2001`, whose four other
reports are all excluded as `no_extractable_data`. If it does, it may be the
report that brings that cohort into the synthesis.

### Benson et al. 2022, *Primary Care Companion for CNS Disorders*

> Benson C, Lin D, Kim H, Wada K, Aboumrad M, Powell E, Zwain G, Near AM.
> Unemployment, homelessness, and other societal outcomes among US veterans with
> schizophrenia relapse: a retrospective cohort study.
> *Prim Care Companion CNS Disord* 2022;24(5):21m03173. `10.4088/PCC.21m03173`

Not in PubMed Central or Europe PMC, no open-access copy, and the publisher
charges $40 for the typeset PDF. The full text is free to read on the article
page, so it was **printed to PDF from the page** rather than purchased. The five
figure and table images, which the print rendered only as links, were downloaded
separately and appended as pages 3 to 7 in the order Tables 1 to 3, then Figures
1 and 2. Each appended page carries a caption naming the item and its source
file. The original GIFs are kept in the `benson2022/` subfolder, which
`check_folder.py` ignores.

All three remain `eligibility_status = pending`: the PDF is held, but the
eligibility decision requires reading the full text and belongs to the extraction
stage.

---

## Two things worth remembering

### The indexes had the wrong first author

The Benson article of record prints **Benson C first and Lin D second**.
Crossref, PubMed and Europe PMC all list Lin D first, in an order
character-for-character identical to the sibling BMC Psychiatry paper `lin2022`,
so the deposited metadata appears to have been copied from it. The `report_id`
follows the article of record, which is why it is `benson2022` and not
`lin2022b`. Anyone checking PubMed will see a different first author; that is the
index's error, and it is recorded in the manifest `notes` so nobody silently
reverses it.

### A back-calculation that was not needed, and would have been wrong

Before the paper was obtained, this file estimated employment counts from the
percentages visible on the article page (unemployment 75.4 and 71.4 per cent,
n = 16,862 per cohort), and argued the reconstruction error would be acceptable
because at that denominator it is about ±8 against a binomial standard error of
about ±56.

**The arithmetic about rounding error was sound. The inference drawn from it was
not.** It treated the complement of unemployment as employment, giving roughly
4,148 and 4,823 employed. Table 3 shows employment status has six mutually
exclusive categories, and the complement of "unemployed" also contains "retired"
(15.8 and 17.1 per cent) and "missing data". The real figures are far lower:

| | Relapse | Non-relapse |
|---|---|---|
| Full-time | 577 | 908 |
| Part-time | 284 | 428 |
| Self-employed | 68 | 93 |
| **Derived `paid_any`** | **929** | **1,429** |
| Unemployed | 12,721 | 12,043 |
| Retired | 2,661 | 2,889 |
| Missing | 551 | 501 |
| Total | 16,862 | 16,862 |

Derived `paid_any` over observed status is 929/16,311 (5.7 per cent) and
1,429/16,361 (8.7 per cent), against the 24.6 and 28.6 per cent the earlier
complement-of-unemployment estimate implied. A four-fold error.

The lesson is codebook rule 2's, and it is stronger than the rounding argument
that nearly overrode it: the barrier to reconstructing a count is not only
rounding, it is not knowing what the residual category contains. No
back-calculation was needed in the end, because the paper prints exact counts
that sum to the denominator.

### A published inconsistency, for the author query list

Table 3's relapse column prints full-time employment as **5.4 per cent**, but
577/16,862 is **3.4 per cent**, and the printed relapse percentages sum to 102.0
rather than 100. The non-relapse column is internally consistent and its
full-time figure is genuinely 5.4 per cent, so the relapse percentage looks
copied from the column beside it. The counts are sound: both columns sum exactly
to 16,862.

Extract the counts, not the percentages, and add this to the corresponding-author
queries. Recorded in the manifest `notes` and in
`docs/evidence_reconciliation.md` section 4.

### Extraction cautions for `benson2022`

- **Cohort overlap.** Same Janssen group and same VHA database as `lin2022`,
  which is excluded as `no_extractable_data`. Very probably the same `us_vha`
  source population, so the two cannot both contribute.
- **Ascertainment.** VHA administrative employment status is usually recorded
  over a window, which is period prevalence and outside the primary pool.
- **Selection.** Cohorts are matched on relapse, not on employment, so
  employment-related selection is probably `none`, but the matching conditions
  the sample and must be recorded.
- **Derived count.** `paid_any` must be derived by summing full-time, part-time
  and self-employed. The categories are mutually exclusive and exhaustive and sum
  to the denominator, so this is permitted, but it requires
  `derivation_component_result_ids` and an independent check.
