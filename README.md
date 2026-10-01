# Employment Rates and Moderators in Psychosis

## Where this is up to

**The analysis is final as of 1 October 2026.** Start with [`docs/handover.md`](docs/handover.md): it
states what is definitive, how the results must be read, how to reproduce them, and what is
still open.

Short version: the inputs are frozen at the tag `input-freeze-2026-10-01` (90 reports, 78
cohorts, 278 results), and the definitive Bayesian fits are in `results/run_ee868e185b4b/`
at the tag `definitive-fit-2026-10-01`. An independent statistical review recomputed the
posteriors by two other methods and asked for no rerun.

Code and data for a systematic review and Bayesian meta-analysis of employment outcomes in people living with psychosis.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R](https://img.shields.io/badge/R-4.4.2-blue.svg)](https://cran.r-project.org/)

**PROSPERO registration:** [CRD420251008448](https://www.crd.york.ac.uk/PROSPERO/view/CRD420251008448)

## Status

**Definitive results exist, and they are thin.** Of 78 cohorts, 11 report the point prevalence
of any paid employment in a whole cohort with no employment-related selection, and five of
those report it at a landmark from cohort entry. Read every figure below with
[`docs/handover.md`](docs/handover.md); the wording matters more than the numbers.

| Horizon | Cohorts | What the data show |
|---|---|---|
| 12 months | 2 | 287/456 (62.9%) and 53/107 (49.5%), both from one research group in Maharashtra, India (hospitals in Pune and Ahmednagar). Pooled posterior median 53% (95% CrI 29 to 66), drawn below the crude 60% mainly by the prior. |
| 24 months | 0 | No estimate. |
| 5 years | 0 | No estimate. Post hoc (D16): one Finnish register cohort, 552/5,297 (10.4%), which is one cohort's proportion and not a meta-analysis. |
| 10 years or more | 3 | 35/65, 23/62 and 0/56. Pooled 23% (9 to 45). Post hoc (D15): 42% (24 to 57) without the forensic cohort. Post hoc (D16): 20% (9 to 38) with the Finnish cohort added. |

Neither pooled figure is a prevalence for people with psychosis in general. The 12-month pool
is three clinics in two neighbouring districts, reported by one research group, and both cohorts qualify only under D13. The long-term pool mixes early intervention, adolescent inpatient
and high-security forensic cohorts and has no single target population. The certainty of both
is very low.

What a reader should know about how the data were checked:

- **Pool-determining fields** were verified against the source reports by one human reviewer.
- **Risk-of-bias judgements** were checked against their sources by AI agents, not by a second
  human. Every result in a pool is appraised; 95 results outside the pools are not. See
  [`docs/rob_verification/README.md`](docs/rob_verification/README.md).
- **Author requests** were sent for 80 reports. Ten were answered.

Four decisions were made after the affected data or results had been seen, and each is
recorded as such in [`docs/methods_deviations.md`](docs/methods_deviations.md). **D13** (the
50 per cent diagnosis rule is sufficient on its own) admits rows to the primary pool. **D14**
(partition sums across mutually exclusive subgroups) admits none. **D15** (leave-one-cohort-out)
and **D16** (interval-aware timing for an author-supplied register series) are post hoc
analyses that change no primary pool and replace no primary estimate.

## Authors

Ricardo Twumasi¹ (guarantor), Wing Yan Vivian Tsang¹, Sebastian Kirdar-Smith¹, Jenny Yiend¹, James Hunter MacCabe¹, Thomas Pollak¹, Stefania Tognin¹, Udita Iyengar¹, Oliver Howes¹, Prachee Bagri¹, Tatiana Starikova¹, Lisa Blaco¹

¹ Department of Psychosis Studies, Institute of Psychiatry, Psychology and Neuroscience, King's College London

Corresponding author: ricardo.twumasi@kcl.ac.uk

## What the review estimates

Two questions, synthesised separately and never combined. Full reasoning in [`docs/statistical_analysis_plan.md`](docs/statistical_analysis_plan.md).

**Primary, prevalence.** Among people with a schizophrenia spectrum disorder or first-episode psychosis recruited into a longitudinal sample without employment-related selection, what proportion are in any paid employment at a follow-up landmark of at least twelve months, under the care received? A trial-derived result can contribute only as a verified whole cohort, never as an allocated arm.

**Secondary, intervention effect.** What is the effect of an intervention on employment compared with its concurrent control, preserving the within-study randomised comparison?

Four decisions shape every output:

- **Only any paid employment is primary.** It includes paid supported and paid sheltered work. Competitive-only and sheltered-only results are separate subtypes and cannot substitute for an any-paid numerator.
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
data/extraction_*.csv        the five linked extraction tables, merged; never edited by hand
data/stage_f_shards/         the 13 immutable Stage F shards the merge is built from
data/result_corrections.csv  every post-merge correction, with its authority
data/rob_additions.csv       risk-of-bias appraisals made after the batches ran
data/author_supplied_counts.csv  the Finnish register series, read only by the D16 sensitivity
data/batch_ledger.csv        which model, prompt and PDF hashes produced each shard
data/extraction_provenance.csv  the field-level verification ledger, 6,782 rows
scripts/                     the merge, idempotent migrations, the folder gate, the shard gate
R/                           libraries, numbered pipeline scripts, and the runner
tests/                       tests that encode why each rule exists (R and Python)
docs/                        handover, analysis plan, deviations, QA report, reconciliation
results/run_ee868e185b4b/    the definitive tables, diagnostics and run manifest
results/provisional_*/       the 23 September pre-freeze fits, kept as the record
results/design_package/      pools and attrition at every horizon; fits nothing
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
git checkout input-freeze-2026-10-01
Rscript R/01_validate_data.R .                          # validate the extraction tables
Rscript tests/testthat.R                                # R tests
python3 -m unittest tests/test_merge_stage_g.py         # merge tests
DEFINITIVE_RUN=yes Rscript R/00_run_all.R               # the definitive fits
```

The runner refuses to sample unless a mode is set, the worktree is clean and a tag points at
`HEAD`; the modes are described in [`docs/handover.md`](docs/handover.md). With no mode set,
`Rscript R/00_run_all.R` validates and stops before sampling.

`R/01_validate_data.R` is also the self-service check for anyone doing extraction. Run it before committing data. It stops on the first violation and names the column, the row and the permitted values.

The definitive run fits 23 models and took about three minutes on a laptop. The 200-replicate simulation study in `config/analysis.yml` has not been run and is listed there as deferred.

## Methods in brief

The primary model is a binomial-logit random-effects meta-analysis fitted with `brms` and Stan:

```r
n_employed | trials(n_outcome_observed) ~ 0 + Intercept + (1 | cohort_id)
```

The binomial likelihood is exact on counts, which matters because this evidence base genuinely contains zero-event cohorts: one 20-year forensic follow-up found nobody in paid employment. A weakly informative `normal(-1.1, 0.8)` prior on the intercept corresponds to a pooled proportion of 0.25 with a 95 per cent prior interval of 0.065 to 0.615.

Bayesian estimation is primary, a departure from the registered protocol documented with its rationale in [`docs/methods_deviations.md`](docs/methods_deviations.md). An exact-likelihood frequentist fit (`metafor::rma.glmm`) is reported alongside as a **diagnostic comparison, not a gate**: different likelihood approximations and priors can legitimately differ, and in the pilot they did, by 0.08 on the pooled proportion at k = 2.

## Licence

MIT. See [`LICENSE`](LICENSE).
