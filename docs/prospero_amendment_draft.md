# PROSPERO amendment, draft for submission

**Record:** CRD420251008448, "Employment Rates and Moderators in Psychosis: A Systematic Review and Meta-Analysis"
**Guarantor:** Dr Ricardo Twumasi, King's College London
**Proposed version:** 5.0
**Drafted:** 5 August 2026; updated 11, 12 and 13 August 2026
**Status:** **SUBMITTED on 23 September 2026** by the guarantor (confirmed 23 September 2026).
The returned PROSPERO version number is to be recorded in `docs/methods_deviations.md` when it
arrives. The text below is the text submitted.

**Version history of this draft.** Version 4.0 was **submitted on 12 August 2026** and covers
everything in the field-by-field section below, up to and including the review-status field.
Version 5.0 is the increment: it registers the decisions taken during Stage F, which are D13,
D14 and the five schema additions, and it updates the review-status field again now that
first-pass risk-of-bias judgements exist. The v4.0 sections are retained here unchanged so
that the record reads as one document rather than as a diff; the v4.0 submission checklist has
been retired and replaced by the v5.0 checklist at the end.

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

---

# Version 5.0 additions: decisions taken during Stage F

Everything above was submitted as version 4.0 on 12 August 2026. Everything below was decided
after that submission, during or immediately after the definitive extraction, and **each was
made after the results it affects had been seen**. That is precisely the circumstance a
registry amendment exists to disclose, and it is stated in those terms rather than presented
as a prospective refinement. Full entries are in `docs/methods_deviations.md`.

### Field: Eligibility criteria, and Strategy for data synthesis (D13, the diagnosis gate)

**Proposed addition:**

> **D13. Where a sample is diagnostically mixed, the 50 per cent qualifying-diagnosis rule is
> sufficient on its own.** The registered rule admits a mixed sample if at least half of it
> carries a qualifying psychosis diagnosis **or** a qualifying subgroup can be extracted
> separately. The implementation required both conditions at once. The rule is applied as
> registered, that is as a disjunction.
>
> **Timing and effect, stated plainly.** This was decided after the affected results had been
> extracted and seen. Under the current extraction, which is structurally validated and
> **scientifically unverified**, D13 permits two of the three provisional twelve-month
> candidates to pass the diagnosis gate: `khare2022b` (Pune public-hospital cohort, 90 per cent
> qualifying diagnosis) and `khare2021` (Pune private-sector cohort, 59.3 per cent). Without
> D13, only `andersen2024` would currently remain at that horizon, and the review's own
> stopping rule for sparse data would then preclude a meta-analysis at twelve months
> altogether.
>
> **Qualification.** None of these rows is human-verified, each carries an open question put to
> its authors, and the composition of the pool can still change in either direction.
> Verification and author information, particularly on `mayoralvanson2019`, may add a row or
> remove one. The figures above describe the pool as it stands on 13 August 2026 and are not a
> claim about what the pool will contain when the inputs are frozen.
>
> Reason for change: the registered wording and the implemented conjunction differ for exactly
> the cohorts named. Applying the implementation would exclude a cohort that is 90 per cent
> schizophrenia and schizoaffective, with a clean twelve-month paid-employment count, on a
> criterion the registration did not impose.

### Field: Strategy for data synthesis (D14, partition sums)

**Proposed addition:**

> **D14. A whole-cohort count may be derived by summing across subgroups that partition the
> cohort**, where the subgroups are mutually exclusive and exhaustive, share the construct,
> ascertainment, window and timepoint, and their denominators sum exactly to the derived
> denominator. The previous rule required derived components to share one arm identity and one
> denominator, which is right for summing outcome categories within an arm and wrong for a
> partition into subgroups.
>
> **Timing and effect, stated plainly.** This was also decided after the affected results had
> been seen, and it is registered for that reason. **Its present effect is not admission to the
> primary pool.** The result it creates, `jirapramukpitak2022` 189 of 549, is a twelve-month
> **period** prevalence and therefore joins the period-prevalence family, not the primary
> point-prevalence synthesis. The two further derived rows it governs are a paid-or-education
> result and an employment, education and training result, both of which belong to secondary
> outcome families. No row enters the primary pool by virtue of D14.
>
> Reason for change: a partition sum is a legitimate and common derivation whose safety
> condition is that the subgroups do not overlap and omit nobody, which is a different
> condition from a shared denominator. Without the change, evidence is not lost but is
> aggregated at a level the review cannot use.

### Field: Data extraction (five schema additions, post-submission, eligibility unchanged)

None of the five changes any study's eligibility or any result's pool membership. Each is
recorded so that the extraction schema in the registry matches the one actually used.

> **D12.7.** A controlled vocabulary of risk-of-bias domain identifiers was added, so that
> domain-level judgements are comparable across results and instruments rather than named
> freely by each extractor.
>
> **D12.8.** A `calendar_end_common` value was added to the follow-up basis vocabulary, for
> studies measured to a shared calendar end point rather than at a fixed elapsed time; it is
> barred from every landmark horizon. It exists so that a clearly reported study is not
> recorded as unclear.
>
> **`analysis_selection_status`.** Employment-related selection is now recorded separately for
> the recruited cohort and for the analysed sample, because a cohort recruited without any
> employment criterion can still be analysed after an employment-related restriction, and the
> registered rule applies to both.
>
> **`reported_percentage_base`.** Where a report prints a percentage, the base it divides by is
> recorded as a distinct field, so that an unstated base is visible as a blank rather than
> inferred.
>
> **`analysis_sample_id`.** An identifier for the analysed sample, distinct from the cohort and
> the arm, so that two reports analysing different subsets of one cohort are not conflated.

### Field: Review status

**Proposed text:**

> Formal screening completed. Data extraction completed for all 90 included reports;
> **first-pass risk-of-bias judgements completed, with independent human verification
> ongoing**. Data synthesis not started.

Stage flags to match: screening completed; data extraction completed; risk of bias assessment
ongoing; data synthesis not started. The record as submitted at version 4.0 marked risk of
bias as not started, which is no longer accurate: 1,491 first-pass domain judgements exist
across the Stage F shards. It is recorded as ongoing rather than completed because no
judgement has yet been checked by a second person, and the review's own rule is that a
first-pass judgement by a single automated extractor is not a completed assessment.

---

## Changes deliberately NOT proposed

- Review-level diagnostic population criteria, eligible study designs, comparators and context are unchanged. The population contributing to the primary prevalence synthesis is newly restricted by employment-related selection, while eligible whole-cohort results may arise from either randomised or non-randomised parent studies.
- Heterogeneity assessment via I-squared is retained, with the added note that for proportions it depends on the arbitrary within-cohort variance and is not comparable across meta-analyses.
- GRADE is retained and will be applied to each pooled estimand, adapted for prevalence evidence.
- The registered secondary outcomes (relationship status, wages, social functioning) are retained. Each is designated in the statistical analysis plan as a separate synthesis or a narrative outcome so that none lapses silently.

---

## Submission checklist, version 5.0

The version 4.0 checklist is retired: every item on it was completed and version 4.0 was
submitted on 12 August 2026.

- [x] Statistical analysis plan ratified by the authorship group (SAP v0.2, 12 August 2026)
- [x] D13 and D14 ratified by the authorship group, with the affected results named
- [x] D9 and D12 ratified by the authorship group (12 August 2026)
- [x] Post-result timing of D13 and D14 stated explicitly in the proposed text above
- [x] Review-status wording updated to match the first-pass risk-of-bias state
- [x] Amendment reviewed by the guarantor
- [x] **Submitted to PROSPERO by the guarantor on 23 September 2026**, recorded in
      `docs/methods_deviations.md`
- [x] `docs/methods_deviations.md` updated to cite the submission date
- [ ] The returned PROSPERO version number recorded in `docs/methods_deviations.md`

The submission was confirmed by the guarantor on 23 September 2026 and is recorded as event
metadata with that date.

The Phase 5 input freeze depends on this: an outcome-conditioned fit may not be run until
version 5.0 submission is confirmed and mirrored in the deviations log, because D13 and D14
were both made after the affected results were seen and the registry is where that is
disclosed.
