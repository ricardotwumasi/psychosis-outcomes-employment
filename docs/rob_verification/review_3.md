# Independent AI source verification, allocation 3

Date: 1 October 2026. Verifier: Codex AI independent verification agent 3.

The accompanying `verification_3.csv` records independent source checks for all 499 assigned existing risk-of-bias domain rows. There are 451 retained judgements and 48 proposed judgement corrections. Every assigned row has an outcome-specific replacement rationale, a source locator, the original judgement and the verified judgement. Agreement concerns the judgement category; retained categories can have substantially repaired rationales. This is 100% source-verification coverage of this allocation, not a claim of independent human verification, complete signalling-question assessment, valid instrument routing or readiness to release the analysis.

## Scope and method

I examined the assigned original judgements and rationales against the local full-text PDFs, concentrating on recruitment, inclusion/exclusion, allocation, follow-up availability, occupational definitions, ascertainment, table arithmetic, analysis and limitations. Shared checks were reused only for the same report and relevant sample. Time-specific missingness and arm-specific measurement/statistical concerns were assessed separately. The CSV identifies the actual construct, time basis and available numerator/denominator for each assessed result; these references do not constitute re-extraction or correction of the underlying outcome table.

The methodological controls consulted were SAP section 8, the RoB instrument/category section of the codebook, and `docs/verification_wave_1_brief.md`. JBI items 6 and 7 were interpreted as employment or the stated occupational condition, rather than psychosis eligibility. The official JBI prevalence checklist supports this distinction: [JBI checklist for prevalence studies](https://jbi.global/sites/default/files/2019-05/JBI_Critical_Appraisal-Checklist_for_Prevalence_Studies2017_0.pdf). A valid diagnostic assessment does not itself validate occupational ascertainment. Conversely, a work/education composite is not automatically invalid when the extracted estimand is precisely that composite.

The local Solmi data supplement was examined, including visually rendered Figures S2 and S3 on pages 8 and 9. The local Fulford legacy Word supplement was read using a read-only text conversion, including eTables 1-5. Image-based Benson Tables 1 and 3 and participant-flow figure, and the Domenicano flow figure, were visually checked. Source-specific table/figure inconsistencies were not silently repaired in the outcome data. All frozen extraction shards, merged outcomes and provenance records were left unchanged.

## Source inventory and coverage

All entries below refer to the local PDFs identified in the CSV. A row count includes domain rows, not unique people, publications or independent effect estimates.

| Report | Domain rows examined | Judgements changed | Principal source sections inspected |
|---|---:|---:|---|
| Basaraba 2023 | 72 | 0 | Cohort/training split, quarterly clinician outcome definition, follow-up table and censoring/discharge notes |
| Bell 2018 | 24 | 0 | Recruitment/randomisation, blinded assessments, vocational records, Tables 1-3, follow-up denominators and limitations |
| Benson 2022 | 18 | 1 | VHA cohort/matching, employment-field timing, visual Tables 1/3 and participant flow |
| Bhullar 2018 | 18 | 1 | Long-term recruitment/flow, Life Chart Schedule definition, Table 2 and limitations |
| Conus 2017 | 9 | 0 | EPPIC consecutive admissions, chart assessment, Modified Vocational Status Index, discharge timing and denominators |
| Cook 2016 | 45 | 5 | EIDP recruitment/linkage, SSA earnings measurement, Tables 1-3, historical 24-month percentages and administrative limitations |
| Domenicano 2025 | 36 | 6 | Consecutive cohort, visual flow diagram, follow-up exclusions, Table 2 and employment/NEET classification |
| Drake 2015 | 63 | 6 | Original trial/extension, annual interview availability, competitive-work definition, Table 3 and incomplete follow-up comparison |
| Evensen 2019 | 9 | 0 | JUMP consent-linked subgroup, specialist/NAV tracking, occupational counts and consent comparisons |
| Fulford 2018 | 18 | 4 | RAISE participants, SURF items/monthly aggregation, Table 1, variable-specific missingness, FIML and local eTables |
| Khare 2021 | 9 | 2 | Private-clinic convenience recruitment, interview methods, family-income imputation, response differences and occupational partition |
| Khare 2022b | 9 | 1 | Public-clinic referral/flow, interview methods, stated paid-work focus, attrition differences and occupational partition |
| Leighton 2019b | 18 | 0 | CRISP/GLED recruitment, EET labels, cohort sizes and outcome tables |
| Luo 2019 | 24 | 2 | Independent sequence/concealment, modified analysis population, employment definitions, occupational subdivision and limitations |
| Maguire 2021 | 9 | 2 | EPPIC census/waiver, country-of-birth exclusions, work/study category, discharge timing and Table 1 |
| McGurk 2016 | 36 | 6 | Off-site concealed randomisation, vocational definitions/tracking, interval-specific availability, Table 3 and limitations |
| Mucci 2021 | 9 | 2 | Initial/follow-up network, recruitment detail, work-function differences in nonparticipants and ambiguous working-status denominator |
| Shimada 2022 | 12 | 0 | Parent-trial referral, post-treatment/discharge exclusions, SFS subscale measurement and complete-case follow-up |
| Solmi 2022 | 27 | 6 | Register cohort, income/main-activity rule, pension exclusions, Figure 1, supplementary methods and Figures S2/S3 |
| Tsiachristas 2016 | 16 | 2 | Administrative baseline/exposure definitions, propensity weighting, imputation, Tables 1/3/5, timing sensitivity and limitations |
| Yamaguchi 2020 | 18 | 2 | Agency/client participation, eligibility, contract-based employment definition, Tables 1/2, service inventory methods and limitations |
| **Total** | **499** | **48** | **Complete assigned existing-row coverage** |

## Material corrections

Benson's non-relapse statistical-analysis judgement changes from `no` to `yes`. Its employment counts and percentages are coherent. The relapse employment-column arithmetic remains defective, but that defect and an unrelated cancer-table error cannot be applied automatically to the non-relapse occupational result. Lack of a printed confidence interval does not, by itself, establish an invalid descriptive calculation.

Bhullar's paid-only condition-identification judgement changes from `yes` to `unclear`, because the employed/unemployed category lacks operational employment ascertainment criteria. The explicitly measured sustained work/education composite retains its favourable measurement judgement. Its Life Chart Schedule and 52-week threshold are relevant to that composite, not proof of the separately reported paid-only status.

Cook's whole-cohort employment-condition judgement changes from `unclear` to `yes`: SSA earnings are a valid objective method for identifying recorded formal paid earnings, irrespective of whether the report details a schizophrenia diagnostic instrument. Four historical 24-month arm measurement judgements change from `low` to `some_concerns`. The separate later SSA records cannot be assumed to have ascertained the contextual earlier trial-period percentages. Site/consent/linkage selection continues to support high comparative risk.

Domenicano's four employment-condition judgements change from `yes` to `unclear`; psychosis ascertainment does not define employment or NEET. Two standalone-employment measurement judgements change from `no` to `unclear`, because missing operational/reliability information is uncertainty, rather than affirmative evidence of invalid ascertainment. Follow-up selection and the conflicting 24-month counts remain unresolved. The 12-month male NEET count also conflicts with the table percentage and total.

Drake's coverage and response judgements at 12, 24 and 36 months change from `no` to `unclear`, giving six changes. The early interview completion rates of 86-89% cannot be evaluated using the much lower participation in the later naturalistic extension. However, the employment-specific denominators and competing six-month/year reference periods remain unresolved, so these early judgements do not become `yes`. Later attrition retains `no`.

Fulford's subjects/setting judgements change from `unclear` to `yes` at both waves, and its measurement judgements change from `no` to `yes` at both waves. The participants and multicentre community setting are described sufficiently, and the standardised SURF measures the extracted paid-work-or-study composite consistently. Six-month aggregation does not make the instrument invalid for that composite. It does prevent treating the reported aggregated percentages as simple person-level binomial counts without further information, so statistical-analysis concerns remain. The supplement does not provide the missing occupation-specific integer bases.

Khare 2021's coverage changes from `yes` to `unclear` because follow-up differs by diagnosis and the occupational analysis excludes three observed nonworking categories. Its paid-employment identification changes from `yes` to `unclear`, since assigning a share of family-business income does not establish actual remuneration of the individual family worker. Recruitment convenience and the untracked informed eligible denominator remain adverse. Khare 2022b's condition identification changes from `no` to `yes` using the explicitly stated paid-work focus and occupational interview, rather than judging diagnosis ascertainment. The small family-work subgroup still lacks separately documented remuneration and must retain the project's construct gate. These changes do not automatically clear either Pune result for the primary pool.

Luo's two competitive/transitional selective-reporting judgements change from `high` to `some_concerns`. An ACT-only occupational subdivision is incomplete comparator reporting, but does not itself prove that a numerical result was selected for its significance or magnitude. Other concerns and the high conditional comparative overall rating remain; an arm-prevalence appraisal is still required.

Maguire's occupational identification and measurement judgements change from `no` to `unclear`. Work or actively attended education is compatible with the extracted composite. Missing remuneration/ascertainment/reliability details create uncertainty; counting education does not invalidate an explicitly work/education outcome. Discharge timing, occupational missingness and the textual/table migrant percentage inconsistency remain unresolved.

McGurk's six randomisation-domain judgements change from `some_concerns` to `low`. Section 1.6 explicitly describes computer allocation by an off-site data manager, stratification, and no advance knowledge by study personnel. An isolated education imbalance does not establish failed randomisation. Follow-up gaps, unblinded vocational tracking, table-percentage inconsistencies and prospective-analysis uncertainty remain relevant to the respective domains.

Mucci's participant-sampling judgement changes from `yes` to `unclear`: invitation of all surviving baseline patients to follow-up does not prove representative initial recruitment. Employment identification changes from `yes` to `unclear`, because the working-status label lacks occupational operational criteria. Informative attrition and the unreported denominator behind 208/35.4% remain adverse.

Solmi's three condition-identification judgements change from `yes` to `unclear`, because the income cutoff used for occupational categorisation is incompletely specified; diagnostic coding is not the employment condition. Its three condition-measurement judgements change from `unclear` to `yes`, because the same objective national administrative classification is applied uniformly. The main figure explicitly names entry N=21,551, correcting the rationale's assertion that no denominator is reported at all. Its year-specific contributing denominators and integer counts remain absent. The supplement offers an earlier-diagnosis cohort with five linkage years and subgroup entry sizes; this partially addresses administrative follow-up uncertainty but does not restore prevalent disability pensioners or recover the main figure's yearly risk sets.

Tsiachristas's two selective-reporting judgements change from `serious` to `moderate`. The absence of an inspectable prospective plan leaves selection uncertainty, but difficult-to-reconcile complete-case bases and absent follow-up counts do not themselves establish result-based selective reporting. Serious overall risk remains because of confounding, selection, exposure classification based on future contact and extensive missingness. The replacement measurement rationale also acknowledges the reported time-interval sensitivity analysis and avoids claiming that routine records are necessarily group-independent or have no assessor.

Yamaguchi's two condition-identification judgements change from `unclear` to `yes`, based on the explicitly contract-supported definition of competitive work at the legal minimum wage or more. The missing 42 of 93 eligible clients and 13/25 agency participation remain adverse. Incomplete service-provision inventories are not evidence that employment contracts were missing.

Basaraba, Bell, Conus, Evensen, Leighton and Shimada retain all assigned judgement categories. Their replacement rationales specify the relevant occupational construct and availability, correct diagnostic/occupational conflation where present, distinguish vocational records from interview retention, and avoid unsupported assertions about prospective plans or the causes of trial deviations.

## Limits and integration

Several trial-origin arm proportions are currently assigned RoB 2, although SAP section 8 requires JBI for prevalence and RoB 2 for a randomised treatment effect. The CSV preserves a transparent source check of those existing comparative-domain judgements, while explicitly withholding closure of routing/signalling validity. A separate result-appropriate appraisal is still necessary. Intended intervention components and lack of participant blinding are not, on their own, deviations from intended treatment; uncertainty retained in these domains must be reviewed with the appropriate official signalling questions before declaring valid completed RoB 2 assessments.

The report inventory is bounded to the 499 assigned existing rows. It neither appraises omitted pilot results nor resolves previously missing assessments. Parent-trial protocols/analysis plans were not retrieved merely because a registration was named. Some recruitment detail and supplements referred to in source reports are unavailable locally, including Yamaguchi's flow diagram and Mucci's detailed participant supplement; the judgements record that limitation rather than inventing missing evidence.

The parent reviewer independently checked the private-clinic Khare 2021 source and can adjudicate that cohort separately from this agent's public-clinic Khare 2022b verification. This is a separation of AI checkers; it does not meet an independent human second-review requirement. The ledger should be integrated as a provenance-preserving overlay, with original judgements retained, rather than rewriting frozen extraction shards.
