#!/usr/bin/env python3
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
"""test_thread.py - bin/thread.sh against a small message thread planted in a temp dir.

  python3 -m unittest tests.test_thread    the promises hold, and every planted break goes red
  python3 tests/test_thread.py             the promises, printed one per line
  python3 tests/test_thread.py --prove-red the above, then break thread.sh nineteen ways in a temp
                                           copy; exit 0 only if the real script is green AND
                                           every break goes red

What thread.sh promises (its header): a thread is a directory and a message is a file NNN-FROM.md
with a `--- key: value ---` header; the order is the filename, so nothing can silently reorder;
escape first, then mark up (a message is data, not markup), in the thread page AND the index;
every message shows its own provenance header (from, date, seq, in-reply-to); unsigned is SAID
(a DRAFT or unsigned status wears the "unsigned" pill); a clearsigned message (2026-09-28) is
read through its OpenPGP armor -- the BEGIN PGP SIGNED MESSAGE line and its Hash: headers, the
signature block, and the "- " dash-escaping are gone before parsing -- and, since this tool never
verifies, its pill says "clearsigned (not verified here)", never "unsigned" or "signed"; a message
with no header (2026-09-28) still opens its own article, takes its provenance from the filename,
says "no header (unsigned)" (or "no header" + the clearsigned pill), and CRLF line ends are read as
LF; every <article is closed exactly once; no JS; `-i DIR` renders the thread index;
unknown flags are rejected loudly (exit 2); no DIR is exit 2; a missing DIR is exit 3.

Written in Python on purpose: thread.sh is sh + awk, so the check is in a second language.
Exit (as a script): 0 all good - 1 a case failed / a break went unnoticed - 77 sh or awk missing.
"""
import os, re, shutil, subprocess, sys, tempfile, unittest

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCRIPT = os.path.join(ROOT, "bin", "thread.sh")
SH = shutil.which("sh")
MISSING = [t for t in ("sh", "awk", "sed") if shutil.which(t) is None]

MUTANTS = [  # (name, old, new) -- old must occur exactly once in thread.sh
    ("mark up before escaping", "function inl(s){ s=esc(s)", "function inl(s){ "),
    ("the sender is not escaped", 'printf "<span class=\\"who\\">%s</span>", esc(h["from"])',
     'printf "<span class=\\"who\\">%s</span>", h["from"]'),
    ("the order is not the filename", 'for f in "$dir"/[0-9]*.md ; do', 'for f in $(ls -r "$dir"/[0-9]*.md) ; do'),
    ("unsigned is implied, not said", 'if (h["status"] ~ /DRAFT|unsigned/) printf', "if (0) printf"),
    ("in-reply-to is dropped", 'if (h["in-reply-to"] != "") printf', "if (0) printf"),
    ("unknown flags are accepted", '-*) echo "$me: unknown option: $1" ; echo "Usage: $me [-i] DIR" ; exit 2 ;;',
     "-*) shift ;;"),
    ("the index counts files that are not messages", "grep -c '^[0-9].*\\.md$'", "grep -c '\\.md$'"),
    ("the armor is not stripped", 'unarmor "$f" | awk -v cs="$cs"', 'cat "$f" | awk -v cs="$cs"'),
    ("the Hash: headers are kept", "cs && hdr { if ($0 ~ /^[[:space:]]*$/) hdr=0; next }", "cs && hdr { hdr=0 }"),
    ("the signature block is kept", "cs && /^-----BEGIN PGP SIGNATURE-----/ { sig=1; next }", "0 { }"),
    ("dash-escaping is not undone", '       cs { sub(/^- /, "") }\n', ""),
    ("dash-escaping is undone in an unsigned message too", '       cs { sub(/^- /, "") }', '       { sub(/^- /, "") }'),
    ("a clearsigned message claims to be signed", '>clearsigned (not verified here)</span>"\n      else if',
     '>signed</span>"\n      else if'),
    ("a header-less message gets no article of its own", "    NR==1 {   # 2026-09-28", "    0 {   # 2026-09-28"),
    ("CRLF is not handled", '{ sub(/\\r$/, "") }', "{ }"),
    ("a header-less message wears no pill", 'else printf "<span class=\\"pill\\">no header (unsigned)</span>"', 'else printf ""'),
    ("a header-less clearsigned message is called unsigned", 'if (cs == 1) printf "<span class=\\"pill\\">no header</span>', 'if (0) printf "<span class=\\"pill\\">no header</span>'),
    ("every file closes an article, opened or not", 'if(opened) print "</article>"', 'print "</article>"'),
    ("the index subject is not escaped", " | sed 's/&/\\&amp;/g; s/</\\&lt;/g; s/>/\\&gt;/g')", ")"),
]

MSG = """---
thread: t-001
seq: {seq}
from: {frm}
date: 2026-09-{day}
{extra}subject: {subject}
status: {status}
---
{body}
"""


def articles(html):
    return re.findall(r"<article.*?</article>", html, re.S)


def suite(script):
    res = []
    t = tempfile.mkdtemp(prefix="thread-tests.")

    def check(name, ok, why=""):
        res.append((name, bool(ok), "" if ok else why))

    def run(*args):
        p = subprocess.run([SH, script, *args], capture_output=True, text=True, encoding="utf-8", cwd=t)
        return p.returncode, p.stdout, p.stderr

    def put(rel, text):
        p = os.path.join(t, rel)
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, "w", encoding="utf-8", newline="") as h:
            h.write(text)

    try:
        th = os.path.join(t, "threads", "t-001")
        # written out of order on purpose: the filename is the order, not the write
        put("threads/t-001/010-Vibrobeast.md", MSG.format(seq="010", frm="Vibrobeast (bench)", day="03",
            extra="in-reply-to: 002-SAVANNAH.md\n", subject="third", status="DRAFT, unsigned",
            body="Third said **loud** and `a<b` and *soft*."))
        put("threads/t-001/001-SAVANNAH.md", MSG.format(seq="001", frm="SAVANNAH <sib> & co", day="01",
            extra="", subject="<b>first</b> & more", status="signed; keeper-relayed",
            body="First <script>alert(1)</script> & done."))
        put("threads/t-001/002-SAVANNAH.md", MSG.format(seq="002", frm="SAVANNAH", day="02",
            extra="in-reply-to: 001-SAVANNAH.md\n", subject="second", status="signed", body="Second."))
        put("threads/t-001/notes.md", "not a message: no NNN- prefix\n")

        rc, out, err = run(th)
        arts = articles(out)
        check("thread: exit 0, one article per NNN-FROM.md file, and only those",
              rc == 0 and len(arts) == 3 and "not a message" not in out, f"exit {rc}, {len(arts)} articles")
        order = [m for m in ("First", "Second", "Third") if m in out]
        pos = [out.find(m) for m in ("First", "Second", "Third")]
        check("the order is the filename (001, 002, 010), not the order written",
              order == ["First", "Second", "Third"] and pos == sorted(pos), f"positions {pos}")
        check("escape first: a script tag in a body arrives as text",
              "&lt;script&gt;alert(1)&lt;/script&gt; &amp; done" in out and "<script" not in out,
              "raw markup reached the page")
        check("escape first: the sender's name is escaped too", "SAVANNAH &lt;sib&gt; &amp; co" in out,
              "sender not escaped")
        check("then mark up: **bold**, `code` (escaped inside), *italic*",
              "<strong>loud</strong>" in out and "<code>a&lt;b</code>" in out and "<em>soft</em>" in out,
              "markup missing")
        a1 = arts[0] if arts else ""
        a3 = arts[2] if len(arts) > 2 else ""
        check("each message shows its provenance: from, date, seq",
              all(x in a1 for x in ("2026-09-01", "#001")) and all(x in a3 for x in ("Vibrobeast (bench)", "2026-09-03", "#010")),
              "header fields missing")
        check("in-reply-to is shown", "in reply to 002-SAVANNAH.md" in a3, "no in-reply-to")
        check("unsigned is SAID: a DRAFT/unsigned status wears the pill, a signed one does not",
              'class="pill">unsigned' in a3 and "pill" not in a1, "pill wrong")
        check("no JS on the page", "<script" not in out.lower(), "script tag found")

        # a clearsigned message: the armor is built as plain text (no key needed; nothing verifies)
        put("threads/t-002/003-Bryant.md", "-----BEGIN PGP SIGNED MESSAGE-----\nHash: SHA512\n\n"
            + "- ---\nseq: 003\nfrom: Bryant\ndate: 2026-09-04\nsubject: armored\nstatus: DRAFT, unsigned\n- ---\n"
            + "Armored body.\n- - a dash-escaped list item\n"
            + "-----BEGIN PGP SIGNATURE-----\n\niQEzBAEBCgAdFiEEnotarealsignature\n=abcd\n-----END PGP SIGNATURE-----\n")
        put("threads/t-002/004-Dee.md", MSG.format(seq="004", frm="Dee", day="05", extra="", subject="plain",
            status="received", body="- keep this dash, the message is not armored"))
        rc, out, err = run(os.path.join(t, "threads", "t-002"))
        arts = articles(out)
        a1 = arts[0] if arts else ""
        check("clearsigned: read through its armor, with its provenance header",
              rc == 0 and len(arts) == 2 and all(x in a1 for x in ('class="who">Bryant<', "2026-09-04", "#003")),
              f"exit {rc}, {len(arts)} articles")
        check("clearsigned: the pill says 'clearsigned (not verified here)', not unsigned or signed",
              'class="pill">clearsigned (not verified here)</span>' in a1 and ">unsigned<" not in a1
              and ">signed<" not in a1, "pill: " + ", ".join(re.findall(r'class="pill">([^<]*)<', a1)))
        check("clearsigned: no armor reaches the page (BEGIN/END lines, Hash:, signature data)",
              not any(x in out for x in ("PGP SIGNED", "PGP SIGNATURE", "Hash: SHA512", "iQEzBAEB", "=abcd")),
              "armor text found")
        check("clearsigned: dash-escaping is undone", "- a dash-escaped list item" in a1
              and "- - a dash" not in a1 and "- ---" not in out, "dash-escaped text found")
        check("an unarmored message keeps its own leading '- '", "- keep this dash" in out, "the dash was eaten")

        # a message with no header, CRLF line ends; an empty message; a clearsigned one with no header
        os.makedirs(os.path.join(t, "threads", "t-003"))
        with open(os.path.join(t, "threads", "t-003", "005-Ann.md"), "wb") as h:
            h.write(b"First paragraph, no header.\r\nStill the first.\r\n\r\nSecond paragraph.\r\n")
        put("threads/t-003/006-Bob.md", "")
        put("threads/t-003/007-Cy.md", "-----BEGIN PGP SIGNED MESSAGE-----\nHash: SHA256\n\nCy wrote no header.\n"
            + "-----BEGIN PGP SIGNATURE-----\n\niQEzBAEBfake\n-----END PGP SIGNATURE-----\n")
        rc, out, err = run(os.path.join(t, "threads", "t-003"))
        arts = articles(out)
        ann = next((a for a in arts if "no header, CRLF" in a or "First paragraph" in a), "")
        cy = next((a for a in arts if "Cy wrote" in a), "")
        check("no header: the message still opens its own article, provenance from the filename",
              rc == 0 and 'class="who">Ann<' in ann and "#005" in ann, f"exit {rc}, {len(arts)} articles")
        check("no header: the pill says so honestly, 'no header (unsigned)'",
              'class="pill">no header (unsigned)</span>' in ann, "pill: " + ", ".join(re.findall(r'class="pill">([^<]*)<', ann)))
        check("no header but clearsigned: 'no header' and 'clearsigned (not verified here)', never unsigned",
              'class="pill">no header</span>' in cy and "clearsigned (not verified here)" in cy
              and "unsigned" not in cy, "pill: " + ", ".join(re.findall(r'class="pill">([^<]*)<', cy)))
        raw = subprocess.run([SH, script, os.path.join(t, "threads", "t-003")], capture_output=True, cwd=t).stdout
        ncr = raw.count(b"\r")
        check("CRLF: no carriage return reaches the page (read as bytes), the blank CRLF line splits paragraphs",
              ncr == 0 and ann.count("<p>") == 2, f"{ann.count('<p>')} paragraphs, {ncr} CR bytes")
        pages = [out] + [run(os.path.join(t, "threads", x))[1] for x in ("t-001", "t-002")]
        counts = [(p.count("<article"), p.count("</article>")) for p in pages]
        check("tags balance on every page: each <article is closed exactly once (an empty file adds neither)",
              all(a == b for a, b in counts) and counts[0] == (2, 2), f"(open, close) per page: {counts}")

        rc, out, err = run("-i", os.path.join(t, "threads"))
        arts = articles(out)
        t1 = next((a for a in arts if 'class="who">t-001<' in a), "")
        check("-i: the index lists each thread, a link, and counts messages only (NNN-FROM.md)",
              rc == 0 and len(arts) == 3 and "3 message(s)" in t1 and 'href="t-001.html"' in t1,
              f"exit {rc}, {re.findall(r'[0-9]+ message', out)}")
        check("-i: escape first holds in the index too (the subject is message data)",
              "&lt;b&gt;first&lt;/b&gt; &amp; more" in out and "<b>first</b>" not in out,
              "the subject reached the index as raw markup")

        rc, out, err = run("-x", th)
        check("an unknown flag is rejected loudly, exit 2", rc == 2 and "unknown option: -x" in out + err, f"exit {rc}")
        rc, out, err = run()
        check("no DIR: usage, exit 2", rc == 2 and "Usage" in out + err, f"exit {rc}")
        rc, out, err = run(os.path.join(t, "nowhere"))
        check("a DIR that is not there: exit 3", rc == 3 and "no such directory" in out + err, f"exit {rc}")
        rc, out, err = run("-h")
        check("-h: usage, exit 0", rc == 0 and "Usage" in out, f"exit {rc}")
    finally:
        shutil.rmtree(t, ignore_errors=True)
    return res


def report(res):
    bad = [r for r in res if not r[1]]
    for name, ok, why in res:
        print(("PASS  " if ok else "FAIL  ") + name + (f" -- {why}" if why else ""))
    print(f"{len(res) - len(bad)}/{len(res)} pass, {len(bad)} fail")
    return not bad


def prove_red():
    with open(SCRIPT, encoding="utf-8", newline="") as h:
        src = h.read()
    d = tempfile.mkdtemp(prefix="thread-mut.")
    caught, lines = 0, []
    try:
        for i, (name, old, new) in enumerate(MUTANTS):
            if src.count(old) != 1:
                lines.append(f"BREAK NOT PLANTED  {name} -- thread.sh changed shape; update MUTANTS"); continue
            m = os.path.join(d, f"thread.{i}.sh")
            with open(m, "w", encoding="utf-8", newline="") as h:
                h.write(src.replace(old, new))
            fails = [r for r in suite(m) if not r[1]]
            if fails:
                caught += 1; lines.append(f"CAUGHT  {name} -- FAIL  {fails[0][0]}")
            else:
                lines.append(f"MISSED  {name} -- the suite stayed green on a broken thread.sh")
    finally:
        shutil.rmtree(d, ignore_errors=True)
    return caught, len(MUTANTS), lines


@unittest.skipIf(MISSING, "needs " + " ".join(MISSING))
class Thread(unittest.TestCase):
    def test_promises(self):
        self.assertEqual([f"{n} -- {w}" for n, ok, w in suite(SCRIPT) if not ok], [])

    def test_prove_red(self):
        caught, n, lines = prove_red()
        self.assertEqual(caught, n, "\n".join(lines))


def main(argv):
    if argv not in ([], ["--prove-red"]):
        print("usage: python3 tests/test_thread.py [--prove-red]", file=sys.stderr); return 2
    if MISSING:
        print("test_thread.py: needs " + " ".join(MISSING) + "; thread.sh is sh + awk", file=sys.stderr); return 77
    print("== thread.sh: a thread renders as its header promises ==")
    green = report(suite(SCRIPT))
    dashes = open(SCRIPT, encoding="utf-8").read().count("\u2014")   # ERRATA E8: the template has none
    print(("  ok    " if not dashes else "  FAIL  ") + "the page template carries no em-dash (%d found)" % dashes)
    green = green and not dashes
    if not argv:
        return 0 if green else 1
    if not green:
        print("PROVE-RED NOT OK -- the real script is not green; a red here proves nothing"); return 1
    print("\n== planted breaks: each must turn the suite red ==")
    caught, n, lines = prove_red()
    print("\n".join(lines)); print()
    if caught == n:
        print(f"PROVE-RED OK -- controls green, {caught}/{n} planted breaks caught"); return 0
    print(f"PROVE-RED NOT OK -- {caught}/{n} planted breaks caught"); return 1


class Template(unittest.TestCase):
    def test_the_page_template_carries_no_em_dash(self):
        # ERRATA E8 (2026-09-29): thread pages may reach the sibling shop, which writes without them.
        # A message's own words are data and keep theirs; only the template is checked.
        with open(os.path.join(ROOT, "bin", "thread.sh"), encoding="utf-8") as f:
            self.assertEqual(f.read().count("\u2014"), 0)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
