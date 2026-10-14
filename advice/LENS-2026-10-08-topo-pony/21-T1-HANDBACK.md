produced-by: builder T1 (Mentat, for Corwin; claude-opus-5-5) · TopoForge "the drawing tells its own story" · 2026-10-08
licence of this note: CC-BY-SA-4.0

# T1 hand-back — TopoForge 1.6, the story feature

## What we handled (lead)

1. **Lasting handles (D1).** Every shape and connector gets `data.tf_ref` (e.g. `firewall-fw01`, `link-gwfw`)
   the moment it exists, stamped inside `reindex()`, so it rides the user's own edit: **no extra undo step**
   (the design's [MINE] worry is gone). Broken, missing or repeated handles are replaced; the first holder
   on a page keeps its handle. Kept through TopoForge's JSON, draw.io and .vsdx export + import.
2. **Facts layer.** `factsOf(doc)` (pure) writes FACTS v=1 lines; grammar in `spec/FACTS-v1.md` (plain words,
   examples, the v1 reading rule "ignore unknown kinds and keys").
3. **Story.** `storyOf(facts)` builds sentences only from the facts, each ending `[refs]`; FACT vs GAPS; banned
   judgement words; user words quoted and Markdown-escaped (new lines as `\n`, backticks, `#`, `[ ]` …);
   a fresh fence word per export (`facts-xxxx`); header line 3 carries sha256 of the drawing JSON and of the
   facts block (crypto.subtle, with a built-in SHA-256 fallback so it works from file:// anywhere).
4. **UI.** New **Story** tab (live, same 600 ms debounce as autosave), says it is a text alternative for the
   drawing; ref buttons select the shape; "Recent changes" (max 9 rows, newest on top) plus a visually
   hidden `role=status aria-live=polite` line that announces what changed; **Download story (.md)** button
   and **File › Export › Story in words (.md)**. The download saves the `.json` and the `-story.md` together
   (the story names that exact JSON by sha256).
5. **Accessibility fixes within reach (D3/D5):** inspector tabs now follow the WAI-ARIA tabs pattern
   (`aria-selected`, `aria-controls`, `role=tabpanel`, roving tabindex, Left/Right/Home/End);
   Space/Enter/arrows on side-panel buttons are no longer swallowed by the canvas shortcuts (they were: Space
   started panning); visible focus rings.
6. **Licence/version:** SPDX comment at the very top of `index.html`; About shows **1.6**, the copyright line
   (Bryant first) and both "Written with Alfred … / story feature by Mentat …" credits; draw.io `agent=` now
   says 1.6; Formats help mentions Story.
7. **Test kit** `tests/` in **POSIX sh + jq** (the checker never runs JavaScript), fixtures, hand-written
   expectations, prove-red. Node harness only *produces* exports.
8. **Patch:** `patches/topoforge-1.5-to-1.6.patch` (598 lines, `diff -u` upstream vs working; applies clean).

## OBSERVED (commands and results, run in the linked computer's shell, cwd `$HOME/mnt/projects/topoforge`)

- `cmp index.html upstream/topoforge-1.5.html` before work: SAME. `sha256sum` upstream = Bryant's received file
  = `6a76e9ca…a9e2a` (unchanged; nothing written in `$HOME/mnt/Bryant` or `upstream/`).
- `sha256sum index.html` → `3aec5110…7b6cc` (3536 → 3999 lines). `patch < patches/topoforge-1.5-to-1.6.patch` on a
  copy of upstream → byte-identical to index.html (`cmp` silent).
- `sh tests/run.sh` → 10 steps GREEN, `KIT GREEN`, exit 0, 6.2 s:
  tables match index.html (51 types, NET_PROPS, LINK_PROPS); fixtures office (59 facts), office-later (62, with
  a change list), loose (17), forged (18), misc (58) all `AGREE`; jq vs hand-written `expect/loose.facts` and
  `expect/office.gaps`; prove-red; a planted wrong tier in index.html turns `--tables` red.
- `sh tests/prove-red.sh` → `PROVE-RED OK (14 cases)`: control green; delete one fact → red (K4 hash);
  delete one fact *and* re-fingerprint → red (K6 diff); flip Web1's parent DMZ→LAN → red (K3); flip + re-fingerprint
  → red (K6); move one shape, re-export JSON only → old story refused (K3, falsifier T4); judgement word "behind" →
  red (K8); ghost ref → red (K7); forged `## Gaps` heading → red (K9); unknown kind `FOO k=v` + unknown key → stays
  green (falsifier T6); forged fixture as exported → green with exactly 1 facts block; a planted second facts
  block → red (K2); dropping the LOOSE_IN_BOX gap → red (K6).
  First run of prove-red caught a hole in my own checker (a repeated but allowed `## Gaps` heading passed);
  fixed by checking section order; second run all OK.
- `node tests/harness/tf-node.js sha index.html` → `SHA OK 8 samples (built-in and crypto.subtle)` (built-in
  SHA-256 equals node's on empty, 55/56/64-byte edges, UTF-8 + emoji, 100 kB).
- `NODE_PATH=…/jsdom sh tests/regen.sh` round trips (TopoForge → format → TopoForge): handles **KEPT** in JSON,
  draw.io and .vsdx for all 5 fixtures; office facts **identical** after all three formats.
- `node tests/harness/ui-jsdom.js index.html` (jsdom, whole app booted): every sample shape has a handle; tabs
  `Properties:true:0 Layers:false:-1 Issues:false:-1 Story:false:-1`; End key moves focus and selection to Story;
  live region `role=status aria-live=polite`; clicking a ref selected that shape; renaming it announced
  `Story updated: "Internet" renamed "Renamed thing". And 1 more.`; duplicate kept handles unique; undo stack
  grew by exactly one per edit; both files downloaded; `TF_VERSION` 1.6; no script errors.

### Pre-existing behaviour the round trip surfaced (Bryant's import/export code; NOT changed by us)
- draw.io export turns spaces in custom-field names into `_` (`Asset tag` → `Asset_tag`).
- .vsdx: a connector custom field named `cable` does not come back (the importer reads names matching
  /medium|media|cable/ as the medium).
- draw.io and .vsdx flatten new lines and tabs in notes, page names and custom fields to spaces.
- .vsdx import re-parents a shape drawn loose inside a group box into that group, so a `LOOSE_IN_BOX` gap
  disappears after a Visio round trip (the picture/model disagreement is "fixed" silently on import).

## JUDGED

- [MINE] Stamping in `reindex()` is a write to the user's model without asking (seam N4/T-4). Corwin's D1 ruling
  covers it; it is visible in the Custom data panel. Falsifier: if Bryant finds `tf_ref` in the Custom data panel
  confusing, hide that one key from the panel (one line) — the data still rides.
- [MINE] One click saves two files (JSON + story). Chrome may ask once to "allow multiple downloads".
  Falsifier: if that prompt bites in use, offer the JSON hash only (story without its drawing) as a second button.
- [DOMAIN] The story follows the model, not the eye (LOOSE_IN_BOX says so out loud); Visio's import does the
  opposite (above). Both are defensible; they disagree.
- [SKILL] `ensureRefs` collision rule depends on array order (first holder keeps). A z-order change after a
  hand-edited duplicate could move a handle. Low risk; covered only by the misc fixture.
- U+2028/2029 in a value pass through fact lines raw (JSON and jq both leave them); the Markdown sentences
  escape them. Harmless for line tools; named in case a reader splits on them.

## Not tested (and how to test)
- **Visio 2010 on avalon** (the design's main falsifier): export office.json's drawing to .vsdx, open and save in
  Visio 2010, re-import; every `tf_ref` must come back. Only TopoForge→TopoForge .vsdx was run.
- A **real browser from file://** and a **real screen reader** (NVDA/Narrator): jsdom is not a browser.
  Hand-test: open index.html from disk, Story tab via keyboard (Tab to the tab row, Right arrow to Story),
  rename a shape, hear the change; File › Export › Story; then `sh tests/check.sh <name>.json <name>-story.md`
  → `AGREE`.
- Colour contrast of the ref buttons was reasoned (accent on panel-2), not measured.
- CSV import/export does not carry `tf_ref` (custom data via CSV not checked).

## Files (all under `$HOME/mnt/projects/topoforge/`)
- `index.html` (1.6) · `patches/topoforge-1.5-to-1.6.patch` · `spec/FACTS-v1.md`
- `tests/check.sh` (K1–K9, `--tables`), `tests/run.sh`, `tests/prove-red.sh`, `tests/facts.jq`, `tests/canon.jq`,
  `tests/tables.json`, `tests/expect/{loose.facts,office.gaps}`, `tests/fixtures/{src/,*.json,*.md}`
- `tests/regen.sh` + `tests/harness/tf-node.js` (node: re-export fixtures, SHA check, round trips) and
  `tests/harness/ui-jsdom.js` (needs jsdom on NODE_PATH; jsdom is not vendored).

## Pending for Bryant (we did not take these on)
1. The four import/export behaviours above (field-name underscores, `cable` read as medium, flattened new lines,
   Visio re-parenting).
2. Whether `tf_ref` should be hidden from the Custom data panel.
3. Whether the TopoForge→Visio 2010→TopoForge trip keeps `tf_ref` (needs avalon).
4. The Issues tab's findings are not in FACTS v1 (design choice, A §6); say if he wants an `ISSUE` kind in v2.
5. Coordination note for T2: `SHA256SUMS` was written at 07:04, before the final `index.html` (07:19);
   it does not list index.html today — if it should, regenerate after this hand-back.
