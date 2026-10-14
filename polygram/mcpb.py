# polygram -- gated agent-skill synthesis.
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.  GPL-3.0-or-later.
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.

"""mcpb -- mint the vibrobeast Claude Desktop extension (one .mcpb file) from this tree.

    python3 -m polygram.mcpb [--out dist]          mint dist/vibrobeast.mcpb; print its sha256
    python3 -m polygram.mcpb --validate FILE       check a minted .mcpb; exit 1 on a problem
    python3 -m polygram.mcpb --manifest            print the manifest that would be minted

Why it exists (2026-10-11).  The plugin carries the six servers for Claude Code and Cowork, and is
switched by asking Claude (pref_set) and restarting.  A desktop extension is the same servers in
the form Claude Desktop installs with a double-click, with a settings page of its own: the doors
(Tavern, Llama Bridge, C4) and their folders become fields, so nobody types a preference or edits
a file to turn one on.  An extension carries one server, so the six run behind the hub
(polygram/mcp/hub.py), which starts each exactly as the plugin does.

An extension carries servers, not skills.  The skills arrive the way the dynaloader already serves
them: mentcached's soft_skills_list and soft_skill_read, live from the SOFT-SKILLS folders.

The zip is deterministic (sorted names, one fixed timestamp), so the same tree mints the same
bytes and the sha256 printed here means something to the person checking a drop.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib
import io
import json
import re
import sys
import zipfile
from pathlib import Path

from . import __version__
from .plugin import _LAUNCH_PY, _SERVER_AUX, _SERVER_FILES, LAUNCH_CMD_SRC

NAME = "vibrobeast"
ZIP_TIME = (2026, 1, 1, 0, 0, 0)

#: Each settings-page field: its env variable, and what the page shows.  Booleans stay off until
#: the person turns them on, as in the plugin.  Paths are optional: empty means "find it yourself".
USER_CONFIG = {
    "tavern_on": ("TAVERN_ON", {
        "type": "boolean", "title": "Tavern: on", "default": False,
        "description": "Let Claude read and post in your Tavern rooms (Bryant's shared room for "
                       "people and agents). What is posted is copied to every member machine's disk."}),
    "tavern_data": ("TAVERN_DATA", {
        "type": "directory", "title": "Tavern: data folder",
        "description": "Only if Tavern lives somewhere unusual; left empty, it is found by itself."}),
    "tavern_as": ("TAVERN_AS", {
        "type": "string", "title": "Tavern: agent name",
        "description": "The name Claude uses in the Tavern. Left empty: the agent already "
                       "registered for this machine, else claude."}),
    "llamabridge_on": ("LLAMABRIDGE_ON", {
        "type": "boolean", "title": "Llama Bridge: on", "default": False,
        "description": "Let Claude hand prompts to a local Ollama server (Bryant's Llama Bridge)."}),
    "ollama_host": ("OLLAMA_HOST", {
        "type": "string", "title": "Llama Bridge: Ollama address",
        "description": "Left empty: http://127.0.0.1:11434, this computer."}),
    "c4_on": ("C4_ON", {
        "type": "boolean", "title": "C4: on", "default": False,
        "description": "Let Claude use your C4 work surface (C4's own server, run with node after "
                       "a check at every start)."}),
    "c4_root": ("C4_ROOT", {
        "type": "directory", "title": "C4: folder",
        "description": "The folder holding mcp/c4-mcp.js; left empty, it is found by itself."}),
    "seat": ("MENTCACHED_SEAT", {
        "type": "directory", "title": "Memory seat folder",
        "description": "Where the memory seat lives; left empty, the usual place is used."}),
}

DESCRIPTION = ("The vibrobeast servers in one Claude Desktop extension: a memory seat, persona "
               "sheets, and doors to Bryant's Tavern, his Llama Bridge and C4. Each door stays "
               "off until you switch it on in this extension's settings.")


def tool_list() -> list[dict]:
    """The tools the six give while every door is off, plus the hub's own: built in-process,
    the same way ``python -m polygram.mcp --list`` builds them."""
    from .mcp import SERVERS
    from .mcp.hub import STATUS_TOOL
    out = [{"name": STATUS_TOOL["name"], "description": STATUS_TOOL["description"]}]
    for name in SERVERS:
        s = importlib.import_module(f".mcp.{name}", __package__).build()
        out += [{"name": t.name, "description": t.description.split(". ")[0][:200]} for t in s.tools]
    return out


def manifest(version: str = __version__) -> dict:
    env = {var: "${user_config.%s}" % key for key, (var, _f) in USER_CONFIG.items()}
    return {
        "manifest_version": "0.3",
        "name": NAME,
        "display_name": "Vibrobeast",
        "version": version,
        "description": DESCRIPTION,
        "author": {"name": "Corwin Brust", "email": "corwin@bru.st"},
        "homepage": "https://vibrobeast.bru.st",
        "license": "GPL-3.0-or-later",
        "keywords": ["memory", "persona", "provenance", "tavern", "free-software"],
        "server": {
            "type": "python",
            "entry_point": "server/launch.py",
            "mcp_config": {
                "command": "python3",
                "args": ["${__dirname}/server/launch.py", "hub"],
                "env": env,
                "platform_overrides": {
                    # The plugin's finder (launch.cmd): no /s, so a quoted folder with a space
                    # survives; /d skips AutoRun, which could print onto the JSON-RPC channel.
                    "win32": {"command": "cmd",
                              "args": ["/d", "/c", "${__dirname}\\server\\launch.cmd", "hub"]},
                },
            },
        },
        "tools": tool_list(),
        "tools_generated": True,
        "user_config": {k: f for k, (_v, f) in USER_CONFIG.items()},
        "compatibility": {"platforms": ["win32", "darwin"],
                          "runtimes": {"python": ">=3.10"}},
    }


README = """# Vibrobeast, the Claude Desktop extension

Install: double-click vibrobeast.mcpb, or drag it onto Claude Desktop's Settings > Extensions.
Then open the extension's settings to switch on the doors you want (Tavern, Llama Bridge, C4).

It needs Python 3.10 or newer on this computer. On Windows the extension finds it by itself
(the Python launcher, PATH, MSYS2, python.org installs); set VIBROBEAST_PYTHON to choose one.

The same servers ship as the vibrobeast plugin for Claude Code and Cowork; this is that plugin's
servers, run behind one door. Ask Claude for vibrobeast_status to see which ones started.

GPL-3.0-or-later; see COPYING. https://vibrobeast.bru.st
"""


def files(source_root: Path, version: str = __version__) -> dict[str, bytes]:
    root = Path(source_root)
    out: dict[str, bytes] = {}
    missing = []
    for rel in _SERVER_FILES:
        p = root / rel
        if p.is_file():
            out["server/" + rel] = p.read_bytes()
        else:
            missing.append(rel)
    for rel in _SERVER_AUX:
        p = root / rel
        if p.is_file():
            out["server/" + rel] = p.read_bytes()
    out["server/launch.py"] = _LAUNCH_PY.encode("utf-8")
    lc = root / LAUNCH_CMD_SRC
    if lc.is_file():
        out["server/launch.cmd"] = lc.read_bytes()
    else:
        missing.append(LAUNCH_CMD_SRC)
    if (root / "COPYING").is_file():
        out["COPYING"] = (root / "COPYING").read_bytes()
    else:
        missing.append("COPYING")
    if missing:
        raise SystemExit("mcpb: not found under %s: %s" % (root, ", ".join(missing)))
    out["README.md"] = README.encode("utf-8")
    out["manifest.json"] = (json.dumps(manifest(version), indent=2) + "\n").encode("utf-8")
    return out


def pack(entries: dict[str, bytes]) -> bytes:
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w", zipfile.ZIP_DEFLATED) as z:
        for name in sorted(entries):
            info = zipfile.ZipInfo(name, ZIP_TIME)
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = (0o755 if name.endswith((".py", ".sh", ".cmd")) else 0o644) << 16
            z.writestr(info, entries[name])
    return buf.getvalue()


_SUBST = re.compile(r"\$\{user_config\.([A-Za-z0-9_]+)\}")
_SEMVER = re.compile(r"\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?")


def problems(m: dict, names: set[str] | None = None) -> list[str]:
    """What is wrong with a manifest (and, given the zip's names, with what it points at)."""
    p: list[str] = []
    for k in ("manifest_version", "name", "version", "description", "author", "server"):
        if k not in m:
            p.append(f"no {k}")
    if p:
        return p
    if not _SEMVER.fullmatch(str(m["version"])):
        p.append(f"version {m['version']!r} is not x.y.z")
    if not (m.get("author") or {}).get("name"):
        p.append("author has no name")
    srv = m["server"]
    mc = srv.get("mcp_config") or {}
    if srv.get("type") not in ("python", "node", "binary", "uv"):
        p.append(f"server.type {srv.get('type')!r} is not python, node, binary or uv")
    if names is not None:
        if srv.get("entry_point") not in names:
            p.append(f"entry_point {srv.get('entry_point')!r} is not in the archive")
        for a in [*mc.get("args", []), *[x for o in (mc.get("platform_overrides") or {}).values()
                                         for x in o.get("args", [])]]:
            if a.startswith("${__dirname}"):
                rel = a[len("${__dirname}") + 1:].replace("\\", "/")
                if rel not in names:
                    p.append(f"{a} names a file that is not in the archive")
    declared = set(m.get("user_config") or {})
    used = set(_SUBST.findall(json.dumps(mc)))
    for k in sorted(used - declared):
        p.append(f"${{user_config.{k}}} is used but no settings field {k!r} is declared")
    for k in sorted(declared - used):
        p.append(f"settings field {k!r} is declared but nothing reads it: a switch that does nothing")
    if "PYTHONPATH" in (mc.get("env") or {}):
        p.append("env names PYTHONPATH, which Claude Desktop refuses (the plugin's 2026-09-23 lesson)")
    win = (mc.get("platform_overrides") or {}).get("win32") or {}
    if win.get("command", "").lower() in ("cmd", "cmd.exe"):
        wa = [a.lower() for a in win.get("args", [])]
        if "/s" in wa:
            p.append("win32 starts cmd with /s, which cuts a quoted folder at its first space")
        if "/c" not in wa:
            p.append("win32 starts cmd without /c")
    tn = [t.get("name") for t in m.get("tools") or []]
    for n in sorted({n for n in tn if tn.count(n) > 1}):
        p.append(f"tool {n!r} is listed twice")
    for k, f in (m.get("user_config") or {}).items():
        if f.get("type") not in ("string", "number", "boolean", "directory", "file"):
            p.append(f"settings field {k!r} has type {f.get('type')!r}")
        if not f.get("title"):
            p.append(f"settings field {k!r} has no title")
    return p


def validate_file(path: Path) -> list[str]:
    with zipfile.ZipFile(path) as z:
        names = set(z.namelist())
        if "manifest.json" not in names:
            return ["no manifest.json at the top of the archive"]
        m = json.loads(z.read("manifest.json").decode("utf-8"))
    return problems(m, names)


def mint(out_dir: Path, source_root: Path) -> tuple[Path, str]:
    data = pack(files(source_root))
    out_dir.mkdir(parents=True, exist_ok=True)
    dest = out_dir / f"{NAME}.mcpb"
    dest.write_bytes(data)
    return dest, hashlib.sha256(data).hexdigest()


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(prog="python3 -m polygram.mcpb")
    ap.add_argument("--out", default="dist")
    ap.add_argument("--root", default=str(Path(__file__).resolve().parents[1]))
    ap.add_argument("--validate", metavar="FILE")
    ap.add_argument("--manifest", action="store_true")
    a = ap.parse_args(argv)
    if a.manifest:
        sys.stdout.write(json.dumps(manifest(), indent=2) + "\n")
        return 0
    if a.validate:
        p = validate_file(Path(a.validate))
        for x in p:
            print(f"  PROBLEM  {x}")
        print(f"mcpb: {a.validate}: " + ("OK" if not p else f"{len(p)} problem(s)"))
        return 1 if p else 0
    dest, sha = mint(Path(a.out), Path(a.root))
    p = validate_file(dest)
    for x in p:
        print(f"  PROBLEM  {x}")
    print(f"mcpb: minted {dest} ({dest.stat().st_size} bytes)")
    print(f"sha256 {sha}")
    return 1 if p else 0


if __name__ == "__main__":
    raise SystemExit(main())
