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
  check_required(co, "extraction_cohorts",
                 c("cohort_id", "cohort_name", "design", "diagnosis_group",
                   "setting", "country_iso3", "region", "country_income_level"))
  check_unique_key(co, "extraction_cohorts", "cohort_id")
  for (col in c("design", "diagnosis_group", "setting", "region",
                "country_income_level")) {
    check_vocab(co, "extraction_cohorts", col, names(V[[col]]))
  }

  ## arms
  a <- dat$arms
  check_required(a, "extraction_arms", c("cohort_id", "arm_id", "arm_type"))
  check_unique_key(a, "extraction_arms", c("cohort_id", "arm_id"))
  check_foreign_key(a, "extraction_arms", "cohort_id", co$cohort_id, "cohort_id")
  check_vocab(a, "extraction_arms", "arm_type", names(V$arm_type))
  check_vocab(a, "extraction_arms", "cluster_randomised", names(V$cluster_randomised),
              allow_na = TRUE)

  ## outcomes
  o <- dat$outcomes
  check_required(o, "extraction_outcomes",
                 c("result_id", "report_id", "cohort_id", "arm_id",
                   "followup_months", "outcome_construct", "ascertainment",
                   "n_employed", "n_outcome_observed", "source_locator"))
  check_unique_key(o, "extraction_outcomes", "result_id")
  check_foreign_key(o, "extraction_outcomes", "report_id", r$report_id, "report_id")
  check_foreign_key(o, "extraction_outcomes", "cohort_id", co$cohort_id, "cohort_id")
  for (col in c("outcome_construct", "ascertainment")) {
    check_vocab(o, "extraction_outcomes", col, names(V[[col]]))
  }
  for (col in c("denominator_basis", "missing_data_method")) {
    check_vocab(o, "extraction_outcomes", col, names(V[[col]]), allow_na = TRUE)
  }

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
assign_horizon <- function(followup_months, cfg) {
  bands <- cfg$horizons$bands
  out <- rep(NA_character_, length(followup_months))
  for (nm in names(bands)) {
    b <- bands[[nm]]
    hit <- !is.na(followup_months) &
      followup_months >= b$min_months & followup_months <= b$max_months
    out[hit & is.na(out)] <- nm
  }
  out
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
  o$horizon <- assign_horizon(o$followup_months, cfg)
  o$p_obs <- o$n_employed / o$n_outcome_observed

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
build_primary_pool <- function(dat, cfg, horizon = cfg$horizons$primary) {
  p <- cfg$pool
  d <- merge(dat$outcomes, dat$cohorts, by = "cohort_id", all.x = TRUE)
  d <- merge(d, dat$arms[c("cohort_id", "arm_id", "arm_type")],
             by = c("cohort_id", "arm_id"), all.x = TRUE)
  # `year` is carried through because the result-selection rule uses it as the
  # final tiebreak. Without it the tiebreak silently referenced a column that
  # did not exist.
  d <- merge(d, dat$reports[c("report_id", "eligibility_status", "year")],
             by = "report_id", all.x = TRUE)

  log <- data.frame(clause = character(), removed = integer(),
                    remaining = integer(), stringsAsFactors = FALSE)
  keep <- function(d, mask, clause) {
    removed <- sum(!mask, na.rm = TRUE) + sum(is.na(mask))
    d2 <- d[!is.na(mask) & mask, , drop = FALSE]
    log <<- rbind(log, data.frame(clause = clause, removed = removed,
                                  remaining = nrow(d2), stringsAsFactors = FALSE))
    d2
  }

  log <- rbind(log, data.frame(clause = "all extracted results", removed = 0L,
                               remaining = nrow(d), stringsAsFactors = FALSE))
  d <- keep(d, d$eligibility_status == "include", "report eligible")
  d <- keep(d, d$design %in% p$designs, "observational design")
  d <- keep(d, d$arm_type %in% p$arm_types, "cohort arm, not a trial arm")
  d <- keep(d, d$ascertainment %in% p$ascertainment, "point prevalence")
  d <- keep(d, d$outcome_construct %in% p$outcome_construct, "paid employment construct")
  d <- keep(d, d$diagnosis_group %in% p$diagnosis_groups, "eligible diagnosis group")
  if ("perc_qualifying_diagnosis" %in% names(d)) {
    d <- keep(d, is.na(d$perc_qualifying_diagnosis) |
                d$perc_qualifying_diagnosis >= p$min_perc_qualifying_diagnosis,
              "at least half the sample has a qualifying diagnosis")
  }
  d <- keep(d, d$horizon == horizon, paste0("horizon ", horizon))
  d <- keep(d, !is.na(d$n_employed) & !is.na(d$n_outcome_observed),
            "numerator and denominator both recoverable")
  d <- keep(d, d$n_outcome_observed > 0, "non-zero denominator")

  dropped <- NULL
  if (isTRUE(p$one_result_per_cohort)) {
    sel <- select_one_result_per_cohort(d, cfg)
    dropped <- sel$dropped
    d <- keep(d, d$result_id %in% sel$kept$result_id, "one result per cohort")
  }

  list(data = d, log = log, dropped_for_overlap = dropped, horizon = horizon)
}

#' Choose one result per cohort under the prespecified order.
#'
#' Reports not selected are RETURNED and named, never silently discarded: a
#' reader must be able to see which report was set aside and why.
select_one_result_per_cohort <- function(d, cfg) {
  order_rules <- cfg$pool$result_selection_order
  primary_construct <- cfg$pool$outcome_construct[[1]]

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
  d <- d[d$arm_type %in% c("control_tau", "control_active", "intervention") &
           d$horizon == horizon &
           !is.na(d$n_employed) & !is.na(d$n_outcome_observed), , drop = FALSE]
  d$arm_intervention <- as.integer(d$arm_type == "intervention")
  d
}
