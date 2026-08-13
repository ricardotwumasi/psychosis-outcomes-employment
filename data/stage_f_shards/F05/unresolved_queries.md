# Batch F05: what an author, or the authorship group, would have to answer

Batch `F05`. Extractor `claude-opus-5`, 12 August 2026.
Queries are grouped by report. Items marked **[schema]** are for the review team rather than an
author.

---

## strassnig2017 (Suffolk County Mental Health Project, 20-year follow-up)

**Q1. What are the gainful employment counts and denominators in Table 1?**
The table prints 60 (20.6%) of 80 for schizophrenia and 23 (53.4%) of 48 for bipolar disorder.
Neither count reproduces its percentage; the counts give 83/128 (64.8%) against the text's 32.9%;
and the Discussion's "66/80 of the SCZ patients were both unemployed and living dependently" is
compatible with neither. Without the counts, no numerator is recoverable and the row stays blocked.
*Blocking:* `strassnig2017_s2017cohort_t240m_paidcomp`, `conflict_status = unresolved`.

**Q2. Was the analysis sample 122 or 128?** The Abstract says 122 with SCZ and BP; the Results say
128 (80 SCZ, 48 BP). This is also the base of the only employment figure the report gives (32.9%).

**Q3. How many of the recruited first-admission cohort were assessed at 20 years, and how many were
alive and eligible?** Neither strassnig report prints a flow. `n_alive_eligible` and `n_assessed` are
blank on all three Suffolk County rows in consequence.

## strassnig2018 (same cohort)

**Q4. Please confirm the employed counts and percentages in Table 1.** The extraction reads the
counts as correct (36 of 146 schizophrenia, 46 of 87 bipolar) because 24.7% and 52.9%, printed one
row above on Residentially Independent, are exactly 36/146 and 46/87. Confirmation would convert
`conflict_status` from `resolved` (on extractor arithmetic) to `resolved` on the authors' authority.
*See `inconsistencies.md` I2.*

**Q5. How were the chi-square statistics in Table 1 computed?** The printed values (39.6 for
employment, 64.1 for residence) do not reproduce from the printed counts (19.0 and 38.5) or from any
alternative reading. *See `inconsistencies.md` I3.* Unresolved.

**Q6. Was employment status observed for all 146 and all 87?** Other rows of Table 1 carry degrees
of freedom implying missing data (for example SANS df = 226 of 233), but no missing count is given
for employment. `denominator_basis = outcome_observed` is recorded on the authors' apparent use of
the full group n; if employment was in fact missing for some, the denominators are too large.

## wang2020b and wang2020c (Yuli Hospital therapeutic community, Taiwan)

**Q7. How many participants were employed at each annual follow-up, and out of how many?** Both
reports give employment only as mean cumulative work duration (months per year) and mean cumulative
income per year, with standard deviations. Neither prints an employed/not-employed count, an
employment proportion, or a count of participants with zero work months at any timepoint. This is
the sole reason both reports carry `report_quantifiable = no` and contribute no outcome row: the
studies are eligible evidence the review cannot use. A count of participants with more than zero
work months in each follow-up year would make both reports quantifiable.

**Q8. Which of 525, 550 and 561 is the recruited total?** *See `inconsistencies.md` I4.* Also: how
do the two samples relate? Neither report cites the other, both recruited "all residents" of the
same therapeutic community over the same window (January 2013 to December 2015) with the same
diagnostic inclusion, yet the totals differ by 36.

**Q9. Do these samples overlap the Wu et al. 2013 PSP validation sample of 655?** wang2020c states
that "Their initial background data were collected from the sharing dataset with another study,
which aimed to validate the Taiwanese Mandarin version of the Personal and Social Performance Scale"
(Methods, Participants, p. 3). That study is not on the screening list, and the relation of its 655
patients to the 525 analysed here is not stated.

**Note on the off-list sibling.** `wang2020` is recorded in the manifest as sharing `yuli_taiwan`
with these two and is off the screening list (D10.1). It was **not** read and no figure was imported
from it. Neither wang2020b nor wang2020c cites it for its sample; the manifest itself records
wang2020 as byte-identical content to wang2020b under the same DOI, so it is a redundant download of
wang2020b rather than a separate study.

## andersen2024 (headspace Early Psychosis programme, Australia)

**Q10. Does "employment" in the NEET item mean paid employment?** The item is defined as "not being
in full- or part-time education and not being in full- or part-time employment" (Methods, p. 877).
Remuneration is never stated. `paid_any` was coded because "employment" in the NEET framework
denotes a labour-market state, but unpaid work experience, voluntary placement or a therapeutic
allowance counted as "Working" would put a non-paid participant into the primary numerator.
*Bearing on:* `andersen2024_fep_cohort_t12m_paidany` (205 of 578), the only F05 result in the
primary pool.

**Q11. What was the vocational status of those who left the programme before 12 months?** Data
collection ended when treatment ended, so 578 of 1574 entrants (36.7%) have an observed 12-month
status. The authors state that "the positive effect of treatment could be larger than observed if
the young people who discontinued treatment did so due to feeling better" and also that "it is also
possible that the NEET status negatively influenced the engagement in treatment", so the direction of
the bias is not established. Treated as attrition under D12.3c: recorded in `n_outcome_observed`,
`missing_data_method` and `jbi9_response_rate`, and left to the SAP section 6 bounding analyses.

**Q12. Were any participants counted in both the FEP and the UHR cohorts?** The programme admits UHR
young people for 6 to 12 months "who do not go on to develop a psychotic disorder" (Methods, p. 876),
which implies some do transition. The report does not say whether a transitioning participant is
re-entered in the FEP cohort or how many transitioned, so the two cohorts cannot be verified as
disjoint. If they are not, `headspace_hep_fep_au` and `headspace_hep_uhr_au` share participants.

**Note on the off-list sibling.** `brown2022` (Brown et al. 2022) is recorded in the manifest as
sharing this cohort and is off the screening list (D10.1). It was **not** read and no figure was
imported from it. andersen2024 cites it twice (pp. 876 and 882) for previously published clinical and
functional outcomes of the same service and for the BPRS median used as a stratification cut-off, but
not for its own sample: the sample here is defined independently as "All young people accessing the
service between 19 June 2017 and 22 March 2021 who consented".

## andersen2026 (pooled Danish early-onset psychosis cohorts)

**Q13. How many participants were in any paid employment, including supported employment?** The
register variable groups "social benefits (unemployed/in supported employment)" into one category, so
supported employment is pooled with unemployment and zero paid work is not separable from positive
paid work. Under D12.3 `paid_any` is **not identified**; the bounds are 49 <= paid_any <= 155 of 198.
A split of the 106 in the "social benefits" category into supported-employed and not-employed would
identify it.

**Q14. What are the four constituent studies' inclusion and exclusion criteria?** They are summarised
only in supplementary Table A.1, which is not in the article PDF. `employment_selection_status = none`
was recorded for `dk_eop_pooled` on the report's own account of who entered ("participants between 10
and 17 years of age (both inclusive) with first-episode EOP ... recruited from inpatient and
outpatient psychiatric units in Denmark between year 1998 and 2016", and "All participants with EOP
or HCs from the clinical studies were included"). A 10-to-17-year-old psychiatric sample cannot
plausibly carry an employment-related entry criterion, but the criteria themselves were not read.
**A Stage G checker should verify this against Table A.1 before the cohort is treated as `none`.**

**Q15. What is each participant's elapsed follow-up?** Follow-up ends at a single calendar date,
31 December 2021, so elapsed follow-up runs from 4.5 to 23.5 years and the reported mean spans the
5-year and the 10-year-plus landmark bands. Individual-level or banded follow-up durations would
allow a landmark result to be constructed. *See [schema] S1.*

---

## [schema] Questions for the review team, not for an author

**S1. The vocabulary has no value for "mean elapsed follow-up to a fixed calendar census date".**
`followup_basis` offers `since_baseline`, `since_onset_mean`, `chronological_age` and `unclear`, and
only `since_baseline` can be assigned to a horizon. andersen2026 is measured from cohort entry, so
`since_baseline` is literally true, but recording it would place the cohort in the 108+ band on the
strength of an average spanning two bands, which is exactly the error D12.3b exists to prevent.
`unclear` was recorded as a deliberate horizon block, and `followup_months = 139` is retained for
information (`assign_horizon()` nulls it because the basis is not `since_baseline`). **A value such
as `since_baseline_mean` would state the situation honestly instead of borrowing `unclear`.** Until
one exists, a reader of the raw row could mistake `unclear` for "the report does not say what the
timepoint is measured from", which is not the case here.

**S2. `outcome_construct` has no value for a cross-classification cell such as "in employment and not
in education".** andersen2024's Table 2 splits its sample four ways (NEET, Working, Studying, Studying
and working). "Studying" maps cleanly to `education_only`, but "Working" (employed and not studying)
has no counterpart value. The two employment cells are recorded as
`outcome_construct = paid_any, result_role = component_only`, which is analytically safe because
`component_only` never enters any pool, with the truth carried in `outcome_verbatim` and `notes`. A
value such as `paid_only` would remove the need for the workaround.

**S3. Is a diagnostically restricted subset of an eligible cohort a whole recruited cohort?**
Both Suffolk County reports analyse only participants whose 10-year consensus diagnosis was
schizophrenia/schizoaffective disorder or bipolar disorder, explicitly excluding psychotic
depression, substance-related and other psychoses from a cohort recruited as consecutive first
admissions with *any* psychotic disorder. Those excluded participants have qualifying psychoses under
SAP section 7. The arms are therefore coded `arm_type = subgroup`, which keeps them out of the
primary prevalence pool under SAP section 2.1 ("Only a whole recruited cohort can contribute").
**Nothing in the primary estimate turns on it here** (the construct is `paid_competitive`, not
`paid_any`, and the horizon is 240 months), but the same question will recur wherever a cohort
recruited on psychosis is analysed only for its schizophrenia-spectrum members, and it should be
settled prospectively rather than case by case.

**S4. Extraction scope note, recorded so an omission is not mistaken for an absence.**
andersen2024 Table 2 also reports the 3-month and 6-month timepoints for the FEP cohort, and the
whole UHR panel. Neither was extracted: 3 and 6 months fall below the 9-month lower bound of the
earliest landmark window, and `chr` is barred from the primary estimand outright by SAP section 7.
Both are recoverable from Table 2, p. 880 if a below-landmark or CHR analysis is ever added.

**S5. No risk-of-bias assessment exists for wang2020b or wang2020c.** Risk of bias attaches to a
result, and neither report yields one. This is an omission by construction, not an oversight.
