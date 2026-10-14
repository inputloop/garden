# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
"""End-to-end + unit tests for polygram (stdlib unittest only)."""

import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from polygram import config, gate, memory, synth  # noqa: E402


NOTE_FLAGGED = """\
---
name: prefers-concise
type: feedback
---
# Keep replies concise :SKILL:
User wants tight answers. #concise
"""

NOTE_A = """\
# Shell tooling notes
Delegates to POSIX shell. #shell-tooling
"""

NOTE_B = """\
# More shell tooling
Reuse across skills. #shell-tooling
"""


def _workspace_with_notes(tmp: Path) -> config.Workspace:
    ws = config.Workspace(tmp).ensure()
    (ws.memory / "a.md").write_text(NOTE_FLAGGED, encoding="utf-8", newline="")
    (ws.memory / "b.md").write_text(NOTE_A, encoding="utf-8", newline="")
    (ws.memory / "c.md").write_text(NOTE_B, encoding="utf-8", newline="")
    return ws


class TestMemory(unittest.TestCase):
    def test_org_and_hashtags_parsed(self):
        with tempfile.TemporaryDirectory() as d:
            p = Path(d) / "n.md"
            p.write_text(NOTE_FLAGGED, encoding="utf-8", newline="")
            note = memory.parse_note(p)
            self.assertIn("skill", note.all_tags)
            self.assertIn("concise", note.all_tags)
            self.assertEqual(note.note_type, "feedback")

    def test_candidates_threshold_and_force(self):
        with tempfile.TemporaryDirectory() as d:
            ws = _workspace_with_notes(Path(d))
            notes = memory.load_notes(ws.memory)
            labels = {c.label for c in memory.candidates(notes, threshold=2)}
            # shell-tooling appears twice -> surfaces by frequency
            self.assertIn("shell-tooling", labels)
            # 'concise' is force-promoted by the :SKILL: control tag on its note
            self.assertIn("concise", labels)
            # the control tag itself is never a candidate
            self.assertNotIn("skill", labels)

    def test_index_excluded(self):
        with tempfile.TemporaryDirectory() as d:
            ws = _workspace_with_notes(Path(d))
            (ws.memory / "MEMORY.md").write_text("# noise #ignored", encoding="utf-8", newline="")
            notes = memory.load_notes(ws.memory)
            self.assertTrue(all(n.path.name != "MEMORY.md" for n in notes))


class TestGate(unittest.TestCase):
    def test_corroborated_passes(self):
        c = memory.Candidate(label="shell-tooling", weight=2,
                             sources=[Path("a"), Path("b")],
                             reason="appears in 2 notes")
        v = gate.evaluate(c)
        self.assertEqual(v.decision, gate.PASS)

    def test_generic_rejected(self):
        c = memory.Candidate(label="misc", weight=2,
                             sources=[Path("a")], reason="single")
        v = gate.evaluate(c)
        self.assertEqual(v.decision, gate.REJECT)

    def test_advice_written(self):
        with tempfile.TemporaryDirectory() as d:
            c = memory.Candidate(label="x-tool", weight=2,
                                 sources=[Path("a"), Path("b")],
                                 reason="appears in 2 notes")
            v = gate.evaluate(c)
            p = gate.record_advice(Path(d), v)
            self.assertTrue(p.exists())
            self.assertIn("decision: PASS", p.read_text(encoding="utf-8"))
            self.assertRegex(p.name, r"^\d{8}-\d{6}Z-", "ERRATA E7: the stamp is UTC and says so")
            import datetime as _d
            q = gate.record_advice(Path(d), v, now=_d.datetime(2026, 9, 28, 21, 19, 14, tzinfo=_d.timezone(_d.timedelta(hours=-5))))
            self.assertTrue(q.name.startswith("20260929-021914Z-"), q.name)


class TestSynth(unittest.TestCase):
    def test_synth_creates_then_idempotent(self):
        with tempfile.TemporaryDirectory() as d:
            skills = Path(d) / "skills"
            c = memory.Candidate(label="shell-tooling", weight=2,
                                 sources=[Path("a"), Path("b")],
                                 reason="appears in 2 notes")
            v = gate.evaluate(c)
            s1 = synth.synthesize(skills, v)
            self.assertTrue(s1.created and s1.skill_md.exists())
            s2 = synth.synthesize(skills, v)
            self.assertFalse(s2.created)

    def test_refuses_closed_gate(self):
        c = memory.Candidate(label="misc", weight=1, sources=[Path("a")],
                             reason="single")
        v = gate.evaluate(c)
        with self.assertRaises(ValueError):
            synth.synthesize(Path("/tmp/nope"), v)


class TestEndToEnd(unittest.TestCase):
    def test_full_pipeline(self):
        with tempfile.TemporaryDirectory() as d:
            ws = _workspace_with_notes(Path(d))
            notes = memory.load_notes(ws.memory)
            made = 0
            for c in memory.candidates(notes, threshold=2):
                v = gate.evaluate(c)
                gate.record_advice(ws.advice, v)
                if v.gated_open:
                    synth.synthesize(ws.skills, v)
                    made += 1
            self.assertGreaterEqual(made, 1)
            self.assertTrue(any(ws.skills.rglob("SKILL.md")))
            self.assertTrue(any(ws.advice.glob("*.md")))


if __name__ == "__main__":
    unittest.main(verbosity=2)
