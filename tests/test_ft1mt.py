"""Second reader for bin/ft1mt (the common footer): Python reads conventions/house.env and
conventions/FOOTERS.org on its own and requires every minted skill to end in exactly the footer
those two say, with a body whose hash is the one its row recorded; and runs ft1mt --prove-red.

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; GPL-3.0-or-later.
Mentat (for Corwin; claude-opus-5-5)
"""
import hashlib, os, re, shlex, subprocess, unittest

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BEGIN = "<!-- footer: minted by bin/ft1mt from conventions/house.env and conventions/FOOTERS.org; edit those, not this -->"
END = "<!-- /footer -->"


def conventions():
    out = {}
    with open(os.path.join(HERE, "conventions", "house.env"), encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                k, v = line.split("=", 1)
                out[k] = shlex.split(v)[0] if v else ""
    return out


def rows():
    with open(os.path.join(HERE, "conventions", "FOOTERS.org"), encoding="utf-8") as fh:
        table = [l for l in fh if l.startswith("|") and not l.startswith("|-")]
    head = [c.strip() for c in table[0].strip().strip("|").split("|")]
    return [dict(zip(head, [c.strip() for c in l.strip().strip("|").split("|")])) for l in table[1:]]


def makers():
    """{skill: other makers}, from conventions/MAKERS.org, read the way bin/ft1mt's co_for reads it
    (a second reader: the attribution ladder's rung 1 in the footer)."""
    out = {}
    p = os.path.join(HERE, "conventions", "MAKERS.org")
    if not os.path.exists(p):
        return out
    with open(p, encoding="utf-8") as fh:
        for line in fh:
            f = line.rstrip("\n").split("|")
            if len(f) > 3:
                k, m = f[1].strip(), f[2].strip()
                if k and k not in out:
                    out[k] = m
    return out


def expected(c, r):
    if r["from"] in ("", "-"):
        first = "*Version %s: first edition %s; spine: %s.*" % (r["version"], r["revised"], r["spine"])
    else:
        first = "*Version %s: edition revised from %s on %s; spine: %s.*" % (r["version"], r["from"], r["revised"], r["spine"])
    ys, yr = r["spine"][:4], r["revised"][:4]
    years = yr if (ys == yr or not ys.isdigit()) else "%s-%s" % (ys, yr)
    co = makers().get(r["skill"], "")
    holder = ("%s and %s" % (co, c["HOLDER"])) if co else c["HOLDER"]
    last = "Copyright %s %s; %s: %s (scripts %s); %s (for %s; %s)" % (
        years, holder, c["PROSE_LICENCE"], c["PROSE_LICENCE_URL"], c["CODE_LICENCE"], c["PERSONA"], c["PRINCIPAL"], c["MODEL"])
    return [BEGIN, first, "", last, END]


def split(path):
    lines = open(path, encoding="utf-8").read().split("\n")
    if lines and lines[-1] == "":
        lines.pop()
    body, footer, inside, after, where = [], [], False, False, None
    for i, l in enumerate(lines):
        if l == BEGIN:
            inside = True
        if inside:
            footer.append(l)
            if l == END:
                inside, after, where = False, True, i
            continue
        if after:
            after = False
            if not l.strip(" \t"):
                continue
        body.append(l)
    while body and not body[-1].strip(" \t"):
        body.pop()
    # where it sits: last, or just before a closing "sentinel:" line with one blank between
    tail = lines[where + 1:] if where is not None else []
    placed = (where is not None) and (tail == [] or (len(tail) == 2 and tail[0] == "" and tail[1].startswith("sentinel: ")))
    return body, footer, placed


class Footers(unittest.TestCase):
    def test_every_minted_footer_is_what_the_conventions_say(self):
        c = conventions()
        rs = rows()
        self.assertGreater(len(rs), 10)
        for r in rs:
            path = os.path.join(HERE, r["folder"], r["skill"], "SKILL.md")
            self.assertTrue(os.path.exists(path), path)
            body, footer, placed = split(path)
            if r["how"] == "mint":
                self.assertEqual(footer, expected(c, r), r["skill"])
                self.assertTrue(placed, "%s: the footer is not last (or just before its sentinel)" % r["skill"])
                sha = hashlib.sha256(("\n".join(body) + "\n").encode("utf-8")).hexdigest()[:12]
                self.assertEqual(sha, r["body"], "%s: body changed since minted" % r["skill"])
            elif r["how"] == "recipe":
                self.assertTrue(any(re.match(r"\*Version [^:]+: .*20\d\d-[01]\d-[0-3]\d", l) for l in body), r["skill"])

    def test_every_skill_has_a_row(self):
        named = {(r["folder"], r["skill"]) for r in rows()}
        for folder in ("skills", "SOFT-SKILLS"):
            for n in sorted(os.listdir(os.path.join(HERE, folder))):
                if os.path.exists(os.path.join(HERE, folder, n, "SKILL.md")):
                    self.assertIn((folder, n), named)

    def test_prove_red(self):
        r = subprocess.run(["sh", os.path.join(HERE, "bin", "ft1mt"), "--prove-red"], capture_output=True, text=True, encoding="utf-8")
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)


if __name__ == "__main__":
    unittest.main()
