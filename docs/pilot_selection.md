# Pilot selection

**Purpose:** engineering validation of the extraction schema, the validators and the modelling pipeline. **Not** an estimate of anything.

Every output table from this pilot carries `sample_status = "PURPOSIVE PILOT - NOT FOR INFERENCE"`. No pooled employment rate and no moderator estimate from these 15 reports may be quoted in a slide, a draft, a grant report or a manuscript.

---

## A limitation to state plainly

The feasibility review asked that pilot reports be selected "without reference to their outcome values". That was not fully achievable in the order the work ran. The Stage 1 evidence reconciliation required reading all 93 reports to map cohorts and adjudicate eligibility, and that pass surfaced headline employment figures. Selection below was made on **design characteristics only**, and no report was chosen or rejected because of the size of its employment rate. But the extractor had prior sight of some headline numbers, so this is not a blinded selection and the pilot is one degree further from being inferential than originally intended.

Recording this is cheaper than pretending otherwise. It is a further reason the pilot estimate is unquotable, not a reason to redo the reconciliation.

---

## What the pilot must exercise

The schema is the deliverable. A pilot of well-behaved studies would validate nothing, so the 15 were chosen to break things:

| Hard case | Why it matters | Reports |
|---|---|---|
| Several reports of one cohort | The result-selection rule and the cohort random effect are the main structural changes in this plan; if they fail, the whole analysis is pseudo-replicated | `hansen2024` + `hansen2024b` (OPUS), `rautio2016` + `majuri2021` (NFBC 1966), `darjee2017` + `thomson2023` (Carstairs) |
| Zero events | The exact binomial likelihood exists for this; a normal approximation with a continuity correction would fail here | `thomson2023` (no paid employment at all at 20 years), `darjee2017` (1 in supported work), `fowler2019` (0 of 24 in one arm) |
| Trial arms | Must be kept out of the prevalence intercept and routed to the intervention synthesis | `christensen2019` (3-arm IPS RCT), `fowler2019` (ISREP) |
| Several timepoints in one report | Tests horizon banding and the landmark rule | `lin2026` (months 3, 6, 9, 12, 15, 18) |
| Several outcome constructs in one arm | Tests one-row-per-result rather than one categorical column | `chen2023` (supported, paid sheltered, unpaid training) |
| Administrative register | Tests the `registry` setting and the period-prevalence exclusion | `twumasi2026`, `cunningham2025`, `hansen2024` |
| Internally inconsistent published numbers | Tests that the validator catches what a reader would miss | `tarricone2017` (46 per cent of total vs 53 per cent of 135), `mihaljevicpeles2016` (77/257 vs 77/205) |
| Non-European, non-Anglophone setting | Guards against a pipeline that only works on Nordic registers | `dayabandara2026` (Sri Lanka), `chen2023` (Taiwan), `lin2026` (Asia-Pacific) |
| Rounded or perturbed counts | Statistics New Zealand randomly rounds all IDI counts to base 3 | `cunningham2025` |
| Conflict of interest | Tests that a COI flag travels with the record | `twumasi2026` |
| Composite employment-or-education | Must be routed to the secondary construct, not the primary | `twumasi2026`, `cunningham2025` |

## The 15

| # | report_id | Cohort | Why chosen |
|---|---|---|---|
| 1 | `hansen2024` | `opus_1998` | Multi-report cohort; period prevalence; 20-year horizon; register outcome |
| 2 | `hansen2024b` | `opus_1998` | Same cohort as 1: forces the result-selection rule to fire |
| 3 | `rautio2016` | `nfbc1966` | Multi-report cohort; zero-event cells; period prevalence |
| 4 | `majuri2021` | `nfbc1966` | Same cohort as 3; denominator restricted to people already on disability pension |
| 5 | `thomson2023` | `carstairs_1992` | Zero events for paid employment; denominator not stated |
| 6 | `darjee2017` | `carstairs_1992` | Same cohort as 5; near-zero events; forensic setting |
| 7 | `fowler2019` | `isrep_rct` | RCT with a zero-event arm; routes to the intervention synthesis |
| 8 | `christensen2019` | `ips_denmark_rct` | Three-arm RCT; work-seeking baseline selection; mixed SMI |
| 9 | `cunningham2025` | `nz_idi` | Register; counts randomly rounded to base 3; ethnicity subgroups |
| 10 | `twumasi2026` | `dk_registers_1998` | Register; very large N; composite construct; **COI, guarantor's own study** |
| 11 | `tarricone2017` | `bologna_fep` | Published numbers internally inconsistent |
| 12 | `mihaljevicpeles2016` | `croatia_rlai` | Denominator conflict between abstract and results |
| 13 | `dayabandara2026` | `nhsl_colombo` | Sri Lanka; two parallel cohorts in one report |
| 14 | `chen2023` | `kaisyuan_taiwan` | Taiwan; three employment constructs; whole sample in vocational training |
| 15 | `lin2026` | `pp1m_asiapac` | Six timepoints; counts recovered from a supplement; completer denominators |

Six cohorts are represented twice by design, so the pilot has roughly 12 distinct cohorts. That is deliberate: the duplication is the thing being tested.

## Conflict of interest

`twumasi2026` is a report by the review's guarantor. It is included in the pilot with a COI flag on the record. **A co-author who is not an author of that paper must independently verify its extraction and complete its risk-of-bias appraisal before any definitive analysis**, and the arrangement must be stated in the manuscript. The pilot extraction does not satisfy that requirement.

## What the pilot does not test

- Whether the pooled proportion is right. It cannot; the sample is purposive.
- Any moderator. At roughly 12 cohorts, every moderator falls below the ten-cohort threshold and will correctly return `not reported`.
- Publication bias or GRADE. Both need the full set.
- Whether extraction is accurate at scale. It measures how long extraction takes and how often the validator fires, which is what the KURF workload estimate needs.
