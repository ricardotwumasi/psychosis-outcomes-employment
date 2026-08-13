# Batch F12: what an author would have to answer

Extractor: claude-opus-5. Batch F12. 12 August 2026.

Ordered by how much the answer would change. The first two queries would each recover a numerator
that the review currently loses; the rest are definitional and would not.

---

## 1. stralin2019 — the highest-value single question in this batch

**Query.** Results section 3.5, p. 378 states: *"86 cases (53%) had any income and 67 cases (42%)
had an income above 100 000 SEK year 13."* Does **"any income"** mean any income **from
employment**, or any income from any source recorded in LISA, which the same paper describes
(Methods 2.3, p. 376) as including *"income from employment, payments from sickness benefits and of
student aides"*?

**Why it matters.** If it means any employment income, then **86 of 161** is a directly reported
`paid_any` count with a clean register denominator at 13 years, and `parachute_sweden` gains a
usable numerator for the 108-months-and-above horizon. If it means any income of any kind, the
figure is not an employment measure at all. The sentence's construction, pairing "any income" with
"an income above 100 000 SEK", reads as the first; the Methods definition of the register permits
the second. Nothing else in the article uses the phrase, and it appears in neither Table 1 nor
Figure 3.

**Recorded as.** `stralin2019_cohort_t156m_anyincome`, `outcome_construct = unclear`,
`n_employed = 86`, `n_outcome_observed = 161`. The count is preserved so that a single-word answer
can promote it; it is not labelled `paid_any` on my reading of a sentence.

**Secondary part of the same query.** Can the authors supply the number in **any** paid employment
at year 13, without the 100,000 SEK threshold? The threshold-defined 67 of 161 is
`paid_intensity_threshold` under D12.3a and cannot substitute for `paid_any`.

---

## 2. solmi2022 — the largest cohort in the batch, and no numerator

**Query A, the denominator.** For each year plotted in Figure 1 (p. 942), how many people
contributed to the occupational-activity classification? The footnote gives N = 21,551, but accrual
ran to 2016 while data linkage ended 31 December 2016 and median follow-up was 4.8 years (IQR
2.2–7.7), so the whole cohort cannot have a year-5 observation and part of it cannot have a year-1
observation. Relatedly, follow-up is stated to end at disability pension, yet disability pension
appears in Figure 1 as a rising category reaching 27.3 per cent at year 5; which at-risk definition
does the occupational series use?

**Query B, the numerator.** Can the authors supply the **counts** behind the "Employed" series,
particularly at one year after diagnosis (19.5 per cent) and five years (25.1 per cent)?

**Query C, the construct.** What is the Statistics Sweden income rule by which people were
*"categorized as employed or not employed based on income"*? The paper states the >6-months-yearly
dominance rule for assigning a main activity but not the underlying employed/not-employed
threshold, so the classification cannot be reproduced. Separately, is a count in **any** paid
employment during each year available, as distinct from the main-activity category?

**Query D, the exclusion.** 5,144 people already on disability pension at first diagnosis were
excluded. Can the employment percentages be recomputed with them included, or their number given
per year? As it stands the analysed cohort is conditioned on not having permanently reduced work
capacity at entry, which raises every printed employment percentage by an unknown amount.

**Why it matters.** This is a 21,551-person national register cohort with a printed employment
figure at exactly the twelve-month landmark. Answers to A and B alone would put the largest
first-episode cohort in the review into the primary evidence base, subject to the construct and
ascertainment gates. Recorded as `conflict_status = unresolved` on all three result rows.

---

## 3. rodriguezpulido2021 — counts that exist but are not printed

**Query.** How many participants in each arm obtained at least one job by 8 months and by 12
months? The paper reports only percentages (52.2 and 60.9 per cent for CR+IPS, 29.2 and 37.5 per
cent for IPS-only; Results and Figure 3, p. 307) against printed denominators of 23 and 24, and
Table 4 (p. 308) gives means for jobs per individual, weekly hours and hourly wage but no
employment count.

**Why the numerator is left blank anyway.** The percentages and denominators would multiply to
whole numbers, and it would be easy to treat that as recovery rather than reconstruction. It is
reconstruction, and extraction_v3 rule 1 and codebook rule 2 forbid it without exception. A confirmed
count from the authors is a different object from an arithmetic one.

**Second query, of limited value.** Was any *point-prevalence* employment figure recorded, in
addition to the cumulative "at least one job during the period" measure? And was any figure recorded
for **any** paid work rather than competitive work only? Even with counts, the reported result is
cumulative attainment of competitive employment in an employment-selected trial arm, so it would
enter neither the primary pool nor the point-prevalence syntheses.

**Third query.** The stated inclusion criteria admit only ICD-10 F20–29 and F31–F32.3, yet Table 1
(p. 301) lists 4 participants with personality disorder and 1 with depression among the 47
analysed. Which is correct? And is the sample 83 per cent F20–29 (Results, p. 300), 74.5 per cent
(Table 1), or "83% with schizophrenia or bipolar disorder" (Abstract)?

---

## 4. topor2019 — the missing 152, and one undefined word

**Query A.** What proportion of the full 364-person working-age follow-up group had income from
salary at year 10, and what are the counts? Table 3 (p. 923) reports only the two service-contact
subgroups (n = 53 and n = 159), which together cover 212 of the 364; the remaining 152 are never
described.

**Query B.** What are the **counts** behind every cell of Table 3? All 20 cells are percentages
with no numerators.

**Query C.** What does **"retired persons"** mean in *"These groups were excluded from the study, as
were 22 retired persons. Consequently, the follow-up group consisted of 364 persons of working age
(18–64 years)"* (p. 921)? Old-age pension, or disability pension? Disability pension is separately
tracked as a source of income *within* the analysed group, rising from 8 to 21 per cent and 20 to 61
per cent in the two subgroups, which suggests the 22 are old-age pensioners and the restriction is
an age restriction rather than an employment one. The report does not say, and silence is not
evidence of absence, so `analysis_selection_status` is recorded as `unclear` on both arm rows rather
than `none`. A one-line answer would move this cohort's analysis units from the sensitivity analysis
to the primary gate, though it would still fail on being subgroups.

**Query D.** Does "salary" include subsidised or sheltered employment, and is there a threshold
below which salary income was not counted?

**Query E.** Is "Year 1" the calendar year in which the diagnosis was set, so that "Year 10" is nine
rather than ten elapsed years? Table 2's footnote a implies the former. Both 108 and 120 months fall
in the same horizon band, so the answer changes no assignment here, but it should be settled for
consistency with the other Swedish cohorts.

---

## 5. stouten2019 — no employment measure exists to query

**Query.** Was employment status recorded for the 162 participants at 12 months in any form: paid
work yes/no, hours, occupational status, or the raw PSP items from which the "social useful
activities including study and work" subscale was scored? The published subscale is a 0–4 rating of
the *severity of problems*, with higher scores meaning more problems, so no proportion employed can
be recovered from what is printed.

**Why it is a weaker query than the others.** Unlike stralin2019 and solmi2022, this is not a case
of a count existing but being reported as a percentage. Nothing counted anyone. Recovery would
require re-scoring individual PSP records, which is a data request rather than a clarification, and
even then the construct would combine paid work with study.

**Second query.** How many patients were referred and diagnosed over the December 2009 to December
2012 recruitment period, before the completer restriction? The sample of 162 is defined by
completion of both assessments, so the denominator of the recruited cohort is not reportable and
`n_entered` cannot be filled.

---

## 6. shimada2022 — no employment measure exists to query

**Query.** Was employment status recorded at the five-year follow-up in any form other than the SFS
employment/occupation subscale score? Table 2 (p. 482) reports means of 4.46 and 2.46 on a 0–10
scale; no participant is classified as employed or not employed anywhere in the report.

**Second query.** Table 1 (p. 479) reports *"Income, n (% yes)"* as 96 (94.12 per cent) of 102. What
counts as income here, and at what timepoint was it recorded? At 94 per cent in a recently
hospitalised inpatient cohort it cannot be employment, and it is not offered as an employment
outcome, so it has not been extracted as one; a definition would confirm that.

**Third query.** The report cites a registration number (UMIN000045509) for the five-year follow-up
but no date and no protocol. When was the follow-up registered relative to the start of follow-up,
and was the SFS employment/occupation subscale a pre-specified outcome?

---

## Cross-cutting note for the authorship group, not an author query

Four of the six reports in this batch print an employment proportion and none of its arithmetic.
Three of those four (`rodriguezpulido2021`, `solmi2022`, `topor2019`) have denominators printed
somewhere in the paper, so a numerator could be reconstructed in each case, and in each case it was
not. That decision is uniform across the batch and is the single largest determinant of what F12
contributes. If the authorship group ever revisits the no-back-calculation rule, these three reports
are the ones the decision would move, and `solmi2022` at 21,551 participants is by far the largest.
The rule was applied as written; this note exists so the size of what it costs is visible rather
than implicit.
