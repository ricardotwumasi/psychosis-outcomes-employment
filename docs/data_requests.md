# Author data requests

The registered protocol commits to this: "Authors will be asked to provide any required data
not available in published reports." This file is the send-ready set of those requests,
rewritten from the Stage F shards on 13 August 2026.

**Status: drafted, not sent.** Nothing in this file is a claim that any message has left the
project. The review team sends; the sent, reminder, response and closure dates are recorded
as event metadata in `data/inclusion_manifest.csv` when the team confirms each one.

## What is in this file and what is deliberately not

Every draft below is **de-identified**. Recipient names and addresses are not here and must
never be committed: this repository is public. The private contact record lives in
`private/contact_log.csv`, which is gitignored, and sent or received correspondence is
likewise prohibited from the repository. The de-identified drafts, by contrast, are an
intended public output: a reader should be able to see exactly what was asked of whom, in
what terms, without learning anyone's email address.

Each draft therefore opens with a bracketed recipient descriptor. The sender fills it from
`private/contact_log.csv`, or looks the corresponding author up in the report itself where
no record exists yet.

## The deadline, and what happens after it

**Responses are requested by 27 August 2026, 23:59 UK time (BST, UTC+1).** The date is
stated in every draft. A reminder goes out on 20 August.

**Late-reply policy.** A reply received after the closure time is logged in the manifest with
its true date and may inform a sensitivity analysis or a correction, but does not enter the
frozen primary inputs. The freeze exists so that the primary estimate cannot be revised in
the light of what arrives after it; a reply that would change a primary input, arriving after
closure, is a finding about the review's timing and is reported as one.

**This policy is the default and is awaiting the user's confirmation.** It is written down
before the drafts leave so that the rule is not chosen once the content of the late reply is
known.

## Request identifiers

Every unresolved conflict and every missing-count item carries a stable identifier
`REQ-<report_id>-<n>`, numbered within the report in the order the items appear here. An
identifier is never reused or renumbered once this file is committed, because the manifest
and the closure record refer to it.

A report that generates no request carries a documented reason instead, in the final section.
Every eligible report is in one list or the other; there is no third state.

The manifest carries only `data_request_status`, `data_request_date` and
`data_response_date`. The substance of every request stays here, so that the request text has
one home and the manifest does not accumulate prose.

---

# 1. Priority group: the three primary-critical requests

These three decide whether a row stays in the provisional twelve-month primary pool. They go
first, they are chased first, and their non-response consequences are fixed below **before
any reply arrives**.

The pool as it stands is k = 3, none of it human-verified: `khare2022b` 53/107,
`khare2021` 287/456, `andersen2024` FEP 205/578, with `mayoralvanson2019` 36/156 one
reversible gate away. Three of those four rows are derived; `mayoralvanson2019` is a reported
result. k can move in either direction, and these requests are a large part of why.

## Prespecified non-response consequences

Written on 13 August 2026, before any reply was received, so that the final decision cannot
depend on the resulting k.

| Report | Field in question | If unanswered at closure |
|---|---|---|
| `andersen2024` | Whether the NEET item's "employment" establishes remuneration | `outcome_construct` is recoded `unclear` under SAP 3.1, which requires `unclear` where remuneration cannot be established. **The row leaves the primary pool.** |
| `khare2021` | Whether the primary denominator is 456 or 459, and whether unwaged family-business workers are counted as paid | The conservative documented choice stands: the denominator remains as extracted and the `paid_any` coding is retained with the family-business caveat carried into the risk-of-bias record and the sensitivity analysis. The row stays, qualified. |
| `mayoralvanson2019` | Whether the 157-person subsample was selected on any employment-related criterion | `analysis_selection_status` stays `unclear`. **The row stays out of the primary pool** and is admitted only to the named sensitivity analysis. |
| `khare2022b` | Whether "employed" requires remuneration in every case, given family-run businesses | The `paid_any` coding stands on the report's own statement that "the focus of the study was on paid employment", with the caveat recorded. The row stays, qualified. |

Two of these consequences remove a row and two retain it. That asymmetry is deliberate and
follows the direction of the underlying rule in each case, not the direction that preserves
k.

## E01. headspace Early Psychosis programme, Australia (`andersen2024`) — PRIMARY-CRITICAL

*Recipient: corresponding author, `andersen2024`.*

- **REQ-andersen2024-1 (primary-critical).** In the NEET item, defined as "not being in
  full- or part-time education and not being in full- or part-time employment", does
  "employment" mean **paid** employment? Specifically, were unpaid work experience, voluntary
  placements or therapeutic allowances counted as "Working"? This bears directly on
  `andersen2024_fep_cohort_t12m_paidany`, 205 of 578.
- **REQ-andersen2024-2.** What was the vocational status of those who left the programme
  before twelve months? 578 of 1,574 entrants have an observed twelve-month status, and the
  report itself gives two arguments pointing in opposite directions about the direction of
  the bias.
- **REQ-andersen2024-3.** Were any participants counted in both the FEP and the UHR cohorts?
  The programme admits ultra-high-risk young people "who do not go on to develop a psychotic
  disorder", which implies some do transition. Whether a transitioning participant is
  re-entered in the FEP cohort decides whether the two cohorts are disjoint.

## E02. Pune cohorts, India (`khare2021`, `khare2022`, `khare2022b`) — PRIMARY-CRITICAL

*Recipient: corresponding author, Pune reports. One email, three reports, two cohorts.*

Note for the sender: `khare2021` is the Pune private-sector cohort and `khare2022`/`khare2022b`
the Pune public-hospital cohort. The review currently treats them as **distinct cohorts** on
the shards' account of different sites and sectors. Confirmation either way is welcome and is
also on the overlap audit queue.

- **REQ-khare2021-1 (primary-critical).** Does "working" require personal remuneration?
  Methods 2.3.2 describes computing monthly income for "participants working in family-run
  businesses who were not paid separate wages" by dividing total family income, and Table 1
  shows 97 of the 257 employed at both assessments worked for family, rising to 83 of 132
  rural participants. Were unwaged family-business workers counted as working, and if so how
  many of the 287?
- **REQ-khare2021-2 (primary-critical).** What is the correct denominator for the
  twelve-month employment figure: 456 or 459? Two students and one volunteer were removed
  from the analysis, and their employment status was observed. Whether the review should
  divide by the observed 459 or the analysed 456 is not settled by the text.
- **REQ-khare2021-3.** Were the site agreement rates of 99.2 per cent and 81.4 per cent
  computed on patients *informed* about the study or on patients *referred to the
  interviewers*? The methods say the number informed "was not tracked".
- **REQ-khare2021-4.** The recruitment window and the calendar dates of the baseline and
  follow-up assessments, which are referred to an earlier report not held here.
- **REQ-khare2021-5.** Supplementary Table 3, comparing the three diagnostic groups, which
  would allow a schizophrenia-spectrum-only proportion to be extracted.
- **REQ-khare2022-1.** Employment counts for the schizophrenia and schizoaffective subgroup.
  The analyses were re-run restricted to that subgroup but only cognition-work associations
  were reported.
- **REQ-khare2022-2.** Confirmation of which denominator the "49.5 per cent at follow-up"
  figure uses: the 150 participants named in the Introduction, or the 107 who completed
  follow-up.
- **REQ-khare2022b-1 (primary-critical).** Does "employed" require remuneration in every
  case? Six to eight per cent of employed participants worked in family-run businesses, and
  whether all of those drew a wage is not stated.
- **REQ-khare2022b-2.** Employment counts by diagnosis. Ninety per cent of the sample carries
  a schizophrenia or schizoaffective diagnosis but no employment count is reported for that
  subgroup.
- **REQ-khare2022b-3.** Supplemental Table 1, comparing the 107 completers with the
  non-completers, which is cited but not in the PDF held.
- **REQ-khare2022b-4.** An exact count, or a confidence interval, for the follow-up
  employment rate printed only as 49.5 per cent.

## E03. PAFIP, Cantabria, Spain (`mayoralvanson2019`, `ayesaarriola2020`) — PRIMARY-CRITICAL

*Recipient: corresponding author or data custodian, PAFIP.*

- **REQ-mayoralvanson2019-1 (primary-critical).** How were the 157 patients chosen? The paper
  says only that "a subsample of 157 patients within PAFIP was selected for the present
  study", and the cross-reference for the criteria is a numeric marker that cannot be resolved
  against the reference list. **Which years does the subsample cover, and on what basis were
  these 157 selected?** An answer of "consecutive PAFIP admissions in years X to Y", or any
  answer establishing that selection was not employment-related, would move
  `analysis_selection_status` from `unclear` to `none`.
- **REQ-mayoralvanson2019-2.** Which denominator does Table 3 use? The baseline row's
  percentages divide by 156 and the one-year row's by 157, while both rows' counts sum to
  156. How many patients had an employment status recorded at each timepoint?
- **REQ-mayoralvanson2019-3.** How is "Employed" defined? Does it include paid sheltered or
  supported work, and does "Temporary disability" remove from the employed count people who
  still hold a job but are on sick leave?
- **REQ-mayoralvanson2019-4.** Which source supplied employment status, and who abstracted it?
- **REQ-ayesaarriola2020-1.** The denominators for Table 1's ten-year rows: how many patients
  had employment status recorded at the 8-to-16-year reassessment? With printed denominators
  this report would supply a `paid_any` numerator by complement at the ten-years-or-more
  horizon.
- **REQ-ayesaarriola2020-2.** Is the ten-year employment variable binary and exhaustive, and
  are students coded unemployed? The complement only yields paid employment if so.
- **REQ-ayesaarriola2020-3.** The mean and distribution of elapsed follow-up. The window is 8
  to 16 years and only "after an average period of 10 years" is given.

---

# 2. The shared email template

Every draft below uses this body. The itemised requests for that group are inserted at
`[ITEMS]`, each as a numbered paragraph carrying its request identifier.

> Dear [recipient descriptor],
>
> We are conducting a systematic review and Bayesian meta-analysis of employment outcomes in
> people living with psychosis, registered on PROSPERO as CRD420251008448. Your study
> [citation] meets our inclusion criteria, and we would be grateful for your help with a small
> number of specific points.
>
> Our primary outcome is the proportion of a cohort in any paid employment at a follow-up
> landmark of at least twelve months. Where a report gives a percentage without a numerator
> and denominator we do not back-calculate the count, because on large denominators the
> rounding error can exceed the sampling error it would replace, and the model would then
> treat a reconstructed number as an observed one.
>
> [ITEMS]
>
> If it is straightforward, we would also welcome separate counts for competitive paid
> employment, paid sheltered or otherwise non-competitive employment, education without paid
> employment, and training without paid employment, each with its own denominator. Please
> indicate whether the categories are mutually exclusive and whether supported jobs were in
> the open labour market. If your published measure is an employment, education or training
> composite, we would gladly retain that exact composite as well as any paid-only split.
>
> We are also checking, for every included study, whether recruitment or the analysed sample
> was conditional on employment status, on wanting or being ready to work, on having an
> employment goal, or on participation in a vocational service or placement. If this is not
> fully described in the report, could you confirm whether any such criterion applied?
>
> **We would be grateful for a reply by 23:59 UK time on 27 August 2026.** We appreciate that
> is a short window. It is the point at which we freeze the inputs to the primary analysis, so
> that our estimate cannot be revised in the light of information arriving afterwards. A later
> reply remains genuinely useful and will be recorded and used in sensitivity analyses, but we
> wanted to be transparent that it would not enter the primary result.
>
> We are happy to acknowledge your contribution and to share the synthesis before submission.
>
> With thanks,
> [sender] on behalf of the review team

---

# 3. The remaining drafts

Grouped by corresponding author or research group. Where one group has several reports, they
are merged into a single email rather than sent separately.

Six reports carry a **dual purpose**: they need both an author request and a documentary
retrieval or a conflict resolution. Each is a single email covering both, marked **[dual]**.

## Hong Kong and China

### E04. Hong Kong EASY programme (`chang2016`, `chan2020`, `chan2019`, `chan2022`, `chang2016b`)

*One group, five reports. Four are eligible evidence the review cannot use for want of a
count.*

- **REQ-chang2016-1.** Does "sustained employment" include full-time students? Methods 2.2
  defines it as maintained full-time work or study, or part-time work; two table footnotes
  define it as full-time or part-time work with no mention of study. Which is the numerator
  behind 111 and 21, and if study is included, how many of each count were in full-time
  education and not in paid work?
- **REQ-chang2016-2.** What is the denominator behind "111 (30.0)"? The column is headed
  n = 374, but 111/374 is 29.7 per cent and 111/370 gives 30.0 per cent, which the printed
  chi-square also reproduces. How many patients in each diagnostic subgroup had employment
  status ascertained at 36 months?
- **REQ-chang2016-3.** Is a whole-sample sustained-employment figure available, and one at 12
  or 24 months? As published, 36 months falls in no landmark band for this review, so a count
  at 12 or 24 months would be usable where the 36-month figure is not.
- **REQ-chang2016-4.** Supplementary Table S1, which is cited but not in the PDF held, or at
  least age, sex and education by subgroup.
- **REQ-chan2020-1.** How many patients were in employment at the ten-year assessment, for
  the early-intervention and standard-care samples separately, with the number observed at
  each of 12 months, 24 months and 10 years? This is the highest-value missing number in the
  group: employment is the paper's stated outcome over ten years in a territory-wide cohort,
  and no count of employed people appears. A count separating paid work from full-time
  education would be particularly valuable, since the paper's own construct excludes supported
  and sheltered work.
- **REQ-chan2020-2.** Six exclusions or five? One page says six were excluded with each group
  then at 145; another gives group changes of 110 to 107 and 104 to 102, which is five.
- **REQ-chan2019-1.** Employment status was collected at the ten-year interview but never
  reported. How many were employed, out of how many recorded? Also, were paid rehabilitation
  placements treated as employed or as unemployed?
- **REQ-chan2022-1.** Any count behind the mean months of employment: the number employed at
  the ten-year interview for the analysed 209, or by relapse group.
- **REQ-chang2016b-1.** How many were in competitive employment at 12 months, by allocated arm
  and overall, with the denominator, separating paid work from studying? Only the composite
  functional-remission figure of 31 of 156 is reported, and this is a twelve-month randomised
  follow-up falling squarely in the primary landmark band.
- **REQ-chang2016b-2.** The trial's recruitment dates and full eligibility criteria, which are
  deferred to a 2015 report not held here. This currently keeps the cohort's
  `employment_selection_status` at `unclear`.

### E05. Hong Kong JCEP (`hui2026`)

- **REQ-hui2026-1.** The number employed and the number whose employment status was observed
  at four years, for the deprived group, the non-deprived group and the two combined. Table 3
  prints only unemployed counts with percentages taken across rather than within groups, so no
  employed count is established. **Please confirm or correct 72 of 112 and 86 of 107**, which
  is what the complement gives if status was observed for everyone; we have not used those
  figures, because the paper's own degrees of freedom show its column headers are not the
  denominator of every variable.
- **REQ-hui2026-2.** What did "employed" count: was part-time, sheltered or supported work, or
  student status, included?
- **REQ-hui2026-3.** Is a whole-cohort figure available? 120 of the 360 randomised were
  excluded from this analysis, so nothing here is a whole recruited cohort.

### E06. Yuli Hospital therapeutic community, Taiwan (`wang2020b`, `wang2020c`)

- **REQ-wang2020b-1** and **REQ-wang2020c-1.** How many participants were employed at each
  annual follow-up, and out of how many? Both reports give employment only as mean cumulative
  work duration and mean cumulative income. A count of participants with more than zero work
  months in each follow-up year would make both reports quantifiable; at present neither
  contributes any outcome row.
- **REQ-wang2020b-2.** Which of 525, 550 and 561 is the recruited total, and how do the two
  samples relate? Neither report cites the other, both recruited "all residents" of the same
  community over the same window with the same diagnostic inclusion, yet the totals differ by
  36.
- **REQ-wang2020c-2.** Do these samples overlap the 655-patient scale-validation sample whose
  shared dataset supplied the initial background data?

### E07. Chinese naturalistic cohort (`liangrong2021`)

- **REQ-liangrong2021-1.** What ends an individual patient's follow-up? Length of follow-up
  runs from 0.2 to 16.8 years with a median of 5.6 and the rule is never stated, so the 170
  employment statuses are measured at unknown and widely differing elapsed times. Employment
  status at a fixed elapsed time would be usable where the present figure is not.
- **REQ-liangrong2021-2.** Were patients both at school and in paid work counted as employed?
  The three categories are mutually exclusive and 52.3 per cent were at school, so part-time
  student employment could be material and invisible in the 70.
- **REQ-liangrong2021-3.** What does "employed" mean here? Remuneration is never mentioned.

### E08. Wuxi supported-employment trial (`zhang2017`)

- **REQ-zhang2017-1.** How many participants dropped out of each arm, and how was employment
  status obtained for them? No attrition figure of any kind is printed for a fifteen-month
  three-arm trial. This is the single field that would most increase what this report
  contributes: the review's intervention model needs an observed denominator and may not
  substitute an intent-to-treat reporting base.
- **REQ-zhang2017-2.** Which test produced the reported p = .002 for the ISE versus IPS
  comparison, and over what window was cumulative employment accumulated? A two-sided
  chi-square on the printed 34 of 54 against 27 of 54 gives about 0.17, while .002 does
  reproduce for ISE against the third arm.

### E09. Chinese first-episode ten-year follow-up (`xu2020`)

- **REQ-xu2020-1.** Was the follow-up conducted as a single interview campaign ending on one
  date? This is the most consequential open question in its batch: the answer decides whether
  the report's only poolable result can be assigned to the ten-year-or-more horizon at all.
- **REQ-xu2020-2.** What does "currently employed" count? Neither remuneration, hours,
  contract status nor labour-market setting is defined, and the question was asked by
  telephone of a proxy informant for most participants.
- **REQ-xu2020-3.** How many of the 53 not interviewed were alive at follow-up? Without this
  the review's complete-cohort bounding analyses cannot be run for this cohort.

### E10. ACT re-employment trial (`luo2019`)

- **REQ-luo2019-1.** Were all participants unemployed at baseline? The outcome is framed
  throughout as *re*-employment and every participant is treated as at risk from day zero,
  but the paper never states it.
- **REQ-luo2019-2.** The operational content of inclusion criteria (4) and (5), "significant
  functional impairment" and "one or more indicators of a need for continuous high level of
  services", which are defined only by reference to a manual and to supplementary materials
  not held. Assertive community treatment admission criteria customarily include inability to
  obtain or maintain employment, which would make this employment-related selection.
- **REQ-luo2019-3.** Employment status *at* twelve months for either arm. Only cumulative
  attainment over the window and mean days worked are given.
- **REQ-luo2019-4.** What is "transitional employment", and was the control arm's single
  re-employed patient competitive or transitional?

## Nordic and Baltic

### E11. JUMP vocational programme, Norway (`gjerdalen2023`, `evensen2017`, `evensen2019`, `lystad2017`, `klungsyr2021`)

*One cohort, five reports, one email.*

- **REQ-gjerdalen2023-1.** The numerator and denominator for competitive employment, work
  placement and sheltered work at the ten-month post-intervention assessment. Ten months is
  the cohort's **only** timepoint inside the primary landmark band, and the figures exist only
  as percentages.
- **REQ-gjerdalen2023-2.** The number alive and register-traceable at five years, and whether
  the two deceased participants are inside the 148.
- **REQ-gjerdalen2023-3.** Which calendar year is "the last calendar year", and was the window
  anchored to each participant's own inclusion date? Inclusion ran from August 2009 to March
  2012, so a single calendar year sits between 4 years 2 months and 5 years 9 months after
  entry depending on when a participant joined.
- **REQ-gjerdalen2023-4.** Arm-level numerators and denominators at post-intervention, two
  years and five years. Both this report and `lystad2017` give the split by allocation group
  as percentages only.
- **REQ-evensen2017-1.** Were the seven unreached participants classified as unemployed at the
  two-year follow-up, or at the end of the intervention period? The sentence says the latter
  but the paragraph and the arithmetic point to the former. Please also confirm 139 as the
  number with observed two-year employment status.
- **REQ-evensen2017-2.** Is any category other than competitive employment remunerated as
  wages? All three defining sources describe work placement and sheltered work as financed by
  welfare schemes rather than by an employer, which under our rules removes both from any paid
  employment. **How many of those in sheltered work received a wage from the sheltered
  enterprise, as distinct from a work assessment allowance or disability pension?** This is the
  question that decides whether the cohort can contribute a paid-employment figure at any
  horizon.
- **REQ-evensen2017-3.** The baseline count in each of the four employment categories, on 148.
  Three mutually inconsistent baseline statements appear across the reports and none carries a
  count.
- **REQ-lystad2017-1.** The counts underlying Figure 3, by group and timepoint. The figure is a
  three-dimensional bar chart with a percentage axis and no data labels.
- **REQ-klungsyr2021-1.** How is "History of unemployment: Yes 20 (15.3%)" defined? The
  variable is never defined and 15.3 per cent is hard to reconcile with a sample in which all
  participants relied on social security benefits and none was competitively employed at
  baseline.

### E12. Danish and Finnish national registers (`hakulinen2019`, `hakulinen2020`)

*Two reports, one author group, one email.*

- **REQ-hakulinen2019-1.** The exact number employed at each age, for the schizophrenia group,
  corresponding to the appendix denominators. The appendix supplies exact denominators and
  not-employed percentages rounded to whole numbers; on a denominator near 9,444 the rounding
  uncertainty is roughly plus or minus 47 against a binomial standard error of about 33, so
  reconstruction would carry more error than the sampling noise it replaces.
- **REQ-hakulinen2019-2.** Is time since first diagnosis available? The outcome is measured at
  fixed chronological ages, so it is not an elapsed follow-up and cannot be assigned to a
  landmark horizon even with exact counts.
- **REQ-hakulinen2019-3.** Can any paid employment during the year be identified separately?
  **The measure is the single most important employment status of the year judged on the main
  source of income, so it is a period-prevalence measure and someone whose main income is a
  disability pension counts as outside the labour market even if they did paid work.** This
  caveat is preserved deliberately: even with exact counts and elapsed time, this report
  contributes to the separate period-prevalence synthesis rather than to the primary
  point-prevalence pool, and the request should be weighed accordingly.
- **REQ-hakulinen2019-4.** Which model produced the Abstract's age-30 odds ratios? None of the
  three matches the corresponding table values.
- **REQ-hakulinen2020-1.** The year-by-year employment counts behind Figure 1. The
  denominators for every year from -10 to +10 are already printed for each group and only the
  diagnosis year's proportions appear as counts. **The numerators alone would give this cohort
  usable results at 12, 24, 60 and 120 months, which would be among the largest single
  contributions to this review at every horizon.**
- **REQ-hakulinen2020-2.** Can employment be given at fixed elapsed intervals from the index
  hospitalisation? The present anchor is the end of each participant's own diagnosis year, so
  even year 1 is an elapsed 12 to 24 months rather than exactly 12.

### E13. Swedish national registers (`solmi2022`) **[dual]**

*Dual purpose: an author request, and the largest single loss in the review if unanswered.*

- **REQ-solmi2022-1.** For each year plotted in Figure 1, how many people contributed to the
  occupational-activity classification? The footnote gives N = 21,551, but accrual ran to 2016
  while linkage ended on 31 December 2016 and median follow-up was 4.8 years, so the whole
  cohort cannot have a year-5 observation.
- **REQ-solmi2022-2.** The **counts** behind the "Employed" series, particularly at one year
  after diagnosis (19.5 per cent) and at five years (25.1 per cent). This is a 21,551-person
  national register cohort with a printed employment figure at exactly the twelve-month
  landmark; answers to these first two items alone would put the largest first-episode cohort
  in the review into the primary evidence base.
- **REQ-solmi2022-3.** The Statistics Sweden income rule by which people were "categorized as
  employed or not employed based on income". The dominance rule for assigning a main activity
  is stated but the underlying employed threshold is not, so the classification cannot be
  reproduced. Is a count in **any** paid employment during each year available, as distinct
  from the main-activity category?
- **REQ-solmi2022-4.** Can the employment percentages be recomputed including the 5,144 people
  already on disability pension at first diagnosis, or their number given per year? As it
  stands the analysed cohort is conditioned on not having permanently reduced work capacity at
  entry, which raises every printed percentage by an unknown amount.
- **REQ-solmi2022-5.** Follow-up is stated to end at disability pension, yet disability pension
  appears in Figure 1 as a rising category reaching 27.3 per cent at year 5. Which at-risk
  definition does the occupational series use?

### E14. Parachute project, Sweden (`stralin2019`)

- **REQ-stralin2019-1.** Does "86 cases (53%) had any income" mean any income **from
  employment**, or any income from any source recorded in the register, which the Methods
  describe as including employment income, sickness benefits and student aid? If the former,
  86 of 161 is a directly reported paid-employment count with a clean register denominator at
  thirteen years. **This is a single-word answer that would promote a preserved count into a
  usable result.**
- **REQ-stralin2019-2.** Can the number in **any** paid employment at year 13 be supplied,
  without the 100,000 SEK threshold? The threshold-defined figure cannot substitute for an
  any-paid count.

### E15. Stockholm County registers (`falk2016`)

- **REQ-falk2016-1.** Crude counts: how many of the 421 men and 335 women had registered
  income from paid employment in 2010, and how many in the baseline year? Only
  age-standardised non-employment rates are reported, and a standardised rate cannot be
  converted into a crude proportion.
- **REQ-falk2016-2.** Is "registered income from paid employment" assessed over the whole
  calendar year, at a fixed date within it, or over some other window?
- **REQ-falk2016-3.** Could the outcome be given at a fixed elapsed interval, for example five
  years after the index diagnosis? Inclusion was in 2005 or 2006 with follow-up in 2010, so
  elapsed follow-up is 4 to 6 years and varies within the cohort.
- **REQ-falk2016-4.** Are the baseline-employed subgroup figures crude or standardised, and
  what are the counts and the size of that group?

### E16. Stockholm ten-year follow-up (`topor2019`)

- **REQ-topor2019-1.** What proportion of the full 364-person working-age follow-up group had
  income from salary at year 10, and what are the counts? Only the two service-contact
  subgroups are reported, covering 212 of the 364; the remaining 152 are never described.
- **REQ-topor2019-2.** The counts behind every cell of Table 3. All twenty cells are
  percentages with no numerators.
- **REQ-topor2019-3.** What does "retired persons" mean where 22 were excluded: old-age pension
  or disability pension? Disability pension is separately tracked *within* the analysed group,
  which suggests the 22 are old-age pensioners and the restriction is an age restriction rather
  than an employment one. A one-line answer would move this cohort's analysis units from the
  sensitivity analysis to the primary gate.
- **REQ-topor2019-4.** Does "salary" include subsidised or sheltered employment, and is there a
  threshold below which salary income was not counted?
- **REQ-topor2019-5.** Is "Year 1" the calendar year in which the diagnosis was set, so that
  "Year 10" is nine rather than ten elapsed years?

### E17. OPUS 2014 and Morpheus (`pedersen2025`)

- **REQ-pedersen2025-1.** How many of the 246 were employed at two and at four years, combined
  across sites? Only arm-level counts are printed and a combined count is not derivable here.
- **REQ-pedersen2025-2.** How many Morpheus patients were employed at Morpheus entry rather
  than at OPUS inclusion? Morpheus began at a median of 183.5 days later, and Table 1 records
  18 of 116 employed at OPUS inclusion under a criterion that excludes employment.
- **REQ-pedersen2025-3.** What did the Aalborg comparison group actually receive? The authors
  note they lacked information on the standard vocational rehabilitation received, which may
  have included supported employment.
- **REQ-pedersen2025-4.** Was the analysis prespecified? Both a point-in-time and an any-time
  version of the employment outcome are reported at both windows with no stated primary.

### E18. Danish DREAM register cohort (`bonnesen2026`)

- **REQ-bonnesen2026-1.** How many were in paid employment alone, without the education
  component? The register distinguishes labour-market contribution and flexible-job benefits
  from state educational grants, so the components are separable in the data but were combined
  into a single reported category. **This is a large, well-ascertained register cohort whose
  loss to the primary pool is entirely a reporting choice.**
- **REQ-bonnesen2026-2.** Why do Table 2's civil-status counts sum to 502 against a printed
  total of 505, and is missing covariate data present but unreported?
- **REQ-bonnesen2026-3.** The mean age of the cohort. Only bands are printed.

### E19. Pooled Danish early-onset psychosis cohorts (`andersen2026`)

- **REQ-andersen2026-1.** How many participants were in any paid employment, including
  supported employment? The register variable groups "social benefits (unemployed/in supported
  employment)" into one category, so paid work is not separable from unemployment; the bounds
  are 49 to 155 of 198. A split of the 106 in that category would identify it.
- **REQ-andersen2026-2.** The four constituent studies' inclusion and exclusion criteria,
  summarised only in a supplementary table not in the article PDF.
- **REQ-andersen2026-3.** Each participant's elapsed follow-up. Follow-up ends at a single
  calendar date, so elapsed follow-up runs from 4.5 to 23.5 years and the reported mean spans
  two landmark bands.

### E20. Helsinki Early Psychosis Study (`lindgren2020`)

- **REQ-lindgren2020-1.** How many were recruited to the study? 67 had baseline cognitive data
  and 54 had both baseline and one-year data, but the recruited cohort size is never printed,
  so the review's bounding analyses cannot be run for this cohort at all.
- **REQ-lindgren2020-2.** The count working, the count studying and the count on sick leave
  from a job at the one-year interview. The reported outcome is a composite that also excludes
  people who hold a job but are signed off, and the definition names the components separately,
  so the underlying data must separate them.
- **REQ-lindgren2020-3.** Is the Table 1 remission row 28 of 53 or 28 of 54? The printed
  percentage implies the latter.

### E21. Northern Finland Birth Cohort 1966 (`majuri2023`)

- **REQ-majuri2023-1.** Is a cross-sectional employment count available at any single age, with
  its denominator, for the schizophrenia and other-psychosis groups? Only latent-class
  trajectory membership over ages 16 to 45 is reported.
- **REQ-majuri2023-2.** Does the "others, mostly unemployed" category at age 46 contain anyone
  in paid work, and if so how many? As printed, zero work is not separable from positive paid
  work, which is why no count could be derived.
- **REQ-majuri2023-3.** Are the life history calendar annual employment roles available as
  counts per year, with denominators?
- **REQ-majuri2023-4.** Why does the schizophrenia-men column of Table 1 sum to 28 when its
  header says 29?

### E22. Finnish 1987 birth cohort (`ringbom2023`)

- **REQ-ringbom2023-1.** Is the schizophrenia and schizoaffective group 86 or 137? Table 1, the
  Results text and the diagnosis breakdown give 86; the Clinical Characteristics section gives
  137. This blocks all five results for that group.
- **REQ-ringbom2023-2.** Is a point prevalence of employment available at any single date, for
  example 31 December 2015 or at age 25? Every outcome is a count of calendar years, so nothing
  is a point prevalence. **A large, register-complete, unselected national cohort at a landmark
  horizon is the most valuable thing this report could supply.**
- **REQ-ringbom2023-3.** Can time since first diagnosis be used instead of age?
- **REQ-ringbom2023-4.** What is the exact cohort flow? The stated exclusions sum to 4,320,
  which would leave 55,156 rather than the 55,171 reported.

### E23. Tallinn first-episode cohort, Estonia (`peebo2022`) **[dual]**

*Dual purpose: the numerators, and the construct definition. Both are needed before any row
from this cohort can be used, and the supplement route has been checked and is not available.*

- **REQ-peebo2022-1.** The numerators behind every employment percentage: counts at 12 and 24
  months on n = 107, and at 12 months on n = 154. No employment numerator appears anywhere in
  the report at any follow-up.
- **REQ-peebo2022-2.** What does "Employment" mean in Tables 2a and 2b? The report says only
  that socio-demographic factors were collected by psychiatrists during interviews. Table 1
  counts students separately from the employed, which suggests paid employment, but that is an
  inference.
- **REQ-peebo2022-3.** Which base produced Table 2b's twelve-month employment figure of 47.7
  per cent? No integer numerator over 154 gives it; the same value appears elsewhere on 107,
  where 51 of 107 does.
- **REQ-peebo2022-4.** Is a point prevalence of employment available at the ten-year follow-up?
  The ten-year outcome is reported only as total duration of employment in months. The tax
  register data behind it would support a point or period prevalence at a stated date, **and
  that would give this review a ten-year result from a region it has almost no evidence
  from.**
- **REQ-peebo2022-5.** Can the treatment-as-usual group's employment be reported as counts?

## United Kingdom and Ireland

### E24. EDEN and the Scottish cohorts (`leighton2019`, `leighton2019b`)

*Two reports, one author group and one named data custodian, one email.*

- **REQ-leighton2019-1.** The full EDEN inclusion and exclusion criteria, given in an appendix
  not part of the PDF held. **This is the cheapest fix available anywhere in the review:** if
  the criteria contain no employment restriction, the cohort moves from `unclear` to `none` for
  every education-and-training synthesis.
- **REQ-leighton2019-2.** Is a paid-employment-only count recoverable for EDEN at twelve
  months, with its denominator? The report gives only the composite, but the study recorded
  "In paid employment at baseline" and "Main income source is salary or wage" as candidate
  predictors, so the underlying data distinguish paid work from education and training.
- **REQ-leighton2019-3.** The baseline characteristics of the EDEN, Scottish and OPUS samples,
  in the same appendix.
- **REQ-leighton2019b-1.** What does the employment, education and training outcome mean
  operationally? Nothing states whether employment must be paid, what hours qualify, whether
  voluntary work counts, or from what source the status was taken. **This affects three cohorts
  across two reports and 495 of the people involved.** The paid-work-only split is the more
  valuable half of the request.
- **REQ-leighton2019b-2.** The eligibility criteria for the 79-patient 2006-2009 cohort, for
  which the article prints none at all.
- **REQ-leighton2019b-3.** Why did 8 of 83 and 12 of 79 participants have no twelve-month
  outcome, and how did they differ?

### E25. EYE-2 cluster-randomised trial (`greenwood2025`)

- **REQ-greenwood2025-1.** The observed employment counts by arm at twelve months: the number
  in any paid employment and the number whose status was observed. The trial reports employment
  only as an adjusted difference in mean days, estimated on multiply-imputed data in the 232 of
  1,027 who consented to the societal interview. **Please also separate paid from unpaid
  employment**, since the reported row combines them and our primary construct is paid work
  only. As the trial is cluster randomised, a cluster-adjusted estimate is needed for any
  pooled comparison, not raw counts alone.
- **REQ-greenwood2025-2.** What does the "probability mean days higher" column report? For the
  employment row that probability is 77 per cent while a normal approximation to the printed
  interval gives about 63 per cent. Are the intervals percentile bootstrap intervals with the
  probabilities the proportion of replicates above zero?

### E26. RADAR trial secondary analysis (`moncrieff2025`)

- **REQ-moncrieff2025-1.** How many participants were in **paid employment**, separately from
  education and training, at 24 months and at baseline? **This is the highest-value request in
  its batch:** this is the only cohort in that batch passing the employment-selection gate as a
  whole recruited cohort at a landmark horizon, and the composite outcome is the only thing
  besides a denominator conflict keeping it out of the primary pool.
- **REQ-moncrieff2025-2.** How many of the 82 relapsers and 171 non-relapsers had a 24-month
  status: 66 and 124, or 58 and 132, or 57 and 132? Table 2, the Results text and Table 4 give
  three different splits of the same 190, and the text percentages reproduce other denominators
  in the same table exactly, so they are not loose rounding.
- **REQ-moncrieff2025-3.** What instrument, question wording or data source recorded
  employment, education and training status, and was the same one used at baseline and at 24
  months?
- **REQ-moncrieff2025-4.** The whole-cohort mean age. Only the two subgroup means are printed.
- **REQ-moncrieff2025-5.** Why does Table 1 print 21 of 80 as 25.3 per cent?

### E27. Oxford AHSN care-cluster cohort (`tsiachristas2016`) **[dual]**

*Dual purpose: a documentary retrieval the team performs, and an author query only the authors
can settle.*

- **REQ-tsiachristas2016-1.** Does online supplementary appendix 1 contain any
  employment-related sample-selection step? **This half is a documentary check, not an author
  query:** the appendix is published with the article and should be retrieved by the review
  team before the email is sent, so that the question is asked only if it remains open.
- **REQ-tsiachristas2016-2.** On which denominator were the probability ratios actually
  computed? The Methods define both outcomes on restricted denominators, while the
  complete-case analysis prints numbers exceeding those who could satisfy the restrictions.
- **REQ-tsiachristas2016-3.** The numerator and denominator for becoming employed, by group. No
  count is printed anywhere in the paper; a single table of counts would convert this report
  from unquantifiable to quantifiable.

### E28. Early intervention service, Australia and UK comparison (`turner2019`)

- **REQ-turner2019-1.** Which of the four participation counts is wrong, and did 8 or 10
  unoccupied participants attain a productive role? Two separate contradictions, both blocking:
  21 + 9 - 4 = 26 against a printed 27, and the Abstract's 10 against the Results' 8. Until
  answered this report contributes nothing to any synthesis.
- **REQ-turner2019-2.** Does "productive role" include training? The construct is written as
  "paid employment or education" where the results are reported and as "paid employment or
  formal education/training" in the data-analysis section.
- **REQ-turner2019-3.** What determined when the follow-up interview happened? Follow-up is
  "18 months (SD 12; range 2-44)" with no stated schedule and no stated common end date.

## Continental Europe

### E29. Italian Network for Research on Psychoses (`mucci2021`) **[dual]**

*Dual purpose: a supplement retrieval that would answer most of the questions, and the author
query that remains if it cannot be obtained.*

**Retrieval first.** Supplement 1 contains the exclusion criteria, the baseline
characteristics and the within-participant comparisons that are the source of the disputed
numbers. **This is the single highest-value retrieval in the review**, and it is behind a
publisher paywall: a team member with institutional access should obtain it before this email
is sent, because it would answer the first three items outright.

- **REQ-mucci2021-1.** What is the denominator for working status at the four-year follow-up?
  The report prints 208 (35.4 per cent) but states the analysis sample as 618, and 208/618 is
  33.7 per cent. Both printed percentages are consistent with a base of 588, which would be the
  number with employment status recorded at both timepoints, as the statistical test used
  requires. **One number resolves this and would make the report quantifiable.**
- **REQ-mucci2021-2.** What does "working status" count? No definition, instrument, threshold
  or ascertainment window is given anywhere in the article. In the Italian context the category
  could include protected or reserved employment, or registration on the disability employment
  lists.
- **REQ-mucci2021-3.** Was employment status observed at a single visit, or over a preceding
  period?
- **REQ-mucci2021-4.** When was the baseline cohort recruited? The dates given are the
  recruitment window of the follow-up study, not of the original cohort.

### E30. Early intervention service, Ferrara (`domenicano2025`)

- **REQ-domenicano2025-1.** Is the 24-month denominator 104, 101 or 102? Three figures appear
  in the Results, in Figure 1 and Table 2, and in Figure 1's own subtraction. Both 24-month
  results are blocked until this is settled.
- **REQ-domenicano2025-2.** Is the twelve-month male NEET count 50 or 25? Table 2 prints 50,
  but the printed total of 35 and the cell's own percentage both require 25.
- **REQ-domenicano2025-3.** What does "employed" mean? The report nowhere defines the variable.
  Does it require remuneration, and does it include sheltered or subsidised placements,
  internships and part-time work? A definition naming paid work would move an otherwise usable
  twelve-month result into the primary pool.
- **REQ-domenicano2025-4.** Student, Employed and NEET sum to 109 of 139 at twelve months and
  85 of 101 at 24 months. Are the remaining participants in training, or is their employment
  status missing?
- **REQ-domenicano2025-5.** Were 219 or 232 patients admitted before the study criteria were
  applied?

### E31. Tenerife cognitive remediation and supported employment trial (`rodriguezpulido2021`)

- **REQ-rodriguezpulido2021-1.** How many participants in each arm obtained at least one job by
  eight months and by twelve months? Only percentages against printed denominators of 23 and 24
  are given. The percentages and denominators would multiply to whole numbers, and we have
  deliberately not done so: a confirmed count is a different object from an arithmetic one.
- **REQ-rodriguezpulido2021-2.** Was any point-prevalence employment figure recorded in
  addition to the cumulative measure, and any figure for **any** paid work rather than
  competitive work only?
- **REQ-rodriguezpulido2021-3.** The stated inclusion criteria admit only certain diagnostic
  codes, yet Table 1 lists 4 participants with personality disorder and 1 with depression among
  the 47 analysed. Which is correct, and is the sample 83 per cent, 74.5 per cent, or "83 per
  cent with schizophrenia or bipolar disorder"?

### E32. Vivantes Berlin IPS trial (`jackel2025`)

- **REQ-jackel2025-1.** Arm-level competitive-employment counts at twelve months, and counts
  for any paid employment including sheltered or supported work, each with its denominator,
  both at twelve months and at any time during follow-up. This is an IPS trial whose stated
  target is competitive employment and it reports no paid-employment-only count for either arm
  at any timepoint; without these it can contribute only to the education-and-training family.
- **REQ-jackel2025-2.** One day or one week? Table 2 labels a row "EET at least one day" while
  the Abstract describes the same counts as EET "for at least 1 week in the follow-up". Both
  results are blocked until this is answered.
- **REQ-jackel2025-3.** How were the education and training subsamples defined, and what are
  the denominators 14 and 18? The text says the subsamples exclude everyone who never received
  education or training, yet the tables report denominators that appear nowhere else.
- **REQ-jackel2025-4.** The corrected diagnostic count in Table 1: the total-sample cell prints
  50 where its own arm counts give 60 and its own percentage also gives 60.

### E33. Lausanne treatment and early intervention programme (`conus2017`)

- **REQ-conus2017-1.** At what elapsed time was each patient's endpoint vocational status
  rated, and how many were rated at or near eighteen months? A distribution, or a restriction
  to patients rated between nine and thirty months, would let this cohort contribute to a
  landmark horizon. **This is the single largest loss in its batch: 661 patients from a
  mandated-catchment epidemiological cohort.**
- **REQ-conus2017-2.** Over what window was the endpoint vocational status rated? The four-week
  qualifier is stated only for the entry rating.
- **REQ-conus2017-3.** How many were in **paid** employment at endpoint? The composite counts
  unpaid employment, students, homemakers and volunteers together with paid work.

### E34. Montreal first-episode cohort (`baltazar2022`)

- **REQ-baltazar2022-1.** Was any of the 43 in supported or sheltered **paid** work at 27 to 31
  years, and is "occupational therapy" unpaid? The derived paid-employment count of 6 of 43
  rests on two readings that follow from the printed counts but are never stated. If some of
  the 8 in occupational therapy were paid, the derivation must be withdrawn.
- **REQ-baltazar2022-2.** The distribution of elapsed follow-up, and whether occupational data
  were collected on one date.

### E35. PEPP Montreal ten-year follow-up (`bhullar2018`)

- **REQ-bhullar2018-1.** How is "Employed" in Table 2 defined, and over what reference period?
  The figure comes from a two-level sociodemographic row with no instrument, definition or
  reference period, in a paper that defines its other vocational measure carefully. If it was
  derived from the same schedule item as occupational activity, the construct changes and the
  cohort loses its only primary-pool-eligible result.
- **REQ-bhullar2018-2.** How many participants engaged in **any** occupational activity, rather
  than 52 weeks of it? The published dichotomy is at 52 of 52 weeks, so the residual band pools
  people with no activity with people active for 1 to 51 weeks.
- **REQ-bhullar2018-3.** The actual distribution of elapsed follow-up, and the programme's own
  admission criteria, which are cited to earlier reports and not reproduced.

### E36. Sao Paulo prevocational cohort (`martini2017`)

- **REQ-martini2017-1.** What is the denominator of the 35.8 per cent: 45, 53 or 44? The
  Results sentence says "of those [45] ... 19 (35.8%)", but 19/45 is 42.2 per cent, 35.8 per
  cent requires 53, and the job-duration percentages on the same page require 44.
- **REQ-martini2017-2.** How many of the 45 were in paid work at the eighteen-month assessment
  itself? The only point-prevalence figure is conditional on having worked at all.
- **REQ-martini2017-3.** How many worked at all, without the 30-day threshold?
- **REQ-martini2017-4.** What happened to the 8 participants who enrolled but were not followed?
  Reasons are given for 4 of the 12 who missed the final evaluation, and those reasons are
  outcome-related.

### E37. Kariya day-care cognitive remediation cohort, Japan (`nakamura2025`)

- **REQ-nakamura2025-1.** How is Type B continuous employment support remunerated for these
  five participants? The report calls it "structured prevocational engagement" not legally
  classified as employment, which is why the five are excluded from paid work; if any held a
  wage relationship the paid-employment numerator changes.
- **REQ-nakamura2025-2.** How was employment status at one year ascertained?
- **REQ-nakamura2025-3.** Was anyone employed at study entry?
- **REQ-nakamura2025-4.** The exact denominator behind the contextual comparison of "~180
  individuals" in the same day care who did not receive the intervention. An exact number would
  give the review a genuine comparison group from the same service.
- **REQ-nakamura2025-5.** The recruitment years, which are never stated.

### E38. Japanese IPS trial (`yamaguchi2020`) **[dual]**

*Dual purpose: a documentary retrieval and, only if it fails, an author query.*

- **REQ-yamaguchi2020-1.** Why were 42 of the 93 eligible clients not analysed? The flow
  diagram is in an online supplement not held here. **This is a documentary retrieval first:**
  the supplement is published with the article. If the 42 were non-consenters or dropouts this
  is ordinary attrition; if any were excluded on an employment-related basis, the analysed
  sample is employment-selected and the result moves out of the primary gate.

### E39. Japanese five-year follow-up (`shimada2022`)

- **REQ-shimada2022-1.** Was employment status recorded at the five-year follow-up in any form
  other than the social functioning subscale score? No participant is classified as employed or
  not employed anywhere in the report.
- **REQ-shimada2022-2.** What counts as "Income, n (% yes)" at 96 of 102, and at what timepoint
  was it recorded? At 94 per cent in a recently hospitalised cohort it cannot be employment.
- **REQ-shimada2022-3.** When was the five-year follow-up registered relative to the start of
  follow-up, and was the employment subscale a prespecified outcome?

### E40. Dutch first-episode cohort (`stouten2019`)

*Weaker than the others, and recorded as such: this is not a count reported as a percentage. Nothing counted anyone, so recovery would require re-scoring individual records.*

- **REQ-stouten2019-1.** Was employment status recorded for the 162 participants at twelve
  months in any form: paid work yes or no, hours, occupational status, or the raw scale items
  from which the "socially useful activities including study and work" subscale was scored?
- **REQ-stouten2019-2.** How many patients were referred and diagnosed over the recruitment
  period, before the completer restriction? The sample is defined by completion of both
  assessments, so the recruited denominator is not reportable.

## United States

### E41. US Veterans Health Administration (`benson2022`, `lin2022`)

*Two reports, one corresponding author, one email.*

- **REQ-benson2022-1.** Is the relapse-cohort full-time employment figure the count 577 or the
  percentage 5.4? The six counts sum to exactly 16,862 and the other five percentages each
  check out, so 577 looks correct and 5.4 looks like a cell copied from the adjacent column,
  but the review cannot resolve a published self-contradiction by its own arithmetic. **A reply
  of "the counts are correct" would unblock 929 of 16,311.**
- **REQ-benson2022-2.** When was employment status measured? The outcome uses "the most recent
  nonmissing data during the study period", the period includes a twelve-month pre-index
  baseline, and no temporality was applied between exposure and outcome. Could the distribution
  of the interval between index date and employment record be given, or the outcome restricted
  to records after the index date?
- **REQ-benson2022-3.** What do the six employment categories mean? None is defined, and the
  source field is updated only twice a year. Is "unemployed" actively seeking work or simply
  not employed, and are people on disability compensation coded unemployed or retired?
- **REQ-benson2022-4.** Is the sex variable exhaustive? Only "Male, n (%)" is printed.
- **REQ-benson2022-5.** The employment-status distribution for the whole 119,343-veteran
  schizophrenia cohort, before relapse stratification and propensity matching. **That, and only
  that, would give this cohort a whole-cohort result eligible for the primary estimand.**
- **REQ-lin2022-1.** The count and denominator behind Figure 2a's 69.2 per cent unemployed for
  the schizophrenia cohort.
- **REQ-lin2022-2.** Does that percentage divide by the full matched cohort of 102,207 or by
  those with a non-missing employment record? The sibling report divides by the full cohort and
  reports 3.3 per cent missing on the same field; this report reports no missing category at
  all.
- **REQ-lin2022-3.** The full employment-status distribution for the 102,207, as reported for
  the 16,862 in the sibling paper. **That would turn this report from unquantifiable into a
  whole-cohort result on the largest sample in its batch.** The complement of 69.2 per cent is
  not employment, because retired and missing veterans would be counted as employed.
- **REQ-lin2022-4.** Three of the five printed standardised mean differences cannot be
  reproduced from the printed percentages. Which figures are correct?

### E42. OnTrackNY (`nossel2018`, `basaraba2023`)

*Two reports, one programme, one email.*

**Framing note for the sender, and a correction to how this was previously described.**
`basaraba2023`'s eight extracted rows are all subgroup rows, so this is not a request for a
subgroup breakdown. **What is wanted is the whole-cohort twelve-month paid-employment count**,
which is the thing the review can actually use and the thing the report does not print.

- **REQ-basaraba2023-1.** Could the **paid-employment component alone** be reported at twelve
  and 24 months, on the same denominators, for the **whole cohort**? The published outcome is a
  single composite of education, vocational training and any paid employment, so no
  paid-employment numerator is recoverable at any of the eight timepoints. The underlying
  programme form records work and school separately, as the sibling report shows, so the data
  exist. **This would give the cohort a usable result at both the twelve- and 24-month
  landmarks and is the largest single recovery available in its batch.**
- **REQ-basaraba2023-2.** The holdout counts, or the whole-sample counts. Rates are given for
  the training and cross-validation split only, 1,038 of 1,298, with the holdout described as
  showing "similar distributions" and no counts.
- **REQ-basaraba2023-3.** How was the holdout drawn? The methods describing the split were not
  available with the PDF held. It is stated to be about 20 per cent and the training set spans
  19 of 20 sites, which suggests it is not purely at random.
- **REQ-nossel2018-1.** The three-way counts of employed only, in school only, and both, with
  the denominator, at nine and twelve months. These are given at admission and six months but
  at twelve months only a model-estimated adjusted prevalence of the composite appears.
  **This would give the cohort a paid-employment result in the primary landmark window, which
  it currently lacks entirely.**
- **REQ-nossel2018-2.** Is employment at the assessments current status on the day, or any work
  in the preceding quarter? Only the admission window is stated.
- **REQ-nossel2018-3.** Is the six-month denominator 260, 261 or 262?

### E43. Connecticut dual-diagnosis cohort (`drake2015`) **[dual]**

*Dual purpose: two blocking conflicts and a whole-cohort request, in one email.*

- **REQ-drake2015-1.** What denominator produced each printed employment percentage? Table 3
  prints 27 (28 per cent) at year 7 over a column N of 90, but 27/90 is 30 per cent, and no
  cell of that row reconciles with its column N at any of the eight timepoints; at years 4 to 7
  the implied denominators exceed the number interviewed. There is a numerator and no
  denominator, at every timepoint.
- **REQ-drake2015-2.** Is the ascertainment window "at least 1 day in the past 6 months" as the
  Measures section says, or "past y" as Table 3 says?
- **REQ-drake2015-3.** Are the same outcomes available for all 198 enrolled? Results are given
  only for the 150 with schizophrenia or schizoaffective disorder, and **the 198 is the whole
  recruited cohort and would be eligible for the primary estimand where the diagnostic subgroup
  is not.**
- **REQ-drake2015-4.** Was current employment recorded at each annual interview as well as "any
  competitive job in the period"? A point-prevalence count would be a different estimand from
  the period measure.
- **REQ-drake2015-5.** Did any participant in this Connecticut sample also enter the Hartford
  supported-employment trial run in the same city and period by overlapping investigators? This
  is an overlap question, not a nicety.

### E44. Employment Intervention Demonstration Program (`cook2016`)

- **REQ-cook2016-1.** The four numerators behind "worked at all" (72 versus 63 per cent) and
  "achieving competitive employment" (56 versus 36 per cent) for the supported-employment and
  control groups, and confirmation that the denominators are the 234 and 215 shown in Table 1.
  Four results currently carry a blank numerator.
- **REQ-cook2016-2.** The yearly numerators and denominators behind Figure 1, which plots the
  percentage with any earned income for each calendar year 2000 to 2012 with no counts. This
  would convert an unusable figure into up to thirteen results.
- **REQ-cook2016-3.** The distribution of elapsed time from each participant's own baseline to
  the start and end of the fixed 2000-2012 outcome window.
- **REQ-cook2016-4.** Which six of the eight programme sites joined the supplemental study?
  This determines whether the Hartford participants in another included report are inside these
  449, which is a cohort-overlap question.
- **REQ-cook2016-5.** What instrument established the diagnosis, and who applied it?

### E45. Hartford IPS trial (`detore2019`)

- **REQ-detore2019-1.** The equivalent two-year counts for the clubhouse and standard
  vocational-rehabilitation arms. 204 were randomised across three arms but only the IPS arm's
  51 of 68 is given, so no within-study contrast can be formed.
- **REQ-detore2019-2.** The age, sex, education and diagnostic composition of the full allocated
  arm and of the 204 randomised. Table 1 describes only the 51 who obtained work.
- **REQ-detore2019-3.** Did any of the 68 withdraw before the two years elapsed? The 17 counted
  as not obtaining competitive work are treated as observed non-attainers, which the report does
  not establish.
- **REQ-detore2019-4.** The recruitment years for the parent trial.
- **REQ-detore2019-5.** Was employment status recorded at fixed timepoints as well as
  cumulatively? A point-prevalence count at twelve or 24 months would be a more useful estimand.

### E46. RAISE-ETP (`fulford2018`)

- **REQ-fulford2018-1.** The numerators and per-timepoint denominators behind the work-or-school
  variable, reported as 39.8, 71.8 and 66.6 per cent with only a range of Ns across all
  variables.
- **REQ-fulford2018-2.** Is the reported value the proportion of participants scoring positive
  at the assessment, or the mean of a score averaged over several monthly ratings? 39.8 per cent
  is not n/404 for any integer n, which suggests the latter, and that would make it a different
  quantity from a prevalence.
- **REQ-fulford2018-3.** Can the paid-work items be reported separately from the student item?
  **That would give a paid-employment result at twelve months for a large first-episode cohort,
  which the composite cannot.**
- **REQ-fulford2018-4.** Is a design effect or intracluster correlation available for this
  outcome, and are arm-specific values available? The trial randomised 34 sites.
- **REQ-fulford2018-5.** Did the experimental programme include supported employment and
  education? This report does not describe the intervention components, which is the sole
  reason a trial safeguard is recorded as `unclear`.

### E47. Suffolk County Mental Health Project (`strassnig2017`, `strassnig2018`) **[dual]**

*Dual purpose: a blocking conflict in one report and a confirmation in the other, one cohort,
one email.*

- **REQ-strassnig2017-1.** What are the gainful employment counts and denominators in Table 1?
  The table prints 60 (20.6 per cent) of 80 and 23 (53.4 per cent) of 48; neither count
  reproduces its percentage, the counts give 64.8 per cent against the text's 32.9 per cent, and
  the Discussion's "66/80 ... both unemployed and living dependently" is compatible with
  neither. Without the counts no numerator is recoverable and the result stays blocked.
- **REQ-strassnig2017-2.** Was the analysis sample 122 or 128? The Abstract says 122 and the
  Results say 128, and this is also the base of the only employment figure the report gives.
- **REQ-strassnig2017-3.** How many of the recruited first-admission cohort were assessed at 20
  years, and how many were alive and eligible? Neither report prints a flow.
- **REQ-strassnig2018-1.** Please confirm the employed counts and percentages in Table 1. We
  read the counts as correct (36 of 146 and 46 of 87) because the percentages printed one row
  above are exactly those fractions, but confirmation would convert a resolution resting on our
  arithmetic into one resting on your authority.
- **REQ-strassnig2018-2.** How were the chi-square statistics in Table 1 computed? The printed
  values do not reproduce from the printed counts or from any alternative reading.
- **REQ-strassnig2018-3.** Was employment status observed for all 146 and all 87? Other rows of
  the same table carry degrees of freedom implying missing data.

### E48. NIMH intramural follow-up (`blackman2025`)

- **REQ-blackman2025-1.** How many people were approached, and how many with baseline data
  could not be traced? The source sample size is never given, so no response rate can be
  computed for this cohort at all.
- **REQ-blackman2025-2.** Were all 124 recontacted within one campaign, and what were the actual
  recontact dates? The interval is 8.6 years on average with a range of 2 to 19.
- **REQ-blackman2025-3.** Were the four "retired" participants and the one whose status could
  not be determined excluded from the analysed denominator, and on what basis? Removing retirees
  raises the reported proportion, and whether that counts as an employment-related analytic
  restriction is a judgement we would rather make with your description than without it.

### E49. Chicago Follow-up Study (`harrow2017`, `jones2024`)

*One cohort, two reports, one email.*

- **REQ-harrow2017-1.** How many were in **paid** work, separately from carers and students?
  The scored variable counts paid work at half-time or more, unpaid care of dependents, and
  half-time or more school attendance all as "working", so no paid-employment count is
  recoverable at any wave.
- **REQ-harrow2017-2.** The per-wave counts, in supplemental tables cited but not in the PDF
  held. Only the twenty-year counts appear in the running text.
- **REQ-harrow2017-3.** A whole-cohort figure: no count is given for the 139, for the 70 with
  schizophrenia as a whole, or for the 69 with mood disorders, whose work is reported only as
  "over 60% ... at each of the 6 followup assessments" with no denominators.
- **REQ-harrow2017-4.** The recruitment window, which neither report gives.
- **REQ-jones2024-1.** The number working at least half the time by wave, ideally for the whole
  n = 256 rather than by latent class. The model's outcome is an explicit binary, so counts
  exist behind it but none is printed.
- **REQ-jones2024-2.** The extent of missing data in Table 1, which is unquantified throughout.

### E50. Brooklyn thinking skills for work trial (`mcgurk2016`)

- **REQ-mcgurk2016-1.** Is the enhanced-vocational-rehabilitation denominator 26 or 25? Table 3
  prints "12/26" beside "48%", and 12/26 is 46.15 per cent while 12/25 is exactly 48.00 per
  cent; Table 1's work-history rows for that arm sum to 25.
- **REQ-mcgurk2016-2.** How are the Discussion's 54 per cent competitive and 67 per cent any
  work activity derived? The table counts give 51.9 and 63.0 per cent, and no whole number of
  participants on a denominator of 54 produces either printed figure.
- **REQ-mcgurk2016-3.** How many participants were in paid work at a fixed timepoint, for
  example at twelve, eighteen or 36 months? All three reported outcomes are cumulative over the
  whole three years, so none can enter a point-prevalence synthesis, and weekly work tracking
  was collected so a point-prevalence count should be recoverable.
- **REQ-mcgurk2016-4.** Did tracking loss differ by arm? Employment information fell from 54
  participants to 42 over the three years, the arm split is not given, and Table 3 uses the full
  randomised denominators.
- **REQ-mcgurk2016-5.** Was the trial registered, and is a protocol available?

### E51. Indianapolis vocational trial (`mervis2017`)

- **REQ-mervis2017-1.** Does "in supported employment" mean holding a paid job, or being
  enrolled in a supported employment service? **This is the question that decides the
  construct.** The methods use "enrolled in supported employment" and the results "went on to
  secure supported employment" for the same participants.
- **REQ-mervis2017-2.** Were the participants in supported employment being paid, and at what
  rate? The only wage in the paper is for the four-month work therapy placement that **both**
  arms received as a condition of entry.
- **REQ-mervis2017-3.** Was the outcome status at the twelve-month assessment, or ever during
  follow-up?
- **REQ-mervis2017-4.** Where were participants recruited? The report names one institution
  while the author affiliations point to another, which decides the cohort's setting and,
  more importantly, whether this sample could overlap another included report.
- **REQ-mervis2017-5.** What are the correct analysis-of-covariance degrees of freedom, and why
  are the arms 29 and 35? F(1, 84) is impossible for 64 randomised participants.

### E52. VA vocational rehabilitation trial (`bell2018`)

- **REQ-bell2018-1.** Is the twelve-month competitive-employment denominator for the combined
  arm 38 or 30? The text gives 9 of 38, both tables give 30, and retention gives 27, while the
  comparator arm is denominated on 36 throughout. The result is blocked until this is answered.
- **REQ-bell2018-2.** How many participants were in **any** paid work, including the incentive
  and compensated work therapy placements, at twelve months? Both of those are paid, so any
  paid employment exceeds the competitive count, but only means of hours and earnings are
  reported.
- **REQ-bell2018-3.** Was employment status at baseline zero or 32? The text says all
  participants were unemployed while an exhaustive baseline partition places 32 of 77 in paid
  placements or casual work.

## Australia

### E53. EPPIC IPS trial, Melbourne (`killackey2019`, `clarke2023`)

*One trial, two reports, one email.*

- **REQ-killackey2019-1.** The numerator and denominator per arm at 6-12 and 12-18 months. The
  trial measured employment over three intervals and reports counts for the first only; for the
  two later intervals, which fall in the twelve- and 24-month landmark bands, it prints only
  odds-ratio p-values and predicted probabilities.
- **REQ-killackey2019-2.** Was the employment definition restricted to the open labour market?
  The definition fixes a wage floor but never states the labour-market setting, and the word
  "competitive" never appears. Could supported-wage, sheltered or disability-enterprise
  placements have counted?
- **REQ-killackey2019-3.** Which arm did the two participants who "withdrew participation as a
  result of having employment" belong to? This is outcome-dependent missingness and its
  direction cannot be signed without the allocation.
- **REQ-killackey2019-4.** The calendar years of recruitment, given only as "a 3-year period".
- **REQ-killackey2019-5.** Supplementary Figures 1 to 3, cited but not in the PDF held.
- **REQ-clarke2023-1.** How was "currently in paid work" defined? No hours threshold, wage
  floor, reference period or verification is stated. Was it the parent trial's minimum-wage
  measure, and was it point-in-time?
- **REQ-clarke2023-2.** Appendix 3, comparing the 100 completers with the 45 non-completers,
  cited but not in the PDF held.
- **REQ-clarke2023-3.** Which base does Table 1's baseline column use? It is headed N = 145 but
  three of its percentages reproduce only on 146.

### E54. EPPIC Melbourne discharge cohort (`maguire2021`)

- **REQ-maguire2021-1.** Is the migrant work-or-study count 137? Table 3 prints 137 and 46.8 per
  cent while the Results text prints 47.3 per cent, and 137/293 is 46.76 per cent. This blocks
  both the subgroup and the whole-cohort rows.
- **REQ-maguire2021-2.** Can paid employment be separated from study at discharge? The composite
  is "being an engaged student or having regular employment" and no paid-only numerator appears
  anywhere, so without it the report contributes nothing to the primary construct.
- **REQ-maguire2021-3.** What does "regular employment" mean? No hours, contract type or pay
  threshold is given.
- **REQ-maguire2021-4.** For how many of the 1,196 was occupation at discharge actually
  recorded? Other rows of the same table print reduced denominators.
- **REQ-maguire2021-5.** The median elapsed time from registration to discharge for the whole
  cohort, and the denominator of the baseline employment block in Table 1, whose counts sum to
  1,183 rather than 1,196.

### E55. St Vincent's IPS programme (`petrakis2019`)

- **REQ-petrakis2019-1.** How many of the 63 with an employment outcome were in **paid** work?
  The 92 underlying placements include volunteer and unpaid work experience positions, and
  because one table counts placements and another counts people, the person-level paid share is
  not recoverable.
- **REQ-petrakis2019-2.** How many of the 8 with a non-competitive placement were paid? Social
  firm, transitional and sheltered placements are typically paid; volunteer and unpaid work
  experience are not.
- **REQ-petrakis2019-3.** What was each participant's engagement period, or better, a count
  employed at twelve months from entry? Individual engagement periods are never reported and
  everyone's participation ended at once when funding changed, so elapsed follow-up varies from
  days to 84 months.
- **REQ-petrakis2019-4.** How many participants were employed at programme entry?
- **REQ-petrakis2019-5.** Is "15 of 126" or "15 of 136" correct for completed tertiary study?

## Southeast Asia

### E56. Bangkok community cohort (`jirapramukpitak2022`)

- **REQ-jirapramukpitak2022-1.** How many of the community-identified participants met criteria
  for a psychotic disorder, and was any diagnostic confirmation made? 277 of the 551 recruited,
  about 50.5 per cent, came from medical records with a treated diagnosis; the other 274 were
  found by community key informants using a screening questionnaire. **The review's diagnosis
  threshold is 50 per cent with a stated diagnostic criterion, so this cohort sits within a
  percentage point of the gate and the answer decides its eligibility.**
- **REQ-jirapramukpitak2022-2.** The 42 participants missing from one baseline row, whose base
  is 507 rather than 549, unannounced. Does the same missingness affect any other variable? It
  does not affect employment, but it shows the tables carry unstated per-variable missingness.

## Pilot reports

The fifteen-report pilot was extracted before Stage F and its requests were never written up
in this form. Five of its reports carry an unresolved conflict or an unstated denominator and
are drafted here on the same terms as the rest.

### E57. Croatian outpatient cohort (`mihaljevicpeles2016`)

- **REQ-mihaljevicpeles2016-1.** Is the employment denominator 257 or 205? The Abstract gives
  77 of 257 and the Results give 77 of 205 after excluding 71 pensioners. Both cannot be right,
  and the result is blocked as an unresolved conflict until an author says which.
- **REQ-mihaljevicpeles2016-2.** On what basis were the 71 pensioners excluded from the
  analysed denominator: old-age pension, disability pension, or both? Excluding people who
  cannot be employed raises the reported proportion, and whether that is an employment-related
  analytic restriction turns on the answer.

### E58. Bologna first-episode cohort (`tarricone2017`)

- **REQ-tarricone2017-1.** Is the twelve-month employment figure 46 per cent of the total or 53
  per cent of 135? The paper states both, and 75 of 163 reproduces neither exactly. What is the
  numerator, and what is the denominator of participants whose employment status was observed
  at twelve months?

### E59. Scottish forensic cohort (`darjee2017`, `thomson2023`)

*One cohort, two reports, one email.*

- **REQ-darjee2017-1.** What is the denominator for the employment figure? One participant is
  recorded in supported work and the denominator is never stated, so no proportion can be
  formed.
- **REQ-thomson2023-1.** What is the denominator at the twenty-year follow-up, and how many
  participants had employment status observed? No paid employment is recorded at twenty years
  and the denominator is not printed, so a genuine zero cannot be distinguished from an absent
  measurement. **A zero with a stated denominator is usable evidence; a zero without one is
  not.**

### E60. New Zealand national cohort (`cunningham2025`)

- **REQ-cunningham2025-1.** Are unrounded counts available for the employment figures, or the
  exact rounding rule and its base? The published counts are randomly rounded to base 3 by the
  national statistics agency, which is a disclosure control rather than a measurement, and the
  review needs to know the induced uncertainty before treating 744 of 2,193 as an observed
  count.

### E61. `twumasi2026` (co-authored by the review team)

*Handled as an internal query, not an external one. The report is co-authored by a member of
this review team, so this is not an arm's-length author request and is recorded separately so
that the distinction is visible. Under the verification plan `twumasi2026` is checked by a
named non-author.*

- **REQ-twumasi2026-1.** The employment numerator and its denominator at the reported
  timepoint. The stated 69.1 per cent against 38,160 implies a denominator that is not printed.
- **REQ-twumasi2026-2.** Can paid employment be separated from the education and training
  composite? As reported, the outcome cannot enter the primary paid-employment pool.

---

# 4. Reports where no request is made, with the reason

Every eligible report not appearing above is here. No report is silently absent.

| Report | Reason no request is made |
|---|---|
| `brown2022` | Off the screening list under D10.1 and not read. Its cohort is covered by `andersen2024`, which is requested at E01. |
| `wang2020` | A redundant download of `wang2020b` under the same DOI with byte-identical content, and off the screening list. No separate study exists to ask about. |
| `chang2016b` (cohort structure) | The cohort-overlap question between the two EASY samples is a review-team adjudication, not an author query, and is on the overlap audit queue. The report's own data requests are at E04. |
| `hansen2024`, `hansen2024b` | Pilot reports of the OPUS 1998 cohort with counts already extracted and no unresolved conflict. Any residual question is a verification task, not a request. |
| `benson2022` derived-count check | The independent arithmetic check on the derived rows is a Stage G human verification task, not something to ask an author. |
| `evensen2019` | A linked report of the JUMP cohort contributing the cumulative-attainment result only, on the 69 who consented to register extraction. Every open question about this cohort is asked once, of the same group, at E11. |
| `chen2023` | Counts and denominators complete, no unresolved conflict. Its whole sample was in vocational training by design, which is a pool-eligibility question for the review to settle, not a question for the author. |
| `christensen2019` | Counts complete, no unresolved conflict. Its selection on expressed desire for competitive employment is recorded and decides eligibility without an author's help. |
| `dayabandara2026` | Counts and denominators complete at twelve months for both parallel cohorts, no unresolved conflict. |
| `fowler2019` | Counts complete. The zero-event cell is a genuine observed zero with a stated denominator, which is usable as it stands. |
| `lin2026` | Resolved from the supplement, which supplies observed-case counts at every visit. Nothing remains to ask. |
| `majuri2021` | Counts complete. Its denominator restricted to those already on disability pension is a recorded analytic restriction the review acts on itself. |
| `rautio2016` | Counts complete, no unresolved conflict. The zero-event cells carry stated denominators. |
| All schema and vocabulary items | Every `[schema]` item in the shards is addressed to the review's own authorship group and is tracked in `docs/methods_deviations.md`, not sent to any external author. |

## Retrievals the team performs rather than requests

These are published materials that should be obtained before the corresponding email is sent,
so that a question is asked only if it survives the retrieval.

| Item | Where it belongs |
|---|---|
| `mucci2021` Supplement 1 (paywalled; needs institutional access) | E29, would answer three of four items |
| `tsiachristas2016` online supplementary appendix 1 | E27, item 1 |
| `yamaguchi2020` online supplement flow diagram | E38, the whole request |
| `hakulinen2019` online appendix tables 1 to 3 | E12; retrievable, and the request should name exact rows |
| `leighton2019b` S1 File (freely available) | E24, item REQ-leighton2019b-2 |
| `jirapramukpitak2022` Additional file 1 | Already re-retrieved during extraction and logged in `data/supplement_provenance.csv` |

---

# 5. Recording the outcome

Request state lives in `data/inclusion_manifest.csv`, in three fields and nowhere else:

- `data_request_status`: `drafted`, `sent`, `responded`, `no_response`, `withdrawn` or
  `not_requested`.
- `data_request_date`: the date the team confirms the request was sent.
- `data_response_date`: the date a reply was received.

**Dates are event metadata, recorded when the team confirms the event.** This file never
asserts that a message was sent; it says what was drafted. The status of every report is
`drafted` or `not_requested` until someone confirms otherwise.

At closure on 27 August every request identifier must resolve to a response, a non-response or
a withdrawal, with no identifier left open. A report whose authors decline or do not reply
keeps its extracted state, and the count of such reports is reported in the PRISMA flow and in
the missing-evidence assessment. Reports lost for want of a numerator are a form of missing
evidence and are treated as one, not quietly dropped.
