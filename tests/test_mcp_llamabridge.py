"""llamabridge: Bryant's Llama Bridge, served off until the person turns it on.

Off: one tool, which says so; nothing else answers.  On: Llama Bridge's own MCP server, with its
log under ~/.mentcached and Ollama where OLLAMA_HOST says (a closed port here: it must say Ollama
is not reachable, not crash).  The vendored file is byte for byte what NOTICE-llama_bridge records.
Prove-red: a switch that ignores the preference is caught by the off test.
Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; GPL-3.0-or-later.
"""
import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
INIT = {"jsonrpc": "2.0", "id": 1, "method": "initialize",
        "params": {"protocolVersion": "2024-11-05", "capabilities": {}, "clientInfo": {"name": "t", "version": "0"}}}
LIST = {"jsonrpc": "2.0", "id": 2, "method": "tools/list"}


def rpc(msgs, env_extra, root=ROOT):
    home = tempfile.mkdtemp()
    env = dict(os.environ, HOME=home, PYTHONPATH=str(root), **env_extra)
    env.pop("LLAMABRIDGE_ON", None) if "LLAMABRIDGE_ON" not in env_extra else None
    env.pop("MENTCACHED_PREFS", None)
    p = subprocess.run([sys.executable, "-m", "polygram.mcp", "llamabridge"], input="\n".join(json.dumps(m) for m in msgs) + "\n",
                       capture_output=True, text=True, encoding="utf-8", env=env, cwd=str(root), timeout=60)
    out = [json.loads(l) for l in p.stdout.splitlines() if l.strip().startswith("{")]
    return out, home


def tools(out):
    for o in out:
        if o.get("id") == 2:
            return [t["name"] for t in o["result"]["tools"]]
    return []


class LlamaBridge(unittest.TestCase):
    def test_off_by_default(self):
        out, home = rpc([INIT, LIST, {"jsonrpc": "2.0", "id": 3, "method": "tools/call",
                                      "params": {"name": "llamabridge_status", "arguments": {}}}], {})
        self.assertEqual(tools(out), ["llamabridge_status"])
        self.assertIn('OFF', out[-1]["result"]["content"][0]["text"])
        self.assertFalse((Path(home) / ".mentcached" / "llama-bridge.db").exists(), "an off bridge wrote its log")

    def test_on_by_preference(self):
        home = tempfile.mkdtemp()
        (Path(home) / ".mentcached").mkdir()
        (Path(home) / ".mentcached" / "prefs.tsv").write_text("ts\tkey\tvalue\tby\twhy\n2026-10-04T00:00Z\tllamabridge.on\ton\ttest\tturned on\n", encoding="utf-8", newline="\n")
        env = dict(os.environ, HOME=home, PYTHONPATH=str(ROOT), OLLAMA_HOST="http://127.0.0.1:9")
        env.pop("LLAMABRIDGE_ON", None); env.pop("MENTCACHED_PREFS", None)
        msgs = [INIT, LIST, {"jsonrpc": "2.0", "id": 3, "method": "tools/call", "params": {"name": "ollama_status", "arguments": {}}}]
        p = subprocess.run([sys.executable, "-m", "polygram.mcp", "llamabridge"], input="\n".join(json.dumps(m) for m in msgs) + "\n",
                           capture_output=True, text=True, encoding="utf-8", env=env, cwd=str(ROOT), timeout=60)
        out = [json.loads(l) for l in p.stdout.splitlines() if l.strip().startswith("{")]
        self.assertEqual(out[0]["result"]["serverInfo"]["name"], "llama-bridge")
        self.assertIn("delegate_async", tools(out))
        self.assertIn("NOT reachable", json.dumps(out[-1]))
        self.assertTrue((Path(home) / ".mentcached" / "llama-bridge.db").exists(), "the log is not under ~/.mentcached")

    def test_vendored_bytes(self):
        # 2026-10-05: the bridge is 1.4.0-vb.1.  NOTICE records upstream's hash (as received)
        # and ours; the file must be ours, and must not claim to be upstream.
        notice = (ROOT / "polygram" / "mcp" / "NOTICE-llama_bridge").read_text(encoding="utf-8")
        rows = [l.split() for l in notice.splitlines() if l.strip().startswith("sha256 ")]
        self.assertEqual(len(rows), 2, "NOTICE must record upstream's hash and ours")
        self.assertIn("upstream", " ".join(rows[0]))
        got = hashlib.sha256((ROOT / "polygram" / "mcp" / "llama_bridge.py").read_bytes()).hexdigest()
        self.assertEqual(got, rows[1][1], "llama_bridge.py is not the bytes NOTICE-llama_bridge records")
        self.assertNotEqual(got, rows[0][1], "the vb.1 file is upstream's bytes; NOTICE is wrong")

    def test_prove_red_switch(self):
        t = Path(tempfile.mkdtemp())
        shutil.copytree(ROOT / "polygram", t / "polygram", ignore=shutil.ignore_patterns("__pycache__"))
        f = t / "polygram" / "mcp" / "llamabridge.py"
        f.write_text(f.read_text(encoding="utf-8").replace("    if not is_on():\n", "    if False:\n"), encoding="utf-8", newline="\n")
        out, _ = rpc([INIT, LIST], {"OLLAMA_HOST": "http://127.0.0.1:9"}, root=t)
        self.assertNotEqual(tools(out), ["llamabridge_status"], "a switch that ignores the preference was not caught")


if __name__ == "__main__":
    unittest.main()
