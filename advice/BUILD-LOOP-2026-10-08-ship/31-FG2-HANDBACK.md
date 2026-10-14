produced-by: claudewin (fixer FG2, Mentat for Corwin; claude-opus-5-5) - 2026-10-08
scope: FOLD-QA2 rows 1, 5, 8, 11, 12 in projects/garden-pony.  Tavern is Bryant Frankford's.

# FG2 hand-back

## Handled
- Row 12 (Bryant's code): presence and state events no longer drop keyboard focus.  New
  focusMark/focusBack in GUI_JS remember the focused control (id, then a data-fk key, then its
  words and place) and focus its twin after the rebuild.  Used in renderTabs, renderView (every
  view; Tools keeps its own regRefocus) and renderRoster (side panel).  Tab-row buttons got
  data-fk keys (room:<id>, view:<tab>, newroom).
- Row 8 (Bryant's code): side panel headings h3 -> h2 (4 places in renderRoster); CSS ".sec h3"
  -> ".sec h2".  Look unchanged (side-by-side screenshot of the panel, before/after: same heading
  size, case, colour, spacing).  axe now reports no violations at all on the Tools and Settings pages.
- Row 1: .gitignore licensed via REUSE.toml (code row) plus a comment line; ignores out-*/ (the
  browser kit's default output).  reuse lint: compliant, 23/23.
- Row 11: tests/scan.sh, sb1rn missing -> one sentence: sb1rn is Corwin's secrets scanner, not in
  this repo and not published yet; it lives in c4/bin/sb1rn and AS4CE0001/bin/sb1rn; ask
  corwin@bru.st; put it two folders up, on PATH, or SB1RN=path.  Exit 2.  README.org says the same;
  INSTALL points to README.
- Row 5: SHA256SUMS now lists every file except .git/ and itself: 28 rows (was 9).  Made last.
- Docs: README.org, NEWS, ChangeLog (FG2 entry, Bryant named first), INSTALL (patch 04 step),
  AUTHORS ("four patches"; Bryant first, unchanged order).

## Changes to Bryant's code (all in patches/04-focus-headings.patch, on top of 03)
1. GUI_JS: new FOCUSABLE, focusName, focusMark, focusBack (before renderTabs).
2. renderTabs: focusMark(nav) before clear, focusBack(nav, fm) at the end; data-fk on room tabs,
   view tabs and the "+" button.
3. renderView: `var fm = fid ? null : focusMark(v);` and `if (fid) regRefocus(fid); else focusBack(v, fm);`.
4. renderRoster: focusMark(side) before clear, focusBack(side, fm) before the scroll restore;
   the four `.sec` headings h3 -> h2.
5. GUI_CSS: `.sec h3 {` -> `.sec h2 {` (same declarations).
6. Header comment: the 2.3.1+gp.1 line now names these two fixes.
7. _selftest_page_a11y (ours): 3 new checks.  VERSION left at 2.3.1+gp.1 (not yet released;
   see JUDGED).

## OBSERVED (device shell unless marked cloud)
- upstream + patches 01..04 (`patch -p1`) -> sha256 60def82e...dfa4 = tavern.py.  01..03 alone ->
  0eb956f5... (the previous tavern.py).
- `PYTHONDONTWRITEBYTECODE=1 python3 tavern.py selftest` -> "170 checks, 0 failed, 47.7s",
  SELFTEST GREEN.
- New selftest checks on the patch-03 page text (new _selftest_page_a11y, old GUI_JS/HTML/CSS):
  the 3 new checks FAIL, the 3 old ones PASS.
- `sh tests/gp-check.sh` -> 14 passed, 0 failed, GREEN.  `--prove-red` -> PROVE-RED OK (8/6).
- `sh tests/scan.sh` -> 28 files, "sb: clean ... allowed 14", CLEAN.  `--prove-red` -> PROVE-RED OK.
- Copy without sb1rn nearby ($HOME/fg2/clone/gp): `sh tests/scan.sh` -> PIN OK, then the
  NOT CHECKED sentence, exit 2.
- `$HOME/rv/bin/reuse lint` -> compliant (23/23).  `sha256sum -c SHA256SUMS` -> 28 OK, 0 not OK.
- Every changed/new file: 0 non-ASCII bytes, 0 lines of 2000+ characters.  No new wire kind or field.
- Cloud browser kit (Chromium 141.0.7390.37, Playwright 1.56.0, axe-core 4.14.0), kit sha256
  bfd06e0e...7339, 40 checks (5 new: presence redraw keeps focus on the Tools tab / first
  Settings button / a person in the side panel, each also proving the node was replaced;
  side headings h2; axe on Settings):
  - patch-03 file 0eb956f5...: RED, 36 passed, 4 failed -> tests/browser/RESULT-2026-10-08-FG2-before-RED.txt
    (sha256 214a864d...f074, same on both sides).
  - new file 60def82e...: GREEN, 40/40 -> tests/browser/RESULT.txt (sha256 d0f0d180...e0a8, same
    on both sides).  The FG run's GREEN note kept as RESULT-2026-10-08-FG-GREEN.txt (renamed).
- `git status`: 12 modified, 3 new (patches/04-focus-headings.patch, the two RESULT notes).
  Nothing committed; .git untouched.

## JUDGED
- [MINE] VERSION stays 2.3.1+gp.1: nothing has shipped under that name, and row 6 (plugin's
  tavernface string) is matching it now.  Falsifier: 2.3.1+gp.1 was already handed to someone.
- [MINE] The focus fallback (same words nearest the old place, else the same place) can land on a
  neighbour when the control is gone; better than the page, not perfect.  Falsifier: a kit
  check where the focused control disappears and focus lands somewhere surprising.
- [PLATFORM] Not checked: a real screen reader, Windows browsers, two linked machines (the kit
  fires presence from a local agent, the same scheduleState path as a peer's).
- [MINE] I made, then removed, two strays inside garden-pony: an empty out-tavern/ (testing the
  ignore line) and __pycache__/ from `python3 -I` (which ignores PYTHONDONTWRITEBYTECODE).  Both
  gone before SHA256SUMS was made.

## Pending for Bryant
- Patch 04 is his to take or leave, like 01..03.  The handoff letter (row 2, not mine) should
  list it: focus kept across presence/state redraws; side panel h2.
