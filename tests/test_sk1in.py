"""Second reader for bin/sk1in (Bryant's five skill-integrity checks; offer 2.3, BRYANT-INFLUENCER r2).

Python reads every SKILL.md on its own and must reach the same verdict as the sh+awk reader for
checks 1 to 4 (nul, ending, desc, version) on every skill in the garden, plus planted faults.

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; GPL-3.0-or-later.
Mentat (for Corwin; claude-opus-5-5)
"""
import os, re, subprocess, tempfile, unittest, glob

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SK1IN = os.path.join(HERE, "bin", "sk1in")


def read(path):
    b = open(path, "rb").read()
    out = {"nul": "RED" if b.count(b"\0") else "OK"}
    text = b.replace(b"\0", b"").decode("utf-8", "replace")
    lines = [l[:-1] if l.endswith("\r") else l for l in text.split("\n")]
    if lines and lines[-1] == "":
        lines.pop()
    desc, found = "", False
    if lines and lines[0] == "---":
        try:
            end = lines.index("---", 1)
        except ValueError:
            end = len(lines)
        for i in range(1, end):
            if lines[i].startswith("description:"):
                found = True
                v = lines[i][len("description:"):].strip()
                if re.fullmatch(r"[>|][-+]?", v):
                    v = ""
                elif len(v) >= 2 and v[0] == v[-1] and v[0] in "\"'":
                    v = v[1:-1]
                parts = [v] if v else []
                j = i + 1
                while j < end and lines[j][:1] in (" ", "\t"):
                    parts.append(lines[j].strip())
                    j += 1
                desc = " ".join(parts)
                break
    out["desc"] = "RED" if (not found or len(desc) > 1024) else "OK"
    fences = sum(1 for l in lines if l.lstrip(" \t").startswith("```"))
    nonblank = [l for l in lines if l.strip(" \t")]
    last = nonblank[-1].rstrip(" \t") if nonblank else ""
    if fences % 2 or not nonblank:
        out["ending"] = "RED"
    elif re.fullmatch(r"sentinel: [A-Z0-9][A-Z0-9-]*", last):
        out["ending"] = "OK"
    elif re.match(r"[ \t]*(#|\||[-*+] |[0-9]+\. |>|```|---|<!--|\[|\*\*)", last):
        out["ending"] = "OK"
    elif last[-1:] in set(".!?:;)]}\"'`*_>"):
        out["ending"] = "OK"
    else:
        out["ending"] = "RED"
    out["version"] = "OK" if any("version" in l.lower() and re.search(r"20\d\d-[01]\d-[0-3]\d", l) for l in lines) else "HOLD"
    return out


def sh_verdicts(dirs):
    r = subprocess.run(["sh", SK1IN, "--raw"] + dirs, capture_output=True, text=True, encoding="utf-8", check=True)
    v = {}
    for line in r.stdout.splitlines():
        verdict, check, skill = line.split("\t")[:3]
        v[(skill, check)] = verdict
    return v


class TwinReaders(unittest.TestCase):
    def test_garden_agrees(self):
        dirs = sorted(glob.glob(os.path.join(HERE, "skills", "*", "")) + glob.glob(os.path.join(HERE, "SOFT-SKILLS", "*", "")))
        dirs = [d for d in dirs if os.path.exists(os.path.join(d, "SKILL.md"))]
        self.assertGreater(len(dirs), 10)
        sh = sh_verdicts(dirs)
        for d in dirs:
            name = os.path.basename(d.rstrip(os.sep))
            py = read(os.path.join(d, "SKILL.md"))
            for check, verdict in py.items():
                self.assertEqual(sh.get((name, check)), verdict, f"{name} {check}: sh {sh.get((name, check))} py {verdict}")

    def test_planted_faults_agree_and_go_red(self):
        with tempfile.TemporaryDirectory() as t:
            base = "---\nname: x\ndescription: A test.\n---\n# T\n\nVersion 1 (2026-10-04).\n\nIt ends.\n"
            cases = {"good": base, "cut": base + "and then it stops in the mi", "nul": base + "\0\0",
                     "long": base.replace("A test.", "y" * 1025), "fence": base + "```\nopen\n",
                     "nover": base.replace("Version 1 (2026-10-04).\n", "")}
            for n, body in cases.items():
                os.makedirs(os.path.join(t, n))
                open(os.path.join(t, n, "SKILL.md"), "w", encoding="utf-8", newline="").write(body)
            dirs = [os.path.join(t, n) for n in cases]
            sh = sh_verdicts(dirs)
            want = {("cut", "ending"): "RED", ("nul", "nul"): "RED", ("long", "desc"): "RED",
                    ("fence", "ending"): "RED", ("nover", "version"): "HOLD", ("good", "ending"): "OK"}
            for (n, c), w in want.items():
                self.assertEqual(read(os.path.join(t, n, "SKILL.md"))[c], w, f"py {n} {c}")
                self.assertEqual(sh[(n, c)], w, f"sh {n} {c}")


if __name__ == "__main__":
    unittest.main()
