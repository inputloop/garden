#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Bryant Frankford <nathanielfrankford@gmail.com> and Contributors
# SPDX-FileCopyrightText: 2026 Corwin Brust <corwin@bru.st> and Contributors
# SPDX-License-Identifier: GPL-3.0-or-later
# Bryant's colophon 1.1 is GPL-3.0-or-later OR LGPL-3.0-or-later. This edition is co-made, so by
# colophon's own rule it carries the terms both makers offer: GPL-3.0-or-later. The LGPL option
# returns to the whole file when Corwin offers it for his changes (one line in the parties file).
"""colophon.py: stamp and check the garden's license terms, and name every maker (power-glove's Tag).

Garden edition (1.1-garden.1, Corwin Brust's garden, for Bryant): Bryant's 1.1 with the attribution
ladder (attribute <- credit <- acknowledge <- thank) and no one's terms in the code. The keeper and
every party, with the terms each offers, come from .colophon-parties.json (or --parties FILE); with
none, colophon says NOT CHECKED. Evidence of ideas and lineage CREDITS a party (the credits must
name them); evidence of their words in the work ATTRIBUTES them (the copyright must name them):
a notice, a byline, a made-or-derived statement, git history, a parcel copy, or (with --sources)
more than 15 lines first seen in that party's own sources. A check whose second reader could not
run exits 2 unless --one-reader says the keeper accepts one. Nothing is fetched without --fetch.

Bryant's 1.1 docstring, as he wrote it: "The terms are the keeper's word of 2026-10-05: code
GPL-3.0-or-later OR LGPL-3.0-or-later; prose and art CC-BY-SA-4.0; copyright "Bryant Frankford
<nathanielfrankford@gmail.com> and Contributors"." Every maker found on evidence
(a notice, a byline, a lineage line, git history, a parcel) is named, and work
two makers share carries only the terms both offer. Someone else's notice is
never replaced, secrets are never stamped, and a check that could not run says
NOT CHECKED, never a silent pass. Stdlib only.

usage:
  colophon.py who   ROOT [--parcels DIR]... [--parties FILE] [--sources KEY=DIR[@DATE]]... [--no-git] [--json]
  colophon.py plan  ROOT [--joint "NAME <EMAIL>"]... [--toml-only] [--art-is-ours] [--parcels DIR]...
                         [--parties FILE] [--sources KEY=DIR[@DATE]]... [--no-git]
  colophon.py apply ROOT [the plan flags] [--year YYYY] [--fetch]
  colophon.py check ROOT [--parcels DIR]... [--parties FILE] [--sources KEY=DIR[@DATE]]... [--no-git]
                         [--one-reader]
  colophon.py texts DEST [ID ...] [--fetch]
  colophon.py --selftest [--prove-red]
exit: 0 clean; 1 gaps, holds, asks or refusals; 2 could not check.
"""
import difflib, fnmatch, hashlib, json, os, re, shutil, subprocess, sys, tempfile, time, urllib.request

VERSION = "1.1-garden.1"
HOLDER = CODE = PROSE = None   # the keeper's, read from the parties file (use_keeper); never written here
FETCH = False                  # license texts are fetched only with --fetch
LADDER_LINES = 15              # rung 1, his number: more than 15 lines from one party's sources
TEXTS = {  # steward copies, pinned 2026-10-05 (a fetched text must match its pin)
    "GPL-3.0-or-later": ("https://www.gnu.org/licenses/gpl-3.0.txt",
                         "3972dc9744f6499f0f9b2dbf76696f2ae7ad8af9b23dde66d6af86c9dfb36986"),
    "LGPL-3.0-or-later": ("https://www.gnu.org/licenses/lgpl-3.0.txt",
                          "e3a994d82e644b03a792a930f574002658412f62407f5fee083f2555c5f23118"),
    "CC-BY-SA-4.0": ("https://creativecommons.org/licenses/by-sa/4.0/legalcode.txt",
                     "28a9529c7d0bb4dc51f4bf5c116a3d16ef247a052f7591466768ddf563fd1cf5"),
}
HERE = os.path.dirname(os.path.abspath(__file__))
SKIP_DIRS = {".git", ".hg", ".svn", "node_modules", "__pycache__", ".venv", "venv", "LICENSES", ".reuse"}
STYLE_BY_EXT = {}
for style, exts in {
    "#": ".sh .bash .zsh .ksh .py .pl .pm .rb .r .yaml .yml .toml .cfg .conf .mk .awk .tcl .ps1 .nix .cmake .ex .exs .jl .htaccess",
    "//": ".js .mjs .cjs .ts .tsx .jsx .go .java .kt .kts .swift .rs .c .h .cc .cpp .hpp .cs .dart .php .scss .groovy .zig",
    "/*": ".css",
    "<!--": ".html .htm .xml .svg .vue .xhtml .md .markdown",
    ";;": ".el .lisp .scm .clj .cljs .rkt",
    "--": ".sql .lua .hs",
    "REM": ".bat .cmd",
    "%": ".tex",
    "..": ".rst",
    "# ": ".org",
}.items():
    for e in exts.split():
        STYLE_BY_EXT[e] = style
STYLE_BY_NAME = {"Makefile": "#", "GNUmakefile": "#", "Dockerfile": "#", ".htaccess": "#"}
PROSE_EXT = {".md", ".markdown", ".org", ".rst", ".adoc", ".txt", ".tex"}
PROSE_NAMES = {"README", "ChangeLog", "CHANGELOG", "NEWS", "AUTHORS", "THANKS", "TODO", "INSTALL", "HACKING", "FROM"}
LICENSE_FILE_RE = re.compile(r"^(LICEN[CS]E|COPYING)(\.[A-Za-z0-9.-]+)?$")
ART_EXT = {".png", ".jpg", ".jpeg", ".gif", ".webp", ".ico", ".svgz", ".bmp", ".mp3", ".wav", ".ogg",
           ".mp4", ".webm", ".mkv", ".pdf", ".woff", ".woff2", ".ttf", ".otf"}
SECRET_RE = re.compile(r"(secret|\.key$|\.pem$|\.p12$|\.pfx$|id_rsa|id_ed25519|(^|/)\.env($|\.))", re.I)
NOTICE_RE = [
    ("MIT (notice)", r"Permission is hereby granted, free of charge"),
    ("Apache-2.0 (notice)", r"Licensed under the Apache License"),
    ("BSD (notice)", r"Redistribution and use in source and binary forms"),
    ("GPL (notice)", r"under the terms of the GNU (Affero |Lesser )?General Public License"),
    ("MPL-2.0 (notice)", r"Mozilla Public\s+License"),
    ("all rights reserved", r"All rights reserved"),
]
OK_CODE = {"MIT", "MIT-0", "BSD-2-Clause", "BSD-3-Clause", "ISC", "Zlib", "0BSD", "CC0-1.0", "Unlicense",
           "Apache-2.0", "MPL-2.0", "BSL-1.0", "X11", "Python-2.0", "Artistic-2.0", "LGPL-2.1-or-later",
           "LGPL-3.0-only", "LGPL-3.0-or-later", "GPL-2.0-or-later", "GPL-3.0-only", "GPL-3.0-or-later"}
NOTE_CODE = {"AGPL-3.0-only": "combines with GPLv3, but its parts keep their network terms",
             "AGPL-3.0-or-later": "combines with GPLv3, but its parts keep their network terms"}
OK_PROSE = {"CC-BY-4.0", "CC-BY-SA-4.0", "CC0-1.0", "CC-BY-SA-3.0", "CC-BY-3.0"}
HOLD_PAT = re.compile(r"^(GPL-2\.0(-only)?|SSPL-1\.0|BUSL-1\.1|LicenseRef-Proprietary|Proprietary)$|^CC-BY(-[A-Z]+)*-N[CD]")
TAG = "SPDX-" "License-Identifier:"  # split so readers of this file do not take it for its own tag
CTAG = "SPDX-" "FileCopyrightText:"
FTAG = "SPDX-" "FileContributor:"
KEEPER = None
# Who may hold a share of the work and the terms each has offered, in their own word (dated). Garden
# edition: no one is written here. A .colophon-parties.json at the root, or --parties FILE, names the
# parties, and "_keeper" (or a party's "keeper": true) says whose garden it is. See
# references/parties.example.json for the shape.
PARTIES = {}
# The keeper's answers of 2026-10-05: work derived from someone's, or built on their ideas or disciplines, names
# them as a co-owner, and its license narrows to what every owner offers. ("credit" would name a contributor.)
POLICY = dict.fromkeys(("notice", "byline", "made", "derived", "lineage", "idea", "joint", "git", "parcel",
                        "similar"), "owner")
# Garden edition: the attribution ladder. Copyright covers words and code, not ideas: evidence that a
# party's ideas, disciplines or lineage shaped the work CREDITS them (rung 2, named in the credits);
# evidence that their words are in it ATTRIBUTES them (rung 1, named in its copyright). A parties file
# may set "_policy" to change a kind, on the keeper's word.
POLICY.update({"idea": "credit", "lineage": "credit", "lines": "owner", "quote": "credit", "credited": "credit"})
NOT_MAKERS = re.compile(r"(?i)^(claude|anthropic|copilot|chatgpt|openai|gemini|github|dependabot|renovate|mentat"
                        r"|polygram)\b|\[bot\]|noreply@anthropic\.com")
NAME = r"[A-Z][A-Za-z.\-]+(?: [A-Z][A-Za-z.\-]+)?"
EVIDENCE = [  # statements of provenance; a mention never counts
    ("byline", re.compile(r"^(?:[Ww]ritten (?:with|by) )?[A-Z][\w-]+ \(for (?P<who>" + NAME + r")[;)]")),
    ("derived", re.compile(r"^(?:[Ll]ineage: *)?(?:[Dd]erived|[Aa]dapted|[Pp]orted|[Ff]orked|[Tt]ranslated|"
                           r"[Rr]ewritten|[Ww]ritten here) from (?:the )?(?P<who>" + NAME + r")'s\b")),
    ("made", re.compile(r"(?:^|\b(?:[Tt]his(?: [a-z]+)?|[Ii]t|[Ww]hich|v[\d.]+) (?:was|is|were) )(?:[Ss]ynthesi[sz]ed|"
                        r"[Ww]ritten|[Mm]ade|[Bb]uilt|[Aa]uthored|[Dd]rafted|[Dd]esigned) by (?P<who>" + NAME + r")\b")),
    ("made", re.compile(r"\b(?:[Cc]o-?made|[Cc]o-?written|[Cc]o-?authored|[Mm]ade together|[Ww]ritten together) "
                        r"with (?P<who>" + NAME + r")\b")),
    ("idea", re.compile(r"\b(?:(?:[Tt]his skill|[Tt]he skill|[Tt]his|[Ii]t) is|[Ss]tatement of|[Ss]napshot of|"
                        r"[Cc]odification of) (?:the )?(?P<who>" + NAME + r")'s (?:own )?(?:[\w-]+ ){0,2}"
                        r"(?:discipline|doctrine|method|practice|ritual|principles|framework|protocol|design)\b")),
    ("idea", re.compile(r"\b(?:[Dd]esign|[Ii]dea|[Aa]pproach|[Mm]ethod) (?:is|was|came)\b[^.]{0,80}?\b(?:from|in|of) "
                        r"(?P<who>" + NAME + r")'s (?:lab|analysis|work|research|notes)\b")),
    ("joint", re.compile(r"\b(?:[Jj]oint|[Cc]o-signed|[Ss]hared canon)\b[^.]{0,80}?(?P<who>" + NAME +
                         r") ?(?:and|&|\u2194|<->|/) ?(?P<who2>" + NAME + r")\b")),
]
LINEAGE_LINE = re.compile(r"^[Ll]ineage: *(?P<rest>.+)")
POSSESSIVE = re.compile(r"\b(" + NAME + r")'s\b")
NOTICE_LINE = re.compile(r"(?:^|(?<=[\s.;:,(\[]))(?:" + re.escape(CTAG) + r"|Copyright\b)\s*(?:\([Cc]\)|©)?\s*"
                         r"(?P<years>\d{4}(?:\s*[-–,]\s*\d{4})*),?\s+(?P<who>\S.*)$")
HINTS = {"lab": 3, "design": 3, "idea": 3, "doctrine": 3, "discipline": 3, "adapted": 3, "borrowed": 3, "co-signed": 3,
         "canon": 2, "based": 2, "answered": 2, "his own": 2, "came": 1, "from": 1}
IGNORE_ON, IGNORE_OFF = ("REUSE-IgnoreStart", "colophon-ignore-start"), ("REUSE-IgnoreEnd", "colophon-ignore-end")


def say(*a):
    print(*a)


def read_text(p):
    with open(p, "rb") as f:
        b = f.read()
    head = b[:8192].rstrip(b"\x00")
    if b"\x00" in head:
        return None, b
    try:
        return b.decode("utf-8"), b
    except UnicodeDecodeError:
        return None, b


def header_ids(text, lines=40):
    """SPDX identifiers declared in the file's first lines, outside REUSE-Ignore regions."""
    ids, skip = [], False
    for ln in text.splitlines()[:lines]:
        if "REUSE-IgnoreStart" in ln:
            skip = True
        if "REUSE-IgnoreEnd" in ln:
            skip = False
            continue
        if skip:
            continue
        m = re.search(re.escape(TAG) + r"\s*(.+?)\s*(\*/|-->|$)", ln)
        if m:
            ids.append(m.group(1).strip())
    return ids


def notice(text, lines=40):
    head = "\n".join(text.splitlines()[:lines])
    for name, pat in NOTICE_RE:
        if re.search(pat, head):
            return name
    return None


def split_ids(expr):
    return [t for t in re.split(r"[\s()]+", expr) if t and t.upper() not in ("OR", "AND", "WITH")]


def kind_of(rel):
    name = os.path.basename(rel)
    ext = os.path.splitext(name)[1].lower()
    if name == "SKILL.md":
        return "prose", None  # skills are minted: annotate, never edit their bytes
    if ext in ART_EXT:
        return "art", None
    if ext == ".svg":
        return "art", "<!--"
    if name in PROSE_NAMES:
        return "prose", None
    style = STYLE_BY_NAME.get(name) or STYLE_BY_EXT.get(ext)
    if ext in PROSE_EXT:
        return "prose", style
    return "code", style


def walk(root):
    for d, dirs, files in os.walk(root):
        dirs[:] = sorted(x for x in dirs if x not in SKIP_DIRS)
        for f in sorted(files):
            p = os.path.join(d, f)
            rel = os.path.relpath(p, root).replace(os.sep, "/")
            if rel == "REUSE.toml" or rel.endswith(".license") or LICENSE_FILE_RE.match(f):
                continue
            yield p, rel


def declared_by_hand(root):
    """(glob, expr) pairs from REUSE.toml annotations outside colophon's own block."""
    p = os.path.join(root, "REUSE.toml")
    if not os.path.exists(p):
        return []
    text = open(p, encoding="utf-8").read()
    if "# colophon: begin" in text:
        pre, rest = text.split("# colophon: begin", 1)
        text = pre + (rest.split("# colophon: end", 1)[1] if "# colophon: end" in rest else "")
    return toml_paths(root, text)


def clean(line):
    s = line.replace("**", "").replace("__", "")
    s = re.sub(r"^[\s#/*;%<!>|`'\"_~=+-]*(?:@?REM\s+)?(?:\.\.\s+)?", "", s)
    return re.sub(r"\s*(?:\*/|-->)\s*$", "", s).strip()


def holders_of(s):
    """The names in a copyright notice's holder text."""
    s = re.sub(r"\s*(?:\*/|-->)\s*$", "", s).strip()
    s = re.sub(r"(?i)\s+and\s+(?:other\s+)?contributors\b.*$", "", s)
    s = re.sub(r"\.\s+(?:All|This|Licensed|See|Released|Distributed|Permission)\b.*$", "", s)
    out = []
    for part in re.split(r",\s*|\s+and\s+|\s*;\s*", s):
        part = part.strip().rstrip(".")
        if part[:1].isupper():
            out.append(part)
    return out


def resolve(who):
    """A party key; "" for an agent, a tool or a bot (never an owner); None for a maker nobody has named."""
    w = who.strip().strip("`'\"*_,;:()")
    m = re.search(r"<([^>]+)>", w)
    email = m.group(1).strip().lower() if m else ""
    name = re.sub(r"\s*<[^>]*>.*$", "", w).strip().rstrip(".")
    if NOT_MAKERS.search(name) or (email and NOT_MAKERS.search(email)):
        return ""
    for k, p in PARTIES.items():
        if email and email in [e.lower() for e in p.get("emails", [])]:
            return k
        if name.lower() in [n.lower() for n in p.get("names", []) + p.get("agents", [])]:
            return k
    return None


ANCHORED = {"byline", "derived"}  # these read only at the start of a line; the rest read across a paragraph


def scan(text, kind):
    """Statements of provenance in a file, as (who, how, line, snippet). Code is read in its header, prose in full;
    a sentence may run across the lines of its paragraph."""
    rows, out, skip, para, start = text.splitlines(), [], False, [], [0]

    def flush():
        if para:
            joined = "\n".join(para)
            flat = joined.replace("\n", " ")
            for how, pat in EVIDENCE:
                if how in ANCHORED:
                    continue
                for m in pat.finditer(flat):
                    no = start[0] + joined[:m.start()].count("\n")
                    near = flat[max(0, m.start() - 20):m.end() + 40]
                    out.extend((m.group(g), how, no, near) for g in ("who", "who2") if m.groupdict().get(g))
            del para[:]

    for no, raw in enumerate(rows[: 60 if kind == "code" else len(rows)], 1):
        if any(m in raw for m in IGNORE_ON):
            skip = True
            flush()
        if any(m in raw for m in IGNORE_OFF):
            skip = False
            continue
        if skip:
            continue
        s = clean(raw)
        if not s:
            flush()
            continue
        m = NOTICE_LINE.search(s)
        if m:
            flush()
            if kind != "code" or no <= 40:
                out += [(w, "notice", no, s[:90]) for w in holders_of(m.group("who"))]
            continue
        if not para:
            start[0] = no
        para.append(s)
        for how, pat in EVIDENCE:
            if how in ANCHORED:
                for m in pat.finditer(s):
                    out += [(m.group(g), how, no, s[:90]) for g in ("who", "who2") if m.groupdict().get(g)]
        m = LINEAGE_LINE.match(s)
        if m:
            out += [(w, "lineage", no, s[:90]) for w in POSSESSIVE.findall(m.group("rest"))]
    flush()
    # Garden edition: a Credits, Acknowledgements or Thanks section is where the ladder's lower
    # rungs are written, so what it says of someone is credit, never a claim that they made the file.
    inside, credits_at = False, set()
    for no, raw in enumerate(rows, 1):
        h = re.match(r"^\s*(#{1,6}|\*{1,6})\s+(.*)$", raw)
        if h:
            inside = re.search(r"(?i)\b(credits?|acknowledge?ments?|thanks)\b", h.group(2)) is not None
            continue
        if inside:
            credits_at.add(no)
    return [(w, "credited" if no in credits_at and how != "notice" else how, no, snip) for w, how, no, snip in out]


def header_holders(text, lines=40):
    out, skip = [], False
    for ln in text.splitlines()[:lines]:
        if any(m in ln for m in IGNORE_ON):
            skip = True
        if any(m in ln for m in IGNORE_OFF):
            skip = False
            continue
        if not skip:
            m = NOTICE_LINE.search(clean(ln))
            if m:
                out += holders_of(m.group("who"))
    return out


def toml_holders(strings):
    out = []
    for s in strings:
        m = re.match(r"^\s*\d{4}(?:\s*[-–,]\s*\d{4})*,?\s+(.*)$", s)
        out += holders_of(m.group(1) if m else s)
    return out


def party_of_dir(name):
    m = re.search(r"from-([A-Za-z][\w-]*)", name, re.I)
    if not m:
        return None
    w = m.group(1).lower()
    for k, p in PARTIES.items():
        if w == k or w in [n.split()[0].lower() for n in p.get("names", [])]:
            return k
    return None


def parcel_index(root, extra=()):
    """sha256 and file name of every file in a parcel from a known maker: parcels/*from-NAME*/ inside or beside
    ROOT, plus --parcels DIR (or KEY=DIR)."""
    dirs = []
    for spec in extra:
        key, _, d = spec.partition("=") if ("=" in spec and not os.path.isdir(spec)) else ("", "", spec)
        dirs.append((key, d))
    for base in (root, os.path.dirname(os.path.abspath(root))):
        pd = os.path.join(base, "parcels")
        if os.path.isdir(pd):
            dirs += [("", os.path.join(pd, d)) for d in sorted(os.listdir(pd)) if "from-" in d.lower()]
    idx, used, seen = {"sha": {}, "name": {}}, [], set()
    for key, d in dirs:
        d = os.path.abspath(d)
        key = key or party_of_dir(os.path.basename(d))
        if d in seen or not os.path.isdir(d) or key not in PARTIES:
            continue
        seen.add(d)
        used.append((key, d))
        for p, _ in walk(d):
            try:
                b = open(p, "rb").read()
            except OSError:
                continue
            idx["sha"].setdefault(sha(b), (key, p))
            if len(b) < 200000:
                idx["name"].setdefault(os.path.basename(p), []).append((key, p))
    return idx, used


def git_index(root):
    """Who touched each file, from git history: {rel: {(name, email): {years}}}, and a note."""
    if not shutil.which("git"):
        return {}, "git: not installed"
    r = subprocess.run(["git", "-C", root, "rev-parse", "--show-toplevel"], capture_output=True, text=True)
    if r.returncode != 0:
        return {}, "git: not a repository"
    top = r.stdout.strip()
    r = subprocess.run(["git", "-C", top, "log", "--no-renames", "--date=format:%Y", "--numstat",
                        "--format=%x1e%an%x1f%ae%x1f%ad%x1f%b%x1f", "--", os.path.abspath(root)],
                       capture_output=True, text=True, errors="replace")
    if r.returncode != 0:
        return {}, "git: log failed"
    out, n = {}, 0
    for rec in r.stdout.split("\x1e")[1:]:
        parts = rec.split("\x1f")
        if len(parts) < 5:
            continue
        n += 1
        who = [(parts[0], parts[1])] + re.findall(r"(?im)^co-authored-by:\s*(.+?)\s*<([^>]+)>\s*$", parts[3])
        for line in parts[4].strip().splitlines():
            bits = line.split("\t")
            if len(bits) != 3 or bits[0] == "0":
                continue
            rel = os.path.relpath(os.path.join(top, bits[2]), root).replace(os.sep, "/")
            if rel.startswith(".."):
                continue
            for name, email in who:
                out.setdefault(rel, {}).setdefault((name.strip(), email.strip().lower()), set()).add(parts[2])
    return out, "git: %d commit(s) read" % n


def skill_dir_of(rel, dirs):
    d = os.path.dirname(rel)
    while True:
        if d in dirs:
            return d
        if not d:
            return None
        d = os.path.dirname(d)


def context(root, parcels=(), use_git=True):
    """What attribution needs about the whole tree, read once: skill-wide statements, parcels, git."""
    ctx = {"root": os.path.abspath(root), "skill_dirs": set(), "skill_ev": {}, "git": {}, "git_note": "git: not read"}
    for p, rel in walk(root):
        if os.path.basename(rel) == "SKILL.md":
            d = os.path.dirname(rel)
            ctx["skill_dirs"].add(d)
            text, _ = read_text(p)
            if text is not None:
                ctx["skill_ev"][d] = [(w, how, "%s:%d" % (rel, no), snip) for w, how, no, snip in scan(text, "prose")]
    ctx["parcels"], ctx["parcel_dirs"] = parcel_index(root, parcels)
    if use_git:
        ctx["git"], ctx["git_note"] = git_index(root)
    return ctx


CREDIT_FILES = re.compile(r"^(README|CREDITS|AUTHORS|ACKNOWLEDGE?MENTS|THANKS|NOTICE|FROM)", re.I)


def add_sources(ctx, root, specs):
    """--sources KEY=DIR[@DATE]: the lines of the work first seen in each party's own sources (at1ld,
    beside this script). More than 15 in a file attributes that party (rung 1); 4 to 15 credits them."""
    ctx["lines"], ctx["lines_note"] = {}, "sources: none given (rung 1 read from statements only)"
    if not specs:
        return
    sys.path.insert(0, HERE)
    import at1ld
    corpora, keys = [], []
    for spec in specs:
        key, _, where = spec.partition("=")
        if key not in PARTIES or not where:
            raise ValueError("%r: KEY must be a party in the parties file, then =DIR[@DATE]" % spec)
        party = PARTIES[key]
        who = party["names"][0] + (" <%s>" % party["emails"][0] if party.get("emails") else "")
        corpora.append(at1ld.load_corpus(who + "=" + where))
        keys.append(key)
    counts, contested = at1ld.count_work(root, corpora)
    agg = {}
    for (i, rel), n in counts.items():   # several sources for one party add up
        agg[(keys[i], rel)] = agg.get((keys[i], rel), 0) + n
    for (key, rel), n in sorted(agg.items()):
        ctx["lines"].setdefault(rel, []).append((key, n))
    ctx["contested"] = contested
    ctx["lines_note"] = "sources: %s (first seen decides; same-day lines count for no one)" % ", ".join(keys)
    if KEEPER not in keys:
        ctx["lines_note"] += "; the keeper's own sources not given, so a line both hold counts for the other"


def credits_text(root):
    out = []
    for p, rel in walk(root):
        if "/" not in rel and CREDIT_FILES.match(os.path.basename(rel)):
            out.append(read_text(p)[0] or "")
    return "\n".join(out)


def credited(text, key):
    return any(re.search(r"\b" + re.escape(n) + r"\b", text) for n in PARTIES[key]["names"] if len(n) > 2)


def attribution(rel, text, raw, kind, ctx):
    """Who made this file, on what evidence: owners (the keeper first), evidence, makers nobody has named."""
    rp = lambda p: os.path.relpath(p, ctx["root"]).replace(os.sep, "/")
    hit = ctx["parcels"]["sha"].get(sha(raw)) if raw is not None else None
    if hit:
        return {"owners": [hit[0]], "evidence": [(hit[0], "parcel", rp(hit[1]), "an unchanged copy")],
                "unknown": [], "foreign": False, "sole": True, "years": {}}
    found = []
    sd = skill_dir_of(rel, ctx["skill_dirs"])
    if sd is not None and os.path.basename(rel) != "SKILL.md":
        # Garden edition: a copyright notice speaks for its own file. What a SKILL.md says of the
        # whole skill (derived from, a byline, a lineage) still reaches every file of it.
        found += [e for e in ctx["skill_ev"].get(sd, []) if e[1] != "notice"]
    if text is not None:
        found += [(w, how, "%s:%d" % (rel, no), snip) for w, how, no, snip in scan(text, kind)]
        mine = text.splitlines()
        for party, src in ctx["parcels"]["name"].get(os.path.basename(rel), []):
            theirs = (read_text(src)[0] or "").splitlines()
            if min(len(mine), len(theirs)) >= 10 and \
                    difflib.SequenceMatcher(None, mine, theirs, autojunk=False).ratio() >= 0.6:
                found.append(("@" + party, "similar", rp(src), "an edited copy"))
    for (name, email), ys in sorted(ctx["git"].get(rel, {}).items()):
        found.append(("%s <%s>" % (name, email), "git", ",".join(sorted(ys)), "commits"))
    for key, n in ctx.get("lines", {}).get(rel, []):   # garden edition: the ladder's rung 1, by count
        if n > LADDER_LINES:
            found.append(("@" + key, "lines", "%d lines" % n, "first seen in their own sources"))
        elif n >= 4:
            found.append(("@" + key, "quote", "%d lines" % n, "first seen in their own sources"))
    evidence, unknown, years, noticed, notices = [], [], {}, set(), 0
    credit = []
    for who, how, where, snip in found:
        key = who[1:] if who.startswith("@") else resolve(who)
        if how == "notice":
            notices += 1
            if key:
                noticed.add(key)
        if key == "":
            continue
        if key is None:
            if how != "notice":
                unknown.append((who, how, where))
            continue
        if how == "git":
            years.setdefault(key, set()).update(where.split(","))
        if POLICY.get(how, "owner") == "owner":
            evidence.append((key, how, where, snip))
        elif key != KEEPER:
            credit.append((key, how, where, snip))
    foreign = notices > 0 and KEEPER not in noticed
    owners = []
    for k in ([] if foreign else [KEEPER]) + [e[0] for e in evidence]:
        if k not in owners:
            owners.append(k)
    credit = [c for c in credit if c[0] not in owners]
    return {"owners": owners, "evidence": evidence, "unknown": unknown, "foreign": foreign, "sole": False,
            "years": years, "credit": credit}


def offer(owners, kind):
    """The license expression every owner offers for this kind of file, or (None, why)."""
    if not owners:
        return None, "no maker found"
    common = None
    for k in owners:
        terms = PARTIES[k].get("terms", {}).get(kind)
        if not terms:
            return None, "%s has declared no terms for %s; the keeper asks" % (PARTIES[k]["names"][0], kind)
        common = list(terms) if common is None else [t for t in common if t in terms]
    if not common:
        return None, "no license every maker offers; the keeper asks"
    return " OR ".join(common), None


def yrs(years, year):
    if not years:
        return year
    ys = sorted(years)
    return ys[0] if ys[0] == ys[-1] else ys[0] + "-" + ys[-1]


def holder_lines(owners, year, joint=(), years=None):
    years = years or {}
    return [yrs(years.get(k), year) + " " + PARTIES[k]["line"] for k in owners] + [year + " " + j for j in joint]


def named(declared, key):
    return any(resolve(h) == key for h in declared)


def alternatives(expr):
    out = []
    for e in expr.split(" ; "):
        out += [a.strip("() ") for a in re.split(r"\s+OR\s+", e)]
    return out


def attrib_text(text, owners, ident, year, years, set_terms):
    """Add missing makers' lines under a header's last copyright line; narrow its terms when set_terms."""
    nl = "\r\n" if "\r\n" in text[:4096] else "\n"
    rows = text.split(nl)
    cl = [i for i, r in enumerate(rows[:40]) if CTAG in r]
    if not cl:
        return text
    have = header_holders(text)
    tpl = rows[cl[-1]]
    pre = tpl[:tpl.index(CTAG)]
    m = re.search(r"\s*(?:\*/|-->)\s*$", tpl)
    post = m.group(0) if m else ""
    add = [pre + CTAG + " " + line + post for k, line in zip(owners, holder_lines(owners, year, (), years))
           if not named(have, k)]
    rows[cl[-1] + 1:cl[-1] + 1] = add
    if set_terms:
        for i, r in enumerate(rows[:40 + len(add)]):
            if TAG in r:
                rows[i] = r[:r.index(TAG)] + TAG + " " + ident + (post if post and r.rstrip().endswith(post.strip()) else "")
                break
    return nl.join(rows)


def load_parties(root, path=None):
    p = path or os.path.join(root, ".colophon-parties.json")
    if not os.path.exists(p):
        if path:
            raise ValueError("no such file: " + path)
        return None
    data = json.load(open(p, encoding="utf-8"))
    global KEEPER
    if isinstance(data.get("_policy"), dict):
        POLICY.update({k: v for k, v in data["_policy"].items() if v in ("owner", "credit")})
    if isinstance(data.get("_keeper"), str):
        KEEPER = data["_keeper"]
    for k, v in data.items():
        if k.startswith("_"):
            continue
        if not isinstance(v, dict) or not v.get("names"):
            raise ValueError("party %r needs a list of names" % k)
        v.setdefault("emails", [])
        v.setdefault("agents", [])
        v.setdefault("terms", {})
        v.setdefault("line", v["names"][0] + (" <%s>" % v["emails"][0] if v["emails"] else ""))
        v.setdefault("said", "the parties file")
        PARTIES[k] = v
        if v.get("keeper") is True:
            KEEPER = k
    return p


def use_keeper():
    """Set HOLDER, CODE and PROSE from the keeper's own entry; (ok, why)."""
    global HOLDER, CODE, PROSE
    if not KEEPER or KEEPER not in PARTIES:
        return False, ("no keeper: name one in .colophon-parties.json (\"_keeper\": KEY); colophon carries "
                       "no one's terms of its own")
    t = PARTIES[KEEPER].get("terms", {})
    if not t.get("code") or not t.get("prose"):
        return False, "the keeper %r has not declared terms for both code and prose" % KEEPER
    HOLDER = PARTIES[KEEPER]["line"]
    CODE, PROSE = " OR ".join(t["code"]), " OR ".join(t["prose"])
    return True, ""


def classify(root, toml_only=False, art_is_ours=False, ctx=None):
    ctx = ctx if ctx is not None else context(root)
    plan, by_hand, std = [], declared_by_hand(root), {CODE, PROSE}
    for p, rel in walk(root):
        hand = covered(rel, by_hand)
        kind, style = kind_of(rel)
        text, raw = read_text(p)
        at = attribution(rel, text, raw, kind, ctx)
        if hand:
            plan.append(("HAS", rel, hand["expr"], None, "declared in REUSE.toml by hand", at))
            continue
        if SECRET_RE.search(rel) and not rel.endswith(".example"):
            plan.append(("SECRET", rel, None, None, "must not ship; never stamped", at))
            continue
        ids = header_ids(text) if text is not None else []
        if ids and at["foreign"]:
            plan.append(("FOREIGN", rel, " ; ".join(ids), None, compat(ids, kind), at))
            continue
        n = notice(text) if text is not None and not ids else None
        if n:
            plan.append(("FOREIGN", rel, n, None, "undeclared: write its terms down by hand (REUSE.toml or .license)", at))
            continue
        if at["unknown"]:
            plan.append(("ASK", rel, None, None, "unknown maker %s (%s at %s): who, and on what terms?" % at["unknown"][0], at))
            continue
        ident, why = offer(at["owners"], kind)
        if ident is None:
            plan.append(("ASK", rel, None, None, why, at))
            continue
        if at["sole"]:
            plan.append(("TOML", rel, ident, None, "their file, unchanged: their copyright, their terms", at))
            continue
        if ids:
            have, expr = header_holders(text), " ; ".join(ids)
            if not named(have, KEEPER):
                plan.append(("FOREIGN", rel, expr, None, compat(ids, kind), at))
                continue
            settable = expr in std or expr == ident
            if not settable and any(a not in PARTIES[k]["terms"].get(kind, []) for a in alternatives(expr)
                                    for k in at["owners"] if k != KEEPER):
                plan.append(("ASK", rel, expr, None, "its terms are not all offered by every maker; the keeper asks", at))
                continue
            missing = [PARTIES[k]["names"][0] for k in at["owners"] if not named(have, k)]
            change = settable and expr != ident
            if missing or change:
                note = "; ".join(x for x in ("name " + ", ".join(missing) if missing else "",
                                             "terms " + expr + " -> " + ident if change else "") if x)
                plan.append(("ATTRIB", rel, ident if settable else expr, style, note, at))
            else:
                plan.append(("HAS", rel, expr, None, "", at))
            continue
        if kind == "art" and style and not art_is_ours:
            plan.append(("ASK", rel, ident, None, "art: whose is it?", at))
            continue
        if text is None:
            if kind == "art" and art_is_ours:
                plan.append(("TOML", rel, ident, None, "art, ours by the keeper's word", at))
            elif kind == "art":
                plan.append(("ASK", rel, ident, None, "art or binary: whose is it?", at))
            else:
                plan.append(("TOML", rel, ident, None, "binary", at))
            continue
        if toml_only or style is None or name_is_skill(rel):
            plan.append(("TOML", rel, ident, None, kind, at))
        else:
            plan.append(("STAMP", rel, ident, style, kind, at))
    return plan


def name_is_skill(rel):
    return os.path.basename(rel) == "SKILL.md"


def compat(ids, kind):
    verdicts = []
    for expr in ids:
        for i in split_ids(expr):
            if HOLD_PAT.search(i):
                verdicts.append("HOLD " + i + ": cannot ship inside this garden's terms; the keeper decides")
            elif kind == "code" and i in OK_CODE:
                verdicts.append("ok " + i)
            elif kind == "code" and i in NOTE_CODE:
                verdicts.append("note " + i + ": " + NOTE_CODE[i])
            elif i in OK_PROSE or i in (PROSE,) or i in split_ids(CODE):
                verdicts.append("ok " + i)
            else:
                verdicts.append("check by hand " + i)
    return "; ".join(verdicts)


def comment_lines(style, lines):
    if style in ("/*",):
        return ["/* " + l + " */" for l in lines]
    if style == "<!--":
        return ["<!-- " + l + " -->" for l in lines]
    if style == "REM":
        return ["@REM " + l for l in lines]
    if style == "..":
        return [".. " + l for l in lines]
    if style == "# ":
        return ["# " + l for l in lines]
    return [style + " " + l for l in lines]


def stamp_text(text, rel, style, lines):
    nl = "\r\n" if "\r\n" in text[:4096] else "\n"
    bom = ""
    if text.startswith("﻿"):
        bom, text = "﻿", text[1:]
    rows = text.split(nl)
    ext = os.path.splitext(rel)[1].lower()
    at = 0
    if rows and rows[0].startswith("#!"):
        at = 1
        if len(rows) > 1 and re.match(r"^#.*coding[:=]", rows[1]):
            at = 2
    elif ext == ".php":
        if rows and rows[0].lstrip().startswith("<?php"):
            at = 1
        else:
            block = ["<?php"] + ["// " + l for l in lines] + ["?>"]
            return bom + nl.join(block) + nl + text
    elif style == "<!--" and rows and re.match(r"(?i)^\s*(<!doctype|<\?xml)", rows[0]):
        at = 1
    elif style == "REM" and rows and rows[0].strip().lower().startswith("@echo off"):
        at = 1
    elif ext in (".md", ".markdown") and rows and rows[0].strip() == "---":
        for k in range(1, len(rows)):
            if rows[k].strip() == "---":
                at = k + 1
                break
    new = rows[:at] + comment_lines(style, lines) + rows[at:]
    return bom + nl.join(new)


def header_payload(ident, year, joint, owners=None, years=None):
    return [CTAG + " " + h for h in holder_lines(owners or [KEEPER], year, joint, years)] + [TAG + " " + ident]


def toml_block(entries, year, joint, precedence):
    out = ["# colophon: begin (written by colophon.py " + VERSION + "; change the terms in colophon, not here)"]
    groups = {}
    for rel, ident, owners, years in entries:
        groups.setdefault((ident, tuple(holder_lines(owners, year, joint, years))), []).append(rel)
    order = lambda kv: (len(kv[0][1]), {CODE: 0, PROSE: 1}.get(kv[0][0], 2), kv[0])
    for (ident, holders), paths in sorted(groups.items(), key=order):
        out.append("[[annotations]]")
        out.append("path = [")
        out += ['  "' + p.replace("\\", "\\\\").replace('"', '\\"').replace("*", "\\\\*") + '",' for p in sorted(paths)]
        out.append("]")
        out.append('precedence = "' + precedence + '"')
        out.append("SPDX-FileCopyrightText = [" + ", ".join('"' + h.replace('"', '\\"') + '"' for h in holders) + "]")
        out.append('SPDX-License-Identifier = "' + ident + '"')
        out.append("")
    out.append("# colophon: end")
    return "\n".join(out) + "\n"


def write_toml(root, block):
    p = os.path.join(root, "REUSE.toml")
    old = open(p, encoding="utf-8").read() if os.path.exists(p) else ""
    if "# colophon: begin" in old:
        pre, rest = old.split("# colophon: begin", 1)
        post = rest.split("# colophon: end", 1)[1] if "# colophon: end" in rest else ""
        new = pre + block + post.lstrip("\n")
    elif old:
        new = old.rstrip("\n") + "\n\n" + block
    else:
        new = "version = 1\n\n" + block
    if new != old:
        with open(p, "w", encoding="utf-8", newline="\n") as f:
            f.write(new)
        return True
    return False


def sha(b):
    return hashlib.sha256(b).hexdigest()


def get_text(ident):
    """The pinned text: the skill's own copy, else the steward's URL. None if neither matches its pin."""
    url, pin = TEXTS[ident]
    local = os.path.join(HERE, "LICENSES", ident + ".txt")
    if os.path.exists(local):
        b = open(local, "rb").read()
        if sha(b) == pin:
            return b, "skill copy"
    if not FETCH:
        say("  NOT CHECKED " + ident + ": no pinned copy beside the skill, and --fetch was not given")
        return None, None
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "colophon/" + VERSION})
        b = urllib.request.urlopen(req, timeout=30).read()
        if sha(b) == pin:
            return b, url
        say("  PIN MISMATCH " + ident + " from " + url + ": the steward may have reformatted; compare by hand")
    except Exception as e:
        say("  NOT CHECKED fetch " + ident + ": " + str(e)[:80])
    return None, None


def write_texts(dest, idents):
    ok = True
    os.makedirs(os.path.join(dest, "LICENSES"), exist_ok=True)
    for ident in idents:
        p = os.path.join(dest, "LICENSES", ident + ".txt")
        if os.path.exists(p) and sha(open(p, "rb").read()) == TEXTS[ident][1]:
            continue
        b, src = get_text(ident)
        if b is None:
            ok = False
            continue
        with open(p, "wb") as f:
            f.write(b)
        say("  TEXT     LICENSES/" + ident + ".txt (" + src + ")")
    return ok


def used_ids(plan):
    ids = set()
    for act, rel, ident, style, note, at in plan:
        if act in ("STAMP", "TOML", "ATTRIB") and ident:
            ids.update(split_ids(ident))
    return ids


def cmd_plan(root, joint, toml_only, art, ctx=None):
    plan = classify(root, toml_only, art, ctx)
    for act, rel, ident, style, note, at in plan:
        makers = [PARTIES[k]["names"][0] for k in at["owners"]]
        say("  %-8s %s%s%s%s" % (act, rel, ("  [" + ident + "]") if ident else "", ("  " + note) if note else "",
                                ("  makers: " + ", ".join(makers)) if at["owners"] != [KEEPER] and makers else ""))
        for k in sorted({c[0] for c in at.get("credit", [])}):
            c = next(x for x in at["credit"] if x[0] == k)
            say("  CREDIT   %s  %s (%s at %s): name them in the credits, not in the copyright" % (
                rel, PARTIES[k]["names"][0], c[1], c[2]))
    have = set(os.listdir(os.path.join(root, "LICENSES"))) if os.path.isdir(os.path.join(root, "LICENSES")) else set()
    need = sorted(i for i in used_ids(plan) if i + ".txt" not in have)
    say("plan: %d file(s): %s; license texts to add: %s" % (len(plan), counts(plan), ", ".join(need) or "none"))
    return plan


def counts(plan):
    c = {}
    for p in plan:
        c[p[0]] = c.get(p[0], 0) + 1
    return ", ".join("%d %s" % (v, k) for k, v in sorted(c.items()))


def cmd_apply(root, joint, toml_only, art, year, ctx=None):
    plan = classify(root, toml_only, art, ctx)
    changed, named_n, toml_entries = 0, 0, []
    for act, rel, ident, style, note, at in plan:
        p = os.path.join(root, rel)
        if act == "STAMP":
            text, _ = read_text(p)
            new = stamp_text(text, rel, style, header_payload(ident, year, joint, at["owners"], at["years"]))
            with open(p, "wb") as f:
                f.write(new.encode("utf-8"))
            changed += 1
            say("  STAMPED  " + rel)
        elif act == "ATTRIB" and not toml_only:
            text, _ = read_text(p)
            new = attrib_text(text, at["owners"], ident, year, at["years"], ident != " ; ".join(header_ids(text)))
            if new != text:
                with open(p, "wb") as f:
                    f.write(new.encode("utf-8"))
                named_n += 1
                say("  NAMED    %s  (%s)" % (rel, note))
        elif act in ("TOML", "ATTRIB"):
            toml_entries.append((rel, ident, at["owners"], at["years"]))
        elif act in ("SECRET", "ASK", "FOREIGN"):
            say("  LEFT     %s  (%s)" % (rel, act.lower() + ((": " + note) if note else "")))
    prec = "override" if toml_only else "closest"
    if toml_entries and write_toml(root, toml_block(toml_entries, year, joint, prec)):
        say("  WROTE    REUSE.toml (%d path(s))" % len(toml_entries))
    ok = write_texts(root, sorted(i for i in used_ids(plan) | ids_in_toml(root) if i in TEXTS))
    say("apply: %d stamped, %d named, %d declared in REUSE.toml; texts %s" % (
        changed, named_n, len(toml_entries), "ok" if ok else "NOT CHECKED"))
    return 0 if ok else 2


def ids_in_toml(root):
    p = os.path.join(root, "REUSE.toml")
    if not os.path.exists(p):
        return set()
    ids = set()
    for m in re.finditer(r'SPDX-License-Identifier\s*=\s*"([^"]+)"', open(p, encoding="utf-8").read()):
        ids.update(split_ids(m.group(1)))
    return ids


def toml_paths(root, text=None):
    """REUSE.toml annotations as dicts (glob, expr, copy, precedence), read without a TOML library (the shapes
    colophon writes, plus single-string paths)."""
    if text is None:
        p = os.path.join(root, "REUSE.toml")
        if not os.path.exists(p):
            return []
        text = open(p, encoding="utf-8").read()
    out = []
    for blk in text.split("[[annotations]]")[1:]:
        m = re.search(r'SPDX-License-Identifier\s*=\s*"([^"]+)"', blk)
        pm = re.search(r"path\s*=\s*(\[.*?\]|\"[^\"]*\")", blk, re.S)
        if not m or not pm:
            continue
        cm = re.search(r'SPDX-FileCopyrightText\s*=\s*(\[.*?\]|"(?:[^"\\]|\\.)*")', blk, re.S)
        copy = [c.replace('\\"', '"') for c in re.findall(r'"((?:[^"\\]|\\.)*)"', cm.group(1))] if cm else []
        prec = re.search(r'precedence\s*=\s*"([^"]+)"', blk)
        for g in re.findall(r'"((?:[^"\\]|\\.)*)"', pm.group(1)):
            out.append({"glob": g.replace("\\\\*", "*").replace('\\"', '"').replace("\\\\", "\\"), "expr": m.group(1),
                        "copy": copy, "precedence": prec.group(1) if prec else "closest"})
    return out


def covered(rel, globs):
    for g in globs:
        if rel == g["glob"] or fnmatch.fnmatchcase(rel, g["glob"].replace("**/", "*").replace("**", "*")):
            return g
    return None


def cmd_check(root, ctx=None, one_reader=False):
    if not os.path.isdir(root):
        say("NOT CHECKED: cannot read " + root)
        return 2
    ctx = ctx if ctx is not None else context(root)
    bad, globs, used = 0, toml_paths(root), set()
    creds, uncredited = credits_text(root), {}
    for p, rel in walk(root):
        if SECRET_RE.search(rel) and not rel.endswith(".example"):
            say("  REFUSED  " + rel + "  (secret-shaped: it must not ship)")
            bad += 1
            continue
        text, raw = read_text(p)
        ids = header_ids(text) if text is not None else []
        hit = covered(rel, globs)
        from_header = bool(ids) and not (hit and hit["precedence"] == "override")
        if from_header:
            expr, declared = " ; ".join(ids), header_holders(text)
        elif hit:
            expr, declared = hit["expr"], toml_holders(hit["copy"])
        else:
            expr, declared = None, []
        if not expr and os.path.exists(p + ".license"):
            side = open(p + ".license", encoding="utf-8").read()
            expr, declared = " ; ".join(header_ids(side)) or None, header_holders(side)
        if not expr:
            n = notice(text) if text is not None else None
            say("  GAP      " + rel + ("  (" + n + ", undeclared)" if n else "  (no license declared)"))
            bad += 1
            continue
        if from_header and not has_copyright(text):
            say("  GAP      " + rel + "  (license declared, no copyright line)")
            bad += 1
            continue
        kind = kind_of(rel)[0]
        for e in expr.split(" ; "):
            used.update(split_ids(e))
            v = compat([e], "code" if kind == "code" else "prose")
            if "HOLD" in v:
                say("  HOLD     " + rel + "  " + v)
                bad += 1
        at = attribution(rel, text, raw, kind, ctx)
        if at["foreign"] and from_header:
            continue  # someone else's notice: theirs to write
        for who, how, where in at["unknown"]:
            say("  ASK      %s  unknown maker %s (%s at %s): who, and on what terms?" % (rel, who, how, where))
            bad += 1
        for k in at["owners"]:
            if k != KEEPER and not named(declared, k):
                e = next((x for x in at["evidence"] if x[0] == k), ("", "?", "", ""))
                say("  UNNAMED  %s  %s made part of it (%s, %s) but is not named in its copyright" % (
                    rel, PARTIES[k]["names"][0], e[1], e[2]))
                bad += 1
        for alt in alternatives(expr):
            for k in at["owners"]:
                if k != KEEPER and alt not in PARTIES[k].get("terms", {}).get(kind, []):
                    say("  TERMS    %s  offers %s, which %s has not offered" % (rel, alt, PARTIES[k]["names"][0]))
                    bad += 1
        for k, how, where, snip in at.get("credit", []):
            if not credited(creds, k):
                uncredited.setdefault(k, []).append("%s (%s at %s)" % (rel, how, where))
    lic = os.path.join(root, "LICENSES")
    for i in sorted(used):
        f = os.path.join(lic, i + ".txt")
        if not os.path.exists(f):
            say("  MISSING  LICENSES/" + i + ".txt")
            bad += 1
        elif i in TEXTS and sha(open(f, "rb").read()) != TEXTS[i][1]:
            say("  DIFFERS  LICENSES/" + i + ".txt is not the pinned steward copy; compare by hand")
            bad += 1
    for k, where in sorted(uncredited.items()):
        say("  UNCREDITED %s shaped %d file(s) (first: %s), and the credits (README, CREDITS, AUTHORS, "
            "ACKNOWLEDGEMENTS, THANKS, NOTICE or FROM at the top) do not name them" % (
                PARTIES[k]["names"][0], len(where), where[0]))
        bad += 1
    second, detail = second_reader(root)
    if second == "fail" and bad == 0:
        say("  DISAGREE colophon reads clean, reuse lint does not: a finding either way")
        for d in detail[:8]:
            say("           reuse: " + d)
        bad += 1
    if second == "pass" and bad:
        say("  DISAGREE reuse lint passes what colophon flagged: read both")
    say("check: %s; second reader (reuse lint): %s; %s" % ("clean" if bad == 0 else "%d finding(s)" % bad, second,
                                                             ctx.get("lines_note", "sources: none given")))
    if bad:
        return 1
    if second not in ("pass", "fail") and not one_reader:
        say("check: NOT CHECKED as a whole: one reader read it clean and the second could not run; "
            "--one-reader says the keeper accepts one")
        return 2
    return 0


def cmd_who(root, ctx, as_json=False):
    """Every maker of every file, on evidence; the files only the keeper made are counted, not listed."""
    rows, tally, gaps, credits = [], {}, 0, {}
    for p, rel in walk(root):
        kind = kind_of(rel)[0]
        text, raw = read_text(p)
        at = attribution(rel, text, raw, kind, ctx)
        for k, how, where, snip in at.get("credit", []):
            credits.setdefault(PARTIES[k]["names"][0], []).append({"file": rel, "how": how, "where": where})
        for k in at["owners"]:
            tally[k] = tally.get(k, 0) + 1
        notes = []
        if text is not None and not at["sole"]:
            for k, party in PARTIES.items():
                if k != KEEPER and k not in at["owners"]:
                    c = len(re.findall(r"\b" + re.escape(min(party["names"], key=len)) + r"\b", text))
                    if c >= 5:
                        hint = max(((sum(w for k, w in HINTS.items() if re.search(r"(?i)\b" + k + r"\b", x)), -i,
                                      "line %d: %s" % (i, clean(x)[:110])) for i, x in enumerate(text.splitlines(), 1)
                                     if re.search(r"\b" + re.escape(min(party["names"], key=len)) + r"\b", x)),
                                    default=(0, 0, ""))
                        hint = hint[2] if hint[0] else ""
                        notes.append("names %s %d times, with no line saying what they made%s; if they made part of "
                                     "it, say so in a 'Lineage:' line" % (party["names"][0], c,
                                                                          (" (closest: " + hint + ")") if hint else ""))
        if at["owners"] == [KEEPER] and not at["unknown"] and not notes:
            continue
        ident, why = offer(at["owners"], kind) if at["owners"] else (None, "")
        rows.append({"file": rel, "makers": [PARTIES[k]["names"][0] for k in at["owners"]], "license": ident,
                     "hold": why or "", "theirs": at["sole"] or at["foreign"],
                     "evidence": [{"maker": PARTIES[k]["names"][0], "how": how, "where": where, "text": snip}
                                  for k, how, where, snip in at["evidence"]],
                     "unknown": [{"who": w, "how": h, "where": x} for w, h, x in at["unknown"]], "notes": notes})
        gaps += bool(at["unknown"] or why)
    summary = {PARTIES[k]["names"][0]: n for k, n in sorted(tally.items(), key=lambda kv: (kv[0] != KEEPER, kv[0]))}
    parcels = [[PARTIES[k]["names"][0], os.path.relpath(d, ctx["root"]).replace(os.sep, "/")] for k, d in ctx["parcel_dirs"]]
    if as_json:
        print(json.dumps({"root": root, "files": rows, "files_by_maker": summary, "git": ctx["git_note"],
                          "parcels": parcels, "policy": "the attribution ladder: words and code in the work make "
                          "co-owners (rung 1); ideas, disciplines and lineage are credited (rung 2); co-made work "
                          "carries the terms every maker offers", "credit": credits}, indent=1))
        return 1 if gaps else 0
    keeper = PARTIES[KEEPER]["names"][0]
    for r in rows:
        if r["unknown"]:
            u = r["unknown"][0]
            say("  ASK      %s  unknown maker %s (%s at %s): who, and on what terms?" % (r["file"], u["who"], u["how"],
                                                                                         u["where"]))
        elif len(r["makers"]) > 1 or r["theirs"]:
            say("  %-8s %s  %s  [%s]" % ("THEIRS" if r["theirs"] else "MAKERS", r["file"], ", ".join(r["makers"]),
                                      r["license"] or "HOLD: " + r["hold"]))
            e = next((x for x in r["evidence"] if x["maker"] != keeper), None)
            if e:
                say("           %s, %s%s" % (e["how"], e["where"], ('  "' + e["text"] + '"') if e["text"] else ""))
        for nt in r["notes"]:
            say("  NOTE     %s  %s" % (r["file"], nt))
    for name, items in sorted(credits.items()):
        say("  CREDIT   %s shaped %d file(s): %s" % (name, len(items), ", ".join(
            sorted({i["file"].split("/")[1] if i["file"].startswith("skills/") else i["file"] for i in items}))[:300]))
    say("who: %s; %s; parcels: %s" % (", ".join("%s %d file(s)" % kv for kv in summary.items()), ctx["git_note"],
                                      ", ".join("%s (%s)" % (d, k) for k, d in parcels) or "none"))
    return 1 if gaps else 0


def has_copyright(text, lines=40):
    head = "\n".join(text.splitlines()[:lines])
    return CTAG in head or re.search(r"(?i)copyright|\u00a9", head) is not None


def second_reader(root):
    exe = shutil.which("reuse")
    if not exe:
        return "NOT CHECKED (pip install reuse)", []
    r = subprocess.run([exe, "--root", root, "lint"], capture_output=True, text=True)
    if r.returncode == 0:
        return "pass", []
    detail = [l.strip("* ").strip() for l in r.stdout.splitlines() if l.startswith("* ") and ("/" in l or "." in l.split(":")[0])]
    return "fail", [d for d in detail if " " not in d]


# ---------------------------------------------------------------- self-test
def selftest(prove_red=False):
    # Garden edition: the parties are read from references/parties.example.json (beside this skill),
    # the declaration a keeper copies; the code carries none. Without it the selftest is NOT CHECKED.
    ex = os.path.join(HERE, "..", "references", "parties.example.json")
    if not os.path.exists(ex):
        say("NOT CHECKED: selftest needs references/parties.example.json beside this skill")
        return 2
    load_parties(None, ex)
    ok_k, why = use_keeper()
    if not ok_k:
        say("NOT CHECKED: " + why)
        return 2
    year, n = "2026", [0]
    t = tempfile.mkdtemp(prefix="colophon-")

    def put(rel, s, mode="w"):
        p = os.path.join(t, rel)
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, "wb") as f:
            f.write(s if isinstance(s, bytes) else s.encode("utf-8"))

    def ok(cond, what):
        if not cond:
            say("FAIL " + what)
            raise SystemExit(1)
        n[0] += 1

    put("a.sh", "#!/bin/sh\necho hi\n")
    put("b.py", "#!/usr/bin/env python3\n# -*- coding: utf-8 -*-\nprint(1)\n")
    put("c.php", "<?php\necho 1;\n")
    put("d.php", "<html><?php echo 1; ?></html>\n")
    put("e.html", "<!doctype html>\n<p>x</p>\n")
    put("f.md", "---\ntitle: t\n---\n# F\n")
    put("g.org", "#+TITLE: g\n* g\n")
    put("h.el", "(message \"h\")\n")
    put("i.json", "{}\n")
    put("skill/SKILL.md", "---\nname: s\ndescription: d\n---\n# S\n")
    put("vendor/mit.js", "// " + CTAG + " 2020 Someone Else\n// " + TAG + " MIT\nvar a;\n")
    put("vendor/legacy.js", "/* Permission is hereby granted, free of charge, to any person */\nvar b;\n")
    put("crlf.bat", "@echo off\r\necho hi\r\n")
    put("WIRE-SECRETS.md", "code: not-a-real-one\n")
    put("logo.png", b"\x89PNG\r\n\x1a\n\x00\x00binary")
    plan = {r: a for a, r, *_ in classify(t)}
    ok(plan["a.sh"] == "STAMP" and plan["skill/SKILL.md"] == "TOML", "classify: code stamps, SKILL.md is declared, not edited")
    ok(plan["vendor/mit.js"] == "FOREIGN" and plan["vendor/legacy.js"] == "FOREIGN", "classify: someone else's notice is foreign")
    ok(plan["WIRE-SECRETS.md"] == "SECRET" and plan["logo.png"] == "ASK", "classify: a secret is refused, art asks whose")
    quiet(lambda: cmd_apply(t, [], False, False, year))
    rd = lambda r: open(os.path.join(t, r), "rb").read().decode("utf-8")
    ok(rd("a.sh").startswith("#!/bin/sh\n# " + CTAG), "a shebang stays first")
    ok(rd("crlf.bat").startswith("@echo off\r\n@REM " + CTAG), "batch: after @echo off, silent @REM, CRLF kept")
    ok(rd("b.py").split("\n")[2].startswith("# " + CTAG), "a coding line stays second")
    ok(rd("c.php").startswith("<?php\n// " + CTAG), "php: after the opening tag")
    ok(rd("d.php").startswith("<?php\n// " + CTAG) and "?>\n<html>" in rd("d.php"), "php that opens with html gets its own block")
    ok(rd("e.html").startswith("<!doctype html>\n<!-- " + CTAG), "html: after the doctype")
    ok(rd("f.md").startswith("---\ntitle: t\n---\n<!-- " + CTAG) and PROSE in rd("f.md"), "markdown: after the frontmatter, prose terms")
    ok(rd("h.el").startswith(";; " + CTAG), "elisp: ;; comments")
    ok(rd("skill/SKILL.md") == "---\nname: s\ndescription: d\n---\n# S\n", "SKILL.md bytes untouched")
    ok(rd("vendor/mit.js").startswith("// " + CTAG + " 2020 Someone Else"), "a foreign notice stands")
    ok("WIRE-SECRETS.md" not in open(os.path.join(t, "REUSE.toml")).read(), "a secret is never declared")
    before = {r: rd(r) for _, r in walk(t) if not r.endswith(".png")}
    quiet(lambda: cmd_apply(t, [], False, False, year))
    ok(before == {r: rd(r) for _, r in walk(t) if not r.endswith(".png")}, "apply twice changes nothing")
    texts = all(os.path.exists(os.path.join(HERE, "LICENSES", i + ".txt")) for i in TEXTS)
    rc = quiet(lambda: cmd_check(t, one_reader=True))
    ok(rc == 1, "check flags the secret, the undeclared foreign file and the unowned art")
    os.remove(os.path.join(t, "WIRE-SECRETS.md"))
    os.remove(os.path.join(t, "logo.png"))
    with open(os.path.join(t, "REUSE.toml"), "a") as f:
        f.write('\n[[annotations]]\npath = "vendor/legacy.js"\nSPDX-FileCopyrightText = "its authors"\n'
                'SPDX-License-Identifier = "MIT"\n')
    os.makedirs(os.path.join(t, "LICENSES"), exist_ok=True)
    put("LICENSES/MIT.txt", "MIT License (test copy)\n")
    quiet(lambda: cmd_apply(t, [], False, False, year))
    block = open(os.path.join(t, "REUSE.toml")).read().split("# colophon: end")[0]
    ok("vendor/legacy.js" not in block, "a hand-written declaration is respected, never re-declared")
    if texts:
        rc = quiet(lambda: cmd_check(t, one_reader=True))
        ok(rc == 0, "check reads the tree clean once each file's terms are written down")
        if not shutil.which("reuse"):
            ok(quiet(lambda: cmd_check(t)) == 2,
               "garden: one reader alone is NOT CHECKED unless --one-reader says the keeper accepts it")
    else:
        say("NOT CHECKED the clean pass: this skill's LICENSES/ texts are absent (card-only install)")
    reds = []
    if prove_red and texts:
        def red(name, breaker):
            snap = tempfile.mkdtemp(prefix="colophon-red-")
            shutil.rmtree(snap)
            shutil.copytree(t, snap)
            breaker(snap)
            rc = quiet(lambda: cmd_check(snap, one_reader=True))
            reds.append((name, rc == 1))
            shutil.rmtree(snap, ignore_errors=True)
        red("a license text removed", lambda s: os.remove(os.path.join(s, "LICENSES", "CC-BY-SA-4.0.txt")))
        red("a license text altered", lambda s: open(os.path.join(s, "LICENSES", "GPL-3.0-or-later.txt"), "ab").write(b" "))
        red("a header stripped", lambda s: open(os.path.join(s, "a.sh"), "w").write("#!/bin/sh\necho hi\n"))
        red("a secret slipped in", lambda s: open(os.path.join(s, "api.key"), "w").write("x\n"))
        red("a non-commercial asset", lambda s: open(os.path.join(s, "nc.md"), "w").write("<!-- " + TAG + " CC-BY-NC-4.0 -->\n"))
    shutil.rmtree(t, ignore_errors=True)
    reds += selftest_makers(ok, prove_red, texts)
    for name, caught in reds:
        say(("red  %s: caught" if caught else "red  %s: NOT CAUGHT") % name)
    second = "NOT CHECKED (pip install reuse)" if not shutil.which("reuse") else "run in check"
    say("colophon selftest: %d checks pass; second reader %s" % (n[0], second))
    if prove_red:
        if not texts:
            say("prove-red: NOT CHECKED (no license texts beside this script)")
            return 2
        if all(c for _, c in reds):
            say("PROVE-RED OK: %d planted faults caught" % len(reds))
            return 0
        return 1
    return 0


def selftest_makers(ok, prove_red, texts):
    """Every maker named, on evidence; a mention, a quote or an agent is not a maker. Robin and Quinn are made up,
    and their names are kept apart in this file so its own lines never read as a statement about anyone."""
    saved = dict(PARTIES)
    R, Q = "Rob" + "in", "Qu" + "inn"
    PARTIES["robin"] = {"line": R + " Quill <robin@example.org>", "names": [R + " Quill", R],
                        "emails": ["robin@example.org"], "agents": [], "said": "a test",
                        "terms": {"code": ["GPL-3.0-or-later"], "prose": ["CC-BY-SA-4.0"]}}
    t, reds = tempfile.mkdtemp(prefix="colophon-makers-"), []

    def put(rel, s):
        p = os.path.join(t, rel)
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, "w", encoding="utf-8", newline="\n") as f:
            f.write(s)

    try:
        put("skills/sig/SKILL.md", "---\nname: sig\ndescription: d\nmetadata:\n  lineage: derived from " + R +
            "'s sign tool\n---\n# Sig\n")
        put("skills/sig/scripts/sig.sh", "#!/bin/sh\necho sig\n")
        put("skills/dis/SKILL.md", "---\nname: dis\ndescription: This is " + R + "'s own audit discipline.\n---\n# Dis\n")
        put("skills/pact/SKILL.md", "---\nname: pact\ndescription: the joint Bryant and " + R + " wire protocol\n---\n")
        put("notes/by.md", "# By\n\nMentat (for " + R + "; MODEL)\n")
        put("notes/quoted.md", "In that garden the agent signs as Mentat (\"Mentat (for " + R + "; MODEL)\").\n")
        put("notes/mention.md", " ".join([R + "'s side."] * 5) + "\n")
        put("notes/agent.md", "*Written with Alfred (for Bryant; MODEL).*\n")
        put("notes/stranger.md", "Lineage: " + Q + "'s field notes\n")
        put("notes/canon.md", "The co-signed wire rules: the shared canon of the Bryant\u2194" + R + " wire.\n")
        put("notes/lab.md", "The design is option C of the decision in " + R + "'s lab: put the router up front.\n")
        put("parcels/2026-01-01-from-robin/tool.py", "print('a tool of theirs')\n")
        put("copy/tool.py", "print('a tool of theirs')\n")
        guide = "".join("step %d of the guide\n" % i for i in range(12))
        put("parcels/2026-01-01-from-robin/guide.md", guide)
        put("docs/guide.md", guide.replace("step 11 of the guide", "step 11, rewritten here"))
        put("old/x.sh", "#!/bin/sh\n# " + CTAG + " 2026 " + HOLDER + "\n# " + TAG + " " + CODE + "\n# Derived from " +
            R + "'s tool\necho x\n")
        git = shutil.which("git")
        if git:
            env = dict(os.environ, GIT_CONFIG_NOSYSTEM="1", HOME=t, GIT_CONFIG_GLOBAL=os.path.join(t, ".nogit"))

            def commit(path, body, who, msg):
                put(path, body)
                subprocess.run(["git", "-C", t, "add", path], capture_output=True, env=env)
                subprocess.run(["git", "-C", t, "-c", "user.name=" + who[0], "-c", "user.email=" + who[1], "-c",
                                "commit.gpgsign=false", "commit", "-q", "-m", msg], capture_output=True, env=env)
            subprocess.run(["git", "-C", t, "init", "-q"], capture_output=True, env=env)
            commit("src/a.py", "print('a')\n", (R + " Quill", "robin@example.org"), "a")
            commit("src/a.py", "print('a')\nprint('more')\n", ("Bryant Frankford", "nathanielfrankford@gmail.com"),
                   "more\n\nCo-Authored-By: Claude <noreply@anthropic.com>")
            commit("src/b.py", "print('b')\n", ("Pat Stranger", "pat@example.org"), "b")
        ctx = context(t)
        plan = {r: (a, i, at) for a, r, i, s, nt, at in classify(t, ctx=ctx)}
        own = lambda r: plan[r][2]["owners"]
        ok(own("skills/sig/SKILL.md") == ["bryant", "robin"] and own("skills/sig/scripts/sig.sh") == ["bryant", "robin"],
           "makers: a derived skill names its source's maker, on every file of the skill")
        ok(plan["skills/sig/scripts/sig.sh"][1] == "GPL-3.0-or-later" and plan["skills/sig/SKILL.md"][1] == PROSE,
           "makers: co-made code carries only the terms every maker offers")
        cred = lambda r: [c[0] for c in plan[r][2].get("credit", [])]
        # Garden edition, the ladder: a joint protocol is co-made; a discipline is credited, not owned
        # (Bryant's 1.1 asserted both make co-owners; copyright covers the words, not the idea).
        ok("robin" in own("skills/pact/SKILL.md") and "robin" not in own("skills/dis/SKILL.md")
           and "robin" in cred("skills/dis/SKILL.md"),
           "ladder: a joint protocol makes co-owners; a discipline is credited, not owned")
        ok("robin" in own("notes/by.md"), "makers: a byline names its principal")
        ok("robin" in own("notes/canon.md") and "robin" not in own("notes/lab.md")
           and "robin" in cred("notes/lab.md"),
           "ladder: a co-signed canon makes co-owners; a design taken from someone's lab is credited")
        ok(own("notes/quoted.md") == own("notes/mention.md") == own("notes/agent.md") == ["bryant"],
           "makers: a quote, a mention or an agent's byline makes no one a maker")
        ok(plan["notes/stranger.md"][0] == "ASK", "makers: a maker nobody has named is asked about, never guessed")
        ok(plan["copy/tool.py"][0] == "TOML" and own("copy/tool.py") == ["robin"] and
           plan["copy/tool.py"][1] == "GPL-3.0-or-later", "makers: an unchanged parcel copy is theirs, under their terms")
        ok(own("docs/guide.md") == ["bryant", "robin"], "makers: an edited parcel copy is co-made")
        ok(plan["old/x.sh"][0] == "ATTRIB", "makers: a header that misses a maker is planned for repair")
        if git:
            ok(own("src/a.py") == ["bryant", "robin"], "makers: git history names its authors; an AI co-author is no one")
            ok(plan["src/b.py"][0] == "ASK", "makers: an unknown git author is asked about")
            os.remove(os.path.join(t, "src/b.py"))
        else:
            say("NOT CHECKED makers from git history (git is not installed)")
        os.remove(os.path.join(t, "notes/stranger.md"))
        # Garden edition: rung 2 is met in the credits, so the tree names the one it credits.
        put("README.md", "# Fixture\n\nCredits: the audit discipline and the router design are " + R + "'s.\n")
        quiet(lambda: cmd_apply(t, [], False, False, "2026", context(t)))
        rd = lambda r: open(os.path.join(t, r), encoding="utf-8").read()
        ok(R + " Quill <robin@example.org>" in rd("skills/sig/scripts/sig.sh") and
           TAG + " GPL-3.0-or-later\n" in rd("skills/sig/scripts/sig.sh"), "makers: apply names both makers and narrows the terms")
        ok(R + " Quill" in rd("old/x.sh") and TAG + " GPL-3.0-or-later\n" in rd("old/x.sh") and
           rd("old/x.sh").count(CTAG) == 2, "makers: apply repairs a header that missed a maker")
        ok(rd("copy/tool.py") == "print('a tool of theirs')\n", "makers: their file keeps its bytes")
        ok('"2026 ' + R + ' Quill <robin@example.org>"' in rd("REUSE.toml"), "makers: REUSE.toml names the co-owner")
        if texts:
            rc = quiet(lambda: cmd_check(t, context(t), one_reader=True))
            ok(rc == 0, "makers: check reads the attributed tree clean")
        if prove_red and texts:
            def red(name, breaker):
                snap = tempfile.mkdtemp(prefix="colophon-red-")
                shutil.rmtree(snap)
                shutil.copytree(t, snap)
                breaker(snap)
                rc = quiet(lambda: cmd_check(snap, context(snap)))
                reds.append((name, rc == 1))
                shutil.rmtree(snap, ignore_errors=True)

            def edit(s, rel, old, new):
                p = os.path.join(s, rel)
                body = open(p, encoding="utf-8").read()
                open(p, "w", encoding="utf-8").write(body.replace(old, new))
            red("a co-owner's line removed", lambda s: edit(s, "skills/sig/scripts/sig.sh",
                                                            "# " + CTAG + " 2026 " + R + " Quill <robin@example.org>\n", ""))
            red("the LGPL offer put back on co-made code", lambda s: edit(s, "old/x.sh", TAG + " GPL-3.0-or-later",
                                                                         TAG + " " + CODE))
            red("a maker nobody has named", lambda s: open(os.path.join(s, "notes", "new.md"), "w").write(
                "<!-- " + CTAG + " 2026 " + HOLDER + " -->\n<!-- " + TAG + " " + PROSE + " -->\nLineage: " + Q + "'s notes\n"))
    finally:
        PARTIES.clear()
        PARTIES.update(saved)
        shutil.rmtree(t, ignore_errors=True)
    return reds


def quiet(fn):
    import io, contextlib
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        return fn()


def main(argv):
    if not argv or argv[0] in ("-h", "--help"):
        print(__doc__)
        return 2
    if argv[0] == "--selftest":
        return selftest("--prove-red" in argv)
    cmd, rest = argv[0], argv[1:]
    joint, flags, pos, year, parcels, parties = [], set(), [], time.strftime("%Y", time.gmtime()), [], None
    sources = []
    i = 0
    while i < len(rest):
        a = rest[i]
        if a in ("--joint", "--year", "--parcels", "--parties", "--sources") and i + 1 < len(rest):
            v = rest[i + 1]
            if a == "--sources":
                sources.append(v)
            elif a == "--joint":
                joint.append(v)
            elif a == "--year":
                year = v
            elif a == "--parcels":
                parcels.append(v)
            else:
                parties = v
            i += 2
            continue
        if a.startswith("--"):
            flags.add(a)
            i += 1
            continue
        pos.append(a)
        i += 1
    if not pos:
        print(__doc__)
        return 2
    root = pos[0]
    global FETCH
    FETCH = "--fetch" in flags
    if cmd == "texts":
        return 0 if write_texts(root, pos[1:] or list(TEXTS)) else 2
    if cmd not in ("who", "plan", "apply", "check"):
        print(__doc__)
        return 2
    if not os.path.isdir(root):
        say("NOT CHECKED: cannot read " + root)
        return 2
    try:
        found = load_parties(root, parties)
    except (OSError, ValueError) as e:
        say("NOT CHECKED: parties file: " + str(e))
        return 2
    if not found:
        say("NOT CHECKED: no .colophon-parties.json in %s and no --parties FILE: colophon carries no one's "
            "terms of its own (see references/parties.example.json)" % root)
        return 2
    ok, why = use_keeper()
    if not ok:
        say("NOT CHECKED: " + why)
        return 2
    ctx = context(root, parcels, "--no-git" not in flags)
    try:
        add_sources(ctx, root, sources)
    except (OSError, ValueError, SystemExit) as e:
        say("NOT CHECKED: sources: " + str(e))
        return 2
    if cmd == "who":
        return cmd_who(root, ctx, "--json" in flags)
    if cmd == "plan":
        cmd_plan(root, joint, "--toml-only" in flags, "--art-is-ours" in flags, ctx)
        return 0
    if cmd == "apply":
        return cmd_apply(root, joint, "--toml-only" in flags, "--art-is-ours" in flags, year, ctx)
    return cmd_check(root, ctx, one_reader="--one-reader" in flags)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
