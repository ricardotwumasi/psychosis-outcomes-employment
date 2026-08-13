# Batch F02 unresolved queries

Cohort `jump_norway`. What an author would have to answer, per report. Every
item below is a field left blank or a judgement left qualified, not a value
guessed at.

Corresponding author for the JUMP reports: Stig Evensen, Division of Mental
Health and Addiction, Oslo University Hospital (evensen2017 and evensen2019).
Oda Skancke Gjerdalen for the 5-year report.
[contact details in private/contact_log.csv]. ClinicalTrials.gov NCT01139502.

---

## Q1. gjerdalen2023 and evensen2017: how many participants were competitively employed at the 10-month post-intervention assessment?

**Why it matters most.** 10 months after baseline is the cohort's **only**
timepoint inside the 9 to 18 month primary landmark band (SAP section 4; nearest
landmark is 12 months, D11.1). The figure exists but only as a percentage:
Figure 1 of `gjerdalen2023` (p. 26) labels the post-intervention competitive
employment band "8.1 %", work placement "35.8 %" and sheltered work "32.5 %", and
`evensen2017` repeats the same three percentages in prose (Background, p. 181),
attributing them to reference 29 (Bull et al. 2016, *J Nerv Ment Dis*
204:599-605), which is not in this review's report set.

No count is printed in any of the five reports. Back-calculation is prohibited
(prompt rule 1, codebook rule 2), so `n_employed` is blank on
`gjerdalen2023_cohort_t10m_paidcomp` and **this cohort contributes nothing
quantitative at the primary horizon**.

**Ask:** the numerator and denominator for competitive employment, work
placement and sheltered work at the 10-month post-intervention assessment.

---

## Q2. evensen2017: were the seven unreached participants classified as unemployed *at the two-year follow-up* or *at the end of the intervention period*?

The sentence reads: "Seven participants could not be reached at the two-year
follow-up. The loss to follow-up of these subjects was managed conservatively by
classifying them as unemployed **at the end of the intervention period**"
(Results, p. 183). The paragraph is about the two-year follow-up, and the
arithmetic only works if the imputation applies there: the categories sum to 146,
Figure 1 records 139 with 2-year employment status, and `evensen2019`'s Table 1
puts the observed unemployed at 51 rather than 58.

**Ask:** confirm that the 7 were assigned to the unemployed category at the
2-year follow-up, and confirm 139 as the number with observed 2-year employment
status.

---

## Q3. All reports: is any category other than competitive employment remunerated as wages?

The three sources that define the categories all describe work placement and
sheltered work as financed by welfare schemes rather than by an employer:
`lystad2017` 2.1, p. 123; `evensen2017` Background, p. 181 ("work placements with
no additional salary beyond their disability benefits"); `gjerdalen2023`
Discussion, p. 28 ("sheltered work or other subsidized or unpaid work
placement"). Under SAP 3.1 that removes both from `paid_any`, which excludes
"receipt of welfare benefits, and any activity for which remuneration or an
employment relationship cannot be established".

Consequence: **`paid_any` is not identified for this cohort at any horizon.** At
2 years the bound on the 139 observed is 31 ≤ paid_any ≤ 88; at 5 years no bound
above the competitive 33 can be stated because the other categories have no
counts. No `paid_any` row is emitted, following the `rautio2016` precedent under
D12.3.

**Ask:** how many of those in sheltered work received a wage from the sheltered
enterprise, as distinct from a work assessment allowance or disability pension?

---

## Q4. All reports: what was the baseline employment count, and on what definition?

Three mutually inconsistent statements (see `inconsistencies.md` I5): 17 per cent
"had some form of employment" (`evensen2017` p. 181, citing an external source);
2.7 + 6.1 + 4.1 = 12.9 per cent across the three categories (`gjerdalen2023`
Figure 1 baseline column); and "none had competitive employment with wages as
their primary source of income at baseline" (`evensen2017` p. 183). No count is
printed for any of them.

`perc_employed_baseline`, `n_employed_baseline` and
`n_employed_baseline_denominator` are blank on every row, so this cohort cannot
contribute to the baseline-employment moderator.

**Ask:** the baseline count in each of the four employment categories, on 148.

---

## Q5. gjerdalen2023: how many participants had 5-year employment status observed, and were the two deceased participants in the denominator?

The 5-year base of 148 is recovered from 33/148 = 22.3 per cent and confirmed by
the arm reweighting, but no denominator is ever printed and no attrition is
reported. `evensen2017` records two deaths before the 2-year follow-up.

`n_outcome_observed` = 148 is recorded with `denominator_basis = entered` and
`n_alive_eligible` is left blank rather than set to 146, because 148 observed of
146 alive is impossible.

**Ask:** the number alive and register-traceable at 5 years, and confirmation of
whether the two deceased participants are inside the 148.

---

## Q6. gjerdalen2023: which calendar year is "the last calendar year", and how does it map onto each participant's fifth year?

"Employment at five-year follow-up was defined as having worked at least one
month during the last calendar year, which is in line with the way employment is
defined by NAV" (2.4.3, p. 25). Inclusion ran from August 2009 to March 2012, so
a single calendar year sits between 4 years 2 months and 5 years 9 months after
entry depending on when a participant joined.

This is recorded as `period_prevalence` with
`ascertainment_window_months = 12` and `followup_months = 60`, and drives the
`unclear` judgement on JBI item 7 for that result.

**Ask:** the calendar year used, and whether the window was anchored to each
participant's own inclusion date.

---

## Q7. gjerdalen2023 and lystad2017: arm-level counts

Both report occupational outcome split by allocation group as percentages only.
`gjerdalen2023` (Results 3.2, p. 26 and Figure 2, p. 27): competitive 19 per cent
CR versus 25 per cent CBT, work placement 18.8 versus 17.9, sheltered 21.9 versus
9.5, at 5 years. `lystad2017` (3.3, p. 124 and Figure 3, p. 127): competitive
10 per cent CBT and 5 per cent CR at post treatment, 22 and 16 per cent at
follow-up, with a chi-square on n = 130, 128 and 122 at the three timepoints.

Figure 3 of `lystad2017` is a 3-D bar chart with a percentage axis and no data
labels. No arm-level count is extractable from either report without
back-calculation, so no `intervention`, `control_active` or per-arm rows are
emitted and no RoB 2 assessment is made: this batch produces no randomised effect
estimate.

**Ask:** arm-level numerators and denominators at post-intervention, 2 years and
5 years.

---

## Q8. lystad2017: the numbers behind Figure 3

Occupational status (working sheltered, in work placement or competitively versus
not working) at baseline, post treatment and follow-up appears only in Figure 3.
`report_quantifiable = no` for this report.

**Ask:** the underlying counts for Figure 3, by group and timepoint.

---

## Q9. klungsyr2021: no employment count exists

The only occupational outcome is mean working hours per week at baseline,
30 weeks and 100 weeks (Table 1, Figure 1, Table 2). `report_quantifiable = no`;
the report contributes design provenance only. Two further points worth an
author's clarification, neither extracted:

- Table 1 records "History of unemployment: Yes 20 (15.3%)" of 131. The variable
  is never defined, and 15.3 per cent is hard to reconcile with a sample in which
  all participants were reliant on social security benefits and none was
  competitively employed with wages as their primary income at baseline.
- The paper refers to "a comparison between the total JUMP sample and a
  constructed control group (TAU - treatment as usual) [13]" (p. 6). If that
  comparison carries employment counts it would be a further report of this
  cohort and is not in the review's frozen 90-report set.

---

## Q10. Schema and vocabulary gaps surfaced by this batch

These are queries for the review team, not for the authors.

1. **`missing_data_method` has no value for worst-case imputation.** The
   permitted values are `complete_case`, `last_observation_carried_forward`,
   `multiple_imputation`, `register_complete`, `not_stated`,
   `not_applicable`. `evensen2017` classified 7 unreached participants as
   unemployed, which is none of these. The three `evensen2017` rows are recorded
   as `complete_case` because the extracted denominator (139) is the
   available-case set, with the report's own method stated in `notes`. A value
   such as `imputed_as_not_employed` would remove the need for that workaround.

2. **`employment_selection_reason` is single-valued.** For this cohort both
   `vocational_service_entry` and `work_intention_or_readiness` are supported by
   the sources. `vocational_service_entry` is recorded because it is a documented
   condition of cohort membership, while the work-motivation statement appears in
   a discussion sentence; both quotations are preserved in
   `employment_selection_verbatim`.

3. **A cluster-randomised trial whose only reported figures are the merged
   cohort.** The codebook says that where a trial-derived whole cohort fails a
   safeguard the allocated arms should be kept separate and routed to the
   intervention synthesis. Here the intervention is employment-targeted, so the
   safeguard fails, but no arm-level counts exist to separate. `arm_type = cohort`
   is used with `employment_targeted_intervention = yes` recorded truthfully, so
   the pool filter in `config/analysis.yml` excludes it; the cohort-level
   `employment_selection_status = selected` excludes it independently. Confirm
   this is the intended handling.
