# polygram -- tests for words (the word-path registry over MCP), a second reader of C4's g/<word>/.
#
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# SPDX-License-Identifier: GPL-3.0-or-later
# This program is free software: you can redistribute it and/or modify it under the terms
# of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
# This file is part of vibrobeast.  Authored by Mentat (for Corwin).  Free software under the GNU
# GPL v3 or (at your option) any later version; WITHOUT ANY WARRANTY; <https://www.gnu.org/licenses/>.
"""Two readers, two languages, one registry: what this Python reader says must agree with what the
POSIX reader (c4/bin/wd1nn) says on the same fixture root -- agreement is evidence, either alone is
data. The fixture is a tiny C4 root made here; the real tree is never written."""
from __future__ import annotations

import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

from polygram.mcp import mentcached, prefs, words
from polygram.mcp.rpc import ToolError


class Base(unittest.TestCase):
    def setUp(self):
        self.td = tempfile.TemporaryDirectory(); self.addCleanup(self.td.cleanup)
        self.c4 = Path(self.td.name) / "c4"
        for d in ("m", "evidence", "facts", "context", "g/TAXONOMY/seam/applied", "g/DISCOVERY/pin"):
            (self.c4 / d).mkdir(parents=True)
        (self.c4 / "m" / "t").write_text("T TEMPLATE TAXONOMY TEST TAG\nS SCALAR SPOKE SELECT SEMAPHORE\n", encoding="utf-8", newline="\n")
        (self.c4 / "evidence" / "scalars.tsv").write_text("# scalars\nRUNCARD-<date>\tpattern\tavowed\tx\ty\n", encoding="utf-8", newline="\n")
        (self.c4 / "evidence" / "terms-of-art.tsv").write_text("# terms\nseam\tCorwin-verbatim\tpinned\tcanon\tx\ty\n", encoding="utf-8", newline="\n")
        (self.c4 / "g/TAXONOMY/seam/applied/joint").write_text("", encoding="utf-8", newline="\n")
        (self.c4 / "facts" / "magic-numbers-is-itself-a-seam").write_text("", encoding="utf-8", newline="\n")
        (self.c4 / "context" / "keepers-pen-seam.md").write_text("", encoding="utf-8", newline="\n")
        self._env = dict(os.environ); self.addCleanup(lambda: (os.environ.clear(), os.environ.update(self._env)))
        os.environ["C4_ROOT"] = str(self.c4); os.environ.pop("MENTCACHED_PREFS", None)
        self._dp, prefs.DEFAULT_PATH = prefs.DEFAULT_PATH, Path(self.td.name) / "prefs.tsv"
        self.addCleanup(lambda: setattr(prefs, "DEFAULT_PATH", self._dp))


class Where(Base):
    def test_a_register_word_hits_m_t_live_with_no_leaf(self):
        r = words.where({"name": "semaphore"})
        self.assertEqual(r["nearest"], "t"); self.assertFalse(r["gap"])
        self.assertEqual(next(h for h in r["live"] if h["place"] == "t")["what"], "S col4")

    def test_seam_hits_four_places(self):
        r = words.where({"name": "seam"})
        self.assertEqual(sum(1 for h in r["live"] if h["hit"]), 4)
        self.assertEqual([h["place"] for h in r["live"] if h["hit"]], ["e", "g", "f", "c"])

    def test_a_gap_is_a_gap_with_every_place_named(self):
        r = words.where({"name": "ceremony"})
        self.assertTrue(r["gap"]); self.assertEqual(len(r["live"]), 7); self.assertIn("PROPER GAP", r["say"])

    def test_every_terms_of_art_row_is_reported_with_its_row_number_and_h_by_name(self):
        (self.c4 / "evidence" / "terms-of-art.tsv").write_text("# terms\nring\tpractice\thand-turning\tx\tx\ty\nring\tCorwin-verbatim\tpinned\tcanon\tx\ty\n", encoding="utf-8", newline="\n")
        (self.c4 / "h").mkdir(); (self.c4 / "h" / "METHOD-lens-and-granule-ring.md").write_text("", encoding="utf-8", newline="\n")
        r = words.where({"name": "ring"})
        e = next(h for h in r["live"] if h["place"] == "e")
        self.assertEqual(e["what"], "row 2: practice · hand-turning ; row 3: Corwin-verbatim · pinned")
        h = next(x for x in r["live"] if x["place"] == "h")
        self.assertTrue(h["hit"]); self.assertIn("METHOD-lens-and-granule-ring.md", h["what"])

    def test_register_then_where_in_origin_order_and_a_second_leaf_is_a_seam(self):
        words.register_word({"name": "ceremony", "leaf": "d", "neighbor": "m/t", "meaning": "a rite"}, by="t")
        (self.c4 / "h").mkdir(); (self.c4 / "h" / "x.md").write_text("", encoding="utf-8", newline="\n")
        words.register_word({"name": "Ceremony", "leaf": "h", "neighbor": "h/x.md", "meaning": "a working sense"}, by="t")
        r = words.where({"name": "ceremony"})
        self.assertEqual([l["leaf"] for l in r["leaves"]], ["d", "h"]); self.assertIn("seam", r["say"]); self.assertFalse(r["gap"])
        self.assertEqual(r["leaves"][0]["neighbor"], "m/t"); self.assertEqual(r["leaves"][1]["by"], "t")

    def test_refusals(self):
        with self.assertRaises(ToolError): words.register_word({"name": "x", "leaf": "q", "neighbor": "m/t", "meaning": "y"}, by="t")
        with self.assertRaises(ToolError): words.register_word({"name": "x", "leaf": "d", "neighbor": "d/nowhere.md", "meaning": "y"}, by="t")
        with self.assertRaises(ToolError): words.register_word({"name": "taxonomy", "leaf": "t", "neighbor": "T col2", "meaning": "y"}, by="t")
        with self.assertRaises(ToolError): words.where({"name": "bad/word"})
        words.register_word({"name": "x", "leaf": "d", "neighbor": "m/t", "meaning": "y"}, by="t")
        with self.assertRaises(ToolError) as cm: words.register_word({"name": "x", "leaf": "d", "neighbor": "m/t", "meaning": "again"}, by="t")
        self.assertIn("already registered", str(cm.exception))
        words.register_word({"name": "y", "leaf": "m", "neighbor": "AS4CE0001/INDEX.md", "meaning": "a copy elsewhere"}, by="t")

    def test_the_root_is_named_and_a_missing_root_is_said(self):
        r = words.where({"name": "seam"}); self.assertEqual(r["root_from"], "$C4_ROOT")
        os.environ["C4_ROOT"] = str(Path(self.td.name) / "nope")
        _home, words.Path = words.Path, words.Path   # (no monkeypatch: the defaults may exist on this host)
        r_root, why = words.root()
        self.assertTrue(r_root is None or r_root != self.c4, "the bad $C4_ROOT must not be chosen")
        self.assertNotEqual(why, "$C4_ROOT")

    def test_the_pref_beats_the_env(self):
        other = Path(self.td.name) / "other"; (other / "m").mkdir(parents=True)
        (other / "m" / "t").write_text("W WORKER WEBSITE WRITE WORK\n", encoding="utf-8", newline="\n")
        prefs.set_("words.root", str(other), "t", "testing")
        r = words.where({"name": "worker"}); self.assertEqual(r["root_from"], "pref words.root"); self.assertEqual(r["nearest"], "t")

    def test_tools_on_mentcached(self):
        srv = mentcached.build(by="t", seat=Path(self.td.name) / "seat", jail=None)
        names = [t.name for t in srv.tools]
        self.assertTrue({"word_where", "word_register"} <= set(names), names)
        out = srv.call("word_where", {"name": "seam"})
        self.assertEqual(sum(1 for h in out["live"] if h["hit"]), 4)


@unittest.skipUnless(shutil.which("sh"), "POSIX sh unavailable")
class TwoReaders(Base):
    """The cross-check: the POSIX reader over the same fixture must agree with the Python one."""
    def test_wd1nn_and_words_agree_on_hits_and_gaps(self):
        c4root = Path(os.environ.get("C4_ROOT_REAL") or "/f/claude/c4")
        if not (c4root / "bin" / "wd1nn").is_file():
            c4root = Path.home() / "mnt" / "c4"
        tool = c4root / "bin" / "wd1nn"
        if not tool.is_file():
            self.skipTest("c4/bin/wd1nn not reachable from here")
        words.register_word({"name": "ceremony", "leaf": "d", "neighbor": "m/t", "meaning": "a rite"}, by="t")
        for w in ("seam", "semaphore", "ceremony", "zebra"):
            py = words.where({"name": w})
            sh = subprocess.run(["sh", str(tool), w], capture_output=True, text=True, encoding="utf-8", env={**os.environ, "C4_ROOT": str(self.c4)})
            sh_hits = sh.stdout.count("\n  HIT ")
            self.assertEqual(sum(1 for h in py["live"] if h["hit"]), sh_hits, f"{w}: python vs sh disagree\n{sh.stdout}")
            self.assertEqual(py["gap"], sh.returncode == 1, f"{w}: gap verdicts disagree")


if __name__ == "__main__":
    unittest.main()
