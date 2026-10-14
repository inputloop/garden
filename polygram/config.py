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

"""Workspace layout and configuration for a polygram root.

A polygram *workspace* is any directory containing a ``.polygram`` marker.
Everything is resolved relative to that root so the tooling works the same
whether invoked from the repo top or a subdirectory.
"""

from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path

MARKER = ".polygram"

# Subdirectories that make up a workspace.
SKILLS_DIR = "skills"     # curated / synthesized skills land here
ADVICE_DIR = "advice"     # growing history of gate evaluations ("advice")
MEMORY_DIR = "memory"     # local memory notes; tags here drive synthesis
MEMORY_INDEX = "MEMORY.md"  # one-line-per-note index, loaded each session
EXTERNS_DIR = "externs"   # cloned upstream skill sources
EXTERNS_MANIFEST = "externs.json"  # registry of externs (name -> record)
DIST_DIR = "dist"         # minted distributable archives (.tar.gz/.zip)


@dataclass(frozen=True)
class Workspace:
    """Resolved paths for a polygram workspace."""

    root: Path

    @property
    def marker(self) -> Path:
        return self.root / MARKER

    @property
    def skills(self) -> Path:
        return self.root / SKILLS_DIR

    @property
    def advice(self) -> Path:
        return self.root / ADVICE_DIR

    @property
    def memory(self) -> Path:
        return self.root / MEMORY_DIR

    @property
    def externs(self) -> Path:
        return self.root / EXTERNS_DIR

    @property
    def externs_manifest(self) -> Path:
        return self.root / EXTERNS_MANIFEST

    @property
    def dist(self) -> Path:
        return self.root / DIST_DIR

    @property
    def memory_index(self) -> Path:
        return self.root / MEMORY_INDEX

    def exists(self) -> bool:
        return self.marker.is_file()

    def ensure(self) -> "Workspace":
        """Create the workspace skeleton if it does not yet exist."""
        self.root.mkdir(parents=True, exist_ok=True)
        for d in (self.skills, self.advice, self.memory, self.externs):
            d.mkdir(parents=True, exist_ok=True)
        if not self.marker.exists():
            self.marker.write_text(
                "# polygram workspace marker\nversion: 1\n", encoding="utf-8", newline="")
        if not self.memory_index.exists():
            self.memory_index.write_text(
                "# MEMORY\n\nOne line per note. Tags here drive skill synthesis.\n",
                encoding="utf-8", newline="")
        return self


def find_root(start: os.PathLike | str | None = None) -> Path | None:
    """Walk upward from *start* looking for a ``.polygram`` marker."""
    here = Path(start or Path.cwd()).resolve()
    for candidate in (here, *here.parents):
        if (candidate / MARKER).is_file():
            return candidate
    return None


def load(start: os.PathLike | str | None = None) -> Workspace | None:
    root = find_root(start)
    return Workspace(root) if root else None
