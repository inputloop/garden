#!/usr/bin/env python3
# at1ld -- ATTRIBUTION 1 LADDER: which rung of Corwin's ladder a work owes each author, from
# the lines it shares with what that author made first, and whether the work's own
# declarations meet it.
#
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later
# This program is free software: you can redistribute it and/or modify it under the terms of
# the GNU General Public License as published by the Free Software Foundation, either version
# 3 of the License, or (at your option) any later version.  It is distributed WITHOUT ANY
# WARRANTY; see <https://www.gnu.org/licenses/>.
"""at1ld -- the attribution ladder, as far as a machine can climb it.

His ladder (man/attribution-ladder.md), left-most rung that applies:
  ATTRIBUTE  we reused, or quoted at length, more than 15 lines from the sources of one author
             (a person or a group) over the body of the work.        (his number: 15)
  CREDIT     we can show, or reasonably claim, influence touching several areas of the work,
             or one significantly.     (proxy: at least 4 lines in each of 2 files, or 9 in
                                        one; house numbers, invented, said so)
  ACKNOWLEDGE, THANK  the keepers' call; this tool lists names, it never rules on them.

Evidence: a line belongs to the author whose sources hold it FIRST (git first-add date per file
for a git tree, else the date given with the directory).  A line first seen in two authors'
sources on the same day is CONTESTED and counts for no one.  Short lines, markup and licence
boilerplate are not evidence.  "First seen here" is not "first written": a thing handed over in
chat and committed later is dated by the commit.  The tool says so in its output.

Declarations read: SPDX-FileCopyrightText and Copyright lines in a file's first 40 and last 15
lines; REUSE.toml [[annotations]] (path globs; the last matching annotation wins, as REUSE says);
for CREDIT, the work's README*, CREDITS*, AUTHORS*, ACKNOWLEDGEMENTS*, THANKS*, NOTICE* and FROM
files.  .reuse/dep5 is NOT CHECKED.

usage: at1ld.py WORK --author 'NAME <EMAIL>'=DIR[@YYYY-MM-DD] [--author ...] [--dump-counts]
exit: 0 every rung met; 1 a rung not met; 2 could not check.
"""
import fnmatch
import os
import re
import subprocess
import sys

ATTRIBUTE_LINES = 15          # his number, 2026-10-05
CREDIT_EACH, CREDIT_FILES, CREDIT_ONE = 4, 2, 9   # house numbers (4, 9), invented, said so
MIN_BYTES = 17                # house number, invented: shorter lines are not evidence
TEXT_EXT = None               # every file that decodes as UTF-8 is read
SKIP_DIRS = {".git", "__pycache__", "node_modules", ".pytest_cache"}
BOILER = re.compile(
    r"SPDX-|copyright|\(c\) [0-9]|general public license|free software foundation|"
    r"without any warranty|gnu\.org/licenses|either version 3|this program is free software|"
    r"redistribute it and/or modify|creative commons|creativecommons\.org|licen[cs]e:|"
    r"co-authored-by|claude-session|assisted-by", re.I)
MARKUP = re.compile(r"^[\]\[ |:`*#=_~<>+./(){}\"',;0-9-]*$")
WS = re.compile(r"[ \t\r\f\v]+")
CREDIT_FILES_RE = re.compile(r"^(README|CREDITS|AUTHORS|ACKNOWLEDGE?MENTS|THANKS|NOTICE|FROM)", re.I)


def norm(line):
    """The evidence form of a line, or None.  Byte length, so the awk reader agrees."""
    s = WS.sub(" ", line).strip(" ")
    if len(s.encode("utf-8", "surrogateescape")) < MIN_BYTES or MARKUP.match(s) or BOILER.search(s):
        return None
    return s


def walk(root):
    for d, dirs, files in os.walk(root):
        dirs[:] = sorted(x for x in dirs if x not in SKIP_DIRS)
        for f in sorted(files):
            p = os.path.join(d, f)
            if os.path.isfile(p) and not os.path.islink(p):
                yield p


def read_lines(path):
    try:
        with open(path, "rb") as fh:
            raw = fh.read()
    except OSError:
        return None
    if b"\x00" in raw[:8192]:
        return None
    text = raw.decode("utf-8", "surrogateescape")
    if text.endswith("\n"):
        text = text[:-1]
    return text.split("\n") if text else []


def git_dates(root):
    """{relpath: first-add date} for a git work tree, else None."""
    try:
        top = subprocess.run(["git", "--no-optional-locks", "-C", root, "rev-parse",
                              "--show-toplevel"], capture_output=True, text=True, timeout=60)
        if top.returncode != 0:
            return None
        out = subprocess.run(["git", "--no-optional-locks", "-C", root, "log", "--reverse",
                              "--diff-filter=A", "--name-only", "--format=@%ad",
                              "--date=short", "--", "."], capture_output=True, text=True,
                             timeout=600).stdout
    except (OSError, subprocess.TimeoutExpired):
        return None
    toplevel = top.stdout.strip()
    dates, cur = {}, None
    for ln in out.splitlines():
        if ln.startswith("@"):
            cur = ln[1:]
        elif ln.strip() and cur:
            ab = os.path.realpath(os.path.join(toplevel, ln.strip()))
            dates.setdefault(ab, cur)
    return dates


def load_corpus(spec):
    """'NAME <EMAIL>'=DIR[@DATE] -> (name, email, {line: date})."""
    who, _, where = spec.partition("=")
    m = re.match(r"\s*(.*?)\s*<([^>]+)>\s*$", who)
    name, email = (m.group(1), m.group(2)) if m else (who.strip(), "")
    label = None
    if re.search(r"@\d{4}-\d{2}-\d{2}$", where):
        where, label = where[:-11], where[-10:]
    if not os.path.isdir(where):
        raise SystemExit("at1ld: NOT CHECKED: no such corpus directory %s" % where)
    dates = git_dates(where)
    lines = {}
    for p in walk(where):
        d = label or (dates or {}).get(os.path.realpath(p))
        if d is None:
            d = "9999-12-31"   # undated: never wins a tie
        for ln in read_lines(p) or []:
            n = norm(ln)
            if n is not None and (n not in lines or d < lines[n]):
                lines[n] = d
    return name, email, lines


def owners(corpora):
    """{line: author index, or -1 when contested}."""
    best = {}
    for i, (_n, _e, lines) in enumerate(corpora):
        for ln, d in lines.items():
            if ln not in best or d < best[ln][0]:
                best[ln] = (d, i)
            elif d == best[ln][0] and best[ln][1] != i:
                best[ln] = (d, -1)
    return {ln: i for ln, (_d, i) in best.items()}


def count_work(work, corpora):
    """({(author index, relpath): lines}, {relpath: contested lines}) for WORK."""
    own = owners(corpora)
    counts, contested = {}, {}
    for p in walk(work):
        rel = os.path.relpath(p, work).replace(os.sep, "/")
        seen = set()
        for ln in read_lines(p) or []:
            n = norm(ln)
            if n is None or n in seen or n not in own:
                continue
            seen.add(n)
            i = own[n]
            if i < 0:
                contested[rel] = contested.get(rel, 0) + 1
            else:
                counts[(i, rel)] = counts.get((i, rel), 0) + 1
    return counts, contested


def reuse_annotations(work):
    """[(globs, copyright_text)] from WORK/REUSE.toml, in file order."""
    p = os.path.join(work, "REUSE.toml")
    lines = read_lines(p)
    if lines is None:
        return []
    text = "\n".join(lines)
    out = []
    for block in re.split(r"^\s*\[\[annotations\]\]\s*$", text, flags=re.M)[1:]:
        block = re.split(r"^\s*\[", block, flags=re.M)[0]
        pm = re.search(r"^\s*path\s*=\s*(\[.*?\]|\"[^\"]*\")", block, re.M | re.S)
        cm = re.search(r"^\s*SPDX-FileCopyrightText\s*=\s*(\[.*?\]|\"[^\"]*\")", block, re.M | re.S)
        if not pm:
            continue
        globs = re.findall(r"\"([^\"]*)\"", pm.group(1))
        cr = " ; ".join(re.findall(r"\"([^\"]*)\"", cm.group(1))) if cm else ""
        out.append((globs, cr))
    return out


def reuse_match(glob, rel):
    if "**" in glob:
        return fnmatch.fnmatchcase(rel, glob.replace("**", "*"))
    return fnmatch.fnmatchcase(rel, glob) and rel.count("/") == glob.count("/")


def declared(work, rel, annotations):
    """(who the file names as maker, where that was read)."""
    lines = read_lines(os.path.join(work, rel)) or []
    found = []
    for ln in lines[:40] + lines[-15:]:
        if re.search(r"SPDX-FileCopyrightText|copyright\s*(\(c\)|\d|©)", ln, re.I):
            found.append(ln.strip())
    toml = ""
    for globs, cr in annotations:
        if any(reuse_match(g, rel) for g in globs):
            toml = cr           # the last match wins
    where = []
    if found:
        where.append("in the file")
    if toml:
        where.append("REUSE.toml")
    return " ; ".join(found + ([toml] if toml else [])), " and ".join(where) or "nowhere"


def names(text, name, email):
    t = text.lower()
    return bool((name and name.lower() in t) or (email and email.lower() in t))


def credits_text(work):
    out = []
    for p in walk(work):
        if CREDIT_FILES_RE.match(os.path.basename(p)):
            out.extend(read_lines(p) or [])
    return "\n".join(out)


def main(argv):
    if not argv or argv[0] in ("-h", "--help"):
        print(__doc__)
        return 0 if argv else 2
    work = argv[0]
    specs = [argv[i + 1] for i, a in enumerate(argv) if a == "--author" and i + 1 < len(argv)]
    if not os.path.isdir(work) or not specs:
        print("at1ld: NOT CHECKED: a work directory and at least one --author are needed")
        return 2
    corpora = [load_corpus(s) for s in specs]
    counts, contested = count_work(work, corpora)
    if "--dump-counts" in argv:
        for (i, rel), n in sorted(counts.items(), key=lambda kv: (kv[0][0], kv[0][1])):
            print("%d\t%s\t%d" % (i, rel, n))
        for rel, n in sorted(contested.items()):
            print("-1\t%s\t%d" % (rel, n))
        return 0
    ann = reuse_annotations(work)
    if os.path.exists(os.path.join(work, ".reuse", "dep5")):
        print("NOTE  .reuse/dep5 is present and NOT CHECKED by this tool")
    creds = credits_text(work)
    worst = 0
    print("at1ld: the attribution ladder over %s" % work)
    print("Evidence is first-seen, not first-written: git first-add dates, or the date given "
          "with a directory.")
    for i, (name, email, _lines) in enumerate(corpora):
        files = sorted(((rel, n) for (j, rel), n in counts.items() if j == i),
                       key=lambda x: (-x[1], x[0]))
        body = sum(n for _r, n in files)
        who = "%s <%s>" % (name, email) if email else name
        if body > ATTRIBUTE_LINES:
            missing = []
            print("\nATTRIBUTE  %s: %d lines of this work are first found in %s's sources "
                  "(more than %d: rung 1)." % (who, body, name, ATTRIBUTE_LINES))
            for rel, n in files:
                dec, where = declared(work, rel, ann)
                ok = names(dec, name, email)
                if not ok:
                    missing.append(rel)
                print("  %-58s %4d lines  names %s? %s%s" % (
                    rel, n, name, "yes" if ok else "NO",
                    "" if ok else "  (declares: %s, read %s)" % (dec or "nobody", where)))
            if missing:
                worst = max(worst, 1)
                print("  MISSING  %d file(s) carry %s's lines and do not name %s." % (
                    len(missing), name, name))
            else:
                print("  MET  every file that carries the lines names %s." % name)
        elif sum(1 for _r, n in files if n >= CREDIT_EACH) >= CREDIT_FILES or \
                any(n >= CREDIT_ONE for _r, n in files):
            ok = names(creds, name, email)
            print("\nCREDIT  %s: %d lines across %d file(s) (rung 2 by the house proxy)." % (
                who, body, len(files)))
            print("  %s  the work's credit files %s %s." % (
                "MET" if ok else "MISSING", "name" if ok else "do not name", name))
            if not ok:
                worst = max(worst, 1)
        else:
            print("\nBELOW CREDIT  %s: %d line(s). Acknowledge or thank is the keepers' call."
                  % (who, body))
    if contested:
        print("\nCONTESTED  %d file(s) hold lines first seen in two authors' sources on the same "
              "day; they count for no one. The keepers decide:" % len(contested))
        for rel, n in sorted(contested.items(), key=lambda x: (-x[1], x[0]))[:17]:
            print("  %-58s %4d lines" % (rel, n))
    print("\nVERDICT  %s" % ("every rung met" if worst == 0 else "a rung is not met"))
    return worst


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
