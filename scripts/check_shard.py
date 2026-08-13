# =============================================================================
# check_shard.py
#
# Checks a Stage F shard before it is trusted or stamped complete. It answers
# the questions that are decidable from the files alone, so that human attention
# goes to the ones that are not: whether a construct was read correctly, whether
# a denominator is observed, whether a cohort is really one cohort.
#
#     /opt/anaconda3/bin/python3 scripts/check_shard.py F09
#     /opt/anaconda3/bin/python3 scripts/check_shard.py   # every shard in the ledger
#
# Exit 0 means the shard is structurally sound. Any other status names the
# fault. A COMPLETE marker is NOT taken as evidence of completeness: one batch
# wrote its marker and then died, and another died before writing one, so the
# marker is checked against the ledger's report list rather than believed.
# =============================================================================
import csv
import os
import sys

import yaml

LEDGER = "data/batch_ledger.csv"
TABLES = ["extraction_reports", "extraction_cohorts", "extraction_arms",
          "extraction_outcomes", "extraction_rob", "report_cohort_map"]
EXTRA = ["provenance.csv", "manifest_changes.csv", "inconsistencies.md",
         "unresolved_queries.md"]
# The shards of record live in the repository. This default used to be the
# scratchpad the batches were written in, which outlives the session that made
# it, so the bare command could pass against a stale, unredacted copy while the
# committed shards went unchecked. STAGE_F_SHARDS still overrides it, for
# checking a shard before it is moved in.
SHARD_ROOT = os.environ.get("STAGE_F_SHARDS", "data/stage_f_shards")


def rows(path):
    with open(path, newline="", encoding="utf-8") as fh:
        return list(csv.DictReader(fh))


def header(path):
    with open(path, newline="", encoding="utf-8") as fh:
        return next(csv.reader(fh))


def check(batch_id, expected_reports, vocab, faults):
    d = os.path.join(SHARD_ROOT, batch_id)
    if not os.path.isdir(d):
        faults.append("%s: no shard directory" % batch_id)
        return

    for name in [t + ".csv" for t in TABLES] + EXTRA + ["COMPLETE"]:
        if not os.path.exists(os.path.join(d, name)):
            faults.append("%s: missing %s" % (batch_id, name))

    for t in TABLES:
        p = os.path.join(d, t + ".csv")
        if not os.path.exists(p):
            continue
        want, got = header("data/%s.csv" % t), header(p)
        if want != got:
            faults.append("%s: %s header differs (extra=%s missing=%s)"
                          % (batch_id, t, sorted(set(got) - set(want)),
                             sorted(set(want) - set(got))))

    rp = os.path.join(d, "extraction_reports.csv")
    if os.path.exists(rp):
        got = {r["report_id"] for r in rows(rp)}
        # The batch is defined by the ledger, not by what the extractor felt
        # like reading. A silently dropped report is the failure this catches.
        for missing in sorted(expected_reports - got):
            faults.append("%s: report %s in the ledger but not in the shard"
                          % (batch_id, missing))
        for extra in sorted(got - expected_reports):
            faults.append("%s: report %s in the shard but not in the ledger"
                          % (batch_id, extra))

    op = os.path.join(d, "extraction_outcomes.csv")
    bp = os.path.join(d, "extraction_rob.csv")
    if not (os.path.exists(op) and os.path.exists(bp)):
        return
    out, rob = rows(op), rows(bp)

    result_ids = {r["result_id"] for r in out}
    dupes = len(out) - len(result_ids)
    if dupes:
        faults.append("%s: %d duplicate result_id in outcomes" % (batch_id, dupes))

    for r in rob:
        if r["result_id"] not in result_ids:
            faults.append("%s: rob row for unknown result_id %s"
                          % (batch_id, r["result_id"]))
        permitted = vocab["rob_domain"].get(r["rob_tool"])
        if permitted is None:
            faults.append("%s: unknown rob_tool %s" % (batch_id, r["rob_tool"]))
        elif r["domain"] not in permitted:
            faults.append("%s: domain %s outside the %s vocabulary"
                          % (batch_id, r["domain"], r["rob_tool"]))

    # Every domain of the chosen instrument, for every appraised result. An
    # absent domain is an unasked question, not a favourable answer.
    seen = {}
    for r in rob:
        seen.setdefault((r["result_id"], r["rob_tool"]), set()).add(r["domain"])
    for (rid, tool), have in sorted(seen.items()):
        absent = set(vocab["rob_domain"].get(tool, [])) - have
        if absent:
            faults.append("%s: result %s (%s) missing domain(s) %s"
                          % (batch_id, rid, tool, ", ".join(sorted(absent))))

    # A derived count must equal the sum of its named components. This is the
    # one arithmetic claim a script can settle, and it is the claim most likely
    # to carry a plausible wrong number into a pool.
    by_id = {r["result_id"]: r for r in out}
    for r in out:
        if r.get("result_role") != "derived":
            continue
        raw = r.get("derivation_component_result_ids") or ""
        for sep in (";", ","):
            raw = raw.replace(sep, " ")
        comp = raw.split()
        if not comp:
            continue
        parts = []
        for c in comp:
            if c not in by_id:
                faults.append("%s: derived %s names unknown component %s"
                              % (batch_id, r["result_id"], c))
                parts = None
                break
            parts.append(by_id[c].get("n_employed", "").strip())
        if parts is None or not all(p.isdigit() for p in parts):
            continue
        total = (r.get("n_employed") or "").strip()
        if total.isdigit() and sum(int(p) for p in parts) != int(total):
            faults.append("%s: derived %s is %s but its components sum to %d"
                          % (batch_id, r["result_id"], total,
                             sum(int(p) for p in parts)))

    print("  %-4s reports=%-3d outcomes=%-3d rob=%-4d results_appraised=%d"
          % (batch_id, len(rows(rp)), len(out), len(rob), len(seen)))


def main(argv):
    vocab = yaml.safe_load(open("config/vocabularies.yml", encoding="utf-8"))
    led = rows(LEDGER)
    ledger = {r["batch_id"]: set(r["report_ids"].split()) for r in led}
    # A batch still running is half-written by definition, and auditing it
    # reports its own incompleteness as a fault. With no argument, check only
    # what claims to be finished; with an explicit id, check it regardless.
    if argv[1:]:
        wanted = argv[1:]
    else:
        wanted = [r["batch_id"] for r in led
                  if os.path.isdir(os.path.join(SHARD_ROOT, r["batch_id"]))
                  and os.path.exists(os.path.join(SHARD_ROOT, r["batch_id"],
                                                  "COMPLETE"))]
        skipped = [r["batch_id"] for r in led if r["status"] == "running"
                   and r["batch_id"] not in wanted]
        if skipped:
            print("still running, not checked: %s" % " ".join(sorted(skipped)))

    faults = []
    for b in sorted(wanted):
        if b not in ledger:
            faults.append("%s: not in the ledger" % b)
            continue
        check(b, ledger[b], vocab, faults)

    if faults:
        print("\nFAULTS (%d):" % len(faults), file=sys.stderr)
        for f in faults:
            print("  " + f, file=sys.stderr)
        return 1
    print("\nOK: %d shard(s) structurally sound" % len(wanted))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
