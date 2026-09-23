# Employment Rates and Moderators in Psychosis

## Where this is up to

**Start with [`docs/handover.md`](docs/handover.md).** It states the current state, the
four open tasks in order, and the rules that are easy to get wrong.

Short version at 23 September 2026: extraction is merged (90 reports, 78 cohorts, 278
results). Every pool-determining field has been human-verified, the author window closed
on 27 August 2026 with its prespecified consequences applied, and PROSPERO version 5.0 was
submitted on 23 September 2026. **Provisional, pre-freeze** Bayesian fits exist for the two
horizons with at least two cohorts. They are stamped not for citation and are not findings;
see `docs/handover.md` for what stands between them and a definitive run.

Code and data for a systematic review and Bayesian meta-analysis of employment outcomes in people living with psychosis.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R](https://img.shields.io/badge/R-4.4.2-blue.svg)](https://cran.r-project.org/)

**PROSPERO registration:** [CRD420251008448](https://www.crd.york.ac.uk/PROSPERO/view/CRD420251008448)

## Status

**Work in progress. Nothing in this repository is a finding.**

The extraction is merged and verified at the field level, and the pipeline has produced **provisional, pre-freeze** posteriors in `results/provisional_*`, fitted from a tagged, clean commit. Every table carries `result_status` reading `PROVISIONAL, PRE-FREEZE - NOT FOR CITATION` beside `sample_status` reading `DEFINITIVE EXTRACTION IN PROGRESS - NOT FOR INFERENCE`. No pooled employment rate or moderator estimate may be quoted.

Outstanding before a definitive run. Full detail in [`docs/handover.md`](docs/handover.md):

1. **Authorship-group rulings**: eligibility of a high-security forensic cohort for the long-term horizon, and ratification of the post hoc leave-one-cohort-out analysis (D15); whether an author-supplied Finnish register series, by year from first hospitalisation, can take landmark horizons.
2. **Risk-of-bias verification** (tier 5 of `data/extraction_provenance.csv`), needed before any risk-of-bias analysis, GRADE or interpretation.
3. **The input freeze**: `sample_status` set to `full`, a freeze tag, and a definitive run under the guard in `R/lib_config.R`.

Two decisions taken during Stage F **admit** evidence and were made after the affected results were seen. Both are recorded as such rather than presented as prospective: **D13** (the 50 per cent diagnosis rule is sufficient on its own) and **D14** (partition sums across mutually exclusive subgroups). They differ in where the evidence lands, and the difference matters: **D13 admits rows to the primary pool; D14 does not.** D14's derived rows are a period-prevalence result and two secondary-family results, so no row enters the primary pool by virtue of D14. See [`docs/methods_deviations.md`](docs/methods_deviations.md).

## Authors

Ricardo Twumasi¹ (guarantor), Wing Yan Vivian Tsang¹, Sebastian Kirdar-Smith¹, Jenny Yiend¹, James Hunter MacCabe¹, Thomas Pollak¹, Stefania Tognin¹, Udita Iyengar¹, Oliver Howes¹, Prachee Bagri¹, Tatiana Starikova¹, Lisa Blaco¹

¹ Department of Psychosis Studies, Institute of Psychiatry, Psychology and Neuroscience, King's College London

Corresponding author: ricardo.twumasi@kcl.ac.uk

## What the review estimates

Two questions, synthesised separately and never combined. Full reasoning in [`docs/statistical_analysis_plan.md`](docs/statistical_analysis_plan.md).

**Primary, prevalence.** Among people with a schizophrenia spectrum disorder or first-episode psychosis recruited into a longitudinal sample without employment-related selection, what proportion are in any paid employment at a follow-up landmark of at least twelve months, under the care received? A trial-derived result can contribute only as a verified whole cohort, never as an allocated arm.

**Secondary, intervention effect.** What is the effect of an intervention on employment compared with its concurrent control, preserving the within-study randomised comparison?

Four decisions shape every output:

- **Only any paid employment is primary.** Competitive-only and sheltered-only results are separate subtypes and cannot substitute for an any-paid numerator.
- **Education and training are retained but not counted as paid employment.** EET, education, training and unpaid vocational activity are separate registered outcome families because they measure vocational or educational participation rather than labour-market participation. At least 15 included reports use a work-or-education composite.
- **The unit of analysis is the cohort, not the publication.** Twelve cohorts in this evidence base produced more than one report: the JUMP vocational programme appears five times and the Hong Kong EASY cohort four times. Treating reports as independent would count the same participants repeatedly and narrow every interval.
- **A twelve-month landmark**, not each cohort's longest follow-up. One cohort's longest is 12 months and another's is 20 years, so pooling the longest available mixes horizons according to publication practice rather than design.

## Repository layout

```
config/analysis.yml          every scientific constant, hashed into the analysis id
config/vocabularies.yml      the controlled vocabularies, read by the validator
config/codebook.md           how to fill in the extraction tables
config/prompts/              the versioned extraction prompts, hashed into the ledger
data/inclusion_manifest.csv  one row per screened report, with its cohort mapping
data/extraction_*.csv        the five linked extraction tables (PILOT ONLY so far)
data/stage_f_shards/         the 13 Stage F shards, verified and NOT yet merged
data/batch_ledger.csv        which model, prompt and PDF hashes produced each shard
data/extraction_provenance.csv  the human-verification ledger. Empty
scripts/                     idempotent migrations, the folder gate, the shard gate
R/                           libraries, numbered pipeline scripts, and the runner
tests/testthat/              tests that encode why each rule exists
docs/                        handover, analysis plan, deviations, QA report, reconciliation
results/run_<id>/            tables, diagnostics and a run manifest
```

Source PDFs, theses and screening material are deliberately **not** in version control. Most of it is copyright and this repository is public.

## Reproducing

Requires R 4.4.2 or later, a working C++ toolchain and CmdStan.

```r
install.packages(c("brms", "cmdstanr", "posterior", "metafor", "yaml",
                   "digest", "testthat", "priorsense"))
cmdstanr::install_cmdstan()
```

From the repository root:

```sh
Rscript R/01_validate_data.R .                          # validate the extraction tables
Rscript R/00_run_all.R                                  # full pipeline
Rscript -e 'testthat::test_dir("tests/testthat")'       # tests
```

`R/01_validate_data.R` is also the self-service check for anyone doing extraction. Run it before committing data. It stops on the first violation and names the column, the row and the permitted values.

The pilot run takes about 15 seconds. The **full** fit inventory, including prior grids, cross-validation and 200-replicate simulation scenarios, has not been benchmarked, and no runtime claim is made for it.

## Methods in brief

The primary model is a binomial-logit random-effects meta-analysis fitted with `brms` and Stan:

```r
n_employed | trials(n_outcome_observed) ~ 0 + Intercept + (1 | cohort_id)
```

The binomial likelihood is exact on counts, which matters because this evidence base genuinely contains zero-event cohorts: one 20-year forensic follow-up found nobody in paid employment. A weakly informative `normal(-1.1, 0.8)` prior on the intercept corresponds to a pooled proportion of 0.25 with a 95 per cent prior interval of 0.065 to 0.615.

Bayesian estimation is primary, a departure from the registered protocol documented with its rationale in [`docs/methods_deviations.md`](docs/methods_deviations.md). An exact-likelihood frequentist fit (`metafor::rma.glmm`) is reported alongside as a **diagnostic comparison, not a gate**: different likelihood approximations and priors can legitimately differ, and in the pilot they did, by 0.08 on the pooled proportion at k = 2.

## Licence

MIT. See [`LICENSE`](LICENSE).
