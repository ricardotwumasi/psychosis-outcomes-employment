# Unresolved queries, batch F11

What an author, or in two cases a supplementary file, would have to supply before a blank in this
shard could be filled or a blocked result unblocked. Extracted 12 August 2026 under
`config/prompts/extraction_v3.md`.

Queries are ordered by how much they would change: those that would unblock a result or supply a
missing denominator come first within each report.

---

## mucci2021 (nirp_italy)

1. **What is the denominator for working status at the 4-year follow-up?** (Blocks
   `mucci2021_cohort_t48m_working`.) The report prints 208 (35.4%) but states the analysis sample
   as 618, and 208/618 = 33.7%. The printed percentages for working status at baseline and
   follow-up are both consistent with a base of 588, which would be the number of participants with
   employment status recorded at both timepoints, as the McNemar test the authors used requires.
   That reconstruction is this extractor's, not an authority, so the result is `unresolved` and the
   numerator carries no denominator. **One number from the authors, or eTable 2 itself, resolves
   this and would make the report quantifiable.**
2. **What does "working status" count?** No definition, instrument, threshold or ascertainment
   window is given anywhere in the article. In the Italian context the category could include
   protected or reserved employment, or registration on the disability employment lists that Table 1
   counts among "available incentives". `outcome_construct` is therefore `unclear`; a definition
   would allow it to be coded, most plausibly as `paid_any`.
3. **Was employment status observed at a single visit?** `ascertainment` is recorded as
   `point_prevalence` because the follow-up reassessed all baseline measures at one visit, but the
   report never says whether working status refers to the day of assessment or to a preceding
   period. If it is a period measure the estimand changes.
4. **SUPPLEMENT NOT HELD, and it would answer questions 1 to 3 plus the population gate.**
   Supplement 1 contains eAppendix 1 (exclusion criteria), eTable 1 (baseline sociodemographic and
   clinical characteristics) and eTable 2 (the within-participant baseline-to-follow-up
   comparisons, the source of 170 and 208). Nothing for `mucci2021` is recorded in
   `data/supplement_provenance.csv`. **This is the single highest-value retrieval in the batch:**
   eAppendix 1 would settle whether `employment_selection_status` is `none` rather than `unclear`,
   and eTable 2 would settle the denominator. The article is behind the JAMA Network paywall and
   the supplement link is `https://jamanetwork.com/journals/jamapsychiatry/fullarticle/2776156`
   (supplementary content tab). A human with institutional access should retrieve it.
5. **When was the baseline cohort recruited?** The article gives March 2016 to December 2017, which
   is the recruitment window of the follow-up study, not of the original cohort. The baseline years
   are in Galderisi et al. 2014 (World Psychiatry 13:275-287), which is not held.
   `recruitment_start` and `recruitment_end` are blank.

## nakamura2025 (kariya_daycare)

1. **How is Type B continuous employment support remunerated for these five participants?** This is
   the question the primary construct turns on. The report says Type B work is "not legally
   classified as employment under national labor law" and calls it "structured prevocational
   engagement", which is why the 5 are coded `vocational_activity` and excluded from paid work under
   SAP 3.1. Japanese Type B typically pays a productivity allowance rather than a wage, but the
   report does not say so, and if any of the five held a wage relationship the `paid_any` numerator
   would change from 4 to more.
2. **How was employment status at one year ascertained?** Self-report, staff record, day-care
   record or register is never stated, and no procedure for tracing participants is described.
3. **Was anyone employed at study entry?** The report says participants "transitioned from
   psychiatric daycare", which implies none was, and Table 1 records only lifetime prior employment
   (17 of 21 with at least 3 months). A baseline employment count would let
   `n_employed_baseline` be filled; it is currently blank.
4. **What is the exact denominator behind the contextual comparison?** "we also examined outcomes
   among ~180 individuals in the same psychiatric daycare who did not receive CRT ... only one
   obtained formal employment (0.6%) and two engaged in vocational activity (1.1%)". The
   denominator is printed as an approximation, so no result was created from it; an exact number
   would give the review a genuine non-CRT comparison group from the same service.
5. **What were the recruitment years?** Never stated. The UMIN registration is UMIN000054690 and the
   JSPS grants ran 2016-2018. `recruitment_start` and `recruitment_end` are blank.

## pedersen2025 (opus_2014)

1. **How many of the 246 were employed at 2 and at 4 years, combined across sites?** The report
   prints only arm-level counts (10 and 22 of 116; 10 and 15 of 130). A combined count is not
   derivable here: the derivation rules require components sharing one `arm_id` and one denominator,
   and the two groups are separately site-defined and non-randomised. The manifest's "37/246 at 4y"
   is therefore refuted as an extractable result. Even if the authors supplied it, the cohort is
   employment-selected and could not enter the primary pool.
2. **How many Morpheus patients were employed at Morpheus entry rather than at OPUS inclusion?**
   Table 1 records 18 of 116 employed and 19 on an education grant at OPUS inclusion, under a
   criterion that excludes both. Morpheus began at a median of 183.5 days later. A count at the true
   point of selection would show how much of the group actually met the criterion (see
   `inconsistencies.md` P1).
3. **What did the Aalborg comparison group actually receive?** The authors state they "lacked
   information on the standard vocational rehabilitation received by patients, which may have
   included IPS". This is the main reason the ROBINS-I classification domain is `moderate` rather
   than `low`.
4. **Was the analysis prespecified?** No protocol or registration is cited. Both a point-in-time and
   an any-time version of the employment outcome are reported at both windows with no stated
   primary, which is why the selective-reporting domain is `moderate`.

## peebo2022 (tallinn_fep, tallinn_fep_tau)

1. **What are the numerators behind every employment percentage?** (Would make the report
   quantifiable; it is currently `report_quantifiable = no`.) No employment numerator appears
   anywhere in the report at any follow-up. Counts for Table 2a at 12 and 24 months on n = 107, and
   for Table 2b at 12 months on n = 154, are the whole request.
2. **What does "Employment" mean in Tables 2a and 2b?** (Blocks the construct coding; all three
   results are `outcome_construct = unclear`.) The report says only that socio-demographic factors
   including employment status were collected by psychiatrists during interviews. Table 1's baseline
   classification counts students separately from the employed, which suggests paid employment, but
   that is an inference. A definition would most plausibly move these rows to `paid_any`.
3. **Which base produced Table 2b's 12-month employment figure of 47.7%?** (Blocks
   `peebo2022_cohort_t12m_employment_all154`.) No integer numerator over 154 gives 47.7%; the same
   value appears in Table 2a on 107, where 51/107 does. The same table's 6-month unemployment of
   9.9% on 166 is likewise unattainable.
4. **Is a point prevalence of employment available at the 10-year follow-up?** The 10-year outcome
   is reported only as total duration of employment in months (mean 76.3 intervention, 47.1
   control). A mean number of months is not a prevalence and was not converted into one, so the
   10-year timepoint contributes nothing. The Estonian Tax and Customs Board data behind it would
   support a point or period prevalence at a stated date, and that would give this review a
   ten-year-horizon result from a region it has almost no evidence from.
5. **Can the treatment-as-usual group's employment be reported as counts?** `tallinn_fep_tau` is
   recorded as a cohort but contributes no result for the same reason as question 4.
6. **SUPPLEMENT STATUS**: `data/supplement_provenance.csv` records `peebo2022` as `not_found`, with
   existence unverified rather than excluded, because Taylor and Francis returns a Cloudflare 403 to
   non-browser clients. The held full text never references a supplement, so a supplement is
   unlikely to be the route to questions 1 to 3.

## petrakis2019 (stvincents_ips)

1. **How many of the 63 with an "employment outcome" were in paid work?** (Would create a
   `paid_any` row where there is currently none.) Table 4 shows the 92 underlying placements include
   3 Volunteer Work and 1 Unpaid Work Experience Position, so the 63 is coded `vocational_activity`.
   Table 4 counts placements and Table 3 counts people, so the person-level paid share is not
   recoverable. A count of participants whose placements included at least one paid role is the
   request.
2. **How many of the 8 with a non-competitive placement were paid?** Social firm, transitional
   employment and sheltered employment placements are typically paid; volunteer and unpaid work
   experience are not. Splitting the 8 would let a `paid_sheltered_noncompetitive` row be created.
3. **What was each participant's engagement period?** (Blocks any horizon assignment.) Outcomes are
   attainment "during their engagement in the IPS program", which ran March 2006 to February 2013
   and ended for everyone at once when the Commonwealth DES funding changed. Individual engagement
   periods are never reported, so elapsed follow-up varies from days to 84 months with a shared
   calendar end. `followup_basis = calendar_end_common` under D12.8 and `followup_months` is left
   blank rather than filled with the programme span. Mean or median engagement time, or better a
   count employed at 12 months from entry, would let this cohort enter a horizon.
4. **How many participants were employed at programme entry?** Not reported;
   `n_employed_baseline` is blank. The eligibility criteria imply few or none, but DES eligibility
   is not stated as requiring unemployment, which is why `baseline_unemployed_required` is `unclear`
   rather than `yes`.
5. **Is "15 of 126" or "15 of 136" correct for completed tertiary study?** Table 2's percentage
   supports 136 and 126 appears nowhere else. `n_post_secondary_denominator = 136` is recorded.
6. **Are employment outcomes available by diagnosis?** Chi-square tests of diagnosis against
   employment outcome are reported without cell counts, so `subgroup_extractable = no`. A psychosis
   subgroup breakdown would let this cohort contribute a diagnostically pure result. It is not
   needed for the D13 gate, which the whole cohort passes at 72.8%.

## ringbom2023 (fi_birth_1987)

1. **Is the schizophrenia and schizoaffective group 86 or 137?** (Blocks all five `sz_sza` results.)
   Table 1, the Results text and the diagnosis breakdown all give 86; Clinical Characteristics gives
   137 (47.6%). Supplementary Table 1, which is cited for the analyses that use 137, is not held and
   would probably settle it.
2. **Is a point prevalence of employment available at any single date?** Every outcome in this
   report is a count of calendar years within 2008-2015, so nothing is point prevalence and nothing
   can enter the primary pool. Employment status at a stated date, for example 31 December 2015 or
   at age 25, would give this review a large, register-complete, unselected national cohort at a
   landmark horizon, which is the most valuable thing any report in this batch could supply.
3. **Can time since first diagnosis be used instead of age?** The observation window is fixed by
   calendar and, because this is a 1987 birth cohort, by age. Time from the first F20-F29 diagnosis
   (2004-2007) to the end of observation varies from 8 to 11 years and is never reported, so
   `followup_basis = chronological_age` and no horizon can be assigned.
4. **What is the exact cohort flow?** The stated exclusions sum to 4 320, which would leave 55 156,
   not the 55 171 reported. Overlapping exclusion categories would explain the direction of the
   difference. No extracted denominator depends on this.
5. **Which base underlies Table 2's non-psychosis NEET column?** Table 2 uses 1 290 while Table 1
   gives 1 187 long-term NEET in the same group. The psychosis column is consistent at 103, so no
   extracted result is affected.

---

## Schema questions for the authorship group, not for authors

These are extractor-level questions raised by this batch. They are recorded here because there is
nowhere else in the shard for them; none of them changed a value in this shard.

1. **`extraction_v3.md` rule 2 and codebook D12.4 conflict about `perc_*` fields.** Rule 2 says
   never type "any `perc_*` field", while the codebook's moderator section and D12.4 say a typed
   percentage is permitted where the source prints nothing else, and this batch's own instructions
   direct that `perc_qualifying_diagnosis` be recorded from what the paper prints. Resolved here in
   favour of the more specific and equally recent rule: no `perc_*` moderator field is typed
   anywhere in this shard (counts and their own denominators are recorded instead), and
   `perc_qualifying_diagnosis` is recorded for `stvincents_ips` only, by summing printed integer
   counts rather than by back-calculating from a percentage. Flagged so the wording can be aligned.
2. **`checked_by` on derived rows has no available value during Stage F.** Four derived rows in this
   shard (ringbom2023 `paid_any` and `education_only`, for both arms) carry
   `checked_by = pending_stage_g_human_check`, because the independent check the codebook requires
   is a human's and belongs to Stage G, exactly as `checker` does in `extraction_rob.csv`. A
   sanctioned placeholder, or an explicit statement that `checked_by` is filled at merge time, would
   remove the ambiguity.
3. **`education_only` and `training_only` are glossed as "without paid employment, where
   separable".** Read strictly, that means education among the non-employed, which almost no source
   reports; read as an activity-type label it means education recorded separately from paid work,
   which is what sources do report. This shard uses the second reading for `ringbom2023` and says so
   in each row's `notes`, and avoids the value entirely for `petrakis2019` (coded
   `education_or_training`). A one-line clarification in the vocabulary would stop the two readings
   diverging across batches.
