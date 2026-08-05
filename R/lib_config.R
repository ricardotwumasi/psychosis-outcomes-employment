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

PROJ_ROOT <- normalizePath(file.path(dirname(sys.frame(1)$ofile %||% "."), ".."),
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
  need <- c("seed", "pool", "horizons", "moderators", "priors",
            "prior_predictive", "reporting", "frequentist", "sampling",
            "diagnostics", "simulation", "sample_status")
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

  # Overlapping bands would assign one result to two horizons.
  bands <- cfg$horizons$bands
  ord <- order(vapply(bands, function(b) b$min_months, numeric(1)))
  bs <- bands[ord]
  for (i in seq_len(length(bs) - 1L)) {
    if (bs[[i]]$max_months > bs[[i + 1L]]$min_months) {
      warning("horizon bands '", names(bs)[i], "' and '", names(bs)[i + 1L],
              "' overlap; a result in the overlap is assigned to the earlier band")
    }
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

  # The primary pool must be able to contain something.
  if (!length(cfg$pool$designs) || !length(cfg$pool$arm_types)) {
    stop("pool.designs and pool.arm_types must both be non-empty", call. = FALSE)
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
#' so the fact is recorded rather than the run being blocked.
worktree_status <- function(cfg) {
  out <- tryCatch(
    system2("git", c("-C", shQuote(cfg$.root), "status", "--porcelain"),
            stdout = TRUE, stderr = FALSE),
    error = function(e) NA_character_
  )
  if (length(out) == 0L) "clean" else "dirty"
}
