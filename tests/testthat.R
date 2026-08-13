#!/usr/bin/env Rscript
# Test entry point.
#
#     Rscript tests/testthat.R
#
# The root is resolved the same way R/01_validate_data.R resolves it: PROJ_ROOT
# if it is set, otherwise the working directory. The earlier version derived the
# root from `sys.frame(1)$ofile`, which is only set when a file is source()d and
# is unset under Rscript, so the documented command failed before reaching a
# single test.
library(testthat)

root <- if (nzchar(Sys.getenv("PROJ_ROOT"))) Sys.getenv("PROJ_ROOT") else getwd()
root <- normalizePath(root, mustWork = TRUE)

if (!file.exists(file.path(root, "config", "analysis.yml"))) {
  stop("project root does not contain config/analysis.yml: ", root,
       "\nrun from the project root, or set PROJ_ROOT.", call. = FALSE)
}

Sys.setenv(PROJ_ROOT = root)
test_dir(file.path(root, "tests", "testthat"))
