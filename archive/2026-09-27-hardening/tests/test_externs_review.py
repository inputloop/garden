# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
"""Tests for externs (freeze) and the HOLD review command (stdlib unittest)."""

import contextlib
import io
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from polygram import cli, config, review  # noqa: E402
from polygram.externs import Manifest, ManifestError  # noqa: E402


# Forced to surface via :SKILL:, single source + well-formed label -> score 1
# -> HOLD (the operator flag surfaces it but adds no score).
HELD_NOTE = "# Color theory helper :SKILL:\nNotes on palettes. #color-theory\n"


def _ws(tmp: Path) -> config.Workspace:
    return config.Workspace(tmp).ensure()


class TestManifestFreeze(unittest.TestCase):
    def test_add_get_persist(self):
        with tempfile.TemporaryDirectory() as d:
            mpath = Path(d) / "externs.json"
            m = Manifest.load(mpath)
            m.add("savane", "https://example.com/savane.git", ref="main")
            m.save()
            again = Manifest.load(mpath)
            self.assertEqual(again.get("savane").url,
                             "https://example.com/savane.git")

    def test_freeze_unfreeze(self):
        with tempfile.TemporaryDirectory() as d:
            m = Manifest.load(Path(d) / "externs.json")
            e = m.add("up", "https://x/up.git")
            e.rev = "deadbeefcafe"
            m.freeze("up")  # defaults to current rev
            self.assertTrue(m.get("up").frozen)
            self.assertEqual(m.get("up").frozen_rev, "deadbeefcafe")
            self.assertEqual(m.get("up").pinned_rev(), "deadbeefcafe")
            m.unfreeze("up")
            self.assertFalse(m.get("up").frozen)
            self.assertEqual(m.get("up").frozen_rev, "")

    def test_freeze_explicit_rev(self):
        with tempfile.TemporaryDirectory() as d:
            m = Manifest.load(Path(d) / "externs.json")
            m.add("up", "https://x/up.git")
            m.freeze("up", rev="abc1234")
            self.assertEqual(m.get("up").frozen_rev, "abc1234")

    def test_owning_extern(self):
        with tempfile.TemporaryDirectory() as d:
            ws = _ws(Path(d))
            m = Manifest.load(ws.externs_manifest)
            m.add("savane", "https://x/savane.git")
            clone = ws.externs / "savane" / "memory" / "n.md"
            clone.parent.mkdir(parents=True, exist_ok=True)
            clone.write_text("# x #y", encoding="utf-8", newline="")
            owner = m.owning_extern(clone, ws.externs)
            self.assertIsNotNone(owner)
            self.assertEqual(owner.name, "savane")
            outside = m.owning_extern(ws.memory / "z.md", ws.externs)
            self.assertIsNone(outside)


class TestReview(unittest.TestCase):
    def _held_ws(self, d: Path) -> config.Workspace:
        ws = _ws(d)
        (ws.memory / "color.md").write_text(HELD_NOTE, encoding="utf-8", newline="")
        return ws

    def test_held_listed(self):
        with tempfile.TemporaryDirectory() as d:
            ws = self._held_ws(Path(d))
            m = Manifest.load(ws.externs_manifest)
            items = review.build(ws, m, threshold=2)
            labels = {it.candidate.label for it in review.held(items)}
            self.assertIn("color-theory", labels)

    def test_promote_synthesizes(self):
        with tempfile.TemporaryDirectory() as d:
            ws = self._held_ws(Path(d))
            m = Manifest.load(ws.externs_manifest)
            items = review.build(ws, m, threshold=2)
            it = review.find(items, "color-theory")
            s = review.promote(ws, it)
            self.assertTrue(s.created and s.skill_md.exists())
            txt = "".join(p.read_text(encoding="utf-8") for p in ws.advice.glob("*.md"))
            self.assertIn("operator promoted", txt)

    def test_reject_records_advice(self):
        with tempfile.TemporaryDirectory() as d:
            ws = self._held_ws(Path(d))
            m = Manifest.load(ws.externs_manifest)
            items = review.build(ws, m, threshold=2)
            it = review.find(items, "color-theory")
            p = review.reject(ws, it)
            self.assertTrue(p.exists())
            self.assertIn("decision: REJECT", p.read_text(encoding="utf-8"))

    def test_held_from_frozen_extern_flagged(self):
        with tempfile.TemporaryDirectory() as d:
            ws = _ws(Path(d))
            m = Manifest.load(ws.externs_manifest)
            m.add("up", "https://x/up.git")
            m.freeze("up", rev="abc1234")
            m.save()
            # the held candidate's note lives in the frozen extern's memory/
            # (externs feed candidates only via their polygram-native memory/)
            note = ws.externs / "up" / "memory" / "color.md"
            note.parent.mkdir(parents=True, exist_ok=True)
            note.write_text(HELD_NOTE, encoding="utf-8", newline="")
            items = review.build(ws, m, threshold=2)
            it = review.find(items, "color-theory")
            self.assertIsNotNone(it)
            self.assertEqual(it.extern.name, "up")
            self.assertTrue(it.from_frozen)


class TestManifestIntegrity(unittest.TestCase):
    """Robustness gaps exposed by the 2026-06-27 externs.json truncation."""

    def test_load_truncated_raises_manifest_error(self):
        with tempfile.TemporaryDirectory() as d:
            mpath = Path(d) / "externs.json"
            # Mid-write truncation: valid prefix, no closing braces.
            mpath.write_text('{\n  "up": {\n    "name": "up",\n    "url": "',
                             encoding="utf-8", newline="")
            with self.assertRaises(ManifestError):
                Manifest.load(mpath)

    def test_load_non_object_raises(self):
        with tempfile.TemporaryDirectory() as d:
            mpath = Path(d) / "externs.json"
            mpath.write_text("[1, 2, 3]", encoding="utf-8", newline="")
            with self.assertRaises(ManifestError):
                Manifest.load(mpath)

    def test_load_bad_record_raises(self):
        with tempfile.TemporaryDirectory() as d:
            mpath = Path(d) / "externs.json"
            mpath.write_text('{"up": {"bogus_field": 1}}', encoding="utf-8", newline="")
            with self.assertRaises(ManifestError):
                Manifest.load(mpath)

    def test_save_is_atomic_and_leaves_no_tmp(self):
        with tempfile.TemporaryDirectory() as d:
            mpath = Path(d) / "externs.json"
            m = Manifest.load(mpath)
            m.add("up", "https://x/up.git")
            m.save()
            self.assertFalse(mpath.with_name(mpath.name + ".tmp").exists())
            # Round-trips cleanly through the guarded loader.
            self.assertIn("up", Manifest.load(mpath).externs)

    def test_reconcile_flags_missing_clone(self):
        with tempfile.TemporaryDirectory() as d:
            ws = _ws(Path(d))
            m = Manifest.load(ws.externs_manifest)
            m.add("up", "https://x/up.git")
            problems = m.reconcile(ws.externs)
            self.assertTrue(any("not cloned" in p for p in problems))

    def test_reconcile_flags_unregistered_dir(self):
        with tempfile.TemporaryDirectory() as d:
            ws = _ws(Path(d))
            m = Manifest.load(ws.externs_manifest)
            (ws.externs / "stray").mkdir(parents=True, exist_ok=True)
            problems = m.reconcile(ws.externs)
            self.assertTrue(any("not in the manifest" in p for p in problems))

    def test_doctor_reports_corrupt_manifest(self):
        with tempfile.TemporaryDirectory() as d:
            ws = _ws(Path(d))
            ws.externs_manifest.write_text('{"up": ', encoding="utf-8", newline="")
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                rc = cli.main(["-C", str(ws.root), "doctor"])
            self.assertEqual(rc, 1)
            self.assertIn("CORRUPT", buf.getvalue())

    def test_doctor_ok_on_clean_workspace(self):
        with tempfile.TemporaryDirectory() as d:
            ws = _ws(Path(d))  # no externs registered
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                rc = cli.main(["-C", str(ws.root), "doctor"])
            self.assertEqual(rc, 0)


if __name__ == "__main__":
    unittest.main(verbosity=2)
