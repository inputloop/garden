# polygram -- gated agent-skill synthesis.
# Copyright (C) 2026 Corwin <mplscorwin@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
# This program is free software: you can redistribute it and/or modify it under the terms
# of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.

"""Durable REJECT: a rejected candidate stays rejected until promoted.

Gap history: `concise` was QC-REJECTED (2026-06-27) and synth cheerfully
re-materialized it during 0.5.4 prep. The ledger is the advice history;
latest terminal decision (PASS/REJECT) per label wins; HOLD never
overrides; review --promote (a later PASS) is the one way through.
"""

import tempfile
import unittest
from pathlib import Path

from polygram import gate
from polygram.memory import Candidate


def _advice(dirp: Path, stamp: str, label: str, decision: str):
    dirp.mkdir(parents=True, exist_ok=True)
    (dirp / f"{stamp}-{label}.md").write_text(
        f"---\ncandidate: {label}\ndecision: {decision}\nscore: 1\n---\n\n# x\n",
        encoding="utf-8", newline="")


def _passing_verdict(label="concise"):
    c = Candidate(label=label, weight=3, sources=[Path("a.md"), Path("b.md")],
                  reason="frequency")
    v = gate.evaluate(c)
    return v


class TestDurableReject(unittest.TestCase):
    def setUp(self):
        self.advice = Path(tempfile.mkdtemp()) / "advice"

    def test_reject_demotes_to_hold_with_named_history(self):
        _advice(self.advice, "20260627-120000", "concise", "REJECT")
        v = _passing_verdict("concise")
        self.assertNotEqual(v.decision, gate.REJECT)  # would pass on its own
        out = gate.apply_durable_rejects([v], self.advice)[0]
        self.assertEqual(out.decision, gate.HOLD)
        self.assertTrue(any("previously REJECTED" in s for s in out.signals))

    def test_later_promote_pass_unrejects(self):
        _advice(self.advice, "20260627-120000", "concise", "REJECT")
        _advice(self.advice, "20260702-090000", "concise", "PASS")  # --promote
        out = gate.apply_durable_rejects([_passing_verdict("concise")],
                                         self.advice)[0]
        self.assertNotEqual(out.decision, gate.HOLD)

    def test_hold_never_overrides_the_ledger(self):
        # The demoted HOLD gets recorded as advice; the ledger must still
        # answer REJECT next run (HOLD is not terminal).
        _advice(self.advice, "20260627-120000", "concise", "REJECT")
        _advice(self.advice, "20260628-120000", "concise", "HOLD")
        self.assertIn("concise", gate.past_rejects(self.advice))

    def test_other_labels_untouched(self):
        _advice(self.advice, "20260627-120000", "concise", "REJECT")
        out = gate.apply_durable_rejects([_passing_verdict("palette")],
                                         self.advice)[0]
        self.assertFalse(any("previously REJECTED" in s for s in out.signals))

    def test_no_advice_dir_is_noop(self):
        v = _passing_verdict()
        out = gate.apply_durable_rejects([v], self.advice / "missing")[0]
        self.assertEqual(out.decision, v.decision)

    def test_non_verdict_advice_ignored(self):
        # dist/tidy advice files carry no candidate:/decision: keys.
        self.advice.mkdir(parents=True)
        (self.advice / "20260702-dist.md").write_text(
            "---\nkind: dist\nname: x\n---\n", encoding="utf-8", newline="")
        self.assertEqual(gate.past_rejects(self.advice), set())


if __name__ == "__main__":
    unittest.main()
