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

"""The ``.gate`` dotfile: an access sign-post at a directory root.

Not the candidate gate (see ``gate.py`` — PASS/HOLD/REJECT for skill
synthesis). This is the *other* gate: a one-file convention declaring what
tool traffic a directory tree consents to. Sign-post, not cathedral — the
file states policy; enforcement grows elsewhere (ethicsminions can learn to
check tool traffic against it).

Format — self-describing fields, ``key: value`` lines, ``#`` comments:

    policy:  read-write | read-only | write-only | none
    reason:  free text — why this policy, so the sign-post is auditable
    since:   ISO date the policy took effect
    embargo: (optional) while PRESENT, egress — the ``publish`` op — is
             denied. Any date or condition in the value is documentation
             of intent, never a mechanism: a date passing is silence, and
             silence ≠ consent. No timer ever lifts an embargo; a human
             lifts it by editing this file, and the file's history is the
             audit trail.
    lift:    (optional) who may lift the embargo and by what protocol
             (e.g. "Corwin, by editing this file" or "2/2 consent-gate").

Semantics: the *nearest* ``.gate`` walking up from a path governs it
(closer signs override farther ones). No ``.gate`` found means ungated —
absence of a sign is not consent, it is merely silence; callers decide.
``policy`` governs local traffic (read/write); ``embargo`` governs egress
(publish) and is orthogonal — an embargoed tree is usually one you *can*
read and work, just not move out. Unknown keys are preserved but ignored
(forward-compatible). A missing or invalid ``policy`` makes the gate
unparseable and the check errors rather than guessing — fail closed,
never fabricate consent.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path

GATE_NAME = ".gate"

POLICIES = ("read-write", "read-only", "write-only", "none")

_ALLOW = {
    "read": {"read-write", "read-only"},
    "write": {"read-write", "write-only"},
}


class GateError(ValueError):
    """A .gate file exists but cannot be trusted (bad or missing policy)."""


@dataclass
class Gate:
    """One parsed .gate file."""

    root: Path                      # directory the sign-post governs
    policy: str
    reason: str = ""
    since: str = ""
    embargo: str = ""               # presence denies publish; value is intent
    lift: str = ""                  # who/how the embargo lifts
    extra: dict[str, str] = field(default_factory=dict)

    def allows(self, op: str) -> bool:
        if op == "publish":
            # Presence of an embargo denies egress, full stop. The value —
            # date or condition — is never evaluated: no timer lifts it.
            return not self.embargo
        if op not in _ALLOW:
            raise GateError(
                f"unknown operation {op!r} (read|write|publish)")
        return self.policy in _ALLOW[op]

    def describe(self) -> str:
        parts = [f"policy: {self.policy}"]
        if self.embargo:
            parts.append(f"embargo: {self.embargo}")
        if self.lift:
            parts.append(f"lift: {self.lift}")
        if self.reason:
            parts.append(f"reason: {self.reason}")
        if self.since:
            parts.append(f"since: {self.since}")
        parts.append(f"root: {self.root}")
        return "\n".join(parts)


def parse(path: Path) -> Gate:
    """Parse one .gate file; raise GateError if policy is absent/invalid."""
    fields: dict[str, str] = {}
    extra: dict[str, str] = {}
    for raw in path.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#") or ":" not in line:
            continue
        key, _, value = line.partition(":")
        key, value = key.strip().lower(), value.strip()
        if key in ("policy", "reason", "since", "embargo", "lift"):
            fields[key] = value
        else:
            extra[key] = value
    policy = fields.get("policy", "")
    if policy not in POLICIES:
        raise GateError(
            f"{path}: policy must be one of {'|'.join(POLICIES)}, "
            f"got {policy!r}")
    return Gate(root=path.parent, policy=policy,
                reason=fields.get("reason", ""),
                since=fields.get("since", ""),
                embargo=fields.get("embargo", ""),
                lift=fields.get("lift", ""), extra=extra)


def nearest(start: Path) -> Gate | None:
    """Find the governing .gate for *start*: nearest one walking up.

    *start* may be a file or directory; it need not exist. Returns None
    when no .gate governs the path (ungated — silence, not consent).
    """
    node = start if start.is_dir() else start.parent
    node = node.resolve()  # once, before walking: symlink/relative edge
    for candidate in (node, *node.parents):
        sign = candidate / GATE_NAME
        if sign.is_file():
            return parse(sign)
    return None


def check(path: Path, op: str) -> tuple[bool, Gate | None]:
    """Is *op* ('read'|'write'|'publish') allowed at *path*? -> (allowed, gate).

    Ungated paths return (True, None): the sign-post convention only
    *restricts* where a sign is posted; it does not invent authority
    where none is declared.
    """
    gate = nearest(path)
    if gate is None:
        return True, None
    return gate.allows(op), gate
