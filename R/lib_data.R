# =============================================================================
# lib_data.R
#
# Reads the extraction tables, validates them against config/vocabularies.yml,
# derives every computed column, and builds the primary prevalence pool.
#
# There is exactly ONE function that constructs the primary pool
# (build_primary_pool). The pool restriction does not also live in a `subset =`
# buried in a model call, because a restriction expressed in two places
# eventually disagrees with itself.
#
# Validation fails loudly. A value outside its vocabulary stops the run naming
# the column, the row and the permitted values; it is never coerced to NA,
# because a silently dropped value is indistinguishable from a value the paper
# did not report, and those mean different things.
# =============================================================================

# --- reading -----------------------------------------------------------------

read_extraction <- function(cfg) {
  rd <- function(key) {
    spec <- cfg$inputs[[key]]
    path <- file.path(cfg$.root, spec$path)
    if (!file.exists(path)) {
      if (isTRUE(spec$required)) {
        stop("required extraction file not found: ", spec$path, call. = FALSE)
      }
      return(NULL)
    }
    utils::read.csv(path, stringsAsFactors = FALSE, na.strings = c("", "NA"),
                    check.names = FALSE)
  }
  list(
    reports  = rd("reports"),
    cohorts  = rd("cohorts"),
    arms     = rd("arms"),
    outcomes = rd("outcomes"),
    rob      = rd("rob"),
    manifest = rd("manifest"),
    report_cohort_map = rd("report_cohort_map"),
    shas = vapply(names(cfg$inputs), function(k)
      sha256_file(file.path(cfg$.root, cfg$inputs[[k]]$path)), character(1))
  )
}

# --- validation helpers ------------------------------------------------------

stop_rows <- function(table, column, bad_idx, bad_values, permitted = NULL) {
  n <- length(bad_idx)
  show <- seq_len(min(n, 8L))
  detail <- paste0("  row ", bad_idx[show], ": '", bad_values[show], "'",
                   collapse = "\n")
  msg <- sprintf("%s$%s has %d invalid value%s:\n%s",
                 table, column, n, if (n == 1L) "" else "s", detail)
  if (n > 8L) msg <- paste0(msg, "\n  ... and ", n - 8L, " more")
  if (!is.null(permitted)) {
    msg <- paste0(msg, "\npermitted values: ", paste(permitted, collapse = ", "))
  }
  stop(msg, call. = FALSE)
}

check_vocab <- function(df, table, column, permitted, allow_na = FALSE) {
  if (!column %in% names(df)) {
    stop(table, " is missing required column '", column, "'", call. = FALSE)
  }
  v <- df[[column]]
  bad <- if (allow_na) !is.na(v) & !v %in% permitted else is.na(v) | !v %in% permitted
  if (any(bad)) stop_rows(table, column, which(bad), v[bad], permitted)
  invisible(TRUE)
}

check_required <- function(df, table, columns) {
  missing <- setdiff(columns, names(df))
  if (length(missing)) {
    stop(table, " is missing required column", if (length(missing) > 1L) "s" else "",
         ": ", paste(missing, collapse = ", "), call. = FALSE)
  }
  for (col in columns) {
    bad <- is.na(df[[col]])
    if (any(bad)) stop_rows(table, col, which(bad), rep("<missing>", sum(bad)))
  }
  invisible(TRUE)
}

check_unique_key <- function(df, table, keys) {
  k <- do.call(paste, c(df[keys], sep = "\r"))
  dup <- duplicated(k) | duplicated(k, fromLast = TRUE)
  if (any(dup)) {
    stop_rows(table, paste(keys, collapse = "+"), which(dup), k[dup])
  }
  invisible(TRUE)
}

check_foreign_key <- function(child, table, column, parent_values, parent_name) {
  v <- child[[column]]
  bad <- is.na(v) | !v %in% parent_values
  if (any(bad)) {
    stop_rows(table, column, which(bad), v[bad],
              permitted = paste0("any ", parent_name, " (", length(parent_values),
                                 " defined)"))
  }
  invisible(TRUE)
}

#' Split a multi-value cell into its identifiers.
#'
#' Components of a derived count are written in one cell separated by
#' semicolons. check_foreign_key is scalar-only, so a multi-value field needs
#' its own splitting before its parts can be checked.
split_ids <- function(x) {
  if (is.na(x) || !nzchar(trimws(x))) return(character(0))
  parts <- trimws(unlist(strsplit(x, "[;,]")))
  parts[nzchar(parts)]
}

#' Require a column, but only on the rows a condition selects.
#'
#' Several v0.2 fields are required conditionally: the employment-selection
#' reason only when a cohort is `selected` or `unclear`, the trial safeguards
#' only when the parent design is a trial, the ascertainment window only for
#' period prevalence. Making them unconditionally required would force an
#' extractor to type `not_applicable` everywhere; not checking them at all would
#' let the condition that matters go unrecorded.
check_required_when <- function(df, table, column, condition, why) {
  if (!column %in% names(df)) {
    stop(table, " is missing required column '", column, "' (", why, ")",
         call. = FALSE)
  }
  condition[is.na(condition)] <- FALSE
  v <- df[[column]]
  bad <- which(condition & (is.na(v) | !nzchar(trimws(as.character(v)))))
  if (length(bad)) {
    stop_rows(table, column, bad, rep("<missing>", length(bad)), permitted = why)
  }
  invisible(TRUE)
}

#' Check every count that was arrived at by arithmetic rather than printed.
#'
#' A derived count is the codebook's one sanctioned exception to "record what
#' the paper prints", and it is the easiest place in the schema to double count.
#' Two rules do the work:
#'
#'   1. The arithmetic is recomputed here, in code, and must match. A typed sum
#'      that disagrees with its own components is exactly the silent error the
#'      "if code can answer, code answers" rule exists to prevent.
#'   2. Components are marked `component` and can never enter a pool. If both a
#'      derived total and its parts were poolable the same participants would
#'      contribute twice.
#'
#' Components are optional: a complement (total minus the printed NEET count) is
#' a derivation with no component rows. Those still need a written justification,
#' because the arithmetic cannot be checked mechanically.
validate_derived_counts <- function(o) {
  if (!"result_role" %in% names(o)) return(invisible(TRUE))
  der <- which(!is.na(o$result_role) & o$result_role == "derived")
  if (!length(der)) return(invisible(TRUE))

  bad <- der[is.na(o$derivation_justification[der]) |
               !nzchar(trimws(o$derivation_justification[der]))]
  if (length(bad)) {
    stop_rows("extraction_outcomes", "derivation_justification", bad,
              rep("<missing>", length(bad)),
              permitted = "a statement of the arithmetic and where its parts came from")
  }

  for (i in der) {
    ids <- split_ids(o$derivation_component_result_ids[i])
    if (!length(ids)) next  # a complement or other non-sum derivation

    missing <- setdiff(ids, o$result_id)
    if (length(missing)) {
      stop_rows("extraction_outcomes", "derivation_component_result_ids", i,
                paste("unknown result_id:", paste(missing, collapse = ", ")),
                permitted = "result_ids that exist in this table")
    }
    if (o$result_id[i] %in% ids) {
      stop_rows("extraction_outcomes", "derivation_component_result_ids", i,
                "a derived result lists itself as its own component",
                permitted = "component result_ids other than this row")
    }

    ci <- match(ids, o$result_id)

    # Two different sums are legitimate here and they are checked differently
    # (D14). A CATEGORY sum adds mutually exclusive outcome categories within
    # one arm, all on one denominator: full-time plus part-time plus
    # self-employed gives paid_any on the same denominator. A PARTITION sum adds
    # results across mutually exclusive subgroups that jointly exhaust the
    # observed-case analysis population, so the component denominators sum to
    # the derived one rather than equalling it.
    #
    # The two are told apart structurally, not by a flag: a flag could disagree
    # with the arithmetic it describes, and then one of them would be wrong with
    # nothing to say which. Components sharing an arm are a category sum;
    # components on different arms are a partition sum.
    partition <- "arm_id" %in% names(o) &&
      any(o$arm_id[ci] != o$arm_id[i], na.rm = TRUE)

    # Common to both: the components must describe the same participants at the
    # same moment, measured the same way, or their counts are not addable. The
    # ascertainment WINDOW is checked as well as its type, since two
    # period-prevalence counts over different windows measure different things.
    shared <- c("cohort_id", "report_id", "followup_months", "followup_basis",
                "ascertainment", "ascertainment_window_months",
                "denominator_basis")
    # A partition sums ONE construct across subgroups, so the construct must
    # match. A category sum does the opposite: it builds paid_any FROM
    # full-time, part-time and self-employed, whose constructs necessarily
    # differ from the total's. Requiring a common construct in both places
    # would forbid the derivation the rule exists to permit.
    if (partition) shared <- c(shared, "outcome_construct")
    if (!partition) shared <- c(shared, "arm_id")
    for (f in shared) {
      if (!f %in% names(o)) next
      if (any(o[[f]][ci] != o[[f]][i], na.rm = TRUE)) {
        stop_rows("extraction_outcomes", "derivation_component_result_ids", i,
                  paste0("components disagree with the derived row on ", f),
                  permitted = paste("components sharing", paste(shared, collapse = ", ")))
      }
    }

    # No USABLE derivation may rest on a component whose own numbers are
    # disputed: the conflict would be laundered into a clean-looking total.
    # The laundering is the harm, so the test is scoped to the case that can
    # launder. A derived row that carries `unresolved` itself is visibly
    # disputed, is blocked from every pool by the same rule that blocks its
    # component, and records a derivation that becomes usable the moment an
    # author resolves the conflict. Forbidding it outright would delete the
    # arithmetic rather than flag it, and the conflict would then have to be
    # rediscovered when the answer arrives.
    if ("conflict_status" %in% names(o) &&
        any(o$conflict_status[ci] == "unresolved", na.rm = TRUE) &&
        !isTRUE(o$conflict_status[i] == "unresolved")) {
      stop_rows("extraction_outcomes", "derivation_component_result_ids", i,
                paste("a component carries conflict_status = unresolved while",
                      "the derived row does not"),
                permitted = paste("components free of unresolved numerical",
                                  "conflict, unless the derived row is itself",
                                  "marked unresolved"))
    }

    if (partition) {
      # The subgroups must be asserted to partition the population, and their
      # denominators must sum EXACTLY to the derived one. Exactness is what
      # distinguishes a partition from an omission: a subgroup left out, or
      # counted twice, changes the sum and is caught here rather than being
      # argued about later.
      for (f in c("derivation_mutually_exclusive", "derivation_exhaustive")) {
        if (f %in% names(o) && !isTRUE(o[[f]][i] == "yes")) {
          stop_rows("extraction_outcomes", f, i, o[[f]][i],
                    permitted = paste("yes, for a partition sum across",
                                      "subgroups; without both, the components",
                                      "are not known to exhaust the population"))
        }
      }
      dsum <- sum(o$n_outcome_observed[ci])
      if (!is.na(dsum) && !is.na(o$n_outcome_observed[i]) &&
          dsum != o$n_outcome_observed[i]) {
        stop_rows("extraction_outcomes", "n_outcome_observed", i,
                  paste0("derived row has denominator ", o$n_outcome_observed[i],
                         " but its subgroup components sum to ", dsum),
                  permitted = paste("component denominators summing exactly to",
                                    "the derived denominator"))
      }
      next
    }

    dens <- unique(stats::na.omit(o$n_outcome_observed[ci]))
    if (length(dens) > 1L) {
      stop_rows("extraction_outcomes", "derivation_component_result_ids", i,
                paste("components have different denominators:",
                      paste(dens, collapse = ", ")),
                permitted = "one common denominator across all components")
    }
    # The derived row must sit on the SAME denominator as its components. A sum
    # of counts over one denominator, reported against another, is a different
    # proportion.
    if (length(dens) == 1L && !is.na(o$n_outcome_observed[i]) &&
        o$n_outcome_observed[i] != dens) {
      stop_rows("extraction_outcomes", "n_outcome_observed", i,
                paste0("derived row has denominator ", o$n_outcome_observed[i],
                       " but its components share ", dens),
                permitted = "the derived row and its components on one denominator")
    }

    # Mutual exclusivity, exhaustiveness and zero-separability are properties of
    # the source's categories that code cannot infer, so they are asserted by
    # the extractor and required here.
    #
    # ZERO SEPARABILITY is the one that bites. rautio2016's lowest intensity
    # band is "<25.0%", not "0%", so it pools people who never worked with
    # people who worked 1-24.9% of working days. Summing the bands above the
    # threshold gives an exact threshold-defined count, but the number in ANY
    # paid work is not identified by the source at all. A derived paid_any from
    # such categories would be a fabrication with a plausible-looking value.
    for (f in c("derivation_mutually_exclusive", "derivation_exhaustive")) {
      if (!f %in% names(o)) next
      if (!isTRUE(o[[f]][i] == "yes")) {
        stop_rows("extraction_outcomes", f, i,
                  as.character(o[[f]][i]),
                  permitted = paste("'yes'. A derived count may only be summed from",
                                    "mutually exclusive and exhaustive categories"))
      }
    }
    if ("derivation_zero_separable" %in% names(o) &&
        identical(o$outcome_construct[i], "paid_any") &&
        !isTRUE(o$derivation_zero_separable[i] == "yes")) {
      stop_rows("extraction_outcomes", "derivation_zero_separable", i,
                as.character(o$derivation_zero_separable[i]),
                permitted = paste("'yes' when the derived construct is paid_any.",
                                  "If a residual category combines zero work with",
                                  "positive low-intensity work, paid_any is NOT",
                                  "identified: leave its numerator unrecoverable,",
                                  "record the bounds, and keep any exact",
                                  "threshold-defined result as",
                                  "paid_intensity_threshold instead"))
    }

    # The arithmetic itself.
    if (!is.na(o$n_employed[i]) && !any(is.na(o$n_employed[ci]))) {
      got <- sum(o$n_employed[ci])
      if (got != o$n_employed[i]) {
        stop_rows("extraction_outcomes", "n_employed", i,
                  paste0(o$n_employed[i], " typed, but the components sum to ", got),
                  permitted = "a derived count equal to the sum of its components")
      }
    }
  }
  invisible(TRUE)
}

# --- validation --------------------------------------------------------------

validate_extraction <- function(dat, cfg) {
  V <- cfg$vocab

  ## reports
  r <- dat$reports
  check_required(r, "extraction_reports",
                 c("report_id", "first_author", "year", "source_filename",
                   "eligibility_status"))
  check_unique_key(r, "extraction_reports", "report_id")
  check_vocab(r, "extraction_reports", "eligibility_status", names(V$eligibility_status))
  check_vocab(r, "extraction_reports", "exclusion_reason", names(V$exclusion_reason))
  # An excluded report without a reason cannot be audited later.
  bad <- r$eligibility_status == "exclude" & r$exclusion_reason == "not_applicable"
  if (any(bad)) {
    stop_rows("extraction_reports", "exclusion_reason", which(bad),
              rep("not_applicable on an excluded report", sum(bad)),
              permitted = setdiff(names(V$exclusion_reason), "not_applicable"))
  }

  ## cohorts
  co <- dat$cohorts
  # employment_selection_status is required on EVERY cohort, not just the ones
  # hoping to enter the primary pool. It is the population gate (D9), and a
  # blank would otherwise be indistinguishable from `none` at the filter while
  # meaning the opposite: that nobody has looked.
  check_required(co, "extraction_cohorts",
                 c("cohort_id", "cohort_name", "design", "diagnosis_group",
                   "setting", "country_iso3", "region", "country_income_level",
                   "employment_selection_status"))
  check_unique_key(co, "extraction_cohorts", "cohort_id")
  for (col in c("design", "diagnosis_group", "setting", "region",
                "country_income_level", "employment_selection_status")) {
    check_vocab(co, "extraction_cohorts", col, names(V[[col]]))
  }
  check_vocab(co, "extraction_cohorts", "employment_selection_reason",
              names(V$employment_selection_reason), allow_na = TRUE)
  # A classification with no wording behind it cannot be checked by anyone,
  # including the person who made it. `none` needs the quotation just as much as
  # `selected` does: it is the evidence that eligibility was actually read.
  check_required_when(
    co, "extraction_cohorts", "employment_selection_verbatim",
    !is.na(co$employment_selection_status),
    "the eligibility wording copied from the source, for every classification")
  check_required_when(
    co, "extraction_cohorts", "employment_selection_source",
    !is.na(co$employment_selection_status),
    "where in the source the classification was read, e.g. 'Methods, Participants, p. 1235'")
  check_required_when(
    co, "extraction_cohorts", "employment_selection_reason",
    co$employment_selection_status %in% c("selected", "unclear"),
    "a reason is required whenever selection is `selected` or `unclear`")

  ## arms
  a <- dat$arms
  check_required(a, "extraction_arms", c("cohort_id", "arm_id", "arm_type"))
  check_unique_key(a, "extraction_arms", c("cohort_id", "arm_id"))
  check_foreign_key(a, "extraction_arms", "cohort_id", co$cohort_id, "cohort_id")
  check_vocab(a, "extraction_arms", "arm_type", names(V$arm_type))
  check_vocab(a, "extraction_arms", "cluster_randomised", names(V$cluster_randomised),
              allow_na = TRUE)

  # Trial safeguards. Required only on a whole-cohort row whose parent design is
  # a trial, which is the only case where merging allocated arms into one
  # prevalence figure is even in question. An observational cohort has nothing
  # to answer here.
  safeguards <- c("all_original_arms_included", "post_randomisation_selection",
                  "employment_targeted_intervention",
                  "common_construct_across_arms", "selective_reweighting")
  for (col in safeguards) {
    check_vocab(a, "extraction_arms", col, names(V$yes_no_na_unclear),
                allow_na = TRUE)
  }

  # Employment-related selection can attach to the ANALYSIS UNIT rather than to
  # recruitment. mihaljevicpeles2016 recruited without any employment criterion
  # but then removed disability pensioners from the employment denominator
  # "because their employment status could not have changed". Recording that at
  # cohort level would misstate the recruitment; recording it nowhere would let
  # a restricted denominator into a whole-cohort pool.
  check_required(a, "extraction_arms", "analysis_selection_status")
  check_vocab(a, "extraction_arms", "analysis_selection_status",
              names(V$employment_selection_status))
  check_vocab(a, "extraction_arms", "analysis_selection_reason",
              names(V$employment_selection_reason), allow_na = TRUE)
  check_required_when(
    a, "extraction_arms", "analysis_selection_reason",
    a$analysis_selection_status %in% c("selected", "unclear"),
    "a reason is required whenever the analysis unit is `selected` or `unclear`")
  # Required on EVERY whole-cohort row, not only trial-parent ones. An
  # observational cohort answers `not_applicable`, which is one word and states
  # that the question was considered. Allowing it to be blank instead would
  # leave the pool filter matching NA against the permitted values, dropping the
  # cohort silently while the log showed a filter behaving normally.
  needs_safeguards <- a$arm_type == "cohort"
  for (col in safeguards) {
    check_required_when(
      a, "extraction_arms", col, needs_safeguards,
      paste0("required on every whole-cohort row. A trial-derived cohort must ",
             "satisfy the SAP section 2.1 safeguards before its merged arms can ",
             "give a prevalence figure; an observational cohort answers ",
             "`not_applicable`"))
  }

  ## outcomes
  o <- dat$outcomes
  # n_employed and n_outcome_observed are deliberately NOT required. The
  # codebook instructs an extractor to leave a count blank rather than
  # back-calculate it from a percentage, and such a row is real data: it
  # records that a result exists and cannot be used, which is what the
  # missing-evidence assessment is built from. build_primary_pool() drops
  # these rows and counts them, so they are excluded visibly rather than
  # rejected at the door.
  # followup_months is required only for a timepoint measured from cohort entry.
  # A result anchored to chronological age has no elapsed follow-up to record,
  # and typing a cohort mean into the field to satisfy a validator is how
  # rautio2016's 210 months came to sit beside a measurement taken at age 44-45.
  check_required(o, "extraction_outcomes",
                 c("result_id", "report_id", "cohort_id", "arm_id",
                   "followup_basis", "outcome_construct", "ascertainment",
                   "result_role", "source_locator"))
  check_required_when(
    o, "extraction_outcomes", "followup_months",
    o$followup_basis == "since_baseline",
    "required when the timepoint is measured from cohort entry")
  check_required_when(
    o, "extraction_outcomes", "measurement_age_years",
    o$followup_basis == "chronological_age",
    "the age at which the measurement was taken, required for an age-anchored result")
  check_unique_key(o, "extraction_outcomes", "result_id")
  check_foreign_key(o, "extraction_outcomes", "report_id", r$report_id, "report_id")
  check_foreign_key(o, "extraction_outcomes", "cohort_id", co$cohort_id, "cohort_id")
  for (col in c("outcome_construct", "ascertainment", "result_role",
                "followup_basis", "conflict_status")) {
    check_vocab(o, "extraction_outcomes", col, names(V[[col]]))
  }
  # A blocked result must say what blocks it, or nobody can resolve it later.
  check_required_when(
    o, "extraction_outcomes", "conflict_note",
    o$conflict_status %in% c("unresolved", "resolved"),
    "what the source contradicts itself about, and how it was resolved if it was")
  for (col in c("denominator_basis", "missing_data_method")) {
    check_vocab(o, "extraction_outcomes", col, names(V[[col]]), allow_na = TRUE)
  }

  # Registers routinely report employment over a tax year while looking like
  # point prevalence. The window length is what distinguishes the two estimands,
  # so a period-prevalence row without it cannot be placed in either synthesis.
  check_required_when(
    o, "extraction_outcomes", "ascertainment_window_months",
    o$ascertainment == "period_prevalence",
    "the length of the measurement window, required for period prevalence")
  win <- suppressWarnings(as.numeric(o$ascertainment_window_months))
  bad <- which(o$ascertainment == "period_prevalence" & !is.na(win) & win <= 0)
  if (length(bad)) {
    stop_rows("extraction_outcomes", "ascertainment_window_months", bad,
              o$ascertainment_window_months[bad],
              permitted = "a positive number of months")
  }

  # A populated denominator must say WHAT it is. This is the guard the
  # darjee2017 error slipped past: 169 is the base the authors divided by, which
  # its printed percentages establish, but nothing in the paper shows employment
  # was observed for all 169, and complete clinical and social records exist for
  # only 137. Arithmetic agreement identifies a REPORTING BASE, not an
  # observation process, and the two must not be recorded in the same field.
  # Forcing denominator_basis to be stated makes that conflation visible at the
  # point it is made.
  check_required_when(
    o, "extraction_outcomes", "denominator_basis",
    !is.na(o$n_outcome_observed),
    paste("required whenever n_outcome_observed is populated: state what the",
          "denominator IS. A percentage base implied by the source's own",
          "arithmetic is `entered` or `unclear`, NOT `outcome_observed`"))

  validate_derived_counts(o)

  # Arms referenced by an outcome must exist on that cohort. Checking the pair
  # rather than arm_id alone catches an arm borrowed from the wrong cohort.
  pair_o <- paste(o$cohort_id, o$arm_id, sep = "\r")
  pair_a <- paste(a$cohort_id, a$arm_id, sep = "\r")
  bad <- !pair_o %in% pair_a
  if (any(bad)) {
    stop_rows("extraction_outcomes", "cohort_id+arm_id", which(bad),
              sub("\r", " / ", pair_o[bad]),
              permitted = "a (cohort_id, arm_id) pair defined in extraction_arms")
  }

  # A proportion above one is an impossible outcome, not a formatting question.
  bad <- !is.na(o$n_employed) & !is.na(o$n_outcome_observed) &
    o$n_employed > o$n_outcome_observed
  if (any(bad)) {
    stop_rows("extraction_outcomes", "n_employed", which(bad),
              paste0(o$n_employed[bad], " employed of ",
                     o$n_outcome_observed[bad], " observed"),
              permitted = "n_employed <= n_outcome_observed")
  }

  # Denominators must nest: observed <= assessed <= alive and eligible <= entered.
  nest <- list(c("n_outcome_observed", "n_assessed"),
               c("n_assessed", "n_alive_eligible"),
               c("n_alive_eligible", "n_entered"))
  for (p in nest) {
    if (all(p %in% names(o))) {
      bad <- !is.na(o[[p[1]]]) & !is.na(o[[p[2]]]) & o[[p[1]]] > o[[p[2]]]
      if (any(bad)) {
        stop_rows("extraction_outcomes", p[1], which(bad),
                  paste0(o[[p[1]]][bad], " > ", p[2], " = ", o[[p[2]]][bad]),
                  permitted = paste(p[1], "<=", p[2]))
      }
    }
  }

  bad <- !is.na(o$followup_months) & o$followup_months < 0
  if (any(bad)) stop_rows("extraction_outcomes", "followup_months", which(bad),
                          o$followup_months[bad], "a non-negative number of months")

  # Every result must be locatable in its source, or it cannot be checked.
  bad <- is.na(o$source_locator) | !nzchar(trimws(o$source_locator))
  if (any(bad)) {
    stop_rows("extraction_outcomes", "source_locator", which(bad),
              rep("<missing>", sum(bad)),
              permitted = "a table, figure or page reference, e.g. 'Table 2, p. 1147'")
  }

  ## report-to-cohort map
  # The map is the authority for which reports bear on which cohorts. A dangling
  # identifier here would put a report in the wrong extraction batch, and a
  # report read without its cohort siblings cannot make a result-selection
  # decision correctly.
  if (!is.null(dat$report_cohort_map) && nrow(dat$report_cohort_map)) {
    m <- dat$report_cohort_map
    check_required(m, "report_cohort_map",
                   c("report_id", "cohort_id", "relationship"))
    check_unique_key(m, "report_cohort_map", c("report_id", "cohort_id"))
    check_foreign_key(m, "report_cohort_map", "report_id", r$report_id, "report_id")
    check_foreign_key(m, "report_cohort_map", "cohort_id", co$cohort_id, "cohort_id")
    check_vocab(m, "report_cohort_map", "relationship", names(V$relationship))

    # Every (report, cohort) pair that produced a result must be in the map, or
    # the batching that relies on the map would separate reports that have to be
    # read together.
    pair_o <- unique(paste(o$report_id, o$cohort_id, sep = "\r"))
    pair_m <- paste(m$report_id, m$cohort_id, sep = "\r")
    missing <- setdiff(pair_o, pair_m)
    if (length(missing)) {
      stop_rows("report_cohort_map", "report_id+cohort_id",
                seq_along(missing), sub("\r", " / ", missing),
                permitted = paste("every report-cohort pair that produces a result",
                                  "must appear in the map"))
    }
  }

  ## risk of bias
  if (!is.null(dat$rob) && nrow(dat$rob)) {
    rb <- dat$rob
    check_required(rb, "extraction_rob",
                   c("rob_assessment_id", "result_id", "rob_tool", "domain",
                     "judgement", "assessor"))
    check_unique_key(rb, "extraction_rob", "rob_assessment_id")
    check_foreign_key(rb, "extraction_rob", "result_id", o$result_id, "result_id")
    check_vocab(rb, "extraction_rob", "rob_tool", names(V$rob_tool))
    # Judgement categories belong to their instrument and are never pooled into
    # a shared scale, so each row is checked against its own tool's scale.
    for (tool in unique(rb$rob_tool)) {
      idx <- which(rb$rob_tool == tool)
      permitted <- V$rob_judgement[[tool]]
      bad <- idx[!rb$judgement[idx] %in% permitted]
      if (length(bad)) {
        stop_rows("extraction_rob", paste0("judgement (tool=", tool, ")"),
                  bad, rb$judgement[bad], permitted)
      }
      # Domain slugs are fixed per instrument. Two Stage F batches independently
      # coined incompatible slugs for the same JBI checklist, which no merge can
      # reconcile and no domain-level summary can cross, so the vocabulary is
      # now enforced rather than left to each extractor.
      domains <- V$rob_domain[[tool]]
      bad <- idx[!rb$domain[idx] %in% domains]
      if (length(bad)) {
        stop_rows("extraction_rob", paste0("domain (tool=", tool, ")"),
                  bad, rb$domain[bad], domains)
      }
      # A domain missing for one result and present for another is not a
      # judgement of "not applicable"; it is an unasked question, and it would
      # quietly weaken that result's appraisal relative to its neighbours.
      for (rid in unique(rb$result_id[idx])) {
        have <- rb$domain[idx][rb$result_id[idx] == rid]
        absent <- setdiff(domains, have)
        if (length(absent)) {
          stop(sprintf(paste0("extraction_rob: result_id '%s' (tool=%s) is ",
                              "missing the domain(s): %s. Every domain of the ",
                              "chosen instrument is required for every result."),
                       rid, tool, paste(absent, collapse = ", ")),
               call. = FALSE)
        }
      }
    }
  }

  invisible(TRUE)
}

# --- derived columns ---------------------------------------------------------

#' Assign each result to a prespecified follow-up band.
#'
#' Returns NA for a result that falls in no band. That is a real outcome, not an
#' error: such results simply do not contribute to any horizon and are counted
#' as such in the flow.
#' Bands overlap at 18 months, which is in both t12m and t24m. The overlap is
#' resolved by proximity to the band's landmark, with an exact tie going to the
#' longer horizon under `horizons.tie_break`. So 18 months is t24m: equidistant
#' from 12 and 24, and the tie rule sends it to 24.
#'
#' The previous version gave the overlap to whichever band appeared first in the
#' yaml, which made a scientific assignment depend on file ordering.
assign_horizon <- function(followup_months, cfg, followup_basis = NULL) {
  # Only a timepoint measured from cohort entry can be placed in a landmark
  # band. A mean time since onset, or a measurement taken at a fixed
  # chronological age, is not an elapsed follow-up: assigning it to a horizon
  # would put a cohort into a band on the strength of an average and mix
  # age-anchored with time-anchored measurements in the same pooled estimate.
  if (!is.null(followup_basis)) {
    followup_months[!is.na(followup_basis) &
                      followup_basis != "since_baseline"] <- NA_real_
  }
  bands <- cfg$horizons$bands
  nm <- names(bands)
  lo <- vapply(bands, function(b) as.numeric(b$min_months), numeric(1))
  hi <- vapply(bands, function(b) as.numeric(b$max_months), numeric(1))
  lmk <- vapply(bands, function(b) as.numeric(b$landmark_months), numeric(1))
  tie_longer <- !identical(cfg$horizons$tie_break, "shorter_horizon")

  out <- rep(NA_character_, length(followup_months))
  for (i in seq_along(followup_months)) {
    x <- followup_months[i]
    if (is.na(x)) next
    cand <- which(x >= lo & x <= hi)
    if (!length(cand)) next
    d <- abs(x - lmk[cand])
    best <- cand[d == min(d)]
    if (length(best) > 1L) {
      best <- if (tie_longer) best[which.max(lmk[best])] else best[which.min(lmk[best])]
    }
    out[i] <- nm[best]
  }
  out
}

#' Fill in moderator percentages from counts, and refuse to average a conflict.
#'
#' A human reviewer asked for perc_female to be computed where a paper gives
#' counts but prints no percentage (71 of 161 is 44.1 per cent). That sits
#' awkwardly beside codebook rule 3, "never compute a percentage, record the
#' count", so the two are reconciled rather than traded off:
#'
#'   - counts present  -> the percentage is DERIVED here, and is checkable
#'                        against the source because the counts are recorded
#'   - counts absent   -> the extractor may type the percentage the paper prints,
#'                        which is the only thing available
#'   - both present    -> they must agree to within rounding, or the run stops
#'
#' Each moderator carries its OWN denominator. Sex, education and baseline
#' employment are frequently reported on different subsets of the same sample,
#' and sharing one denominator across them would silently misattribute.
derive_moderator_percentages <- function(o) {
  spec <- list(
    perc_female            = c("n_female", "n_female_denominator"),
    perc_post_secondary    = c("n_post_secondary", "n_post_secondary_denominator"),
    perc_employed_baseline = c("n_employed_baseline", "n_employed_baseline_denominator")
  )
  for (pc in names(spec)) {
    num_col <- spec[[pc]][1]; den_col <- spec[[pc]][2]
    if (!all(c(num_col, den_col) %in% names(o))) next
    num <- suppressWarnings(as.numeric(o[[num_col]]))
    den <- suppressWarnings(as.numeric(o[[den_col]]))
    ok <- !is.na(num) & !is.na(den) & den > 0
    if (!any(ok)) next
    computed <- 100 * num / den
    typed <- suppressWarnings(as.numeric(o[[pc]]))

    clash <- which(ok & !is.na(typed) & abs(typed - computed) > 1)
    if (length(clash)) {
      stop_rows("extraction_outcomes", pc, clash,
                paste0(typed[clash], " typed, but ", num[clash], "/", den[clash],
                       " is ", round(computed[clash], 1)),
                permitted = paste0("a typed ", pc, " agreeing with its counts to ",
                                   "within one percentage point, or no typed value at all"))
    }
    o[[pc]][ok] <- computed[ok]
  }
  o
}

#' Every column that is computed rather than typed.
#'
#' Rule 5: if code can answer, code answers. No extractor supplies any of these,
#' and the validator rejects the file if one appears as a typed column.
derive_columns <- function(dat, cfg) {
  o <- dat$outcomes
  forbidden <- intersect(names(o), c("p_obs", "horizon", "followup_years",
                                     "prop_unobserved"))
  if (length(forbidden)) {
    stop("extraction_outcomes contains derived column",
         if (length(forbidden) > 1L) "s" else "", " that must not be typed by ",
         "an extractor: ", paste(forbidden, collapse = ", "),
         ". These are computed in lib_data.R.", call. = FALSE)
  }

  o$followup_years <- o$followup_months / 12
  o$horizon <- assign_horizon(o$followup_months, cfg,
                              if ("followup_basis" %in% names(o)) o$followup_basis)
  o$p_obs <- o$n_employed / o$n_outcome_observed
  o <- derive_moderator_percentages(o)

  # Attrition is deliberately NOT n_entered minus n_outcome_observed. Death,
  # emigration, lost linkage, ineligibility and non-response are distinct, and
  # one derived figure hides which occurred. This is the proportion whose
  # outcome was unobserved among those alive and eligible, nothing more.
  o$prop_unobserved <- if ("n_alive_eligible" %in% names(o)) {
    ifelse(is.na(o$n_alive_eligible) | o$n_alive_eligible == 0, NA_real_,
           1 - o$n_outcome_observed / o$n_alive_eligible)
  } else NA_real_

  dat$outcomes <- o
  dat
}

# --- the primary pool --------------------------------------------------------

#' Build the primary prevalence pool.
#'
#' The ONLY place the pool restriction exists. Returns the pooled rows plus a
#' clause-by-clause record of how many rows each restriction removed, so an
#' over-aggressive filter is visible rather than silent.
build_primary_pool <- function(dat, cfg, horizon = cfg$horizons$primary,
                               pool_override = NULL) {
  p <- utils::modifyList(cfg$pool, pool_override %||% list())

  d <- merge(dat$outcomes, dat$cohorts, by = "cohort_id", all.x = TRUE)
  # The WHOLE arms table is merged, not three columns of it. The trial
  # safeguards live here, and selecting a subset meant they could never reach a
  # filter no matter what the configuration said.
  d <- merge(d, dat$arms, by = c("cohort_id", "arm_id"), all.x = TRUE,
             suffixes = c("", ".arm"))
  # `year` is carried through because the result-selection rule uses it as the
  # final tiebreak. Without it the tiebreak silently referenced a column that
  # did not exist.
  d <- merge(d, dat$reports[c("report_id", "eligibility_status", "year")],
             by = "report_id", all.x = TRUE)

  log <- data.frame(clause = character(), removed = integer(),
                    remaining = integer(), cohorts_remaining = integer(),
                    stringsAsFactors = FALSE)
  n_cohorts <- function(x) length(unique(x$cohort_id))
  keep <- function(d, mask, clause) {
    removed <- sum(!mask, na.rm = TRUE) + sum(is.na(mask))
    d2 <- d[!is.na(mask) & mask, , drop = FALSE]
    log <<- rbind(log, data.frame(clause = clause, removed = removed,
                                  remaining = nrow(d2),
                                  cohorts_remaining = n_cohorts(d2),
                                  stringsAsFactors = FALSE))
    d2
  }
  # keep() counts NA as removed, which is correct for a genuinely unknown value
  # but catastrophic for a column that simply does not exist: every row would be
  # dropped and the log would show a filter behaving normally. Any column a
  # clause depends on is therefore asserted present first.
  need_cols <- function(cols, clause) {
    absent <- setdiff(cols, names(d))
    if (length(absent)) {
      stop("the pool clause '", clause, "' depends on column",
           if (length(absent) > 1L) "s" else "", " that ",
           if (length(absent) > 1L) "are" else "is", " not present: ",
           paste(absent, collapse = ", "),
           ". Refusing to filter on a missing column, which would empty the ",
           "pool while looking like a legitimate restriction.", call. = FALSE)
    }
  }

  log <- rbind(log, data.frame(clause = "all extracted results", removed = 0L,
                               remaining = nrow(d), cohorts_remaining = n_cohorts(d),
                               stringsAsFactors = FALSE))
  d <- keep(d, d$eligibility_status == "include", "report eligible")

  # A component of a derived count is real evidence and is kept in the table,
  # but pooling it alongside the total it feeds would count the same people
  # twice.
  need_cols("result_role", "not a component-only fragment")
  d <- keep(d, d$result_role %in% c("reported", "derived"),
            "not a component-only fragment")

  # A result its own source contradicts is blocked from every synthesis until
  # the contradiction is resolved. A note alone is not enough: a numerically
  # complete row stays analytically usable and would enter a pool silently.
  need_cols("conflict_status", "no unresolved conflict in the source")
  d <- keep(d, d$conflict_status %in% c("none", "resolved"),
            "no unresolved conflict in the source")

  # THE POPULATION GATE (D9). Parent design no longer decides this.
  need_cols("employment_selection_status", "no employment-related selection")
  d <- keep(d, d$employment_selection_status %in% p$employment_selection,
            "no employment-related selection at recruitment")

  # Selection can attach to the analysis unit instead of to recruitment: a
  # cohort recruited without any employment criterion can still report its
  # employment rate on a denominator from which a work-capacity group has been
  # removed. Both gates are needed, and they are logged separately so a reader
  # can see which one a cohort failed.
  need_cols("analysis_selection_status", "no employment-related analytic restriction")
  d <- keep(d, d$analysis_selection_status %in% p$employment_selection,
            "no employment-related analytic restriction")

  need_cols("arm_type", "whole recruited cohort, not an allocated arm")
  d <- keep(d, d$arm_type %in% p$arm_types,
            "whole recruited cohort, not an allocated arm")

  # A trial-derived whole cohort must clear every safeguard. `not_applicable` is
  # how an observational cohort answers, so it passes; `unclear` does not, since
  # an unverified safeguard is not a satisfied one.
  if (length(p$trial_safeguards)) {
    need_cols(names(p$trial_safeguards), "trial-derived whole-cohort safeguards")
    ok <- rep(TRUE, nrow(d))
    for (col in names(p$trial_safeguards)) {
      ok <- ok & d[[col]] %in% p$trial_safeguards[[col]]
    }
    d <- keep(d, ok, "trial-derived whole-cohort safeguards")
  }

  d <- keep(d, d$ascertainment %in% p$ascertainment, "point prevalence")
  d <- keep(d, d$outcome_construct %in% p$outcome_construct,
            paste0("outcome construct (", paste(p$outcome_construct, collapse = ", "), ")"))
  # SAP section 7, as clarified by the authorship group on 12 August 2026 (D13):
  # a whole mixed severe-mental-illness cohort is eligible when at least half of
  # it carries a qualifying psychosis diagnosis. `subgroup_extractable` is NOT an
  # additional requirement, and this code previously required both, which is
  # stricter than the prespecified rule and than the rationale recorded beside
  # it. Where fewer than half qualify, an extractable diagnostic subgroup may be
  # retained for a separately labelled subgroup analysis, but it does not enter
  # the whole-cohort primary estimand, because a subgroup arm is not a whole
  # recruited cohort. `chr` remains excluded entirely and unconditionally.
  #
  # carstairs_1992 met both conditions and so never exposed the difference.
  # khare2022b did: 90 per cent schizophrenia-spectrum, a whole recruited
  # cohort, no separately extractable subgroup.
  cond <- p$diagnosis_groups_conditional
  elig_dx <- d$diagnosis_group %in% p$diagnosis_groups
  if (length(cond)) {
    ok_cond <- d$diagnosis_group %in% cond &
      !is.na(d$perc_qualifying_diagnosis) &
      d$perc_qualifying_diagnosis >= p$min_perc_qualifying_diagnosis
    elig_dx <- elig_dx | ok_cond
  }
  d <- keep(d, elig_dx, "eligible diagnosis group")
  if ("perc_qualifying_diagnosis" %in% names(d)) {
    d <- keep(d, is.na(d$perc_qualifying_diagnosis) |
                d$perc_qualifying_diagnosis >= p$min_perc_qualifying_diagnosis,
              "at least half the sample has a qualifying diagnosis")
  }
  # Named sensitivity: exclude every cohort whose parent study was a trial.
  if (length(p$exclude_parent_designs)) {
    need_cols("design", "parent design excluded by sensitivity analysis")
    d <- keep(d, !d$design %in% p$exclude_parent_designs,
              "parent design excluded by sensitivity analysis")
  }
  d <- keep(d, d$horizon == horizon, paste0("horizon ", horizon))
  d <- keep(d, !is.na(d$n_employed) & !is.na(d$n_outcome_observed),
            "numerator and denominator both recoverable")
  d <- keep(d, d$n_outcome_observed > 0, "non-zero denominator")

  dropped <- NULL
  if (isTRUE(p$one_result_per_cohort)) {
    sel <- select_one_result_per_cohort(d, cfg, horizon = horizon)
    dropped <- sel$dropped
    d <- keep(d, d$result_id %in% sel$kept$result_id, "one result per cohort")
  }

  list(data = d, log = log, dropped_for_overlap = dropped, horizon = horizon,
       n_cohorts = n_cohorts(d))
}

#' Run the named sensitivity analyses declared in config as pool overrides.
#'
#' Returns one row per analysis with its cohort count and cohort set, so a
#' sensitivity that turns out identical to the primary is visible as such rather
#' than being reported as corroboration.
build_sensitivity_pools <- function(dat, cfg, horizon = cfg$horizons$primary) {
  spec <- cfg$sensitivity$implemented
  if (!length(spec)) return(NULL)
  out <- list()
  for (nm in names(spec)) {
    pool <- build_primary_pool(dat, cfg, horizon = horizon,
                               pool_override = spec[[nm]]$pool_override)
    out[[nm]] <- list(name = nm, label = spec[[nm]]$label %||% nm, pool = pool,
                      cohorts = sort(unique(pool$data$cohort_id)))
  }
  out
}

#' Choose one result per cohort under the prespecified order.
#'
#' Reports not selected are RETURNED and named, never silently discarded: a
#' reader must be able to see which report was set aside and why.
select_one_result_per_cohort <- function(d, cfg, horizon = cfg$horizons$primary) {
  order_rules <- cfg$pool$result_selection_order
  primary_construct <- cfg$pool$outcome_construct[[1]]
  landmark <- cfg$horizons$bands[[horizon]]$landmark_months

  keys <- unique(d$cohort_id)
  kept_idx <- integer(0)
  dropped <- list()

  for (k in keys) {
    idx <- which(d$cohort_id == k)
    if (length(idx) == 1L) { kept_idx <- c(kept_idx, idx); next }
    sub <- d[idx, , drop = FALSE]
    ord <- seq_len(nrow(sub))
    for (rule in rev(order_rules)) {
      ord <- switch(
        rule,
        # SAP section 4 defines the estimate as the reported timepoint closest
        # to the landmark within the window, so proximity is a selection rule
        # and not merely a tiebreak.
        closest_to_landmark = ord[order(abs(sub$followup_months[ord] - landmark))],
        largest_analysis_population = ord[order(-sub$n_outcome_observed[ord])],
        closest_construct = ord[order(sub$outcome_construct[ord] != primary_construct)],
        earliest_publication = ord[order(sub$year[ord])],
        ord
      )
    }
    win <- idx[ord[1]]
    kept_idx <- c(kept_idx, win)
    lost <- setdiff(idx, win)
    dropped[[length(dropped) + 1L]] <- data.frame(
      cohort_id = k,
      kept_result_id = d$result_id[win],
      kept_report_id = d$report_id[win],
      dropped_result_id = d$result_id[lost],
      dropped_report_id = d$report_id[lost],
      reason = "same cohort, one result selected per prespecified order",
      stringsAsFactors = FALSE
    )
  }
  list(kept = d[sort(kept_idx), , drop = FALSE],
       dropped = if (length(dropped)) do.call(rbind, dropped) else NULL)
}

#' Trial arms, for the separate intervention synthesis.
#'
#' Never merged with the prevalence pool. See docs/statistical_analysis_plan.md
#' section 2.
build_intervention_set <- function(dat, cfg, horizon = cfg$horizons$primary) {
  d <- merge(dat$outcomes, dat$cohorts, by = "cohort_id", all.x = TRUE)
  d <- merge(d, dat$arms, by = c("cohort_id", "arm_id"), all.x = TRUE)
  # Components of a derived count are excluded here for the same reason as in
  # the prevalence pool: pooling a part alongside its total double counts.
  d <- d[d$arm_type %in% c("control_tau", "control_active", "intervention") &
           d$result_role %in% c("reported", "derived") &
           d$conflict_status %in% c("none", "resolved") &
           d$horizon == horizon &
           !is.na(d$n_employed) & !is.na(d$n_outcome_observed), , drop = FALSE]
  d$arm_intervention <- as.integer(d$arm_type == "intervention")
  d
}
