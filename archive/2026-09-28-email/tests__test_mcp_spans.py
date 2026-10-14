# tier: smoke
# polygram -- tests for span_start / span_mark / span_stop / span_report on mentcached.
# Copyright (C) 2026 Corwin <mplscorwin@gmail.com>.  GPL-3.0-or-later.
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
"""Time and tokens per span, from on-start / on-stop calls (Corwin, 2026-09-23).

What is pinned here: the ledger is append-only and one row per EVENT; time is the
server's and tokens are the caller's; a span with no token figures says "time only";
stop refuses when nothing is open and refuses twice; the report's totals equal the
sum of its spans; and a path the USER named is never created.
"""

from __future__ import annotations

import os
import tempfile
import unittest
from pathlib import Path

from polygram.mcp import mentcached, spans
from polygram.mcp.rpc import ToolError


class SpanLedger(unittest.TestCase):
    def setUp(self):
        self.td = tempfile.TemporaryDirectory(); self.addCleanup(self.td.cleanup)
        root = Path(self.td.name)
        self.ledger = root / "stats" / "spans.tsv"
        self._env = dict(os.environ)
        os.environ["MENTCACHED_STATS"] = ""            # the default path, redirected below
        spans.DEFAULT_LEDGER, self._dl = self.ledger, spans.DEFAULT_LEDGER
        seat = root / "seat"; seat.mkdir()
        self.srv = mentcached.build(by="test-by", seat=seat, jail=None)

    def tearDown(self):
        os.environ.clear(); os.environ.update(self._env)
        spans.DEFAULT_LEDGER = self._dl

    def call(self, name, **args):
        return self.srv.call(name, args)

    def test_start_mark_stop_is_three_rows_and_one_span(self):
        s = self.call("span_start", label="build", tokens_left=1000)
        self.assertIn("mode", s)
        self.call("span_mark", tokens_left=700, note="half")
        out = self.call("span_stop", tokens_left=400, outcome="done")
        rows = [ln for ln in self.ledger.read_text(encoding="utf-8").splitlines()[1:] if ln]
        self.assertEqual([r.split("\t")[1] for r in rows], ["start", "mark", "stop"])
        self.assertEqual(out["tokens_used"], 600)
        self.assertEqual(out["marks"], 1)
        self.assertFalse(out["open"])
        self.assertEqual(out["outcome"], "done")
        self.assertIn("600 tokens", out["say"])
        rep = self.call("span_report")
        self.assertEqual(rep["count"], 1)
        self.assertEqual(rep["tokens"], 600)
        self.assertEqual(rep["by_label"][0]["label"], "build")

    def test_nothing_is_ever_rewritten(self):
        self.call("span_start", label="a", tokens_left=10)
        before = self.ledger.read_bytes()
        self.call("span_stop", tokens_left=5)
        after = self.ledger.read_bytes()
        self.assertTrue(after.startswith(before), "a stop must APPEND, not rewrite the start")

    def test_time_only_when_no_token_figures(self):
        self.call("span_start", label="think")
        out = self.call("span_stop")
        self.assertIsNone(out["tokens_used"])
        self.assertIn("time only", out["say"])
        self.assertGreaterEqual(out["seconds"], 0)

    def test_stop_refuses_when_nothing_is_open_and_refuses_twice(self):
        with self.assertRaises(ToolError) as cm:
            self.call("span_stop")
        self.assertIn("span_start first", str(cm.exception))
        s = self.call("span_start", label="x")
        self.call("span_stop")
        with self.assertRaises(ToolError) as cm:
            self.call("span_stop", span=s["span"])
        self.assertIn("already stopped", str(cm.exception))

    def test_two_open_spans_must_be_named(self):
        a = self.call("span_start", label="a"); b = self.call("span_start", label="b")
        self.assertEqual(b["also_open"], [f"{a['span']} a"])
        with self.assertRaises(ToolError) as cm:
            self.call("span_mark")
        self.assertIn("more than one span is open", str(cm.exception))
        self.call("span_stop", span=a["span"])
        self.assertEqual(self.call("span_report")["open"], [b["span"]])

    def test_tokens_must_be_whole_and_not_negative(self):
        with self.assertRaises(ToolError):
            self.call("span_start", label="x", tokens_left="lots")
        with self.assertRaises(ToolError):
            self.call("span_start", label="x", tokens_left=-1)

    def test_label_is_required_and_fields_fold_to_one_line(self):
        with self.assertRaises(ToolError):
            self.call("span_start", label="   ")
        self.call("span_start", label="two\twords\nhere", note="a\tb")
        self.call("span_stop")
        rows = self.ledger.read_text(encoding="utf-8").splitlines()
        self.assertEqual(rows[1].split("\t")[3], "two words here")
        self.assertEqual(rows[1].split("\t")[6], "a b")

    def test_report_totals_equal_the_sum_of_spans_and_filters_narrow(self):
        for lab, t0, t1 in (("a", 100, 90), ("a", 90, 70), ("b", 70, 65)):
            self.call("span_start", label=lab, tokens_left=t0); self.call("span_stop", tokens_left=t1)
        rep = self.call("span_report")
        self.assertEqual(rep["count"], 3)
        self.assertEqual(rep["tokens"], sum(s["tokens_used"] for s in rep["spans"]))
        self.assertEqual(rep["seconds"], sum(s["seconds"] for s in rep["spans"]))
        self.assertEqual({b["label"]: b["tokens"] for b in rep["by_label"]}, {"a": 30, "b": 5})
        self.assertEqual(self.call("span_report", label="b")["count"], 1)
        self.assertEqual(self.call("span_report", since="2999-01-01")["count"], 0)
        self.assertEqual(len(self.call("span_report", limit=2)["spans"]), 2)

    def test_a_user_named_path_is_never_created(self):
        os.environ["MENTCACHED_STATS"] = str(Path(self.td.name) / "nowhere" / "spans.tsv")
        srv = mentcached.build(by="t", seat=Path(self.td.name) / "seat", jail=None)
        with self.assertRaises(ToolError) as cm:
            srv.call("span_start", {"label": "x"})
        self.assertIn("never creates", str(cm.exception))
        self.assertFalse((Path(self.td.name) / "nowhere").exists())

    def test_a_foreign_line_in_the_ledger_is_skipped_not_guessed_at(self):
        self.call("span_start", label="a"); self.call("span_stop")
        with self.ledger.open("a", encoding="utf-8") as fh:
            fh.write("garbage line with no tabs\n")
        self.assertEqual(self.call("span_report")["count"], 1)


if __name__ == "__main__":
    unittest.main()
