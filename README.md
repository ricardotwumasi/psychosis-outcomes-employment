# Employment Rates and Moderators in Psychosis

Code and data for a systematic review and Bayesian meta-analysis of employment outcomes in people living with psychosis.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R](https://img.shields.io/badge/R-4.4.2-blue.svg)](https://cran.r-project.org/)

**PROSPERO registration:** [CRD420251008448](https://www.crd.york.ac.uk/PROSPERO/view/CRD420251008448)

## Status

**Work in progress. Nothing in this repository is a finding.**

What exists is the extraction schema, the analysis plan and the pipeline, proved end to end on a deliberately non-representative 15-report pilot. The full synthesis has not been run. Every result file carries a `sample_status` column reading `PURPOSIVE PILOT - NOT FOR INFERENCE`, and no pooled employment rate or moderator estimate from it may be quoted.

Four things are outstanding before a definitive analysis, tracked in [`docs/pilot_report.md`](docs/pilot_report.md) and [`docs/evidence_reconciliation.md`](docs/evidence_reconciliation.md):

1. **A decision on the primary pool rule.** The pilot showed the current rule excludes cohorts by study design when it should exclude them by whether the sample was selected on wanting to work.
2. **A screening export** (Rayyan or Covidence) to reconcile the 92 distinct reports found in the staged files against the PRISMA figure of 90.
3. **Author requests** for the 21 reports giving employment in a form with no recoverable numerator and denominator, drafted in [`docs/data_requests.md`](docs/data_requests.md).
4. **A search update.** The registered search closes 2 June 2025 and 2026 reports are already in the set. Submission of the amendment in [`docs/prospero_amendment_draft.md`](docs/prospero_amendment_draft.md) depends on it.

## Authors

Ricardo Twumasi¹ (guarantor), Wing Yan Vivian Tsang¹, Sebastian Kirdar-Smith¹, Jenny Yiend¹, James Hunter MacCabe¹, Thomas Pollak¹, Stefania Tognin¹, Udita Iyengar¹, Oliver Howes¹, Prachee Bagri¹, Tatiana Starikova¹, Lisa Blaco¹

¹ Department of Psychosis Studies, Institute of Psychiatry, Psychology and Neuroscience, King's College London

Corresponding author: ricardo.twumasi@kcl.ac.uk

## What the review estimates

Two questions, synthesised separately and never combined. Full reasoning in [`docs/statistical_analysis_plan.md`](docs/statistical_analysis_plan.md).

**Primary, prevalence.** Among people with a schizophrenia spectrum disorder or first-episode psychosis identified in an observational cohort, what proportion are in paid employment at a follow-up landmark of at least twelve months?

**Secondary, intervention effect.** What is the effect of an intervention on employment compared with its concurrent control, preserving the within-study randomised comparison?

Three decisions shape every output:

- **Education is not counted as employment** in the primary construct. Papers reporting "in work or education" are recorded under a separate construct, because that composite tracks a country's education system rather than its labour market. At least 15 included reports use the composite.
- **The unit of analysis is the cohort, not the publication.** Twelve cohorts in this evidence base produced more than one report: the JUMP vocational programme appears five times and the Hong Kong EASY cohort four times. Treating reports as independent would count the same participants repeatedly and narrow every interval.
- **A twelve-month landmark**, not each cohort's longest follow-up. One cohort's longest is 12 months and another's is 20 years, so pooling the longest available mixes horizons according to publication practice rather than design.

## Repository layout

```
config/analysis.yml          every scientific constant, hashed into the analysis id
config/vocabularies.yml      the controlled vocabularies, read by the validator
config/codebook.md           how to fill in the extraction tables
data/inclusion_manifest.csv  one row per screened report, with its cohort mapping
data/extraction_*.csv        the five linked extraction tables
R/                           libraries, numbered pipeline scripts, and the runner
tests/testthat/              tests that encode why each rule exists
docs/                        analysis plan, deviations, amendment, reconciliation, pilot report
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
