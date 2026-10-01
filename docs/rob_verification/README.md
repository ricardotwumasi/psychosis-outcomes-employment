# Risk-of-bias source verification, 1 October 2026

This folder is the audit record for the tier 5 check of the risk-of-bias table. It says what was checked, by whom, what changed, and what the check does not cover.

## What was checked

All 1,491 domain judgements in `data/extraction_rob.csv` were compared with their source reports. They cover 182 of the 278 outcome records, from 62 reports.

| Block | File | Rows | Judgement retained | Judgement corrected |
|---|---|---|---|---|
| 1 | `verification_1.csv`, `review_1.md` | 496 | 419 | 77 |
| 2 | `verification_2.csv`, `review_2.md` | 496 | 434 | 62 |
| 3 | `verification_3.csv`, `review_3.md` | 499 | 451 | 48 |
| All | `adjudicated_verification.csv` | 1,491 | 1,304 | 187 |

The original judgement, the verified judgement and the source locator are kept for every row, so each of the 187 corrections can be traced.

## Who checked it

**Three AI verification agents, working on disjoint blocks, and a coordinating AI reviewer who accepted the results.** No human reviewed these judgements. This is not a second human review and must not be reported as one. The human verification of this review covers tiers 0 to 2, the pool-determining fields, and was done by a single reviewer.

## How the corrections reach the data

The corrections are rows in `data/result_corrections.csv` (table `extraction_rob`), applied by `scripts/merge_stage_g.py`. The merged table is never edited by hand. The verification record for each row is in `data/extraction_provenance.csv` at tier 5.

Source locators name each report's file under `dissertation_shared_folder/Data Extraction Papers/`. That folder holds copyright material and is not in this repository.

## What the check does not cover

1. **Outcomes with no appraisal.** `unappraised_results.csv` lists the 96 outcome records that had no linked appraisal on 1 October 2026: 69 reported results, 22 component-only fragments and 5 derived results. A complete check of the existing rows says nothing about these.
2. **Comparative-tool records.** `effect_tool_record_gaps.csv` lists 438 rows held under RoB 2 (246) and ROBINS-I (192). Of these, 410 have no signalling-question record. RoB 2 and ROBINS-I appraise an intervention effect; they do not appraise a single-arm proportion. These rows are not used in any synthesis in this review.
3. **Sample-size adequacy.** JBI item 3 has no review-wide precision criterion, so 117 accepted judgements on it are provisional.

## A coding difference between the files

`verification_2.csv` records agreement as `yes` or `no`. The other two blocks use `agree` or `disagree`. `adjudicated_verification.csv` uses `agree` or `disagree` throughout. The block files are kept as produced; use the adjudicated file for any count.

## Appraisals added for pooled results

After the check above, every result that enters a primary or sensitivity pool was compared with the appraisal table. One had no appraisal: `thomson2023_cohort_t240m_paidany`, the forensic cohort in the long-term pool. It was appraised on 1 October 2026.

- **Appraisal:** the nine JBI prevalence items, by an AI assessor reading the whole paper. The rows are in `data/rob_additions.csv`, which the merge appends to `data/extraction_rob.csv` on every run.
- **Verification:** a second AI agent read the paper independently and agreed with all nine judgements. It found two unsupported statements in the rationales, which were corrected before the rows were entered. The record is `verification_thomson2023.csv`.
- **Judgements:** sampling yes; coverage no; response rate no; the other six unclear. The paper gives no definition, source or reference period for the employment item, and the result rests on 56 of about 152 surviving cohort members.
- **A provenance limit:** the paper's Table 1 gives 66 consenting participants. The denominator of 56 comes from the author's reply, and the paper does not explain the difference.

So the table now holds 1,500 rows, and 95 outcome records remain unappraised, none of which enters a pool. `unappraised_results.csv` is kept as the list at the time of the check and still names the Thomson result.

The Finnish schizophrenia series enters the post hoc interval-aware sensitivity (D16) at years +5 and +10. Its year 0 result already had an appraisal. `hakulinen_author_series_appraisal.md` records, item by item, whether that appraisal carries to the later years. It does, except for item 5 (coverage), which changes from yes to unclear: the denominator falls from 6,939 to 5,297 and 3,801, and the paper does not say why.

None of this is human verification.
