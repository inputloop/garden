#!/usr/bin/env python3
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
"""test_freshen.py - bin/freshen against small files planted in a temp dir.

  python3 -m unittest tests.test_freshen    the promises hold, and every planted break goes red
  python3 tests/test_freshen.py             the promises, printed one per line
  python3 tests/test_freshen.py --prove-red the above, then break freshen six ways in a temp copy;
                                            exit 0 only if the real script is green AND every
                                            break goes red

What freshen promises (its header and comments): `freshen FILE...` dances each named file and says
"freshened: FILE"; the dance is a rename away and back, so the file ends where it was, with the
same bytes and nothing left beside it; `-r DIR` dances every regular file under DIR but skips
.private trees; a file that cannot be danced is FAILED on stderr and left in place; exit 0 if all
danced, 1 if any failed, and the 1 survives the -r loop (the reason the list is read in this
shell, not a pipeline); no PATH is a usage error, exit 2; a PATH that is not a file is skipped
and said.

Written in Python on purpose: freshen is sh, so the check is in a second language.  The FAILED
cases need a folder the caller cannot write; as root every folder is writable, so those cases say
SKIPPED.  Exit (as a script): 0 all good - 1 a case failed / a break went unnoticed - 77 sh
missing, or --prove-red as root (said).
"""
import os, shutil, stat, subprocess, sys, tempfile, unittest

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCRIPT = os.path.join(ROOT, "bin", "freshen")
SH = shutil.which("sh")
ROOTED = hasattr(os, "geteuid") and os.geteuid() == 0

MUTANTS = [  # (name, old, new, needs_a_locked_folder) -- old must occur exactly once
    ("a failed dance exits 0", "        rc=1\n", "\n", True),
    ("the -r loop runs in a pipeline again", 'while IFS= read -r f; do dance "$f"; done < "$list"',
     'cat "$list" | while IFS= read -r f; do dance "$f"; done', True),
    (".private trees are danced", "-name .private -prune -o ", "", False),
    ("the file is not renamed back", ' && mv -- "$t" "$f" 2>/dev/null; then', "; then", False),
    ("the way back copies, leaving the temp name", ' && mv -- "$t" "$f" 2>/dev/null; then',
     ' && cp -- "$t" "$f" 2>/dev/null; then', False),
    ("no PATH is not a usage error", 'PATH..." >&2; exit 2; }', 'PATH..." >&2; exit 0; }', False),
]


def listing(d):
    out = {}
    for base, dirs, files in os.walk(d):
        for f in files:
            p = os.path.join(base, f)
            with open(p, "rb") as h:
                out[os.path.relpath(p, d)] = h.read()
    return out


def suite(script):
    """Run every case against `script`; return [(name, ok_or_None, why)] (None = SKIPPED)."""
    res = []
    t = tempfile.mkdtemp(prefix="freshen-tests.")
    locked = os.path.join(t, "locked")

    def check(name, ok, why=""):
        res.append((name, bool(ok), "" if ok else why))

    def run(*args):
        p = subprocess.run([SH, script, *args], capture_output=True, text=True, encoding="utf-8", cwd=t,
                           env=dict(os.environ, TMPDIR=t))
        return p.returncode, p.stdout, p.stderr

    def put(rel, data):
        p = os.path.join(t, rel)
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, "wb") as h:
            h.write(data)
        return p

    try:
        one = put("files/one.txt", b"one\n")
        two = put("files/two.txt", b"two, with\r\nmixed endings\n")
        a = put("tree/a.txt", b"a\n")
        b = put("tree/sub/b.txt", b"b\n")
        put("tree/.private/secret.txt", b"not for tools\n")
        c = put("locked/c.txt", b"c\n")
        put("mixed/ok.txt", b"ok\n")
        put("mixed/locked/d.txt", b"d\n")

        rc, out, err = run()
        check("no PATH: usage on stderr, exit 2", rc == 2 and "usage" in err, f"exit {rc} err={err!r}")

        before = listing(os.path.join(t, "files"))
        rc, out, err = run(one, two)
        check("named files: exit 0, each said freshened", rc == 0 and f"freshened: {one}" in out
              and f"freshened: {two}" in out, f"exit {rc} out={out!r} err={err!r}")
        after = listing(os.path.join(t, "files"))
        check("named files: same names, same bytes, nothing left beside them", after == before,
              f"before={sorted(before)} after={sorted(after)}")

        before = listing(os.path.join(t, "tree"))
        rc, out, err = run("-r", os.path.join(t, "tree"))
        check("-r: exit 0, every regular file under the folder freshened",
              rc == 0 and f"freshened: {a}" in out.replace("//", "/") and f"freshened: {b}" in out.replace("//", "/"),
              f"exit {rc} out={out!r}")
        check("-r: a .private tree is skipped", ".private" not in out, f"out={out!r}")
        check("-r: same names, same bytes, nothing left beside them",
              listing(os.path.join(t, "tree")) == before, f"after={sorted(listing(os.path.join(t, 'tree')))}")

        rc, out, err = run(os.path.join(t, "tree"))
        check("a folder without -r is skipped and said", "skip (not a file)" in err and "freshened" not in out,
              f"exit {rc} out={out!r} err={err!r}")

        if ROOTED:
            for n in ("a file that cannot be danced: FAILED, exit 1, left in place",
                      "exit 1 survives the -r loop", "one failure does not stop the others"):
                res.append((n, None, "running as root: every folder is writable"))
        else:
            os.chmod(locked, stat.S_IRUSR | stat.S_IXUSR)
            os.chmod(os.path.join(t, "mixed", "locked"), stat.S_IRUSR | stat.S_IXUSR)
            rc, out, err = run(c)
            with open(c, "rb") as h:
                same = h.read() == b"c\n"
            check("a file that cannot be danced: FAILED, exit 1, left in place",
                  rc == 1 and f"FAILED: {c}" in err and same and os.listdir(locked) == ["c.txt"],
                  f"exit {rc} err={err!r} left={os.listdir(locked)}")
            rc, out, err = run("-r", os.path.join(t, "mixed"))
            check("exit 1 survives the -r loop", rc == 1 and "FAILED" in err, f"exit {rc} err={err!r}")
            rc, out, err = run(c, one)
            check("one failure does not stop the others", rc == 1 and f"freshened: {one}" in out,
                  f"exit {rc} out={out!r}")
    finally:
        for d in (locked, os.path.join(t, "mixed", "locked")):
            if os.path.isdir(d):
                os.chmod(d, stat.S_IRWXU)
        shutil.rmtree(t, ignore_errors=True)
    return res


def report(res, quiet=False):
    bad = [r for r in res if r[1] is False]
    if not quiet:
        for name, ok, why in res:
            print(("SKIPPED  " if ok is None else "PASS  " if ok else "FAIL  ") + name + (f" -- {why}" if why else ""))
        n = sum(1 for r in res if r[1] is not None)
        print(f"{n - len(bad)}/{n} pass, {len(bad)} fail, {sum(1 for r in res if r[1] is None)} skipped")
    return not bad


def plant(src, old, new, dst):
    if src.count(old) != 1:
        return False
    with open(dst, "w", encoding="utf-8", newline="") as h:
        h.write(src.replace(old, new))
    return True


def prove_red(quiet=False):
    """Return (caught, planted, lines). A mutant needing a locked folder is SKIPPED as root."""
    with open(SCRIPT, encoding="utf-8", newline="") as h:
        src = h.read()
    d = tempfile.mkdtemp(prefix="freshen-mut.")
    caught, planted, lines = 0, 0, []
    try:
        for i, (name, old, new, needs_lock) in enumerate(MUTANTS):
            if needs_lock and ROOTED:
                lines.append(f"SKIPPED  {name} -- running as root, nothing can be locked"); continue
            m = os.path.join(d, f"freshen.{i}")
            if not plant(src, old, new, m):
                lines.append(f"BREAK NOT PLANTED  {name} -- freshen changed shape; update MUTANTS"); planted += 1; continue
            planted += 1
            fails = [r for r in suite(m) if r[1] is False]
            if fails:
                caught += 1; lines.append(f"CAUGHT  {name} -- FAIL  {fails[0][0]}")
            else:
                lines.append(f"MISSED  {name} -- the suite stayed green on a broken freshen")
    finally:
        shutil.rmtree(d, ignore_errors=True)
    return caught, planted, lines


@unittest.skipIf(SH is None, "sh not found: freshen is a sh script")
class Freshen(unittest.TestCase):
    def test_promises(self):
        bad = [f"{n} -- {w}" for n, ok, w in suite(SCRIPT) if ok is False]
        self.assertEqual(bad, [])

    def test_prove_red(self):
        caught, planted, lines = prove_red()
        self.assertTrue(planted > 0 and caught == planted, "\n".join(lines))


def main(argv):
    if argv not in ([], ["--prove-red"]):
        print("usage: python3 tests/test_freshen.py [--prove-red]", file=sys.stderr); return 2
    if SH is None:
        print("test_freshen.py: sh not found; freshen is a sh script, nothing can be checked", file=sys.stderr); return 77
    print("== freshen: the dance keeps its promises ==")
    green = report(suite(SCRIPT))
    if not argv:
        return 0 if green else 1
    if not green:
        print("PROVE-RED NOT OK -- the real script is not green; a red here proves nothing"); return 1
    if ROOTED:
        print("test_freshen.py: running as root, the FAILED cases cannot be planted; --prove-red is incomplete", file=sys.stderr)
    print("\n== planted breaks: each must turn the suite red ==")
    caught, planted, lines = prove_red()
    print("\n".join(lines)); print()
    if planted and caught == planted:
        print(f"PROVE-RED OK -- controls green, {caught}/{planted} planted breaks caught")
        return 77 if ROOTED else 0
    print(f"PROVE-RED NOT OK -- {caught}/{planted} planted breaks caught"); return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
