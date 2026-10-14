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

"""External upstream sources ("externs") that polygram clones in.

An *extern* is a remote source of skills/memory we pull into the workspace so
its tags can feed synthesis. Each extern is recorded in a JSON manifest at the
workspace root (``externs.json``) and cloned under ``externs/<name>/``.

**Freezing** pins an extern at a specific revision: a frozen extern is skipped
by ``sync`` (never re-pulled) and its candidates are flagged frozen during
review, so an upstream you depend on can't silently churn your skills.

Standard library only. Git is invoked through ``subprocess`` (the POSIX
tooling layer); all manifest/freeze logic is pure and git-independent.
"""

from __future__ import annotations

import datetime as _dt
import json
import os
import subprocess
from dataclasses import asdict, dataclass, field
from pathlib import Path


class ManifestError(Exception):
    """externs.json is unparseable, malformed, or failed write verification.

    Raised instead of leaking a raw ``json.JSONDecodeError`` so callers (and
    ``polygram doctor``) can report something actionable when the manifest is
    truncated or hand-edited out from under the tooling.
    """


@dataclass
class Extern:
    name: str
    url: str
    ref: str = "main"
    rev: str = ""            # last observed commit of the working copy
    frozen: bool = False
    frozen_rev: str = ""     # the pinned commit when frozen
    added_at: str = ""
    updated_at: str = ""
    kind: str = "git"        # "git" = cloned remote; "local" = hand-authored snapshot

    def pinned_rev(self) -> str:
        return self.frozen_rev if self.frozen else self.rev

    def is_local(self) -> bool:
        return self.kind == "local"

    def status(self) -> str:
        if self.is_local():
            return "LOCAL snapshot" + (" FROZEN" if self.frozen else "")
        if self.frozen:
            return f"FROZEN @ {self.frozen_rev[:8] or '?'}"
        return f"tracking {self.ref}" + (f" @ {self.rev[:8]}" if self.rev else "")


class Manifest:
    """The set of registered externs, persisted as JSON at *path*."""

    def __init__(self, path: Path, externs: dict[str, Extern] | None = None):
        self.path = path
        self.externs: dict[str, Extern] = externs or {}

    @classmethod
    def load(cls, path: Path) -> "Manifest":
        if not path.is_file():
            return cls(path)
        raw = path.read_text(encoding="utf-8") or "{}"
        try:
            data = json.loads(raw)
        except json.JSONDecodeError as exc:
            raise ManifestError(
                f"{path} is not valid JSON ({exc}). It may be truncated or "
                f"hand-edited; restore it from version control or re-run "
                f"'polygram extern add'."
            ) from exc
        if not isinstance(data, dict):
            raise ManifestError(
                f"{path}: expected a JSON object of externs, got "
                f"{type(data).__name__}."
            )
        try:
            externs = {name: Extern(**rec) for name, rec in data.items()}
        except TypeError as exc:
            raise ManifestError(f"{path}: malformed extern record ({exc}).") from exc
        return cls(path, externs)

    def save(self) -> None:
        """Serialize atomically and verify the bytes landed.

        The Windows mount silently truncates writes (see
        ``git-fails-on-windows-mount``), which is exactly how externs.json got
        corrupted before. We write to a temp file, confirm it reads back whole,
        ``os.replace`` it into place, then re-read the final file to be sure.
        """
        data = {name: asdict(e) for name, e in sorted(self.externs.items())}
        text = json.dumps(data, indent=2, sort_keys=True) + "\n"
        tmp = self.path.with_name(self.path.name + ".tmp")
        tmp.write_text(text, encoding="utf-8", newline="")
        if tmp.read_text(encoding="utf-8") != text:
            tmp.unlink(missing_ok=True)
            raise ManifestError(
                f"{self.path}: write verification failed (short write to "
                f"{tmp.name}); manifest left untouched."
            )
        os.replace(tmp, self.path)
        if self.path.read_text(encoding="utf-8") != text:
            raise ManifestError(
                f"{self.path}: post-write verification failed; the file on "
                f"disk does not match what was written."
            )

    # -- integrity -------------------------------------------------------
    def reconcile(self, externs_dir: Path) -> list[str]:
        """Cross-check the manifest against ``externs/<name>/`` clone dirs.

        Returns a list of human-readable problems; an empty list means the
        manifest and the cloned working copies agree. Pure/read-only.
        """
        return [msg for _absent, msg in self._findings(externs_dir)]

    def triage(self, externs_dir: Path) -> tuple[list[str], list[str]]:
        """Split :meth:`reconcile` into ``(notes, problems)``.

        A registered extern whose ``externs/<name>/`` does not exist AT ALL has
        simply never been fetched here -- the normal state of a fresh clone,
        where externs.json is tracked and externs/ is gitignored (audit N4,
        2026-09-27).  That is a note.  Anything present but wrong (not a git
        clone, an empty local snapshot, a stray directory, no url) stays a
        problem.  Same messages as reconcile(), only sorted into two piles.
        """
        notes: list[str] = []
        problems: list[str] = []
        for absent, msg in self._findings(externs_dir):
            (notes if absent else problems).append(msg)
        return notes, problems

    def _findings(self, externs_dir: Path) -> list[tuple[bool, str]]:
        """(absent, message) per finding; absent = the dir was never there."""
        out: list[tuple[bool, str]] = []
        for name, e in sorted(self.externs.items()):
            clone = externs_dir / name
            if e.is_local():
                # A local snapshot is hand-authored, not cloned: a populated
                # dir without .git is exactly right; only an empty/missing one
                # is a problem.
                if not clone.exists():
                    out.append((True,
                        f"{name}: local extern, externs/{name}/ absent here "
                        f"(a snapshot its keeper holds; nothing to fetch)"))
                elif not clone.is_dir() or not any(clone.iterdir()):
                    out.append((False,
                        f"{name}: local extern but externs/{name}/ is missing "
                        f"or empty"))
                continue
            if not e.url:
                out.append((False, f"{name}: no url recorded"))
            if not clone.exists():
                out.append((True,
                    f"{name}: registered but not cloned (externs/{name}/ "
                    f"missing; run `sh bin/polygram extern sync` to fetch)"))
            elif not (clone / ".git").exists():
                out.append((False,
                    f"{name}: externs/{name}/ exists but is not a git clone"))
        if externs_dir.is_dir():
            for child in sorted(externs_dir.iterdir()):
                if child.is_dir() and child.name not in self.externs:
                    out.append((False,
                        f"externs/{child.name}/ present but not in the manifest "
                        f"(run 'polygram extern add' or remove the directory)"))
        return out

    # -- mutations -------------------------------------------------------
    def add(self, name: str, url: str, ref: str = "main",
            now: _dt.datetime | None = None) -> Extern:
        if name in self.externs:
            raise KeyError(f"extern {name!r} already registered")
        stamp = (now or _dt.datetime.now()).isoformat(timespec="seconds")
        e = Extern(name=name, url=url, ref=ref, added_at=stamp, updated_at=stamp)
        self.externs[name] = e
        return e

    def get(self, name: str) -> Extern:
        if name not in self.externs:
            raise KeyError(f"no such extern: {name!r}")
        return self.externs[name]

    def remove(self, name: str) -> None:
        self.externs.pop(name, None)

    def freeze(self, name: str, rev: str | None = None) -> Extern:
        e = self.get(name)
        e.frozen = True
        e.frozen_rev = rev if rev is not None else (e.rev or e.frozen_rev)
        e.updated_at = _dt.datetime.now().isoformat(timespec="seconds")
        return e

    def unfreeze(self, name: str) -> Extern:
        e = self.get(name)
        e.frozen = False
        e.frozen_rev = ""
        e.updated_at = _dt.datetime.now().isoformat(timespec="seconds")
        return e

    def owning_extern(self, path: Path, externs_dir: Path) -> Extern | None:
        """Return the extern whose clone dir contains *path*, if any."""
        try:
            rel = Path(path).resolve().relative_to(externs_dir.resolve())
        except (ValueError, OSError):
            return None
        top = rel.parts[0] if rel.parts else ""
        return self.externs.get(top)


# -- git tooling layer (subprocess; degrades gracefully) -----------------

def _git(args: list[str], cwd: Path | None = None) -> tuple[int, str]:
    try:
        p = subprocess.run(
            ["git", *args], cwd=str(cwd) if cwd else None,
            capture_output=True, text=True, encoding="utf-8", timeout=120,
        )
        return p.returncode, (p.stdout or p.stderr).strip()
    except (FileNotFoundError, subprocess.SubprocessError) as exc:
        return 127, str(exc)


def current_rev(repo: Path) -> str:
    code, out = _git(["rev-parse", "HEAD"], cwd=repo)
    return out if code == 0 else ""


def sync(extern: Extern, externs_dir: Path) -> tuple[str, str]:
    """Clone or update one extern. Returns (state, detail).

    Frozen externs are never pulled; on a fresh frozen target we still clone
    and check out the pinned rev so the working copy matches the manifest.
    """
    dest = externs_dir / extern.name
    externs_dir.mkdir(parents=True, exist_ok=True)

    if extern.is_local():
        return "local", "snapshot (not synced)"

    if not (dest / ".git").exists():
        code, out = _git(["clone", "--depth", "1", "--branch", extern.ref,
                          extern.url, str(dest)])
        if code != 0:
            return "error", out
        if extern.frozen and extern.frozen_rev:
            _git(["fetch", "--depth", "1", "origin", extern.frozen_rev], cwd=dest)
            _git(["checkout", extern.frozen_rev], cwd=dest)
        extern.rev = current_rev(dest)
        return "cloned", extern.rev[:8]

    if extern.frozen:
        return "skipped", f"frozen @ {extern.frozen_rev[:8] or '?'}"

    code, out = _git(["pull", "--ff-only"], cwd=dest)
    if code != 0:
        return "error", out
    extern.rev = current_rev(dest)
    return "updated", extern.rev[:8]
