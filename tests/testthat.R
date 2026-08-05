library(testthat)
Sys.setenv(PROJ_ROOT = normalizePath(file.path(dirname(sys.frame(1)$ofile %||% "."), "..")))
test_dir("testthat")
