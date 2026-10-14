# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
"""Tests for the skill loadability gate (stdlib unittest only).

Why these tests exist (2026-07-13): sandboxer shipped a 1633-char description
(limit 1024). The body was perfect; the skill could never load, so it could
never fire. And skilltank had been 1039 chars — over, silently dead — through
several signed releases. Nobody knew, because nobody measured. These measure.

The gate lives in skills/skill-sign/scripts/skill-lint.sh and is called
fail-closed from `skill-sign.sh sign`. What is tested is BEHAVIOR — exit codes
against real fixtures — never the tool's own opinion of itself: a parsed flag
is not a behavior.

SKILL_LINT overrides the tool under test. Not a convenience: on a mounted
filesystem a file just edited through the file tool can be served STALE to the
shell, so `sh skill-lint.sh` may run a phantom and every test fails for reasons
that have nothing to do with the code. Point SKILL_LINT at a freshly minted
copy, or run on the host — the host is the tiebreaker.
"""

import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
LINT = Path(
    os.environ.get(
        "SKILL_LINT", str(REPO / "skills" / "skill-sign" / "scripts" / "skill-lint.sh")
    )
)
LIMIT = 1024

_have_sh = shutil.which("sh") is not None


def _run(target) -> subprocess.CompletedProcess:
    return subprocess.run(
        ["sh", str(LINT), "-q", str(target)], capture_output=True, text=True, encoding="utf-8"
    )


def _skill(root: Path, name: str, text: str) -> Path:
    d = root / name
    d.mkdir()
    (d / "SKILL.md").write_text(text, encoding="utf-8", newline="")
    return d


def _desc(n: int) -> str:
    return "x" * n


@unittest.skipUnless(LINT.is_file() and _have_sh, "skill-lint.sh or POSIX sh unavailable")
class TestDescriptionLimit(unittest.TestCase):
    """L4 — the limit that started all this."""

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)

    def tearDown(self):
        self.tmp.cleanup()

    def test_at_limit_passes(self):
        """Exactly 1024 is legal — the boundary belongs to the good side."""
        d = _skill(self.root, "edge", f"---\nname: edge\ndescription: {_desc(LIMIT)}\n---\nbody\n")
        self.assertEqual(_run(d).returncode, 0)

    def test_one_over_limit_fails(self):
        """1025 fails. Off-by-one here means a dead skill in production."""
        d = _skill(self.root, "edge", f"---\nname: edge\ndescription: {_desc(LIMIT + 1)}\n---\nbody\n")
        r = _run(d)
        self.assertEqual(r.returncode, 1)
        self.assertIn("L4", r.stderr)
        self.assertIn("1025", r.stderr)

    def test_finding_names_the_overage(self):
        """Actionable: say how much to cut, not merely 'too long'."""
        d = _skill(self.root, "edge", f"---\nname: edge\ndescription: {_desc(LIMIT + 47)}\n---\nbody\n")
        self.assertIn("over by 47", _run(d).stderr)

    def test_multibyte_counted_as_chars_not_bytes(self):
        """An em-dash is 3 bytes, 1 char. Counting bytes would fail good skills."""
        d = _skill(self.root, "emdash", "---\nname: emdash\ndescription: " + "—" * 1000 + "\n---\nbody\n")
        self.assertEqual(_run(d).returncode, 0)


@unittest.skipUnless(LINT.is_file() and _have_sh, "skill-lint.sh or POSIX sh unavailable")
class TestDescriptionShapes(unittest.TestCase):
    """L3 — present, in every legal YAML shape."""

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)

    def tearDown(self):
        self.tmp.cleanup()

    def test_missing_description_fails(self):
        """No description = no trigger = the skill can never be found."""
        d = _skill(self.root, "nodesc", "---\nname: nodesc\n---\nbody\n")
        r = _run(d)
        self.assertEqual(r.returncode, 1)
        self.assertIn("L3", r.stderr)

    def test_folded_block_scalar_passes(self):
        """A '>-' description is legal YAML and loads fine — it must NOT fail.

        The lint's first draft failed these: a false BAD against seven shipped
        skills. A guard that fails good artifacts teaches people to pass -f.
        """
        text = (
            "---\nname: folded\ndescription: >-\n"
            "  first line of the description\n"
            "  second line continues it\n---\nbody\n"
        )
        d = _skill(self.root, "folded", text)
        self.assertEqual(_run(d).returncode, 0)

    def test_folded_over_limit_still_fails(self):
        """...but a folded description is measured WHOLE, not per line."""
        lines = "\n".join("  " + "y" * 100 for _ in range(12))
        d = _skill(self.root, "folded", f"---\nname: folded\ndescription: >-\n{lines}\n---\nbody\n")
        r = _run(d)
        self.assertEqual(r.returncode, 1)
        self.assertIn("L4", r.stderr)


@unittest.skipUnless(LINT.is_file() and _have_sh, "skill-lint.sh or POSIX sh unavailable")
class TestParseability(unittest.TestCase):
    """L1/L2/L6/L7 — the artifact must parse at all."""

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)

    def tearDown(self):
        self.tmp.cleanup()

    def test_no_frontmatter_fails(self):
        d = _skill(self.root, "nofence", "# just a heading\nbody\n")
        r = _run(d)
        self.assertEqual(r.returncode, 1)
        self.assertIn("L1", r.stderr)

    def test_unclosed_frontmatter_fails(self):
        d = _skill(self.root, "unclosed", "---\nname: unclosed\ndescription: fine\nbody, never closed\n")
        r = _run(d)
        self.assertEqual(r.returncode, 1)
        self.assertIn("L1", r.stderr)

    def test_name_must_match_directory(self):
        """The router looks a skill up by name; a mismatch is unreachable."""
        d = _skill(self.root, "realdir", "---\nname: other-name\ndescription: fine\n---\nbody\n")
        r = _run(d)
        self.assertEqual(r.returncode, 1)
        self.assertIn("L2", r.stderr)

    def test_clearsigned_skill_md_fails(self):
        """House idiom: detach runnables/parsed files. Clearsign breaks the fence."""
        text = (
            "-----BEGIN PGP SIGNED MESSAGE-----\nHash: SHA512\n\n"
            "---\nname: cs\ndescription: fine\n---\nbody\n"
        )
        d = _skill(self.root, "cs", text)
        r = _run(d)
        self.assertEqual(r.returncode, 1)
        self.assertIn("L6", r.stderr)

    def test_crlf_fails(self):
        d = self.root / "crlf"
        d.mkdir()
        (d / "SKILL.md").write_bytes(b"---\r\nname: crlf\r\ndescription: fine\r\n---\r\nbody\r\n")
        r = _run(d)
        self.assertEqual(r.returncode, 1)
        self.assertIn("L7", r.stderr)

    def test_nul_padding_fails(self):
        d = self.root / "padded"
        d.mkdir()
        (d / "SKILL.md").write_bytes(b"---\nname: padded\ndescription: fine\n---\nbody\n" + b"\0" * 79)
        r = _run(d)
        self.assertEqual(r.returncode, 1)
        self.assertIn("L8", r.stderr)
        self.assertIn("79", r.stderr)


@unittest.skipUnless(LINT.is_file() and _have_sh, "skill-lint.sh or POSIX sh unavailable")
class TestShippedTree(unittest.TestCase):
    """The regression with teeth: every skill in the real tree stays loadable."""

    def test_every_installed_skill_is_loadable(self):
        skills_dir = REPO / "skills"
        dirs = [p for p in sorted(skills_dir.iterdir()) if (p / "SKILL.md").is_file()]
        # coverage before targets: a sweep of nothing is silence, not innocence
        self.assertTrue(dirs, "no skills found — this sweep would be vacuously green")
        r = subprocess.run(
            ["sh", str(LINT), "-q", *[str(p) for p in dirs]],
            capture_output=True,
            text=True, encoding="utf-8",
        )
        self.assertEqual(r.returncode, 0, f"unloadable skill(s) in the tree:\n{r.stderr}")


if __name__ == "__main__":
    unittest.main()
