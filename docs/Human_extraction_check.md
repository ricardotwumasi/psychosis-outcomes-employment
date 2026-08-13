# Human Extraction Check Report

> **Scope, added 13 August 2026. This check covers the 15-report pilot only.**
>
> Three reviewers read a subset of the pilot. **None of Stage F has been checked by a
> human.** All 75 non-pilot reports were extracted on 12-13 August 2026 and no human has
> read any of those 208 results or 1,491 risk-of-bias judgements. Do not read this
> document as evidence that the review's extraction has been verified.
>
> The corrections arising from this check were applied and are recorded in
> `docs/extraction_qa_report.md` §4. The Stage G human verification, which covers every
> pool-determining field and every risk-of-bias judgement across all 90 reports, is still
> to be done and `data/extraction_provenance.csv` is the empty ledger waiting for it.

## Overview
This document collates the manual screening observations from three independent reviewers regarding the automated data extraction process. The reviews highlight specific data points requiring manual correction or author contact to resolve inconsistencies.

## Reviewer One Observations
The first reviewer evaluated five articles, specifically Hansen 2024, Hansen 2024b, Rautio 2016, Majuri 2021, and Thompson 2023. The majority of the extracted data was accurate. However, a few minor points were identified for two of the articles.

### Hanson 2024
The extraction did not report the total number of individuals assessed. The article text indicates that 416 participants were assessed, which should be recorded in the Extraction Outcomes field. Furthermore, the automated extraction tool previously highlighted an inconsistency in the calculations provided within the article. Consequently, the authors will need to be contacted for clarification regardless of this missing field.

### Rautio 2016
The automated extraction failed to report the percentage of female participants. This metric has since been manually calculated as 44.1 percent based on 71 female participants out of a total of 161. Since this specific percentage is not explicitly stated in the article, a programmatic solution could be implemented to calculate such missing proportions when raw counts are available. Alternatively, manual calculation remains a feasible approach for the Extraction Outcomes field.

Additionally, the extraction did not report the number of participants entered into the study. The article details a subsample of 161 individuals with schizophrenia spectrum disorders derived from the larger Northern Finland Birth Cohort 1966, which originally comprised 12,058 individuals. Further deliberation is required to determine which figure is the most accurate to report in the Extraction Arms field. Finally, there is a conceptual question regarding whether limiting the employment category to those working more than 25 percent of the time is overly restrictive. The authors have included data for the under 25 percent category in their tables, which could potentially be incorporated into our dataset if deemed appropriate.

## Reviewer Two Observations
The second reviewer examined an additional five papers, encompassing Darjee et al., Fowler et al., Christensen et al., Cunningham et al., and Twumasi et al.

### Christensen et al. (2019)
The extraction inaccurately states that baseline unemployment was required. A closer reading reveals that participants were required to possess a desire for competitive employment or education, rather than being strictly unemployed at baseline. The wording in the extraction criteria may need to be revised to reflect this nuance.

### Darjee et al. (2017)
The automated extraction utilized 137 as the denominator for the end of follow-up employment outcomes. While the paper explicitly reports that 137 participants had completed the clinical and social follow-up data, it does not definitively state that this specific figure was the denominator used for calculating the reported employment outcomes. This ambiguity warrants further scrutiny.

## Reviewer Three Observations
The third reviewer conducted manual screening on papers located in rows 12 through 16 of the tracking spreadsheet, noting that colleagues Lisa and Prachee were handling the remaining ten articles.

### Tarricone et al. (2017)
In the article by Tarricone and colleagues, the number of observed outcomes was extracted as 163. This figure is highly likely to be incorrect, as the true number of individuals at the follow-up stage was 135. It appears the automated extraction tool was uncertain and defaulted to extracting the initial sample size instead.

Furthermore, an error originating from the authors themselves was identified. The authors state that 75 patients were employed at the 12-month follow-up, which they calculated as 46 percent of the original sample and 53 percent of those still in contact. However, mathematically, 75 divided by 135 yields exactly 55.5 percent. This constitutes a minor mathematical error in the original publication rather than a flaw in the automated extraction. All other extracted data points for this set of papers appeared correct.
