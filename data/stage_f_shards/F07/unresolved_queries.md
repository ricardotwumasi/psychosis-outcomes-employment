# Batch F07 — what an author would have to answer

One section per report. Each item states the question, why it matters to this review, and
what the answer would unblock. Items marked **BLOCKING** correspond to a
`conflict_status = unresolved` row or to a result with no recoverable numerator or
denominator.

---

## cook2016 (eidp_usa)

1. **The 24-month EIDP-period counts.** The report gives "worked at all" as 72% against
   63% and "achieving competitive employment" as 56% against 36% for the supported
   employment and control groups (Results, p. 1009) with no counts and no stated
   denominators. What are the four numerators, and are the denominators the 234 and 215
   shown in Table 1? Four results currently carry a blank numerator. **BLOCKING** for those
   four rows.
2. **Point prevalence by year.** Figure 1 plots the percentage with any earned income for
   each calendar year 2000 to 2012 but prints no counts. Could the yearly numerators and
   denominators be supplied? That would convert an unusable figure into up to thirteen
   point- or period-prevalence results.
3. **Elapsed follow-up.** Participants entered EIDP between 1996 and 1998 and the outcome
   window is the fixed calendar period 2000 to 2012. What is the distribution of elapsed
   time from each participant's own baseline to the start and end of that window? Without
   it the result cannot be assigned to any landmark horizon (D12.8).
4. **Which six sites.** Six of the eight EIDP sites joined the supplemental study. Which
   six? This determines whether the Hartford participants in `detore2019` are inside these
   449, which is a cohort-overlap question under D5 rather than a nicety.
5. **Diagnosis ascertainment.** What instrument established the "DSM-IV axis I diagnosis of
   mental illness", and who applied it?

## detore2019 (hartford_ips_rct)

1. **The other two arms.** 204 were randomised to IPS, a psychosocial clubhouse programme
   and standard brokered vocational rehabilitation, but only the IPS arm's 51 of 68 is
   given here. What are the equivalent counts for the clubhouse and standard vocational
   arms over the same two years? Without them no within-study contrast can be formed from
   this report.
2. **Characteristics of the 68.** Table 1 describes only the 51 who obtained work. What are
   the age, sex, education and diagnostic composition of the full allocated arm, and of the
   204 randomised? `perc_qualifying_diagnosis` for the cohort is blank because of this, and
   `mean_age` is blank on the result row for the same reason.
3. **Retention.** Did any of the 68 withdraw before the two years elapsed? The 17 counted
   as not obtaining competitive work are treated as observed non-attainers, which the
   report does not establish.
4. **Recruitment period.** The report gives no recruitment years for the parent trial.
5. **Point prevalence.** Was employment status recorded at fixed timepoints (the
   assessments were six-monthly) as well as cumulatively? A point-prevalence count at 12 or
   24 months would be a different and more useful estimand than cumulative attainment.

## domenicano2025 (eis_ferrara)

1. **The 24-month denominator. BLOCKING.** Is it 104 (Results 3.2, p. 4), 101 (Figure 1 and
   Table 2) or 102 (Figure 1's own subtraction, which also gives 26 women rather than 25)?
   Both 24-month results are blocked until this is settled by the authors.
2. **The 12-month male NEET count. BLOCKING.** Table 2 prints 50, but the printed total of
   35 and the cell's own 24.5% of 102 both require 25. Which is right?
3. **What "employed" means.** The report nowhere defines the employment variable. Does it
   require remuneration? Does it include sheltered or subsidised placements, "tirocini" and
   internships, and part-time work? `outcome_construct` is currently `unclear`, which keeps
   an otherwise usable 12-month result out of the primary pool; a definition naming paid
   work would move it to `paid_any`.
4. **The unclassified participants.** Student, Employed and NEET sum to 109 of 139 at 12
   months and 85 of 101 at 24 months. Are the remaining 30 and 16 in training (and so
   neither NEET nor student nor employed), or is their employment status missing? If the
   latter, `n_outcome_observed` should be smaller than the values recorded here.
5. **Screening flow.** Were 219 or 232 patients admitted before the study criteria were
   applied?

## drake2015 (ct_dual_diagnosis)

1. **The denominator of every employment cell. BLOCKING.** Table 3 prints 27 (28%) at year
   7 over a column N of 90, but 27/90 is 30%, and no cell of that row reconciles with its
   column N at any of the eight timepoints; at years 4 to 7 the implied denominators exceed
   the number interviewed. What denominator produced each printed percentage? Without it
   there is a numerator and no denominator, at every timepoint.
2. **The ascertainment window. BLOCKING (same rows).** Is competitive employment "at least
   1 day in the past 6 months" (Measures, p. 204) or "past y" (Table 3, p. 207)?
3. **The full 198.** Results are given only for the 150 with schizophrenia or
   schizoaffective disorder. Are the same outcomes available for all 198 enrolled? The 198
   is the whole recruited cohort and would be eligible for the primary estimand where the
   150-person diagnostic subgroup is not.
4. **Point prevalence.** Was current employment recorded at each annual interview as well
   as "any competitive job in the period"? A point-prevalence count would be a different
   estimand from the period measure recorded here.
5. **Overlap with the Hartford IPS trial.** Did any participant in this 1993 to 1998
   Connecticut sample also enter the Hartford supported-employment trial run in the same
   city and period by overlapping investigators?

## falk2016 (stockholm_2005)

1. **Crude counts. BLOCKING.** Table 2 reports only age-standardised non-employment rates.
   How many of the 421 men and 335 women had registered income from paid employment in
   2010, and how many in the baseline year? A crude numerator and denominator would make
   this large register cohort usable; the standardised rate cannot be converted into one,
   and its complement is not the crude employment proportion.
2. **The measurement window.** Is "registered income from paid employment" assessed over
   the whole calendar year, at a fixed date within it, or over some other window?
   `ascertainment_window_months = 12` is currently inferred from LISA being an annual
   register and from the rates being dated to single calendar years; the report never says.
3. **A single elapsed follow-up.** Inclusion was in 2005 or 2006 and follow-up is 2010, so
   elapsed follow-up is 4 to 6 years and varies within the cohort. Could the outcome be
   given at a fixed elapsed interval (for example five years after the index diagnosis) so
   that it could be assigned to a landmark horizon?
4. **The baseline-employed subgroup.** "51.1% of men and 56.3% of women were still
   employed" among those employed at baseline. Are these crude or standardised, and what
   are the counts and the size of the baseline-employed group?

## fulford2018 (raise_etp)

1. **Numerators and per-timepoint denominators. BLOCKING.** Table 1 gives the SURF
   work-or-school variable as 39.8%, 71.8% and 66.6% with no counts and only a range of Ns
   across all variables. How many participants were rated positive at each timepoint, and
   out of how many?
2. **What the percentage is a percentage of.** The three SURF items were "combined into a
   single score ... and aggregated across 6-month time points". Is the reported value the
   proportion of participants scoring 1 at the assessment, or the mean of a score averaged
   over several monthly ratings? 39.8% is not n/404 for any integer n, which suggests the
   latter, and that would make it a different quantity from a prevalence.
3. **Paid work separated from school.** The composite counts being a student as a positive.
   Can the paid-work items be reported separately from the student item? That would give a
   `paid_any` result at 12 months for a large first-episode cohort, which the composite
   cannot.
4. **Cluster design.** RAISE-ETP randomised 34 sites. Is a design effect or intracluster
   correlation available for the work-or-school outcome, and are arm-specific values
   available?
5. **The intervention.** This report does not describe the NAVIGATE components at all.
   Did the experimental programme include supported employment and education? The
   trial-derived whole-cohort safeguard `employment_targeted_intervention` is `unclear`
   solely because this source does not say, and a `no` or `yes` from the authors would
   settle whether the merged cohort could ever contribute a prevalence estimate.

---

## Two schema observations, for the authorship group rather than for an author

1. **`missing_data_method` has no value for full information maximum likelihood.**
   `fulford2018` handled missing data with FIML in its structural equation models. The
   controlled vocabulary offers `complete_case`, `last_observation_carried_forward`,
   `multiple_imputation`, `register_complete`, `not_stated` and `not_applicable`. The
   descriptive percentages this batch extracts are complete-case, so `complete_case` is
   recorded and the FIML models are described in `notes`, but a report whose *extracted*
   figure came from a FIML model would have no truthful value to record.
2. **Instrument choice for a single-arm proportion from a trial.** `extraction_rob.csv`
   attaches an instrument to a result, and neither RoB 2 nor ROBINS-I assesses a
   single-arm proportion. The rule applied in this batch, and stated here so it can be
   overridden consistently: `rob2` where the report itself presents a randomised
   between-arm comparison of the employment outcome and the row is one arm of that
   comparison (the six `cook2016` arm rows); `jbi_prevalence` for every other
   proportion-type result, including `detore2019`'s single IPS arm, whose selected
   character is then captured in the JBI sample-frame, sampling and coverage domains.
