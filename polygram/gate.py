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

"""The gate: evaluate a skill candidate before it is allowed to synthesize.

"Gated" synthesis means nothing becomes a skill on autopilot. Each candidate
is scored on a few cheap, deterministic signals; the verdict plus its
reasoning is written to the ``advice/`` store as a timestamped markdown file.
Over time those files form a growing history of "advice" the operator (and
Claude) can read back.

The heuristics here are intentionally simple and explainable — the point is a
defensible paper trail, not a clever classifier.
"""

from __future__ import annotations

import datetime as _dt
from dataclasses import dataclass, field
from pathlib import Path

from .memory import Candidate

PASS = "PASS"
HOLD = "HOLD"
REJECT = "REJECT"


@dataclass
class Verdict:
    candidate: Candidate
    score: int
    decision: str
    signals: list[str] = field(default_factory=list)

    @property
    def gated_open(self) -> bool:
        return self.decision == PASS


# `score_to_pass` was `threshold_pass` until 2026-09-17.  Renamed because the old
# name reads as an attempt count, and THE BUILD LOOP's cap of three swings is an
# attempt count -- two different threes, one word.  This three is a SCORE.
def evaluate(candidate: Candidate, *, score_to_pass: int = 3,
             threshold_hold: int = 1) -> Verdict:
    """Score a candidate on quality + applicability signals."""
    score = 0
    signals: list[str] = []

    # Signal: corroboration across multiple notes => more durable.
    n = len(set(candidate.sources))
    if n >= 2:
        score += 2
        signals.append(f"corroborated by {n} distinct notes (+2)")
    else:
        signals.append("single source (+0)")

    # An operator flag only *surfaces* a candidate (gets it past the frequency
    # threshold); it deliberately adds no score, so flagged-but-thin items land
    # on HOLD for review rather than auto-passing.
    if "flagged" in candidate.reason:
        signals.append("surfaced by operator flag (no score; lands on HOLD)")

    # Signal: label looks actionable (a verb-ish or domain noun, not noise).
    label = candidate.label
    if (len(label) >= 4 and "-" in label) or label.isalpha():
        score += 1
        signals.append("label is well-formed (+1)")

    # Signal: penalise overly generic labels that would make a vague skill.
    if label in {"note", "todo", "misc", "general", "stuff", "thing"}:
        score -= 2
        signals.append("label too generic (-2)")

    if score >= score_to_pass:
        decision = PASS
    elif score >= threshold_hold:
        decision = HOLD
    else:
        decision = REJECT

    return Verdict(candidate=candidate, score=score, decision=decision,
                   signals=signals)


def past_rejects(advice_dir: Path) -> set[str]:
    """Labels whose latest recorded gate decision is REJECT.

    The durable-reject ledger IS the advice history: verdicts carry
    ``candidate:`` and ``decision:`` frontmatter and dated filenames sort
    chronologically, so the latest terminal decision (PASS or REJECT) per
    label wins. HOLD is not terminal and never overrides the ledger —
    otherwise the demotion this feeds would erase the very REJECT it
    enforces. A REJECT therefore stands until an operator's
    ``review --promote`` records a later PASS. (Gap found when a
    QC-rejected candidate re-materialized during the 0.5.4 mint prep.)
    """
    latest: dict[str, str] = {}
    if not advice_dir.is_dir():
        return set()
    for path in sorted(advice_dir.glob("*.md")):
        cand = dec = None
        try:
            with path.open(encoding="utf-8", errors="replace") as fh:
                for i, line in enumerate(fh):
                    if i > 12:
                        break
                    if line.startswith("candidate: "):
                        cand = line[len("candidate: "):].strip()
                    elif line.startswith("decision: "):
                        dec = line[len("decision: "):].strip()
        except OSError:
            continue
        if cand and dec in (PASS, REJECT):
            latest[cand] = dec
    return {c for c, d in latest.items() if d == REJECT}


def apply_durable_rejects(verdicts: list[Verdict], advice_dir: Path, *,
                          rejected: set[str] | None = None) -> list[Verdict]:
    """Demote re-surfaced candidates whose latest advice says REJECT.

    A durable REJECT never silently drops a candidate: it lands on HOLD
    with the history named in the signals, so ``review`` shows it and
    ``--promote`` (which records a later PASS) remains the one way through.
    """
    if rejected is None:
        rejected = past_rejects(advice_dir)
    if not rejected:
        return verdicts
    out: list[Verdict] = []
    for v in verdicts:
        if v.candidate.label in rejected and v.decision != REJECT:
            out.append(Verdict(
                candidate=v.candidate, score=v.score, decision=HOLD,
                signals=v.signals + [
                    "previously REJECTED in advice (durable) — held; "
                    "override with: review --promote"],
            ))
        else:
            out.append(v)
    return out


def _slug(text: str) -> str:
    keep = [c if c.isalnum() else "-" for c in text.lower()]
    return "".join(keep).strip("-") or "candidate"


def record_advice(advice_dir: Path, verdict: Verdict, *,
                  now: _dt.datetime | None = None) -> Path:
    """Append a verdict to the advice history; returns the file written."""
    advice_dir.mkdir(parents=True, exist_ok=True)
    # UTC with a Z (ERRATA E7, 2026-09-29): the host stamped local time and a VM UTC, neither said
    # which.  A naive ``now`` is read as local time and converted.
    now = (now or _dt.datetime.now(_dt.timezone.utc)).astimezone(_dt.timezone.utc)
    stamp = now.strftime("%Y%m%d-%H%M%SZ")
    path = advice_dir / f"{stamp}-{_slug(verdict.candidate.label)}.md"

    sources = "\n".join(f"  - {p}" for p in verdict.candidate.sources) or "  - (none)"
    body = (
        f"---\n"
        f"candidate: {verdict.candidate.label}\n"
        f"decision: {verdict.decision}\n"
        f"score: {verdict.score}\n"
        f"recorded: {now.isoformat(timespec='seconds')}\n"
        f"---\n\n"
        f"# Gate verdict: {verdict.candidate.label} -> {verdict.decision}\n\n"
        f"**Weight:** {verdict.candidate.weight}  "
        f"**Reason candidate surfaced:** {verdict.candidate.reason}\n\n"
        f"## Signals\n\n"
        + "\n".join(f"- {s}" for s in verdict.signals)
        + "\n\n## Sources\n\n"
        + sources
        + "\n"
    )
    path.write_text(body, encoding="utf-8", newline="")
    return path
