# Batch F10 — what an author would have to answer

One section per report. Each question names the result it blocks or the field it would fill, so a
data request can be prioritised by what it would actually recover. A question is listed only where a
reply would change a recorded value; where the answer is already in the paper it is not asked.

Cross-reference: `inconsistencies.md` gives the arithmetic behind every conflict named here, and the
affected rows carry the same text in `conflict_note`.

---

## maguire2021 (EPPIC Melbourne 2011-2016)

1. **Is the migrant work-or-study count 137 or something else?** Table 3 (p. 1394) prints 137 and
   46.8 per cent; the Results text (p. 1395) prints 47.3 per cent. 137/293 = 46.76 per cent.
   *Candidate resolution, not applied:* the text figure is a typographical error and 137/293 stands,
   which would make the whole-cohort count 594/1196. **Blocks** `maguire2021_migrants_discharge_paidoreduc`
   and `maguire2021_cohort_discharge_paidoreduc`.
2. **Can paid employment be separated from study at discharge?** The composite is "being an engaged
   student or having regular employment", and no paid-only numerator appears anywhere. A separate
   count of those in paid work at discharge would create the only `paid_any` result this cohort can
   contribute. Without it the report contributes nothing to the primary construct.
3. **What does "regular employment" mean?** No hours, contract type or pay threshold is given, so
   the paid half of the composite is not operationally defined.
4. **For how many of the 1196 was occupation at discharge actually recorded?** The methods say it
   "was obtained from the discharge summary or progress notes for each young person", and the
   employment row of Table 3 carries no reduced n, but the four HoNOS rows of the same table print
   reduced denominators of 830, 839, 831 and 746. A stated count would convert
   `n_outcome_observed = 1196` from an inference about complete ascertainment into a recorded value.
5. **What is the median elapsed time from registration to discharge for the whole cohort?** Only the
   two subgroup medians are printed (581 and 667 days), so `followup_months` is left blank. A
   whole-cohort figure would still not make the result assignable to a landmark, because the IQRs
   (333-730 and 478-741 days) span both the 9-18 and the 18-30 month windows, but it would let the
   cohort be described properly.
6. **What is the denominator of the baseline employment block in Table 1?** Its counts sum to 1183,
   not 1196, and the "Student not attending school" cell is printed garbled as "3.1 (37.4)".

## majuri2023 (Northern Finland Birth Cohort 1966)

1. **Is a cross-sectional employment count available at any single age?** The report gives only
   latent-class trajectory membership over ages 16 to 45. A count employed at one age, with its
   denominator, for the SZ and OP groups, would be the first NFBC1966 result that is neither
   age-anchored (rautio2016, D12.3b) nor restricted to disability-pension recipients (majuri2021).
2. **Does the Statistics Finland "others, mostly unemployed" category at age 46 contain anyone in
   paid work, and if so how many?** This is the single question that decides whether Table 1's
   occupational categories can be summed into a `paid_any` count. As printed, "mostly" means zero
   work is not separable from every category containing positive paid work, which D12.3 bars, so no
   count was derived. Note that even a clean answer would leave the result barred from every landmark
   horizon, because the measurement is at chronological age 46 (D12.3b).
3. **Why does the schizophrenia-men column of Table 1 (p. 70) sum to 28 when its header says 29?**
4. **Are the life history calendar annual employment roles available as counts per year?** The
   underlying data are annual role occupancy from 1982 to 2011; a count of those in full-time or
   part-time employment in a named year, with its denominator, would be directly usable, whereas the
   trajectory classes are not.

## martini2017 (Sao Paulo prevocational cohort)

1. **What is the denominator of the 35.8 per cent — 45, 53 or 44?** The Results sentence says "of
   those [45] ... 19 (35.8%)", but 19/45 = 42.2 per cent and 35.8 per cent requires 53, while the
   job-duration percentages on the same page require 44.
   *Candidate resolution, not applied:* the analysed denominator is 45 (19 + 26, both printed as
   group sizes and both used as the bases of Tables 1 and 2), the 35.8 per cent was computed on the
   enrolled 53, and 44 is a further error. **Blocks** `martini2017_cohort_t18m_paidthreshold30d`.
2. **How many of the 45 were in paid work at the 18-month assessment itself?** The only
   point-prevalence figure is 7 of the 19 who had worked, which is conditional on having worked.
   A count on the full analysed sample would give the cohort its first usable point prevalence. It
   was deliberately not derived as 7/45, because "did not obtain paid work for at least 30 days" does
   not establish that nobody in the unemployed group was working at month 18.
3. **How many worked at all, without the 30-day threshold?** The construct as reported is
   `paid_intensity_threshold`, not `paid_any`, because everyone who worked for fewer than 30 days is
   counted as unemployed.
4. **What happened to the 8 participants who enrolled but were not followed?** Reasons are given for
   4 of the 12 who missed the final clinical evaluation ("three were employed and could not miss
   work, and one was incarcerated"), which is outcome-related, but not for the 8.

## mcgurk2016 (Brooklyn TSW trial)

1. **Is the E-VR denominator 26 or 25?** Table 3 prints "12/26" beside "48%", and 12/26 = 46.15 per
   cent while 12/25 = 48.00 per cent exactly; Table 1's E-VR work-history rows sum to 25.
   *Candidate resolution, not applied:* either the denominator is 25 or the percentages are wrong.
   **Blocks** `mcgurk2016_evr_t36m_paidcomp` and `mcgurk2016_evr_t36m_paidany`.
2. **How are the Discussion's 54 per cent competitive and 67 per cent any work activity derived?**
   The table counts give 28/54 = 51.9 and 34/54 = 63.0 per cent, and no whole number of participants
   on a denominator of 54 produces either printed figure. **Blocks** both competitive rows and both
   work-activity rows.
3. **How many participants were in paid work at a fixed timepoint, for example at 12, 18 or 36
   months?** All three reported outcomes are cumulative over the whole three years
   (`any_time_during_followup`), so none can enter a point-prevalence synthesis. Weekly work tracking
   was collected, so a point-prevalence count should be recoverable from the existing data.
4. **Did tracking loss differ by arm?** Employment information fell from 54 participants (100 per
   cent) in months 1-12 to 42 (75 per cent) in months 31-36, and the arm split is not given, yet
   Table 3 uses the full randomised denominators for a three-year cumulative outcome.
5. **Was the trial registered, and is a protocol available?** None is cited, so the reported outcome
   set cannot be checked against a prespecified one.

## mervis2017 (IVIP randomised trial)

1. **Does "in supported employment" mean holding a paid job, or being enrolled in a supported
   employment service?** This is the question that decides the construct. The report uses "enrolled
   in supported employment" and "supported employment enrollment status" in the methods and analysis
   plan, and "went on to secure supported employment" in the results, for the same 14 and 6. Under
   SAP 3.1 an activity whose remuneration cannot be established is not paid work, so
   `outcome_construct` is recorded as `unclear`. If the answer is a paid mainstream job the construct
   becomes `paid_competitive`; if it is service enrolment it becomes `vocational_activity`; neither
   is `paid_any` without a further answer about non-competitive paid work.
2. **Were the participants in supported employment being paid, and at what rate?** The only wage in
   the paper, "$10 per hour worked", is for the four-month work therapy placement that **both** arms
   received as a condition of entry, and that placement is itself described as "not in conventionally
   competitive employment".
3. **Was the outcome status at the 12-month assessment, or ever during follow-up?** "At follow-up,
   the number of participants in supported employment was tallied" and the within-group McNemar tests
   both point to a status, and `ascertainment` is recorded as `point_prevalence` on that basis; "by
   time of follow-up" points to a cumulative reading.
4. **Where were participants recruited?** The report says "community mental health clinics affiliated
   with the New York State Psychiatric Institute", with NYSPI ethics approval, while the author
   affiliations and the cohort slug point to The Institute of Living at Hartford Hospital,
   Connecticut. This decides the cohort's country region and setting description and, more
   importantly, whether this sample could overlap any other Institute of Living or Hartford report in
   the review. See `manifest_changes.csv`.
5. **What are the correct ANCOVA degrees of freedom?** F(1, 84) is impossible for 64 randomised
   participants, so the analysed sample cannot be verified from the reported statistics.
6. **How was randomisation sequence generated and concealed, and why are the arms 29 and 35?**

## moncrieff2025 (RADAR trial secondary analysis)

1. **How many of the 82 relapsers and 171 non-relapsers had a 24-month employment, education and
   training status: 66 and 124, or 58 and 132, or 57 and 132?** Table 2, the Results text and Table 4
   give three different splits of the same 190. The text percentages reproduce the MANSA and PANSS
   denominators of the same table exactly, so they are not loose rounding.
   *Candidate resolution, not applied:* the whole-cohort figure 38/190 is invariant to the split,
   since 66 + 124 = 58 + 132 = 190 and 8 + 30 = 38 either way. That does not establish that the
   numerators 8 and 30 are correctly allocated. **Blocks** all three EET rows.
2. **How many participants were in PAID EMPLOYMENT, separately from education and training, at 24
   months and at baseline?** This is the highest-value request in the batch. RADAR is the only cohort
   in F10 that passes the D9 employment-selection gate as a whole recruited cohort at a landmark
   horizon (24 months, `since_baseline`), and the only thing keeping it out of the primary pool,
   apart from the denominator conflict, is that its outcome is an EET composite. A paid-only
   numerator and denominator would create a directly poolable `paid_any` result.
3. **What instrument, question wording or data source was used to record employment, education and
   training status,** and was the same one used at baseline and at 24 months? None is named, which is
   why two JBI condition-measurement domains are `unclear`.
4. **What is the whole-cohort mean age?** Only the two subgroup means are printed (44.25 and 47.30).
   The sample-size-weighted mean is 46.3 years, but that is this extractor's arithmetic, so
   `mean_age` is left blank on the whole-cohort row.
5. **Why does Table 1 print 21/80 as 25.3 per cent** when 21/80 is 26.3 per cent?

---

## Schema questions for the authorship group, not for an author

These are not data requests. They are places where the extraction hit the edge of the vocabulary and
had to choose, and the choice is recorded here so it can be overruled cheaply.

1. **`followup_basis` has no value for "measured at an individually timed service discharge".**
   `maguire2021` measures occupation at discharge from an early intervention service. Elapsed
   follow-up varies across the cohort (median 581 days for migrants against 667 for Australian-born,
   IQRs spanning roughly 11 to 24 months), and the report is perfectly clear about what it measured,
   so `unclear` would misreport it as poor reporting in the risk-of-bias and missing-evidence
   assessments, which `extraction_v3` rule 13 forbids. `since_baseline` would wrongly admit it to a
   landmark horizon. `calendar_end_common` is used, because its operative property — followed from
   entry to one common end point, elapsed follow-up varying, the printed figure a mean or median — is
   exactly what happens here, and because batch F06 already applied it to `baltazar2022`, whose T4
   assessment is "27 to 31 years after first admission" rather than a shared calendar date. The
   D12.8 wording says "one shared calendar end date", which a service discharge is not. Either the
   wording should be widened to "one common end point, whether a shared calendar date or a shared
   terminating event", or a fifth value is needed. **Nothing turns on which**: both candidate values
   are barred from every horizon, so no result's eligibility changes.

2. **The derived-count rules assume a within-arm category sum, and two rows here are partition sums.**
   `maguire2021_cohort_discharge_paidoreduc` sums two subgroups on denominators 293 and 903 into
   594/1196, and `moncrieff2025_cohort_t24m_eet` sums two subgroups on 66 and 124 into 38/190. Both
   are exact partitions of one recruited cohort, both are mutually exclusive and exhaustive, and in
   both the component denominators sum to the derived denominator. The codebook nevertheless requires
   that components share `cohort_id`, `arm_id`, `followup_months`, `ascertainment` and
   `ascertainment_window_months` and sit on **one** shared denominator, which was written for summing
   intensity bands or job types within one arm.

   This is not a hypothetical tension. Naming the components was tried and the project's own
   validator rejected it:

   ```
   VALIDATION FAILED
   extraction_outcomes$derivation_component_result_ids has 1 invalid value:
     row 72: 'components disagree with the derived row on arm_id'
   ```

   Both rows therefore leave `derivation_component_result_ids` **blank** and record the component
   result_ids, the arithmetic and this reason in `derivation_justification`, which is what the
   codebook's conditional wording permits ("**where** it names components ... the validator
   additionally requires"). With the field blank, `Rscript R/01_validate_data.R` passes on the whole
   shard merged into a copy of `data/`.

   **What the authorship group needs to decide.** A partition sum across mutually exclusive and
   exhaustive subgroups of one cohort is a legitimate and common derivation, and it currently cannot
   be expressed in the schema without losing the component link. Either the validator gains a
   partition case — components may differ on `arm_id` and on denominator when their denominators sum
   exactly to the derived denominator and `derivation_mutually_exclusive` and `derivation_exhaustive`
   are both `yes` — or the codebook should say plainly that partition sums record their components in
   prose. Until then the link between these two derived rows and their components is unenforced, so a
   later edit to a component would not be caught. Both rows should be relinked once a rule exists.

3. **`component_only` is being used for post-hoc subgroup rows of a single recruited cohort.**
   Four rows in this shard (`maguire2021` migrants and Australian-born, `moncrieff2025` relapsed and
   not relapsed) are subgroup prevalences that have obvious meaning in their own papers but no pool
   to enter in this review: SAP 2.1 and 5 admit only a whole recruited cohort to the prevalence
   estimand, and neither split is randomised, so neither supports an intervention effect either. They
   are coded `component_only`, following the treatment of `benson2022` in batch F03, which keeps
   risk-of-bias effort attached to the results that can actually be synthesised. D12.2 describes
   `component_only` as being for "fragments with no independent analytical meaning, such as a single
   intensity band", which is a narrower description than this use. If the authorship group prefers
   `reported`, the four rows need risk-of-bias assessments and an instrument decision, because
   neither a whole-cohort prevalence nor a randomised effect describes them.
