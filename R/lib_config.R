# =============================================================================
# lib_config.R
#
# Loads and validates config/analysis.yml and config/vocabularies.yml, and
# derives the quantities that depend on them: per-fit seeds, moderator scaling,
# and the analysis identifier.
#
# Nothing here reads data. Configuration must be loadable and checkable before
# any extraction file exists, so a configuration error surfaces immediately
# rather than after an hour of fitting.
# =============================================================================

# Resolved the same way in every entry point: PROJ_ROOT if set, else the working
# directory. The earlier version read `sys.frame(1)$ofile`, which is unset unless
# the file is source()d, and referenced `%||%` a line before defining it.
PROJ_ROOT <- normalizePath(
  if (nzchar(Sys.getenv("PROJ_ROOT"))) Sys.getenv("PROJ_ROOT") else getwd(),
  mustWork = FALSE)

`%||%` <- function(a, b) if (is.null(a)) b else a

#' Load the analysis configuration and fail loudly on anything incoherent.
#'
#' @param root project root; defaults to the working directory.
load_config <- function(root = getwd()) {
  cfg_path <- file.path(root, "config", "analysis.yml")
  voc_path <- file.path(root, "config", "vocabularies.yml")
  for (p in c(cfg_path, voc_path)) {
    if (!file.exists(p)) stop("configuration file not found: ", p, call. = FALSE)
  }

  cfg <- yaml::read_yaml(cfg_path)
  cfg$vocab <- yaml::read_yaml(voc_path)
  cfg$.root <- root
  cfg$.sha_analysis <- sha256_file(cfg_path)
  cfg$.sha_vocab <- sha256_file(voc_path)

  validate_config(cfg)
  cfg
}

#' Structural checks on the configuration.
#'
#' These are the assumptions the rest of the pipeline relies on. Each one has
#' been wrong at some point in some analysis, which is why it is checked rather
#' than assumed.
validate_config <- function(cfg) {
  need <- c("seed", "pool", "horizons", "sparse_data", "moderators", "priors",
            "prior_predictive", "reporting", "frequentist", "sampling",
            "diagnostics", "simulation", "sensitivity", "sample_status")
  missing <- setdiff(need, names(cfg))
  if (length(missing)) {
    stop("analysis.yml is missing required sections: ",
         paste(missing, collapse = ", "), call. = FALSE)
  }

  # A ROPE on the pooled proportion would require a defensible threshold for an
  # acceptable employment rate. None exists, and inventing one to obtain a
  # categorical verdict is not justified, so the option cannot be switched on
  # by editing the yaml alone.
  if (isTRUE(cfg$reporting$rope_on_pooled_proportion)) {
    stop("reporting.rope_on_pooled_proportion is TRUE. There is no defensible ",
         "threshold for an acceptable employment rate; see ",
         "docs/statistical_analysis_plan.md section 10.6. Refusing to run.",
         call. = FALSE)
  }

  # The frequentist fit is a diagnostic comparison. If it is ever promoted to a
  # gate, the reasoning in the analysis plan has to change first.
  if (isTRUE(cfg$frequentist$treat_as_gate)) {
    stop("frequentist.treat_as_gate is TRUE. The metafor fit is a diagnostic, ",
         "not a gate: different likelihood approximations and priors can ",
         "legitimately differ. See docs/statistical_analysis_plan.md section 11.",
         call. = FALSE)
  }

  # The primary horizon must be one of the defined bands, or every downstream
  # selection silently returns nothing.
  if (!cfg$horizons$primary %in% names(cfg$horizons$bands)) {
    stop("horizons.primary '", cfg$horizons$primary,
         "' is not one of the defined bands: ",
         paste(names(cfg$horizons$bands), collapse = ", "), call. = FALSE)
  }

  # Bands may overlap: 18 months is in both t12m and t24m. That is resolved by a
  # prespecified rule rather than by list order, so every band needs a landmark
  # to measure proximity against, and the tie rule must be one the code
  # implements. The previous version only warned and let the first band listed
  # win, which made the assignment an artefact of yaml ordering.
  bands <- cfg$horizons$bands
  for (nm in names(bands)) {
    if (is.null(bands[[nm]]$landmark_months)) {
      stop("horizon band '", nm, "' needs landmark_months, used to assign a ",
           "result that falls in more than one band", call. = FALSE)
    }
    lm <- bands[[nm]]$landmark_months
    if (lm < bands[[nm]]$min_months || lm > bands[[nm]]$max_months) {
      stop("horizon band '", nm, "' has landmark_months ", lm,
           " outside its own range [", bands[[nm]]$min_months, ", ",
           bands[[nm]]$max_months, "]", call. = FALSE)
    }
  }
  if (!isTRUE(cfg$horizons$tie_break %in% c("longer_horizon", "shorter_horizon"))) {
    stop("horizons.tie_break must be 'longer_horizon' or 'shorter_horizon'; ",
         "a result exactly between two landmarks needs a prespecified rule",
         call. = FALSE)
  }

  # Every moderator needs the fields its kind requires. A continuous moderator
  # without a unit would be regularised on an arbitrary scale.
  for (nm in names(cfg$moderators)) {
    m <- cfg$moderators[[nm]]
    if (is.null(m$kind) || !m$kind %in% c("continuous", "categorical")) {
      stop("moderator '", nm, "' needs kind continuous or categorical", call. = FALSE)
    }
    if (is.null(m$tier) || !m$tier %in% c("confirmatory", "exploratory")) {
      stop("moderator '", nm, "' needs tier confirmatory or exploratory", call. = FALSE)
    }
    if (m$kind == "continuous") {
      for (f in c("unit", "centre", "nominal_contrast")) {
        if (is.null(m[[f]])) {
          stop("continuous moderator '", nm, "' needs '", f, "'", call. = FALSE)
        }
      }
      if (length(m$nominal_contrast) != 2L || diff(unlist(m$nominal_contrast)) == 0) {
        stop("moderator '", nm, "' needs a nominal_contrast of two distinct values",
             call. = FALSE)
      }
    } else if (is.null(m$reference)) {
      stop("categorical moderator '", nm, "' needs a reference level", call. = FALSE)
    }
  }

  # The primary pool must be able to contain something. Since D9 the population
  # gate is employment-related selection rather than parent design, so
  # pool.designs no longer exists and its absence is not an error.
  if (!length(cfg$pool$employment_selection) || !length(cfg$pool$arm_types) ||
      !length(cfg$pool$outcome_construct)) {
    stop("pool.employment_selection, pool.arm_types and pool.outcome_construct ",
         "must all be non-empty", call. = FALSE)
  }
  if ("designs" %in% names(cfg$pool)) {
    stop("pool.designs is set. The design-based gate was superseded by D9 on ",
         "11 August 2026: the primary pool is gated on employment-related ",
         "selection, not on parent study design. Remove pool.designs and use ",
         "pool.employment_selection. See docs/methods_deviations.md D9.",
         call. = FALSE)
  }
  # `none` is the only status SAP section 2.1 admits to the primary pool.
  # Admitting `unclear` here rather than in the named sensitivity analysis would
  # convert missing information into eligibility.
  if (!identical(as.character(unlist(cfg$pool$employment_selection)), "none")) {
    stop("pool.employment_selection must be exactly [none] for the primary ",
         "pool. `unclear` belongs in sensitivity.implemented, not here; see ",
         "docs/statistical_analysis_plan.md section 2.1.", call. = FALSE)
  }

  # The two sensitivity analyses SAP section 2.1 names must exist as executable
  # specifications, not as inert flags.
  for (nm in c("unclear_selection_included", "trial_derived_excluded")) {
    if (is.null(cfg$sensitivity$implemented[[nm]]$pool_override)) {
      stop("sensitivity.implemented.", nm, ".pool_override is missing. SAP ",
           "section 2.1 names this analysis; it must be specified here so it ",
           "runs rather than being declared and skipped.", call. = FALSE)
    }
  }

  # Prespecified before any definitive count was seen, so a thin pool is
  # reported rather than renegotiated.
  if (!length(cfg$sparse_data$min_cohorts_for_model) ||
      cfg$sparse_data$min_cohorts_for_model < 2L) {
    stop("sparse_data.min_cohorts_for_model must be at least 2: a pooled ",
         "estimate from one cohort is that cohort's proportion, not a ",
         "meta-analysis", call. = FALSE)
  }
  invisible(TRUE)
}

#' Per-unit prior scale for a moderator.
#'
#' The prior is specified on the full scientific contrast and divided by the
#' nominal span, so an arbitrary choice of unit does not implicitly make a
#' moderator more or less regularised than intended.
moderator_scale <- function(cfg, name, priors = cfg$priors$primary) {
  m <- cfg$moderators[[name]]
  if (is.null(m)) stop("unknown moderator '", name, "'", call. = FALSE)
  if (m$kind == "categorical") {
    return(list(span = 1, prior_sd = priors$beta_full_sd))
  }
  span <- abs(diff(unlist(m$nominal_contrast))) / m$unit
  list(span = span, prior_sd = priors$beta_full_sd / span)
}

#' Deterministic per-fit seed.
#'
#' Derived from the fit's NAME rather than from run order, so refitting one
#' model reproduces exactly regardless of what else ran.
fit_seed <- function(cfg, fit_id) {
  h <- utf8ToInt(fit_id)
  as.integer((cfg$seed + sum(h * seq_along(h) * 7919L)) %% .Machine$integer.max)
}

sha256_file <- function(path) {
  if (!file.exists(path)) return(NA_character_)
  digest::digest(file = path, algo = "sha256")
}

#' Content hash identifying this analysis.
#'
#' Deterministic in the git commit, the configuration, the vocabularies and the
#' input data, so two runs sharing an identifier are the same analysis and a
#' changed input cannot silently reuse an old identifier.
analysis_id <- function(cfg, data_shas) {
  commit <- tryCatch(
    system2("git", c("-C", shQuote(cfg$.root), "rev-parse", "HEAD"),
            stdout = TRUE, stderr = FALSE),
    error = function(e) "no-git"
  )
  substr(digest::digest(
    paste(c(commit, cfg$.sha_analysis, cfg$.sha_vocab, unlist(data_shas)),
          collapse = "|"),
    algo = "sha256"
  ), 1, 12)
}

#' Whether the working tree is clean, recorded in the manifest.
#'
#' A run made from a dirty tree cannot be reproduced from the commit it names,
#' so the fact is recorded, and the provisional and definitive gates refuse on
#' it.
#'
#' A git failure is "unknown", never "clean". The earlier version returned
#' "clean" whenever git printed nothing, and a git that fails prints nothing,
#' so a missing repository or a broken git passed the gate it exists to enforce.
worktree_status <- function(cfg) {
  out <- tryCatch(
    suppressWarnings(system2("git", c("-C", shQuote(cfg$.root), "status", "--porcelain"),
                             stdout = TRUE, stderr = FALSE)),
    error = function(e) structure(character(0), status = -1L)
  )
  if (!is.null(attr(out, "status")) && attr(out, "status") != 0L) return("unknown")
  if (length(out) == 0L) "clean" else "dirty"
}

#' Tags pointing at HEAD, or NA if git cannot say.
#'
#' A provisional or definitive fit must name a tag, because a commit hash in a
#' manifest is easy to lose and a tag is the thing a reader can check out.
head_tags <- function(cfg) {
  out <- tryCatch(
    suppressWarnings(system2("git", c("-C", shQuote(cfg$.root), "tag", "--points-at", "HEAD"),
                             stdout = TRUE, stderr = FALSE)),
    error = function(e) structure(character(0), status = -1L)
  )
  if (!is.null(attr(out, "status")) && attr(out, "status") != 0L) return(NA_character_)
  as.character(out[nzchar(out)])
}

# =============================================================================
# The no-posterior guard.
#
# Sampling a posterior on real employment outcomes is the one irreversible act
# in this project: once a pooled number exists, every later decision can be
# accused of having been taken in the light of it. The guard makes that act
# impossible by accident. It is deliberately not a warning.
#
# It lives here rather than in the runner so it can be tested without running
# main(). There are four modes, and exactly one environment variable selects
# each of the three that fit:
#
#   design_only    nothing set. Refuses to sample anything.
#   engineering    ENGINEERING_FIT=i-understand-this-is-not-a-result. Runs on
#                  SYNTHETIC data only (SYNTHETIC_DATA=1 is required), because
#                  an ungated fit on real outcomes is exactly what the guard
#                  exists to prevent, and provisional mode now covers the
#                  legitimate need to see the real pipeline run.
#   provisional    PROVISIONAL_FIT=pre-freeze. Real data, before the sample is
#                  frozen. Needs a clean worktree and a tag at HEAD, writes to
#                  results/provisional_<aid>/, and every table says
#                  PROVISIONAL_STAMP in its result_status column.
#   definitive     DEFINITIVE_RUN=yes. Needs sample_status "full", a clean
#                  worktree and a tag at HEAD.
#
# Setting more than one is refused rather than resolved. The previous version
# let ENGINEERING_FIT silently win over DEFINITIVE_RUN, so a stale variable in
# a shell could turn an intended definitive run into an ungated one.
# =============================================================================

PROVISIONAL_STAMP <- "PROVISIONAL, PRE-FREEZE - NOT FOR CITATION"

MODE_VARS <- c(ENGINEERING_FIT = "i-understand-this-is-not-a-result",
               PROVISIONAL_FIT = "pre-freeze",
               DEFINITIVE_RUN = "yes")

#' Resolve the fit mode from the environment, refusing any ambiguity.
#'
#' A variable that is set to anything other than its one accepted value is an
#' error rather than "not set": a mistyped value is someone trying to select a
#' mode, and quietly falling back to another mode is the silent win this
#' replaces. DEFINITIVE_RUN keeps its historical aliases true and 1.
#'
#' @param env named character vector of the variables, as Sys.getenv returns.
resolve_fit_mode <- function(env = Sys.getenv(c(names(MODE_VARS), "SYNTHETIC_DATA"),
                                              unset = "")) {
  val <- function(v) if (v %in% names(env)) as.character(env[[v]]) else ""
  set <- names(MODE_VARS)[vapply(names(MODE_VARS), function(v) nzchar(val(v)), logical(1))]
  if (length(set) > 1L) {
    stop("REFUSING TO CHOOSE A FIT MODE. More than one mode variable is set: ",
         paste(set, collapse = ", "), ". Unset all but one; no mode wins ",
         "silently over another.", call. = FALSE)
  }
  mode <- if (!length(set)) "design_only" else {
    v <- set
    ok <- if (v == "DEFINITIVE_RUN") tolower(val(v)) %in% c("yes", "true", "1")
          else identical(val(v), MODE_VARS[[v]])
    if (!ok) {
      stop(v, " is set to '", val(v), "', which is not its accepted value '",
           MODE_VARS[[v]], "'. Refusing rather than guessing which mode was meant.",
           call. = FALSE)
    }
    switch(v, ENGINEERING_FIT = "engineering", PROVISIONAL_FIT = "provisional",
           DEFINITIVE_RUN = "definitive")
  }
  # Synthetic data belongs to engineering and to nothing else. A provisional or
  # definitive table computed on generated data would carry a real-looking stamp.
  synthetic <- nzchar(val("SYNTHETIC_DATA"))
  if (synthetic && !identical(mode, "engineering")) {
    stop("SYNTHETIC_DATA is set in mode '", mode, "'. Synthetic data is ",
         "permitted in engineering mode only.", call. = FALSE)
  }
  if (identical(mode, "engineering") && !synthetic) {
    stop("ENGINEERING_FIT requires SYNTHETIC_DATA=1. An engineering fit bypasses ",
         "every gate, so it may not sample real employment outcomes; use ",
         "PROVISIONAL_FIT=pre-freeze for a gated fit on the real extraction.",
         call. = FALSE)
  }
  list(mode = mode, synthetic = synthetic)
}

#' Refuse to sample unless the mode's gates are all satisfied.
#'
#' Returns the tag(s) at HEAD so the runner can record them. `worktree` and
#' `tags` are arguments so the gates can be tested without a real repository in
#' a particular state.
assert_may_fit <- function(cfg, mode, worktree = worktree_status(cfg),
                           tags = head_tags(cfg)) {
  if (identical(mode, "engineering")) {
    message("\n  [ENGINEERING FIT] synthetic data; outputs are NOT results and go ",
            "to a separate namespace.")
    return(invisible(list(mode = mode, tag = NA_character_)))
  }
  if (!mode %in% c("provisional", "definitive")) {
    stop("REFUSING TO SAMPLE A POSTERIOR.\n",
         "  This run is design-only. Nothing is fitted on real employment ",
         "outcomes.\n",
         "  For the pools, selection tables and attrition, run ",
         "Rscript R/04_design_package.R\n",
         "  A provisional fit needs PROVISIONAL_FIT=pre-freeze, a definitive run ",
         "DEFINITIVE_RUN=yes, each with the gates below;\n",
         "  an engineering fit needs ENGINEERING_FIT=i-understand-this-is-not-a-result ",
         "and SYNTHETIC_DATA=1.",
         call. = FALSE)
  }
  fails <- character(0)
  if (identical(mode, "definitive") && !identical(cfg$sample_status, "full")) {
    fails <- c(fails, paste0("sample_status is '", cfg$sample_status,
                             "', not 'full'"))
  }
  if (!identical(worktree, "clean")) {
    fails <- c(fails, paste0("worktree is '", worktree,
                             "'; a ", mode, " fit must be reproducible from a commit"))
  }
  tags <- tags[!is.na(tags)]
  if (!length(tags)) {
    fails <- c(fails, paste0("no git tag points at HEAD; tag the commit so a ",
                             mode, " fit names something a reader can check out"))
  }
  if (length(fails)) {
    stop("REFUSING A ", toupper(mode), " FIT. ", length(fails),
         " gate(s) not satisfied:\n", paste0("  - ", fails, collapse = "\n"),
         call. = FALSE)
  }
  if (identical(mode, "provisional")) {
    message("\n  [PROVISIONAL FIT] ", PROVISIONAL_STAMP, "  (tag ",
            paste(tags, collapse = ";"), ")")
  }
  invisible(list(mode = mode, tag = paste(tags, collapse = ";")))
}

#' The value every output table carries in its result_status column.
#'
#' One column, one wording per mode, on every table, so a CSV separated from
#' its directory still says what it is.
result_status_label <- function(mode) {
  switch(mode,
         provisional = PROVISIONAL_STAMP,
         engineering = "ENGINEERING, SYNTHETIC DATA - NOT A RESULT",
         definitive = "definitive",
         design_only = "design only - no estimate",
         stop("unknown fit mode '", mode, "'", call. = FALSE))
}

stamp_result_status <- function(df, mode) {
  if (is.null(df) || !nrow(df)) return(df)
  df$result_status <- result_status_label(mode)
  df
}
