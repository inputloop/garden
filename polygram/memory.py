# polygram -- gated agent-skill synthesis.
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

"""Parse MEMORY notes and surface skill candidates.

Memory is a folder of one-fact markdown files plus a ``MEMORY.md`` index.
polygram reads *tags* out of those files to decide what wants to become a
skill. Two tag dialects are supported:

* Org-style trailing tags on a heading: ``# Some Title :EXTERN:GATED:``
* Inline hashtags in note bodies: ``#skill-candidate``

Frontmatter (``type:``) is parsed when present but optional. Everything here
is standard library only.
"""

from __future__ import annotations

import re
from collections import Counter
from dataclasses import dataclass, field
from pathlib import Path

# ``:TAG:`` or ``:TAG1:TAG2:`` at the end of a heading line.
_ORG_TAGS = re.compile(r":([A-Za-z][A-Za-z0-9_@:]*):\s*$")
# ``#tag`` hashtags inside body text (not markdown headings).
_HASHTAG = re.compile(r"(?<!\w)#([a-z][a-z0-9-]{2,})\b")
_FRONTMATTER = re.compile(r"^---\s*\n(.*?)\n---\s*\n", re.DOTALL)
_HEADING = re.compile(r"^(#{1,6})\s+(.*?)\s*$", re.MULTILINE)


@dataclass
class Note:
    """One parsed memory file."""

    path: Path
    title: str = ""
    note_type: str = ""
    tags: set[str] = field(default_factory=set)
    hashtags: set[str] = field(default_factory=set)
    body: str = ""

    @property
    def all_tags(self) -> set[str]:
        return {t.lower() for t in (self.tags | self.hashtags)}


@dataclass
class Candidate:
    """A keyword/tag cluster that may deserve a skill."""

    label: str
    weight: int
    sources: list[Path] = field(default_factory=list)
    reason: str = ""


def _parse_frontmatter(text: str) -> tuple[dict[str, str], str]:
    m = _FRONTMATTER.match(text)
    if not m:
        return {}, text
    fm: dict[str, str] = {}
    for line in m.group(1).splitlines():
        if ":" in line and not line.strip().startswith("#"):
            key, _, val = line.partition(":")
            fm[key.strip()] = val.strip()
    return fm, text[m.end():]


def parse_note(path: Path) -> Note:
    text = path.read_text(encoding="utf-8", errors="replace")
    fm, body = _parse_frontmatter(text)

    title = fm.get("name", "")
    org_tags: set[str] = set()
    for hashes, heading in _HEADING.findall(body):
        if not title:
            title = heading
        tagmatch = _ORG_TAGS.search(heading)
        if tagmatch:
            org_tags.update(p for p in tagmatch.group(1).split(":") if p)

    hashtags = set(_HASHTAG.findall(body))

    return Note(
        path=path,
        title=title or path.stem,
        note_type=fm.get("type", ""),
        tags=org_tags,
        hashtags=hashtags,
        body=body.strip(),
    )


def load_notes(memory_dir: Path) -> list[Note]:
    """Parse every ``*.md`` under *memory_dir* except the index file."""
    if not memory_dir.is_dir():
        return []
    notes = []
    for path in sorted(memory_dir.rglob("*.md")):
        if path.name == "MEMORY.md":
            continue
        if ".git" in path.parts:
            continue
        notes.append(parse_note(path))
    return notes


# Tags that control synthesis rather than name a skill. A note carrying one of
# these is a human saying "promote this note's real tags" -- the control tag
# itself never becomes a skill.
CONTROL_TAGS = {"skill-candidate", "skill", "synth"}

# Hex colour codes (e.g. ffcc00) get harvested out of extern docs/diagrams by
# raw frequency but are never real skills. Skip a 6-hex-digit token that
# contains at least one digit (spares pure-letter words like "facade").
_HEX_NOISE = re.compile(r"^[0-9a-f]{6}$")


def _is_noise_tag(tag: str) -> bool:
    return bool(_HEX_NOISE.match(tag)) and any(c.isdigit() for c in tag)


def candidates(notes: list[Note], threshold: int = 2) -> list[Candidate]:
    """Cluster tags across notes; anything at or above *threshold* is a candidate.

    A control tag (``:SKILL:`` / ``#skill-candidate``) on a note force-promotes
    that note's *other* tags regardless of frequency, but is never itself a
    candidate.
    """
    weights: Counter[str] = Counter()
    sources: dict[str, list[Path]] = {}
    forced: set[str] = set()

    for note in notes:
        real_tags = {t for t in note.all_tags
                     if t not in CONTROL_TAGS and not _is_noise_tag(t)}
        note_forces = bool(note.all_tags & CONTROL_TAGS)
        for tag in real_tags:
            weights[tag] += 1
            sources.setdefault(tag, []).append(note.path)
            if note_forces:
                forced.add(tag)

    out: list[Candidate] = []
    for tag, weight in weights.most_common():
        promoted = weight >= threshold or tag in forced
        if not promoted:
            continue
        reason = (
            "explicitly flagged" if tag in forced
            else f"appears in {weight} notes"
        )
        out.append(
            Candidate(label=tag, weight=weight, sources=sources[tag], reason=reason)
        )
    return out
