# polygram -- gated agent-skill synthesis.
# Copyright (C) 2026 Corwin <mplscorwin@gmail.com>
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

"""Synthesize a skill skeleton once the gate is open.

Given a PASS verdict, write a ``skills/<label>/SKILL.md`` skeleton plus a
stdlib-only ``tool.py`` stub wired to the candidate's keywords. Synthesis is
idempotent: an existing skill is never clobbered unless ``overwrite=True``.
"""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

from .gate import Verdict

_SKILL_TEMPLATE = """\
---
name: {label}
description: >-
  Synthesized by polygram from memory tag '{label}'. {reason}.
  Review and tighten this description before relying on it for triggering.
metadata:
  source: polygram-synth
  gate_score: {score}
---

# {title}

> Synthesized by polygram from the notes listed under Provenance; its steps are not written yet.

## When to use

Triggered around the theme **{label}** ({reason}).

## Steps

1. (describe the procedure this skill should encode)
2. (...)

## Tooling

A stub tool lives alongside this file as `tool.py`. Wire real behaviour in.

## Provenance

{sources}
"""

_TOOL_TEMPLATE = '''\
"""Stub tool for the '{label}' skill — synthesized by polygram (stdlib only)."""

from __future__ import annotations

import argparse

KEYWORDS = {keywords!r}


def run(args: argparse.Namespace) -> int:
    print("polygram stub tool for {label!r}; keywords:", ", ".join(KEYWORDS))
    return 0


def main() -> int:
    p = argparse.ArgumentParser(description="{label} tool")
    return run(p.parse_args())


if __name__ == "__main__":
    raise SystemExit(main())
'''


@dataclass
class Synthesized:
    label: str
    skill_dir: Path
    skill_md: Path
    tool_py: Path
    created: bool


def synthesize(skills_dir: Path, verdict: Verdict, *,
               overwrite: bool = False) -> Synthesized:
    if not verdict.gated_open:
        raise ValueError(
            f"gate is not open for {verdict.candidate.label!r} "
            f"(decision={verdict.decision})"
        )

    label = verdict.candidate.label
    skill_dir = skills_dir / label
    skill_md = skill_dir / "SKILL.md"
    tool_py = skill_dir / "tool.py"

    if skill_md.exists() and not overwrite:
        return Synthesized(label, skill_dir, skill_md, tool_py, created=False)

    skill_dir.mkdir(parents=True, exist_ok=True)
    sources = "\n".join(f"- {p}" for p in verdict.candidate.sources) or "- (none)"
    skill_md.write_text(
        _SKILL_TEMPLATE.format(
            label=label,
            title=label.replace("-", " ").title(),
            reason=verdict.candidate.reason,
            score=verdict.score,
            sources=sources,
        ),
        encoding="utf-8", newline="")
    tool_py.write_text(
        _TOOL_TEMPLATE.format(label=label, keywords=[label]),
        encoding="utf-8", newline="")
    return Synthesized(label, skill_dir, skill_md, tool_py, created=True)
