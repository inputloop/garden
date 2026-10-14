#!/usr/bin/env python3
# evalboard.py — turn a skill-creator iteration into ONE tidy, sortable boxscore.
# STDLIB ONLY. Companion to scoreboard.py; same band visual language.
#
# The problem it fixes (Corwin, 2026-09-02): six walls of sub-agent prose + a
# "100% / 100%" table = eyes glaze. The signal that mattered (did the skill
# CHANGE anything? where is it weak? what did it cost?) was buried. This sorts
# the interesting rows to the top and lets you re-sort on any column.
#
# Reads a skill-creator iteration dir:
#   <iter>/benchmark.json
#   <iter>/eval-*/<config>/run-1/grading.json      (summary.pass_rate, expectations)
#   <iter>/eval-*/<config>/run-1/timing.json       (total_tokens, duration)
#   <iter>/eval-*/<config>/run-1/outputs/          (produced files)
#   <iter>/eval-*/<config>/input/seat/memory/      (final artifacts, if present)
#
# Signal it computes per eval:
#   * pass n/m for with_skill and for the baseline
#   * PASS-DIVERGE  — the two configs disagree on pass/fail
#   * ARTIFACT-DIVERGE — the two configs produced different file *sets*
#     (same verdict, different behaviour — the thing pass/fail can't see)
#   * cost delta (time, tokens): with_skill minus baseline
# Default sort puts diverging + failing rows first; headers are click-to-sort.
import sys, os, json, glob, argparse, html

def _load(p, default=None):
    try:    return json.load(open(p, encoding="utf-8"))
    except Exception: return default

def _fileset(run):
    files = set()
    for sub in ("run-1/outputs", "input/seat/memory"):
        d = os.path.join(run, sub)
        if os.path.isdir(d):
            for f in glob.glob(os.path.join(d, "*")):
                if os.path.isfile(f):
                    files.add(os.path.basename(f))
    return files

def _cfg(evaldir, name):
    run = os.path.join(evaldir, name)
    g = _load(os.path.join(run, "run-1", "grading.json"), {}) or {}
    t = _load(os.path.join(run, "run-1", "timing.json"), {}) or {}
    s = g.get("summary", {})
    return {
        "present": os.path.isdir(run),
        "passed": s.get("passed", 0), "total": s.get("total", 0),
        "rate": s.get("pass_rate", 0.0),
        "tokens": t.get("total_tokens", 0),
        "secs": t.get("total_duration_seconds", 0.0),
        "files": _fileset(run),
    }

def collect(iterdir, primary="with_skill", baseline="without_skill"):
    rows = []
    for evaldir in sorted(glob.glob(os.path.join(iterdir, "eval-*"))):
        if not os.path.isdir(evaldir):
            continue
        name = os.path.basename(evaldir)
        a, b = _cfg(evaldir, primary), _cfg(evaldir, baseline)
        pass_div = (a["total"] and b["total"] and (a["passed"] != b["passed"]))
        art_div = bool(a["files"] and b["files"] and a["files"] != b["files"])
        only_a = sorted(a["files"] - b["files"])
        only_b = sorted(b["files"] - a["files"])
        note = ""
        if art_div:
            bits = []
            if only_a: bits.append("+skill: " + ", ".join(only_a))
            if only_b: bits.append("+base: " + ", ".join(only_b))
            note = " · ".join(bits)
        rows.append({
            "eval": name, "a": a, "b": b,
            "pass_div": pass_div, "art_div": art_div,
            "d_secs": round(a["secs"] - b["secs"], 1),
            "d_tok": a["tokens"] - b["tokens"], "note": note,
        })
    return rows

def _sort_key(r):
    # interesting first: any divergence, then failures, then bigger cost
    diverge = 1 if (r["pass_div"] or r["art_div"]) else 0
    failing = 1 if (r["a"]["total"] and r["a"]["passed"] < r["a"]["total"]) else 0
    return (-diverge, -failing, -abs(r["d_tok"]))

def _badge(passed, total):
    if not total:            st, gl = "unwired", "◇"
    elif passed == total:    st, gl = "ok", "●"
    else:                    st, gl = "stale", "■"
    return f'<span class="sb-cell sb-{st}"><span class="sb-ic">{gl}</span><span class="sb-vl">{passed}/{total}</span></span>'

def _dv(flag, word):
    st, gl = ("watch", "◆") if flag else ("ok", "●")
    txt = word if flag else "same"
    return f'<span class="sb-cell sb-{st}"><span class="sb-ic">{gl}</span><span class="sb-lb">{txt}</span></span>'

CSS = """
.eb{font:0.9rem/1.4 ui-sans-serif,system-ui,-apple-system,Segoe UI,Roboto,sans-serif;color:#1f2328;max-width:100%}
.eb h3{font-size:1rem;margin:0 0 .2em}
.eb .sub{color:#57606a;font-size:.82rem;margin-bottom:.7em}
.eb table{border-collapse:collapse;width:100%;font-size:.86rem}
.eb th,.eb td{text-align:left;padding:.34em .6em;border-bottom:1px solid #d0d7de;vertical-align:top}
.eb th{cursor:pointer;user-select:none;font-size:.74rem;text-transform:uppercase;letter-spacing:.03em;color:#57606a;white-space:nowrap}
.eb th:hover{color:#1f2328}
.eb th.act::after{content:" ▾";opacity:.6}
.eb td.ev{font-weight:600}
.eb .note{color:#57606a;font-size:.82rem}
.eb .num{text-align:right;font-variant-numeric:tabular-nums;white-space:nowrap}
.eb .pos{color:#9a6700}.eb .neg{color:#1a7f37}
.sb-cell{display:inline-flex;align-items:center;gap:.3em;white-space:nowrap}
.sb-ic{font-size:.82em}.sb-vl{font-weight:700}.sb-lb{opacity:.9}
.sb-ok .sb-ic{color:#1a7f37}.sb-watch .sb-ic{color:#9a6700}.sb-stale .sb-ic{color:#cf222e}.sb-unwired .sb-ic{color:#6e7781}
@media (prefers-color-scheme:dark){
 .eb{color:#e6edf3}.eb .sub,.eb th,.eb .note{color:#8b949e}
 .eb th:hover,.eb th.act{color:#e6edf3}.eb th,.eb td{border-color:#30363d}
 .eb .pos{color:#d29922}.eb .neg{color:#3fb950}
 .sb-ok .sb-ic{color:#3fb950}.sb-watch .sb-ic{color:#d29922}.sb-stale .sb-ic{color:#f85149}.sb-unwired .sb-ic{color:#8b949e}
}
"""

def _num(v, unit="", pos_is_bad=True):
    if v == 0: return f'<td class="num">0{unit}</td>'
    sign = "+" if v > 0 else ""
    cls = ("pos" if v > 0 else "neg") if pos_is_bad else ("neg" if v > 0 else "pos")
    return f'<td class="num {cls}">{sign}{v}{unit}</td>'

def render(rows, skill, iterlabel, primary, baseline):
    rows = sorted(rows, key=_sort_key)
    pa = sum(r["a"]["passed"] for r in rows); ta = sum(r["a"]["total"] for r in rows)
    pb = sum(r["b"]["passed"] for r in rows); tb = sum(r["b"]["total"] for r in rows)
    ndiv = sum(1 for r in rows if r["pass_div"] or r["art_div"])
    head = (f'<h3>{html.escape(skill)} — eval boxscore</h3>'
            f'<div class="sub">{html.escape(iterlabel)} · {len(rows)} evals · '
            f'<b>{primary}</b> {pa}/{ta} pass · <b>{baseline}</b> {pb}/{tb} pass · '
            f'{ndiv} row(s) diverge. Sorted: divergences &amp; failures first — click any header to re-sort.</div>')
    ths = ['EVAL', f'{primary}', f'{baseline}', 'PASS≠', 'BEHAVIOUR≠', 'Δ time', 'Δ tok', 'what differs']
    thr = "".join(f'<th data-k="{i}">{html.escape(t)}</th>' for i, t in enumerate(ths))
    trs = []
    for r in rows:
        div = 1 if (r["pass_div"] or r["art_div"]) else 0
        fail = 1 if (r["a"]["total"] and r["a"]["passed"] < r["a"]["total"]) else 0
        sort_meta = f'data-s0="{div}" data-s1="{fail}" data-s2="{abs(r["d_tok"])}"'
        tds = [
            f'<td class="ev" data-v="{html.escape(r["eval"])}">{html.escape(r["eval"])}</td>',
            f'<td data-v="{r["a"]["passed"]}">{_badge(r["a"]["passed"], r["a"]["total"])}</td>',
            f'<td data-v="{r["b"]["passed"]}">{_badge(r["b"]["passed"], r["b"]["total"])}</td>',
            f'<td data-v="{1 if r["pass_div"] else 0}">{_dv(r["pass_div"], "diverge")}</td>',
            f'<td data-v="{1 if r["art_div"] else 0}">{_dv(r["art_div"], "diverge")}</td>',
            _num(r["d_secs"], "s"),
            _num(r["d_tok"]),
            f'<td class="note" data-v="{html.escape(r["note"])}">{html.escape(r["note"]) or "—"}</td>',
        ]
        trs.append(f'<tr {sort_meta}>' + "".join(tds) + '</tr>')
    js = """
<script>
(function(){
 var t=document.currentScript.previousElementSibling; if(!t||t.tagName!=='TABLE')t=document.querySelector('.eb table');
 var tb=t.tShow=t.tBodies[0];
 t.querySelectorAll('th').forEach(function(th){th.addEventListener('click',function(){
   var i=+th.dataset.k, rows=[].slice.call(tb.rows);
   var asc=th._asc=!th._asc;
   t.querySelectorAll('th').forEach(function(x){x.classList.remove('act')});th.classList.add('act');
   rows.sort(function(a,b){
     var x=a.cells[i].dataset.v, y=b.cells[i].dataset.v;
     var nx=parseFloat(x),ny=parseFloat(y);
     if(!isNaN(nx)&&!isNaN(ny)){return asc?nx-ny:ny-nx;}
     return asc?(''+x).localeCompare(y):(''+y).localeCompare(x);
   });
   rows.forEach(function(r){tb.appendChild(r);});
 });});
})();
</script>"""
    return (f'<style>{CSS}</style><div class="eb">{head}'
            f'<table><thead><tr>{thr}</tr></thead><tbody>{"".join(trs)}</tbody></table></div>{js}')

def main():
    ap = argparse.ArgumentParser(description="render a sortable eval boxscore from a skill-creator iteration dir")
    ap.add_argument("iterdir")
    ap.add_argument("--skill", default="skill")
    ap.add_argument("--primary", default="with_skill")
    ap.add_argument("--baseline", default="without_skill")
    ap.add_argument("--label", default=None)
    a = ap.parse_args()
    rows = collect(a.iterdir, a.primary, a.baseline)
    label = a.label or os.path.basename(os.path.normpath(a.iterdir))
    sys.stdout.write(render(rows, a.skill, label, a.primary, a.baseline))

if __name__ == "__main__":
    main()
