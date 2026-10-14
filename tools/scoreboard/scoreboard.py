#!/usr/bin/env python3
# scoreboard.py — render a thin, legible garden-state band ("cite-status").
# STDLIB ONLY. A reusable UI gadget: feed it cells, it emits a self-contained
# HTML band you can paste anywhere (chat widget, a page, an email).
#
# Design contract (Corwin, 2026-09-02):
#   * thin subtle band; ~normal-height text; 0.24em top/bottom margin(padding).
#   * a label sits next to things that are not label, so state is readable
#     even when the indicator COLOUR changes. State is carried THREE ways at
#     once — colour, SHAPE (glyph), and a text word — so colour is never
#     load-bearing alone (colour-blind / theme / low-vision safe).
#   * honest absence: an unwired cell shows a hollow grey marker + "unwired",
#     never a fabricated number (report the absence of an instrument).
#
# Usage:
#   echo '[{"label":"SEAT","value":"98","state":"ok"}]' | python3 scoreboard.py
#   python3 scoreboard.py --demo
#   python3 scoreboard.py --cells cells.json --title "GARDEN"
#
# Cell:  {"label": str, "value": str, "state": "ok|watch|stale|unwired",
#         "note": optional str (tooltip)}
import sys, json, html, argparse

# state -> (glyph SHAPE, text WORD, light colour, dark colour)
# colours chosen for >=4.5:1 on the band grounds in each theme.
STATES = {
    "ok":      ("●", "ok",      "#1a7f37", "#3fb950"),  # ● filled circle
    "watch":   ("◆", "watch",   "#9a6700", "#d29922"),  # ◆ diamond
    "stale":   ("■", "stale",   "#cf222e", "#f85149"),  # ■ square
    "unwired": ("◇", "unwired", "#6e7781", "#8b949e"),  # ◇ hollow diamond
}

def _cell_html(c):
    st = c.get("state", "unwired")
    glyph, word, _lc, _dc = STATES.get(st, STATES["unwired"])
    label = html.escape(str(c.get("label", "")))
    value = html.escape(str(c.get("value", "")))
    note  = html.escape(str(c.get("note", "")))
    title = f'{label}: {word}' + (f' — {note}' if note else '')
    # glyph carries colour(class) + shape(char); label+value carry text;
    # the hidden word carries state for screen readers.
    return (
        f'<span class="sb-cell sb-{st}" title="{title}" role="listitem">'
        f'<span class="sb-ic" aria-hidden="true">{glyph}</span>'
        f'<span class="sb-lb">{label}</span>'
        f'<span class="sb-vl">{value}</span>'
        f'<span class="sb-sr">({word})</span>'
        f'</span>'
    )

CSS = """
.sb-band{--bg:#f3f4f6;--fg:#1f2328;--edge:#d0d7de;
  display:flex;flex-wrap:wrap;align-items:center;gap:.15em .5em;
  font:0.9rem/1.2 ui-sans-serif,system-ui,-apple-system,Segoe UI,Roboto,sans-serif;
  color:var(--fg);background:var(--bg);border:1px solid var(--edge);
  border-radius:999px;padding:.24em .8em;width:max-content;max-width:100%;
  box-sizing:border-box}
.sb-ttl{font-weight:700;letter-spacing:.04em;opacity:.7;font-size:.78em;
  text-transform:uppercase;margin-right:.15em}
.sb-cell{display:inline-flex;align-items:center;gap:.32em;padding:.02em .18em;
  white-space:nowrap}
.sb-ic{font-size:.82em;line-height:1;transform:translateY(-.02em)}
.sb-lb{opacity:.85}
.sb-vl{font-weight:700}
.sb-sr{position:absolute;width:1px;height:1px;overflow:hidden;clip:rect(0 0 0 0)}
.sb-sep{opacity:.3}
.sb-ok  .sb-ic{color:#1a7f37}
.sb-watch .sb-ic{color:#9a6700}
.sb-stale .sb-ic{color:#cf222e}
.sb-unwired .sb-ic{color:#6e7781}
@media (prefers-color-scheme:dark){
  .sb-band{--bg:#161b22;--fg:#e6edf3;--edge:#30363d}
  .sb-ok  .sb-ic{color:#3fb950}
  .sb-watch .sb-ic{color:#d29922}
  .sb-stale .sb-ic{color:#f85149}
  .sb-unwired .sb-ic{color:#8b949e}
}
"""

def render(cells, title=None, embed_css=True):
    inner = []
    if title:
        inner.append(f'<span class="sb-ttl">{html.escape(title)}</span>')
    inner.append('<span class="sb-sep">|</span>'.join(_cell_html(c) for c in cells))
    band = f'<div class="sb-band" role="list" aria-label="{html.escape(title or "status")}">{"".join(inner)}</div>'
    if embed_css:
        return f'<style>{CSS}</style>\n{band}\n'
    return band

DEMO = [
    {"label": "MEM·auto", "value": "84", "state": "ok",      "note": "notes in auto-memory"},
    {"label": "MEM·seat", "value": "98", "state": "ok",      "note": "durable seat notes"},
    {"label": "SYNC",     "value": "diff?", "state": "watch", "note": "live hash-diff not run this session"},
    {"label": "SKILLS",   "value": "21", "state": "ok",      "note": "AS4CE0001/skills"},
    {"label": "DRIFT",    "value": "cyc2·DONE", "state": "ok", "note": "drift ledger 2026-09-01"},
    {"label": "WIRE",     "value": "offline", "state": "unwired", "note": "no instrument — keeper decision"},
]

def main():
    ap = argparse.ArgumentParser(description="render a garden-state band")
    ap.add_argument("--demo", action="store_true", help="render the built-in demo cells")
    ap.add_argument("--cells", help="path to a JSON array of cells")
    ap.add_argument("--title", default="GARDEN")
    ap.add_argument("--no-css", action="store_true", help="omit the <style> block")
    a = ap.parse_args()
    if a.demo:
        cells = DEMO
    elif a.cells:
        cells = json.load(open(a.cells, encoding="utf-8"))
    else:
        raw = sys.stdin.read().strip()
        if not raw:
            ap.error("no cells: pass --demo, --cells FILE, or pipe JSON on stdin")
        cells = json.loads(raw)
    sys.stdout.write(render(cells, title=a.title, embed_css=not a.no_css))

if __name__ == "__main__":
    main()
