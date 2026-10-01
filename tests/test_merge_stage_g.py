"""Regression checks for shard changes superseded by a correction ledger."""
import csv
import importlib.util
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

spec = importlib.util.spec_from_file_location(
    "merge_stage_g", Path(__file__).resolve().parents[1] / "scripts/merge_stage_g.py")
merge = importlib.util.module_from_spec(spec)
spec.loader.exec_module(merge)


class ManifestCorrectionChainTests(unittest.TestCase):
    def check_state(self, current, correction=None):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "corrections.csv"
            if correction is not None:
                rows = correction if isinstance(correction, list) else [correction]
                with path.open("w", newline="", encoding="utf-8") as handle:
                    writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
                    writer.writeheader()
                    writer.writerows(rows)
            manifest = [{"report_id": "example", "notes": current}]
            changes = [{"report_id": "example", "field": "notes",
                        "old": "before shard", "new": "after shard", "_batch": "F01"}]
            faults, log = [], []
            with patch.object(merge, "RESULT_CORRECTIONS", str(path)):
                counts = merge.apply_manifest_changes(manifest, changes, faults, log)
            return manifest[0]["notes"], faults, counts

    @staticmethod
    def correction(**overrides):
        return {"table": "inclusion_manifest", "key": "example", "field": "notes",
                "old": "after shard", "new": "adjudicated", "authority": "source review",
                **overrides}

    def test_original_old_and_new_states(self):
        # The three-state rule must keep working without a ledger, or the merge
        # stops being rerunnable.
        self.assertEqual(self.check_state("before shard"), ("after shard", [], (1, 0)))
        self.assertEqual(self.check_state("after shard"), ("after shard", [], (0, 1)))

    def test_exact_authorised_successor_is_preserved(self):
        # A source adjudication recorded in the ledger must survive a rerun: the
        # shard's value must not be written back over it.
        self.assertEqual(self.check_state("adjudicated", self.correction()),
                         ("adjudicated", [], (0, 1)))

    def test_arbitrary_third_value_still_fails(self):
        # A hand edit to the manifest is not a correction. Only the ledger's own
        # new value is accepted in place of the shard's.
        self.assertTrue(self.check_state("unlogged change", self.correction())[1])

    def test_missing_authority_still_fails(self):
        # A correction nobody authorised cannot supersede extracted data.
        self.assertTrue(self.check_state("adjudicated", self.correction(authority=""))[1])

    def test_unlinked_old_value_still_fails(self):
        # The chain must be shard.new -> correction.new. A correction written
        # against some other starting value says nothing about this shard change.
        self.assertTrue(self.check_state("adjudicated", self.correction(old="unrelated"))[1])

    def test_duplicate_corrections_do_not_authorise_a_successor(self):
        # Two ledger rows for one field are ambiguous, so neither is trusted.
        self.assertTrue(self.check_state("adjudicated", [self.correction()] * 2)[1])


class RobCorrectionTests(unittest.TestCase):
    def apply(self, current, **overrides):
        row = {"table": "extraction_rob", "key": "r1__jbi6", "field": "judgement",
               "old": "yes", "new": "unclear", "authority": "source verification",
               **overrides}
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "corrections.csv"
            with path.open("w", newline="", encoding="utf-8") as handle:
                writer = csv.DictWriter(handle, fieldnames=list(row))
                writer.writeheader()
                writer.writerow(row)
            rob = [{"rob_assessment_id": "r1__jbi6", "judgement": current}]
            tables = {"extraction_rob": (["rob_assessment_id", "judgement"], rob)}
            faults, log = [], []
            with patch.object(merge, "RESULT_CORRECTIONS", str(path)):
                counts = merge.apply_result_corrections(tables, faults, log)
            return rob[0]["judgement"], faults, counts

    def test_rob_judgement_is_corrected_through_the_ledger(self):
        # The 187 adjudicated risk-of-bias corrections are rebuilt from the
        # ledger on every merge. If the table were not correctable they would
        # be lost the next time the shards are merged.
        self.assertEqual(self.apply("yes"), ("unclear", [], (1, 0)))
        self.assertEqual(self.apply("unclear"), ("unclear", [], (0, 1)))

    def test_rob_judgement_that_moved_underneath_the_ledger_fails(self):
        # A judgement that is neither the extracted nor the adjudicated value
        # was changed outside the ledger and must stop the merge.
        self.assertTrue(self.apply("no")[1])


class RobAdditionTests(unittest.TestCase):
    FIELDS = ["rob_assessment_id", "result_id", "judgement"]

    def add(self, rob, additions, shard_keys=()):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "additions.csv"
            with path.open("w", newline="", encoding="utf-8") as handle:
                writer = csv.DictWriter(handle, fieldnames=self.FIELDS)
                writer.writeheader()
                writer.writerows(additions)
            faults, log = [], []
            with patch.object(merge, "ROB_ADDITIONS", str(path)):
                out, n = merge.apply_rob_additions(
                    self.FIELDS, rob, [{"result_id": "r1"}], set(shard_keys), faults, log)
            return out, faults

    @staticmethod
    def row(key="G01_r1_jbi1", result="r1", judgement="yes"):
        return {"rob_assessment_id": key, "result_id": result, "judgement": judgement}

    def test_an_added_appraisal_is_present_once_however_often_the_merge_runs(self):
        # The merged table is the base of the next merge. If additions were
        # appended blindly, every rerun would duplicate the appraisal and the
        # result would look twice-assessed.
        once, faults = self.add([], [self.row()])
        twice, _ = self.add(once, [self.row()])
        self.assertEqual((once, faults), ([self.row()], []))
        self.assertEqual(twice, once)

    def test_an_addition_cannot_stand_in_for_a_batch_appraisal(self):
        # A batch row is changed through the ledger, with an authority. An
        # addition under the same key would replace it with no record of why.
        self.assertTrue(self.add([], [self.row()], shard_keys=["G01_r1_jbi1"])[1])

    def test_an_addition_for_a_result_that_does_not_exist_fails(self):
        # An appraisal attached to no result can never be read beside the
        # estimate it is supposed to qualify.
        self.assertTrue(self.add([], [self.row(result="missing")])[1])


if __name__ == "__main__":
    unittest.main()
