# =============================================================================
# apply_stage_f_renames.py
#
# Applies report_id renames established by a Stage F full-text read, to
# `data/inclusion_manifest.csv` and `data/batch_ledger.csv`.
#
# Renames are applied ahead of the Stage G merge, unlike every other manifest
# change in the shards, because `report_id` is the join key. A ledger naming one
# id and a shard naming another cannot be reconciled by inspection later, and a
# stale id silently joins to nothing.
#
# Each entry records what the paper showed. This is not a tidy-up: it is a
# correction to what the review believes a staged file IS.
#
#     python3 scripts/apply_stage_f_renames.py
#
# Idempotent. Run it twice; the second run reports no changes.
# =============================================================================
import csv
import sys

MANIFEST = "data/inclusion_manifest.csv"
LEDGER = "data/batch_ledger.csv"

# old_id -> (new_id, {field: value}, evidence)
RENAMES = {
    "unknown2022": (
        "khare2022b",
        {
            "first_author": "Khare",
            "doi": "10.1037/prj0000512",
            "title": ("A 1-Year Prospective Study of Employment in People With "
                      "Severe Mental Illnesses Receiving Public Sector "
                      "Psychiatric Services in India"),
        },
        "F04 read the PDF: 2022-23727-001.pdf is the complete article "
        "(Psychiatric Rehabilitation Journal 2022;45(3):237-246), not the "
        "supplement the manifest took it for. The staged DOI was the "
        "supplemental-materials record's; the article DOI printed on p. 237 is "
        "10.1037/prj0000512, which is exactly what screening row 20 holds, so "
        "this correction removes a DOI divergence rather than creating one. "
        "khare2022 was already taken by the Schizophrenia Research: Cognition "
        "companion on the same cohort, hence the letter suffix.",
    ),
}


def load(path):
    with open(path, newline="", encoding="utf-8") as fh:
        reader = csv.DictReader(fh)
        return reader.fieldnames, list(reader)


def save(path, fieldnames, rows):
    with open(path, "w", newline="", encoding="utf-8") as fh:
        writer = csv.DictWriter(fh, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def main():
    changes = []

    fn, manifest = load(MANIFEST)
    ids = {r["report_id"] for r in manifest}
    for old, (new, fields, why) in RENAMES.items():
        if new in ids and old not in ids:
            continue                      # already applied
        if new in ids and old in ids:
            print("FAIL: both %s and %s are in the manifest; resolve by hand"
                  % (old, new), file=sys.stderr)
            return 1
        for r in manifest:
            if r["report_id"] != old:
                continue
            r["report_id"] = new
            for k, v in fields.items():
                r[k] = v
            r["notes"] = ("report_id corrected from %s on 12 August 2026. %s %s"
                          % (old, why, r["notes"])).strip()
            changes.append("manifest: %s -> %s" % (old, new))
    if changes:
        save(MANIFEST, fn, manifest)

    fn, ledger = load(LEDGER)
    for old, (new, _, _) in RENAMES.items():
        for r in ledger:
            parts = r["report_ids"].split()
            if old in parts:
                r["report_ids"] = " ".join(new if p == old else p for p in parts)
                changes.append("ledger %s: %s -> %s" % (r["batch_id"], old, new))
                # pdf_sha256 carries the id alongside each hash
                r["pdf_sha256"] = " ".join(
                    (new + h[len(old):]) if h.startswith(old + ":") else h
                    for h in r["pdf_sha256"].split())
    if any(c.startswith("ledger") for c in changes):
        save(LEDGER, fn, ledger)

    if not changes:
        print("no changes")
        return 0
    for c in changes:
        print(c)
    return 0


if __name__ == "__main__":
    sys.exit(main())
