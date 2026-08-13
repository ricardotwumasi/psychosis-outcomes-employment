# PROSPERO amendment, draft for submission

**Record:** CRD420251008448, "Employment Rates and Moderators in Psychosis: A Systematic Review and Meta-Analysis"
**Guarantor:** Dr Ricardo Twumasi, King's College London
**Proposed version:** 4.0
**Drafted:** 5 August 2026; updated 11 August 2026
**Status:** DRAFT for the authorship group. Not submitted. Submit only after the statistical analysis plan is approved.

---

## Why an amendment is needed now

PROSPERO permits changes to an ongoing review and expects them to be recorded with their timing and rationale. The changes below are substantive: they alter the primary estimand, the population contributing to it, the outcome construct, the analysis framework and the risk-of-bias instruments. Recording them only in a repository file would not satisfy that expectation, and reviewers at the target journal check the registration against the manuscript.

Decisions D1 to D8 were drafted before any pooled real-data result was examined. A purposive engineering pilot subsequently produced an unreportable pooled estimate under the superseded design-based eligibility rule. The revised population rule was adopted after that pilot but before definitive extraction and synthesis. It is justified by the target population and recruitment mechanism, not by the direction or magnitude of the pilot results. This timing will be stated in the registry and manuscript.

---

## Field-by-field changes

### Field: Risk of bias (quality) assessment

**Current text:** "Risk of bias will be assessed using: Cochrane RoB-2."

**Proposed text:**

> Risk of bias will be assessed with instruments matched to the design and estimand of each result, rather than with a single instrument.
>
> Prevalence estimates from eligible whole cohorts, irrespective of the parent study design, will be assessed with the JBI critical appraisal checklist for studies reporting prevalence data. Trial origin and any experimentally assigned care will additionally be recorded when judging applicability. Effect estimates from randomised comparisons will be assessed with Cochrane RoB 2. Effect estimates from non-randomised studies of interventions will be assessed with ROBINS-I.
>
> Risk of bias will be assessed at the level of the individual result rather than the publication, since one report may contribute results of different designs. Instrument-specific judgement categories will be retained and will not be collapsed into a common scale. Each assessment will be made by one assessor and checked by a second.
>
> Reason for change: RoB 2 assesses the risk of bias in an estimate of the effect of assignment to an intervention. It does not assess whether the sampling frame and recruitment are appropriate for a prevalence estimand. The original entry named a randomised-trial instrument for every result in a review containing several designs and estimands.

### Field: Main outcomes

**Current text:** "Employment status (including full-time employment, part-time employment, sheltered employment, education/training programs); Job tenure (duration of employment)".

**Proposed text:**

> Primary headline outcome: point-prevalence any paid employment at a defined follow-up landmark. Paid employment means current work in return for wages or salary and includes full-time and part-time work, competitive employment, and paid supported or sheltered work. It excludes education, unpaid training or work experience, volunteering and activities for which remuneration cannot be established.
>
> Paid-employment subtypes will not substitute for any paid employment in the primary synthesis. Competitive paid employment and paid sheltered or otherwise non-competitive employment will be extracted and analysed separately. Supported employment will be classified by the nature of the job rather than assumed to be sheltered, because support can be provided in an ordinary competitive job.
>
> Employment, education or training (EET) will be retained as a separate registered vocational-participation outcome and will not be combined with paid-only employment results. Education and training will be extracted separately where the report permits; a combined education-or-training result will be retained only when its components cannot be separated. Unpaid vocational activity will be recorded as a further distinct outcome. If the amendment is accepted, these will be designated key secondary outcomes rather than included in the primary paid-employment numerator.
>
> Job tenure remains a registered outcome and will be synthesised separately if at least ten cohorts report a comparable duration measure, and narratively otherwise.
>
> Reason for change: the registered record lists full-time employment, part-time employment, sheltered employment and education/training programmes within the broad primary outcome domain, but it does not require them to be combined into one numerator. It also prespecifies analysing studies with different definitions of employment separately. Paid work measures labour-market participation, whereas education and training measure educational or vocational participation and vary with age, service model and national systems. Combining them would yield a quantity with no stable interpretation. Every registered component is retained as a named outcome, so no registered outcome is discarded.

### Field: Strategy for data synthesis

**Current text:** "3.7.1 Quantitative Synthesis. Frequentist meta-analysis are planned, however, if there are a small amount of studies (n<10) we will use a Bayesian framework in the meta-analysis using the brms package in R. A random-effects meta-analysis will be conducted to estimate the pooled proportion of employment across studies..."

**Proposed text:**

> **Estimands.** Two questions will be synthesised separately and will not be combined.
>
> (a) Prevalence. Among people with a schizophrenia spectrum disorder or first-episode psychosis recruited into a longitudinal clinical, catchment, registry or population sample without employment-related selection, the proportion in any paid employment at a defined follow-up landmark of at least twelve months, under the care received. Employment-related selection includes eligibility, enrolment or analytic restriction based on employment status, willingness or readiness to work, an employment goal, vocational-service eligibility or participation, current vocational placement, or previous failure to obtain employment. Samples with unclear selection status will be excluded from the primary analysis and included only in a named sensitivity analysis.
>
> The primary prevalence unit is the whole recruited cohort, not an allocated trial arm. A trial-derived whole cohort may contribute when every original allocation group is represented without omission or selective reweighting, outcome ascertainment is common across groups, no post-randomisation subgroup is selected, and the experimental intervention was not specifically intended to change employment. Parent trial design and treatment history will remain recorded. A prespecified sensitivity analysis will exclude all trial-derived cohorts. Employment-selected samples remain eligible for the review and may contribute to intervention-effect synthesis or a separately labelled selected-population analysis.
>
> (b) Intervention effect. The effect of an intervention on employment compared with its concurrent control, at matched follow-up, preserving the within-study randomised comparison. Arm-level rates pooled across studies by arm class will not be interpreted as an intervention effect.
>
> **Framework.** Bayesian random-effects meta-analysis using the brms package in R with Stan, as the primary framework, irrespective of the number of contributing cohorts. The primary model is a binomial-logit random-effects model on the employed count and its denominator, with a cohort-level random effect. An exact-likelihood frequentist fit (metafor::rma.glmm on logit proportions, maximum likelihood) will be reported alongside as a diagnostic comparison.
>
> Reason for change to the framework: the outcome is a proportion estimated from counts, for which a binomial likelihood is exact, whereas the frequentist route requires a normal approximation to a transformed proportion with a continuity correction for zero cells. Between-cohort heterogeneity in this literature is very high, and a weakly informative prior on the between-cohort standard deviation is better behaved than maximum likelihood when a subgroup contains few cohorts. Moderator reporting is sparse and uneven, which partial pooling handles more honestly than complete-case meta-regression. Priors will be weakly informative, justified by prior predictive checks specified before fitting, and subjected to a prespecified sensitivity grid.
>
> **Unit of analysis.** The cohort, not the publication. Reports will be mapped to cohorts before any result is selected. Selection will occur only among results with the same horizon, ascertainment and exact construct, so a competitive-only, sheltered-only or EET result cannot substitute for any paid employment. Where otherwise equivalent results remain, selection will follow the largest analysis population, then clearest denominator and ascertainment, then earliest publication; reports not selected will be named in the output.
>
> **Timepoints.** The primary estimate will use, for each cohort, the reported timepoint closest to twelve months within a window of nine to eighteen months. Separate models will be fitted at 24 months (18 to 30), five years (48 to 78) and ten years or more (108 and above). Reason: taking each cohort's longest available follow-up does not create a common horizon and selects on which cohorts published long-term results.
>
> **Denominator.** The primary analysis will be available-case, with the denominator being the number whose employment status was observed at the landmark. The number entering the cohort, the number alive and eligible, the number assessed and the number with observed status will be recorded separately. Complete-cohort best-case and worst-case bounding analyses and an attrition moderator are prespecified.
>
> **Outcome separation.** Only point-prevalence `paid_any` results will enter the primary prevalence synthesis. Competitive-only, sheltered-only, EET, education-only, training-only, period-prevalence and cumulative employment-attainment results will be analysed within separate outcome and ascertainment families. Categories will be summed only when the source establishes that they are mutually exclusive, exhaustive and use the same denominator.

### Field: Assessment of reporting biases

**Current text:** publication bias assessed using funnel plots, Begg's test and Egger's test, with trim-and-fill if detected.

**Proposed text:**

> Missing evidence will be assessed with a contour-enhanced funnel plot presented descriptively, a structured narrative assessment of grey-literature and language coverage and of the proportion of eligible cohorts with no extractable employment result, and Egger's regression reported only where at least ten cohorts contribute and interpreted as small-study effects rather than as publication bias. Trim-and-fill and Begg's test will not be used.
>
> Reason for change: these procedures are unreliable for highly heterogeneous proportions, and Cochrane advises against asymmetry tests with fewer than ten studies while noting that asymmetry has causes other than publication bias. Trim-and-fill assumes a selection mechanism that is not plausible for prevalence estimates, where a cohort's employment rate is rarely the reason a report is published.

### Field: Search date restrictions

**Current text:** "Databases will be searched for articles published from 1 January 2016 and before by 2 June 2025."

**Proposed text:**

> Databases were searched for articles published from 1 January 2016 to 9 June 2026.
>
> Reason for change: 2 June 2025 is the close date of an earlier search. The search was subsequently re-run across the registered databases and closed on 9 June 2026. The registry entry is being corrected to state the end date of the final executed search.

**Status:** complete. The search closed 9 June 2026 and returned 6,698 records, 3,936 after duplicate removal, 279 assessed at full text and 90 reports included. No further search or deduplication run is outstanding.

### Field: Review status

Update the stage flags: formal screening completed; data extraction ongoing; risk of bias not started; data synthesis not started. The record currently marks all of these as not completed.

---

## Changes deliberately NOT proposed

- Review-level diagnostic population criteria, eligible study designs, comparators and context are unchanged. The population contributing to the primary prevalence synthesis is newly restricted by employment-related selection, while eligible whole-cohort results may arise from either randomised or non-randomised parent studies.
- Heterogeneity assessment via I-squared is retained, with the added note that for proportions it depends on the arbitrary within-cohort variance and is not comparable across meta-analyses.
- GRADE is retained and will be applied to each pooled estimand, adapted for prevalence evidence.
- The registered secondary outcomes (relationship status, wages, social functioning) are retained. Each is designated in the statistical analysis plan as a separate synthesis or a narrative outcome so that none lapses silently.

---

## Submission checklist

- [ ] Statistical analysis plan approved by the authorship group
- [ ] Employment-selection rule and outcome hierarchy approved by the authorship group
- [ ] Search update run, deduplicated and dated
- [ ] True search end date inserted above
- [ ] Amendment reviewed by the guarantor
- [ ] Submitted to PROSPERO and the returned version number recorded in `methods_deviations.md`
- [ ] `methods_deviations.md` updated to cite the accepted amendment version and date
