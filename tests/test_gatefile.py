# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
"""Tests for the .gate dotfile convention (stdlib unittest only)."""

import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from polygram import gatefile  # noqa: E402


def _gate(dirpath: Path, policy: str, **kw) -> Path:
    lines = [f"policy: {policy}"]
    for k, v in kw.items():
        lines.append(f"{k}: {v}")
    p = dirpath / gatefile.GATE_NAME
    p.write_text("# sign-post\n" + "\n".join(lines) + "\n", encoding="utf-8", newline="")
    return p


class TestParse(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        self.addCleanup(self.tmp.cleanup)

    def test_parses_three_fields_and_comments(self):
        _gate(self.root, "read-only",
              reason="frozen snapshot", since="2026-07-02")
        g = gatefile.parse(self.root / ".gate")
        self.assertEqual(g.policy, "read-only")
        self.assertEqual(g.reason, "frozen snapshot")
        self.assertEqual(g.since, "2026-07-02")
        self.assertEqual(g.root, self.root)

    def test_unknown_keys_preserved_not_fatal(self):
        _gate(self.root, "none", owner="corwin")
        g = gatefile.parse(self.root / ".gate")
        self.assertEqual(g.extra, {"owner": "corwin"})

    def test_bad_policy_fails_closed(self):
        _gate(self.root, "rw")  # not a valid policy
        with self.assertRaises(gatefile.GateError):
            gatefile.parse(self.root / ".gate")

    def test_missing_policy_fails_closed(self):
        (self.root / ".gate").write_text("reason: oops\n", encoding="utf-8", newline="")
        with self.assertRaises(gatefile.GateError):
            gatefile.parse(self.root / ".gate")


class TestNearestWins(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        self.addCleanup(self.tmp.cleanup)
        self.sub = self.root / "private" / "deep"
        self.sub.mkdir(parents=True)

    def test_nearest_gate_governs(self):
        _gate(self.root, "read-write")
        _gate(self.root / "private", "none", reason="family line")
        g = gatefile.nearest(self.sub)
        self.assertEqual(g.policy, "none")
        self.assertEqual(g.root.name, "private")

    def test_falls_back_to_ancestor(self):
        _gate(self.root, "read-only")
        g = gatefile.nearest(self.sub)
        self.assertEqual(g.policy, "read-only")

    def test_ungated_returns_none(self):
        self.assertIsNone(gatefile.nearest(self.sub))

    def test_file_target_uses_parent(self):
        _gate(self.root, "write-only")
        f = self.sub / "note.md"
        f.write_text("x", encoding="utf-8", newline="")
        g = gatefile.nearest(f)
        self.assertEqual(g.policy, "write-only")

    def test_relative_path_resolves_before_walking(self):
        # SAVANNAH cite #2: resolve once, then walk — a relative start
        # must find the same governing sign as its absolute form.
        import os
        _gate(self.root, "read-only")
        cwd = os.getcwd()
        self.addCleanup(os.chdir, cwd)
        os.chdir(self.root)
        g = gatefile.nearest(Path("private/deep"))
        self.assertIsNotNone(g)
        self.assertEqual(g.policy, "read-only")
        self.assertEqual(g.root, self.root.resolve())


class TestCheck(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        self.addCleanup(self.tmp.cleanup)

    def _check(self, op):
        return gatefile.check(self.root / "f.txt", op)

    def test_policy_matrix(self):
        cases = {
            "read-write": {"read": True, "write": True},
            "read-only": {"read": True, "write": False},
            "write-only": {"read": False, "write": True},
            "none": {"read": False, "write": False},
        }
        for policy, ops in cases.items():
            _gate(self.root, policy)
            for op, want in ops.items():
                allowed, g = self._check(op)
                self.assertEqual(allowed, want, f"{policy}/{op}")
                self.assertEqual(g.policy, policy)

    def test_ungated_is_silence_not_consent_marker(self):
        allowed, g = self._check("read")
        self.assertTrue(allowed)
        self.assertIsNone(g)  # caller can distinguish silence from a sign

    def test_unknown_op_raises(self):
        _gate(self.root, "read-write")
        with self.assertRaises(gatefile.GateError):
            gatefile.check(self.root, "execute")


class TestEmbargo(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        self.addCleanup(self.tmp.cleanup)

    def test_embargo_denies_publish_despite_open_policy(self):
        _gate(self.root, "read-write",
              embargo="until users notified", lift="Corwin, by editing this file")
        allowed, g = gatefile.check(self.root / "f", "publish")
        self.assertFalse(allowed)
        self.assertEqual(g.lift, "Corwin, by editing this file")
        # local traffic unaffected: embargo is egress-only
        self.assertTrue(g.allows("read"))
        self.assertTrue(g.allows("write"))

    def test_no_timer_ever_lifts(self):
        # A date long past still denies: a date passing is silence,
        # and silence is not consent.
        _gate(self.root, "read-write", embargo="until 2001-01-01")
        allowed, _ = gatefile.check(self.root, "publish")
        self.assertFalse(allowed)

    def test_no_embargo_allows_publish(self):
        _gate(self.root, "read-only")
        allowed, g = gatefile.check(self.root, "publish")
        self.assertTrue(allowed)
        self.assertIsNotNone(g)

    def test_lift_is_the_edit_itself(self):
        p = _gate(self.root, "read-write", embargo="until terms land")
        self.assertFalse(gatefile.parse(p).allows("publish"))
        # the affirmative human act: the field is removed from the sign
        _gate(self.root, "read-write")
        self.assertTrue(gatefile.parse(p).allows("publish"))

    def test_describe_shows_embargo_and_lift(self):
        _gate(self.root, "read-write", embargo="until proof", lift="2/2 consent-gate")
        d = gatefile.parse(self.root / ".gate").describe()
        self.assertIn("embargo: until proof", d)
        self.assertIn("lift: 2/2 consent-gate", d)


if __name__ == "__main__":
    unittest.main()
