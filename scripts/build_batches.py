# =============================================================================
# build_batches.py
#
# Plans the Stage F reading batches and writes them to `data/batch_ledger.csv`
# with status `planned`. Run fields (model, hashes, timestamps) are left blank
# and filled when a batch actually runs.
#
# Batches are connected components of the report-cohort graph, never filenames
# and never a plain group-by on cohort_id. A component is the transitive closure
# of reports joined by a shared cohort, so every report that could bear on a
# result-selection decision is read by the same person or agent. Two reports on
# one cohort where only one may contribute the 12-month result cannot be
# adjudicated by someone who has seen only one of them.
#
# Two sources feed the graph, and they are not equally trustworthy:
#
#   data/report_cohort_map.csv   confirmed by a read. Authoritative, and it is
#                                many-to-many: one report may hold two cohorts.
#   data/inclusion_manifest.csv  the provisional `cohort_id` from triage, for
#                                reports nobody has read yet. Good enough to
#                                decide who reads what together; NOT good enough
#                                to assert cohort identity. Stage F writes the
#                                confirmed row.
#
# Reports already in the pilot are kept in the graph, because a remaining report
# can share a cohort with a piloted one (`majuri2023` and `nfbc1966` is the
# case), but they are not counted as reads and not listed for extraction.
#
#     python3 scripts/build_batches.py
# =============================================================================
import csv
import re
import sys

MANIFEST = "data/inclusion_manifest.csv"
COHORT_MAP = "data/report_cohort_map.csv"
REPORTS = "data/extraction_reports.csv"
LEDGER = "data/batch_ledger.csv"

TARGET = 6   # reports per batch, before a component pushes it over

# Documented overlaps between two *different* cohort ids, which a shared
# cohort_id cannot express and which therefore have to be listed. Same pattern
# as DOI_ALIASES in check_folder.py: each entry is a checked exception, not a
# guess. Reports linked here are read together and the note travels with them.
CROSS_COHORT_OVERLAPS = [
    (("leighton2019", "national_eden"), ("hansen2024", "opus_1998"),
     "leighton2019 validates a prediction model on OPUS. Its OPUS figures must "
     "NOT be pooled alongside hansen2024; relationship is validation_sample"),
]


def load(path):
    with open(path, newline="", encoding="utf-8") as fh:
        return list(csv.DictReader(fh))


def main():
    manifest = load(MANIFEST)
    confirmed = load(COHORT_MAP)
    piloted = {r["report_id"] for r in load(REPORTS)}

    screened = [r for r in manifest if r["screening_list"] == "yes"]

    # report -> set of cohorts. Confirmed rows win; provisional fills the gaps.
    links = {r["report_id"]: set() for r in screened}
    for r in confirmed:
        if r["report_id"] in links:
            links[r["report_id"]].add(r["cohort_id"])
    for r in screened:
        if not links[r["report_id"]] and r["cohort_id"].strip():
            links[r["report_id"]].add(r["cohort_id"].strip())

    # A report with no cohort_id at all may still carry a triage hint reading
    # "LIKELY <cohort> (verify on receipt)". Three do. Using it to decide who
    # reads what is exactly right, and it asserts nothing: the reader either
    # confirms the cohort or does not, and writes the confirmed row either way.
    # Without it, `chan2020` would be read apart from the four other Hong Kong
    # EASY reports and could not be adjudicated against them.
    hinted = {}
    for r in screened:
        if links[r["report_id"]]:
            continue
        m = re.search(r"LIKELY\s+([a-z0-9_]+)", r["cohort_overlap_notes"])
        if m:
            links[r["report_id"]].add(m.group(1))
            hinted[r["report_id"]] = m.group(1)

    # Union-find over reports, joined through shared cohorts. A report with no
    # cohort at all (never read, cohort unknown) stays its own component: it is
    # not evidence of independence, only absence of evidence of overlap.
    parent = {rid: rid for rid in links}

    def find(x):
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    def union(a, b):
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[max(ra, rb)] = min(ra, rb)

    by_cohort = {}
    for rid, cohorts in links.items():
        for c in cohorts:
            by_cohort.setdefault(c, []).append(rid)
    for members in by_cohort.values():
        for other in members[1:]:
            union(members[0], other)
    for (ra, _), (rb, _), _ in CROSS_COHORT_OVERLAPS:
        if ra in parent and rb in parent:
            union(ra, rb)

    comps = {}
    for rid in links:
        comps.setdefault(find(rid), []).append(rid)

    # Only components containing at least one unread report need a batch.
    todo = []
    for root, members in comps.items():
        unread = sorted(m for m in members if m not in piloted)
        if not unread:
            continue
        cohorts = sorted({c for m in members for c in links[m]})
        seen = sorted(m for m in members if m in piloted)
        todo.append({"unread": unread, "cohorts": cohorts, "piloted": seen})

    # Largest components first so they anchor their own batch rather than
    # straggling into one already full.
    todo.sort(key=lambda d: (-len(d["unread"]), d["unread"][0]))

    batches = []
    current = []
    current_n = 0
    for comp in todo:
        # A component is never split across batches. That is the whole point,
        # so a component larger than TARGET becomes an oversized batch of its
        # own rather than being cut in half.
        if current and current_n + len(comp["unread"]) > TARGET:
            batches.append(current)
            current, current_n = [], 0
        current.append(comp)
        current_n += len(comp["unread"])
    if current:
        batches.append(current)

    rows = []
    for i, batch in enumerate(batches, start=1):
        reports = [r for c in batch for r in c["unread"]]
        cohorts = sorted({c for comp in batch for c in comp["cohorts"]})
        carried = sorted({p for comp in batch for p in comp["piloted"]})
        parts = ["%d component(s)" % len(batch)]
        if carried:
            parts.append("shares a cohort with piloted %s, read those rows "
                         "before selecting a result" % " ".join(carried))
        for rid in reports:
            if rid in hinted:
                parts.append("%s has NO confirmed cohort; batched with %s on a "
                             "triage hint only, confirm or refute from the paper"
                             % (rid, hinted[rid]))
        for (ra, _), (rb, _), warning in CROSS_COHORT_OVERLAPS:
            if ra in reports or rb in reports:
                parts.append(warning)
        note = "; ".join(parts)
        rows.append({
            "batch_id": "F%02d" % i,
            "report_ids": " ".join(reports),
            "cohort_ids": " ".join(cohorts),
            "n_reports": len(reports),
            "model": "", "prompt_file": "", "prompt_sha256": "",
            "extractor": "", "started_utc": "", "completed_utc": "",
            "seed": "", "pdf_sha256": "", "shard_sha256": "",
            "status": "planned", "notes": note,
        })

    # A batch that has already run carries its model, seed and hashes, and that
    # record is the only evidence of how its shard was produced. Rewriting the
    # plan must never erase it. Run fields are carried across, and a batch whose
    # composition would change after it ran is a hard failure: the shard on disk
    # would no longer correspond to the row describing it.
    with open(LEDGER, newline="", encoding="utf-8") as fh:
        reader = csv.DictReader(fh)
        fieldnames = reader.fieldnames
        existing = {r["batch_id"]: r for r in reader}

    RUN_FIELDS = ("model", "prompt_file", "prompt_sha256", "extractor",
                  "started_utc", "completed_utc", "seed", "pdf_sha256",
                  "shard_sha256")
    for row in rows:
        prev = existing.get(row["batch_id"])
        if not prev or prev["status"] == "planned":
            continue
        if prev["report_ids"] != row["report_ids"]:
            print("FAIL: %s already ran on [%s] but the plan now gives [%s]. "
                  "Resolve by hand; do not silently rewrite a run batch."
                  % (row["batch_id"], prev["report_ids"], row["report_ids"]),
                  file=sys.stderr)
            return 1
        for f in RUN_FIELDS:
            row[f] = prev[f]
        row["status"] = prev["status"]

    with open(LEDGER, "w", newline="", encoding="utf-8") as fh:
        writer = csv.DictWriter(fh, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

    total = sum(r["n_reports"] for r in rows)
    print("%d batches, %d reads" % (len(rows), total))
    for r in rows:
        print("  %s  n=%d  %s" % (r["batch_id"], r["n_reports"], r["report_ids"]))

    unread_total = len([r["report_id"] for r in screened
                        if r["report_id"] not in piloted])
    if total != unread_total:
        print("FAIL: %d reads planned but %d screened reports are unread"
              % (total, unread_total), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
