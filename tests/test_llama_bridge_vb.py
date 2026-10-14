"""llama_bridge 1.4.0-vb.1: think, options, the window sized to the prompt, one at a time.

Spec, written fresh for these tests (not copied from the code): a caller may say whether a model
thinks; the bridge passes that on only to a model that can think, and says afterwards whether it
thought and how much.  A caller may pass Ollama options; they arrive unchanged, over the keeper's
defaults.  A model whose own context window is huge gets a window just big enough for the prompt
and an answer, in a few fixed sizes, so it stays in GPU memory; a model with a modest window, or
one whose Modelfile sets its own, is left alone.  Background jobs wait their turn in the bridge,
not in Ollama, so a job's time limit starts when it runs.  The cache never serves a thought-through
answer to a caller who asked for none.  warm_model loads the window the next call will use.

Every request the bridge makes is recorded by the shipped stand-in (scripts/fake_ollama.py in the
llama-bridge skill) and read back here; prove-red plants
each fault in a copy of the module and wants this suite to fail.
Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; GPL-3.0-or-later.
"""
import importlib.util
import json
import os
import subprocess
import sys
import tempfile
import threading
import time
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
SRC = Path(os.environ.get("LB_SRC") or (HERE.parent / "polygram" / "mcp" / "llama_bridge.py"))

sys.path.insert(0, str(Path(os.environ.get("LB_FAKE_DIR") or
                          (HERE.parent / "skills" / "llama-bridge" / "scripts"))))
import fake_ollama  # noqa: E402  (the shipped stand-in; the tests use the tool people get)

Fake = fake_ollama.FakeOllama
MODELS = {  # invented for these tests, in fake_ollama's shape
    "big:12b": {"size": 1000, "family": "gemma4", "param": "12B",
                "capabilities": ["completion", "thinking"], "context_length": 262144,
                "parameters": ""},
    "big:12b-8k": {"size": 800, "family": "gemma4", "param": "12B",
                   "capabilities": ["completion", "thinking"], "context_length": 262144,
                   "parameters": "num_ctx                        8192"},
    "plain:3b": {"size": 300, "family": "llama", "param": "3B",
                 "capabilities": ["completion"], "context_length": 131072, "parameters": ""},
    "small:7b": {"size": 500, "family": "qwen2", "param": "7B",
                 "capabilities": ["completion", "thinking"], "context_length": 32768,
                 "parameters": ""},
}


def load(src=SRC):
    spec = importlib.util.spec_from_file_location("lbvb_%d" % id(src), str(src))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


class VB(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.srv, cls.host = fake_ollama.start(models=MODELS, spill={"big:12b": 62})

    @classmethod
    def tearDownClass(cls):
        cls.srv.shutdown()

    def setUp(self):
        self.lb = load()
        self.lb.CFG["db"] = os.path.join(tempfile.mkdtemp(), "lb.db")
        self.lb.CFG["ollama"] = self.host
        self.lb.init_db()
        Fake.log.clear()
        Fake.peak = 0
        Fake.delay = 0.0
        Fake.loaded.clear()

    def call(self, name, args):
        content, err = self.lb.mcp_call_tool(name, args)
        return content[0]["text"], err

    # think
    def test_think_false_reaches_a_thinking_model(self):
        self.call("delegate_task", {"model": "big:12b", "prompt": "p1", "think": "false", "no_cache": True})
        self.assertIs(Fake.log[-1].get("think"), False)

    def test_think_level_passes_through(self):
        self.call("delegate_task", {"model": "big:12b", "prompt": "p2", "think": "high", "no_cache": True})
        self.assertEqual(Fake.log[-1].get("think"), "high")

    def test_think_never_sent_to_a_model_that_cannot_think(self):
        self.call("delegate_task", {"model": "plain:3b", "prompt": "p3", "think": "true", "no_cache": True})
        self.assertNotIn("think", Fake.log[-1])

    def test_unsaid_think_is_reported_when_the_model_thought(self):
        text, _ = self.call("delegate_task", {"model": "big:12b", "prompt": "p4", "no_cache": True})
        self.assertNotIn("think", Fake.log[-1])
        self.assertIn("think=false skips that", text)

    def test_bad_think_is_refused(self):
        text, err = self.call("delegate_task", {"model": "big:12b", "prompt": "p5", "think": "maybe"})
        self.assertTrue(err)
        self.assertEqual(Fake.log, [])

    def test_think_default_from_config(self):
        self.lb.cfg_set("think_default", "false")
        self.call("delegate_task", {"model": "big:12b", "prompt": "p6", "no_cache": True})
        self.assertIs(Fake.log[-1].get("think"), False)

    # options and the window
    def test_options_pass_through_over_config(self):
        self.lb.cfg_set("options", json.dumps({"temperature": 0.9, "top_k": 20}))
        self.call("delegate_task", {"model": "plain:3b", "prompt": "p7", "no_cache": True,
                                    "options": {"temperature": 0.2, "num_predict": 64}})
        o = Fake.log[-1]["options"]
        self.assertEqual((o["temperature"], o["top_k"], o["num_predict"]), (0.2, 20, 64))

    def test_huge_window_gets_the_floor_for_a_short_prompt(self):
        self.call("delegate_task", {"model": "big:12b", "prompt": "short", "no_cache": True})
        self.assertEqual(Fake.log[-1]["options"]["num_ctx"], 8192)

    def test_long_prompt_gets_a_bigger_bucket_not_a_clipped_one(self):
        prompt = "word " * 30000
        self.call("delegate_task", {"model": "big:12b", "prompt": prompt, "no_cache": True})
        n = Fake.log[-1]["options"]["num_ctx"]
        self.assertIn(n, (32768, 65536))
        self.assertGreater(n, self.lb.est_claude_tokens(prompt))

    def test_caller_num_ctx_wins(self):
        self.call("delegate_task", {"model": "big:12b", "prompt": "x", "no_cache": True,
                                    "options": {"num_ctx": 4096}})
        self.assertEqual(Fake.log[-1]["options"]["num_ctx"], 4096)

    def test_modest_or_modelfile_windows_are_left_alone(self):
        for m in ("small:7b", "big:12b-8k"):
            self.call("delegate_task", {"model": m, "prompt": "x " + m, "no_cache": True})
            self.assertNotIn("num_ctx", Fake.log[-1].get("options", {}), m)

    def test_auto_off_sends_nothing(self):
        self.lb.cfg_set("num_ctx_auto", "0")
        self.call("delegate_task", {"model": "big:12b", "prompt": "x", "no_cache": True})
        self.assertNotIn("options", Fake.log[-1])

    def test_warm_loads_the_window_the_next_call_uses(self):
        self.call("warm_model", {"model": "big:12b"})
        warm = Fake.log[-1]
        self.call("delegate_task", {"model": "big:12b", "prompt": "a short prompt", "no_cache": True})
        self.assertEqual(warm["options"]["num_ctx"], Fake.log[-1]["options"]["num_ctx"])
        self.assertNotIn("think", warm)

    # cache
    def test_cache_key_unchanged_when_nothing_new_is_said(self):
        k = self.lb._cache_key("m", "p", None, None, None, {})
        import hashlib
        want = hashlib.sha256(("%s\x00%s\x00%s\x00%s" % ("m", "", "p", "")).encode()).hexdigest()
        self.assertEqual(k, want)

    def test_cache_does_not_serve_a_thought_answer_to_think_false(self):
        self.call("delegate_task", {"model": "big:12b", "prompt": "same"})
        self.call("delegate_task", {"model": "big:12b", "prompt": "same", "think": "false"})
        self.assertEqual(len(Fake.log), 2, "the second call was served from the first one's cache")

    # one at a time
    def test_async_jobs_run_one_at_a_time_and_say_queued(self):
        Fake.delay = 0.6
        ids = []
        for i in range(3):
            text, _ = self.call("delegate_async", {"model": "plain:3b", "prompt": "job %d" % i,
                                                   "no_cache": True})
            ids.append(text.split()[3].rstrip("."))
        time.sleep(0.2)
        states = [self.call("delegate_result", {"job_id": j})[0] for j in ids]
        self.assertTrue(any("queued" in s for s in states), states)
        deadline = time.time() + 15
        while time.time() < deadline and any(
                ("queued" in self.call("delegate_result", {"job_id": j})[0] or
                 "running" in self.call("delegate_result", {"job_id": j})[0]) for j in ids):
            time.sleep(0.2)
        self.assertEqual(Fake.peak, 1, "two generate calls reached Ollama at once")

    # status
    def test_status_says_when_a_model_spilled(self):
        for m in ("big:12b", "big:12b-8k"):
            self.call("delegate_task", {"model": m, "prompt": "load " + m, "no_cache": True})
        text, _ = self.call("ollama_status", {})
        self.assertIn("62% in GPU memory", text)
        self.assertIn("big:12b-8k (all in GPU memory", text)

    def test_version_says_it_is_not_upstream(self):
        self.assertIn("-vb.", self.lb.VERSION)

    def test_config_cli_refuses_junk(self):
        ok, why = self.lb.vb_config_set("think_default", "sometimes")
        self.assertFalse(ok)
        ok, _ = self.lb.vb_config_set("num_ctx_floor", "16384")
        self.assertTrue(ok)


PLANTS = {
    "think-dropped": ('            body["think"] = want\n', '            pass\n'),
    "options-dropped": ('    if opts:\n        body["options"] = opts\n', '    pass\n'),
    "no-auto-window": ('    if cfg_get("num_ctx_auto", "1") != "1":\n        return None\n',
                       '    return None\n'),
    "cache-blind-to-think": ('    if think is not None or options:\n', '    if False:\n'),
    "no-slot": ('    with generate_slot():\n', '    with threading.Lock():\n'),
    "think-to-anyone": ('        if not meta.get("thinking"):\n            info["think"] = "n/a"',
                        '        if False:\n            info["think"] = "n/a"'),
}


def prove_red():
    bad = 0
    # the control: unplanted, the suite must be green, or a red plant proves nothing
    r = subprocess.run([sys.executable, __file__], env=dict(os.environ, LB_SRC=str(SRC)),
                       capture_output=True, text=True, encoding="utf-8", timeout=300)
    if r.returncode != 0:
        print("FAIL control: the suite is red before any plant")
        return 1
    print("green control: the suite passes unplanted")
    for name, (old, new) in PLANTS.items():
        src = SRC.read_text(encoding="utf-8")
        if src.count(old) != 1:
            print("FAIL plant %s: its target is not in the source once" % name)
            bad = 1
            continue
        t = Path(tempfile.mkdtemp()) / "llama_bridge.py"
        t.write_text(src.replace(old, new), encoding="utf-8", newline="\n")
        r = subprocess.run([sys.executable, __file__], env=dict(os.environ, LB_SRC=str(t)),
                           capture_output=True, text=True, encoding="utf-8", timeout=300)
        if r.returncode == 0:
            print("FAIL plant %s: the suite stayed green" % name)
            bad = 1
        else:
            print("red  %s: caught" % name)
    print("prove-red: %s" % ("every planted fault caught" if not bad else "FAILED"))
    return bad


if __name__ == "__main__":
    if "--prove-red" in sys.argv:
        sys.exit(prove_red())
    unittest.main()
