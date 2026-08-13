# =============================================================================
# merge_stage_g.py
#
# Builds the merged extraction tables from the frozen Stage F shards, the
# manifest and relationship changes the shards recorded, and the pilot rows
# already in data/.
#
#     /opt/anaconda3/bin/python3 scripts/merge_stage_g.py --check   # report only
#     /opt/anaconda3/bin/python3 scripts/merge_stage_g.py           # write
#
# The corrections model this implements is:
#
#     merged = f(frozen shards, manifest and relationship changes)
#
# so a correction is made by editing an input and rerunning, never by hand
# editing a merged table. Rerunning is safe: the merge is idempotent, and the
# manifest changes are applied on a three-state rule rather than blindly.
#
# Idempotency. Each table is rebuilt as (rows whose key is not in the shard set)
# plus (all shard rows), so running twice gives the same tables as running once.
# The pilot rows are the ones that survive the first clause; they are never
# rewritten by this script.
#
# The three-state rule for a manifest change. For each (report_id, field):
#   current == old   apply new
#   current == new   already applied, logged as a no-op
#   anything else    STOP. A third value means the manifest moved underneath
#                    the shard and neither value can be trusted.
#
# Exit 0 means the merge is sound. Any other status names the fault and nothing
# is written.
# =============================================================================
import argparse
import csv
import glob
import os
import sys
from collections import Counter, defaultdict

csv.field_size_limit(10 ** 9)

DATA = "data"
SHARD_ROOT = os.environ.get("STAGE_F_SHARDS", "data/stage_f_shards")

# table name -> primary key columns
TABLES = {
    "extraction_reports": ("report_id",),
    "extraction_cohorts": ("cohort_id",),
    "extraction_arms": ("cohort_id", "arm_id"),
    "extraction_outcomes": ("result_id",),
    "extraction_rob": ("rob_assessment_id",),
    "report_cohort_map": ("report_id", "cohort_id"),
}

# Cohort attributes that must agree if two shards describe the same cohort.
# Free-text fields are excluded: two extractors may word a note differently
# without disagreeing about the cohort.
COHORT_AGREE = ["cohort_name", "design", "country_iso3", "region",
                "diagnosis_group", "employment_selection_status"]

# andersen2024 describes two parallel cohorts, so its cohort_id "change" is two
# report-cohort relationships rather than one scalar edit. The relationships are
# routed through report_cohort_map.csv. The legacy scalar manifest field cannot
# hold two values, so the policy below is applied and recorded in the manifest
# note rather than left to whichever change row is processed last.
DUAL_COHORT_POLICY = {
    "andersen2024": {
        "cohorts": ["headspace_hep_fep_au", "headspace_hep_uhr_au"],
        # The scalar field carries the cohort that contributes to the primary
        # estimand; the map carries both. chr samples are barred from the
        # primary estimand outright, so the FEP cohort is the contributing one.
        "scalar": "headspace_hep_fep_au",
        "legacy": ["headspace_hep_au"],
    },
    "hakulinen2020": {
        # Three separately ascertained national case groups, each analysed
        # separately with no participant in more than one. The bipolar group
        # fails the diagnosis gate and gets no cohort.
        "cohorts": ["fi_registers_scz", "fi_registers_nonaff"],
        "scalar": "fi_registers_scz",
        "legacy": ["fi_registers", "fi_registers_scz fi_registers_nonaff"],
    },
    "leighton2019b": {
        "cohorts": ["crisp_glasgow", "glasgow_edinburgh_2006"],
        "scalar": "crisp_glasgow",
        "legacy": ["crisp_glasgow; glasgow_edinburgh_2006"],
    },
    "dayabandara2026": {
        # A pilot report, not a Stage F one. The merge check surfaced that its
        # scalar cohort_id names a cohort that has never existed in the cohort
        # table: the two parallel cohorts are nhsl_colombo_fep and
        # nhsl_colombo_rec, and the map has carried both since the pilot.
        "cohorts": ["nhsl_colombo_fep", "nhsl_colombo_rec"],
        "scalar": "nhsl_colombo_fep",
        "legacy": ["nhsl_colombo"],
    },
}

DUAL_NOTE = ("Two parallel cohorts. The scalar cohort_id carries the "
             "primary-contributing cohort only; report_cohort_map.csv is the "
             "authority and carries both.")

# Reconciliation of change rows the shards recorded in a form the three-state
# rule cannot match: an abbreviated old value, a punctuation difference, or a
# commentary annotation typed into a value field. The shards are immutable, so
# a correction is expressed here as an input rather than by editing them. Each
# row still goes through the strict three-state rule, against the reconciled
# values, so nothing is waved through.
RECONCILIATION = "data/stage_g_reconciliation.csv"

# --- D14 completion -----------------------------------------------------------
#
# D14 was ratified after the batches ran, so the shards could not use it. Two
# things follow, and they are different operations. Conflating them would
# duplicate results that already exist.
#
# D14_LINKS: partition sums that ARE ALREADY in the 208. The shards left
# derivation_component_result_ids blank because the validator of the day
# rejected components whose arm_id differed from the derived row. It now has a
# partition case, so the link is restored. No row is created.
#
# D14_NEW_ROWS: the one whole-cohort count D14 permits that does NOT exist in
# any shard. Its numerator and denominator are summed from the components at
# merge time rather than typed here, so the figures cannot drift from the rows
# they come from.
D14_LINKS = {
    "maguire2021_cohort_discharge_paidoreduc": [
        "maguire2021_migrants_discharge_paidoreduc",
        "maguire2021_ausborn_discharge_paidoreduc"],
    "moncrieff2025_cohort_t24m_eet": [
        "moncrieff2025_relapsed_t24m_eet",
        "moncrieff2025_notrelapsed_t24m_eet"],
}

D14_NEW_ROWS = [{
    "result_id": "jirapramukpitak2022_cohort_t12m_paidany",
    # The new row inherits construct, ascertainment, window, horizon and
    # follow-up basis from a component, because a partition sum must agree with
    # its parts on all of them; only the fields below differ.
    "template": "jirapramukpitak2022_early_t12m_paidany",
    "components": ["jirapramukpitak2022_early_t12m_paidany",
                   "jirapramukpitak2022_later_t12m_paidany"],
    "overrides": {
        "arm_id": "cohort",
        "result_role": "derived",
        "analysis_sample_id": "",
        "derivation_mutually_exclusive": "yes",
        "derivation_exhaustive": "yes",
        "checked_by": "",
        "derivation_justification": (
            "D14 partition sum. The two illness-stage strata are mutually "
            "exclusive by definition (one or fewer past relapses against more "
            "than one), exhaust the analysed cohort, and are measured on the "
            "same construct, ascertainment, window and timepoint. Both cells "
            "were verified against Table S3 of Additional file 1 in F08. "
            "Twelve-month PERIOD prevalence, so this row belongs to the "
            "period-prevalence family and not to the primary point-prevalence "
            "pool. checked_by is left blank: the independent human check is "
            "Stage G's and has not happened."),
        "notes": (
            "Created at the Stage G merge under D14, which was ratified after "
            "the F08 batch ran. It exists in no shard. Numerator and "
            "denominator are summed from the component rows at merge time."),
    },
}]


def read(path):
    with open(path, newline="", encoding="utf-8") as fh:
        rd = csv.DictReader(fh)
        return rd.fieldnames, list(rd)


def write(path, fields, rows):
    with open(path, "w", newline="\n", encoding="utf-8") as fh:
        w = csv.DictWriter(fh, fieldnames=fields, lineterminator="\n")
        w.writeheader()
        for r in rows:
            w.writerow({k: r.get(k, "") for k in fields})


def shard_ids():
    return sorted(d for d in os.listdir(SHARD_ROOT)
                  if os.path.isdir(os.path.join(SHARD_ROOT, d)))


def load_shard_table(table):
    """Every shard's rows for one table, tagged with the shard they came from."""
    out = []
    for p in sorted(glob.glob(os.path.join(SHARD_ROOT, "F*", table + ".csv"))):
        batch = os.path.basename(os.path.dirname(p))
        _, rows = read(p)
        for r in rows:
            out.append((batch, r))
    return out


def check_cross_shard(faults):
    """Duplicate keys across shards, and cohorts two shards describe differently.

    None is expected. The check exists regardless, because a duplicate key
    discovered after the merge is a silently overwritten row.
    """
    for table, keys in TABLES.items():
        seen = {}
        for batch, r in load_shard_table(table):
            k = tuple(r.get(c, "") for c in keys)
            if k in seen:
                faults.append("%s: duplicate key %s in %s and %s"
                              % (table, k, seen[k], batch))
            else:
                seen[k] = batch

    attrs = defaultdict(dict)
    for batch, r in load_shard_table("extraction_cohorts"):
        cid = r["cohort_id"]
        for a in COHORT_AGREE:
            if a not in r:
                continue
            prev = attrs[cid].get(a)
            if prev is not None and prev[0] != r[a]:
                faults.append("%s: cohort %s has %s=%r in %s but %r in %s"
                              % ("extraction_cohorts", cid, a, prev[0],
                                 prev[1], r[a], batch))
            elif prev is None:
                attrs[cid][a] = (r[a], batch)


def load_manifest_changes(faults):
    """All change rows, keyed and checked for unexpected duplication."""
    rows = []
    for p in sorted(glob.glob(os.path.join(SHARD_ROOT, "F*", "manifest_changes.csv"))):
        batch = os.path.basename(os.path.dirname(p))
        _, rr = read(p)
        for r in rr:
            r["_batch"] = batch
            rows.append(r)

    counts = Counter((r["report_id"], r["field"]) for r in rows)
    for (rid, field), n in sorted(counts.items()):
        if n == 1:
            continue
        policy = DUAL_COHORT_POLICY.get(rid)
        if field == "cohort_id" and policy and n == len(policy["cohorts"]):
            continue
        faults.append("manifest_changes: %s/%s appears %d times and no policy "
                      "covers it" % (rid, field, n))

    if os.path.exists(RECONCILIATION):
        _, rec = read(RECONCILIATION)
        by_key = {(r["report_id"], r["field"]): r for r in rec}
        used = set()
        for r in rows:
            k = (r["report_id"], r["field"])
            if k in by_key:
                r["old"] = by_key[k]["reconciled_old"]
                r["new"] = by_key[k]["reconciled_new"]
                r["_reconciled"] = by_key[k]["reason"]
                used.add(k)
        for k in sorted(set(by_key) - used):
            faults.append("reconciliation: %s/%s matches no shard change row; "
                          "a stale override is a silent edit" % k)
    return rows


def apply_manifest_changes(manifest, changes, faults, log):
    by_id = {r["report_id"]: r for r in manifest}
    applied = noop = 0

    # The report_id rename must run first: later change rows for the same
    # report are keyed on the new identifier.
    ordered = ([c for c in changes if c["field"] == "report_id"] +
               [c for c in changes if c["field"] != "report_id"])

    # A report renamed by one change row is still keyed on its old identifier
    # by that shard's other change rows, so the rename has to be resolvable
    # afterwards. Without this the rows following an already-applied rename
    # look like changes to a report that does not exist.
    alias = {c["old"]: c["new"] for c in changes if c["field"] == "report_id"}

    for c in ordered:
        rid, field, old, new = c["report_id"], c["field"], c["old"], c["new"]

        if field == "cohort_id" and rid in DUAL_COHORT_POLICY:
            continue  # handled by apply_dual_cohorts

        row = by_id.get(rid)
        if row is None and field == "report_id":
            row = by_id.get(old)
        if row is None and rid in alias:
            row = by_id.get(alias[rid])
        if row is None:
            # A rename already applied leaves the old id absent, which is a
            # no-op rather than a fault when the new id is present.
            if field == "report_id" and new in by_id:
                noop += 1
                log.append("noop    %s %s already renamed to %s" % (c["_batch"], old, new))
                continue
            faults.append("manifest: no row for report_id %r (%s/%s)" % (rid, c["_batch"], field))
            continue

        cur = row.get(field, "")
        # `new` is tested first. Where a change is an identity (old == new,
        # which happens when a shard records "confirmed, unchanged"), testing
        # `old` first would report an apply on every run and make an idempotent
        # merge look like a changing one.
        if cur == new:
            noop += 1
            log.append("noop    %s %-22s %-22s already %r" % (c["_batch"], rid, field, new))
        elif cur == old:
            row[field] = new
            if field == "report_id":
                by_id.pop(old, None)
                by_id[new] = row
            applied += 1
            log.append("apply   %s %-22s %-22s %r -> %r" % (c["_batch"], rid, field, old, new))
        else:
            faults.append("manifest: %s.%s is %r, which is neither the shard's "
                          "old %r nor its new %r; refusing to guess (%s)"
                          % (rid, field, cur, old, new, c["_batch"]))
    return applied, noop


def apply_dual_cohorts(manifest, rcmap, faults, log):
    """Route a report's several cohorts through the map, not the scalar field."""
    by_id = {r["report_id"]: r for r in manifest}
    have = {(r["report_id"], r["cohort_id"]) for r in rcmap}
    for rid, policy in sorted(DUAL_COHORT_POLICY.items()):
        row = by_id.get(rid)
        if row is None:
            faults.append("dual-cohort policy names %r, absent from manifest" % rid)
            continue
        for cid in policy["cohorts"]:
            if (rid, cid) not in have:
                faults.append("dual-cohort: %s -> %s is not in report_cohort_map"
                              % (rid, cid))
        allowed = ({policy["scalar"], ""} | set(policy["cohorts"])
                   | set(policy.get("legacy", [])))
        if row.get("cohort_id", "") not in allowed:
            faults.append("dual-cohort: %s scalar cohort_id is %r, which is "
                          "neither the policy value nor a known legacy value"
                          % (rid, row.get("cohort_id", "")))
            continue
        row["cohort_id"] = policy["scalar"]
        note = row.get("cohort_overlap_notes", "")
        if DUAL_NOTE not in note:
            row["cohort_overlap_notes"] = (note + "; " if note else "") + DUAL_NOTE
        log.append("dual    %-22s scalar=%s, map carries %s"
                   % (rid, policy["scalar"], " and ".join(policy["cohorts"])))


def merge_table(table, keys, faults):
    """(pilot rows whose key is not in the shard set) + (all shard rows)."""
    fields, base = read(os.path.join(DATA, table + ".csv"))
    shard_rows = load_shard_table(table)

    for batch, r in shard_rows:
        for f in r:
            if f not in fields:
                faults.append("%s: shard %s has column %r absent from data/%s.csv"
                              % (table, batch, f, table))
    shard_keys = {tuple(r.get(c, "") for c in keys) for _, r in shard_rows}
    kept = [r for r in base if tuple(r.get(c, "") for c in keys) not in shard_keys]
    dropped = len(base) - len(kept)
    merged = kept + [r for _, r in shard_rows]
    return fields, merged, len(base), len(shard_rows), dropped


def apply_d14(outcomes, faults, log):
    """Restore the partition links, and add the one row D14 permits.

    Idempotent: a link already present is left alone, and the new row is only
    appended when its result_id is absent.
    """
    by = {r["result_id"]: r for r in outcomes}

    for derived, comps in sorted(D14_LINKS.items()):
        row = by.get(derived)
        if row is None:
            faults.append("D14: derived row %r not in the merged outcomes" % derived)
            continue
        for c in comps:
            if c not in by:
                faults.append("D14: %s names component %r, which is absent" % (derived, c))
        cur = row.get("derivation_component_result_ids", "")
        want = ";".join(comps)
        if cur == want:
            log.append("d14     link  %-46s already populated" % derived)
            continue
        if cur:
            faults.append("D14: %s already links %r; refusing to overwrite" % (derived, cur))
            continue
        row["derivation_component_result_ids"] = want
        for f in ("derivation_mutually_exclusive", "derivation_exhaustive"):
            if f in row:
                row[f] = "yes"
        log.append("d14     link  %-46s -> %s" % (derived, want))

    for spec in D14_NEW_ROWS:
        rid = spec["result_id"]
        if rid in by:
            log.append("d14     row   %-46s already present" % rid)
            continue
        tmpl = by.get(spec["template"])
        if tmpl is None:
            faults.append("D14: template %r absent" % spec["template"])
            continue
        comps = [by.get(c) for c in spec["components"]]
        if any(c is None for c in comps):
            faults.append("D14: %s has a missing component" % rid)
            continue
        row = dict(tmpl)
        row["result_id"] = rid
        row.update(spec["overrides"])
        # Summed, never typed, so the row cannot drift from its parts. Every
        # count field is summed, not just the numerator and its denominator:
        # a partition sum inherits nothing scalar from one stratum, and a
        # cohort row carrying one stratum's n_assessed fails the nesting check
        # for the right reason. A field blank in any component stays blank,
        # because a partial sum would understate the total silently.
        for f in ("n_employed", "n_outcome_observed", "n_entered",
                  "n_alive_eligible", "n_assessed"):
            if f not in row:
                continue
            vals = [c.get(f, "").strip() for c in comps]
            row[f] = str(sum(int(v) for v in vals)) if all(v for v in vals) else ""
        row["derivation_component_result_ids"] = ";".join(spec["components"])
        outcomes.append(row)
        by[rid] = row
        log.append("d14     row   %-46s created %s/%s from %d components"
                   % (rid, row["n_employed"], row["n_outcome_observed"], len(comps)))


def main(argv):
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true",
                    help="report what would change and write nothing")
    args = ap.parse_args(argv[1:])

    faults, log = [], []

    print("Stage G merge, shards at %s" % SHARD_ROOT)
    print("shards: %s\n" % ", ".join(shard_ids()))

    check_cross_shard(faults)
    changes = load_manifest_changes(faults)
    print("manifest change rows: %d, unique (report_id, field) keys: %d"
          % (len(changes), len({(c["report_id"], c["field"]) for c in changes})))

    man_fields, manifest = read(os.path.join(DATA, "inclusion_manifest.csv"))
    map_fields, rcmap_base = read(os.path.join(DATA, "report_cohort_map.csv"))
    map_shard = load_shard_table("report_cohort_map")
    map_keys = {(r["report_id"], r["cohort_id"]) for _, r in map_shard}
    rcmap = ([r for r in rcmap_base
              if (r["report_id"], r["cohort_id"]) not in map_keys] +
             [r for _, r in map_shard])

    applied, noop = apply_manifest_changes(manifest, changes, faults, log)
    apply_dual_cohorts(manifest, rcmap, faults, log)
    print("manifest changes applied: %d, already-applied no-ops: %d\n" % (applied, noop))

    results = {}
    for table, keys in TABLES.items():
        if table == "report_cohort_map":
            continue
        fields, merged, n_base, n_shard, dropped = merge_table(table, keys, faults)
        results[table] = (fields, merged)
        print("  %-22s base=%-4d shard=%-5d superseded=%-3d merged=%d"
              % (table, n_base, n_shard, dropped, len(merged)))
    print("  %-22s base=%-4d shard=%-5d superseded=%-3d merged=%d"
          % ("report_cohort_map", len(rcmap_base), len(map_shard),
             len(rcmap_base) - (len(rcmap) - len(map_shard)), len(rcmap)))

    apply_d14(results["extraction_outcomes"][1], faults, log)
    n_out = len(results["extraction_outcomes"][1])
    n_pilot = 69
    n_shard = len(load_shard_table("extraction_outcomes"))
    n_new = len(D14_NEW_ROWS)
    print("\npost-D14 outcome rows: %d" % n_out)
    if n_out != n_pilot + n_shard + n_new:
        faults.append("outcome count is %d, but %d pilot + %d shard + %d new D14 "
                      "rows is %d" % (n_out, n_pilot, n_shard, n_new,
                                      n_pilot + n_shard + n_new))
    else:
        print("  asserted: %d pilot + %d shard + %d new D14 = %d"
              % (n_pilot, n_shard, n_new, n_out))

    # Every cohort named anywhere must exist in the merged cohort table.
    cohort_ids = {r["cohort_id"] for r in results["extraction_cohorts"][1]}
    for r in manifest:
        cid = r.get("cohort_id", "")
        if cid and cid not in cohort_ids and r["eligibility_status"] in ("include", "linked_report"):
            faults.append("manifest: %s names cohort %r, absent from the merged "
                          "cohort table" % (r["report_id"], cid))
    for r in rcmap:
        if r["cohort_id"] not in cohort_ids:
            faults.append("report_cohort_map: %s names cohort %r, absent from the "
                          "merged cohort table" % (r["report_id"], r["cohort_id"]))

    new_cohorts = sorted(cohort_ids - {r["cohort_id"] for r in
                                       read(os.path.join(DATA, "extraction_cohorts.csv"))[1]})
    print("\ncohorts new to the merged table (%d): %s"
          % (len(new_cohorts), ", ".join(new_cohorts)))

    if faults:
        print("\nMERGE FAILED, %d fault(s), nothing written:" % len(faults))
        for f in faults:
            print("  " + f)
        return 1

    if args.check:
        print("\n--check: sound, nothing written")
        for line in log:
            print("  " + line)
        return 0

    for table, (fields, merged) in results.items():
        write(os.path.join(DATA, table + ".csv"), fields, merged)
    write(os.path.join(DATA, "report_cohort_map.csv"), map_fields, rcmap)
    write(os.path.join(DATA, "inclusion_manifest.csv"), man_fields, manifest)

    print("\nOK: merged tables written. Rerunning is a no-op.")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
