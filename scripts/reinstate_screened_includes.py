# =============================================================================
# reinstate_screened_includes.py
#
# D8 froze `DATA_EXTRACTION_FINAL.xlsx` as the authoritative screening record.
# All 90 of its rows are marked INCLUDE. Twenty-one manifest rows nevertheless
# carried `eligibility_status = exclude` with reason `no_extractable_data`,
# which is not a screening decision at all: it is a judgement, made here and
# from an incomplete read, that the report prints no recoverable numerator and
# denominator. D10.2 already ruled that the two must not be conflated, because
# an exclusion removes a report from the eligible count while an eligible but
# unquantifiable report belongs in the missing-evidence assessment where a
# reader can see it.
#
# This script settles that. The 21 return to `include`, and `report_quantifiable`
# is left blank for the Stage F re-read to fill from the paper. Nothing here
# asserts the reports are usable; it asserts only that nobody excluded them.
#
# Idempotent, like the other migrations in this folder: run it twice and the
# second run reports no changes. Run it after any script that rewrites
# `eligibility_status`.
#
#     python3 scripts/reinstate_screened_includes.py
# =============================================================================
import csv
import sys

MANIFEST = "data/inclusion_manifest.csv"


def main():
    with open(MANIFEST, newline="", encoding="utf-8") as fh:
        reader = csv.DictReader(fh)
        fieldnames = reader.fieldnames
        rows = list(reader)

    changes = []
    for r in rows:
        # Only rows the screening sheet actually carries. The six
        # `not_in_screening_set` rows are untouched: D10.1 keeps them out, and a
        # frozen universe makes that firmer, not weaker.
        if r["screening_list"] != "yes":
            continue
        if r["eligibility_status"] == "exclude" \
                and r["exclusion_reason"] == "no_extractable_data":
            r["eligibility_status"] = "include"
            r["exclusion_reason"] = "not_applicable"
            changes.append("%s: exclude/no_extractable_data -> include, "
                           "report_quantifiable left blank for the re-read"
                           % r["report_id"])

    if not changes:
        print("no changes")
        return 0

    with open(MANIFEST, "w", newline="", encoding="utf-8") as fh:
        writer = csv.DictWriter(fh, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

    for c in changes:
        print(c)
    print("%d rows changed" % len(changes))
    return 0


if __name__ == "__main__":
    sys.exit(main())
