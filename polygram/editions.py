# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can
# redistribute it and/or modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.  It is distributed WITHOUT
# ANY WARRANTY; see <https://www.gnu.org/licenses/>.
"""editions -- sized editions of the plugin, and the random option.

The design is c4 ``h/DESIGN-2026-09-28-default-skill-set.md``, final as input to
C4 (Corwin, 2026-09-28: "bless: your list.  consent-gate over drift included";
"On top is good"; "Assume your model is final as input to C4").

    FULL    the plugin ``make dist`` mints (every garden skill).  Untouched here.
    GRAIN   the floor of eight, plus 4% of the population beyond it, by use
    GREAT   the floor, plus 9%
    GRAND   the floor, plus 17%
    RANDOM  his fourth option (2026-09-28): the floor plus skills "selected quite
            randomly, intended for use helping to find improvements in wiring of
            skills that could be dropped by confirmation bias of name or
            otherwise".  By default as many as GRAIN picks; it stacks with a size
            (ranked picks first, random ones drawn from what is left) and takes a
            size word (or ``all``) for how many.

4, 9 and 17 are the house numbers, used as settings (``--house``).  The floor
counts ON TOP of the percentage.  Every garden skill an edition does not install
goes to the edition's own ``SOFT-SKILLS/`` folder with the reason it went there,
and the edition's launcher points mentcached at that folder, so a soft skill is
still found (``soft_skills_list`` / ``soft_skill_read``).

WHAT THIS MODULE DOES NOT DO.  It never changes what the full edition carries:
``plugin.mint_plugin`` gains two keyword arguments that default to nothing, and
with nothing it writes the same bytes as before (tests/test_editions.py holds
that).  It never refuses to mint: a problem is printed, and when the door check
cannot run no skill beyond the floor is picked.  The changes the design owes to
the checked 0.8.90 product itself (the soft-skill server, the full README,
garden-usage) were ERRATA E1-E3, made 2026-09-29 (ChangeLog).
"""

from __future__ import annotations

import datetime as _dt
import json
import os
import random as _random
import re
import secrets
import subprocess
from dataclasses import dataclass, field
from pathlib import Path

from .dist import SkillSrc, discover

HOUSE = {"grain": 4, "great": 9, "grand": 17}
SIZE_WORDS = ("grain", "great", "grand")
RANDOM_WORDS = SIZE_WORDS + ("all",)
YES = ("1", "yes", "true", "on", "y")
#: His core seven, as blessed 2026-09-28 (consent-gate in drift's seat), and drift as the eighth
#: once it existed, as the design said ("When it exists the floor is eight: GRAIN becomes 8 + 7 =
#: 15"); his word 2026-10-04: "full skills: 15 is the present number, ACK".
FLOOR = ("mentat-skill", "principles", "skilltank", "sandboxer", "lens",
         "garden-usage", "consent-gate", "drift")
#: Rows of C4's c/t that are not tools (the S register itself; a function library).
NOT_TOOLS = ("skill", "it4cfn")
WINDOW_DAYS = 90

_DOOR_RE = re.compile(r"^\s*HOLD\s+(person-data|egress)\b", re.M)
_DECK_RE = re.compile(r"c4_source_deck:\s*decks/([^\s]+?)\.deck\.md")


# ------------------------------------------------------------------ options --

def normalise_random(value: str | None) -> str | None:
    """'' / None -> None; yes-words -> 'grain'; a size word or 'all' -> itself."""
    if value is None:
        return None
    v = str(value).strip().lower()
    if not v or v in ("0", "no", "false", "off", "n"):
        return None
    if v in YES:
        return "grain"
    if v in RANDOM_WORDS:
        return v
    raise ValueError(f"random must be one of {', '.join(RANDOM_WORDS)} (or yes): {value!r}")


def parse_house(text: str | None) -> dict[str, int]:
    """'grain=4,great=9,grand=17' -> dict; missing words keep the house numbers."""
    out = dict(HOUSE)
    for part in (text or "").split(","):
        part = part.strip()
        if not part:
            continue
        k, _, v = part.partition("=")
        k = k.strip().lower()
        if k not in HOUSE or not v.strip().isdigit():
            raise ValueError(f"--house wants grain=N,great=N,grand=N; got {part!r}")
        out[k] = int(v)
    return out


def edition_name(base: str, size: str | None, rnd: str | None) -> str:
    """vibrobeast-grain, vibrobeast-random, vibrobeast-grain-random,
    vibrobeast-great-random-grand (the random count named when it is not GRAIN)."""
    parts = [base]
    if size:
        parts.append(size)
    if rnd:
        parts.append("random")
        if rnd != "grain":
            parts.append(rnd)
    return "-".join(parts)


def picks_for(pct: int, population: int, floor_n: int) -> int:
    """ceil(pct% of the population beyond the floor), in integers."""
    beyond = max(0, population - floor_n)
    return -(-pct * beyond // 100)


# --------------------------------------------------------------- the records --

@dataclass
class Population:
    skills: int
    soft: int
    decks: int | None = None
    tools: int | None = None
    notes: list[str] = field(default_factory=list)

    @property
    def total(self) -> int:
        return self.skills + self.soft + (self.decks or 0) + (self.tools or 0)

    def say(self) -> str:
        bits = [f"{self.skills} skills in the garden", f"{self.soft} soft skills"]
        bits.append(f"{self.decks} C4 decks not yet made into skills"
                    if self.decks is not None else "C4 decks NOT counted (no C4 tree)")
        bits.append(f"{self.tools} C4 tools" if self.tools is not None
                    else "C4 tools NOT counted (no C4 tree)")
        return f"{self.total} ({', '.join(bits)})"


def population(skills: list[SkillSrc], soft: list[SkillSrc], c4: Path | None) -> Population:
    """What the build draws on: the garden, its soft skills, the decks a skill
    could still be minted from, and C4's registered tools (design 3.3)."""
    pop = Population(skills=len(skills), soft=len(soft))
    if c4 is None or not c4.is_dir():
        pop.notes.append("no C4 tree: decks and tools are not counted, so the sizes come out smaller")
        return pop
    minted: set[str] = set()
    for s in skills:
        try:
            minted.update(_DECK_RE.findall((s.path / "SKILL.md").read_text(encoding="utf-8", errors="replace")))
        except OSError:
            pass
    decks = sorted(p.name[:-len(".deck.md")] for p in (c4 / "decks").glob("*.deck.md"))
    pop.decks = len([d for d in decks if d not in minted])
    ct = c4 / "c" / "t"
    if ct.is_file():
        rows = [ln.split("\t", 1)[0] for ln in ct.read_text(encoding="utf-8", errors="replace").splitlines()
                if ln.strip() and not ln.startswith("#")]
        pop.tools = len([r for r in rows if r not in NOT_TOOLS])
    else:
        pop.notes.append(f"no tool register at {ct}: tools are not counted")
    return pop


def health(metrics_log: Path) -> dict[str, str]:
    """The test kit's last state per item (metrics/log: ITEM STATE CUR LAST DATE NOTE)."""
    out: dict[str, str] = {}
    try:
        text = metrics_log.read_text(encoding="utf-8", errors="replace")
    except OSError:
        return out
    for ln in text.splitlines():
        cols = ln.split(None, 2)
        if len(cols) >= 2 and cols[0] != "ITEM":
            out[cols[0]] = cols[1]
    return out


def default_usage_dirs() -> list[Path]:
    env = (os.environ.get("POLYGRAM_USAGE_DIRS") or "").strip()
    if env:
        return [Path(p).expanduser() for p in env.split(os.pathsep) if p.strip()]
    return [Path.home() / ".claude" / "projects"]


def _parse_ts(value: str) -> _dt.datetime | None:
    try:
        return _dt.datetime.fromisoformat(value.replace("Z", "+00:00"))
    except (ValueError, AttributeError):
        return None


def usage_days(dirs: list[Path], now: _dt.datetime, window: int = WINDOW_DAYS
               ) -> tuple[dict[str, int], list[str], bool]:
    """Distinct days (UTC) each skill was attributed in the window, from session
    transcripts (``attributionSkill`` + ``timestamp`` on each message).  Returns
    (days, what was read, checked).  A folder that is not there is said, never
    read as zero use."""
    start = now - _dt.timedelta(days=window)
    seen: dict[str, set[str]] = {}
    said: list[str] = []
    checked = False
    for d in dirs:
        if not d.is_dir():
            said.append(f"{d}: not there -- NOT CHECKED")
            continue
        checked = True
        files = 0
        for f in d.rglob("*.jsonl"):
            try:
                if _dt.datetime.fromtimestamp(f.stat().st_mtime, _dt.timezone.utc) < start:
                    continue
                files += 1
                with f.open(encoding="utf-8", errors="replace") as fh:
                    for line in fh:
                        if '"attributionSkill"' not in line:
                            continue
                        try:
                            o = json.loads(line)
                        except ValueError:
                            continue
                        sk = o.get("attributionSkill")
                        ts = _parse_ts(o.get("timestamp", ""))
                        if not sk or ts is None or ts < start or ts > now:
                            continue
                        name = str(sk).rsplit(":", 1)[-1]
                        seen.setdefault(name, set()).add(ts.astimezone(_dt.timezone.utc).date().isoformat())
            except OSError as exc:
                said.append(f"{f}: not readable ({exc.__class__.__name__}) -- NOT CHECKED")
        said.append(f"{d}: {files} transcript file(s) touched in the last {window} days")
    return {k: len(v) for k, v in seen.items()}, said, checked


def door_holds(skill_dir: Path, gate: Path) -> list[str] | None:
    """The candor gate's --travel HOLDs on person-data or egress; None when the
    gate could not run (then nobody may say the skill is not door-held)."""
    try:
        cp = subprocess.run(["sh", str(gate), "--travel", str(skill_dir)],
                            capture_output=True, text=True, encoding="utf-8",
                            errors="replace", timeout=60)
    except (OSError, subprocess.SubprocessError):
        return None
    if cp.returncode not in (0, 1):
        return None
    return sorted(set(_DOOR_RE.findall(cp.stdout)))


def description_chars(skill_md: Path) -> int:
    """Characters of the frontmatter description, whitespace folded (the cost
    that rides every turn; ties go to the shorter)."""
    try:
        text = skill_md.read_text(encoding="utf-8", errors="replace")
    except OSError:
        return 0
    if not text.startswith("---"):
        return 0
    fm = text.split("\n---", 1)[0]
    m = re.search(r"^description:[ \t]*(.*?)(?=^[A-Za-z_][\w-]*:|\Z)", fm, re.S | re.M)
    if not m:
        return 0
    desc = " ".join(m.group(1).split())
    desc = re.sub(r"^[>|][+-]?\s*", "", desc).strip().strip("'\"")
    return len(desc)


# ---------------------------------------------------------------- the choice --

@dataclass
class Selection:
    size: str | None
    rnd: str | None
    pct: int | None
    seed: str | None
    population: Population
    floor: list[SkillSrc]
    ranked: list[tuple[SkillSrc, int]]
    drawn: list[SkillSrc]
    soft: list[tuple[SkillSrc, str]]
    holds: dict[str, list[str]]
    states: dict[str, str]
    usage_said: list[str]
    usage_checked: bool
    problems: list[str] = field(default_factory=list)
    notes: list[str] = field(default_factory=list)

    @property
    def installed(self) -> list[SkillSrc]:
        return self.floor + [s for s, _ in self.ranked] + self.drawn


def select(skills: list[SkillSrc], *, soft_skills: list[SkillSrc], size: str | None,
           rnd: str | None, house: dict[str, int], floor: tuple[str, ...] = FLOOR,
           seed: str | None = None, gate: Path, metrics_log: Path,
           usage_dirs: list[Path] | None, c4: Path | None,
           now: _dt.datetime, fires_broadly) -> Selection:
    """Pick an edition's installed skills (design 3.3-3.6, plus the random option)."""
    if size is None and rnd is None:
        raise ValueError("an edition needs a size (grain, great, grand) or --random; "
                         "the full edition is `polygram dist`")
    if size is not None and size not in SIZE_WORDS:
        raise ValueError(f"size must be one of {', '.join(SIZE_WORDS)}: {size!r}")
    by_name = {s.name: s for s in skills}
    pop = population(skills, soft_skills, c4)
    problems: list[str] = []
    fl = []
    for n in floor:
        if n in by_name:
            fl.append(by_name[n])
        else:
            problems.append(f"floor skill {n!r} is not in the garden: the floor is not a floor")
    floor_names = {s.name for s in fl}

    states = health(metrics_log)
    holds: dict[str, list[str]] = {}
    door_ok = True
    for s in skills:
        h = door_holds(s.path, gate)
        if h is None:
            door_ok = False
            break
        if h:
            holds[s.name] = h
    if not door_ok:
        problems.append(f"the door check ({gate} --travel) could not run: no skill beyond "
                        "the floor is picked, so nothing held at a receiving door is "
                        "installed unasked")
        holds = {}

    broad = {s.name for s in skills if fires_broadly(s.path / "SKILL.md")}
    reasons: dict[str, str] = {}
    candidates: list[SkillSrc] = []
    for s in skills:
        if s.name in floor_names:
            continue
        if s.name in broad:
            reasons[s.name] = "fires broadly by its own description: the receiver opts in"
        elif s.name in holds:
            reasons[s.name] = f"held at a receiving door ({' and '.join(holds[s.name])}): the receiver opts in"
        elif states.get(s.name) == "RED":
            reasons[s.name] = "its last test-kit result is RED"
        elif not door_ok:
            reasons[s.name] = "the door check could not run"
        else:
            candidates.append(s)

    days, said, checked = ({}, [], False)
    if usage_dirs:
        days, said, checked = usage_days(usage_dirs, now)
    else:
        said = ["no transcript folder was named"]

    def key(s: SkillSrc):
        unchecked = 1 if states.get(s.name) in (None, "UNCHECKED") else 0
        return (unchecked, -days.get(s.name, 0), description_chars(s.path / "SKILL.md"), s.name)

    ranked_order = sorted(candidates, key=key)
    total = pop.total
    pct = house[size] if size else None
    ranked: list[tuple[SkillSrc, int]] = []
    if size:
        n = picks_for(house[size], total, len(fl))
        ranked = [(s, days.get(s.name, 0)) for s in ranked_order[:n]]
        if n > len(candidates):
            problems.append(f"{size.upper()} asks for {n} picks and only {len(candidates)} "
                            "skills can be picked: all of them are installed")
    drawn: list[SkillSrc] = []
    if rnd:
        seed = seed if seed not in (None, "") else secrets.token_hex(8)
        rest = sorted((s for s in candidates if s.name not in {r.name for r, _ in ranked}),
                      key=lambda s: s.name)
        k = len(rest) if rnd == "all" else min(len(rest), picks_for(house[rnd], total, len(fl)))
        drawn = sorted(_random.Random(str(seed)).sample(rest, k), key=lambda s: s.name)
    chosen = floor_names | {s.name for s, _ in ranked} | {s.name for s in drawn}
    soft = []
    for s in skills:
        if s.name in chosen:
            continue
        why = reasons.get(s.name)
        if why is None:
            if size and rnd:
                why = f"below the {size.upper()} line, and not drawn"
            elif size:
                why = f"below the {size.upper()} line"
            else:
                why = "not drawn"
        soft.append((s, why))
    return Selection(size=size, rnd=rnd, pct=pct, seed=seed if rnd else None,
                     population=pop, floor=fl, ranked=ranked, drawn=drawn, soft=soft,
                     holds=holds, states=states, usage_said=said, usage_checked=checked,
                     problems=problems, notes=list(pop.notes))


# ------------------------------------------------------------- the packaging --

_LAUNCH_ANCHOR = "\nfrom polygram.mcp.__main__ import main   # noqa: E402 -- after sys.path, on purpose\n"
_LAUNCH_SOFT = '''
# A SIZED EDITION (2026-09-28): the garden skills this edition does not install
# sit in ../SOFT-SKILLS.  mentcached reads soft skills from $SOFT_SKILLS when no
# softskills.roots preference is set; unless the environment already says, point
# it at the usual folder beside the seat first, then at this edition's own.
_SOFT = os.path.join(os.path.dirname(_HERE), "SOFT-SKILLS")
if os.path.isdir(_SOFT) and not os.environ.get("SOFT_SKILLS"):
    os.environ["SOFT_SKILLS"] = os.pathsep.join(
        [os.path.join(os.path.expanduser("~"), ".mentcached", "SOFT-SKILLS"), _SOFT])
'''


def launch_variant(base: str) -> str:
    """The launcher with the soft-skill block, as an asserted replacement (a copy
    drifts; a replace whose anchor stopped matching raises instead of shipping)."""
    if base.count(_LAUNCH_ANCHOR) != 1:
        raise RuntimeError("launch.py anchor not found: the sized launcher would ship without its soft-skill folder")
    return base.replace(_LAUNCH_ANCHOR, _LAUNCH_SOFT + _LAUNCH_ANCHOR)


def _names(items) -> str:
    return ", ".join(f"`{s}`" for s in items) if items else "none"


def readme_section(sel: Selection, *, name: str, now: _dt.datetime, house: dict[str, int],
                   command: str) -> str:
    """This edition, read back in words (the keeper does not read TSV)."""
    L: list[str] = ["", f"## This edition: `{name}`", ""]
    what = []
    if sel.size:
        what.append(f"**{sel.size.upper()}**, {sel.pct} percent")
    if sel.rnd:
        what.append(f"**RANDOM** ({'every skill that can be picked' if sel.rnd == 'all' else sel.rnd.upper() + ' many'})")
    L.append(f"Size: {' plus '.join(what)}. Minted {now.date().isoformat()} from the garden's records "
             "as of that day; the full edition, `vibrobeast`, carries every garden skill.")
    L.append("")
    L.append(f"The population it is sized from: {sel.population.say()}. The floor of "
             f"{len(sel.floor)} is installed on top of the percentage (house numbers, as settings: "
             f"GRAIN {house['grain']}, GREAT {house['great']}, GRAND {house['grand']}).")
    L.append("")
    L.append(f"**The floor** (always installed, whatever the ranking): {_names(s.name for s in sel.floor)}.")
    held = [f"`{s.name}` is held at a receiving door ({' and '.join(sel.holds[s.name])})"
            for s in sel.floor if s.name in sel.holds]
    red = [f"`{s.name}`" for s in sel.floor if sel.states.get(s.name) == "RED"]
    if held:
        L.append("Floor skills held at a receiving door, installed anyway and said here: " + "; ".join(held) + ".")
    if red:
        L.append("Floor skills whose last test-kit result is RED, installed anyway and said here: " + ", ".join(red) + ".")
    L.append("")
    if sel.size:
        if sel.ranked and sel.usage_checked:
            L.append(f"**Picked by use** ({len(sel.ranked)}; distinct days used in the last {WINDOW_DAYS}, "
                     "health first, the shorter description on a tie):")
            L.append("")
            for s, d in sel.ranked:
                L.append(f"- `{s.name}`: used on {d} day(s)")
        elif sel.ranked:
            L.append(f"**Picked** ({len(sel.ranked)}): use was NOT CHECKED, so these are ranked by "
                     "health, then by the shorter description:")
            L.append("")
            for s, _d in sel.ranked:
                L.append(f"- `{s.name}`")
        else:
            L.append("**Picked by use:** none.")
        L.append("")
    if sel.rnd:
        L.append(f"**Picked at random** ({len(sel.drawn)}, seed `{sel.seed}`), to find skills our "
                 "ranking under-favours. Which of these helped is worth telling us. To mint this "
                 f"same set again: `{command} SEED={sel.seed}`.")
        L.append("")
        for s in sel.drawn:
            L.append(f"- `{s.name}`")
        L.append("")
    L.append(f"**Kept soft** ({len(sel.soft)}), in `SOFT-SKILLS/`: not installed, still here. "
             "`soft_skills_list` names them, `soft_skill_read NAME` reads one, and garden-usage "
             "answers which one fits. Each one, and why:")
    L.append("")
    L.append("If you set the `softskills.roots` preference (the install notes above suggest it), put this "
             "edition's own `SOFT-SKILLS` folder in it too: a set preference is read instead of the "
             "folder this edition's launcher names. `soft_skills_list` says which folders it read.")
    L.append("")
    by_reason: dict[str, list[str]] = {}
    for s, why in sel.soft:
        by_reason.setdefault(why, []).append(s.name)
    for why, ns in sorted(by_reason.items()):
        L.append(f"- {why}: {_names(sorted(ns))}")
    L.append("")
    L.append("The use record: " + ("; ".join(sel.usage_said) if sel.usage_said else "none") + "."
             + ("" if sel.usage_checked else " Use NOT CHECKED is not zero use."))
    chars = sum(description_chars(s.path / "SKILL.md") for s in sel.installed)
    L.append(f"The installed descriptions ride every turn: {chars} characters.")
    for p in sel.problems:
        L.append(f"PROBLEM at mint: {p}.")
    L.append("")
    return "\n".join(L)


def discover_soft(root: Path) -> list[SkillSrc]:
    return discover(root / "SOFT-SKILLS", "soft")
