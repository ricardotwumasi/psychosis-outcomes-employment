# PROSPERO amendment, draft for submission

**Record:** CRD420251008448, "Employment Rates and Moderators in Psychosis: A Systematic Review and Meta-Analysis"
**Guarantor:** Dr Ricardo Twumasi, King's College London
**Proposed version:** 4.0
**Drafted:** 5 August 2026
**Status:** DRAFT for the authorship group. Not submitted. Submit only after the statistical analysis plan is approved.

---

## Why an amendment is needed now

PROSPERO permits changes to an ongoing review and expects them to be recorded with their timing and rationale. The changes below are substantive: they alter the primary estimand, the population contributing to it, the outcome construct, the analysis framework and the risk-of-bias instruments. Recording them only in a repository file would not satisfy that expectation, and reviewers at the target journal check the registration against the manuscript.

All changes are prospective. At the date of drafting, one study row exists in the repository and no pooled estimate has been computed.

---

## Field-by-field changes

### Field: Risk of bias (quality) assessment

**Current text:** "Risk of bias will be assessed using: Cochrane RoB-2."

**Proposed text:**

> Risk of bias will be assessed with instruments matched to the design and estimand of each result, rather than with a single instrument.
>
> Prevalence estimates from observational cohorts, which carry the review's primary outcome, will be assessed with the JBI critical appraisal checklist for studies reporting prevalence data. Effect estimates from randomised comparisons will be assessed with Cochrane RoB 2. Effect estimates from non-randomised studies of interventions will be assessed with ROBINS-I.
>
> Risk of bias will be assessed at the level of the individual result rather than the publication, since one report may contribute results of different designs. Instrument-specific judgement categories will be retained and will not be collapsed into a common scale. Each assessment will be made by one assessor and checked by a second.
>
> Reason for change: RoB 2 assesses the risk of bias in an estimate of the effect of assignment to an intervention in a randomised trial. The review's primary outcome is a prevalence in an observational cohort, for which RoB 2 has no applicable domains. The original entry named a randomised-trial instrument for a predominantly observational review.

### Field: Main outcomes

**Current text:** "Employment status (including full-time employment, part-time employment, sheltered employment, education/training programs); Job tenure (duration of employment)".

**Proposed text:**

> Primary outcome: point-prevalence paid employment, defined as work for pay (competitive, supported or sheltered) held at a defined follow-up landmark.
>
> Employment or participation in education and training will be extracted and analysed as a separate, secondary outcome rather than combined with paid employment in the primary estimate. Competitive employment alone, supported or sheltered employment alone, and broad vocational activity will each be recorded and reported separately where sufficient cohorts report them.
>
> Job tenure remains a registered outcome and will be synthesised separately if at least ten cohorts report a comparable duration measure, and narratively otherwise.
>
> Reason for change: combining paid work with enrolment in education produces a composite whose value depends on the age structure and education system of each cohort rather than on labour-market participation, so two cohorts with identical employment can differ substantially on the composite. The original wording is preserved as a separately reported outcome.

### Field: Strategy for data synthesis

**Current text:** "3.7.1 Quantitative Synthesis. Frequentist meta-analysis are planned, however, if there are a small amount of studies (n<10) we will use a Bayesian framework in the meta-analysis using the brms package in R. A random-effects meta-analysis will be conducted to estimate the pooled proportion of employment across studies..."

**Proposed text:**

> **Estimands.** Two questions will be synthesised separately and will not be combined.
>
> (a) Prevalence. Among people with a schizophrenia spectrum disorder or first-episode psychosis identified in an observational cohort, the proportion in paid employment at a defined follow-up landmark of at least twelve months. Participants enrolled in intervention trials are excluded from this estimate, because eligibility for such trials typically requires being unemployed, wanting to work and being clinically stable, so their employment rate is conditioned on that selection. Trial control and treatment-as-usual arms may be added in a named sensitivity analysis following a documented comparability review.
>
> (b) Intervention effect. The effect of an intervention on employment compared with its concurrent control, at matched follow-up, preserving the within-study randomised comparison. Arm-level rates pooled across studies by arm class will not be interpreted as an intervention effect.
>
> **Framework.** Bayesian random-effects meta-analysis using the brms package in R with Stan, as the primary framework, irrespective of the number of contributing cohorts. The primary model is a binomial-logit random-effects model on the employed count and its denominator, with a cohort-level random effect. An exact-likelihood frequentist fit (metafor::rma.glmm on logit proportions, maximum likelihood) will be reported alongside as a diagnostic comparison.
>
> Reason for change to the framework: the outcome is a proportion estimated from counts, for which a binomial likelihood is exact, whereas the frequentist route requires a normal approximation to a transformed proportion with a continuity correction for zero cells. Between-cohort heterogeneity in this literature is very high, and a weakly informative prior on the between-cohort standard deviation is better behaved than maximum likelihood when a subgroup contains few cohorts. Moderator reporting is sparse and uneven, which partial pooling handles more honestly than complete-case meta-regression. Priors will be weakly informative, justified by prior predictive checks specified before fitting, and subjected to a prespecified sensitivity grid.
>
> **Unit of analysis.** The cohort, not the publication. Reports will be mapped to cohorts before any result is selected. Where several reports describe one cohort at one follow-up horizon, one result will be selected by a prespecified rule (largest analysis population at that horizon; then closest outcome construct; then earliest publication) and the reports not selected will be named in the output.
>
> **Timepoints.** The primary estimate will use, for each cohort, the reported timepoint closest to twelve months within a window of nine to eighteen months. Separate models will be fitted at 24 months (18 to 30), five years (48 to 78) and ten years or more (108 and above). Reason: taking each cohort's longest available follow-up does not create a common horizon and selects on which cohorts published long-term results.
>
> **Denominator.** The primary analysis will be available-case, with the denominator being the number whose employment status was observed at the landmark. The number entering the cohort, the number alive and eligible, the number assessed and the number with observed status will be recorded separately. Complete-cohort best-case and worst-case bounding analyses and an attrition moderator are prespecified.

### Field: Assessment of reporting biases

**Current text:** publication bias assessed using funnel plots, Begg's test and Egger's test, with trim-and-fill if detected.

**Proposed text:**

> Missing evidence will be assessed with a contour-enhanced funnel plot presented descriptively, a structured narrative assessment of grey-literature and language coverage and of the proportion of eligible cohorts with no extractable employment result, and Egger's regression reported only where at least ten cohorts contribute and interpreted as small-study effects rather than as publication bias. Trim-and-fill and Begg's test will not be used.
>
> Reason for change: these procedures are unreliable for highly heterogeneous proportions, and Cochrane advises against asymmetry tests with fewer than ten studies while noting that asymmetry has causes other than publication bias. Trim-and-fill assumes a selection mechanism that is not plausible for prevalence estimates, where a cohort's employment rate is rarely the reason a report is published.

### Field: Search date restrictions

**Current text:** "Databases will be searched for articles published from 1 January 2016 and before by 2 June 2025."

**Proposed text:** to be completed once the search update is run. The record must state the actual end date of the final search. Reports published in 2026 are present in the current evidence set, so the registered window and the evidence base do not presently agree.

**Action required before submission:** run and document the search update with deduplication, then insert the true end date here.

### Field: Review status

Update the stage flags: formal screening completed; data extraction ongoing; risk of bias not started; data synthesis not started. The record currently marks all of these as not completed.

---

## Changes deliberately NOT proposed

- The population criteria, eligible designs, comparators and context are unchanged.
- Heterogeneity assessment via I-squared is retained, with the added note that for proportions it depends on the arbitrary within-cohort variance and is not comparable across meta-analyses.
- GRADE is retained and will be applied to each pooled estimand, adapted for prevalence evidence.
- The registered secondary outcomes (relationship status, wages, social functioning) are retained. Each is designated in the statistical analysis plan as a separate synthesis or a narrative outcome so that none lapses silently.

---

## Submission checklist

- [ ] Statistical analysis plan approved by the authorship group
- [ ] Search update run, deduplicated and dated
- [ ] True search end date inserted above
- [ ] Amendment reviewed by the guarantor
- [ ] Submitted to PROSPERO and the returned version number recorded in `methods_deviations.md`
- [ ] `methods_deviations.md` updated to cite the accepted amendment version and date
