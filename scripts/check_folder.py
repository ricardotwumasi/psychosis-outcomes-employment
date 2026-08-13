# =============================================================================
# check_folder.py
#
# The gate between screening and extraction. It answers one question: does
# `Data Extraction Papers/` hold exactly one readable PDF for every study that
# passed screening, and does the manifest describe what is actually on disk?
#
# Run it before any extraction batch, and again after adding or removing a PDF:
#
#     /opt/anaconda3/bin/python3 scripts/check_folder.py
#
# Exit status 0 means the folder is frozen and extraction may start. Any other
# status names the studies at fault. It is written in Python rather than R
# because poppler is not installed on this machine, so PyMuPDF is the only
# working PDF reader, and openpyxl is needed to read the screening spreadsheet.
#
# The xlsx-to-manifest mapping is NOT recomputed here. It was resolved once,
# by DOI and then by title, and recorded in the manifest's `screening_row`
# column. This script checks that recorded mapping is complete and consistent,
# so a fuzzy title match can never silently change which study a row means.
# =============================================================================
import csv
import hashlib
import os
import re
import sys
import unicodedata

MANIFEST = "data/inclusion_manifest.csv"
XLSX = "DATA_EXTRACTION_FINAL.xlsx"
PAPERS = "dissertation_shared_folder/Data Extraction Papers"

# Studies the screening sheet records under a different DOI from the manifest,
# with the reason. Each entry is a deliberate, checked exception: the two DOIs
# must denote the same work. Anything not listed here is reported as a fault.
DOI_ALIASES = {
    "twumasi2026": ("10.64898/2026.01.07.26343585",
                    "screening used the medRxiv preprint; the manifest holds the "
                    "published Psychological Medicine DOI for the same paper"),
}

failures = []
warnings = []


def fail(section, lines):
    if lines:
        failures.append((section, lines))


def warn(section, lines):
    if lines:
        warnings.append((section, lines))


def nfc(s):
    return unicodedata.normalize("NFC", s or "")


def clean_doi(d):
    d = str(d or "").strip().lower()
    d = re.sub(r"^https?://(dx\.)?doi\.org/", "", d)
    # the screening sheet carries trailing record junk such as "  PT  - Article"
    d = re.split(r"\s{2,}|\s+pt\s+-", d)[0].strip().rstrip(".")
    return d if d.startswith("10.") else ""


def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as fh:
        for block in iter(lambda: fh.read(1 << 20), b""):
            h.update(block)
    return h.hexdigest()


def main():
    for path in (MANIFEST, XLSX, PAPERS):
        if not os.path.exists(path):
            print("cannot run: %s not found. Run from the repository root." % path)
            return 2

    import openpyxl
    wb = openpyxl.load_workbook(XLSX, data_only=True)
    xlsx = {}
    for i, r in enumerate(wb.active.iter_rows(min_row=2, values_only=True), start=2):
        if r[0] is None and r[1] is None:
            continue
        xlsx[i] = {"title": (r[0] or "").strip(), "doi": clean_doi(r[1]), "notes": r[4]}

    manifest = list(csv.DictReader(open(MANIFEST, newline="", encoding="utf-8")))
    for col in ("screening_list", "screening_row", "source_available", "file_sha256"):
        if col not in manifest[0]:
            print("cannot run: %s has no `%s` column." % (MANIFEST, col))
            return 2

    on_disk = {nfc(f) for f in os.listdir(PAPERS) if f.lower().endswith(".pdf")}

    # 1. every screened-in study maps to exactly one manifest row --------------
    claimed = {}
    for m in manifest:
        row = m["screening_row"].strip()
        if m["screening_list"] == "yes":
            if not row:
                fail("screening_list=yes with no screening_row", ["%s" % m["report_id"]])
            else:
                claimed.setdefault(int(row), []).append(m)
        elif row:
            fail("screening_row set but screening_list is not yes", ["%s" % m["report_id"]])

    fail("screened-in studies with no manifest row",
         ["xlsx row %d: %s" % (i, xlsx[i]["title"][:88]) for i in sorted(xlsx) if i not in claimed])
    fail("screening rows claimed by more than one manifest row",
         ["xlsx row %d claimed by %s" % (i, ", ".join(x["report_id"] for x in ms))
          for i, ms in sorted(claimed.items()) if len(ms) > 1])
    fail("screening_row pointing outside the spreadsheet",
         ["%s -> row %d" % (ms[0]["report_id"], i) for i, ms in sorted(claimed.items()) if i not in xlsx])

    # a recorded mapping must still agree with the spreadsheet's own DOI
    mismatched, aliased = [], []
    for i, ms in sorted(claimed.items()):
        if i not in xlsx:
            continue
        rid = ms[0]["report_id"]
        xd, md = xlsx[i]["doi"], clean_doi(ms[0]["doi"])
        if not (xd and md) or xd == md or md.startswith(xd):
            continue
        alias = DOI_ALIASES.get(rid)
        if alias and alias[0] == xd:
            aliased.append("%-16s %s: %s" % (rid, xd, alias[1]))
        else:
            mismatched.append("xlsx row %d %s != %s %s" % (i, xd, rid, md))
    fail("screening_row mapped to a row with a different DOI", mismatched)
    warn("DOI differs from the screening sheet, accepted (recorded, not an error)", aliased)

    # 2. manifest and disk agree ----------------------------------------------
    expected = {}
    missing_pdf = []
    for m in manifest:
        name = nfc(m["source_filename"])
        if m["source_available"] == "yes":
            expected[name] = m
            if name not in on_disk:
                missing_pdf.append("%-20s %s" % (m["report_id"], m["source_filename"]))
        elif name in on_disk:
            fail("PDF present but manifest says source_available=no",
                 ["%-20s %s" % (m["report_id"], m["source_filename"])])
    fail("manifest says source_available=yes but the PDF is absent", missing_pdf)
    fail("PDF on disk with no manifest row", sorted(on_disk - set(expected)))

    # 3. content integrity -----------------------------------------------------
    drifted, unreadable = [], []
    for name, m in sorted(expected.items()):
        path = os.path.join(PAPERS, name)
        if not os.path.exists(path):
            continue
        if m["file_sha256"] and sha256(path) != m["file_sha256"]:
            drifted.append("%-20s %s" % (m["report_id"], name))
        try:
            import fitz
            doc = fitz.open(path)
            text = doc[0].get_text().strip() if doc.page_count else ""
            doc.close()
            if len(text) < 200:
                unreadable.append("%-20s %s (page 1 yielded %d characters)"
                                  % (m["report_id"], name, len(text)))
        except Exception as exc:
            unreadable.append("%-20s %s (%s)" % (m["report_id"], name, exc))
    fail("file changed since the manifest hash was recorded", drifted)
    fail("PDF unreadable or image-only, so no text can be extracted", unreadable)

    # 4. outstanding studies ---------------------------------------------------
    pending = [m for m in manifest
               if m["screening_list"] == "yes" and m["source_available"] != "yes"
               and m["eligibility_status"] != "duplicate"]
    fail("screened in but no PDF held",
         ["%-16s %-24s %s" % (m["report_id"], m["doi"], m["title"][:70]) for m in pending])

    off_list = [m for m in manifest if m["screening_list"] == "no"]
    warn("manifest rows not on the screening list (recorded, not an error)",
         ["%-20s %-14s source_available=%s" % (m["report_id"], m["eligibility_status"], m["source_available"])
          for m in off_list])

    # report -------------------------------------------------------------------
    held = len([m for m in manifest if m["screening_list"] == "yes" and m["source_available"] == "yes"])
    print("screened-in studies : %d" % len(xlsx))
    print("PDFs held for them  : %d" % held)
    print("PDFs in the folder  : %d" % len(on_disk))
    for section, lines in warnings:
        print("\nnote: %s (%d)" % (section, len(lines)))
        for line in lines:
            print("   %s" % line)
    if not failures:
        print("\nOK: all %d screened-in studies have a readable PDF and the manifest matches the folder." % len(xlsx))
        return 0
    for section, lines in failures:
        print("\nFAIL: %s (%d)" % (section, len(lines)))
        for line in lines:
            print("   %s" % line)
    print("\n%d check(s) failed. Extraction must not start until these are resolved." % len(failures))
    return 1


if __name__ == "__main__":
    sys.exit(main())
