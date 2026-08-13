# =============================================================================
# build_provenance.py
#
#     /opt/anaconda3/bin/python3 scripts/build_provenance.py
#
# Emits the human-verification denominator: one row per (result_id, field) for
# every field that can move a result into or out of a pool, across the whole
# merged set, with the verifier columns blank.
#
# The point of writing the denominator out in full is that completion becomes a
# fraction rather than a claim. A blank `verifier` means nobody has checked that
# field yet. Blanks are never deleted, so the ledger cannot be made to look
# finished by removing what has not been done.
#
# Rerunning is safe. Rows already carrying verification are preserved exactly;
# only missing (result_id, field) pairs are added, and rows whose result_id no
# longer exists are reported rather than silently dropped.
#
# Tiers are the review's, section 9: 0 is what must be verified before the
# primary pool can be frozen, rising to 5 for the 1,491 risk-of-bias rows.
# =============================================================================
import csv
import os
import sys
from collections import Counter

OUT = "data/extraction_provenance.csv"
OUTCOMES = "data/extraction_outcomes.csv"
ARMS = "data/extraction_arms.csv"
COHORTS = "data/extraction_cohorts.csv"
ROB = "data/extraction_rob.csv"

# Fields that determine whether a result reaches a pool, by tier. A field is
# listed once, at the lowest tier at which it can change a pool decision.
POOL_FIELDS = [
    "outcome_construct", "ascertainment", "ascertainment_window_months",
    "n_employed", "n_outcome_observed", "denominator_basis",
    "followup_months", "followup_basis", "horizon",
    "result_role", "conflict_status", "arm_id",
    "derivation_component_result_ids",
]
COHORT_FIELDS = ["employment_selection_status", "diagnosis_group",
                 "perc_qualifying_diagnosis", "design"]
ARM_FIELDS = ["arm_type", "analysis_selection_status",
              "employment_targeted_intervention"]

# Tier 0: the provisional primary candidates and the near-miss, plus their
# derivation components. Named explicitly rather than derived from the current
# pool, because a row that has just left the pool still needs verifying to
# establish that it was right to leave.
TIER0_RESULTS = {
    "khare2022b_cohort_t12m_paidany",
    "khare2021_cohort_t12m_paidany",
    "andersen2024_fep_cohort_t12m_paidany",
    "mayoralvanson2019_cohort_t12m_paidany",
}
TIER0_COHORTS = {"pune_public", "pune_private", "headspace_hep_fep_au",
                 "headspace_hep_uhr_au", "pafip_spain"}

SOURCE_VERSION = os.environ.get("PROVENANCE_SOURCE_VERSION", "stage-g-merge")


def read(path):
    with open(path, newline="", encoding="utf-8") as fh:
        rd = csv.DictReader(fh)
        return rd.fieldnames, list(rd)


def tier_for(result_id, cohort_id, field, components):
    """Lowest tier at which this field can change a pool decision."""
    if result_id in TIER0_RESULTS or result_id in components:
        return 0
    if cohort_id in TIER0_COHORTS:
        return 0
    if field in ("employment_selection_status", "design"):
        return 1
    if field in COHORT_FIELDS or field in ARM_FIELDS:
        return 2
    return 2


def main():
    of, outcomes = read(OUTCOMES)
    _, arms = read(ARMS)
    _, cohorts = read(COHORTS)
    cohort_by = {c["cohort_id"]: c for c in cohorts}
    arm_by = {(a["cohort_id"], a["arm_id"]): a for a in arms}

    components = set()
    for r in outcomes:
        if r["result_id"] in TIER0_RESULTS:
            for c in r.get("derivation_component_result_ids", "").split(";"):
                if c.strip():
                    components.add(c.strip())

    wanted = []
    for r in outcomes:
        rid, cid = r["result_id"], r["cohort_id"]
        for f in POOL_FIELDS:
            if f not in r:
                continue
            wanted.append((rid, f, r.get(f, ""), "extraction_outcomes",
                           tier_for(rid, cid, f, components)))
        c = cohort_by.get(cid)
        if c:
            for f in COHORT_FIELDS:
                if f in c:
                    wanted.append((rid, f, c.get(f, ""), "extraction_cohorts",
                                   tier_for(rid, cid, f, components)))
        a = arm_by.get((cid, r.get("arm_id", "")))
        if a:
            for f in ARM_FIELDS:
                if f in a:
                    wanted.append((rid, f, a.get(f, ""), "extraction_arms",
                                   tier_for(rid, cid, f, components)))

    # Tier 5: every result-level risk-of-bias domain judgement. These are not
    # pool-determining, so they cannot hold up the input freeze, but they are
    # required before any risk-of-bias analysis, GRADE, interpretation or
    # release, and 1,491 of them will not be checked in five days. They are
    # enumerated here so that the size of the outstanding work is visible in
    # the same ledger rather than asserted separately.
    #
    # Tiers 3 and 4 are deliberately not enumerated in this file. Tier 4 is
    # author replies, which are tracked by request identifier in
    # docs/data_requests.md and by status in the manifest; tier 3 is secondary
    # model inputs, whose fields are the arm and outcome rows already carried
    # above. Inventing rows for them here would double-count the same checks.
    if os.path.exists(ROB):
        _, rob = read(ROB)
        for r in rob:
            wanted.append((r.get("result_id", ""),
                           "rob:" + r.get("domain", ""),
                           r.get("judgement", "") or r.get("rating", ""),
                           "extraction_rob", 5))

    fields = ["result_id", "field", "extracted_value", "source_table",
              "source_locator", "extractor", "extraction_date", "batch_id",
              "verification_tier", "source_version",
              "verifier", "verified_date", "verified_value", "agreement",
              "adjudication", "notes"]

    existing = {}
    if os.path.exists(OUT):
        _, rows = read(OUT)
        for r in rows:
            existing[(r.get("result_id", ""), r.get("field", ""))] = r

    live = {(rid, f) for rid, f, _, _, _ in wanted}
    orphans = [k for k in existing if k not in live and any(
        existing[k].get(c, "") for c in ("verifier", "verified_value", "adjudication"))]

    out_rows, added, kept = [], 0, 0
    for rid, f, val, table, tier in wanted:
        prev = existing.get((rid, f))
        if prev:
            # A verified row is never rewritten. The extracted value is
            # refreshed only when nobody has checked it yet, so a correction
            # upstream does not silently invalidate a completed check.
            if not prev.get("verifier", ""):
                prev["extracted_value"] = val
                prev["verification_tier"] = str(tier)
                prev["source_version"] = SOURCE_VERSION
                prev["source_table"] = table
            out_rows.append(prev)
            kept += 1
        else:
            out_rows.append({"result_id": rid, "field": f,
                             "extracted_value": val, "source_table": table,
                             "verification_tier": str(tier),
                             "source_version": SOURCE_VERSION})
            added += 1

    with open(OUT, "w", newline="\n", encoding="utf-8") as fh:
        w = csv.DictWriter(fh, fieldnames=fields, lineterminator="\n")
        w.writeheader()
        for r in out_rows:
            w.writerow({k: r.get(k, "") for k in fields})

    by_tier = Counter(int(r["verification_tier"]) for r in out_rows)
    done = Counter(int(r["verification_tier"]) for r in out_rows if r.get("verifier"))
    print("provenance denominator written to %s" % OUT)
    print("  rows: %d (%d new, %d preserved)" % (len(out_rows), added, kept))
    print("  source_version: %s" % SOURCE_VERSION)
    print("\n  tier  verified / total   completion")
    for t in sorted(by_tier):
        n, d = done.get(t, 0), by_tier[t]
        print("    %d   %6d / %-6d   %5.1f%%" % (t, n, d, 100.0 * n / d))
    print("\n  A blank verifier means not yet checked. Blanks are the point of "
          "this file\n  and are never deleted: completion is the fraction above, "
          "not a claim.")
    if orphans:
        print("\n  WARNING: %d verified row(s) name a result_id that no longer "
              "exists:" % len(orphans))
        for k in orphans:
            print("    %s / %s" % k)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
