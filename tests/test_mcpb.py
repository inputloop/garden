# polygram -- tests for the Claude Desktop extension mint (polygram/mcpb.py) and the hub.
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.  GPL-3.0-or-later.
"""The extension is minted from the same tree as the plugin; these hold it to that.

Parity is the main claim: the extension's tools are the plugin's tools (plus vibrobeast_status),
checked by running the hub from a real minted copy with nothing from the source tree in scope.
"""

import copy
import hashlib
import json
import os
import subprocess
import sys
import tempfile
import unittest
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from polygram import mcpb  # noqa: E402
from polygram.mcp import rpc  # noqa: E402
from polygram.plugin import _SERVER_FILES  # noqa: E402


def _rpc(proc, mid, method, params=None):
    proc.stdin.write(json.dumps({"jsonrpc": "2.0", "id": mid, "method": method,
                                 "params": params or {}}) + "\n")
    proc.stdin.flush()
    while True:
        line = proc.stdout.readline()
        if not line:
            raise AssertionError(f"hub closed before answering {method}")
        msg = json.loads(line)
        if msg.get("id") == mid:
            return msg


class MintTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.td = tempfile.TemporaryDirectory()
        cls.out = Path(cls.td.name)
        cls.dest, cls.sha = mcpb.mint(cls.out / "a", ROOT)
        cls.x = cls.out / "x"
        with zipfile.ZipFile(cls.dest) as z:
            z.extractall(cls.x)
            cls.names = set(z.namelist())

    @classmethod
    def tearDownClass(cls):
        cls.td.cleanup()

    def test_validates(self):
        self.assertEqual(mcpb.validate_file(self.dest), [])

    def test_deterministic(self):
        _d, sha2 = mcpb.mint(self.out / "b", ROOT)
        self.assertEqual(self.sha, sha2)
        self.assertEqual(self.sha, hashlib.sha256(self.dest.read_bytes()).hexdigest())

    def test_every_server_file_ships(self):
        for rel in _SERVER_FILES:
            self.assertIn("server/" + rel, self.names)
        for rel in ("server/launch.py", "server/launch.cmd", "COPYING", "README.md", "manifest.json"):
            self.assertIn(rel, self.names)

    def test_no_bytecode_ships(self):
        self.assertFalse([n for n in self.names if "__pycache__" in n or n.endswith(".pyc")])

    def _hub(self, env_extra):
        env = {k: v for k, v in os.environ.items() if not k.startswith(("TAVERN_", "C4_", "LLAMABRIDGE_"))}
        env.pop("PYTHONPATH", None)
        env.update(env_extra)
        return subprocess.Popen([sys.executable, "-B", str(self.x / "server" / "launch.py"), "hub"],
                                cwd=str(self.out), env=env, stdin=subprocess.PIPE,
                                stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, encoding="utf-8")

    def test_parity_and_round_trip(self):
        """The hub from the minted copy lists exactly the manifest's tools, and answers calls."""
        p = self._hub({"TAVERN_ON": "${user_config.tavern_on}", "C4_ON": "false"})
        try:
            self.assertIn("result", _rpc(p, 1, "initialize", {"protocolVersion": "2024-11-05"}))
            tools = [t["name"] for t in _rpc(p, 2, "tools/list")["result"]["tools"]]
            m = json.loads((self.x / "manifest.json").read_text(encoding="utf-8"))
            self.assertEqual(sorted(tools), sorted(t["name"] for t in m["tools"]))
            st = _rpc(p, 3, "tools/call", {"name": "vibrobeast_status", "arguments": {}})
            st = json.loads(st["result"]["content"][0]["text"])
            self.assertTrue(all(s["state"] == "running" for s in st["servers"]), st)
            self.assertEqual(st["switches_seen"].get("TAVERN_ON"), "unset (dropped)")
            self.assertEqual(st["clashes"], [])
            r = _rpc(p, 4, "tools/call", {"name": "no_such_tool", "arguments": {}})
            self.assertTrue(r["result"]["isError"])
            self.assertIn("REFUSED", r["result"]["content"][0]["text"])
            r = _rpc(p, 5, "tools/call", {"name": "seat_mode", "arguments": {}})
            self.assertIn("result", r)
        finally:
            p.stdin.close()
            p.wait(timeout=30)

    def test_plugin_tools_equal_extension_tools(self):
        """The plugin's own --list, read from the source tree, against the manifest."""
        out = subprocess.run([sys.executable, "-B", "-m", "polygram.mcp", "--list"], cwd=str(ROOT),
                             capture_output=True, encoding="utf-8", check=True).stdout
        plugin = sorted(l.strip() for l in out.splitlines() if l.startswith("    "))
        m = json.loads((self.x / "manifest.json").read_text(encoding="utf-8"))
        ext = sorted(t["name"] for t in m["tools"] if t["name"] != "vibrobeast_status")
        self.assertEqual(plugin, ext)


class ProblemsGoRed(unittest.TestCase):
    """Each check in mcpb.problems() fires when its fault is planted."""

    def setUp(self):
        self.m = mcpb.manifest()

    def test_clean(self):
        self.assertEqual(mcpb.problems(self.m), [])

    def test_missing_field(self):
        m = copy.deepcopy(self.m)
        del m["user_config"]["tavern_data"]
        self.assertTrue(any("tavern_data" in p and "no settings field" in p for p in mcpb.problems(m)))

    def test_unused_field(self):
        m = copy.deepcopy(self.m)
        m["user_config"]["orphan"] = {"type": "string", "title": "x"}
        self.assertTrue(any("nothing reads it" in p for p in mcpb.problems(m)))

    def test_pythonpath(self):
        m = copy.deepcopy(self.m)
        m["server"]["mcp_config"]["env"]["PYTHONPATH"] = "x"
        self.assertTrue(any("PYTHONPATH" in p for p in mcpb.problems(m)))

    def test_slash_s(self):
        m = copy.deepcopy(self.m)
        m["server"]["mcp_config"]["platform_overrides"]["win32"]["args"].insert(1, "/s")
        self.assertTrue(any("/s" in p for p in mcpb.problems(m)))

    def test_entry_point_absent(self):
        self.assertTrue(any("entry_point" in p for p in mcpb.problems(self.m, names={"manifest.json"})))


class SwitchTests(unittest.TestCase):
    def setUp(self):
        self.saved = os.environ.get("TAVERN_ON")

    def tearDown(self):
        if self.saved is None:
            os.environ.pop("TAVERN_ON", None)
        else:
            os.environ["TAVERN_ON"] = self.saved

    def test_words(self):
        for v, want in (("1", True), ("true", True), ("on", True), ("false", False), ("0", False),
                        ("", None), ("${user_config.tavern_on}", None), ("maybe", None)):
            os.environ["TAVERN_ON"] = v
            self.assertIs(rpc.env_switch("TAVERN_ON"), want, v)

    def test_settings_off_beats_prefs_on(self):
        from polygram.mcp import tavernface
        with tempfile.TemporaryDirectory() as td:
            old = os.environ.get("MENTCACHED_PREFS")
            (Path(td) / "prefs.tsv").write_text("", encoding="utf-8", newline="\n")
            os.environ["MENTCACHED_PREFS"] = str(Path(td) / "prefs.tsv")
            try:
                from polygram.mcp import prefs
                prefs.set_("tavern.on", "on", by="test", why="test")
                os.environ.pop("TAVERN_ON", None)
                self.assertTrue(tavernface.is_on(), "the pref alone should turn it on")
                os.environ["TAVERN_ON"] = "false"
                self.assertFalse(tavernface.is_on(), "the settings page said off")
            finally:
                if old is None:
                    os.environ.pop("MENTCACHED_PREFS", None)
                else:
                    os.environ["MENTCACHED_PREFS"] = old


if __name__ == "__main__":
    unittest.main()
