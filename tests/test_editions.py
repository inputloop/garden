# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
"""Sized editions and the random option (polygram/editions.py), against the
design c4 h/DESIGN-2026-09-28-default-skill-set.md, and the promise that the
full edition's bytes do not move."""
import datetime as dt
import json
import os
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
sys.dont_write_bytecode = True
from polygram import editions, plugin  # noqa: E402
from polygram.dist import SkillSrc  # noqa: E402

NOW = dt.datetime(2026, 9, 28, 4, 0, tzinfo=dt.timezone.utc)
HAVE_SH = shutil.which("sh") is not None

# A stand-in candor gate: a skill holds at the door when it carries a DOOR file.
GATE = """#!/bin/sh
[ "$1" = --travel ] && shift
if [ -f "$1/DOOR" ]; then printf '  HOLD     %s: stand-in\\n' "$(cat "$1/DOOR")"; exit 1; fi
echo '  PASS     egress: none'; exit 0
"""


def skill(root: Path, name: str, desc: str = "A plain helper.", door: str = "") -> SkillSrc:
    d = root / name
    d.mkdir(parents=True)
    (d / "SKILL.md").write_text(f"---\nname: {name}\ndescription: {desc}\n---\n\nBody.\n",
                                encoding="utf-8", newline="")
    if door:
        (d / "DOOR").write_text(door, encoding="utf-8", newline="")
    return SkillSrc(name=name, path=d, origin="workspace")


def turn(dirp: Path, name: str, when: dt.datetime) -> None:
    dirp.mkdir(parents=True, exist_ok=True)
    rec = {"attributionSkill": f"vibrobeast:{name}", "type": "assistant",
           "timestamp": when.isoformat().replace("+00:00", "Z")}
    with (dirp / "s.jsonl").open("a", encoding="utf-8", newline="") as fh:
        fh.write(json.dumps(rec) + "\n")


@unittest.skipUnless(HAVE_SH, "needs sh for the door check")
class Editions(unittest.TestCase):
    def setUp(self):
        self.t = tempfile.TemporaryDirectory()
        b = Path(self.t.name)
        self.b = b
        self.gate = b / "gate.sh"
        self.gate.write_text(GATE, encoding="utf-8", newline="")
        g = b / "garden"
        self.floor = tuple(f"floor{i}" for i in range(1, 8))
        self.skills = [skill(g, n) for n in self.floor]
        self.skills += [skill(g, "loud", "Trigger on most prompts.")]
        self.skills += [skill(g, "held", door="egress")]
        self.skills += [skill(g, "floor4held") ]
        self.skills += [skill(g, "broken")]
        self.skills += [skill(g, f"c{i:02d}", "x" * (10 + i)) for i in range(20)]
        self.log = b / "log"
        self.log.write_text("ITEM STATE CUR LAST DATE NOTE\nbroken RED - - - -\n"
                            + "".join(f"c{i:02d} GREEN - - - -\n" for i in range(20)),
                            encoding="utf-8", newline="")
        self.usage = b / "usage"

    def tearDown(self):
        self.t.cleanup()

    def sel(self, **kw):
        base = dict(soft_skills=[], size="grain", rnd=None, house=dict(editions.HOUSE),
                    floor=self.floor, seed=None, gate=self.gate, metrics_log=self.log,
                    usage_dirs=[self.usage], c4=None, now=NOW,
                    fires_broadly=plugin.fires_broadly)
        base.update(kw)
        return editions.select(self.skills, **base)

    def test_floor_on_top_and_the_math(self):
        s = self.sel()
        pop = len(self.skills)
        self.assertEqual(s.population.total, pop)
        want = editions.picks_for(4, pop, 7)
        self.assertEqual(len(s.ranked), want)
        self.assertEqual([x.name for x in s.floor], list(self.floor))
        self.assertEqual(editions.picks_for(4, 167, 7), 7)     # the design's GRAIN
        self.assertEqual(editions.picks_for(9, 167, 7), 15)
        self.assertEqual(editions.picks_for(17, 167, 7), 28)

    def test_broad_door_red_never_picked_and_said(self):
        s = self.sel(size="grand", rnd="all")
        chosen = {x.name for x in s.installed}
        for n in ("loud", "held", "broken"):
            self.assertNotIn(n, chosen)
        why = dict((x.name, w) for x, w in s.soft)
        self.assertIn("broadly", why["loud"])
        self.assertIn("door", why["held"])
        self.assertIn("RED", why["broken"])

    def test_floor_beats_the_door(self):
        (self.b / "garden" / "floor4" / "DOOR").write_text("person-data", encoding="utf-8", newline="")
        s = self.sel()
        self.assertIn("floor4", {x.name for x in s.floor})
        self.assertEqual(s.holds.get("floor4"), ["person-data"])

    def test_days_not_counts_and_the_window(self):
        for h in range(8):                                   # eight times, one afternoon
            turn(self.usage, "c19", NOW.replace(hour=8) - dt.timedelta(days=1) + dt.timedelta(minutes=30 * h))
        for w in range(3):                                   # three different days
            turn(self.usage, "c18", NOW - dt.timedelta(days=7 * w + 2))
        turn(self.usage, "c17", NOW - dt.timedelta(days=200))  # out of the window
        days, _said, checked = editions.usage_days([self.usage], NOW)
        self.assertTrue(checked)
        self.assertEqual(days.get("c19"), 1)
        self.assertEqual(days.get("c18"), 3)
        self.assertNotIn("c17", days)
        s = self.sel(house={"grain": 50, "great": 9, "grand": 17})
        order = [x.name for x, _ in s.ranked]
        self.assertEqual(order[0], "c18")
        self.assertEqual(order[1], "c19")

    def test_unchecked_ranks_after_checked_and_ties_go_short(self):
        s = self.sel(size="grand", house={"grain": 4, "great": 9, "grand": 100})
        order = [x.name for x, _ in s.ranked]
        self.assertLess(order.index("c00"), order.index("c01"))   # shorter description first
        self.assertEqual(order[-1], "floor4held")                  # UNCHECKED: no log row

    def test_missing_use_record_is_not_zero(self):
        s = self.sel(usage_dirs=[self.b / "nowhere"])
        self.assertFalse(s.usage_checked)
        self.assertTrue(any("NOT CHECKED" in x for x in s.usage_said))

    def test_random_repeatable_disjoint_and_stacked(self):
        a = self.sel(rnd="grain", seed="42")
        b = self.sel(rnd="grain", seed="42")
        self.assertEqual([x.name for x in a.drawn], [x.name for x in b.drawn])
        ranked = {x.name for x, _ in a.ranked}
        self.assertFalse(ranked & {x.name for x in a.drawn})
        self.assertEqual(len(a.drawn), editions.picks_for(4, a.population.total, 7))
        seeds = {tuple(x.name for x in self.sel(size=None, rnd="grain", seed=str(i)).drawn) for i in range(6)}
        self.assertGreater(len(seeds), 1)
        only = self.sel(size=None, rnd="grain", seed="1")
        self.assertEqual(only.ranked, [])
        every = self.sel(size=None, rnd="all", seed="1")
        cand = 20 + 1  # c00..c19 and floor4held
        self.assertEqual(len(every.drawn), cand)

    def test_no_door_check_no_picks(self):
        s = self.sel(gate=self.b / "no-such-gate.sh", rnd="all", seed="1")
        self.assertEqual(s.ranked, [])
        self.assertEqual(s.drawn, [])
        self.assertTrue(any("door check" in p for p in s.problems))

    def test_missing_floor_is_said(self):
        s = self.sel(floor=self.floor + ("drift",))
        self.assertTrue(any("'drift'" in p for p in s.problems))

    def test_names_and_options(self):
        self.assertEqual(editions.edition_name("vibrobeast", "grain", None), "vibrobeast-grain")
        self.assertEqual(editions.edition_name("vibrobeast", None, "grain"), "vibrobeast-random")
        self.assertEqual(editions.edition_name("vibrobeast", "great", "grand"), "vibrobeast-great-random-grand")
        self.assertEqual(editions.normalise_random("yes"), "grain")
        self.assertIsNone(editions.normalise_random(""))
        self.assertEqual(editions.parse_house("grain=5")["grain"], 5)
        with self.assertRaises(ValueError):
            editions.normalise_random("lots")
        with self.assertRaises(ValueError):
            self.sel(size=None, rnd=None)


@unittest.skipUnless(HAVE_SH, "needs sh for the door check")
class Packaging(unittest.TestCase):
    def setUp(self):
        self.t = tempfile.TemporaryDirectory()
        self.b = Path(self.t.name)
        g = self.b / "garden"
        self.skills = [skill(g, n) for n in ("alpha", "beta", "gamma")]

    def tearDown(self):
        self.t.cleanup()

    def test_full_edition_bytes_unchanged_by_the_new_keywords(self):
        a = plugin.mint_plugin(self.b / "a", self.skills, source_root=ROOT, version="9.9.9")
        b = plugin.mint_plugin(self.b / "b", self.skills, source_root=ROOT, version="9.9.9",
                               soft=None, readme_extra="")
        self.assertFalse((a.root / "SOFT-SKILLS").exists())
        self.assertEqual((a.root / "servers" / "launch.py").read_text(encoding="utf-8"), plugin._LAUNCH_PY)
        self.assertEqual((a.root / "MANIFEST").read_bytes(), (b.root / "MANIFEST").read_bytes())
        self.assertNotIn("This edition", (a.root / "README.md").read_text(encoding="utf-8"))

    def test_sized_edition_finds_its_soft_skills(self):
        r = plugin.mint_plugin(self.b / "e", self.skills[:1], source_root=ROOT, version="9.9.9",
                               name="vibrobeast-grain", soft=self.skills[1:],
                               readme_extra="\n## This edition: test\n")
        soft = r.root / "SOFT-SKILLS"
        self.assertEqual(sorted(p.name for p in soft.iterdir()), ["beta", "gamma"])
        self.assertIn("## This edition: test", (r.root / "README.md").read_text(encoding="utf-8"))
        self.assertIn("./SOFT-SKILLS/beta/SKILL.md", (r.root / "MANIFEST").read_text(encoding="utf-8"))
        # Run the shipped launcher's own lines up to the server import, with a bare
        # environment, then ask the soft-skill server's own code what it can see.
        home = self.b / "home"
        home.mkdir()
        probe = (
            "import os,sys,runpy\n"
            f"src=open({str(r.root / 'servers' / 'launch.py')!r},encoding='utf-8').read()\n"
            "src=src.split('from polygram.mcp.__main__ import main')[0]\n"
            f"g={{'__file__':{str(r.root / 'servers' / 'launch.py')!r},'__name__':'probe'}}\n"
            "exec(compile(src,'launch.py','exec'),g)\n"
            "from polygram.mcp import softskills\n"
            "print(sorted(s['name'] for s in softskills.scan()['skills']))\n")
        env = {k: v for k, v in os.environ.items()
               if k not in ("SOFT_SKILLS", "MENTCACHED_SEAT", "MENTCACHED_PREFS")}
        env.update(HOME=str(home), USERPROFILE=str(home), PYTHONDONTWRITEBYTECODE="1")
        cp = subprocess.run([sys.executable, "-c", probe], capture_output=True, text=True,
                            encoding="utf-8", env=env, cwd=str(self.b))
        self.assertEqual(cp.returncode, 0, cp.stderr)
        self.assertIn("'beta'", cp.stdout)
        self.assertIn("'gamma'", cp.stdout)

    def test_launch_anchor_must_match(self):
        with self.assertRaises(RuntimeError):
            editions.launch_variant("no anchor here")


if __name__ == "__main__":
    unittest.main()
