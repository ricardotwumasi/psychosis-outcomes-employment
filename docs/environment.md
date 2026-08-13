# Analysis environment record

Recorded 11 August 2026, as part of the prospective release gate. A definitive run
is reproducible only if the environment it ran under is written down, so this file
belongs with the SAP, codebook, configuration and PDF hashes.

**This is an environment record, not a frozen environment.** It says what the code
has been run under and what versions were present on 13 August 2026. The freeze is
a Phase 5 act: it happens at the tagged input commit, after the author window
closes, and it is that tag rather than this file that pins a definitive run. Two
items below are not yet reproducible from a public source and are listed as open
freeze items.

**Re-verified 13 August 2026, after the Stage F protection checkpoint.** All four
gates exit 0. The interpreter is written out rather than left as `python3`, for the
reason given under Python below.

```
/opt/anaconda3/bin/python3 scripts/check_folder.py   exit 0   90 screened studies, readable PDFs
/opt/anaconda3/bin/python3 scripts/check_shard.py    exit 0   13 shards structurally sound
Rscript R/01_validate_data.R .                       exit 0   0 warnings
Rscript tests/testthat.R                             exit 0   90 pass, 0 fail, 0 skip, 0 warn
```

The 105 warnings recorded against the test run earlier on 13 August did not recur
here. They are not being reported as fixed by a change to any rule, because no rule
changed: the only relevant difference is that `data/inclusion_manifest.csv` and the
Stage F shard CSVs were converted from CRLF to LF earlier in the same checkpoint,
and a trailing carriage return read into a character field is the most likely
source of a warning of that kind. The count is recorded as observed, 0, rather than
carried forward as 105.

The test count has risen from 23 to 90 as rules were added; the figure is recorded here
because a changed count with no changed rule would mean tests had been lost. The
validator and tests run against the **pilot data only**: the Stage F shards are not
merged, so neither is evidence that the Stage F rows validate in place.

## Platform

| | |
|---|---|
| OS | macOS, darwin 25.4.0 |
| Architecture | aarch64-apple-darwin20 |

## R

R version 4.4.2 (2024-10-31), at `/usr/local/bin/Rscript`.

`renv.lock` records all 97 packages resolved from this machine's library, and is
the machine-readable version of the table below. It was produced by
`renv::snapshot()` run against a copy of `R/`, `tests/` and `scripts/` in a scratch
project, so that `renv` could not restructure this repository while writing it; the
package versions come from the live library either way. Each entry was then reduced
to `renv`'s minimal field set (package, version, source, repository). The verbose
form `renv` wrote first embedded the full `DESCRIPTION` of every package, including
a maintainer email address for each, which does not belong in a public repository
and is not needed to restore.

Two entries are open freeze items, not yet reproducible from a public pinned source:

- **`bayesplot` 1.12.0.9000** is a development build from
  `https://stan-dev.r-universe.dev`, not a CRAN release. A `.9000` version is not a
  fixed point: the same string can name different code on different days. Before
  the Phase 5 freeze it should be replaced with a CRAN release or pinned to a
  commit. `cmdstanr` 0.9.0 comes from the same repository but is a released version.
- **`priorsense` 1.2.0**, with `ggdist` and `ggh4x`, was added to the lockfile by
  hand. `renv` scans R sources for dependencies and `priorsense` is named only in
  `config/analysis.yml:395`, so the scan could not see it. It is a real dependency
  of the prespecified prior-sensitivity work and is recorded as one.

| Package | Version | Used for |
|---|---|---|
| `yaml` | 2.3.10 | reads `config/analysis.yml` and `config/vocabularies.yml` |
| `testthat` | 3.2.1.1 | `tests/` |
| `brms` | 2.23.0 | primary Bayesian prevalence model |
| `cmdstanr` | 0.9.0 | Stan backend |
| `rstan` | 2.32.6 | |
| `posterior` | 1.6.0 | draw-wise back-transformation and diagnostics |
| `priorsense` | 1.2.0 | power-scaling prior sensitivity, supplementing the prespecified grid |
| `metafor` | 4.6.0 | `rma.glmm` frequentist comparison (a diagnostic, not a gate) |
| `digest` | 0.6.37 | file hashing for the analysis identifier |

## Stan

CmdStan **2.36.0**, at `~/.cmdstan/cmdstan-2.36.0`, reached through `cmdstanr`
0.9.0. The CmdStan version is recorded separately from the R packages because it is
a separate toolchain with its own compiler behaviour: two CmdStan versions can give
different numerical results from the same `.stan` file and the same seed, so a
definitive fit that does not name its CmdStan version has not been pinned.

## Python

Python 3.9.13, at `/opt/anaconda3/bin/python3`. Pinned in `requirements.txt`:

| Package | Version |
|---|---|
| `openpyxl` | 3.1.5 |
| `PyMuPDF` | 1.26.5 |

Python is used only for `scripts/check_folder.py`, because poppler is not installed
on this machine and PyMuPDF is the only working PDF reader here, while `openpyxl` is
needed to read `DATA_EXTRACTION_FINAL.xlsx`.

PyMuPDF is pinned rather than floated because the folder gate hashes each PDF and
checks that page one yields text. A different PyMuPDF can extract different text from
the same file, which would make the gate mean something different from run to run.

The documented commands name `/opt/anaconda3/bin/python3` rather than `python3`.
Bare `python3` does resolve to that interpreter on this machine, but only because
`/opt/anaconda3/bin` precedes `/usr/bin` on the PATH. The system interpreter at
`/usr/bin/python3` is Python 3.9.6 and has neither PyMuPDF nor openpyxl, so under
any PATH that does not put Anaconda first the documented command fails on an import
rather than on anything to do with the data. Naming the interpreter removes the
dependence on PATH.

## Entry points, corrected

`tests/testthat.R` previously derived the project root from `sys.frame(1)$ofile`,
which is only set when a file is `source()`d and is unset under `Rscript`. The
documented command `Rscript tests/testthat.R` therefore failed before reaching a
single test, with `Error in sys.frame(1) : not that many frames on the stack`. It now
resolves the root the same way `R/01_validate_data.R:15` does, from `PROJ_ROOT` if
set and the working directory otherwise, and fails with a readable message if that
directory is not the project root. The same fragile expression at `R/lib_config.R:13`
was replaced for the same reason; it also referenced `%||%` one line before defining
it, which worked only because R 4.4 supplies `%||%` in base.
