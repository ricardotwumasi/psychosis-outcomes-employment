# Batch F12: internal contradictions found in the sources

Extractor: claude-opus-5. Batch F12. 12 August 2026. Prompt: `config/prompts/extraction_v3.md`.

Every entry gives the report, what the paper prints, what the arithmetic gives, and the exact
location. Where a contradiction bears on a result, `conflict_status = unresolved` is set on that
result row, per D12.3d and extraction_v3 rule 10; where it bears only on the description of the
cohort, it is recorded here and in the cohort row but does not block a result.

---

## solmi2022 — BLOCKING. The base of every employment percentage is contradicted by the methods

**Blocks:** `solmi2022_cohort_t12m_paidthresh`, `solmi2022_cohort_t24m_paidthresh`,
`solmi2022_cohort_t60m_paidthresh` (`conflict_status = unresolved`).

**What the paper prints.** Figure 1 (p. 942), "Development of main occupational activity of persons
with first-episode nonaffective psychosis, from 2 calendar years before to 5 years after first
diagnosis", carries the footnote: *"Time point 0 refers to the year of first psychosis diagnosis.
N=21,551."* The employed series runs 32.0, 30.5, 22.2, 19.5, 22.1, 22.9, 23.9, 25.1 per cent from
two years before diagnosis to five years after.

**What the methods say.** Cohort accrual ran from 2006 to **2016**, and *"the follow-up ended at
death, emigration, DP, or the end of data linkage (December 31, 2016), whichever occurred first"*
(Methods, Study Design and Statistical Analysis, p. 940). Median follow-up was **4.8 years, IQR
2.2 to 7.7** (Results, p. 940).

**The contradiction.** A person first diagnosed in 2016 has no year-1 observation and nobody
diagnosed after 2011 has a year-5 observation, so N = 21,551 cannot be the denominator of the
year-1 to year-5 percentages. An IQR whose lower bound is 2.2 years puts at least a quarter of the
cohort outside the year-3 point, let alone year 5. Either the figure's stated N is a cohort size
printed in a footnote rather than the base of its own percentages, or the series is computed on a
shrinking denominator that is never reported. The two accounts cannot both hold, and which one
holds determines what 19.5 per cent is 19.5 per cent *of*.

**A second, compounding contradiction in the same figure.** Follow-up is stated to end at
disability pension, yet disability pension appears in Figure 1 as a rising occupational category
reaching 27.3 per cent at year 5. People who have left follow-up are therefore still being
classified, so the occupational-activity series must use a different and unstated at-risk
definition from the survival analysis that the rest of the paper is built on.

**Candidate resolution, recorded as a candidate only.** The series is most likely computed on
whoever is under observation in each year, which would make the footnote's N the cohort size and
not the denominator. Under extraction_v3 rule 14 my own reconstruction is not an authority, so the
status stays `unresolved` and the reconstruction is recorded in `conflict_note` and in
`unresolved_queries.md`.

---

## stralin2019 — NON-BLOCKING. The diagnostic breakdown accounts for only 153 of 161 cases

**Location.** Results 3.2, "Primary diagnoses for the first episode psychosis", p. 376; Table 1
caption and rows, p. 378.

**What the paper prints.** *"The distribution of primary diagnoses for the 161 patients were as
follows: 40 cases (25%) with Schizophrenia, 13 cases (8%) with Schizophreniform disorder, 11 cases
(7%) with Schizoaffective disorder, 17 cases (11%) with Delusional disorder, 21 cases (13%) with
Brief psychosis, 30 cases (19%) with Psychosis NOS, 12 cases (7%) with manic of bipolar disorder
with non-congruent psychotic symptoms, and 9 cases (6%) with major depression with non-congruent
psychotic symptoms."*

**What the arithmetic gives.** 40 + 13 + 11 + 17 + 21 + 30 + 12 + 9 = **153**, not 161. Eight cases
are unaccounted for. The paper's own percentages sum to 96 per cent, which is consistent with
153/161 = 95 per cent, so the shortfall is in the counts and not a rounding artefact.

**A second contradiction, in the same numbers.** Table 1 (p. 378) dichotomises the 161 into
"Schizophrenia related syndromes (DSM-IV 295)" 64 and "Non-schizophrenia syndromes (not DSM-IV
295)" 97, which sum correctly to 161, and the caption defines the second group as *"delusional
disorder, brief psychosis and psychosis NOS"*. But those three categories total 17 + 21 + 30 = 68,
and adding the two affective-psychosis categories that the caption omits gives 68 + 21 = 89, still
short of the printed 97. The 64 is internally consistent (40 + 13 + 11 = 64); the 97 is not
reachable from any combination of the listed diagnoses.

**Effect on the extraction.** None on the employment result. The employment numerator 67 and its
denominator 161 agree exactly between the running text and Table 1, and every Table 1 subgroup
column checks against its own printed percentage and sums consistently with the 4 to 13 cases each
stratifier is missing. `conflict_status` on both stralin2019 result rows is therefore `none`. The
contradiction is recorded because it bears on `perc_qualifying_diagnosis` and on any future
diagnostic-subgroup moderator: it means the cohort's diagnostic composition as printed cannot be
reproduced.

---

## rodriguezpulido2021 — NON-BLOCKING. Three mutually inconsistent statements of the sample's diagnoses

**Location.** Abstract, p. 293; Results, first paragraph, p. 300; Table 1, p. 301; Methods, Study
groups, p. 296; Discussion, p. 309.

1. **Abstract vs Results.** The abstract says *"Sixty-five participants (83% with schizophrenia or
   bipolar disorder)"*. The Results say *"Mainly were people with schizophrenia and personality
   disorder (83% F20–29 and 17% F31–F32.3)"*. If F20–29 is 83 per cent and F31–F32.3 is 17 per cent
   and they sum to 100, then 100 per cent, not 83 per cent, have schizophrenia or a mood disorder.
   The same sentence also names "schizophrenia and personality disorder" while giving ICD blocks
   that contain neither personality disorder nor depression.
2. **Both vs Table 1.** Table 1 gives the diagnoses of the 47 analysed participants as 35
   schizophrenia (74.5 per cent), 7 bipolar disorder, 4 personality disorder and 1 depression. That
   is 74.5 per cent F20–29, not 83 per cent.
3. **Table 1 vs the inclusion criteria.** The stated criteria admit only *"an ICD-10 diagnosis of
   F20–29 ... and F31–F32.3"* (Methods, p. 296). Personality disorder is F60–F69 and does not
   satisfy either. Four of the 47 analysed participants therefore carry a diagnosis the study's own
   eligibility criteria exclude.

**Effect on the extraction.** `perc_qualifying_diagnosis` is recorded as 83, the paper's own F20–29
figure, with this entry flagged. The D13 diagnosis gate passes on any of the three readings, since
83, 74.5 and 100 all exceed 50 per cent, so the contradiction changes no eligibility decision here.
`conflict_status` on the four result rows is `none`, because the contradiction concerns the sample's
composition and not the employment result.

**A fourth, minor arithmetic slip.** The Limitations say the study *"can be severely limited by the
selection bias introduced due to the high rate (17%) of rejections"* (p. 310). Rejections were 8 of
65 who met criteria but did not consent, which is 12.3 per cent; 17 per cent is the *drop-out* rate
after randomisation (10 of 57 = 17.5 per cent). The two are conflated.

---

## topor2019 — NON-BLOCKING. The reported subgroups do not reconstruct the analysed cohort

**Location.** Method, pp. 920–921; Table 1, p. 921; Table 3, p. 923.

**What the paper prints.** 447 persons with a first-time psychosis diagnosis 2000–2004; minus 51
deceased, 10 register lapses and 22 retired persons; *"consequently, the follow-up group consisted
of 364 persons of working age (18–64 years)"*. The two groups whose salary proportions are reported
are 53 and 159 (Table 1).

**What the arithmetic gives.** 447 − 51 − 10 − 22 = 364, which checks. But 53 + 159 = **212**,
leaving **152 of the 364** in neither reported group. Those 152 are never described, never counted
into a third group, and no salary figure of any kind is given for them or for the 364 as a whole.

**Effect on the extraction.** This is not a contradiction between two printed numbers, so
`conflict_status` stays `none`; it is recorded here because it is the reason the report is
unquantifiable at the level the review needs. Even a complete set of counts for the two reported
subgroups would leave 42 per cent of the working-age cohort unmeasured, so no whole-cohort
prevalence is reconstructable from this report by any route.

---

## Checked and found consistent

Recorded so that a checker knows these were looked at rather than skipped.

- **stralin2019, Table 1, p. 378.** Every one of the 20 outcome cells matches its own printed
  percentage, and both outcome columns sum correctly across the schizophrenia dichotomy
  (15 + 52 = 67 employed of 64 + 97 = 161; 46 + 43 = 89 with antipsychotics of 161). The other four
  stratifiers each drop 2 to 13 cases with missing data on that stratifier, and every one of those
  shortfalls is consistent with the cohort totals.
- **stouten2019.** The diagnostic breakdown (81 + 9 + 9 + 5 + 2 + 56) sums exactly to the stated
  162, and the migration groups (46 + 56 + 60) sum exactly to 162.
- **shimada2022.** The disposition reconciles at every step: 136 randomised, 68 per arm; 18 excluded
  at index discharge (12 and 6) leaving 111 (54 and 57); 9 excluded during follow-up (6 and 3)
  leaving 102 (48 and 54). Diagnoses 88 + 14 = 102.
- **solmi2022, Table 1, p. 941.** Every count matches its printed percentage against N = 21,551, and
  the eight ICD-10 first-diagnosis categories sum to 21,551 exactly. The contradiction in this report
  is between Figure 1 and the Methods, not within Table 1.
