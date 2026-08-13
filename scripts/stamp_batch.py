# =============================================================================
# stamp_batch.py
#
# Records how a Stage F batch was actually run, into `data/batch_ledger.csv`.
# The plan in that file says which reports belong together; this says which
# model read which PDF bytes under which prompt, which is what makes a shard
# reproducible and what a reader needs to judge it.
#
#     python3 scripts/stamp_batch.py F01 running  --model claude-opus-5
#     python3 scripts/stamp_batch.py F01 complete --model claude-opus-5
#
# On `running` it stamps the prompt file and its hash, the model, the start
# time and the SHA-256 of every source PDF the batch reads, taken from the
# manifest so a swapped file is caught rather than rehashed silently. On
# `complete` it adds the end time and the shard hash, computed over the shard's
# files in sorted order so it does not depend on directory listing order.
#
# `seed` is left blank deliberately: the extraction runs are not seeded and
# writing a number there would imply a reproducibility this does not have.
# =============================================================================
import csv
import hashlib
import os
import sys
from datetime import datetime, timezone

LEDGER = "data/batch_ledger.csv"
MANIFEST = "data/inclusion_manifest.csv"
PROMPT = "config/prompts/extraction_v3.md"
# Defaults to the shards of record, for the reason given in check_shard.py:
# a scratchpad default lets a hash be stamped from a stale copy.
SHARD_ROOT = os.environ.get("STAGE_F_SHARDS", "data/stage_f_shards")


def sha256_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as fh:
        for chunk in iter(lambda: fh.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def shard_hash(batch_id):
    """One hash over the whole shard: each file's name and content, sorted."""
    d = os.path.join(SHARD_ROOT, batch_id)
    if not os.path.isdir(d):
        return ""
    h = hashlib.sha256()
    for name in sorted(os.listdir(d)):
        p = os.path.join(d, name)
        if os.path.isfile(p):
            h.update(name.encode("utf-8"))
            h.update(sha256_file(p).encode("ascii"))
    return h.hexdigest()


def main(argv):
    if len(argv) < 3:
        print(__doc__ or "usage: stamp_batch.py <batch_id> <status> "
                         "[--model M]", file=sys.stderr)
        return 2
    batch_id, status = argv[1], argv[2]
    model = ""
    if "--model" in argv:
        model = argv[argv.index("--model") + 1]

    manifest = {r["report_id"]: r
                for r in csv.DictReader(open(MANIFEST, newline="",
                                             encoding="utf-8"))}

    with open(LEDGER, newline="", encoding="utf-8") as fh:
        reader = csv.DictReader(fh)
        fieldnames = reader.fieldnames
        rows = list(reader)

    row = next((r for r in rows if r["batch_id"] == batch_id), None)
    if row is None:
        print("FAIL: no batch %s in the ledger" % batch_id, file=sys.stderr)
        return 1

    now = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

    if status == "running":
        # Hashes come from the manifest, which check_folder.py has already
        # proved matches the bytes on disk. Rehashing here would just relocate
        # that check somewhere nobody runs.
        missing = [rid for rid in row["report_ids"].split()
                   if not manifest.get(rid, {}).get("file_sha256")]
        if missing:
            print("FAIL: no file_sha256 in the manifest for %s"
                  % " ".join(missing), file=sys.stderr)
            return 1
        row["model"] = model
        row["extractor"] = model
        row["prompt_file"] = PROMPT
        row["prompt_sha256"] = sha256_file(PROMPT)
        row["started_utc"] = now
        row["pdf_sha256"] = " ".join(
            "%s:%s" % (rid, manifest[rid]["file_sha256"][:16])
            for rid in row["report_ids"].split())
        row["status"] = "running"
    elif status == "complete":
        marker = os.path.join(SHARD_ROOT, batch_id, "COMPLETE")
        if not os.path.exists(marker):
            print("FAIL: %s has no COMPLETE marker; the batch is not finished"
                  % batch_id, file=sys.stderr)
            return 1
        row["completed_utc"] = now
        row["shard_sha256"] = shard_hash(batch_id)
        row["status"] = "complete"
    else:
        print("FAIL: status must be running or complete", file=sys.stderr)
        return 1

    with open(LEDGER, "w", newline="", encoding="utf-8") as fh:
        writer = csv.DictWriter(fh, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

    print("%s -> %s" % (batch_id, row["status"]))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
