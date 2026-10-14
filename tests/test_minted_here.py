# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# SPDX-License-Identifier: GPL-3.0-or-later
"""make dist says which minted skills are not minted here (2026-09-28)."""
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from polygram import dist  # noqa: E402


def mk(root: Path, name: str, text: str) -> None:
    (root / name).mkdir(parents=True)
    (root / name / "SKILL.md").write_text(text, encoding="utf-8", newline="")


class MintedHere(unittest.TestCase):
    def setUp(self):
        self.t = tempfile.TemporaryDirectory()
        base = Path(self.t.name)
        self.garden, self.canon = base / "skills", base / "canon"
        self.garden.mkdir()
        self.canon.mkdir()

    def tearDown(self):
        self.t.cleanup()

    def lines(self):
        skills = dist.collect(self.garden, [self.canon], family_only=False)
        return dist.minted_elsewhere(skills, [self.canon])

    def test_canon_only_skill_is_said(self):
        mk(self.canon, "c1", "---\nname: c1\ndescription: x\n---\nbody\n")
        got = self.lines()
        self.assertEqual(len(got), 1)
        self.assertIn("c1 comes from", got[0])
        self.assertIn("not skills/", got[0])

    def test_same_text_in_both_is_silent(self):
        text = "---\nname: c2\ndescription: x\n---\nbody\n"
        mk(self.garden, "c2", text)
        mk(self.canon, "c2", text.replace("\n", "  \r\n"))  # canonical form: same
        self.assertEqual(self.lines(), [])

    def test_garden_drift_is_said_and_garden_wins(self):
        mk(self.garden, "c3", "---\nname: c3\ndescription: x\n---\nnew\n")
        mk(self.canon, "c3", "---\nname: c3\ndescription: x\n---\nold\n")
        got = self.lines()
        self.assertEqual(len(got), 1)
        self.assertIn("skills/c3/SKILL.md differs", got[0])
        skills = dist.collect(self.garden, [self.canon], family_only=False)
        self.assertEqual([s.origin for s in skills], ["workspace"])


if __name__ == "__main__":
    unittest.main()
