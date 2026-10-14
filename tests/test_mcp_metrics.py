# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
# tier: smoke
"""metrics_read over MCP -- the read-only window on the skill-metrics store.

The server must answer from sk2mt (one implementation), refuse honestly when it cannot, and
never write. GPL-3.0-or-later. Authored by Mentat (for Corwin)."""
import os, subprocess, tempfile, unittest
from pathlib import Path
from unittest import mock

from polygram.mcp import mentcached, metrics
from polygram.mcp.rpc import ToolError

ROOT = Path(__file__).resolve().parents[1]
SK = ROOT / "skills" / "skill-metrics" / "scripts" / "sk2mt"


class MetricsRead(unittest.TestCase):
    def setUp(self):
        self.d = tempfile.mkdtemp()
        self.m = os.path.join(self.d, "m")
        subprocess.run(["sh", str(SK), "-C", self.m, "init"], check=True, capture_output=True)
        for it, st in (("polygram", "GREEN"), ("gf-02-layered-assurance", "OK"), ("layered", "RED")):
            subprocess.run(["sh", str(SK), "-C", self.m, "set", it, st, "--date", "2026-09-01T00:00:00Z"],
                           check=True, capture_output=True)
        self.env = mock.patch.dict(os.environ, {"SKILL_METRICS_ROOT": self.m,
                                                "MENTCACHED_SEAT": os.path.join(self.d, "seat")})
        self.env.start()
        self.srv = mentcached.build(seat=Path(self.d) / "seat")

    def tearDown(self):
        self.env.stop()

    def call(self, **a):
        return self.srv.call("metrics_read", a)

    def test_listed(self):
        self.assertIn("metrics_read", [t["name"] for t in self.srv.list_tools()["tools"]])

    def test_exact_name(self):
        r = self.call(view="state", names=["layered"])
        self.assertEqual((r["metrics_mode"], r["text"]), ("FOUND", "RED\n"))
        self.assertIn("mode", r)          # the server's own contract: every result says its mode

    def test_pattern_is_grep(self):
        r = self.call(view="items", pattern="layered")
        self.assertEqual(r["text"].split(), ["gf-02-layered-assurance", "layered"])

    def test_state_filter(self):
        r = self.call(view="items", state="RED")
        self.assertEqual((r["metrics_mode"], r["text"]), ("FOUND", "layered\n"))

    def test_say_is_words(self):
        self.assertTrue(self.call(names=["polygram"])["text"].startswith("polygram is GREEN"))

    def test_none_selected(self):
        self.assertEqual(self.call(view="state", names=["nosuch"])["metrics_mode"], "NONE-SELECTED")

    def test_names_and_pattern_refused(self):
        with self.assertRaises(ToolError):
            self.call(names=["x"], pattern="y")

    def test_dash_name_refused(self):
        with self.assertRaises(ToolError):
            self.call(names=["-v"])

    def test_unset_root_is_notvisible(self):
        with mock.patch.dict(os.environ, {"SKILL_METRICS_ROOT": ""}):
            self.assertEqual(self.call()["metrics_mode"], "NOTVISIBLE")

    def test_missing_root_is_notvisible_and_not_created(self):
        gone = os.path.join(self.d, "typo")
        with mock.patch.dict(os.environ, {"SKILL_METRICS_ROOT": gone}):
            self.assertEqual(self.call()["metrics_mode"], "NOTVISIBLE")
        self.assertFalse(os.path.exists(gone))

    def test_no_sh_refuses_by_name(self):
        with mock.patch.object(metrics, "find_sh", return_value=None):
            with self.assertRaises(ToolError) as cm:
                self.call()
        self.assertIn("SKILL_METRICS_SH", str(cm.exception))

    def test_read_only(self):
        before = open(os.path.join(self.m, "log")).read()
        for v in metrics.VIEWS:
            self.call(view=v)
        self.assertEqual(open(os.path.join(self.m, "log")).read(), before)

    def test_check_view(self):
        self.assertEqual(self.call(view="check")["metrics_mode"], "FOUND")


if __name__ == "__main__":
    unittest.main()
