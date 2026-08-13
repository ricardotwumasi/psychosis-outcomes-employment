# Deviations from the registered protocol

**Registration:** PROSPERO [CRD420251008448](https://www.crd.york.ac.uk/PROSPERO/view/CRD420251008448), registered 20 March 2025, versions 1.0 and 1.1 (20 March 2025), 2.0 (6 June 2025), 3.0 (9 June 2026), **4.0 (submitted 12 August 2026, carrying D9 to D12)**.

> **A version 5.0 amendment is owed. D13 and D14 are not registered.** It is prepared in
> `docs/prospero_amendment_draft.md` as of 13 August 2026 and awaits the guarantor's
> submission; until that is confirmed and dated here, version 5.0 is prepared and not
> registered.
>
> Both were settled during Stage F, *after* version 4.0 was submitted, so no registry
> version carries them. Both **admit evidence** and both were made after the affected
> results were seen. That combination is exactly what a registry amendment exists to
> record, and leaving it unregistered would be the most criticisable thing in this review.
>
> **Where the admitted evidence lands differs between the two, and earlier drafts of this
> file, the README and the handover all overstated D14 by saying it admits evidence to the
> primary pool.** Corrected 13 August 2026. **D13 admits rows to the primary pool.** **D14
> does not**: the row it creates, `jirapramukpitak2022` 189 of 549, is a twelve-month
> *period* prevalence and belongs to the period-prevalence family, and the two further
> derived rows it governs are a paid-or-education result and an EET result, both in
> secondary outcome families. D14 is still a post-result change to a derivation rule and
> still requires registration; what it does not do is put a row into the primary pool.
>
> D12.7 and D12.8 also postdate the submission but are schema bookkeeping that changes no
> result's eligibility.
>
> `docs/prospero_amendment_draft.md` has not been extended to cover them.

This log records every departure from the registered record, with its date and rationale. It mirrors, and does not replace, the dated PROSPERO amendment drafted in `prospero_amendment_draft.md`. A repository file is not a registry entry, and reviewers check the registry.

Each entry states whether the decision was made **before** or **after** pooled outcome data were seen. D1 to D8 were recorded before a pooled real-data result was examined. The purposive engineering pilot later produced an unreportable pooled estimate under the superseded design-based rule. D9 is therefore labelled **post-pilot, before definitive extraction and synthesis**. No pilot result may be used as a review finding.

**D13 and D14 are later still, and are labelled hardest of all: they were made *during* Stage F, after the counts they admit had been extracted.** Neither was prompted by a pooled estimate, since none has been fitted, but both were prompted by seeing a specific result blocked. Each entry states this plainly rather than presenting the decision as prospective, and each records that the conflict was surfaced by extraction, put to the authorship group with the affected result named, and ratified. A reader assessing this review for data-driven decision-making should start with D13 and D14.

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
| Prevalence from an eligible whole cohort, irrespective of parent design | JBI critical appraisal checklist for prevalence studies, with trial-origin applicability recorded where relevant |
| Effect from a randomised comparison | Cochrane RoB 2 |
| Effect from a non-randomised intervention study | ROBINS-I |

**Rationale:** RoB 2 assesses the risk of bias in an estimate of the effect of assignment to an intervention. It does not assess whether the sampling frame and recruitment are appropriate for a prevalence estimand. Applying it alone to prevalence would produce judgements that do not correspond to the estimand being assessed. A trial-derived whole cohort therefore receives a JBI appraisal for its prevalence result and a separate RoB 2 assessment for any treatment-effect result.

**Consequence:** the risk-of-bias judgements in the MSc supplementary material are not migrated. That table applies the RoB 2 category "Some concerns" to quasi-experimental studies nominally assessed with ROBINS-I, mixing two instruments' response scales. All risk-of-bias assessment is redone.

---

## D3. Separation of prevalence and intervention estimands (historical specification; superseded by D9)

**Date:** 5 August 2026. **Prospective.**

**Registered:** a single random-effects meta-analysis of "the pooled proportion of employment across studies", with both randomised and non-randomised designs eligible.

**Deviation:** two estimands are synthesised separately. The primary pooled prevalence uses observational cohorts only. Intervention evidence is synthesised as within-study treatment effects.

**Rationale:** participants randomised into a vocational trial are typically required to be unemployed, to want to work, to be clinically stable and to consent to a service. Their employment rate is conditioned on that selection and does not estimate employment in the underlying psychosis population. Pooling the two would produce a number that answers neither question. Separately, pooling all intervention arms against all non-intervention arms across studies would discard randomisation and confound the intervention with whatever distinguishes trials that offer it, so it cannot support a causal claim.

**Mitigation:** trial control and treatment-as-usual arms may be added to the prevalence estimate in a named sensitivity analysis, after a written comparability review of their eligibility criteria. That result is reported alongside the primary, never in place of it.

**Status:** superseded on 11 August 2026 by D9. The separation of prevalence and intervention effects is retained, but parent study design no longer determines eligibility for the whole-cohort prevalence synthesis.

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

## D6. Paid employment is separated from education and training

**Date:** 5 August 2026. **Prospective.**

**Registered:** primary outcome "Employment status (including full-time employment, part-time employment, sheltered employment, education/training programs)".

**Deviation:** the primary headline construct is point-prevalence **any paid employment**. Education and training are retained as registered outcomes but are not counted as employment in the primary numerator. EET, education, training, competitive paid employment, and paid sheltered or otherwise non-competitive employment are separate outcome families.

**Rationale:** the registered record places full-time employment, part-time employment, sheltered employment and education/training programmes within a broad outcome domain but does not require them to be pooled. It also prespecifies analysing different definitions of employment separately. Paid work measures labour-market participation. Education and training measure educational or vocational participation and vary with age, service model and national systems. Two cohorts with identical paid-employment rates can therefore have materially different EET rates. Keeping the constructs separate gives each pooled quantity a stable interpretation while retaining every registered outcome.

**Classification:** only `paid_any`, explicitly reported or derived from exact mutually exclusive and exhaustive paid categories with a common denominator, enters the primary pool. Competitive-only and sheltered-only results are not substitutes. Supported employment is classified by the nature of the job because support can be delivered in an ordinary competitive job. Education and training are separated when possible; an EET or education-or-training composite is retained when the source does not permit separation. Point prevalence, period prevalence and cumulative employment attainment are analysed separately.

**Consequence:** the single row currently in the repository (`sturup2022`, "work as primary income source or registered student") does not enter the primary estimate as recorded and must be re-extracted against the primary construct if the source can be obtained.

**Timing clarification:** this hierarchy was specified prospectively on 5 August 2026 and reaffirmed on 11 August 2026 after the registered wording was re-read. Designating paid employment as the sole headline outcome and EET as key secondary still requires the proposed PROSPERO amendment because it changes the registered hierarchy.

---

## D7. Publication and missing-evidence assessment

**Date:** 5 August 2026. **Prospective.**

**Registered:** section 3.7.4, "Publication bias will be assessed using funnel plots, Begg's test, and Egger's test", with trim-and-fill if bias is detected.

**Deviation:** trim-and-fill and Begg's test are not run. A contour-enhanced funnel plot is presented descriptively, Egger's regression is reported only where at least ten cohorts contribute and is interpreted as small-study effects, and a structured narrative assessment of missing evidence is added.

**Rationale:** these tests are unreliable for highly heterogeneous proportions, and Cochrane advises against asymmetry tests with fewer than ten studies while noting that asymmetry has causes other than publication bias. Trim-and-fill assumes a specific selection mechanism that is not plausible for prevalence estimates, where a cohort's employment rate is rarely the reason a paper is published. Running them mechanically would produce numbers without evidential value.

---

## D8. Search currency

**Date:** 5 August 2026. **Resolved 12 August 2026.**

**Registered:** databases searched from 1 January 2016 to 2 June 2025.

**Deviation:** the search window is extended. The executed search runs from 1 January 2016 to **9 June 2026**.

**Resolution:** the earlier record in this repository treated 2 June 2025 as the live close date and flagged the 2026 publication years in the set as a contradiction. That was an error of this log, not of the review. 2 June 2025 is the close date of an **earlier** search. The search update was run and closed by the review team on 9 June 2026, and the reports carrying 2026 publication years fall inside the executed window.

**The frozen report universe.** `DATA_EXTRACTION_FINAL.xlsx` (sheet "Prachee - Data Extraction", 90 rows, every row marked `INCLUDE`) and the 90 PDFs in `dissertation_shared_folder/Data Extraction Papers` are the authoritative record of what the search returned and what passed screening. Neither is superseded by anything in `data/`. The PRISMA flow of 3 August 2026 records 6,698 records identified, 2,762 duplicates removed, 3,936 screened, 279 sought and assessed at full text, 189 excluded (wrong population 4, wrong outcome 99, wrong study design 86) and **90 reports included**. The three staged PRISMA figures of 23 June, 6 July and 3 August 2026 all carry the same n = 90.

**Consequences.** The report universe is frozen at 90, so Stage F batching is fixed against it and no longer waits on a search. Publication years from 2016 to 2026 are in scope by design. The new end date is carried into the PROSPERO record by the amendment, and no further search or deduplication run is required before the definitive analysis. The six reports in `data/inclusion_manifest.csv` that were never on the screening list keep `not_in_screening_set` under D10.1, which the frozen universe reinforces: reinstating any of them needs a documented screening-list amendment.

---

## D9. Employment selection replaces parent design as the primary prevalence gate

**Date:** 11 August 2026. **Post-pilot, before definitive extraction and synthesis. Ratified by the authorship group 12 August 2026.**

**Registered:** both randomised and non-randomised longitudinal study types are eligible, and the record does not define an employment-selection restriction for the primary synthesis.

**Previous specification:** D3 restricted the primary pooled prevalence to observational cohorts and excluded trial-derived participants by parent study design.

**Revised specification:** a whole recruited cohort may enter the primary prevalence synthesis irrespective of parent design when recruitment and the analysed denominator were not selected on employment-related criteria. Employment-related selection includes baseline employment or unemployment, wanting or readiness to work, an employment goal, vocational-service eligibility or participation, current vocational placement, or previous employment failure. Selection is coded `none`, `selected` or `unclear` with the source wording and location. Only `none` enters the primary synthesis.

Allocated intervention, active-control and treatment-as-usual arms remain outside the prevalence intercept. A trial-derived whole cohort is eligible only when every original allocation group is represented without omission or selective reweighting, the same construct and ascertainment apply across groups, no post-randomisation subgroup is selected, and the intervention was not specifically intended to change employment. Employment-selected samples remain eligible for the review, intervention-effect synthesis, or a separately labelled selected-population analysis.

**Rationale:** parent design is an unreliable proxy for the population being estimated. The pilot exposed both directions of error: the observational Chen vocational cohort entered despite selection through vocational placement, while the merged OPUS cohort was excluded despite no employment-related recruitment criterion. Applying the proposed rule to the pilot does not increase the amount of evidence: it replaces eight Chen rows with eight OPUS rows at the initial gate, and leaves only one result at twelve months under the current broad construct configuration. The decision is therefore not justified by improved power or a favourable pooled result. Random-effects heterogeneity cannot correct systematic conditioning on factors that determine employment.

**Sensitivity and transparency:** samples with `unclear` selection enter only a named sensitivity analysis. A separate sensitivity excludes all trial-derived cohorts. Trial origin is retained as provenance and considered in applicability. The pilot result under the superseded rule remains an historical engineering artefact and will not be rerun as an inferential analysis.

---

## D10. Screening set and eligibility dispositions

**Date:** 11 August 2026. **Post-pilot, before definitive extraction. No count from any of these reports had been seen when the rule was written.**

### D10.1 Reports never on the screening list are not eligibility decisions

Six staged reports were never on the `DATA_EXTRACTION_FINAL.xlsx` screening list of 90: `bjornsdottir2022`, `mackinley2022`, `peralta2025`, `brown2022`, `delpiccolo2024`, `wang2020`. Three of them carried `eligibility_status = include` while also carrying `source_available = no`, which is a contradiction. Left unchanged they would have entered the PRISMA eligibility flow, making the review appear to have assessed 96 reports and included 62.

They now take `eligibility_status = not_in_screening_set`, a disposition rather than an eligibility judgement, and are excluded from the eligibility flow. The rows are retained because deleting them would erase the record of what was staged. The PRISMA flow covers exactly the 90 screened reports: **80 include, 7 linked_report, 3 pending, 0 exclude** (see D10.2 for why the excluded count is now zero). This matches the published PRISMA figure of 90 reports included.

**This is not a finding that the three are ineligible.** Two plainly report usable figures. It is a finding that they were never screened in, and a report cannot enter a synthesis without passing the screening it is supposed to have passed. Reinstating any of them requires a documented screening-list amendment, not a status change.

### D10.2 Eligible but not quantifiable is recorded as such, not as an exclusion

Twenty-one reports were excluded with reason `no_extractable_data`. That conflates two different things: a report that fails the eligibility criteria, and a report that meets every criterion but prints only a percentage. The second is eligible evidence the review could not use, and it belongs in the missing-evidence assessment rather than disappearing from the eligible count.

A new field `report_quantifiable` (`yes`/`no`/`unclear`) separates the two. A report with no recoverable numerator or denominator stays `include` with `report_quantifiable = no`. Its loss then appears at the numerator/denominator gate in the pool attrition log and in the missing-evidence assessment, where a reader can see it.

**Applied 12 August 2026, by `scripts/reinstate_screened_includes.py`.** The 21 rows are now `include` with `exclusion_reason = not_applicable` and `report_quantifiable` blank, to be filled from the paper during the Stage F re-read. The change was made ahead of the re-read rather than after it because D8 froze `DATA_EXTRACTION_FINAL.xlsx` as the authoritative screening record and every one of its 90 rows is marked `INCLUDE`: no report in the screened set was ever excluded at full text by the review team, so a manifest carrying 21 exclusions contradicted the authority it is supposed to describe. **This changes the PRISMA flow**, and it changes it towards the published figure: the eligibility box now reads 90 reports included and none excluded after inclusion, with unquantifiable reports appearing later, at the numerator/denominator gate.

**This is not a finding that any of the 21 is usable.** Most probably are not. `report_quantifiable` stays blank until someone has read the paper, and a blank is not a `yes`.

---

## D11. Prespecifications closed before definitive extraction

**Date:** 11 August 2026. **Prospective: written and committed before any definitive count was extracted.**

Three questions the SAP left implicit, closed now so they cannot be settled after seeing the data.

**D11.1 The overlapping horizon boundary.** The 12-month band is 9 to 18 months and the 24-month band is 18 to 30, so 18 months falls in both. The code previously assigned it to whichever band appeared first in the configuration file, making a scientific assignment an artefact of yaml ordering; the configuration validator only warned. A result is now assigned to the band whose landmark is nearest, with an exact tie going to the **longer** horizon. **18 months is therefore t24m.**

**D11.2 Result selection by proximity to the landmark.** SAP section 4 defines the primary estimate as "the reported timepoint closest to 12 months within a window of 9 to 18 months", but the implemented selection order began with largest analysis population, so a cohort reporting both 10 and 17 months could contribute the more distant timepoint. Proximity to the landmark is now the first selection rule, and the SAP section 5 order breaks remaining ties.

**D11.3 The sparse-data rule.** Counted in **distinct cohorts**, not result rows: zero cohorts gives no estimate for that horizon; one cohort gives a descriptive exact binomial interval, explicitly labelled as one cohort's observed proportion and not a meta-analysis; two or more permits the planned model with a stated small-k qualification and prior sensitivity reported alongside. If a horizon falls below threshold, **the primary fit for that horizon stops and nothing else does**. Extraction, the other horizons, the secondary estimands and the rest of the review continue, and no prespecified rule is relaxed.

The pilot report anticipated that the revised primary pool might be empty. That is why this rule is written now rather than when the number is known.

**Application clarification, 13 August 2026.** D11.3 is unchanged. What is written down here is *when* the count it turns on is taken: **k is counted on the verified, frozen pool at each horizon**, not on a provisional pool during extraction or verification. A cohort counts towards k once every field that determines its pool membership has been human-verified and the inputs have been frozen at the tagged input commit; before that the pool is a working figure that can move in either direction, as it has during Stage F.

This is a clarification of how an existing rule is applied, not a new or modified stopping rule, and it is recorded now for a specific reason: at the time of writing the provisional twelve-month pool stands at k = 3 with a fourth candidate one reversible gate away, so k currently sits either side of the boundary between "descriptive interval only" and "the planned model". Fixing the timing of the count while that is still true means the rule cannot later be read as having been settled in the light of the k it produces. Nothing about the thresholds, the counting unit or the consequences changes.

---

## D12. Extraction schema decisions

**Date:** 11 August 2026, revised 12 August 2026 after the pilot rechecks. **Post-pilot and pilot recheck, before definitive extraction. Ratified by the authorship group 12 August 2026.**

Labelled this way rather than simply "prospective" because these rules were written after the pilot was extracted and after the Stage B rechecks had read eight of its papers. No definitive count informed them and no pooled estimate was examined, but the rechecks did surface the specific cases below, and D12.3 in particular was **rewritten because a recheck disproved its first version**. That sequence is recorded rather than smoothed over.

**D12.1 A paid-or-education composite is representable.** The codebook's v0.2 vocabulary deleted `paid_or_education` on the ground that it "does not reveal whether training is included", replacing it with `paid_or_education_or_training`. Applying that literally to the pilot rows would have required coding Hansen's "working or studying at the 20-year follow-up" and Tarricone's "full time study was considered employment" as composites naming training, which those sources do not. Deleting the value forces a misstatement; the distinction the codebook wanted is obtained by keeping **both** values so the extractor must choose. `paid_or_education_or_training` is reserved for composites that name all three, such as NEET and Twumasi's "competitive employment formal education or a vocational training program". Neither enters the primary pool.

**D12.2 `result_role` and derived counts.** Every result is `reported`, `derived` or `component_only`.

**Being used as a component is a relationship, not a property of a result.** A directly reported competitive-employment count is a valid secondary result in the competitive-employment family *and* may contribute to a derived `paid_any` total; it stays `reported`. Double counting is prevented by pools being construct-specific, not by suppressing the row. `component_only` is reserved for fragments with no independent analytical meaning, such as a single intensity band, and those never enter any pool.

A `derived` row must state its arithmetic. Where it names components, the sum is **recomputed in R** and must match; the components must share cohort, arm, timepoint, ascertainment **and ascertainment window**; the derived row must sit on the **same denominator** as its components; and `derivation_mutually_exclusive` and `derivation_exhaustive` must both be asserted `yes`.

**D12.3 Employment reported as intensity bands. (Rewritten 12 August 2026; the first version was wrong.)**

Derive `paid_any` from intensity bands only when the categories are mutually exclusive and exhaustive **and zero work is separable from every category containing positive paid work**. If a residual category combines zero work with positive low-intensity work, `paid_any` is **not identified**. Leave its numerator unrecoverable, record the bounds, and retain any exact threshold-defined result as a separate non-primary construct.

The first version of this rule said the opposite: sum every band involving any paid work. A recheck of `rautio2016` disproved it. That paper's lowest band is `<25.0%`, **not `0%`**, so it pools people with no working days at all together with people who worked 1 to 24.9 per cent of working days. Summing the bands above the threshold gives an exact count of 18 of 161 employed for at least 25 per cent of working days; the number in *any* paid work is bounded only by 18 ≤ paid_any ≤ 161 and cannot be recovered. A derived `paid_any` from those bands would have been a fabrication carrying a plausible-looking value into the primary estimand.

Enforced by `derivation_zero_separable`, which the validator requires to be `yes` whenever the derived construct is `paid_any`.

**D12.3a `paid_intensity_threshold`.** A threshold-defined result such as "employed for at least 25 per cent of working days" is a **precisely defined** construct and is recorded as `paid_intensity_threshold`, not as `unclear`. It never enters the primary pool and never substitutes for `paid_any`: excluding everyone below the threshold changes the numerator while retaining a paid-employment label, which is the same error as substituting a competitive-only count.

**D12.3b `followup_basis`.** Only a timepoint measured from cohort entry can be assigned to a landmark horizon. A mean time since onset, or a measurement taken at a fixed chronological age, is not an elapsed follow-up. `rautio2016` is the case: its measurement point is chronological age 44 to 45, and the 210 months recorded against it is the **mean** time since onset across a cohort whose individual follow-ups ran from 5 to over 20 years. Assigning that to the ten-year horizon would place a cohort in a landmark band on the strength of an average and mix age-anchored with time-anchored measurements in one pooled estimate.

**D12.3c Post-randomisation subgroup selection is not outcome attrition.** The SAP 2.1 safeguards concern allocation groups: whether every original group is represented, and whether a post-randomisation *subgroup* has been selected. Ordinary loss to follow-up is not such a selection. It belongs in `n_outcome_observed`, `missing_data_method`, the risk-of-bias assessment and the prespecified bounding analyses (SAP section 6). Reading attrition as subgroup selection would fail every study in the review, on a gate not designed to carry it.

**D12.3d Unresolved published conflicts block a result.** Where a source contradicts itself about a result, `conflict_status = unresolved` **blocks that result from every synthesis** until an author reply resolves it, or permanently if none comes. A note alone is insufficient: a numerically complete row remains analytically usable and would enter a pool silently. Currently blocking `hansen2024`'s two Table 2 employment rows (subgroups sum to 99 and 52 against printed totals of 105 and 54) and both `mihaljevicpeles2016` endpoint rows (205 versus 257, compounded by 71 versus 52 pensioners omitted).

**D12.4 Moderator percentages are derived from their own counts.** A human reviewer asked for `perc_female` to be computed where a source gives counts but prints no percentage. Counts are now recorded in `n_female`, `n_post_secondary` and `n_employed_baseline`, **each with its own denominator** because these are routinely reported on different subsets of one sample, and the percentage is computed in R. A typed percentage is permitted only where the source prints nothing else, and a typed value contradicting its own counts stops the run rather than being silently overwritten.

**D12.5 Parallel cohorts get separate cohort identifiers.** Two independently recruited samples described in one report are two cohorts, not two `subgroup` arms of one. `subgroup` is reserved for a post-hoc split of a single recruited sample. The pilot lost `dayabandara2026`'s 12-month result to this.

**D12.7 Risk-of-bias domain slugs are a controlled vocabulary, and the domain set is required in full. (Added 12 August 2026, during Stage F.)** The schema fixed the instruments and their judgement scales but left the domain identifiers free text. The first two Stage F batches consequently coded the same JBI checklist as `jbi1_sample_frame` to `jbi9_response_rate` and as `q1_sample_frame` to `q9_response_rate`. Neither was wrong; nothing said. Left alone, thirteen batches would have produced thirteen vocabularies, no merge could have reconciled them and no domain-level summary could have crossed a batch boundary.

`rob_domain` in `config/vocabularies.yml` now fixes the slugs per instrument, and the validator rejects both an unlisted slug and a result missing any domain of its instrument. The instrument-prefixed form was chosen over the bare `q1..q9` form because RoB 2 and ROBINS-I also number their domains, so `q1` stops identifying a domain as soon as one dataset holds two instruments.

Completeness is enforced as well as membership because an absent domain is an unasked question, and once an appraisal is summarised it is indistinguishable from a favourable answer. A domain that genuinely does not apply takes the instrument's own `not_applicable` judgement with a rationale.

**This is a schema decision made after two batches had been extracted, and it is labelled as such rather than presented as prospective.** The second batch's nine slugs were remapped position to position onto the canonical set, which is exact because the JBI checklist is numbered 1 to 9 in a fixed order. No judgement, rationale, source location or result was altered by the remapping. The batch ledger records which prompt version produced which shard: F01 and F02 ran under `extraction_v1.md`, everything after under `extraction_v2.md`.

**D12.8 `calendar_end_common` follow-up. (Added 12 August 2026, during Stage F.)** D12.3b barred a mean time since onset and a fixed chronological age from the landmark horizons. Stage F found a third form of the same failure, and a far commoner one: a cohort followed from entry to a single shared calendar end date, so elapsed follow-up varies across participants and the reported figure is its mean. `andersen2026` is the case, with individual follow-ups of 4.5 to 23.5 years and a mean of 11.1; that mean spans two landmark bands.

The extractor recorded it as `unclear`, which blocks the horizon correctly but misdescribes the source: the report is entirely clear about what it measured, and `unclear` would have been read as poor reporting in the risk-of-bias and missing-evidence assessments. `followup_basis` therefore gains `calendar_end_common`, which is barred from every horizon exactly as `unclear` is.

**This changes no result's eligibility**, since both values block identically. It changes only whether the review describes a clearly reported study as unclear. Register-based studies routinely censor at a common date, so this will recur.

**`since_baseline_mean`, added the same day for the same reason.** A fourth form appeared immediately: a mean or median elapsed time since cohort *entry*, across a cohort whose individual follow-ups differ. `liangrong2021` is the case, with a median of 67 months across admissions spanning 2000 to 2013. It is not `since_onset_mean`, which is anchored on illness onset; it is not `calendar_end_common`, which requires a shared end date that a cohort with a 0.2-year minimum follow-up cannot have; and it is not `unclear`, because the report is explicit. Two batches in succession reached for whichever barring value was nearest and said so in their queries. The horizon was barred correctly each time, so **no result's eligibility changes here either**; what changes is that the record stops asserting something untrue about the source. 67 months would otherwise have fallen inside the five-year window of 48 to 78 months, so the bar is load-bearing, not cosmetic.

**D12.6 `rob_overall` is suspended as a moderator.** It was listed as an exploratory moderator, which would put an overall risk-of-bias rating into an analysis, but nothing defines how to derive one from JBI's nine items, RoB 2's five domains or ROBINS-I's seven, and D2 forbids collapsing the three scales onto a shared one. Inventing a rule now would manufacture a composite with no standing in any instrument. It is commented out rather than deleted, and is reinstated only if the authorship group prespecifies a per-instrument derivation rule.

**D12.9 A derived count may name a disputed component when the derived row is itself disputed.** **Date: 13 August 2026, at the Stage G merge. Changes no result's eligibility.**

The validator forbade any derived count whose component carried `conflict_status = unresolved`, on the stated ground that the conflict would be laundered into a clean-looking total. The merge surfaced the case the wording did not anticipate: `benson2022_relapse_mostrecent_paidany`, 929 of 16,311, is derived from a full-time component whose printed count and printed percentage contradict each other (the subject of `REQ-benson2022-1`), and the derived row **is itself marked `unresolved`**.

Nothing is laundered there. The total is as visibly disputed as its part, and both are blocked from every pool by the same rule. The test is therefore scoped to the case that can actually launder: a component may be `unresolved` only when the derived row is too. Forbidding the row outright would delete the arithmetic rather than flag it, and the derivation would have to be rediscovered when the authors answer.

This changes no result's eligibility, because both rows were blocked before the change and remain blocked after it. It is recorded because it is a validator rule altered while looking at real data, which is the circumstance that requires disclosure whether or not it changes an answer.

**Not needed, and recorded so:** the partition-sum case that batches F10 and F08 asked for was already implemented in `build_primary_pool()`'s validator before the merge ran. The two F10 derived rows therefore had their component identifiers restored without any rule change, and only the single `jirapramukpitak2022` row was created.

---

## D13. The diagnosis gate: the 50 per cent rule is sufficient on its own

**Date:** 12 August 2026. **Post-pilot, during Stage F extraction. Ratified by the authorship group.** The result it admits had been extracted when the rule was clarified, and this entry says so rather than presenting the clarification as prospective.

**Registered and prespecified:** SAP section 7, "At least 50 per cent of the sample has a qualifying psychosis diagnosis, **or** a qualifying subgroup can be extracted separately."

**Issue:** the implementation did not match. `config/analysis.yml` and `build_primary_pool()` admitted an `smi_mixed` cohort only when the percentage rule was met **and** `subgroup_extractable == "yes"`, and the configuration comment described that conjunction as "per SAP section 7". It is stricter than the prespecified rule, and stricter than the rationale recorded immediately beside it, which argues that "the prespecified 50 per cent rule admits it, so the rule wins and the label yields".

The discrepancy survived the pilot because `carstairs_1992`, the only `smi_mixed` cohort in it, satisfied both conditions. `khare2022b` is the first case to separate them: 90 per cent schizophrenia-spectrum, a whole recruited cohort, and no separately extractable subgroup.

**Clarified specification.** A whole `smi_mixed` cohort is eligible for the primary estimand when at least 50 per cent of participants have a qualifying psychosis diagnosis. `subgroup_extractable` is **not** an additional requirement. Where fewer than 50 per cent qualify, an extractable diagnostic subgroup may be retained for a **separately labelled subgroup analysis**, but it does not enter the whole-cohort primary estimand unless the SAP explicitly creates that exception, because a subgroup arm is not a whole recruited cohort. `chr` remains excluded entirely and unconditionally.

**Rationale.** The prespecified document governs, and the implementation was wrong relative to it. The clarification also removes a real ambiguity in the registered wording: read literally, the "or" branch offered a route into the primary pool that the pool could never honour, since the primary estimand admits only whole recruited cohorts. Stating which branch does what removes that contradiction rather than relaxing a criterion.

**Direction and transparency.** This change **admits** evidence rather than excluding it, and it was made after the affected result was seen. That is the harder direction to defend, so the sequence is recorded plainly: the conflict was surfaced by the F04 extraction, put to the authorship group with the affected result named, and ratified. `khare2022b`'s 53 of 107 at 12 months enters the primary pool subject to every other gate and to independent human verification, which has not yet been done. No other prespecified rule was relaxed, and no result already excluded on any other ground was revisited.

---

## D14. Partition sums across mutually exclusive subgroups

**Date:** 12 August 2026. **Post-pilot, during Stage F extraction. Ratified by the authorship group.** As with D13, the results it admits had already been extracted when the rule was settled, and this entry says so.

**Issue.** D12.2 required a derived count's components to sit on **one common denominator**. That is right for a *category* sum, which adds mutually exclusive outcome categories within one arm: full-time plus part-time plus self-employed gives `paid_any` on the same denominator. It silently forbade a *partition* sum, which adds one construct across mutually exclusive subgroups whose denominators sum to the whole. Batches F08 and F10 hit this independently and withheld correct counts on it. The largest was `jirapramukpitak2022`: 146/372 and 43/177 verified cell by cell, summing to 189/549 on a cohort with `employment_selection_status = none`, which is one of the few cohorts in the review eligible for the primary pool at all. It was the only usable result in Stage F withheld on a schema question rather than on the evidence.

**Ruling.** A whole-analysis-unit count may be derived by summing results across mutually exclusive subgroups when the source establishes that the subgroups jointly exhaust the **observed-case analysis population** for that result. The components must describe the same cohort, report, timepoint, follow-up basis, exact outcome construct, ascertainment method, ascertainment window and denominator basis. Their numerators and denominators must be published integer counts; the component numerators must sum exactly to the derived numerator, and their denominators must sum exactly to the derived `n_outcome_observed`. The derived result must represent the parent whole-cohort analysis unit, without subgroup omission, overlap or selective reweighting. Every component must be free of unresolved numerical conflict, and the derivation must be independently checked.

**"Whole cohort" means the complete observed-case analysis population at that timepoint**, not necessarily everyone recruited at baseline. This aligns the rule with the available-case estimand in SAP section 6 rather than creating a second, stricter notion of completeness that no report would satisfy.

**The rule applies to every outcome family.** Arithmetic validity does not depend on whether the result is `paid_any`, an EET composite, point prevalence or period prevalence. Eligibility for any particular synthesis remains governed separately by construct, ascertainment, horizon, population, conflict status and the other pool gates, which are untouched.

**Implementation.** The two sums are told apart **structurally rather than by a flag**: components sharing an arm are a category sum, components on different arms are a partition sum. A flag could contradict the arithmetic it describes, leaving nothing to say which was wrong. The construct must match across a partition's components and must *not* be required to match across a category's, since a category sum builds `paid_any` precisely out of components whose constructs differ from the total's; conflating the two would forbid the derivation D12.2 exists to permit. Enforced in `build_derived_checks` within `R/lib_data.R`, with tests for exact denominator summation, for both assertions being required, and for refusing any derivation resting on a component with `conflict_status = unresolved`.

**On "independently checked".** This is **not** implemented as a new pool gate. Stage G already requires independent human verification of every pool-determining value, derived-count provenance explicitly among them, before the freeze. A partition-derived row is therefore checked by the machinery that already exists, and `data/extraction_provenance.csv` remains the ledger that records it. Adding a second, partition-specific gate would have implied that other derived counts need less checking, which is the opposite of the intent.

**Direction and transparency.** Like D13 this change **admits** evidence rather than excluding it, and it was made after the affected counts were seen. The conflict was surfaced by two independent extraction batches, put to the authorship group with the affected result named, and ratified. It does not revisit any result excluded on other grounds, and it does not relax the prohibition on back-calculating a count from a percentage, which remains absolute.

---

## Non-deviations, recorded to prevent confusion

- **Extraction by a machine checked by a human** is what the record already specifies ("Data will be extracted by one person (or a machine) and checked by at least one other person (or machine)"). The LLM-assisted extraction used here is within the registered process, not a departure from it. Every field determining inclusion or the primary estimate is checked independently.
- **The 15-report pilot** is engineering validation, not a registered analysis. It produced a numerical pipeline output but no reportable estimate. It requires no amendment as an analysis, although decisions made after inspecting it are dated above.
