#!/usr/bin/env python3
"""gv1mt-browser -- the garden view in headless Chromium: GV9 (JavaScript off), GV12 (axe-core, light and
dark, and the manual switch), GV13 (keyboard reach and a visible focus ring), GV17 (no two text boxes
overlap in the ring or the compass), and the page's own self-test
(seal, story, marks, counts, badges).  field-comic's tools/hl1rn.py is the pattern.

usage: gv1mt-browser.py PAGE [--prove-red]
  --prove-red plants three faults in copies of PAGE and requires each to be caught:
    a muted text colour too faint to read (GV12 must fail), the doorways shown only by JavaScript
    (GV9 must fail), copy buttons taken out of the Tab order (GV13 must fail), and a ring label drawn twice
    in one place (GV17 must fail).
Environment: AXE=path/to/axe.min.js (else node_modules/axe-core/axe.min.js beside the repo or under
$HOME/gvkit); GV_LIBDIR=a folder of extra shared libraries for Chromium (prepended to LD_LIBRARY_PATH;
default $HOME/gvkit/root/usr/lib/x86_64-linux-gnu when that folder exists).  GV_LIBDIR is the folder
holding libXdamage.so.1 itself, not ~/gvkit/deb (that holds only the downloaded .deb).

Setting up the browser leg in a fresh Cowork VM (as it was run green on 2026-10-10; no root needed):
  python3 -m playwright install chromium            # Chromium for the python Playwright already there
  mkdir -p ~/gvkit/deb && cd ~/gvkit/deb && apt-get download libxdamage1 \
    && dpkg-deb -x libxdamage1_*.deb ~/gvkit/root   # the one library this VM's Chromium lacked
  cd ~/gvkit && npm install axe-core@4.10.2         # axe-core, found at ~/gvkit/node_modules
Then, from the garden:
  GV_LIBDIR=$HOME/gvkit/root/usr/lib/x86_64-linux-gnu sh tests/gv1mt-tests.sh
Exit 0 green, 1 red, 77 NOT CHECKED (no Playwright, no Chromium, or no axe-core): never a silent pass.

Authored by Mentat (for Corwin; claude-opus-5-5).
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
"""
import os, re, sys, tempfile

OVERLAP_JS = """() => { const out = [], n = {};
  function axes(P) { const a = []; for (let i = 0; i < 2; i++) { const dx = P[i+1][0]-P[i][0], dy = P[i+1][1]-P[i][1];
    const l = Math.hypot(dx, dy) || 1; a.push([-dy/l, dx/l]); } return a; }
  function proj(P, ax) { let lo = Infinity, hi = -Infinity; for (const p of P) { const v = p[0]*ax[0]+p[1]*ax[1];
    lo = Math.min(lo, v); hi = Math.max(hi, v); } return [lo, hi]; }
  function depth(A, B) { let d = Infinity; for (const ax of axes(A).concat(axes(B))) { const a = proj(A, ax), b = proj(B, ax);
    const o = Math.min(a[1], b[1]) - Math.max(a[0], b[0]); if (o <= 0) return 0; d = Math.min(d, o); } return d; }
  for (const id of ['ring', 'compass']) { const svg = document.getElementById(id); if (!svg) continue;
    const inv = svg.getScreenCTM().inverse();
    const Q = Array.from(svg.querySelectorAll('text')).filter(t => t.getClientRects().length).map(t => {
      const b = t.getBBox(), m = inv.multiply(t.getScreenCTM());
      return {t: (t.textContent || '').trim(), P: [[b.x, b.y], [b.x+b.width, b.y], [b.x+b.width, b.y+b.height], [b.x, b.y+b.height]]
        .map(([x, y]) => { const q = new DOMPoint(x, y).matrixTransform(m); return [q.x, q.y]; })}; });
    n[id] = Q.length;
    for (let i = 0; i < Q.length; i++) for (let j = i+1; j < Q.length; j++) { const d = depth(Q[i].P, Q[j].P);
      if (d > 0.5) out.push(id + ': "' + Q[i].t + '" on "' + Q[j].t + '" (' + d.toFixed(1) + ')'); } }
  return {n: n, out: out}; }"""

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def find_axe():
    for p in (os.environ.get("AXE"), os.path.join(HERE, "node_modules", "axe-core", "axe.min.js"),
              os.path.expanduser("~/gvkit/node_modules/axe-core/axe.min.js"),
              "/usr/lib/node_modules/axe-core/axe.min.js"):
        if p and os.path.isfile(p):
            return p
    return None


def not_checked(why):
    print("gv1mt-browser: NOT CHECKED (%s)" % why)
    sys.exit(77)


def run(page, axe_src):
    """PAGE -> list of (id, ok, msg)."""
    from playwright.sync_api import sync_playwright
    url = "file://" + os.path.abspath(page)
    res = []
    env = dict(os.environ)
    lib = os.environ.get("GV_LIBDIR") or os.path.expanduser("~/gvkit/root/usr/lib/x86_64-linux-gnu")
    if os.path.isdir(lib):
        env["LD_LIBRARY_PATH"] = lib + ":" + env.get("LD_LIBRARY_PATH", "")
    with sync_playwright() as pw:
        b = pw.chromium.launch(env=env)
        # GV9: JavaScript off
        ctx = b.new_context(java_script_enabled=False)
        p = ctx.new_page()
        p.goto(url)
        need = {"read-back": "#h-read", "ring": "#ring", "compass": "#compass", "doorways": ".door",
                "tensions": "#h-t", "story": "details[data-node]"}
        seen = {k: p.locator(sel).first.is_visible() for k, sel in need.items()}
        doors = p.locator(".door").count()
        vis_doors = sum(1 for i in range(doors) if p.locator(".door").nth(i).is_visible())
        asb = sum(1 for i in range(doors) if "as built" in p.locator(".door").nth(i).inner_text())
        ok = all(seen.values()) and vis_doors == 4 and asb == 4
        res.append(("GV9", ok, "JS off: %s; %d of 4 doorways visible, %d say 'as built'"
                    % (", ".join("%s %s" % (k, "shown" if v else "NOT SHOWN") for k, v in seen.items()), vis_doors, asb)))
        ctx.close()
        # GV12: axe in light, dark, and the manual switch to dark from a light system
        for label, scheme, manual in (("light", "light", None), ("dark", "dark", None), ("switch-dark", "light", "dark")):
            ctx = b.new_context(color_scheme=scheme)
            p = ctx.new_page()
            errs = []
            p.on("pageerror", lambda e: errs.append(str(e)))
            p.goto(url)
            if manual:
                p.evaluate("m => document.documentElement.setAttribute('data-theme', m)", manual)
            p.add_script_tag(content=axe_src)
            r = p.evaluate("""async () => { const r = await axe.run(document, {runOnly: {type: 'tag',
                values: ['wcag2a','wcag2aa','wcag21a','wcag21aa']}, resultTypes: ['violations']});
                return r.violations.map(v => ({id: v.id, impact: v.impact, n: v.nodes.length,
                  first: v.nodes[0] && v.nodes[0].target.join(' ')})); }""")
            hard = [v for v in r if v["impact"] in ("critical", "serious")]
            soft = [v for v in r if v not in hard]
            res.append(("GV12", not hard and not errs, "axe %s: %s%s%s" % (
                label, "; ".join("%s %s x%d at %s" % (v["impact"], v["id"], v["n"], v["first"]) for v in hard) or "no critical or serious",
                ("; also " + ", ".join("%s %s" % (v["impact"], v["id"]) for v in soft)) if soft else "",
                ("; page errors: " + "; ".join(errs)) if errs else "")))
            if label == "light":
                st = p.evaluate("async () => (await window.__gardenSelfTest())")
                for t in st:
                    nc = t["msg"].startswith("NOT CHECKED")
                    res.append(("SELF", t["pass"] or nc, "%s %s" % (t["id"], t["msg"])))
                # GV17: no two text boxes overlap (ring and compass)
                ov = p.evaluate(OVERLAP_JS)
                res.append(("GV17", not ov["out"] and ov["n"].get("ring", 0) > 0,
                            "%s text boxes; %d overlapping pairs%s" % (
                                ", ".join("%s %d" % kv for kv in sorted(ov["n"].items())), len(ov["out"]),
                                ("; first: " + " | ".join(ov["out"][:4])) if ov["out"] else "")))
                # GV13: keyboard
                want = p.evaluate("""() => { const sel = 'button:not([hidden]), summary, input, a[href]';
                    return Array.from(document.querySelectorAll(sel)).filter(e => e.offsetParent !== null || e.tagName==='SUMMARY')
                      .map((e, i) => { e.setAttribute('data-kb', 'k' + i); return 'k' + i; }); }""")
                got, focus_ok, first = set(), 0, None
                for _ in range(len(want) + 40):
                    p.keyboard.press("Tab")
                    k = p.evaluate("""() => { const a = document.activeElement; if (!a) return null;
                        const s = getComputedStyle(a); return [a.getAttribute('data-kb'), s.outlineStyle !== 'none' && parseFloat(s.outlineWidth) >= 2]; }""")
                    if not k or not k[0]:
                        continue
                    if k[0] == first:
                        break
                    first = first or k[0]
                    if k[0] not in got and k[1]:
                        focus_ok += 1
                    got.add(k[0])
                missing = [w for w in want if w not in got]
                names = p.evaluate("ids => ids.map(i => { const e = document.querySelector('[data-kb=\"'+i+'\"]'); return e.tagName + ' ' + (e.textContent||'').trim().slice(0,30); })", missing[:5])
                res.append(("GV13", not missing and focus_ok == len(got),
                            "Tab reached %d of %d controls, %d with a visible focus ring%s"
                            % (len(got & set(want)), len(want), focus_ok, ("; missed: " + " | ".join(names)) if missing else "")))
            ctx.close()
        b.close()
    return res


def plant(s, old, new):
    if s.count(old) < 1:
        raise SystemExit("gv1mt-browser: cannot plant the fault: %r is not in the page" % old[:60])
    return s.replace(old, new)


def dup_label(s):
    m = re.search(r'(<g class="n [^"]*" data-id="[^"]*">.*?)(<text [^>]*>[^<]*</text>)', s, re.S)
    if not m:
        raise SystemExit("gv1mt-browser: cannot plant the fault: no ring label found")
    return s[:m.end(2)] + m.group(2) + s[m.end(2):]


FAULTS = [
    ("a muted text colour too faint to read", "GV12",
     lambda s: plant(s, "--muted:#4a505b", "--muted:#b9bcc2")),
    ("the doorways shown only by JavaScript", "GV9",
     lambda s: plant(s, '<article class="door"', '<article data-js hidden class="door"')),
    ("copy buttons taken out of the Tab order", "GV13",
     lambda s: plant(s, 'data-js hidden data-copy=', 'tabindex="-1" data-js hidden data-copy=')),
    ("a ring label drawn twice in one place", "GV17", dup_label),
]


def main():
    args = [a for a in sys.argv[1:] if a != "--prove-red"]
    if not args:
        print(__doc__)
        return 2
    page = args[0]
    try:
        import playwright.sync_api  # noqa: F401
    except ImportError:
        not_checked("no Playwright for python3")
    axe = find_axe()
    if not axe:
        not_checked("no axe-core: set AXE=path/to/axe.min.js")
    axe_src = open(axe, encoding="utf-8").read()
    try:
        res = run(page, axe_src)
    except Exception as e:
        not_checked("headless Chromium did not run: %s" % str(e).splitlines()[0])
    if "--prove-red" not in sys.argv:
        for i, ok, msg in res:
            print("%-5s %-5s %s" % ("ok" if ok else "FAIL", i, msg))
        bad = sum(1 for r in res if not r[1])
        print("gv1mt-browser: %s (%d checks, %d failed)" % ("GREEN" if not bad else "RED", len(res), bad))
        return 1 if bad else 0
    src = open(page, encoding="utf-8").read()
    bad = 0
    with tempfile.TemporaryDirectory() as t:
        for n, (what, row, fault) in enumerate(FAULTS):
            f = os.path.join(t, "fault-%d.html" % n)
            open(f, "w", encoding="utf-8").write(fault(src))
            got = [r for r in run(f, axe_src) if r[0] == row]
            caught = any(not r[1] for r in got)
            print("prove-red: %s: %s %s" % (what, row, "FAILS as it should" if caught else "still passes (NOT caught)"))
            if caught:
                print("           " + next(r[2] for r in got if not r[1])[:160])
            bad |= not caught
    print("PROVE-RED OK" if not bad else "PROVE-RED FAILED")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
