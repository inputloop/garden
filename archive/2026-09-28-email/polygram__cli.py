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

"""polygram command-line interface (stdlib argparse).

Subcommands
-----------
  init     create a polygram workspace in the current directory
  scan     parse memory and report skill candidates
  gate     evaluate candidates, write advice files (no synthesis)
  synth    gate + synthesize skills for everything that PASSes
  review   review HOLD candidates; promote / reject / freeze their extern
  extern   manage upstream sources (add/list/sync/freeze/unfreeze)
  list     list synthesized skills and recent advice
  dist     mint distributable skill archives (tar.gz/zip)
  doctor   check the local runtime
"""

from __future__ import annotations

import argparse
import os
import platform
import shutil
import sys
from pathlib import Path

from . import (__version__, config, dist, gate, gatefile, memory, plugin,
               review, synth)
from .externs import Manifest, ManifestError, sync as extern_sync


def _resolve(start: str | None) -> config.Workspace | None:
    return config.load(start)


def _need_ws(args) -> config.Workspace:
    ws = _resolve(args.dir)
    if ws is None:
        print("error: not inside a polygram workspace (run 'polygram init')",
              file=sys.stderr)
        raise SystemExit(2)
    return ws


def _manifest(ws: config.Workspace) -> Manifest:
    try:
        return Manifest.load(ws.externs_manifest)
    except ManifestError as exc:
        print(f"error: {exc}", file=sys.stderr)
        print("       run 'polygram doctor' for details.", file=sys.stderr)
        raise SystemExit(2)


def cmd_init(args) -> int:
    root = Path(args.dir or ".").resolve()
    ws = config.Workspace(root).ensure()
    print(f"polygram workspace ready at {ws.root}")
    print("  skills/  advice/  memory/  externs/  MEMORY.md  .polygram")
    return 0


def cmd_scan(args) -> int:
    ws = _need_ws(args)
    notes = memory.load_notes(ws.memory)
    cands = memory.candidates(notes, threshold=args.threshold)
    print(f"scanned {len(notes)} note(s) in {ws.memory}")
    if not cands:
        print("no skill candidates above threshold")
        return 0
    print(f"\n{len(cands)} candidate(s):")
    for c in cands:
        print(f"  - {c.label:<24} weight={c.weight}  ({c.reason})")
    return 0


def cmd_gate(args) -> int:
    ws = _need_ws(args)
    notes = memory.load_notes(ws.memory)
    cands = memory.candidates(notes, threshold=args.threshold)
    if not cands:
        print("nothing to gate")
        return 0
    verdicts = gate.apply_durable_rejects(
        [gate.evaluate(c) for c in cands], ws.advice)
    for v in verdicts:
        path = gate.record_advice(ws.advice, v)
        print(f"  {v.decision:<6} {v.candidate.label:<24} score={v.score}"
              f"  -> {path.name}")
    return 0


def cmd_synth(args) -> int:
    ws = _need_ws(args)
    notes = memory.load_notes(ws.memory)
    cands = memory.candidates(notes, threshold=args.threshold)
    if not cands:
        print("nothing to synthesize")
        return 0
    passed = held = rejected = 0
    verdicts = gate.apply_durable_rejects(
        [gate.evaluate(c) for c in cands], ws.advice)
    for v in verdicts:
        c = v.candidate
        gate.record_advice(ws.advice, v)
        if v.gated_open:
            s = synth.synthesize(ws.skills, v, overwrite=args.overwrite)
            state = "created" if s.created else "exists"
            print(f"  PASS   {c.label:<24} -> skills/{c.label}/ ({state})")
            passed += 1
        elif v.decision == gate.HOLD:
            print(f"  HOLD   {c.label:<24} score={v.score} (use 'polygram review')")
            held += 1
        else:
            print(f"  REJECT {c.label:<24} score={v.score}")
            rejected += 1
    print(f"\nsynthesized {passed}, held {held}, rejected {rejected}")
    return 0


def cmd_review(args) -> int:
    ws = _need_ws(args)
    manifest = _manifest(ws)
    items = review.build(ws, manifest, threshold=args.threshold)

    if args.freeze_extern:
        manifest.freeze(args.freeze_extern, rev=args.rev)
        manifest.save()
        print(f"froze extern {args.freeze_extern!r}")

    acted = False
    for label in args.promote or []:
        it = review.find(items, label)
        if it is None:
            print(f"  ?      {label:<24} not a current candidate", file=sys.stderr)
            continue
        s = review.promote(ws, it, overwrite=args.overwrite)
        print(f"  PROMOTE {label:<23} -> skills/{label}/ "
              f"({'created' if s.created else 'exists'})")
        acted = True
    for label in args.reject or []:
        it = review.find(items, label)
        if it is None:
            print(f"  ?      {label:<24} not a current candidate", file=sys.stderr)
            continue
        review.reject(ws, it)
        print(f"  REJECT  {label:<23} advice recorded")
        acted = True
    if acted or args.freeze_extern:
        return 0

    holds = review.held(items)
    if not holds:
        print("no candidates on HOLD")
        return 0
    print(f"{len(holds)} candidate(s) on HOLD:\n")
    for it in holds:
        origin = ""
        if it.extern:
            origin = f"  [extern {it.extern.name}"
            origin += " FROZEN]" if it.from_frozen else "]"
        print(f"  HOLD  {it.candidate.label:<22} score={it.verdict.score}{origin}")
        for sig in it.verdict.signals:
            print(f"          - {sig}")
    print("\nactions: --promote LABEL | --reject LABEL | --freeze-extern NAME")
    return 0


_SKILLS_SOURCE_ENV = "POLYGRAM_SKILLS_SOURCE"


def _default_skills_sources() -> list[str]:
    """Skills sources from $POLYGRAM_SKILLS_SOURCE (os.pathsep-separated).

    Lets `polygram dist` pick up the installed-skills cache with no flag once
    the env var is set once (e.g. in a shell profile). Empty if unset.
    """
    raw = os.environ.get(_SKILLS_SOURCE_ENV, "")
    return [p for p in raw.split(os.pathsep) if p]


def cmd_dist(args) -> int:
    ws = _need_ws(args)
    sources = args.skills_source or _default_skills_sources()
    used_env = not args.skills_source and bool(sources)
    installed = [Path(p).expanduser() for p in sources]
    if used_env:
        print(f"using {_SKILLS_SOURCE_ENV}: {os.pathsep.join(sources)}")
    # A named source that is not there drops its skills from the mint; say so,
    # and keep going (audit N10, 2026-09-27: `make dist` with no C4 tree lost
    # the canon skills in silence).
    for src in installed:
        if not src.is_dir():
            print(f"dist: skills-source {src} missing -- canon skills not included",
                  file=sys.stderr)
    if args.sources_only and not installed:
        print("--sources-only needs at least one --skills-source DIR "
              f"(or ${_SKILLS_SOURCE_ENV})", file=sys.stderr)
        return 2
    names = tuple(args.only) if args.only else None
    skills = dist.collect(
        ws.skills, installed_roots=installed,
        family_only=not args.all_installed,
        include_workspace=not args.sources_only,
        names=names,
    )
    if names:
        missing = sorted(set(names) - {s.name for s in skills})
        if missing:
            print("--only named skills not found in any root: "
                  + ", ".join(missing), file=sys.stderr)
            return 1
    if not skills:
        print("nothing to mint: no skills found in skills/ "
              "or the given --skills-source roots", file=sys.stderr)
        return 1

    if args.format == "both":
        formats = dist.FORMATS
    elif args.format == "all":
        formats = dist.CLI_FORMATS
    else:
        formats = (args.format,)

    out_dir = Path(args.out).expanduser() if args.out else ws.dist

    # The plugin is a different shape from an archive -- one tree carrying the
    # MCP servers, not one bundle per skill -- so it is minted separately and
    # mint() never learns about it.
    want_plugin = "plugin" in formats
    formats = tuple(f for f in formats if f != "plugin")

    pres = None
    if want_plugin:
        pres = plugin.mint_plugin(
            out_dir, skills, source_root=ws.root,
            name=args.plugin_name, version=args.dist_version,
            python=args.python,
            self_locating=args.self_locating,
            install_root=args.install_root)
        problems = pres.problems + plugin.validate(pres.root)
        print(f"minted plugin {pres.name}-{pres.version}: "
              f"{len(pres.skills)} skill(s), "
              f"{len(pres.servers)} server(s), {pres.files} file(s)")
        print(f"  tree:     {pres.root}")
        print(f"  install:  {pres.archive}  sha256={pres.sha256[:16]}")
        print(f"  servers:  {', '.join(pres.servers)}")
        if pres.launcher:
            print("  shape:    zero-substitution -- no ${...} in .mcp.json")
            print(f"  launcher: {pres.launcher}")
            print("            that path is BAKED. It must be where this tree "
                  "lives on the")
            print("            machine that runs it; --install-root names it.")
        if problems:
            print("  PROBLEMS (the plugin was still written; fix and re-mint):")
            for pb in problems:
                print(f"    - {pb}")
        else:
            print("  validate: OK "
                  "(manifest, kebab-case name, every skill has a SKILL.md, "
                  "every ${CLAUDE_PLUGIN_ROOT} path resolves)")
        if not formats:
            dist.record_advice(
                ws.advice,
                dist.DistResult(name=pres.name, version=pres.version,
                                skills=pres.skills,
                                bundles=[pres.archive] if pres.archive else [],
                                checksums={pres.archive.name: pres.sha256}
                                if pres.archive else {}))
            return 1 if problems else 0

    result = dist.mint(out_dir, skills, name=args.name,
                       version=args.dist_version, formats=formats)
    advice = dist.record_advice(ws.advice, result)

    print(f"minted {result.name}-{result.version} "
          f"({len(result.skills)} skill(s)):")
    for s in result.skills:
        print(f"  - {s.name:<28} [{s.origin}]")
    if result.artifacts:
        print("archives:")
        for a in result.artifacts:
            print(f"  - {a}  sha256={result.checksums[a.name][:16]}")
    if result.bundles:
        print("installable .skill bundles:")
        for b in result.bundles:
            print(f"  - {b}  sha256={result.checksums[b.name][:16]}")
    if result.retired:
        print("retired bundles (no longer in the rack; moved aside, not deleted):")
        for r in result.retired:
            print(f"  - {r}")
    print(f"manifest: {result.manifest}")
    print(f"advice:   {advice.name}")
    return 0


def cmd_extern(args) -> int:
    ws = _need_ws(args)
    manifest = _manifest(ws)

    if args.action == "add":
        e = manifest.add(args.name, args.url, ref=args.ref)
        e.kind = args.kind
        manifest.save()
        print(f"registered extern {args.name!r} ({args.url} @ {args.ref})")
    elif args.action == "list":
        if not manifest.externs:
            print("no externs registered")
            return 0
        for name, e in sorted(manifest.externs.items()):
            print(f"  {name:<24} {e.status():<22} {e.url}")
    elif args.action == "freeze":
        e = manifest.freeze(args.name, rev=args.rev)
        manifest.save()
        print(f"froze {args.name!r} @ {e.frozen_rev[:8] or '(rev unknown)'}")
    elif args.action == "unfreeze":
        manifest.unfreeze(args.name)
        manifest.save()
        print(f"unfroze {args.name!r}")
    elif args.action == "sync":
        targets = ([manifest.get(args.name)] if args.name
                   else list(manifest.externs.values()))
        if not targets:
            print("nothing to sync")
            return 0
        for e in targets:
            state, detail = extern_sync(e, ws.externs)
            print(f"  {state:<8} {e.name:<24} {detail}")
        manifest.save()
    return 0


def cmd_list(args) -> int:
    ws = _need_ws(args)
    skills = sorted(p.parent.name for p in ws.skills.rglob("SKILL.md")) \
        if ws.skills.is_dir() else []
    advice = sorted(ws.advice.glob("*.md")) if ws.advice.is_dir() else []
    print(f"skills ({len(skills)}):")
    for s in skills:
        print(f"  - {s}")
    print(f"advice files ({len(advice)}):")
    for a in advice[-args.tail:]:
        print(f"  - {a.name}")
    return 0


def cmd_gatefile(args) -> int:
    """Check the .gate sign-post governing a path (no workspace needed)."""
    target = Path(args.path).expanduser()
    try:
        allowed, g = gatefile.check(target, args.op)
    except gatefile.GateError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2
    if g is None:
        print(f"ungated: no {gatefile.GATE_NAME} governs {target}")
        return 0
    verdict = "allowed" if allowed else "DENIED"
    print(f"{verdict}: {args.op} at {target}")
    print(g.describe())
    return 0 if allowed else 1


def cmd_doctor(args) -> int:
    print(f"polygram {__version__}")
    print(f"  python      {platform.python_version()} ({sys.executable})")
    print(f"  platform    {platform.system()} {platform.release()}")
    for tool in ("sh", "git", "find", "grep"):
        loc = shutil.which(tool)
        print(f"  {tool:<11} {loc or 'NOT FOUND'}")
    ws = _resolve(args.dir)
    print(f"  workspace   {ws.root if ws else '(none -- run polygram init)'}")
    if ws is None:
        return 0
    try:
        manifest = Manifest.load(ws.externs_manifest)
    except ManifestError as exc:
        print(f"  externs     CORRUPT -- {exc}")
        return 1
    if not manifest.externs:
        print("  externs     0 registered")
        return 0
    # Registered but never fetched here (a fresh clone: externs/ is not
    # tracked) is a note, not a failure; present-but-broken still fails.
    notes, problems = manifest.triage(ws.externs)
    if problems:
        print(f"  externs     {len(manifest.externs)} registered, "
              f"{len(problems)} issue(s):")
        for p in problems:
            print(f"                - {p}")
    else:
        print(f"  externs     {len(manifest.externs)} registered, OK"
              + (f" ({len(notes)} not fetched here)" if notes else ""))
    for n in notes:
        print(f"                note: {n}")
    return 1 if problems else 0


def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(prog="polygram",
                                description="gated agent-skill synthesis")
    p.add_argument("--version", action="version",
                   version=f"polygram {__version__}")
    p.add_argument("-C", "--dir", help="operate as if started in this directory")
    sub = p.add_subparsers(dest="cmd", required=True)

    sp = sub.add_parser("init", help="create a polygram workspace")
    sp.set_defaults(func=cmd_init)

    for name, func, helptext in (
        ("scan", cmd_scan, "report skill candidates from memory"),
        ("gate", cmd_gate, "evaluate candidates, write advice"),
        ("synth", cmd_synth, "gate + synthesize passing skills"),
    ):
        sp = sub.add_parser(name, help=helptext)
        sp.add_argument("-t", "--threshold", type=int, default=2,
                        help="min tag frequency to surface a candidate")
        if name == "synth":
            sp.add_argument("--overwrite", action="store_true",
                            help="re-synthesize existing skills")
        sp.set_defaults(func=func)

    sp = sub.add_parser("review", help="review HOLD candidates")
    sp.add_argument("-t", "--threshold", type=int, default=2)
    sp.add_argument("--promote", action="append", metavar="LABEL",
                    help="force-synthesize a held candidate (repeatable)")
    sp.add_argument("--reject", action="append", metavar="LABEL",
                    help="record a REJECT for a held candidate (repeatable)")
    sp.add_argument("--freeze-extern", metavar="NAME",
                    help="pin the upstream a held candidate came from")
    sp.add_argument("--rev", help="revision to freeze at (default: current)")
    sp.add_argument("--overwrite", action="store_true")
    sp.set_defaults(func=cmd_review)

    sp = sub.add_parser("extern", help="manage upstream sources")
    esub = sp.add_subparsers(dest="action", required=True)
    a = esub.add_parser("add", help="register an extern")
    a.add_argument("name")
    a.add_argument("url")
    a.add_argument("--ref", default="main")
    a.add_argument("--kind", choices=("git", "local"), default="git",
                   help="git = cloned remote; local = hand-authored snapshot")
    esub.add_parser("list", help="list externs")
    a = esub.add_parser("sync", help="clone/update externs (skips frozen)")
    a.add_argument("name", nargs="?")
    a = esub.add_parser("freeze", help="pin an extern at a revision")
    a.add_argument("name")
    a.add_argument("--rev")
    a = esub.add_parser("unfreeze", help="resume tracking an extern")
    a.add_argument("name")
    sp.set_defaults(func=cmd_extern)

    sp = sub.add_parser("list", help="list skills and advice")
    sp.add_argument("--tail", type=int, default=10, help="advice files to show")
    sp.set_defaults(func=cmd_list)

    sp = sub.add_parser("dist", help="mint distributable skill archives")
    sp.add_argument("--name", default="polygram-curation",
                    help="archive base name")
    sp.add_argument("--dist-version", "--version", dest="dist_version",
                    default=__version__, metavar="VERSION",
                    help="version stamp for the archive (--version also "
                         "works here; bare `polygram --version` still "
                         "prints the tool version)")
    sp.add_argument("--skills-source", action="append", metavar="DIR",
                    help="installed-skills root to include (repeatable); "
                         "defaults to $POLYGRAM_SKILLS_SOURCE when unset")
    sp.add_argument("--all-installed", action="store_true",
                    help="include all installed skills, not just Mentat-family")
    sp.add_argument("--sources-only", action="store_true",
                    help="mint from the --skills-source roots alone; do not "
                         "sweep the workspace skills/ in")
    sp.add_argument("--only", action="append", metavar="NAME",
                    help="mint just this skill dir name (repeatable); any "
                         "name not found in a root is an error")
    sp.add_argument("--format",
                    choices=("tar.gz", "zip", "skill", "plugin", "both", "all"),
                    default="both",
                    help="tar.gz/zip = aggregate; skill = per-skill installable "
                         "bundle; plugin = one Cowork plugin carrying the "
                         "skills AND the three MCP servers; both = tar.gz+zip; "
                         "all = +skill +plugin")
    sp.add_argument("--plugin-name", default="vibrobeast", metavar="NAME",
                    help="plugin name, kebab-case (default: vibrobeast)")
    sp.add_argument("--python", default=plugin.DEFAULT_PYTHON, metavar="EXE",
                    help="interpreter the plugin's .mcp.json launches the "
                         "servers with (default: python3). Pass 'auto' to "
                         "probe python3/python/py on THIS host and bake the "
                         "first that runs. On Windows with msys2 -- or where "
                         "python3 is an App Execution Alias -- this is the "
                         "line most likely to be wrong, and a wrong one shows "
                         "up only as a server that never starts.")
    sp.add_argument("--self-locating", action="store_true",
                    help="mint the zero-substitution shape: .mcp.json carries "
                         "no ${...} anywhere -- no env block at all -- and the "
                         "servers start through servers/launch.py, which puts "
                         "its own directory on sys.path. Opt-in; without it "
                         "the mint is unchanged. The launcher's path is baked "
                         "ABSOLUTE, so on a cross-host mint pass "
                         "--install-root too.")
    sp.add_argument("--install-root", metavar="DIR",
                    help="with --self-locating: where this plugin tree will "
                         "LIVE on the machine that runs it, which is the path "
                         "baked into .mcp.json (default: the minted tree's "
                         "own path, correct only when minting and running are "
                         "the same host)")
    sp.add_argument("--out", metavar="DIR",
                    help="output directory (default: <workspace>/dist)")
    sp.set_defaults(func=cmd_dist)

    sp = sub.add_parser("gatefile",
                        help="check the .gate sign-post governing a path")
    sp.add_argument("path", help="file or directory to check")
    sp.add_argument("op", nargs="?", choices=("read", "write", "publish"),
                    default="read", help="operation to check (default: read)")
    sp.set_defaults(func=cmd_gatefile)

    sp = sub.add_parser("doctor", help="check the local runtime")
    sp.set_defaults(func=cmd_doctor)

    return p


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
