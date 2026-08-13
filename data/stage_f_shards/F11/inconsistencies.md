# Internal inconsistencies found in batch F11

Batch F11, extracted 12 August 2026 under `config/prompts/extraction_v3.md`.

Every internal contradiction found while reading the six reports is listed, whether or not it
touches an extracted result. Each entry gives what the paper prints, what the arithmetic gives,
and where. Where a contradiction bears on a result, the result carries
`conflict_status = unresolved` and is named; where it does not, that is stated so a checker does
not go looking for a block that is not there.

Page numbers are article pages except for `nakamura2025` and `pedersen2025`, which are paginated
as "N of 13" and "N of 11" respectively.

---

## mucci2021

### M1. The 4-year working-status count and its percentage cannot both be right against the stated sample. BLOCKS A RESULT.

**Prints** (Results, Study Population, p. 553): "Of 921 individuals recruited at baseline, 618
participated in the present study"; "Of 618 participants, 427 (69.1%) were male"; and "patients
had ... a modest increase in working status (170 [28.9%] vs 208 [35.4%]; P < .001) ... (eTable 2
in Supplement 1)".

**Arithmetic gives**: 208/618 = 33.66%, not 35.4%. 170/618 = 27.51%, not 28.9%. Both printed
percentages are instead consistent with an unstated base of 588: 208/588 = 35.37% and
170/588 = 28.91%.

**Effect**: `mucci2021_cohort_t48m_working` is `conflict_status = unresolved`. The candidate
resolution (588 = pairs with both baseline and follow-up status, as a within-participant McNemar
comparison requires) is recorded in `conflict_note` as a candidate only. Under prompt rule 14 an
extractor's own reconstruction is not an authority, so the status stays `unresolved` and
`n_outcome_observed` stays blank rather than being back-calculated.

### M2. The same sentence implies three different denominators.

**Prints** (Results, Study Population, p. 553): supported housing 76 (12.4%) vs 62 (10.1%); legal
problems 52 (8.5%) vs 8 (1.3%); stable affective relationships 92 (15.1%) vs 115 (18.8%);
second-generation antipsychotic treatment 432 (69.9%) vs 441 (71.4%).

**Arithmetic gives**: 76/612 = 12.42% and 62/612 = 10.13%; 52/612 = 8.50% and 8/612 = 1.31%;
92/609 = 15.11% and 115/612 = 18.79%; 432/618 = 69.90% and 441/618 = 71.36%. So three or four
different bases (about 609, 612, 618 and, for working status, 588) are in use in one sentence.

**Effect**: no separate block. This is the corroborating evidence that M1 is item-level
missingness rather than a typographical error, and it is the reason the base for working status
cannot simply be assumed to equal any other variable's base.

---

## nakamura2025

None of the following touches the employment numerators. The three employment counts and their
denominator are mutually consistent: 9/21 = 42.86%, 4/21 = 19.05%, 5/21 = 23.81%, and 4 + 5 = 9.
All `nakamura2025` results are therefore `conflict_status = none`.

### N1. "23 participants who completed the study" against 21 completers.

**Prints** (Methods, Participants, p. 2 of 13): "Among the 23 participants who completed the
study, seven individuals (30.4%) took anticholinergic medications and nine (39.1%) took
benzodiazepines during CRT." Table 1 (p. 3 of 13) is headed Total (n = 23), Completers (n = 21),
Dropouts (n = 2) and gives anticholinergic use 7 for the total and 6 for completers, benzodiazepine
use 9 for the total and 8 for completers.

**Arithmetic gives**: 7/23 = 30.4% and 9/23 = 39.1%, so the quoted figures belong to the total of
23 assessed pre-intervention, not to the 21 who completed. The word "completed" is wrong.

### N2. Figure 2 and the text disagree about why two participants left.

**Prints**: Figure 2 (p. 6 of 13) labels the step from 23 to 21 "Declined to participate n = 2";
the Results text (p. 6 of 13) says "During the intervention, two participants dropped out".

### N3. The sample's mean education is the non-transition subgroup's value.

**Prints** (Results, p. 7 of 13): "Participants had a mean of 12.9 +/- 1.9 years of education".
Table 1 gives completers 13.1 +/- 1.7. Table 3 (p. 9 of 13) gives the 1Y-NET non-transition group
12.9 +/- 1.9.

**Effect**: the whole-sample education figure in the text has been copied from one subgroup.
`n_post_secondary` is not extracted from this report in any case.

### N4. Two effect sizes disagree with their own table.

**Prints**: Results p. 7 of 13 gives BACS motor speed "effect size = 1.06"; Table 2 (p. 8 of 13)
gives 1.03 for the same comparison. Results p. 7 of 13 gives mean age 40.7 +/- 6.6; Table 1 gives
40.7 +/- 6.7.

### N5. A confidence interval that excludes its own point estimate.

**Prints** (Table 2, p. 8 of 13): BACS composite score, "effect size 1.38 (0.97-1.00)". The
interval does not contain 1.38 and its bounds are in the wrong order relative to the estimate.
The same impossible interval is repeated in the text on p. 7 of 13.

### N6. The number of sessions is given three ways.

**Prints**: Abstract, "The program included 24 sessions over 3 months, conducted twice weekly";
Methods, Intervention, p. 2 of 13, "The intervention included 36 sessions over 3 months ...
repeated 24 times for cognitive training (24 sessions) and 12 times for bridging sessions (12
sessions)"; Results, p. 7 of 13, "A total of 24 interventions were conducted". 24 + 12 = 36, so
the abstract and the Results count the cognitive-training sessions only.

---

## pedersen2025

None of the following blocks a result. All sixteen cells of Table 2 reconcile with their
denominators of 116 and 130, so every `pedersen2025` result is `conflict_status = none`.

### P1. Fifteen per cent of the Morpheus group was employed at baseline, under a criterion that excludes the employed. AFFECTS THE SELECTION CODING, NOT A COUNT.

**Prints** (Methods 2.1, p. 2 of 11): "Morpheus targeted OPUS patients aged 18-35 who neither were
employed nor enrolled in school but were motivated to do so". Table 1 (p. 6 of 11), Employment
status at inclusion in OPUS: Employment 18 (15.5%) Morpheus and 7 (5.4%) standard; Education grant
19 (16.4%) and 16 (12.3%).

**Arithmetic gives**: 18 + 19 = 37 of 116 Morpheus patients (31.9%) were employed or on an
education grant at the point the criterion says none should have been.

**Candidate explanation, recorded and not applied**: baseline is the date of OPUS inclusion
(Methods 2.6.2, p. 4 of 11), whereas "The Morpheus programme started at a median of 183.5 days
(IQR: 90.5; 359.5) following OPUS inclusion" (Results, p. 4 of 11), so employment status could
change in the intervening six months. The selection coding is unaffected either way: the
restriction was applied at Morpheus entry, which is what D9 asks about, so
`employment_selection_status = selected` stands.

### P2. Both eligibility percentages are computed on a base other than the one named in the sentence.

**Prints** (Results, p. 4 of 11): "A total of 404 patients were referred to the OPUS programme in
Aarhus, of whom 116 (41.0%) were included in Morpheus (Figure 1). In Aalborg, 246 patients were
referred to OPUS, with 130 (60.2%) eligible for Morpheus."

**Arithmetic gives**: 116/404 = 28.7% and 130/246 = 52.8%. The printed percentages are instead
116/283 = 40.99% and 130/216 = 60.19%, i.e. they use Figure 1's post-exclusion bases (283 Aarhus
and 216 Aalborg after 151 exclusions) while the sentence names the pre-exclusion referral counts.
The flow itself is sound: 404 + 246 = 650, 650 - 151 = 499 = 283 + 216.

### P3. The two group percentages in Table 1 sum to more than 100.

**Prints** (Table 1, p. 6 of 11): "Total 116 (47.2) / 130 (52.9)".

**Arithmetic gives**: 116/246 = 47.15% and 130/246 = 52.85%; the second is rounded up and the
first down, so the printed pair sums to 100.1.

### P4. A 19 per cent that matches two different rows.

**Prints** (Discussion, p. 8 of 11): "This is comparable to the 19% of Morpheus patients who
obtained employment or enrolled in school." Table 2 gives employment at 4 years as 22 (19.0%) for
Morpheus, which is employment alone; employment or education at 2 years is (10 + 12)/116 = 18.9%.

**Effect**: the label "employment or enrolled in school" fits the 18.9% figure and the number
19.0% fits the employment-only row. The extraction takes both counts from Table 2 directly, so no
result depends on resolving this.

### P5. Abstract times the outcomes from diagnosis, Methods from OPUS inclusion.

**Prints**: Abstract, "employed or enrolled in education 2 and 4 years after diagnosis"; Methods
2.6.2 (p. 4 of 11), "Baseline was defined as the date of inclusion in the OPUS programme"; Tables
3 and 4, "after inclusion in OPUS treatment". The Methods definition is taken as authoritative and
`followup_basis = since_baseline` with 24 and 48 months is recorded against it.

---

## peebo2022

### E1. A 12-month employment percentage that no integer numerator can produce on its stated base. BLOCKS A RESULT.

**Prints** (Table 2b, p. 210): the 12-month column is headed "12 months (n = 154)" and the
Employment% row prints 47.7 in that column. Table 2a (p. 210), headed "N = 107, who attended all
the follow-ups", prints 47.7 for the same variable and timepoint.

**Arithmetic gives**: on a base of 154, 73/154 = 47.40% and 74/154 = 48.05%; no integer gives
47.7% under rounding or truncation. On a base of 107, 51/107 = 47.66%, which does.

**Effect**: `peebo2022_cohort_t12m_employment_all154` is `conflict_status = unresolved`. The
candidate resolution, recorded and not applied, is that the Table 2b cell repeats Table 2a's
completer figure instead of being computed on 154.

### E2. The same table's 6-month unemployment percentage is also unattainable.

**Prints** (Table 2b, p. 210): 6-month column headed n = 166, Unemployment% 9.9.

**Arithmetic gives**: 16/166 = 9.64% and 17/166 = 10.24%. No integer gives 9.9%. Other cells in
the same column do reconcile (Permanent incapacity for work 24.7% = 41/166; Employment 45.7% =
76/166 truncated from 45.78%), so the problem is cell-specific rather than a base error. Six-month
results are below the review's twelve-month minimum and are not extracted, so this blocks nothing;
it is recorded because it shows E1 is not isolated.

### E3. Forty-two or forty-seven dropouts after 12 months.

**Prints** (Results, Ten-year follow-up, p. 209, and repeated at Discussion, Limitations, p. 213):
"we compared patients at the 12-month follow-up to see if there is any clinically significant
difference between patients who stayed in the study (n = 107) and the patients who dropped out
(n = 42) after 12 months". Figure 1 (p. 212) shows "Included at 12 months (n = 154)" and
"Included at 24 months (n = 107)" with "Lost to follow-up (n = 47)" between them.

**Arithmetic gives**: 154 - 107 = 47, and Figure 1's own breakdown of that loss sums to 47
(change of diagnosis 2, refused 11, lost contact 27, relocated 7). 42 appears nowhere else.

### E4. The intervention group's causes of death sum to one fewer than the total printed.

**Prints** (Table 5, p. 211): intervention group unnatural causes 4 (3.4%), with the footnote
"Intervention group: poisoning, undetermined intent (n = 1), accidental poisonings and 1
intentional self-harm with a sharp object (n = 2)". The text (p. 211) says "four patients in the
intervention group died of unnatural causes".

**Arithmetic gives**: the footnote's items sum to 3, not 4. The control group's footnote does sum
correctly to 9 (1 + 2 + 4 + 1 + 1). Deaths are not an extracted outcome.

---

## petrakis2019

None of the following blocks a result. Tables 3 and 4 reconcile throughout (63 = 31 + 8 + 24;
63 = 46 + 11 + 6; 92 = 38 + 15 + 39; 15 = 4 + 5 + 2 + 3 + 1; every diagnosis, education,
accommodation, age and marital-status column sums to 136), so all `petrakis2019` results are
`conflict_status = none`.

### V1. Fifteen of 126 against fifteen of 136.

**Prints** (Results, Participant demographics and characteristics, p. 539): "Only 11% of the cohort
(15 of 126 participants) had completed any tertiary study." Table 2 (p. 541): "Completed Tertiary
15 11.0%", and the study cohort is N = 136.

**Arithmetic gives**: 15/126 = 11.90%, which does not round to 11.0%; 15/136 = 11.03%, which does.
The number 126 appears nowhere else in the report, and 136 minus the 19 whose education level was
"Not specified" is 117, not 126.

**Effect**: `n_post_secondary = 15` is recorded with `n_post_secondary_denominator = 136`, the
denominator Table 2's own percentage supports.

### V2. "Of placements" used for a participant-level count.

**Prints** (Results, Employment outcomes, p. 540): "Overall, 22.8% (N = 31) of participants
achieved a confirmed competitive open employment role, 5.9% [8] a non-competitive placement, and
outcome type was not specified for 17.6% (N = 24) of placements." The Discussion (p. 541) instead
says "type of employment (competitive or non-competitive) was not specified for 17.6% of the
working group".

**Arithmetic gives**: 24/136 = 17.6% (participants), whereas the placement-level unspecified count
is 39 of 92 = 42.4% (Table 4, p. 542). The phrase "of placements" is wrong; the Discussion's
"working group" reading, and Table 3's note that "All percentages were calculated using N values
as denominators", both give participants.

### V3. "Achieved employment" describes a category that includes unpaid activity.

**Prints**: Abstract, "findings were that 46.3% of participants achieved employment"; Table 3
(p. 541), "Employment Outcome 63 46.3%"; Table 4 (p. 542), placement types include "Volunteer Work
3 3.3%" and "Unpaid Work Experience Position 1 1.1%".

**Effect**: not an arithmetic contradiction but a construct one, and it is the reason the 63 is
coded `vocational_activity` rather than `paid_any`. The report gives no way to say how many of the
63 attained only unpaid activity, because Table 4 counts placements and Table 3 counts people.

---

## ringbom2023

### R1. The schizophrenia and schizoaffective group is 86 in one place and 137 in another. BLOCKS FIVE RESULTS.

**Prints** (Results, Labor Market Outcomes, p. 93): "The 86 subjects diagnosed with schizophrenia
or schizoaffective disorders were more likely to be not studying (n = 61, 70.9%), not working
(n = 40, 46.5%), or not on parental leave (n = 75, 87.2%)". Table 1 (p. 93) heads the column
"Schizophrenia (n = 86)". Results, Participants and Setting (p. 93): "68 with schizophrenia
(ICD-10-code F20), 18 with schizoaffective disorder (F25)". Results, Clinical Characteristics
(p. 95): "These were for the 137 (47.6%) with schizophrenia or a schizoaffective disorder".

**Arithmetic gives**: 68 + 18 = 86, and every band in Table 1's schizophrenia column sums to 86
(40 + 29 + 17; 61 + 18 + 7; 75 + 11 + 0; 13 + 24 + 49), and the abstract's 57.0% long-term NEET is
49/86 = 56.98%. Separately, 137/288 = 47.57%, so 137 is internally consistent with its own
percentage. Both numbers are self-consistent and they cannot both describe one named group.

**Effect**: all five `sz_sza` results carry `conflict_status = unresolved`. The candidate
resolution, recorded and not applied, is that 86 is anchored by four independent sums and 137 is
probably a different or later ascertainment used only in Supplementary Table 1, which is not held.
The five whole-cohort (n = 288) results are unaffected and are `conflict_status = none`.

### R2. The cohort flow is fifteen short.

**Prints** (Results, Participants and Setting, p. 93): "The 1987 Finnish Birth Cohort study
included 59 476 people ... Of these, 756 had died before the end of follow-up period in 2015, 2
913 had emigrated, and 534 had been diagnosed with intellectual disabilities. A further 117 were
excluded because they were diagnosed with a psychotic disorder during 1998-2003 ... The final
number included in the analyses was 55 171, which was 92.8% of the cohort."

**Arithmetic gives**: 59 476 - 756 - 2 913 - 534 - 117 = 55 156, which is 15 fewer than the stated
55 171. **Candidate explanation, recorded and not applied**: if 15 individuals fall into two
exclusion categories at once (for example emigrated and intellectually disabled), the naive sum
over-counts exclusions and the true remainder is larger, which is the direction observed. Both
figures round to 92.8% of 59 476, so the printed percentage does not discriminate. No extracted
result uses 55 171 or 55 156 as a denominator.

### R3. Table 2's non-psychosis NEET base contradicts Table 1's long-term NEET count.

**Prints**: Table 1 (p. 93), no-psychosis group, "Not in education, employment or training / >= 5
year 1187 (2.2%)". Table 2 (p. 93), no-psychosis columns headed "Total (n = 54 883)" and "NEET
(n = 1290)", for a table titled "The prevalence of sociodemographic characteristics and long-term
NEET".

**Arithmetic gives**: 1187/54 883 = 2.16%, matching the abstract's 2.2%. 1290/54 883 = 2.35%.
Table 2's own cells are computed on 1290 (for example parental severe psychiatric illness 244
(18.9%), and 244/1290 = 18.91%), so 1290 is genuinely the base used there. The psychosis column is
not affected: Table 2's "NEET (n = 103)" matches Table 1's 103.

**Effect**: the non-psychosis group contributes no result to this review, so nothing is blocked.

### R4. The abstract counts a thousand more people without psychosis than the results do.

**Prints**: Abstract, "The study cohort were 288 people who had been diagnosed with psychotic
disorders during 2004-2007 ... and 55 883 who had not." Results (p. 93) and Table 1: 54 883.

**Arithmetic gives**: 55 171 - 288 = 54 883. The abstract's 55 883 is a transposition.

### R5. Ages 20-28 or 21-28.

**Prints**: Abstract and Methods, "We looked at the national register data for those subjects in
2008-2015, when they were 20-28 year old"; Table 1's title, "Status during 2008-2015 when the
subjects were 21-28 years of age".

**Effect**: the window is the same either way for a 1987 birth cohort (age 20 at the start of 2008,
21 during it). `measurement_age_years = 28`, the age at the end of the window, is recorded with the
discrepancy noted in each result's `notes`.
