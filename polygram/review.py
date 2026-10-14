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

"""HOLD review: the operator's desk for candidates the gate didn't auto-pass.

A ``HOLD`` verdict means "plausible, but not enough signal to synthesize on its
own." This module replays the gate, annotates each held candidate with the
extern it came from (and whether that extern is frozen), and provides the three
operator actions:

* **promote** -- override the gate and synthesize the skill anyway (recorded to
  advice as an operator decision, so the paper trail stays honest);
* **reject**  -- record a REJECT verdict and drop it;
* **freeze-extern** -- pin the upstream a held candidate came from so it stops
  churning while you decide.

Pure/stdlib; takes a Workspace and the externs Manifest.
"""

from __future__ import annotations

from dataclasses import dataclass, replace

from . import config as _config, gate, memory, synth
from .config import Workspace
from .externs import Extern, Manifest


@dataclass
class ReviewItem:
    candidate: memory.Candidate
    verdict: gate.Verdict
    extern: Extern | None  # owning upstream, if the sources live under one

    @property
    def from_frozen(self) -> bool:
        return bool(self.extern and self.extern.frozen)


def build(ws: Workspace, manifest: Manifest, *, threshold: int = 2) -> list[ReviewItem]:
    """Replay the gate over current memory and annotate every candidate."""
    notes = memory.load_notes(ws.memory)
    # Extern clones contribute their own notes; each extern dir is scanned so
    # its tags can surface as candidates (and resolve back to the owning extern).
    if ws.externs.is_dir():
        # An extern contributes ONLY its polygram-native memory/ notes, never
        # arbitrary docs in the cloned repo. Scanning a whole upstream tree let
        # supply-chain noise surface as candidates (e.g. a Mermaid `fill:#ffcc00`
        # token harvested by frequency); restricting to <extern>/memory/ keeps
        # the "externs feed candidates" feature without the bleed-through.
        for child in sorted(ws.externs.iterdir()):
            if child.is_dir():
                notes += memory.load_notes(child / _config.MEMORY_DIR)
    items: list[ReviewItem] = []
    rejected = gate.past_rejects(ws.advice)
    for cand in memory.candidates(notes, threshold=threshold):
        verdict = gate.apply_durable_rejects(
            [gate.evaluate(cand)], ws.advice, rejected=rejected)[0]
        owner = None
        for src in cand.sources:
            owner = manifest.owning_extern(src, ws.externs)
            if owner is not None:
                break
        items.append(ReviewItem(candidate=cand, verdict=verdict, extern=owner))
    return items


def held(items: list[ReviewItem]) -> list[ReviewItem]:
    return [it for it in items if it.verdict.decision == gate.HOLD]


def find(items: list[ReviewItem], label: str) -> ReviewItem | None:
    for it in items:
        if it.candidate.label == label:
            return it
    return None


def promote(ws: Workspace, item: ReviewItem, *, overwrite: bool = False):
    """Operator override: force a HOLD/REJECT candidate through to synthesis."""
    forced = replace(
        item.verdict,
        decision=gate.PASS,
        signals=[*item.verdict.signals, "operator promoted from HOLD review (+force)"],
    )
    gate.record_advice(ws.advice, forced)
    return synth.synthesize(ws.skills, forced, overwrite=overwrite)


def reject(ws: Workspace, item: ReviewItem):
    """Operator override: record a REJECT verdict for a held candidate."""
    rejected = replace(
        item.verdict,
        decision=gate.REJECT,
        signals=[*item.verdict.signals, "operator rejected in HOLD review"],
    )
    return gate.record_advice(ws.advice, rejected)
