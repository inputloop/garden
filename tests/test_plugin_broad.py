# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# SPDX-License-Identifier: GPL-3.0-or-later
"""Skills that fire broadly are said in the plugin README, and the Python reading
agrees with candor-gate's shell reading on every garden skill (2026-09-28)."""
import os
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from polygram import plugin  # noqa: E402

GATE = ROOT / "skills" / "candor-gate" / "scripts" / "candor_gate.sh"


def write(d: Path, desc: str, body: str = "Body.") -> Path:
    d.mkdir(parents=True)
    (d / "SKILL.md").write_text(f"---\nname: {d.name}\ndescription: {desc}\n---\n\n{body}\n",
                                encoding="utf-8", newline="")
    return d / "SKILL.md"


class Broad(unittest.TestCase):
    def test_instruction_and_negation(self):
        with tempfile.TemporaryDirectory() as t:
            t = Path(t)
            self.assertTrue(plugin.fires_broadly(write(t / "a", "Trigger on most prompts.")))
            self.assertTrue(plugin.fires_broadly(write(t / "b", "Run at the TOP OF EVERY substantive prompt.")))
            self.assertFalse(plugin.fires_broadly(write(t / "c", "It clears opt-in engagement (no silent always-on).")))
            self.assertFalse(plugin.fires_broadly(write(t / "d", "Count words in a file.")))

    @unittest.skipUnless(shutil.which("sh") and GATE.is_file(), "needs sh and candor-gate")
    def test_two_readers_agree_on_the_garden(self):
        diff = []
        for d in sorted((ROOT / "skills").iterdir()):
            md = d / "SKILL.md"
            if not md.is_file():
                continue
            out = subprocess.run(["sh", str(GATE), "--travel", str(d)], capture_output=True,
                                 text=True, encoding="utf-8", errors="replace").stdout
            shell = "NOTICE   engagement" in out
            if shell != plugin.fires_broadly(md):
                diff.append((d.name, shell))
        self.assertEqual(diff, [], "candor_gate.sh and plugin.fires_broadly disagree")

    def test_readme_names_them(self):
        with tempfile.TemporaryDirectory() as t:
            t = Path(t)
            src = t / "src"
            write(src / "loud", "Trigger on most prompts.")
            write(src / "quiet", "Count words.")
            from polygram.dist import SkillSrc
            skills = [SkillSrc(name=n, path=src / n, origin="workspace") for n in ("loud", "quiet")]
            res = plugin.mint_plugin(t / "dist", skills, source_root=ROOT, python="python3")
            readme = (res.root / "README.md").read_text(encoding="utf-8")
            self.assertIn("## Skills that fire broadly", readme)
            self.assertIn("- `loud`", readme)
            self.assertNotIn("- `quiet`", readme)
            # SPEC (F3, pass 3, C5b J5): the advice arrives before the act it advises about --
            # the section sits above Install and says what to do after installing as well.
            self.assertLess(readme.index("## Skills that fire broadly"), readme.index("## Install"))
            self.assertIn("after you install", readme)


if __name__ == "__main__":
    unittest.main()
