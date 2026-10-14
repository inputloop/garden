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

"""Mint distributable archives of curated skills.

The synthesis pipeline (memory -> gate -> synth) leaves curated skills under
``skills/``; ``dist`` is the *packaging* end of the same pipeline. It gathers
skills from one or more source roots — the workspace's own ``skills/`` plus any
installed "Mentat & family" skills you point it at — stages them into a single
tree, writes a ``MANIFEST`` with a SHA-256 per file, and mints ``.tar.gz`` and
``.zip`` artifacts under ``dist/``.

Like the rest of polygram this is standard library only and leaves a paper
trail: every mint records an advice file describing what went into the archive.

A *skill* is any directory that contains a ``SKILL.md``. Sources are scanned one
level deep (``<root>/<name>/SKILL.md``), which matches both the workspace
``skills/`` layout and the installed-skills cache.

Per-skill ``.skill`` bundles (2026-09-04): every bundle now carries a
``.skill-manifest`` (sha256 per file), not only the aggregate ``tar.gz``/
``zip`` archives. A skill that was already signed via ``skill-sign.sh``
keeps its own gpg-backed manifest untouched; an unsigned skill gets one
synthesized here in the same format, so a stranger with no gpg can still
hash-check the bundle (see ``skill-sign.sh``'s tiered ``verify`` and its
companion ``check.sh``). Bundles also carry the ``check.sh`` + ``SAYS-SO``
bundle template from ``skills/skill-sign/scripts/`` when present, unless the
skill already ships its own file of either name.
"""

from __future__ import annotations

import datetime as _dt
import hashlib
import os
import tarfile
import zipfile
from dataclasses import dataclass, field
from pathlib import Path

# Curated "Mentat & family" allowlist: the local-curation skills polygram is
# meant to ship. Used to filter an installed-skills source down to the family
# unless the caller asks for everything. Names match installed skill dir names.
MENTAT_FAMILY = (
    "candor-gate",
    "color-theory",
    "consent-gate",
    "consolidate-memory",
    "context-engineering-collection",
    "eclipse-pass",
    "medley-review",
    "mentat-skill",
    "pmo",
    "posix",
    "principles",
    "release-runbook",
    "sandboxer",
    "savane-forensics",
    "security-digest",
    "session-rotate",
    "skill-creator",
    "skill-sign",
    "skilltank"
)

FORMATS = ("tar.gz", "zip")          # aggregate archive formats
ALL_FORMATS = ("tar.gz", "zip", "skill")  # incl. per-skill installable bundles

# The CLI knows one more word than mint() does.  "plugin" is a different
# SHAPE -- one tree carrying MCP servers, not one bundle per skill -- and it
# is minted by polygram.plugin.  Keeping it out of ALL_FORMATS means mint()
# can never be handed a format it would quietly mis-build: an earlier draft
# put it in ALL_FORMATS, and mint() fell through to the generic zip branch
# and produced a file named ".plugin" that was an ordinary skills archive.
# Wrong bytes under a right-looking name is the worst failure a packager has.
CLI_FORMATS = ALL_FORMATS + ("plugin",)

# Editor/build cruft that must never ship inside a skill bundle.  ``.arc`` is
# the mirror-tree archive of the dormant (see ``.arc/README.md``): parked
# copies of superseded files, each beside the signature that covered it.
# A skill carrying one would otherwise ship its own history as content.
# skill-sign.sh's ``build_manifest`` prunes the SAME three names, so the
# express manifest and the mint agree on what a skill is (2026-09-24;
# tests/arc-never-ships.pl proves both, in a third language).
_JUNK_DIRS = {"__pycache__", ".git", ".arc"}
_JUNK_NAMES = {".DS_Store"}

# Filenames skill-sign.sh owns; kept as constants here so the two tools
# agree without importing across the python/shell boundary.
_MANIFEST_NAME = ".skill-manifest"
_SIGNATURE_NAME = ".signature.asc"

# The bundle template (check.sh + SAYS-SO): the no-gpg tier-1 checker and
# its 5-line explainer, sourced from beside skill-sign.sh so there is one
# physical copy for both bundling paths (this module's ``mint`` and
# skill-sign.sh's ``cmd_bundle``). Missing here (e.g. a checkout that
# doesn't carry skills/skill-sign) just means bundles ship without the
# template — never a hard failure of the mint.
_TEMPLATE_DIR = Path(__file__).resolve().parent.parent / "skills" / "skill-sign" / "scripts"
_BUNDLE_TEMPLATE_FILES = ("check.sh", "SAYS-SO")


def _is_tmp_stray(name: str) -> bool:
    """True if *name* looks like an in-place editor's abandoned temp file.

    ``sed -i`` stages its rewrite in a mkstemp sibling named ``sed`` + 6
    random alnum chars; interrupt it (or copy the tree mid-edit) and the
    stray survives with content identical to the file being edited — which
    is exactly how ``sedx44W4d`` rode into the 0.5.3 mint.  Require a digit
    or uppercase in the suffix so real words ("sedation", "sediment") never
    trip the filter; a fully-lowercase mkstemp suffix is rare (<1%) and
    still caught by review.  Also covers vim swaps and emacs lockfiles,
    which share the same "tool residue next to the real file" shape.
    """
    if len(name) == 9 and name.startswith("sed"):
        suf = name[3:]
        if suf.isalnum() and any(c.isdigit() or c.isupper() for c in suf):
            return True
    if name.startswith(".") and name.endswith((".swp", ".swo", ".swx")):
        return True                                   # vim swap
    if name.startswith(".#"):
        return True                                   # emacs lockfile
    return False


def _rel(path: Path, base: Path) -> str:
    """*path* relative to *base* as a posix string.

    Deliberately NOT ``Path.relative_to``: mingw/msys Python builds hand
    pathlib mixed separators (``skills\\name/SKILL.md``) and 3.14's
    relative_to refuses them. ``os.path.relpath`` normalizes per-platform,
    so the same tree mints identically on the host and in the sandbox.
    """
    rel = os.path.relpath(str(path), str(base))
    return rel.replace(os.sep, "/").replace("\\", "/")


def _is_junk(path: Path, base: Path) -> bool:
    """True if *path* (under *base*) is editor/build cruft, not skill content."""
    if any(part in _JUNK_DIRS for part in _rel(path, base).split("/")):
        return True
    name = path.name
    if name in _JUNK_NAMES:
        return True
    if name.endswith((".pyc", ".tmp", "~")):
        return True
    if name.startswith("#") and name.endswith("#"):   # emacs autosave
        return True
    if _is_tmp_stray(name):
        return True
    return False


@dataclass
class SkillSrc:
    """One discovered skill directory and where it came from."""

    name: str
    path: Path
    origin: str  # human label for the source root (e.g. "workspace", "installed")


@dataclass
class DistResult:
    name: str
    version: str
    skills: list[SkillSrc]
    artifacts: list[Path] = field(default_factory=list)   # aggregate archives
    bundles: list[Path] = field(default_factory=list)     # per-skill .skill files
    retired: list[Path] = field(default_factory=list)     # stale bundles moved aside
    manifest: Path | None = None
    advice: Path | None = None
    checksums: dict[str, str] = field(default_factory=dict)  # archive name -> sha256


def discover(root: Path, origin: str, *, only: tuple[str, ...] | None = None,
             ) -> list[SkillSrc]:
    """Find skill dirs (``<root>/<name>/SKILL.md``) one level under *root*.

    If *only* is given, keep just those whose directory name is in the set.
    """
    if not root.is_dir():
        return []
    found: list[SkillSrc] = []
    for child in sorted(root.iterdir()):
        if not child.is_dir() or child.name.startswith("."):
            continue
        if not (child / "SKILL.md").is_file():
            continue
        if only is not None and child.name not in only:
            continue
        found.append(SkillSrc(name=child.name, path=child, origin=origin))
    return found


def collect(workspace_skills: Path,
            installed_roots: list[Path] | None = None, *,
            family_only: bool = True,
            include_workspace: bool = True,
            names: tuple[str, ...] | None = None) -> list[SkillSrc]:
    """Gather workspace skills plus optional installed sources, de-duplicated.

    Workspace skills always win on a name collision (your curation overrides an
    installed copy of the same name).

    ``include_workspace=False`` scopes the mint to the installed roots alone
    (CLI ``--sources-only``); ``names`` keeps only those skill dir names from
    every root (CLI ``--only NAME``). Added 2026-09-11: a dist meant for a few
    new skills was sweeping 21 workspace skills into ``skills/dist-*/`` with no
    way to say "just these" (memory/c4-forge-mint-2026-09-04.md:28).
    """
    out: dict[str, SkillSrc] = {}
    if include_workspace:
        for s in discover(workspace_skills, "workspace", only=names):
            out[s.name] = s
    only = tuple(MENTAT_FAMILY) if family_only else None
    if names is not None:
        only = tuple(names)  # a name asked for by hand outranks the family allowlist
    for root in installed_roots or []:
        for s in discover(root, "installed", only=only):
            out.setdefault(s.name, s)  # don't clobber workspace curation
    return [out[k] for k in sorted(out)]


def _sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as fh:
        for chunk in iter(lambda: fh.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()


def _canonical_skill_md_bytes(path: Path) -> bytes:
    """Reproduce skill-sign.sh's ``canonical_skill_content``: LF endings, no
    trailing whitespace per line, no trailing blank lines.

    Kept in lockstep with the awk version in skill-sign.sh on purpose: same
    bytes in, same hash out, on either side of the mint/sign boundary — a
    skill unpacked from a bundle this function manifested and then run
    through ``skill-sign.sh sign`` reproduces the SKILL.md hash exactly, if
    nothing actually changed.
    """
    raw = path.read_text(encoding="utf-8", errors="surrogateescape")
    lines = raw.replace("\r\n", "\n").replace("\r", "\n").split("\n")
    lines = [ln.rstrip(" \t") for ln in lines]
    while lines and lines[-1] == "":
        lines.pop()
    if not lines:
        return b""
    return ("\n".join(lines) + "\n").encode("utf-8", errors="surrogateescape")


def _skill_manifest_text(staged: list[tuple[Path, str]]) -> str:
    """Hash-only ``.skill-manifest`` text for one skill's staged files.

    Same format as skill-sign.sh's ``build_manifest`` (``sha256  ./path``,
    sorted, no header) so the two are interchangeable and a later
    ``skill-sign.sh sign`` reproduces this byte-for-byte if the content is
    unchanged. This manifest is UNSIGNED — it ships with no
    ``.signature.asc`` — see skill-sign.sh's tiered ``verify`` for what that
    does and doesn't prove.
    """
    entries: list[tuple[str, str]] = []
    for abspath, rel in staged:
        arc = f"./{rel}"
        if rel == "SKILL.md":
            digest = hashlib.sha256(_canonical_skill_md_bytes(abspath)).hexdigest()
        else:
            digest = _sha256(abspath)
        entries.append((arc, digest))
    entries.sort(key=lambda e: e[0])
    return "".join(f"{digest}  {arc}\n" for arc, digest in entries)


def _staged_files(skill: SkillSrc) -> list[tuple[Path, str]]:
    """(absolute file, arcname-relative-to-skill-dir) for every file in a skill."""
    pairs: list[tuple[Path, str]] = []
    for f in sorted(skill.path.rglob("*")):
        if f.is_file() and not _is_junk(f, skill.path):
            pairs.append((f, _rel(f, skill.path)))
    return pairs


def _build_manifest(top: str, skills: list[SkillSrc], version: str,
                    now: _dt.datetime) -> tuple[str, dict[str, str]]:
    """Return (manifest_text, {arcpath: sha256}) for every packaged file."""
    lines = [
        "# polygram dist manifest",
        f"name: {top}",
        f"version: {version}",
        f"minted: {now.isoformat(timespec='seconds')}",
        f"skills: {len(skills)}",
        "",
        "# sha256  origin  path",
    ]
    checks: dict[str, str] = {}
    for skill in skills:
        for abspath, rel in _staged_files(skill):
            arc = f"skills/{skill.name}/{rel}"
            digest = _sha256(abspath)
            checks[arc] = digest
            lines.append(f"{digest}  {skill.origin:<9}  {arc}")
    return "\n".join(lines) + "\n", checks


def mint(dist_dir: Path, skills: list[SkillSrc], *,
         name: str = "polygram-curation", version: str = "0",
         formats: tuple[str, ...] = FORMATS,
         now: _dt.datetime | None = None) -> DistResult:
    """Stage *skills* into a single tree and write the requested archives.

    Archive entries live under ``<name>-<version>/skills/<skill>/...`` with a
    ``<name>-<version>/MANIFEST`` at the top. Returns a :class:`DistResult`.

    ``fmt == "skill"`` bundles are per-skill and self-contained: each one
    carries its own ``.skill-manifest`` (the skill's own gpg-backed one if
    already signed, else one synthesized here) plus the ``check.sh`` +
    ``SAYS-SO`` bundle template when available — see the module docstring.
    """
    if not skills:
        raise ValueError("nothing to mint: no skills collected")
    now = now or _dt.datetime.now()
    dist_dir.mkdir(parents=True, exist_ok=True)
    top = f"{name}-{version}"

    manifest_text, checks = _build_manifest(top, skills, version, now)
    manifest_path = dist_dir / f"{top}.MANIFEST"
    manifest_path.write_text(manifest_text, encoding="utf-8", newline="")

    result = DistResult(name=name, version=version, skills=skills,
                        manifest=manifest_path)

    for fmt in formats:
        if fmt == "plugin":
            raise ValueError(
                "mint() does not build plugins -- a plugin is one tree with "
                "MCP servers in it, not an archive of skills. Use "
                "polygram.plugin.mint_plugin(), or `polygram dist "
                "--format plugin`, which splits it out before calling here.")
        if fmt not in ALL_FORMATS:
            raise ValueError(f"unknown format: {fmt!r} (use {ALL_FORMATS})")
        if fmt == "skill":
            # One installable, folder-rooted <name>.skill per skill.
            for skill in skills:
                bundle = dist_dir / f"{skill.name}.skill"
                staged = _staged_files(skill)
                staged_names = {rel for _, rel in staged}
                with zipfile.ZipFile(bundle, "w", zipfile.ZIP_DEFLATED) as zf:
                    for abspath, rel in staged:
                        zf.write(str(abspath), arcname=f"{skill.name}/{rel}")
                    # Every bundle carries a hash-only manifest. A skill
                    # already signed via skill-sign.sh staged its own
                    # (gpg-backed) .skill-manifest above — never overwrite
                    # that; only synthesize one when it's missing.
                    if _MANIFEST_NAME not in staged_names:
                        zf.writestr(f"{skill.name}/{_MANIFEST_NAME}",
                                    _skill_manifest_text(staged))
                    # Bundle template: check.sh + SAYS-SO ride along so a
                    # stranger with no gpg can still hash-check the bytes.
                    # Skip anything the skill already ships itself.
                    for tf in _BUNDLE_TEMPLATE_FILES:
                        if tf in staged_names:
                            continue
                        tpath = _TEMPLATE_DIR / tf
                        if tpath.is_file():
                            zf.write(str(tpath), arcname=f"{skill.name}/{tf}")
                result.bundles.append(bundle)
                result.checksums[bundle.name] = _sha256(bundle)
            # 2026-09-25: a skill retired from the rack left its old <name>.skill in dist/,
            # installable and looking current. Bundles this mint did not write are moved to
            # dist/.retired-bundles/ (a dot-dir: never staged, never shipped), never deleted.
            minted = {sk.name for sk in skills}
            for old in sorted(dist_dir.glob("*.skill")):
                if old.stem in minted:
                    continue
                aside = dist_dir / ".retired-bundles"
                aside.mkdir(exist_ok=True)
                dest = aside / old.name
                if dest.exists():
                    dest = aside / f"{old.stem}-{now.strftime('%Y%m%d-%H%M%S')}.skill"
                old.replace(dest)
                result.retired.append(dest)
            continue
        archive = dist_dir / f"{top}.{fmt}"
        if fmt == "tar.gz":
            with tarfile.open(archive, "w:gz") as tar:
                tar.add(str(manifest_path), arcname=f"{top}/MANIFEST")
                for skill in skills:
                    for abspath, rel in _staged_files(skill):
                        tar.add(str(abspath),
                                arcname=f"{top}/skills/{skill.name}/{rel}")
        else:  # zip
            with zipfile.ZipFile(archive, "w", zipfile.ZIP_DEFLATED) as zf:
                zf.write(str(manifest_path), arcname=f"{top}/MANIFEST")
                for skill in skills:
                    for abspath, rel in _staged_files(skill):
                        zf.write(str(abspath),
                                 arcname=f"{top}/skills/{skill.name}/{rel}")
        result.artifacts.append(archive)
        result.checksums[archive.name] = _sha256(archive)

    result.checksums.update(checks)
    return result


def record_advice(advice_dir: Path, result: DistResult, *,
                  now: _dt.datetime | None = None) -> Path:
    """Write a dist advice file so every mint stays on the paper trail."""
    advice_dir.mkdir(parents=True, exist_ok=True)
    now = now or _dt.datetime.now()
    stamp = now.strftime("%Y%m%d-%H%M%S")
    path = advice_dir / f"{stamp}-dist-{result.name}.md"

    skill_lines = "\n".join(
        f"- {s.name}  ({s.origin})" for s in result.skills) or "- (none)"
    artifact_lines = "\n".join(
        f"- {a.name}  sha256={result.checksums.get(a.name, '?')[:16]}"
        for a in (result.artifacts + result.bundles)) or "- (none)"
    body = (
        f"---\n"
        f"kind: dist\n"
        f"name: {result.name}\n"
        f"version: {result.version}\n"
        f"skills: {len(result.skills)}\n"
        f"recorded: {now.isoformat(timespec='seconds')}\n"
        f"---\n\n"
        f"# Dist mint: {result.name}-{result.version}\n\n"
        f"## Skills packaged ({len(result.skills)})\n\n"
        f"{skill_lines}\n\n"
        f"## Artifacts\n\n"
        f"{artifact_lines}\n"
    )
    path.write_text(body, encoding="utf-8", newline="")
    result.advice = path
    return path
