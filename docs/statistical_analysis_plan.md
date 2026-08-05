# Statistical analysis plan

**Review:** Employment Rates and Moderators in Psychosis: A Systematic Review and Meta-Analysis
**Registration:** PROSPERO [CRD420251008448](https://www.crd.york.ac.uk/PROSPERO/view/CRD420251008448)
**Version:** 0.1 draft, 5 August 2026
**Status:** DRAFT. Not yet approved by the authorship group. No outcome extraction beyond the non-inferential pilot may begin until this document is approved and the corresponding PROSPERO amendment is submitted.

This plan is written before the outcome data exist. Only one study row and a 15-report engineering pilot are available at the time of writing, and no pooled estimate has been computed. Any decision taken after seeing pooled results will be recorded separately in `methods_deviations.md` and labelled post hoc.

---

## 1. Why this document exists

The registered protocol specifies a random-effects meta-analysis of the pooled proportion employed. It does not, on its own, determine an analysable estimand. Five questions are left open, and each of them changes the headline number:

1. Whose employment rate is being estimated: people with psychosis in a defined population, or people who consented to a vocational trial?
2. What counts as employment: any paid work, competitive work only, or paid work and education together?
3. Employment when: at a fixed horizon, or at whatever the longest follow-up in each report happens to be?
4. Employment among whom: everyone entering the cohort, everyone still alive and traceable, or everyone whose employment status was actually observed?
5. What is one observation: one publication, or one group of participants?

Answering these after seeing the data would make the review unfalsifiable. They are answered here.

---

## 2. Estimands

Two separate questions are synthesised separately. They are not combined into one model, and neither is presented as evidence for the other.

### 2.1 Primary estimand: employment prevalence in psychosis cohorts

> Among people with a schizophrenia spectrum disorder or first-episode psychosis identified in an observational cohort, what proportion are in paid employment at a defined follow-up landmark of at least twelve months?

Trial participants are **excluded** from this estimand. A person randomised into a vocational intervention trial has typically been required to be unemployed, to want to work, to be clinically stable, and to consent to a service. Their employment rate is conditioned on that selection and is not an estimate of employment in the underlying population. Control and treatment-as-usual arms are therefore not pooled with observational cohorts by default. They may be added in a named sensitivity analysis, but only after a written comparability review of their eligibility criteria, and the sensitivity result is reported alongside the primary rather than in place of it.

This is a change from the earlier working assumption that observational cohorts and control arms could share a pool.

### 2.2 Secondary estimand: intervention effect on employment

> Among people with psychosis enrolled in a randomised or non-randomised trial of a vocational, psychological or service-level intervention, what is the effect of the intervention on employment compared with its concurrent control, at matched follow-up?

This preserves the within-study comparison. Pooling all intervention arms against all non-intervention arms across studies discards randomisation and confounds the intervention with whatever distinguishes trials that offer it, so no such arm-class comparison is interpreted causally anywhere in this review.

### 2.3 Registered outcomes not covered by either estimand

Job tenure, relationship status, wages and social functioning are registered outcomes. Each is designated here so that none disappears silently:

| Registered outcome | Designation in this plan |
|---|---|
| Employment status | Primary, both estimands above |
| Job tenure | Separate synthesis if at least ten cohorts report a comparable duration measure; narrative otherwise |
| Wages earned | Narrative only. Currencies, years and definitions are not commensurable without a purchasing-power adjustment that the review has not registered |
| Relationship status | Narrative only |
| Social functioning metrics | Narrative only. Instruments are too varied to pool without a crosswalk |

---

## 3. Outcome construct

### 3.1 Primary construct

**Point-prevalence paid employment.** Work for pay, whether competitive, supported or sheltered, held at the landmark timepoint.

**Education and training are not counted as employment in the primary construct.** This matters concretely: the one row currently in the repository (`sturup2022`) defines its outcome as "work as primary income source or registered student", which is a different construct and cannot enter the primary estimate as recorded.

### 3.2 Constructs recorded separately

Each is extracted where reported and analysed as its own outcome, never merged into the primary:

- **Competitive employment only** (open labour market, at or above minimum wage, not set aside for people with disabilities). Reported as a secondary pooled estimate where at least ten cohorts supply it.
- **Supported or sheltered employment.**
- **Employment or education combined**, which is what many first-episode services report. Recorded because it is common, analysed separately because it is not the primary construct.
- **Broad vocational activity**, including unpaid and voluntary activity.

A report frequently supplies several of these for one arm and timepoint. The extraction schema therefore stores one row per result, not one categorical outcome column per arm, so no valid outcome is discarded to fit the table.

### 3.3 Ascertainment

Only **point prevalence** enters the primary estimate. Three other ascertainment types are recorded and excluded from it:

| Ascertainment | Meaning | Primary pool |
|---|---|---|
| `point_prevalence` | Employed at the landmark | Included |
| `period_prevalence` | Employed during a defined window, for example a tax year | Excluded, named sensitivity |
| `any_time_during_followup` | Ever employed across follow-up | Excluded, reported separately |
| `unclear` | Cannot be determined from the report | Excluded, counted in the flow |

`period_prevalence` is a separate level rather than being folded into either neighbour because national registers routinely report employment over a tax year, and silently treating that as point prevalence would inflate the pooled estimate by an unknown amount.

---

## 4. Timepoint

The primary analysis uses a **twelve-month landmark**: for each cohort, the reported timepoint closest to 12 months within a window of **9 to 18 months**. If no timepoint falls in that window the cohort does not contribute to the primary estimate, and it is counted as such in the flow diagram.

Additional prespecified horizons, each analysed as its own model and reported alongside:

| Horizon | Window |
|---|---|
| 24 months | 18 to 30 months |
| 5 years | 48 to 78 months |
| 10 years or more | 108 months and above |

Rationale. Taking each cohort's longest available follow-up does not create a common horizon: one cohort's longest is 12 months and another's is 20 years, so the pooled estimate would mix horizons in a way determined by publication practice rather than by design. It also selects on which cohorts retained participants long enough to publish long-term results. A landmark fixes the horizon; the separate horizons then show how employment changes with time, which is the substantive question. This is also closer to the registered plan to extract multiple timepoints and analyse them separately.

A longitudinal model using all timepoints simultaneously, with follow-up time as a covariate and within-cohort dependence modelled, is a possible secondary analysis. It will be attempted only if at least ten cohorts contribute two or more timepoints, and it is exploratory.

---

## 5. Unit of evidence and dependence

**The unit of analysis is the cohort, not the publication.** The random effect groups on `cohort_id`.

A cohort is one identified group of participants. One cohort can generate many publications: OPUS, AESOP, RAISE, the Chicago Follow-up Study, the Northern Finland Birth Cohort and the Nordic national registers all do. One publication can also describe more than one cohort.

Rules, in order:

1. Every report is mapped to a `cohort_id` in `data/inclusion_manifest.csv` before any result is selected. The mapping is printed for human review and is never inferred silently.
2. Where several reports describe one cohort at one horizon, **one result is selected**, by this prespecified order: (a) the report whose analysis population is largest at that horizon; (b) if tied, the report with the outcome construct closest to the primary; (c) if still tied, the earliest publication. The reports not selected are named in the output, not dropped invisibly.
3. Where one cohort legitimately contributes several non-overlapping results at one horizon, for example two subgroups whose combined count is not recoverable, the dependence is modelled explicitly with a nested term.

There is no minimum number of multi-result cohorts below which dependence may be ignored. Dependence is a property of the design, not of how many clusters happen to be available to estimate a variance component. Where a variance component cannot be estimated, a result is selected or aggregated prospectively under rule 2; the dependence is never simply left unmodelled.

---

## 6. Denominators and missing outcome data

Five counts are recorded separately for every result, because a proportion computed on each answers a different question:

| Field | Definition |
|---|---|
| `n_entered` | Randomised, or entering the cohort at baseline |
| `n_alive_eligible` | Alive and still meeting eligibility at the landmark |
| `n_assessed` | Approached and assessed for employment status at the landmark |
| `n_outcome_observed` | Employment status actually observed and used in the report's own analysis |
| `n_employed` | Employed at the landmark, by the stated construct |

**The primary analysis is available-case, with `n_outcome_observed` as the denominator.** The model is `n_employed | trials(n_outcome_observed)`. The field is named for the estimand rather than called `n_analysed`, so a reader cannot mistake which denominator is in use.

Attrition is **not** derived as `n_entered` minus `n_outcome_observed`. Death, emigration, loss of linkage, ineligibility and non-response are conceptually distinct, and a single derived attrition figure hides which occurred. Each report's own account is recorded in `missing_data_method` and `denominator_basis`.

Prespecified missing-outcome sensitivity analyses:

1. **Complete-cohort worst case:** all participants with unobserved status treated as not employed, denominator `n_alive_eligible`. This is the pessimistic bound.
2. **Complete-cohort best case:** all unobserved treated as employed, same denominator. The optimistic bound.
3. **Attrition as a moderator:** the proportion unobserved entered as a continuous moderator.

Available-case analysis assumes employment status is missing at random conditional on the cohort. That assumption is stated in the manuscript, not left implicit, and the bounding analyses show what it is worth.

---

## 7. Population

A cohort is eligible for the primary estimand only if all of the following are recorded and satisfied:

- A schizophrenia spectrum disorder or first-episode psychosis, ascertained by a stated diagnostic criterion (ICD, DSM or RDC) or by a register diagnosis code recorded in the extraction.
- At least 50 per cent of the sample has a qualifying psychosis diagnosis, or a qualifying subgroup can be extracted separately.
- Psychosis is not secondary to a medical condition such as encephalitis or epilepsy.

Recorded for every cohort so that eligibility can be checked rather than asserted: `diagnostic_instrument`, `diagnosis_confirmed` (how), `perc_qualifying_diagnosis`, `first_episode` (yes/no/mixed), `subgroup_extractable`.

Clinical high risk (`chr`) and mixed severe mental illness (`smi_mixed`) samples are **not** admitted to the primary pool merely for being valid vocabulary values. `chr` cohorts are excluded from the primary estimand entirely. `smi_mixed` cohorts enter only when a psychosis subgroup is separately extractable.

---

## 8. Risk of bias

Risk of bias attaches to a **result and its estimand**, not to a publication. A single overall study-level rating is not recorded.

| Evidence type | Instrument |
|---|---|
| Prevalence estimate from an observational cohort | **JBI critical appraisal checklist for prevalence studies** (9 items) |
| Effect estimate from a randomised comparison | **Cochrane RoB 2** |
| Effect estimate from a non-randomised intervention study | **ROBINS-I** |

Neither RoB 2 nor ROBINS-I is designed for a prevalence estimate, so neither is used for the primary estimand. This corrects the registered record, which names RoB 2 alone for a predominantly observational review.

The existing risk-of-bias table in the MSc supplementary material applies the RoB 2 category `Some concerns` to quasi-experimental studies assessed with ROBINS-I. Those judgements mix two instruments' response scales and **are not migrated**. All risk-of-bias assessment is redone under this plan.

Each assessment records: instrument and version, the specific result assessed, domain, signalling-question responses where the instrument has them, judgement, free-text rationale, source location, assessor, and checker. Instrument-specific categories are never collapsed into a shared numeric scale.

---

## 9. Moderators

### 9.1 Thresholds

No meta-regression is fitted with fewer than **ten cohorts** contributing the moderator, and no categorical level with fewer than **ten cohorts** is estimated as its own level. This follows Cochrane Handbook chapter 10. A moderator failing the threshold is reported with `status = "not reported"` and blank estimate columns, so its absence is visible rather than silent.

These thresholds replace the earlier draft's eight-cohort and four-per-level rules, which were too permissive.

### 9.2 Hierarchy

**Confirmatory** (prespecified, reported with the primary):

1. Follow-up horizon
2. Diagnosis group (first-episode versus established schizophrenia versus mixed psychosis)
3. Country income level (high versus middle)
4. Employment construct (competitive only versus any paid)

**Exploratory** (reported as exploratory, not used to support a conclusion): mean age, percentage female, education, baseline employment, antipsychotic use, negative symptom severity, region, setting, risk-of-bias judgement.

All moderator estimates are ecological: they describe variation between cohort means and do not license an inference about individuals within cohorts. That caveat is stated wherever moderator results appear.

### 9.3 Scaling

Moderator scaling is **fixed here, in clinical units, and never recomputed from whichever cohorts happen to be in a given fit**. Recentring on the pilot and again on the full data would silently change what a coefficient means and what its prior implies.

| Moderator | Unit | Centre |
|---|---|---|
| Mean age | per 10 years | 30 years |
| Percentage female | per 10 percentage points | 40 per cent |
| Post-secondary education | per 10 percentage points | 30 per cent |
| Employed at baseline | per 10 percentage points | 20 per cent |
| Follow-up | per doubling of months from 12 | 12 months |

Symptom severity is **not** converted to percentage of scale range across PANSS, SANS, BPRS and BNSS. That conversion assumes linearity and comparable floor effects across instruments, which is not established. Symptom severity is analysed within a single instrument where at least ten cohorts use it, and omitted otherwise.

---

## 10. Models

Fitted with `brms` and Stan. Bayesian estimation is primary; see `methods_deviations.md` for the registered-protocol deviation and its justification.

### 10.1 Primary prevalence model

```r
brms::bf(n_employed | trials(n_outcome_observed) ~ 0 + Intercept + (1 | cohort_id),
         family = binomial(link = "logit"))
```

The binomial likelihood supplies within-cohort sampling variability exactly, with no continuity correction and no normal approximation to a proportion near a boundary. The logit-scale cohort effect gives a logistic-normal distribution of true cohort proportions.

Where a cohort contributes several non-overlapping results, `(1 | cohort_id) + (1 | cohort_id:result_id)` is fitted instead, per section 5.

Moderators enter as pre-built numeric columns, never as R factors. With `0 + Intercept` in the formula, `model.matrix` sees no intercept and gives a factor full dummy coding, which over-parameterises the model while still producing plausible-looking output.

### 10.2 Intervention model

Where arm-level counts are available and the trial is individually randomised:

```r
brms::bf(n_employed | trials(n_outcome_observed) ~ 0 + Intercept + arm_intervention + (1 | study_id),
         family = binomial(link = "logit"))
```

with a study-specific baseline so the treatment coefficient is a within-study contrast.

Where the trial is cluster-randomised, or the report supplies an adjusted effect, a normal likelihood on the reported log odds ratio or log risk ratio with its standard error is used instead. Unadjusted participant counts from a cluster-randomised trial understate uncertainty, so the extraction records the cluster design, the reported adjusted estimate and interval, and the intracluster correlation or design effect where available.

The effect measure is the **odds ratio**, chosen for coherence with the logit-scale prevalence model. Risk differences are reported as a derived quantity for interpretation.

### 10.3 Priors

| Parameter | Prior | Justification |
|---|---|---|
| Intercept (logit) | `normal(-1.1, 0.8)` | `plogis(-1.1) = 0.25`, mid-range of the 10 to 40 per cent reported in this field. Implied 95 per cent prior interval on the pooled proportion is 0.065 to 0.615, so nothing plausible is excluded and the prior cannot by itself produce the estimate |
| Between-cohort SD | `normal(0, 0.5)`, truncated at 0 | Prior median 0.34 implies true cohort proportions of 0.15 to 0.39 at a pooled 0.25; 95 per cent of the prior lies below 0.98. Ajnakina et al. reported I-squared near 96 per cent, so a prior concentrated below 0.2 would be indefensible. Röver et al. (2021) |
| Moderator slopes | `normal(0, 0.5)` on the full nominal contrast, divided by the nominal span | Centred at zero, so no moderation is presupposed. Anchoring on the contrast rather than the fitted unit prevents an arbitrary unit choice from implicitly changing the regularisation |
| Treatment log odds ratio | `normal(0, 0.7)` | 95 per cent prior interval on the odds ratio of roughly 0.25 to 4.0. Wide enough for a vocational intervention effect, tight enough to exclude implausible effects |

`normal(0, 10)` on a logit is **not** an uninformative prior for a proportion: it places almost all implied prior mass near 0 and 1.

Ajnakina et al.'s 32.5 per cent is used **only** as a prior-predictive plausibility anchor, never as a prior mean. Its 74 studies overlap this review's search window, so using it informatively would double-count the same primary studies.

### 10.4 Prior predictive checks

Run before any posterior is computed, with `sample_prior = "only"`, across the actual denominators in the data and additionally across small denominators and zero-event configurations. Prespecified criteria, hashed into the analysis identifier so that the commit pinning them provably predates the fits:

- Each of 0.10, 0.325 and 0.45 falls inside the central 95 per cent implied prior interval for the pooled proportion.
- At least 90 per cent of prior mass for a new cohort's true proportion lies in [0.01, 0.90].
- The median simulated observed proportion lies in [0.10, 0.45].
- At most 5 per cent of prior mass places the observed proportion above 0.80.

The requirement is **coverage**, not agreement. A failure is reported as a failure and the priors are revised in a dated amendment; it is not renegotiated after the fact.

### 10.5 Prior sensitivity

A prespecified grid varying one component at a time is primary:

```
intercept_mean : -1.4, -1.1, -0.8
intercept_sd   :  0.5,  0.8,  1.5
tau_sd         : 0.25,  0.5,  1.0
beta_full_sd   : 0.25,  0.5,  1.0
```

`priorsense` power-scaling (version 1.2.0, installed) supplements the grid. It does not replace it.

### 10.6 Reporting

Estimation is primary (Dienes 2020). A decision is an additional statement about a posterior, never a substitute for reporting it.

Back-transformation is **draw-wise**; a point summary is never transformed. The pooled proportion is `plogis(b_Intercept)` evaluated on the draws.

Reported for the pooled proportion: median, standard deviation, and the **central 95 per cent credible interval as the single headline interval**. A highest-density interval is reported only where the posterior is visibly asymmetric and the two intervals differ materially, and it is then computed on the proportion draws because the HDI is not invariant under back-transformation.

Also reported: the between-cohort standard deviation with its interval, the implied 95 per cent range of true cohort proportions, and a **new-cohort interval** labelled explicitly as the distribution of the *latent true* proportion in a new exchangeable cohort. It is not the predictive distribution of an observed count, which would additionally carry binomial sampling variability.

I-squared is reported as a secondary descriptor only, with the note that for proportions it depends on the arbitrary within-cohort variance and is not comparable across meta-analyses.

**No ROPE is defined on the pooled proportion.** No defensible threshold exists for an acceptable employment rate, and manufacturing one to obtain a categorical verdict is not justified. A directional probability such as `P(pooled proportion < 0.30)` is reported **only** if an external clinical or policy rationale for that threshold is written into this plan first. None is at present, so none is reported.

Moderator slopes are reported with a robustness region over a grid of smallest effect sizes of interest, so a reader sees what threshold would be needed to change the verdict rather than being handed one.

---

## 11. Frequentist comparison

```r
metafor::rma.glmm(measure = "PLO", xi = n_employed, ni = n_outcome_observed, method = "ML")
```

This is the exact-likelihood frequentist counterpart of the primary model. A `rma()` fit on `escalc(measure = "PLO")` transformed estimates is reported as an approximate secondary comparison.

The `model` argument is **not** passed. It is not relevant for `measure = "PLO"`, warns as such, and returns identical estimates for `UM.FS` and `UM.RS`. Random versus equal effects is controlled by `method`.

Logit proportions are used rather than the Freeman-Tukey double arcsine transformation. Back-transforming a double-arcsine pooled estimate requires a single summary sample size and is unstable with markedly unequal cohort sizes, to the point of returning a pooled proportion outside the range of the observed proportions (Schwarzer et al. 2019). This evidence base has exactly that pathology, with national registers of tens of thousands alongside clinical cohorts of a hundred.

**This comparison is a diagnostic, not a gate.** Different likelihood approximations and different priors can legitimately give different pooled estimates and different heterogeneity estimates, and there is no theorem requiring the Bayesian between-cohort standard deviation to exceed the frequentist one. No numerical agreement tolerance is imposed on real data, and no run fails because the two disagree. A discrepancy triggers documented investigation of the data, the likelihood, the priors, convergence and zero-event handling. Where equivalence is genuinely testable, it is tested on simulated data whose expected behaviour is known.

---

## 12. Publication and missing-evidence assessment

Funnel-plot asymmetry tests and trim-and-fill are unreliable for heterogeneous proportions, and Cochrane advises against asymmetry tests with fewer than ten studies while noting that asymmetry has causes other than publication bias. Running them mechanically would produce a number without evidential value.

The registered plan for Begg's test, Egger's test and trim-and-fill is therefore amended to:

1. A contour-enhanced funnel plot for the primary estimand, presented as a description of the evidence rather than a test.
2. A structured assessment of missing evidence: grey-literature coverage, language coverage, the proportion of eligible cohorts with no extractable employment result, and whether unreported results are plausibly related to their magnitude.
3. Egger's regression reported **only** where at least ten cohorts contribute, and interpreted as small-study effects rather than as publication bias.

## 13. Certainty of evidence

GRADE is applied to each pooled estimand, adapted for prevalence evidence: starting certainty, then rating for risk of bias, inconsistency, indirectness, imprecision and publication bias. The domain judgements and their rationale are tabulated. Where GRADE is not applied to a narrative outcome, that is stated rather than left blank.

---

## 14. Analyses that are explicitly not confirmatory

- Any estimate from the 15-report engineering pilot. The pilot exists to test the schema, the validators and the software. Its reports were selected purposively to exercise hard cases, so the sample is not representative and no pooled proportion or moderator estimate from it may be quoted.
- Any moderator not listed as confirmatory in section 9.2.
- The longitudinal all-timepoints model.
- Any analysis added after the pooled results are seen, which is recorded as post hoc in `methods_deviations.md`.

---

## 15. Open decisions requiring authorship-group approval

1. The exclusion of trial control arms from the primary prevalence estimand (section 2.1).
2. The exclusion of education from the primary employment construct (section 3.1), which changes how the existing `sturup2022` row is treated.
3. The twelve-month landmark and its 9 to 18 month window (section 4).
4. The available-case denominator (section 6).
5. The switch to the JBI prevalence checklist for the primary estimand (section 8).
6. The confirmatory moderator set (section 9.2).
7. Whether a directional threshold for the pooled proportion has a policy rationale worth stating (section 10.6).

---

## References

Dienes Z (2021). How to use and report Bayesian hypothesis tests. *Psychology of Consciousness*.
Röver C, Bender R, Dias S, et al. (2021). On weakly informative prior distributions for the heterogeneity parameter in Bayesian random-effects meta-analysis. *Research Synthesis Methods* 12:448-474.
Schwarzer G, Chemaitelly H, Abu-Raddad LJ, Rücker G (2019). Seriously misleading results using inverse of Freeman-Tukey double arcsine transformation in meta-analysis of single proportions. *Research Synthesis Methods* 10:476-483.
Higgins JPT, Thomas J, Chandler J, et al. (eds). *Cochrane Handbook for Systematic Reviews of Interventions*, current version, chapters 10, 13 and 25.
Munn Z, Moola S, Lisy K, Riitano D, Tufanaru C. *JBI critical appraisal checklist for studies reporting prevalence data*.
