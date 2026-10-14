# polygram -- tests for `skill-sign.sh manifest`, the EXPRESS manifest (2026-09-24).
#
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# SPDX-License-Identifier: GPL-3.0-or-later
# This program is free software: you can redistribute it and/or modify it under the terms
# of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
# This file is part of vibrobeast.  Authored by Mentat (for Corwin).  Free software under the GNU
# GPL v3 or (at your option) any later version; WITHOUT ANY WARRANTY; <https://www.gnu.org/licenses/>.
"""The claim: after a sweep edits a skill, the tool that edited can write the manifest itself, with
no key, and `verify` then reads UNVERIFIED-AUTHOR -- never TREE CHANGED, never BAD. A signature the
new manifest would orphan is archived, not deleted -- into the skill's .arc/, which is the skill's
history and NOT the skill: build_manifest prunes it, exactly as polygram/dist.py's _JUNK_DIRS does
for the mint (Corwin, 2026-09-24: ".arc/ in the mint: _JUNK_DIRS and build_manifest together";
the 0.7.4 shelf mint had shipped 172 .arc/ rows of 433). tests/arc-never-ships.pl holds both."""
from __future__ import annotations

import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SIGN = ROOT / "skills" / "skill-sign" / "scripts" / "skill-sign.sh"
_have_sh = shutil.which("sh") is not None


def _run(*args) -> subprocess.CompletedProcess:
    return subprocess.run(["sh", str(SIGN), *args], capture_output=True, text=True, encoding="utf-8")


@unittest.skipUnless(SIGN.is_file() and _have_sh, "skill-sign.sh or POSIX sh unavailable")
class ExpressManifest(unittest.TestCase):
    def setUp(self):
        self.td = tempfile.TemporaryDirectory(); self.addCleanup(self.td.cleanup)
        self.sk = Path(self.td.name) / "sk"; self.sk.mkdir()
        (self.sk / "SKILL.md").write_text("---\nname: sk\ndescription: fine\n---\nbody\n", encoding="utf-8", newline="\n")

    def test_writes_a_manifest_with_no_key_and_verify_reads_tier_1(self):
        r = _run("manifest", str(self.sk))
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertIn("manifest written", r.stdout)
        self.assertTrue((self.sk / ".skill-manifest").is_file())
        v = _run("verify", str(self.sk))
        self.assertIn("UNVERIFIED-AUTHOR", v.stdout + v.stderr)
        self.assertNotIn("TREE CHANGED", v.stdout + v.stderr)

    def test_a_second_run_with_no_change_says_unchanged(self):
        _run("manifest", str(self.sk))
        r = _run("manifest", str(self.sk))
        self.assertIn("manifest unchanged", r.stdout)

    def test_an_orphaned_signature_is_archived_and_listed_never_deleted(self):
        _run("manifest", str(self.sk))
        (self.sk / ".signature.asc").write_text("not a real signature\n", encoding="utf-8", newline="\n")
        (self.sk / "SKILL.md").write_text("---\nname: sk\ndescription: fine\n---\nbody changed\n", encoding="utf-8", newline="\n")
        r = _run("manifest", str(self.sk))
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertIn("moved to", r.stderr)
        self.assertFalse((self.sk / ".signature.asc").exists())
        arc = list((self.sk / ".arc").rglob("signature-*_pre-manifest.asc"))
        self.assertEqual(len(arc), 1)
        man = (self.sk / ".skill-manifest").read_text(encoding="utf-8")
        self.assertNotIn("_pre-manifest.asc", man, ".arc/ is the skill's history, not the skill: never in the manifest")
        self.assertNotIn("/.arc/", man)
        v = _run("verify", str(self.sk))
        self.assertIn("UNVERIFIED-AUTHOR", v.stdout + v.stderr)

    def test_refuses_a_dir_without_skill_md(self):
        d = Path(self.td.name) / "nope"; d.mkdir()
        r = _run("manifest", str(d))
        self.assertNotEqual(r.returncode, 0)
        self.assertIn("no SKILL.md", r.stderr)


if __name__ == "__main__":
    unittest.main()
