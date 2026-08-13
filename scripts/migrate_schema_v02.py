# =============================================================================
# migrate_schema_v02.py
#
# Migrates the five extraction tables from the v0.1 schema to the v0.2 schema
# specified in config/codebook.md and docs/statistical_analysis_plan.md, closing
# the implementation gate recorded at config/codebook.md line 6.
#
#     python3 scripts/migrate_schema_v02.py --check    # report, change nothing
#     python3 scripts/migrate_schema_v02.py            # write
#
# It is a script, not a hand edit, so the transformation is auditable and can be
# rerun against a fresh checkout. It is idempotent: running it twice is a no-op.
#
# What it does NOT do: decide employment_selection_status, the trial safeguards,
# or any value that requires reading a paper. Those columns are created blank
# and populated in the Stage B recheck, because a classification invented here
# would look identical to one taken from a source.
#
# The outcome_construct remapping IS applied here, from the verbatim already
# extracted in the pilot. Each mapping is listed individually with the wording
# that justifies it rather than applied as a blanket rename, because
# `paid_supported_sheltered` conflated support context with labour-market type
# and its rows do not all land in the same new value.
# =============================================================================
import argparse
import csv
import os
import sys

DATA = "data"

# --- new columns, in the position they should occupy -------------------------
# (table, anchor column, [columns inserted AFTER the anchor])
# An anchor of None appends at the end.
NEW_COLUMNS = {
    "extraction_reports.csv": [
        ("exclusion_reason", ["report_quantifiable"]),
    ],
    "extraction_cohorts.csv": [
        (None, ["employment_selection_status", "employment_selection_reason",
                "employment_selection_verbatim", "employment_selection_source"]),
    ],
    "extraction_arms.csv": [
        ("baseline_wants_work_required",
         ["all_original_arms_included", "post_randomisation_selection",
          "employment_targeted_intervention", "common_construct_across_arms",
          "selective_reweighting"]),
    ],
    "extraction_outcomes.csv": [
        ("outcome_verbatim", ["result_role"]),
        ("ascertainment", ["ascertainment_window_months"]),
        ("source_locator", ["derivation_component_result_ids",
                            "derivation_justification", "checked_by"]),
        ("perc_female", ["n_female", "n_female_denominator"]),
        ("perc_post_secondary", ["n_post_secondary", "n_post_secondary_denominator"]),
        ("perc_employed_baseline", ["n_employed_baseline",
                                    "n_employed_baseline_denominator"]),
    ],
    # extraction_rob.csv already carries the full v0.2 header (rob_tool_version,
    # signalling_responses, rationale, source_location, checker,
    # bias_direction). It is header-only because no assessment has been made yet,
    # not because it is out of date, so it needs no migration.
}

# --- outcome_construct remapping --------------------------------------------
# Keyed by result_id. The comment on each line is the extracted
# outcome_verbatim that decides it. Anything not listed keeps its current value,
# which is only valid if that value still exists in the new vocabulary.
CONSTRUCT_MAP = {
    # "sheltered workshop settings that employ people with disabilities
    # separately from others ... not subject to labor standards laws" is
    # unambiguously segregated paid work.
    "chen2023_cohort_t0m_paidshelt": "paid_sheltered_noncompetitive",
    "chen2023_cohort_t12m_paidshelt": "paid_sheltered_noncompetitive",

    # "supported work" alone does not establish whether the job was in the open
    # labour market. The codebook requires `unclear` rather than a guess in
    # either direction; the wording is preserved in outcome_verbatim.
    "darjee2017_sz_t120m_paidsupp": "unclear",
    "darjee2017_sz_t120m_paidsupp_ever": "unclear",

    # "Working or studying", "employment or education", "work or study" name no
    # training component, so these are paid-or-education, not the full EET
    # composite.
    "hansen2024_cohort_t240m_paidoredu": "paid_or_education",
    "hansen2024b_cohort_t240m_paidoredu": "paid_or_education",
    "christensen2019_ips_t18m_paidoredu": "paid_or_education",
    "christensen2019_ipse_t18m_paidoredu": "paid_or_education",
    "christensen2019_sau_t18m_paidoredu": "paid_or_education",
    "tarricone2017_cohort_t12m_paidoredu": "paid_or_education",
    "tarricone2017_interrupted_t12m_paidoredu": "paid_or_education",

    # NEET names education, employment AND training; Twumasi names "competitive
    # employment formal education or a vocational training program".
    "cunningham2025_cohort_t60m_paidoredu": "paid_or_education_or_training",
    "cunningham2025_maori_t60m_paidoredu": "paid_or_education_or_training",
    "cunningham2025_nonmaori_t60m_paidoredu": "paid_or_education_or_training",
    "twumasi2026_cohort_t120m_paidoredu": "paid_or_education_or_training",
    "twumasi2026_cohort_t120m_paidoredu_pw": "paid_or_education_or_training",

    # "Education/training" combined, not separable.
    "twumasi2026_cohort_t0m_edu": "education_or_training",

    # "job training (no salary)" is unpaid training, which the new vocabulary
    # can express exactly; `vocational_activity` was the closest the old one had.
    "chen2023_cohort_t0m_voc": "training_only",
    "chen2023_cohort_t12m_voc": "training_only",
}

# Rows whose count was arrived at by arithmetic rather than printed as such.
# `derived` requires a justification and, at the Stage G check, a named checker.
DERIVED = {
    "cunningham2025_cohort_t60m_paidoredu":
        "Total minus the printed NEET count; the source prints NEET, not its complement",
    "cunningham2025_maori_t60m_paidoredu":
        "Total minus the printed NEET count of 441",
    "cunningham2025_nonmaori_t60m_paidoredu":
        "Total minus the printed NEET count of 429",
}


def read_table(name):
    path = os.path.join(DATA, name)
    with open(path, newline="", encoding="utf-8") as fh:
        rdr = csv.DictReader(fh)
        return list(rdr.fieldnames or []), list(rdr)


def write_table(name, header, rows):
    path = os.path.join(DATA, name)
    with open(path, "w", newline="", encoding="utf-8") as fh:
        w = csv.DictWriter(fh, fieldnames=header, lineterminator="\n")
        w.writeheader()
        for r in rows:
            w.writerow({k: r.get(k, "") for k in header})


def insert_columns(header, spec):
    """Insert new columns after their anchor, skipping any already present."""
    header = list(header)
    for anchor, cols in spec:
        cols = [c for c in cols if c not in header]
        if not cols:
            continue
        if anchor is None or anchor not in header:
            header.extend(cols)
        else:
            at = header.index(anchor) + 1
            header[at:at] = cols
    return header


def main(check_only):
    changes = []

    for name, spec in NEW_COLUMNS.items():
        path = os.path.join(DATA, name)
        if not os.path.exists(path):
            print("missing table, skipped: %s" % name)
            continue
        header, rows = read_table(name)
        if not header:
            print("empty table, skipped: %s" % name)
            continue
        new_header = insert_columns(header, spec)
        added = [c for c in new_header if c not in header]
        if added:
            changes.append("%s: added %s" % (name, ", ".join(added)))
        for r in rows:
            for c in added:
                r.setdefault(c, "")

        if name == "extraction_outcomes.csv":
            # result_role: every existing row is a directly reported count
            # unless it is named in DERIVED. No pilot row is a `component`;
            # component rows arrive with the intensity-band rule in Stage F.
            n_role = n_con = n_der = 0
            for r in rows:
                if not r.get("result_role"):
                    r["result_role"] = "reported"
                    n_role += 1
                rid = r["result_id"]
                if rid in CONSTRUCT_MAP and r["outcome_construct"] != CONSTRUCT_MAP[rid]:
                    r["outcome_construct"] = CONSTRUCT_MAP[rid]
                    n_con += 1
                if rid in DERIVED and r["result_role"] != "derived":
                    r["result_role"] = "derived"
                    r["derivation_justification"] = DERIVED[rid]
                    n_der += 1
            if n_role:
                changes.append("%s: result_role set to 'reported' on %d rows"
                               % (name, n_role))
            if n_con:
                changes.append("%s: outcome_construct remapped on %d rows"
                               % (name, n_con))
            if n_der:
                changes.append("%s: result_role set to 'derived' on %d rows"
                               % (name, n_der))

        if name == "extraction_reports.csv":
            # report_quantifiable is decidable from the data already held: a
            # report is quantifiable if any of its results carries both a
            # numerator and a denominator. Rule 5, code answers.
            _, outcomes = read_table("extraction_outcomes.csv")
            with_counts = {
                o["report_id"] for o in outcomes
                if (o.get("n_employed") or "").strip()
                and (o.get("n_outcome_observed") or "").strip()
            }
            n_q = 0
            for r in rows:
                if not r.get("report_quantifiable"):
                    r["report_quantifiable"] = (
                        "yes" if r["report_id"] in with_counts else "no")
                    n_q += 1
            if n_q:
                changes.append("%s: report_quantifiable derived for %d rows"
                               % (name, n_q))

        if not check_only:
            write_table(name, new_header, rows)

    # extraction_rob.csv is header-only; give it the full v0.2 header so the
    # first assessment written into it does not have to invent one.
    if not changes:
        print("nothing to do: schema is already at v0.2")
        return 0
    for c in changes:
        print(("would apply: " if check_only else "applied: ") + c)
    if check_only:
        print("\n--check: no files written")
    return 0


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true",
                    help="report what would change and write nothing")
    args = ap.parse_args()
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    os.chdir(root)
    sys.exit(main(args.check))
