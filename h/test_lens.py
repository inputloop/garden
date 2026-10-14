#!/usr/bin/env python3
"""Tests for lens - stdlib unittest. Run: python3 -m unittest test_lens -v"""
import json
import os
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lens  # noqa: E402
import ferry_core as fc  # noqa: E402


class Base(unittest.TestCase):
    def setUp(self):
        self.d = tempfile.TemporaryDirectory()
        p = self.d.name
        self.subjects = os.path.join(p, "subjects.tsv")
        self.lens = os.path.join(p, "lens.tsv")
        self.rec = os.path.join(p, "receipts.log")
        self.material = os.path.join(p, "card.md")
        with open(self.material, "w") as fh:
            fh.write("it is about TRUST\n")

    def tearDown(self):
        self.d.cleanup()

    def pin(self, notes=True):
        return lens.pin(self.material, "the card", self.subjects, self.rec,
                        notes_ok=notes, subj_id="card")


class TestPinAndShare(Base):
    def test_pin_records_sha(self):
        rec = self.pin()
        self.assertEqual(rec["sha256"], fc.sha256_file(self.material))

    def test_add_requires_pinned_subject(self):
        with self.assertRaises(KeyError):
            lens.add_reading(self.subjects, self.lens, self.rec, "card",
                             "claude", "a_self", "x", "y")

    def test_reading_carries_pinned_sha(self):
        self.pin()
        r = lens.add_reading(self.subjects, self.lens, self.rec, "card",
                             "claude", "a_self", "instrument-node", "iT is a role")
        self.assertEqual(r["subject_sha"], fc.sha256_file(self.material))


class TestConverge(Base):
    def _two_models(self, s_claude, s_copilot, view="c_infl_on_mine"):
        self.pin()
        lens.add_reading(self.subjects, self.lens, self.rec, "card", "claude",
                         view, s_claude, "claude claim")
        lens.add_reading(self.subjects, self.lens, self.rec, "card", "copilot",
                         view, s_copilot, "copilot claim")

    def test_diverge_when_stances_differ(self):
        # the 'my words win' contrast: copilot asserts user-words dominate,
        # claude holds cross-influence is *watched*, not settled -> DIVERGE
        self._two_models("cross-influence-watched", "user-words-win")
        rep = lens.converge(self.lens, "card", subjects=self.subjects)
        self.assertEqual(rep["per_view"]["c_infl_on_mine"]["verdict"], "DIVERGE")
        self.assertIn("c_infl_on_mine", rep["summary"]["diverging_views"])

    def test_converge_when_stances_match(self):
        self._two_models("cross-influence-watched", "cross-influence-watched")
        rep = lens.converge(self.lens, "card", subjects=self.subjects)
        self.assertEqual(rep["per_view"]["c_infl_on_mine"]["verdict"], "CONVERGE")

    def test_single_and_gap(self):
        self.pin()
        lens.add_reading(self.subjects, self.lens, self.rec, "card", "claude",
                         "a_self", "s", "c")
        rep = lens.converge(self.lens, "card", subjects=self.subjects)
        self.assertEqual(rep["per_view"]["a_self"]["verdict"], "SINGLE")
        self.assertEqual(rep["per_view"]["persona"]["verdict"], "GAP")

    def test_similarity_is_hint_not_verdict(self):
        # identical claims but DIFFERENT stance tokens must still DIVERGE:
        # proves the prose-similarity hint never overrides the stance verdict.
        self.pin()
        lens.add_reading(self.subjects, self.lens, self.rec, "card", "claude",
                         "persona", "stanceA", "same words")
        lens.add_reading(self.subjects, self.lens, self.rec, "card", "copilot",
                         "persona", "stanceB", "same words")
        rep = lens.converge(self.lens, "card", subjects=self.subjects)
        pv = rep["per_view"]["persona"]
        self.assertEqual(pv["verdict"], "DIVERGE")
        self.assertEqual(pv["claim_similarity_hint"], 1.0)  # high, yet DIVERGE

    def test_stale_reading_flagged(self):
        self.pin()
        lens.add_reading(self.subjects, self.lens, self.rec, "card", "claude",
                         "a_self", "s", "c")
        # material changes after the reading -> re-pin -> reading now stale
        with open(self.material, "w") as fh:
            fh.write("changed bytes\n")
        self.pin()
        rep = lens.converge(self.lens, "card", subjects=self.subjects)
        self.assertTrue(rep["summary"]["stale_readings"])


class TestNotesGuard(Base):
    def test_notes_dropped_when_writing_is_danger(self):
        self.pin(notes=False)
        r = lens.add_reading(self.subjects, self.lens, self.rec, "card",
                             "claude", "inverse", "s", "c", note="secret detail")
        self.assertEqual(r["note"], "")


class TestImport(Base):
    def test_import_nested_and_flat(self):
        self.pin()
        nested = {"model": "copilot", "views": {
            "c_infl_on_mine": {"stance": "user-words-win",
                               "claim": "the user's words win"}}}
        flat = [{"model": "gemini", "view": "a_self", "stance": "tool-node",
                 "claim": "reads as an instrument"}]
        f1 = os.path.join(self.d.name, "a.json")
        f2 = os.path.join(self.d.name, "b.json")
        with open(f1, "w") as fh:
            json.dump(nested, fh)
        with open(f2, "w") as fh:
            json.dump(flat, fh)
        self.assertEqual(len(lens.import_json(f1, self.subjects, self.lens,
                                              self.rec, "card")), 1)
        self.assertEqual(len(lens.import_json(f2, self.subjects, self.lens,
                                              self.rec, "card")), 1)
        rep = lens.converge(self.lens, "card", subjects=self.subjects)
        self.assertEqual(rep["summary"]["n_models"], 2)


if __name__ == "__main__":
    unittest.main()
