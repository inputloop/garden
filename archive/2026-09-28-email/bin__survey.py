#!/usr/bin/env python3
# surgery-survey -- build a navigable map of a system, and say what you could
# not see.  Part of RECIPE-2026-09-15-software-surgery.
# Copyright (C) 2026 Corwin <mplscorwin@gmail.com>.  GPLv3+.
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
"""Survey a tree into a map whose every surface says how it was drawn.

THE ONE RULE THIS TOOL EXISTS TO ENFORCE:

    Authored geometry is hard surface.  Derived geometry is fog.
    They are never unified, and there is no flag to unify them.

In a first-person view, PROXIMITY READS AS MEANING -- that is the one thing the
medium does better than a list.  So a layout algorithm's accidental adjacency
is a lie delivered through the strongest channel available.  If no human
decided two things belong near each other, this map may draw a cloud, and may
not draw a wall.

WHY THAT IS NOT PRECIOUSNESS.  Building this, a first pass extracted the import
graph with a regular expression and reported two modules as UNREACHABLE from
any entry point -- a sealed chamber, exactly the finding such a tool exists to
surface.  It was false: a parenthesised multi-line import.  A phantom dead end
is indistinguishable from a real finding from the inside, and is worse than a
crash, because a crash does not leave you with a confident, memorable, wrong
belief about an architecture.  Hence: ast, never regex, and every surface
carries its extractor.

MAP EDGES.  Where the survey stopped is a first-class feature of the map, not
an omission from it.  Dynamic imports, subprocess calls, plugin loaders and
anything this tool cannot follow are recorded as FRONTIER: the boundary between
surveyed and unsurveyed.  Rendering ignorance as solid rock is the most
damaging thing a map like this can do.
"""
import ast
import json
import sys
from pathlib import Path

AUTHORED, DERIVED, FRONTIER = "authored", "derived", "frontier"

# Directories that are OUTPUT, not design. Surveying them produces findings
# about the build system wearing the clothes of findings about the
# architecture -- the first run of this tool reported the bundled copy of the
# package inside dist/ as "TWO PROGRAMS, no door between them", which is true
# of the bytes and meaningless about the design. The exclusion is listed here
# rather than buried, and the map records that it was applied, because a survey
# that quietly skips things is a survey that renders ignorance as rock.
NOT_DESIGN = {"dist", "build", ".git", "__pycache__", "node_modules",
              ".venv", "venv", ".tox", ".mypy_cache", ".pytest_cache",
              "site-packages", ".eggs"}


def _module_name(p: Path, root: Path) -> str:
    rel = p.relative_to(root).with_suffix("")
    parts = [x for x in rel.parts if x != "__init__"]
    return ".".join(parts)


def survey(root: Path) -> dict:
    root = root.resolve()
    mods, edges, frontier = {}, [], []

    skipped = sorted({part for p in root.rglob("*.py")
                      for part in p.relative_to(root).parts
                      if part in NOT_DESIGN})
    py = sorted(p for p in root.rglob("*.py")
                if not (NOT_DESIGN & set(p.relative_to(root).parts)))
    for p in py:
        name = _module_name(p, root)
        mods[name] = {
            "module": name,
            "path": str(p.relative_to(root)),
            # AUTHORED: a human put this file in this directory. The directory
            # tree is a design decision, not an inference.
            "surface": AUTHORED,
            "drawn_by": "the directory tree, as committed",
            "lines": len(p.read_text(encoding="utf-8", errors="replace").splitlines()),
        }

    for p in py:
        src = p.read_text(encoding="utf-8", errors="replace")
        name = _module_name(p, root)
        try:
            tree = ast.parse(src, filename=str(p))
        except SyntaxError as exc:
            frontier.append({"at": name, "kind": "unparseable",
                             "why": f"{type(exc).__name__}: {exc}",
                             "surface": FRONTIER})
            continue
        pkg = name.rsplit(".", 1)[0] if "." in name else ""
        for node in ast.walk(tree):
            if isinstance(node, ast.ImportFrom):
                base = pkg if node.level else ""
                target = ((base + "." + node.module) if (node.level and node.module)
                          else (base if node.level else (node.module or "")))
                if target in mods:
                    edges.append({"from": name, "to": target,
                                  # DERIVED: the edge's EXISTENCE is a fact in
                                  # the bytes; its POSITION in any layout is a
                                  # guess. A tunnel is a crisp line through fog.
                                  "surface": DERIVED,
                                  "drawn_by": "ast.ImportFrom"})
            elif isinstance(node, ast.Import):
                for a in node.names:
                    if a.name in mods:
                        edges.append({"from": name, "to": a.name,
                                      "surface": DERIVED, "drawn_by": "ast.Import"})
            elif isinstance(node, ast.Call):
                f = node.func
                dotted = ""
                if isinstance(f, ast.Attribute):
                    dotted = f.attr
                elif isinstance(f, ast.Name):
                    dotted = f.id
                if dotted in ("run", "Popen", "system", "check_output",
                              "import_module", "__import__", "exec", "eval"):
                    frontier.append({
                        "at": name, "line": node.lineno, "kind": dotted,
                        "surface": FRONTIER,
                        "why": ("control leaves the tree here and static reading "
                                "cannot follow it. This is a MAP EDGE: the "
                                "survey stopped, it did not find nothing."),
                    })

    # Reachability, per entry point. Entry points are AUTHORED: __main__ and
    # console scripts are declared, not guessed.
    entries = sorted(m for m in mods if m.endswith("__main__") or m == "cli"
                     or m.endswith(".cli"))
    adj = {}
    for e in edges:
        adj.setdefault(e["from"], set()).add(e["to"])
    reach = {}
    for e in entries:
        seen, stack = set(), [e]
        while stack:
            cur = stack.pop()
            if cur in seen:
                continue
            seen.add(cur)
            stack.extend(adj.get(cur, ()))
        reach[e] = sorted(seen)

    return {
        "root": str(root),
        "legend": {
            AUTHORED: "a human decided this. Hard surface; you may trust a wall.",
            DERIVED: "a machine inferred this. Its existence is a fact; its "
                     "position is a guess. Drawn as fog.",
            FRONTIER: "the survey stopped here. NOT emptiness -- a map edge.",
        },
        "modules": [mods[k] for k in sorted(mods)],
        "edges": edges,
        "frontier": frontier,
        "entries": entries,
        "reach": reach,
        "excluded": skipped,
        "counts": {"modules": len(mods), "edges": len(edges),
                   "frontier": len(frontier), "entries": len(entries)},
    }


def guidance(m: dict) -> str:
    """The guidance-system display: what a pilot needs before moving."""
    out = []
    c = m["counts"]
    out.append(f"SURVEY  {m['root']}")
    out.append(f"  {c['modules']} rooms (authored)   {c['edges']} tunnels (derived)"
               f"   {c['frontier']} map edges")
    if m.get("excluded"):
        out.append(f"  not surveyed (output, not design): {', '.join(m['excluded'])}")
    out.append("")
    if not m["entries"]:
        out.append("  NO ENTRY POINT FOUND. There is nothing to fly into.")
        out.append("  That is a finding about this tree, not a failure of the survey.")
    for e, seen in sorted(m["reach"].items()):
        out.append(f"  entry {e}: reaches {len(seen)} room(s)")
    names = sorted(m["reach"])
    for i in range(len(names)):
        for j in range(i + 1, len(names)):
            a, b = set(m["reach"][names[i]]), set(m["reach"][names[j]])
            shared = a & b
            out.append("")
            out.append(f"  {names[i]} ({len(a)}) and {names[j]} ({len(b)}) "
                       f"share {len(shared)} room(s)")
            if not shared:
                out.append("  ^ TWO PROGRAMS. One directory, one version string,")
                out.append("    no door between them. One screen: two rooms, one")
                out.append("    wall. This is the kind of thing the tool is for.")
    if m["frontier"]:
        out.append("")
        out.append("  MAP EDGES -- where the survey stopped:")
        for f in m["frontier"][:12]:
            where = f"{f['at']}:{f.get('line', '?')}"
            out.append(f"    {where:<34} {f['kind']}")
        out.append("    Beyond these, the map says nothing. It does not say"
                   " 'nothing is there'.")
    return "\n".join(out)


def main(argv):
    if len(argv) < 2 or argv[1] in ("-h", "--help"):
        print(__doc__)
        print("usage: survey.py TREE [--json]")
        return 0
    if argv[1] == "--prove-red":
        # A survey that cannot report ignorance is a survey that lies.
        import tempfile
        d = Path(tempfile.mkdtemp())
        (d / "a.py").write_text("import subprocess\nsubprocess.run(['x'])\n",
                                encoding="utf-8", newline="")
        (d / "b.py").write_text("def f(:\n", encoding="utf-8", newline="")
        m = survey(d)
        kinds = {f["kind"] for f in m["frontier"]}
        if "run" not in kinds:
            print("prove-red FAIL: a subprocess call did not register as a map "
                  "edge, so this survey renders ignorance as rock", file=sys.stderr)
            return 1
        if "unparseable" not in kinds:
            print("prove-red FAIL: a file it could not parse was silently "
                  "dropped rather than reported", file=sys.stderr)
            return 1
        if any(e["surface"] == AUTHORED for e in m["edges"]):
            print("prove-red FAIL: an inferred edge claimed to be authored",
                  file=sys.stderr)
            return 1
        print("prove-red PASS: the survey reports what it could not see")
        return 0
    m = survey(Path(argv[1]))
    if "--json" in argv:
        print(json.dumps(m, indent=2))
    else:
        print(guidance(m))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
