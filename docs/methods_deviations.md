# Deviations from the registered protocol

**Registration:** PROSPERO [CRD420251008448](https://www.crd.york.ac.uk/PROSPERO/view/CRD420251008448), registered 20 March 2025, versions 1.0 and 1.1 (20 March 2025), 2.0 (6 June 2025), 3.0 (9 June 2026).

This log records every departure from the registered record, with its date and rationale. It mirrors, and does not replace, the dated PROSPERO amendment drafted in `prospero_amendment_draft.md`. A repository file is not a registry entry, and reviewers check the registry.

Each entry states whether the decision was made **before** or **after** the pooled outcome data were seen. At the date of this version, no pooled estimate has been computed on real data, so every entry below is prospective.

---

## D1. Bayesian estimation as the primary framework

**Date:** 5 August 2026. **Prospective.**

**Registered:** section 3.7.1, "Frequentist meta-analysis are planned, however, if there are a small amount of studies (n<10) we will use a Bayesian framework in the meta-analysis using the brms package in R."

**Deviation:** Bayesian estimation with `brms` is the primary framework irrespective of the number of cohorts. The review has approximately 90 included reports, so the registered n<10 trigger is not met.

**Rationale:**

1. The outcome is a proportion estimated from counts. A binomial likelihood on the counts is exact. The registered frequentist route in practice means a normal approximation to a transformed proportion, which needs a continuity correction for zero cells and behaves poorly near the boundary.
2. Between-cohort heterogeneity in this literature is very high (Ajnakina et al. reported I-squared near 96 per cent). A weakly informative half-normal prior on the between-cohort standard deviation is better behaved at this heterogeneity than maximum likelihood, which shrinks the heterogeneity estimate when the number of cohorts in a subgroup is small.
3. Moderator data are sparse and unevenly reported. Partial pooling handles that more honestly than complete-case meta-regression.
4. The primary quantity of interest for a clinician or policymaker is a distribution over plausible employment rates, including the rate in a new cohort. That is directly available as a posterior and only approximately available frequentist.

**Mitigation:** an exact-likelihood frequentist fit (`metafor::rma.glmm`, logit proportions, maximum likelihood) is reported alongside as a diagnostic comparison, so a reader can see whether the two frameworks tell the same story.

---

## D2. Risk-of-bias instruments

**Date:** 5 August 2026. **Prospective.**

**Registered:** "Risk of bias will be assessed using: Cochrane RoB-2."

**Deviation:** three design-appropriate instruments are used instead of one:

| Evidence type | Instrument |
|---|---|
| Prevalence from an observational cohort | JBI critical appraisal checklist for prevalence studies |
| Effect from a randomised comparison | Cochrane RoB 2 |
| Effect from a non-randomised intervention study | ROBINS-I |

**Rationale:** RoB 2 assesses the risk of bias in an estimate of the effect of assignment to an intervention in a randomised trial. The primary estimand of this review is a prevalence in an observational cohort, for which RoB 2 has no applicable domains. Applying it would produce judgements that do not correspond to the estimand being assessed. The registered record names a randomised-trial instrument for a predominantly observational review, which is an error in the registration rather than a considered choice.

**Consequence:** the risk-of-bias judgements in the MSc supplementary material are not migrated. That table applies the RoB 2 category "Some concerns" to quasi-experimental studies nominally assessed with ROBINS-I, mixing two instruments' response scales. All risk-of-bias assessment is redone.

---

## D3. Separation of prevalence and intervention estimands

**Date:** 5 August 2026. **Prospective.**

**Registered:** a single random-effects meta-analysis of "the pooled proportion of employment across studies", with both randomised and non-randomised designs eligible.

**Deviation:** two estimands are synthesised separately. The primary pooled prevalence uses observational cohorts only. Intervention evidence is synthesised as within-study treatment effects.

**Rationale:** participants randomised into a vocational trial are typically required to be unemployed, to want to work, to be clinically stable and to consent to a service. Their employment rate is conditioned on that selection and does not estimate employment in the underlying psychosis population. Pooling the two would produce a number that answers neither question. Separately, pooling all intervention arms against all non-intervention arms across studies would discard randomisation and confound the intervention with whatever distinguishes trials that offer it, so it cannot support a causal claim.

**Mitigation:** trial control and treatment-as-usual arms may be added to the prevalence estimate in a named sensitivity analysis, after a written comparability review of their eligibility criteria. That result is reported alongside the primary, never in place of it.

---

## D4. Twelve-month landmark timepoint

**Date:** 5 August 2026. **Prospective.**

**Registered:** "For studies reporting employment rates at multiple time points, we will extract data for each time point and analyze them separately to examine changes over time." No rule is given for which timepoint carries the primary estimate.

**Specification (not strictly a deviation, since the record is silent):** the primary estimate uses the timepoint closest to 12 months within a 9 to 18 month window. Separate models are fitted at 24 months, 5 years, and 10 years or more.

**Rationale:** taking each cohort's longest available follow-up does not create a common horizon, since one cohort's longest is 12 months and another's is 20 years. It also selects on which cohorts retained participants long enough to publish long-term results. A landmark fixes the horizon so the pooled estimate has a single meaning, and the separate horizons then answer the change-over-time question the registration asks for.

---

## D5. Cohort rather than report as the unit of analysis

**Date:** 5 August 2026. **Prospective.**

**Registered:** the record does not address repeated publications from one participant sample.

**Specification:** the random effect groups on cohort. Where several reports describe one cohort at one horizon, one result is selected by a prespecified rule and the others are named in the output.

**Rationale:** OPUS, AESOP, RAISE, the Chicago Follow-up Study, the Northern Finland Birth Cohort and the Nordic national registers each generate multiple publications from overlapping participants. Treating publications as independent would count the same participants several times and understate the width of every interval. The evidence reconciliation carried out on 5 August 2026 confirmed multiple such clusters among the staged reports.

---

## D6. Employment construct excludes education

**Date:** 5 August 2026. **Prospective.**

**Registered:** primary outcome "Employment status (including full-time employment, part-time employment, sheltered employment, education/training programs)".

**Deviation:** the primary construct is point-prevalence **paid** employment. Education and training are recorded and analysed separately, not counted as employment in the primary estimate.

**Rationale:** combining paid work with enrolment in education produces a composite whose value depends on the age distribution and the education system of each cohort rather than on labour-market participation. Two cohorts with identical employment can differ by twenty percentage points on the composite. The registered wording is retained as a separately reported outcome, so nothing registered is lost.

**Consequence:** the single row currently in the repository (`sturup2022`, "work as primary income source or registered student") does not enter the primary estimate as recorded and must be re-extracted against the primary construct if the source can be obtained.

---

## D7. Publication and missing-evidence assessment

**Date:** 5 August 2026. **Prospective.**

**Registered:** section 3.7.4, "Publication bias will be assessed using funnel plots, Begg's test, and Egger's test", with trim-and-fill if bias is detected.

**Deviation:** trim-and-fill and Begg's test are not run. A contour-enhanced funnel plot is presented descriptively, Egger's regression is reported only where at least ten cohorts contribute and is interpreted as small-study effects, and a structured narrative assessment of missing evidence is added.

**Rationale:** these tests are unreliable for highly heterogeneous proportions, and Cochrane advises against asymmetry tests with fewer than ten studies while noting that asymmetry has causes other than publication bias. Trim-and-fill assumes a specific selection mechanism that is not plausible for prevalence estimates, where a cohort's employment rate is rarely the reason a paper is published. Running them mechanically would produce numbers without evidential value.

---

## D8. Search currency

**Date:** 5 August 2026. **Outstanding, not yet resolved.**

**Registered:** databases searched from 1 January 2016 to 2 June 2025.

**Issue:** project material refers to updating the search through 2026, and staged reports carry 2026 publication years. The registered search window and the evidence base do not currently agree.

**Required action:** run and document a search update with deduplication before any definitive analysis, and record the new end date in the PROSPERO amendment. Until that is done, no analysis in this repository may be described as a current synthesis of the literature.

---

## Non-deviations, recorded to prevent confusion

- **Extraction by a machine checked by a human** is what the record already specifies ("Data will be extracted by one person (or a machine) and checked by at least one other person (or machine)"). The LLM-assisted extraction used here is within the registered process, not a departure from it. Every field determining inclusion or the primary estimate is checked independently.
- **The 15-report pilot** is engineering validation, not a registered analysis, and produces no reportable estimate. It requires no amendment.
