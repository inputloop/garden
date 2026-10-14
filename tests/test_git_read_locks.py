"""git reads without the index lock -- the second-language spec for tests/git-read-locks-tests.sh.

Copyright (C) 2026 Corwin Brust <corwin@bru.st>.  Authored by Mentat (for Corwin).
SPDX-License-Identifier: GPL-3.0-or-later  (or, at your option, any later version)

A plain `git status` opens .git/index.lock and, when nothing changed, unlinks it; on a mount that
refuses deletes the lock stays (sandboxer, 2026-09-29).  Every status/diff/describe a shipped script
runs must carry --no-optional-locks or GIT_OPTIONAL_LOCKS=0.  Written from that rule, not from the sh
test's regex: it tokenizes each command line instead of pattern-matching it.
Run: python3 -m unittest tests.test_git_read_locks
"""
import glob, os, re, shlex, tempfile, unittest

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
READS = {"status", "diff", "describe"}


def offenders(root):
    bad = []
    shell = [p for g in ("bin/*", "skills/*/scripts/*", "SOFT-SKILLS/*/scripts/*", "tests/*.sh")
             for p in glob.glob(os.path.join(root, g)) if os.path.isfile(p)]
    for p in shell:
        if p.endswith(("git-read-locks-tests.sh", ".py")):
            continue
        try:
            lines = open(p, encoding="utf-8", errors="replace").read().splitlines()
        except OSError:
            continue
        for n, line in enumerate(lines, 1):
            if line.lstrip().startswith("#") or "GIT_OPTIONAL_LOCKS=0" in line:
                continue
            for seg in re.split(r"[;&|()`]|\$\(", line):
                try:
                    w = shlex.split(seg, posix=True)
                except ValueError:
                    w = seg.split()
                for i, tok in enumerate(w):
                    if tok != "git":
                        continue
                    j, flags = i + 1, []
                    while j < len(w) and w[j].startswith("-"):
                        flags.append(w[j]); j += 2 if w[j] == "-C" else 1
                    if j < len(w) and w[j] in READS and "--no-optional-locks" not in flags:
                        bad.append("%s:%d" % (os.path.relpath(p, root), n))
    for p in glob.glob(os.path.join(root, "polygram", "**", "*.py"), recursive=True) + \
            glob.glob(os.path.join(root, "skills", "*", "scripts", "*.py")):
        src = open(p, encoding="utf-8", errors="replace").read()
        for m in re.finditer(r"\[([^\]]*)\]", src):
            args = re.findall(r"""["']([^"']*)["']""", m.group(1))
            if args[:1] == ["git"] and READS & set(args) and "--no-optional-locks" not in args:
                bad.append("%s:%d" % (os.path.relpath(p, root), src[:m.start()].count("\n") + 1))
    return sorted(set(bad))


class GitReadLocks(unittest.TestCase):
    def test_the_shipped_scripts_read_without_the_lock(self):
        self.assertEqual(offenders(ROOT), [])

    def test_it_can_fail(self):
        with tempfile.TemporaryDirectory() as t:
            os.makedirs(os.path.join(t, "bin")); os.makedirs(os.path.join(t, "polygram"))
            with open(os.path.join(t, "bin", "a"), "w", encoding="utf-8", newline="\n") as f:
                f.write('#!/bin/sh\nx=$(git -C "$r" status --porcelain)\n# git status in a comment\n'
                        'git --no-optional-locks diff --stat\n')
            with open(os.path.join(t, "polygram", "c.py"), "w", encoding="utf-8", newline="\n") as f:
                f.write('subprocess.run(["git", "-C", r, "status"])\n')
            self.assertEqual(offenders(t), ["bin/a:2", "polygram/c.py:1"])


if __name__ == "__main__":
    unittest.main()
