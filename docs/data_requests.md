# Outstanding data requests

The registered protocol commits to this: "Authors will be asked to provide any required data not available in published reports." This file lists what to ask for and from whom.

**Status at 5 August 2026:** three supplements were supplied locally and two are now fully resolved. Twenty-one reports still lack a recoverable numerator or denominator.

---

## Resolved from supplements

| Report | What the supplement gave | Now |
|---|---|---|
| `lin2026` | Table S3, observed-case employment counts at every visit: month 12 121/303, month 15 119/289, month 18 127/280 | **Included.** Point prevalence. Note the denominators are completers, so attrition is informative and the available-case assumption is doing real work here |
| `jirapramukpitak2022` | Table S3, one-year employment: early stage 146/372 and later stage 43/177, total 189/549 | **Included.** Period prevalence (12-month earnings), so it enters the period-prevalence sensitivity rather than the primary pool |

## Partially resolved, still needs a request

### `hakulinen2019` (Danish registers, born 1955-1991, schizophrenia diagnosed 15-25)

The supplement supplies **exact denominators** (Appendix Table 1: 9,444 with employment data at age 25, falling to 364 at age 59) and **not-employed percentages rounded to whole numbers** (Appendix Table 2: 87 per cent at age 25).

That is not enough. Back-calculating the numerator from a whole-number percentage on a denominator of 9,444 carries a rounding uncertainty of roughly plus or minus 47, whereas the binomial standard error of the count at that proportion is about 33. **The reconstruction error would exceed the sampling error it replaces**, and the model would then treat a fabricated count as exact. Codebook rule 2 applies.

**Ask:** the exact number employed at each age, for the schizophrenia group, corresponding to Appendix Table 1's denominators.

**But note:** the outcome is the AKM annual "most important employment status", which is period prevalence over a year. Even with exact counts this report sits outside the primary point-prevalence pool and would contribute only to the period-prevalence sensitivity. Weigh the request accordingly.

---

## Remaining 21 reports without extractable counts

Grouped by what is actually needed, because the ask differs.

### A. Counts almost certainly exist in a supplement or can be released directly

Highest value, lowest effort. All are otherwise eligible.

| Report | Cohort | What to ask for |
|---|---|---|
| `falk2016` | Stockholm County 2005-06 registers | Crude employed counts and denominators by year; the paper prints only age-standardised non-employment rates |
| `solmi2022` | Swedish registers 2006-16 | Employed counts and the denominator at each year relative to diagnosis; Figure 1 percentages only |
| `topor2019` | Stockholm County 2000-04 | Counts with salary income at year 10 for the full working-age cohort, not just the two subgroups |
| `lin2022` | US Veterans Health Administration | Employment counts behind the unemployment percentages in the figure, and the ascertainment window |
| `blackman2025` | NIMH intramural | Employed count behind "45.2 per cent of 124" |
| `peebo2022` | Tallinn FEP | Employed counts at each follow-up behind the percentages, and at the 10-year registry follow-up |
| `rodriguezpulido2021` | Tenerife CR trial | Arm-level counts behind 60.9 per cent and 37.5 per cent |
| `fulford2018` | RAISE-ETP | Numerators and denominators for the SURF work-or-school variable at 6 and 12 months, ideally with work separated from school |

### B. Employment measured only as a duration or a score, so no prevalence exists to request

An author request here means asking them to compute something they did not report. Lower yield, but worth it for the large cohorts.

`wang2020b`, `wang2020c` (Yuli Hospital: cumulative work months), `chan2022` (Hong Kong EASY: mean months employed over 10 years), `shimada2022` (SFS employment subscale score), `klungsyr2021` (mean weekly hours), `majuri2023` (latent-class trajectories), `jones2024` (ordinal work-performance scores).

**Ask:** the number employed at a defined timepoint, with its denominator, if the underlying data permit.

Note that `chan2022`, `klungsyr2021`, `majuri2023` and `jones2024` belong to cohorts already represented by another included report (`chang2016`, `evensen2017`/`gjerdalen2023`, `rautio2016`/`majuri2021`, `harrow2017` respectively), so recovering them adds timepoints rather than cohorts.

### C. Model-based estimates only

`greenwood2025` (EYE-2, adjusted mean days from imputed data in a consenting economic subsample of 232 of 1,027) and `tsiachristas2016` (probability ratio only, denominator restricted to those unemployed at baseline).

**Ask:** observed employment counts and denominators by arm at 12 months. For EYE-2, note the trial is cluster-randomised, so any pooled analysis needs the cluster-adjusted estimate rather than raw counts.

### D. No employment measure exists

`brown2022` (headspace: SOFAS and My Life Tracker only) and `stouten2019` (PSP work-and-study problem severity only). No request worth making. `brown2022`'s cohort is covered by `andersen2024` in any case.

### E. Employment not separable from a composite

`chang2016b` (component of composite functional remission). Its cohort is covered by `chang2016`.

---

## Draft request template

> Dear Dr [name],
>
> We are conducting a systematic review and meta-analysis of employment outcomes in psychosis, registered on PROSPERO as CRD420251008448. Your study [citation] meets our inclusion criteria.
>
> Our primary outcome is the proportion in paid employment at a defined follow-up point. Your paper reports [what it reports], from which we cannot recover a numerator and denominator. We would rather not reconstruct counts from rounded percentages, since that introduces error we cannot quantify.
>
> Would you be able to provide the number of participants in paid employment, and the number whose employment status was observed, at [timepoint]? If your measure combines employment with education or training, figures for paid employment alone would be especially valuable, though we would gladly take the composite as well.
>
> We are happy to acknowledge your contribution and to share the synthesis before submission.
>
> With thanks,
> [name] on behalf of the review team

---

## Recording the outcome

Every request and its outcome goes in `data/inclusion_manifest.csv` under `notes`, using the prefix `DATA REQUEST` followed by the date and the result. A report whose authors decline or do not reply stays `no_extractable_data`, and the count of such reports is reported in the PRISMA flow and in the missing-evidence assessment. Reports lost for want of a numerator are a form of missing evidence and are treated as one, not quietly dropped.
