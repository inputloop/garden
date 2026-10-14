# tier: smoke
# polygram -- tests for plugin_freshness (installed plugin vs the shelf mint).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>.  GPL-3.0-or-later.
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
"""'What changed in the plugin that I need to reinstall it?' answered by a tool (2026-09-23).

Pinned: the verdict comes from the two MANIFESTs alone; a server file difference says reinstall
YES, a skill-only difference says 'only if you want that text live' and names the skill; a
source tree (no MANIFEST above the code) is UNKNOWN, never CURRENT; an unset shelf is UNKNOWN with
the installed mint still reported; a shelf given as a MANIFEST path works; the CLI exit codes are
0 CURRENT / 1 BEHIND / 2 UNKNOWN.
"""

from __future__ import annotations

import json
import os
import tempfile
import unittest
from pathlib import Path

from polygram.mcp import freshness, mentcached


def _plugin(root: Path, files: dict[str, str]) -> Path:
    (root / ".claude-plugin").mkdir(parents=True, exist_ok=True)
    (root / ".claude-plugin" / "plugin.json").write_text(json.dumps({"name": "vibrobeast"}), encoding="utf-8", newline="\n")
    lines = []
    for rel, sha in sorted(files.items()):
        lines.append(f"{sha}  ./{rel}")
    (root / "MANIFEST").write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")
    return root


H = lambda n: f"{n:064x}"   # noqa: E731 -- a fake sha256, 64 hex


class Freshness(unittest.TestCase):
    def setUp(self):
        self.td = tempfile.TemporaryDirectory(); self.addCleanup(self.td.cleanup)
        self.root = Path(self.td.name)
        self._env = dict(os.environ); self.addCleanup(lambda: (os.environ.clear(), os.environ.update(self._env)))
        os.environ.pop("POLYGRAM_DIST", None); os.environ.pop("CLAUDE_PLUGIN_ROOT", None)
        # the host's real ~/.mentcached/prefs.tsv must not leak in (it names a real shelf)
        self.prefs = self.root / "prefs.tsv"
        os.environ["MENTCACHED_PREFS"] = str(self.prefs)
        self.base = {"servers/polygram/mcp/mentcached.py": H(1), "skills/a/SKILL.md": H(2),
                     "skills/b/SKILL.md": H(3), "README.md": H(4)}
        self.inst = _plugin(self.root / "installed", self.base)

    def test_identical_manifests_are_current(self):
        sh = _plugin(self.root / "shelf", self.base)
        r = freshness.report({"shelf": str(sh)}, installed=self.inst)
        self.assertEqual(r["verdict"], "CURRENT")
        self.assertEqual(r["installed_mint"], r["shelf_mint"])
        self.assertTrue(r["reinstall"].startswith("no:"))

    def test_a_skill_only_change_names_the_skill_and_does_not_demand_reinstall(self):
        sh = _plugin(self.root / "shelf", {**self.base, "skills/b/SKILL.md": H(33)})
        r = freshness.report({"shelf": str(sh)}, installed=self.inst)
        self.assertEqual(r["verdict"], "BEHIND")
        self.assertEqual(r["skills_changed"], ["b"])
        self.assertEqual(r["servers_changed"], 0)
        self.assertIn("only if you want that skill text live", r["reinstall"])
        self.assertEqual(r["changed"], ["skills/b/SKILL.md"])

    def test_a_server_change_says_reinstall_yes(self):
        sh = _plugin(self.root / "shelf", {**self.base, "servers/polygram/mcp/mentcached.py": H(11),
                                              "servers/polygram/mcp/new.py": H(12)})
        r = freshness.report({"shelf": str(sh)}, installed=self.inst)
        self.assertEqual(r["verdict"], "BEHIND")
        self.assertEqual(r["servers_changed"], 2)
        self.assertTrue(r["reinstall"].startswith("yes:"), r["reinstall"])
        self.assertEqual(r["only_shelf"], ["servers/polygram/mcp/new.py"])

    def test_a_removed_file_is_only_installed(self):
        sh = _plugin(self.root / "shelf", {k: v for k, v in self.base.items() if k != "skills/a/SKILL.md"})
        r = freshness.report({"shelf": str(sh)}, installed=self.inst)
        self.assertEqual(r["only_installed"], ["skills/a/SKILL.md"])
        self.assertEqual(r["skills_changed"], ["a"])

    def test_the_shelf_may_be_named_by_its_manifest(self):
        sh = _plugin(self.root / "shelf", self.base)
        r = freshness.report({"shelf": str(sh / "MANIFEST")}, installed=self.inst)
        self.assertEqual(r["verdict"], "CURRENT")

    def test_no_shelf_is_unknown_but_still_reports_the_installed_mint(self):
        r = freshness.report({}, installed=self.inst)
        self.assertEqual(r["verdict"], "UNKNOWN")
        self.assertIn("installed_mint", r)
        self.assertIn("pass `shelf`", r["say"])

    def test_the_freshness_shelf_pref_is_honoured_by_the_tool_itself(self):
        """2026-09-24: checks.run read the pref, the tool did not -- a plain call said UNKNOWN."""
        sh = _plugin(self.root / "shelf", self.base)
        self.prefs.write_text("ts\tkey\tvalue\tby\twhy\n"
                              f"2026-09-24T00:00:00Z\tfreshness.shelf\t{sh}\ttest\t\n",
                              encoding="utf-8", newline="\n")
        os.environ["POLYGRAM_DIST"] = str(self.root / "not-a-plugin")
        r = freshness.report({}, installed=self.inst)
        self.assertEqual(r["shelf_how"], "pref freshness.shelf")
        self.assertEqual(r["verdict"], "CURRENT")

    def test_a_pref_naming_a_non_plugin_falls_through_to_the_env(self):
        sh = _plugin(self.root / "shelf", self.base)
        self.prefs.write_text("ts\tkey\tvalue\tby\twhy\n"
                              f"2026-09-24T00:00:00Z\tfreshness.shelf\t{self.root / 'nowhere'}\ttest\t\n",
                              encoding="utf-8", newline="\n")
        os.environ["POLYGRAM_DIST"] = str(sh)
        r = freshness.report({}, installed=self.inst)
        self.assertEqual(r["shelf_how"], "POLYGRAM_DIST")

    def test_polygram_dist_env_is_honoured_and_said(self):
        sh = _plugin(self.root / "shelf", self.base)
        os.environ["POLYGRAM_DIST"] = str(sh)
        r = freshness.report({}, installed=self.inst)
        self.assertEqual(r["shelf_how"], "POLYGRAM_DIST")
        self.assertEqual(r["verdict"], "CURRENT")

    def test_a_source_tree_is_unknown_never_current(self):
        """This test runs from the source tree, so the real installed_root() must say so."""
        sh = _plugin(self.root / "shelf", self.base)
        r = freshness.report({"shelf": str(sh)})
        self.assertEqual(r["verdict"], "UNKNOWN")
        self.assertIn("source tree", r["installed_how"])

    def test_a_shelf_that_is_not_a_plugin_is_refused_in_words(self):
        r = freshness.report({"shelf": str(self.root)}, installed=self.inst)
        self.assertEqual(r["verdict"], "UNKNOWN")
        self.assertIn("not a plugin tree", r["shelf_how"])

    def test_the_tool_is_on_mentcached_and_carries_the_mode_word(self):
        seat = self.root / "seat"; seat.mkdir()
        srv = mentcached.build(by="t", seat=seat, jail=None)
        self.assertIn("plugin_freshness", [t.name for t in srv.tools])
        out = srv.call("plugin_freshness", {"shelf": str(_plugin(self.root / "shelf", self.base))})
        self.assertIn("mode", out)
        self.assertEqual(out["verdict"], "UNKNOWN")   # the test runs from source

    def test_cli_exit_codes(self):
        import contextlib, io
        sh_same = _plugin(self.root / "s1", self.base)
        sh_diff = _plugin(self.root / "s2", {**self.base, "README.md": H(44)})
        with contextlib.redirect_stdout(io.StringIO()), contextlib.redirect_stderr(io.StringIO()):
            self.assertEqual(freshness.main(["--shelf", str(sh_same), "--installed", str(self.inst)]), 0)
            self.assertEqual(freshness.main(["--shelf", str(sh_diff), "--installed", str(self.inst)]), 1)
            self.assertEqual(freshness.main(["--shelf", str(sh_diff)]), 2)
            self.assertEqual(freshness.main(["--bogus"]), 2)


if __name__ == "__main__":
    unittest.main()
