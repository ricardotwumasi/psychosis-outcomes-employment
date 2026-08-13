# Batch F04: what an author would have to answer

One section per report, then a final section of decisions that belong to the review team
rather than to any author.

---

## killackey2019 (EPPIC IPS trial, eppic_ips_rct)

1. **The 12-month and 18-month employment counts, by arm.** This is the one that matters. The
   trial measured employment over 0-6, 6-12 and 12-18 months and reports counts for the first
   interval only (47/66 and 29/60, p. 78). For 6-12 and 12-18 months it prints odds-ratio
   p-values (0.288 and 0.594) and Fig. 1 predicted probabilities, from which no numerator or
   denominator can be recovered. Both later intervals fall in landmark bands (12-month and
   24-month) and neither can be used. Requested: numerator and denominator per arm at 6-12 and
   12-18 months.
2. **Was the employment definition restricted to the open labour market?** The definition is
   "a job that paid the legislated minimum wage for a minimum of 1 day in the previous 6-month
   period" (p. 77). It fixes remuneration but never states the labour-market setting, and the
   word "competitive" never appears. Coded `paid_competitive` on the strength of the wage floor
   and the description of IPS as returning people to "mainstream employment"; `unclear` would
   be the alternative. Requested: whether supported-wage, sheltered or Australian Disability
   Enterprise placements could count.
3. **Which arm did the two participants who "withdrew participation as a result of having
   employment" belong to?** (p. 78.) This is outcome-dependent missingness and drives the
   high risk-of-bias judgement on RoB 2 domain 3; its direction cannot be signed without the
   allocation.
4. **Calendar years of recruitment.** Only "Recruitment occurred over a 3-year period" (p. 76)
   is given, so `recruitment_start` and `recruitment_end` are blank for this cohort.
5. **Supplementary Figs 1 to 3** (CONSORT flow, hours worked, studying) are cited but not in
   the PDF held.

## clarke2023 (same trial)

6. **How was "currently in paid work" defined?** The report says only that "employment status
   was treated as a binary variable (i.e. employed and unemployed)" (pp. 771-772) and labels
   the row "Currently in paid work" (Table 1, p. 773). No hours threshold, wage floor,
   reference period or verification is stated. Coded `paid_any` on the source's own wording;
   if the variable was in fact the parent trial's minimum-wage measure, the construct would be
   `paid_competitive` instead. Requested: the item wording and whether it was point-in-time.
7. **Appendix 3**, the comparison of the 100 completers with the 45 non-completers, is cited
   ("no major differences") but is not in the PDF, so the claim cannot be checked. Appendices
   1, 2 and 4 to 13 are likewise absent.
8. **Which base does Table 1's baseline column use?** It is headed N = 145 but three of its
   percentages reproduce only on 146 (see inconsistencies.md item 1).

## harrow2017 (Chicago Follow-up Study, chicago_followup)

9. **How many were in PAID work, separately from carers and students?** The scored variable
   counts paid work at half-time or more, unpaid care of children or dependents, and half-time
   or more school attendance, all as "working" (Method 2.3, p. 269). No paid-employment count
   is therefore recoverable at any wave: for the two extracted 20-year groups paid_any is
   bounded only by 0 to 36 and 0 to 22. Requested: the paid-employment-only numerators.
10. **The per-wave counts.** Supplemental Tables 2 to 4, which hold work functioning, negative
    symptoms and psychosis at each of the six follow-ups, are cited (p. 269) but are not in the
    PDF held. Only the 20-year counts appear in the running text. Supplemental Table 1 (other
    sample characteristics) is likewise absent, which is why no moderator is recorded on either
    result row.
11. **A whole-cohort figure.** No count is given for the 139, or for the 70 with schizophrenia
    as a whole, or for the 69 mood-disordered patients, whose work is reported only as "over
    60% ... at each of the 6 followup assessments" (p. 271) with no denominators.
12. **Recruitment window.** Neither report gives one; jones2024 says only that the programme
    was "initiated in 1970".

## jones2024 (same cohort)

13. **Any employment count at any wave.** The report gives mean Strauss-Carpenter scores (0-4)
    and Harrow Functioning Interview scores (1-5) by latent class, and GEE coefficients. Its
    GEE outcome is an explicit binary ("1 = no work or less than half of the time; 2 = work at
    least half of the time", p. 2450), so counts exist behind the model but none is printed.
    Requested: the number working at least half the time by wave, ideally for the whole n = 256
    rather than by latent class.
14. **The latent classes are not a vocational outcome.** Class sizes (105, 73, 78) are
    memberships and are not recorded as prevalences anywhere in this shard. Table 2's n column
    (410, 300, 323) counts observations across six waves, not people, as its own footnote says.
15. **Missing data are unquantified** throughout Table 1 (see inconsistencies.md item 9).

## khare2022 (Pune public hospital, pune_public)

16. **Confirmation of denominators quoted from the companion report.** The Introduction (p. 2)
    attributes "40% at baseline, 49.5% at follow-up" to "the 150 participants", but the 49.5%
    is on the 107 who completed follow-up (see inconsistencies.md item 11).
17. **Employment counts for the schizophrenia-schizoaffective subgroup.** The report re-ran its
    analyses restricted to that subgroup (Results, p. 5) but reported only cognition-work
    associations. This is the missing piece that would settle `subgroup_extractable` for the
    cohort, and with it the diagnosis gate (see the team note below).

## khare2022b (formerly staged as unknown2022; same cohort)

18. **Age, sex and clinical characteristics of the 107 who completed follow-up.** Supplemental
    Table 1, which compares completers with non-completers, is cited (p. 239) but is not in the
    PDF held, so `mean_age` is left blank on the extracted result.
19. **Employment counts by diagnosis.** As item 17. 90% of the sample is
    schizophrenia-schizoaffective, but no employment count is reported for that subgroup.
20. **Does "employed" require remuneration in every case?** The construct is coded `paid_any`
    on the strength of "the focus of the study was on paid employment" (p. 245) and the
    collection of monthly income for every employed participant. 6% to 8% of employed
    participants worked in family-run businesses (pp. 238, 240); whether all of those drew a
    wage is not stated.
21. **A confidence interval or exact count for the follow-up rate.** The paper prints only
    49.5%; the count 53 is derived here from two printed cells and is checked against that
    percentage.

---

## Notes for the review team (not author queries)

**A. The diagnosis gate removes the only landmark-horizon result in this batch, on a field that
is a judgement call.** `khare2022b_cohort_t12m_paidany` (53/107 paid_any, point prevalence, 12
months, whole recruited cohort) passes every other gate: report eligible, no unresolved
conflict, `employment_selection_status = none`, `analysis_selection_status = none`,
`arm_type = cohort`, all trial safeguards `not_applicable`, point prevalence, `paid_any`,
horizon t12m, numerator and denominator both recoverable. It is removed by the clause
"eligible diagnosis group", because the cohort is `smi_mixed` (eligibility admitted bipolar
disorder and major depression without requiring psychosis) and `subgroup_extractable = no`
(no employment count is reported for the 90% with a schizophrenia-spectrum diagnosis).

SAP section 7 reads as a disjunction: "At least 50 per cent of the sample has a qualifying
psychosis diagnosis, **or** a qualifying subgroup can be extracted separately."
`config/analysis.yml` and `build_primary_pool()` implement a conjunction: `smi_mixed` is
admitted only when `perc_qualifying_diagnosis >= 50` **and** `subgroup_extractable == "yes"`.
The two readings differ for exactly this cohort, at 90% qualifying. This shard records the
fields truthfully and does not code around the gate. The team should decide whether the
implemented conjunction is intended; if it is, this is a 90%-schizophrenia cohort with a clean
12-month `paid_any` count being excluded, and that should be visible in the flow diagram rather
than in a log file.

**B. Two construct codings are judgement calls, both with the verbatim recorded.**
`killackey2019` is coded `paid_competitive` on a minimum-wage definition that never names the
labour market (query 2), and `clarke2023` is coded `paid_any` on an undefined "currently in
paid work" item in the same trial (query 6). Neither cohort can reach the primary pool in any
case, because eppic_ips_rct is employment-selected, so the coding affects only which secondary
outcome family the rows join.

**C. `checked_by` on the derived row records that the independent check is outstanding.** The
sum 45 + 8 = 53 was recomputed and reproduces the report's own printed 49.5% and 43.9%, but
that is the extractor checking itself. Stage G human verification is still required, and the
field says so rather than naming a checker who has not looked.

**D. The two `component_only` rows carry no risk-of-bias rows, deliberately.** They are
fragments of the derived count, can never enter any pool, and the appraisal that matters is on
the derived row. Every result that can enter a synthesis has a complete instrument.

**E. Risk-of-bias instrument choice for harrow2017.** The two 20-year counts exist in the
source only as the two sides of a non-randomised medication comparison (reported with its own
chi-square of 12.683), so ROBINS-I is applied rather than the JBI prevalence checklist: neither
count is a whole-cohort prevalence, and neither group was allocated. The alternative reading,
two subgroup prevalences appraised with JBI, was considered and rejected; recorded here so the
choice is visible rather than silent.

**F. killackey2019 was `pending` in the manifest and is now adjudicated.** The full text was
read; it is `include` with `report_quantifiable = yes`, and the cohort hint is confirmed. See
manifest_changes.csv.
