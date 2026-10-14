"""ps1sg (persona sheets signed at make dist): the list parses the same in Python as in the
shell; make dist calls it on both paths (signed and UNSIGNED=1); its own --prove-red passes.

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; GPL-3.0-or-later.
Mentat (for Corwin; claude-opus-5-5)
"""
import os, shutil, subprocess, unittest

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def rows():
    with open(os.path.join(HERE, "conventions", "SIGNED-PERSONAS.org"), encoding="utf-8") as fh:
        t = [l for l in fh if l.startswith("|") and not l.startswith("|-")][1:]
    return [[c.strip() for c in l.strip().strip("|").split("|")][:2] for l in t]


class PersonaSigning(unittest.TestCase):
    def test_corwin_is_listed_with_its_seat_copy(self):
        r = {f: a for f, a in rows()}
        self.assertIn("../../modelthisbook/CORWIN.md", r)
        self.assertEqual(r["../../modelthisbook/CORWIN.md"], "book/CORWIN.md")

    def test_make_dist_calls_it_on_both_paths(self):
        mk = open(os.path.join(HERE, "Makefile"), encoding="utf-8").read()
        dist = mk.split("\ndist:", 1)[1].split("\n\n", 1)[0]
        self.assertIn("sh bin/ps1sg check", dist)
        self.assertIn("sh bin/ps1sg sign", dist)

    @unittest.skipUnless(shutil.which("gpg"), "no gpg: NOT CHECKED")
    def test_prove_red(self):
        r = subprocess.run(["sh", os.path.join(HERE, "bin", "ps1sg"), "--prove-red"], capture_output=True, text=True, encoding="utf-8")
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)


if __name__ == "__main__":
    unittest.main()
