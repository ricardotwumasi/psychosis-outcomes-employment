# =============================================================================
# manifest_hygiene_v02.py
#
#     python3 scripts/manifest_hygiene_v02.py --check
#     python3 scripts/manifest_hygiene_v02.py
#
# Two corrections to data/inclusion_manifest.csv, plus the columns the author-
# query cycle needs. Idempotent.
#
# 1. THE OFF-LIST RECORDS ARE NOT ELIGIBILITY DECISIONS.
#
#    Six manifest rows were never on the DATA_EXTRACTION_FINAL.xlsx screening
#    list of 90. Three of them (bjornsdottir2022, mackinley2022, peralta2025)
#    still carry eligibility_status = include while also carrying
#    source_available = no, which is a contradiction: a report cannot be
#    included on the strength of a PDF that was deleted. Left as they are they
#    would enter the PRISMA eligibility flow, making the review appear to have
#    assessed 96 reports and included 62.
#
#    They become `not_in_screening_set`, which is a disposition rather than an
#    eligibility judgement. The rows stay, because deleting them would erase the
#    audit trail of what was staged and why it was removed.
#
#    This is NOT a claim that the three are ineligible. Two of them plainly
#    report usable figures (peralta2025 80/243 in paid work at ~21 years,
#    bjornsdottir2022 54/144 at discharge). It is a claim that they were never
#    screened in, and that a report cannot enter a synthesis without passing the
#    screening it is supposed to have passed. If the team wants them, the route
#    is a documented screening-list amendment, not a quiet `include`.
#
# 2. COLUMNS FOR THE AUTHOR-QUERY CYCLE.
#
#    report_quantifiable separates "eligible" from "yielded a usable count", so
#    a report that meets every criterion but prints only a percentage stays
#    visible as eligible evidence the review could not use. Left blank here and
#    filled by the Stage F re-read.
#
#    The three data_request_* columns carry only non-sensitive status and dates.
#    Author names and email addresses go in private/contact_log.csv, which is
#    gitignored: correspondence with a named individual does not belong in a
#    public repository.
# =============================================================================
import argparse
import csv
import os
import sys

MANIFEST = "data/inclusion_manifest.csv"

NEW_COLUMNS = [
    ("eligibility_status", ["report_quantifiable"]),
    (None, ["data_request_status", "data_request_date", "data_response_date"]),
]


def main(check_only):
    with open(MANIFEST, newline="", encoding="utf-8") as fh:
        rdr = csv.DictReader(fh)
        header = list(rdr.fieldnames)
        rows = list(rdr)

    changes = []

    for anchor, cols in NEW_COLUMNS:
        cols = [c for c in cols if c not in header]
        if not cols:
            continue
        if anchor is None or anchor not in header:
            header.extend(cols)
        else:
            at = header.index(anchor) + 1
            header[at:at] = cols
        changes.append("added columns: %s" % ", ".join(cols))
        for r in rows:
            for c in cols:
                r.setdefault(c, "")

    for r in rows:
        for c in header:
            r.setdefault(c, "")

    # The screening list is the authority for what is in the review.
    offlist = [r for r in rows if r["screening_list"] == "no"]
    for r in offlist:
        if r["eligibility_status"] != "not_in_screening_set":
            was = r["eligibility_status"]
            r["eligibility_status"] = "not_in_screening_set"
            r["exclusion_reason"] = "not_applicable"
            note = ("DISPOSITION 11 August 2026: was `%s`. Not on the "
                    "DATA_EXTRACTION_FINAL.xlsx screening list of 90, so this is "
                    "not an eligibility decision and the row is not counted in "
                    "the PRISMA eligibility flow. Reinstating it requires a "
                    "documented screening-list amendment, not a status change."
                    % was)
            r["notes"] = (r["notes"] + " | " + note) if r["notes"] else note
            changes.append("%s: eligibility_status %s -> not_in_screening_set"
                           % (r["report_id"], was))

    onlist = [r for r in rows if r["screening_list"] == "yes"]
    print("screening list rows : %d" % len(onlist))
    print("off-list audit rows : %d" % len(offlist))

    if not changes:
        print("nothing to do: manifest already correct")
        return 0
    for c in changes:
        print(("would apply: " if check_only else "applied: ") + c)

    if not check_only:
        with open(MANIFEST, "w", newline="", encoding="utf-8") as fh:
            w = csv.DictWriter(fh, fieldnames=header, lineterminator="\n")
            w.writeheader()
            w.writerows(rows)
    else:
        print("\n--check: no files written")
    return 0


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true")
    args = ap.parse_args()
    os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    sys.exit(main(args.check))
