# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
# tier: smoke
"""Every module the MCP servers can import must ship in the plugin.

Written 2026-09-22 after a real miss: polygram/mcp/metrics.py was added, mentcached imported
it, and the plugin mint's hand-kept file list did not carry it -- so the minted mentcached
would have died on import on the keeper's desktop. Two checks, two angles: the list covers
the directory, and every server really imports from a real mint.
GPL-3.0-or-later. Authored by Mentat (for Corwin)."""
import os, subprocess, sys, tempfile, unittest, zipfile
from pathlib import Path

from polygram import dist, plugin

ROOT = Path(__file__).resolve().parents[1]


class PluginShipsWhatServersImport(unittest.TestCase):
    def test_every_mcp_module_is_listed(self):
        have = {p.relative_to(ROOT).as_posix() for p in (ROOT / "polygram" / "mcp").glob("*.py")}
        missing = sorted(have - set(plugin._SERVER_FILES))
        self.assertEqual(missing, [], "add these to plugin._SERVER_FILES")

    def test_each_server_imports_from_a_real_mint(self):
        with tempfile.TemporaryDirectory() as td:
            out = Path(td) / "dist"; out.mkdir()
            skills = dist.collect(ROOT / "skills", include_workspace=True)
            res = plugin.mint_plugin(out, skills, source_root=ROOT)
            inst = Path(td) / "installed"
            with zipfile.ZipFile(res.archive) as zf:
                zf.extractall(inst)
            # Started the way the app starts them: through servers/launch.py, with no
            # PYTHONPATH (2026-09-23 -- the desktop refuses that env name outright).
            env = dict(os.environ); env.pop("PYTHONPATH", None)
            for srv in plugin.SERVERS if hasattr(plugin, "SERVERS") else ("mentcached", "persona", "skillx"):
                p = subprocess.run([sys.executable, str(inst / "servers" / "launch.py"), "--list"],
                                   env=env, cwd=td, capture_output=True, text=True, encoding="utf-8")
                self.assertEqual(p.returncode, 0, f"{srv}: {p.stderr[-400:]}")
                self.assertIn(srv, p.stdout, f"{srv} not listed by the launcher")
            self.assertTrue((inst / "skills" / "skill-metrics" / "scripts" / "sk2mt").is_file())
            # 2026-10-08: Bryant's Tavern ships whole and pinned, and the minted switch starts OFF
            # from a clean home (one tool, tavern_status).  Spec: tests/tavernface-SPEC.txt.
            import hashlib, json
            up = inst / "servers" / "polygram" / "mcp" / "tavern_upstream.py"
            self.assertEqual(hashlib.sha256(up.read_bytes()).hexdigest(),
                             "6ffaa56681406aa55073cb9c5ae296edd6659730ff8d73793c5655a77483e78c")
            self.assertTrue((inst / "servers" / "polygram" / "mcp" / "NOTICE-tavern").is_file())
            home = Path(td) / "home"; home.mkdir()
            env2 = dict(env, HOME=str(home), USERPROFILE=str(home))
            for k in ("TAVERN_ON", "TAVERN_DATA", "TAVERN_AS", "MENTCACHED_PREFS"):
                env2.pop(k, None)
            msgs = [{"jsonrpc": "2.0", "id": 1, "method": "initialize", "params": {}},
                    {"jsonrpc": "2.0", "id": 2, "method": "tools/list"}]
            p = subprocess.run([sys.executable, str(inst / "servers" / "launch.py"), "tavernface"],
                               input="\n".join(json.dumps(m) for m in msgs) + "\n", env=env2, cwd=td,
                               capture_output=True, text=True, encoding="utf-8", timeout=60)
            got = [json.loads(l) for l in p.stdout.splitlines() if l.startswith("{")]
            self.assertEqual([t["name"] for t in got[-1]["result"]["tools"]], ["tavern_status"], p.stderr[-400:])
            # 2026-10-08: c4face from a clean home with no C4 tree answers one tool, c4_status.
            # Spec: tests/c4face-SPEC.txt (C1).
            for k in ("C4_ROOT", "MENTCACHED_SEAT", "POLYGRAM_DIST", "VIBROBEAST_NODE"):
                env2.pop(k, None)
            env2["C4FACE_GUESS"] = "0"     # skip the author's-layout guesses (F:/claude/c4 is real on avalon)
            p = subprocess.run([sys.executable, str(inst / "servers" / "launch.py"), "c4face"],
                               input="\n".join(json.dumps(m) for m in msgs) + "\n", env=env2, cwd=td,
                               capture_output=True, text=True, encoding="utf-8", timeout=60)
            got = [json.loads(l) for l in p.stdout.splitlines() if l.startswith("{")]
            self.assertEqual([t["name"] for t in got[-1]["result"]["tools"]], ["c4_status"], p.stderr[-400:])
            self.assertTrue((inst / "servers" / "launch.cmd").is_file())


if __name__ == "__main__":
    unittest.main()
