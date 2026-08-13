# Batch F02 internal inconsistencies

Cohort `jump_norway` (Job Management Programme, Norway). Five reports:
`evensen2017`, `evensen2019`, `gjerdalen2023`, `klungsyr2021`, `lystad2017`.

Every item below records the report, what the paper prints, what the arithmetic
gives, and the exact location. Nothing here is resolved by assumption. Where a
conflict does not touch an extracted numerator that is stated explicitly, so a
checker does not have to rediscover it.

---

## I1. evensen2017: the percentage base changes between the four 2-year categories

**Location:** Results, Employment outcome, p. 183.

**Printed.** "At 2-year follow-up, 21.2% (n = 31) of the participants had
competitive employment ... In addition, 25.3% (n = 37) had work placements in
ordinary workplaces at 2-year follow-up ... An additional 13.7% (n = 20) had
sheltered work at 2-year follow-up ... The remaining 39.2% (n = 58) were
unemployed."

**Arithmetic.** The four counts sum to 146, which is 148 entered minus the two
deaths reported in the same paragraph. Three of the four percentages are on 146:
31/146 = 21.2, 37/146 = 25.3, 20/146 = 13.7. The fourth is not: 58/146 = **39.7**,
not the printed 39.2. The printed 39.2 is 58/148.

**Consequence for extraction.** None for the extracted numerators, which are the
printed counts. `reported_percentage_base` is recorded as 146, the base that
three of the four categories and every extracted count agree on. The defect is
carried into the JBI item 8 judgement for
`evensen2017_cohort_t24m_paidcomp`.

---

## I2. evensen2017: the category counts (146) and the observation denominator (139) differ by exactly the seven who could not be reached

**Location:** Results, Employment outcome, p. 183, against Figure 1, p. 182.

**Printed.** Figure 1's final row reads "2 Year follow up: 78 employment status"
(CBT) and "2 Year follow up: 61 employment status" (CR). 78 + 61 = 139. The text
categories sum to 146.

**Text that reconciles them.** "Seven participants could not be reached at the
two-year follow-up. The loss to follow-up of these subjects was managed
conservatively by classifying them as unemployed at the end of the intervention
period." 146 − 7 = 139.

**Independent confirmation from a sibling report.** `evensen2019` Table 1, p. 5,
compares the 2-year employment outcome of consenters and decliners and carries
the test statistic **chi-square (3, n = 139)**. Its printed percentages resolve to
integers only on bases of 69 and 70: competitive 16 + 15 = 31, work placement
24 + 13 = 37, sheltered 9 + 11 = 20, unemployed 20 + 31 = 51. The first three
match `evensen2017` exactly; the fourth is 51, and 51 + 7 imputed = 58. The two
deaths and the seven unreached all fall in the declined group, which is why its
employment row sits on 70 while its header says N = 79.

**Consequence for extraction.** This is a reporting ambiguity rather than a
contradiction, and it is resolved. `n_outcome_observed` = 139 with
`denominator_basis = outcome_observed`; the report's own base of 146 goes in
`reported_percentage_base`. `conflict_status` stays `none`. The residual
ambiguity is the phrase "at the end of the intervention period" in a paragraph
about the two-year follow-up; see `unresolved_queries.md` Q2.

---

## I3. evensen2017 Table 1: the gender percentages belong to a different sample

**Location:** Table 1, p. 183, "Gender, male" row, against `gjerdalen2023`
Table 1, p. 26 and `lystad2017` Table 1, p. 125.

**Printed.** `evensen2017` Table 1 is headed "Baseline sample characteristics
(n = 148)" with columns CBT (n = 84) and CR (n = 64), and gives male 61.8% and
79.4%.

**Arithmetic.** 61.8% of 84 = 51.9 and 79.4% of 64 = 50.8, neither an integer.
Those two percentages are exactly `lystad2017`'s values for the 131-participant
neurocognitive subsample: 42/68 = 61.8% and 50/63 = 79.4% (Table 1, p. 125).
`gjerdalen2023` Table 1 prints the same variable for the same 84 and 64 as
**counts**: 53 (63%) and 50 (78%).

**Consequence for extraction.** `n_female` = 45 is taken from
`gjerdalen2023`'s printed counts (148 − 53 − 50 = 45), not from
`evensen2017`'s percentages. Both routes happen to give 103 males in total, so
the extracted moderator is unaffected, but `evensen2017`'s printed percentages
are wrong against its own denominators and must not be used.

---

## I4. gjerdalen2023: the 5-year denominator of 148 includes two participants who had already died

**Location:** `gjerdalen2023` Results 3.2, p. 25 and Figure 1, p. 26, against
`evensen2017` Results, p. 183.

**Printed.** `gjerdalen2023` reports "Thirty-three individuals (22.3%) were
competitively employed at 5-year follow-up" and Table 1 is headed
"Ntotal = 148". 33/148 = 22.30%, so the base is 148; 33/146 would be 22.6%. The
arm percentages reweight onto 148 exactly (competitive 19% of 64 plus 25% of 84
gives 33.2; work placement gives 27.1 against a printed 18.2% of 148 = 26.9;
sheltered gives 22.0 against 14.9% of 148 = 22.1).

**Contradicting fact.** `evensen2017` states "Two individuals died prior to
2-year follow-up of causes unrelated to participation in the study" (p. 183).
`gjerdalen2023` never mentions the deaths and reports no attrition of any kind at
5 years.

**Consequence for extraction.** Two people who could not have been employed sit
in the 5-year denominator, biasing the proportion slightly downwards.
`n_outcome_observed` = 148 is recorded with `denominator_basis = entered` rather
than `outcome_observed`, and `n_alive_eligible` is left **blank** rather than set
to 146, because recording 148 observed of 146 alive would assert an impossible
nesting. Carried into JBI item 5 for `gjerdalen2023_cohort_t60m_paidcomp`.

---

## I5. Baseline employment: 17 per cent in one report, 12.9 per cent in another

**Location:** `evensen2017` Background, p. 181, against `gjerdalen2023`
Figure 1, p. 26 (Baseline column).

**Printed.** `evensen2017`: "At the start of the intervention all participants
were reliant on social security benefits, and 17% had some form of employment
(29)" — the figure is attributed to reference 29, Bull et al. 2016, which is not
in this batch. `gjerdalen2023` Figure 1's baseline column is labelled
competitive employment 2.7%, work placement 6.1%, sheltered work 4.1%, summing to
**12.9%**.

A third statement sits alongside them: "Among the 148 individuals who commenced
the programme, none had competitive employment with wages as their primary source
of income at baseline" (`evensen2017`, p. 183). That one is compatible with 2.7%
competitive, since 2.7% could be in competitive work without wages as their
primary income.

**Consequence for extraction.** `perc_employed_baseline`,
`n_employed_baseline` and `n_employed_baseline_denominator` are left **blank** on
every row. No count is printed for either figure, the two percentages disagree by
4 points, and one is second-hand. See `unresolved_queries.md` Q4.

---

## I6. evensen2019 Table 1: the declined column's employment row is on 70, not the header's 79

**Location:** `evensen2019` Table 1, p. 5.

**Printed.** Column header "Declined (N = 79)". Employment outcome for that
column: competitive 21.4%, work placement 18.6%, sheltered 15.7%, unemployed
44.3%, with chi-square (3, n = 139).

**Arithmetic.** On 79 those give 16.9, 14.7, 12.4 and 35.0, none an integer. On
**70** they give exactly 15, 13, 11 and 31, summing to 70; and 69 + 70 = 139, the
n printed in the same row's test statistic. The other 9 (2 deaths, 7 unreached)
have no 2-year employment status. The header is correct for every other variable
in the column: male 58 (73.4%) is 58/79.

**Consequence for extraction.** Nothing is extracted from the declined column.
The row is used only as the independent confirmation of the 139 in I2.

---

## I7. evensen2019 Table 1: one education percentage is typeset on the header line

**Location:** `evensen2019` Table 1, p. 5, "Education, highest completed".

The declined column shows "32.9%" against the *header* row rather than against a
category, and its University and "Not completed primary school" cells are empty.
38.0 + 13.9 + 8.9 + 6.3 = 67.1, and 67.1 + 32.9 = 100.0, so the stray value is a
displaced category percentage. Recorded for completeness; nothing is extracted
from this row and `perc_post_secondary` is blank on every result.

---

## I8. Apparent, not real: evensen2017's screening numbers

Text, p. 182: "76 did not meet the inclusion criteria". Figure 1, p. 182, splits
the same people into "34 ineligible" (before assessment) and "42 excluded"
(after), and 34 + 42 = 76. The full chain reconciles exactly:
319 − 61 declined − 34 ineligible = 224 assessed; 224 − 42 excluded − 9 no-shows
= 173 eligible; 173 − 25 non-starters = 148 starters. Recorded so that a checker
does not log it as a contradiction.

---

## I9. Not an inconsistency but a construct trap: the 46.5 per cent and 55.4 per cent composites

`evensen2017` (Discussion, p. 185) writes "as many as 46.5% worked in ordinary
workplaces with pay **or social security benefits** at 2-year follow-up"
(21.2 + 25.3). `gjerdalen2023` (Results 3.2, p. 25) writes "At 5-year follow-up
55.4% of the participants were in some form of employment" (22.3 + 18.2 + 14.9).

Both composites are arithmetically correct and both pool paid competitive work
with categories that carry no employer wage. `lystad2017` (2.1, p. 123) is
explicit: work placement is "financed by the Norwegian Labor and Welfare
Administration through work assessment allowance or disability benefits", and
sheltered work is "funded by the Norwegian Labor and Welfare Services through so-
called work assessment allowance or disability pensions". Neither composite is
`paid_any`. They are extracted as `vocational_activity`, and `paid_any` is left
unidentified for this cohort with the bound 31 ≤ paid_any ≤ 88 on the 139
observed at 2 years.

## Post-extraction normalisation, 12 August 2026 (not a source inconsistency)

This shard originally coded the nine JBI domains as `q1_sample_frame` to
`q9_response_rate`. Batch F01 independently coded the same checklist as
`jbi1_sample_frame` to `jbi9_response_rate`. Neither shard was wrong: the schema
did not fix the slugs, so each extractor had to choose.

`config/vocabularies.yml` now fixes them per instrument, and the validator
enforces both the slug set and its completeness per result. This shard's nine
slugs were remapped position to position onto the canonical set, which is exact
because the JBI checklist is numbered 1 to 9 in a fixed order. No judgement,
rationale, source location or result was altered.
