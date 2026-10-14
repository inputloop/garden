produced-by: Mentat (for Corwin; claude-opus-5-5), fixer FG (QA pass 1 -> fixes) - 2026-10-08
licence: CC-BY-SA-4.0 - subject: Tavern / garden-pony, FOLD-QA1 rows 6-12
work folder: $HOME/mnt/projects/garden-pony/ (nothing written in $HOME/mnt/Bryant or upstream/)

# FG hand-back: garden-pony fixes after QA pass 1

## What we handled
1. Row 6, VERSION. tavern.py now says `VERSION = "2.3.1+gp.1"`. Every use was read (grep VERSION):
   display, HOWTO text, setup batch echo, web user agent, MCP serverInfo, share_source note, selftest
   strings, run.json, /api ping. None parses it as numbers. The peer handshake compares PROTO only
   (tavern.py `if hi.get("proto") != PROTO`; `ver` is only stored for display). The profile event
   allows `ver` up to 16 characters; "2.3.1+gp.1" is 10. Share source now posts
   "#source Tavern 2.3.1+gp.1". gp-check K7 (stock 2.3.1 peer) GREEN.
2. Rows 7, 8, Tools tab. Every Tools button has an id (reg-register, reg-rank, reg-approve-NAME,
   reg-share-NAME, reg-revoke-GRANT, reg-adopt-DROP, reg-refresh; the rank box is reg-q).
   renderView, only on the Tools tab, notes the focused element's id before the redraw and calls
   regRefocus(id) after: the same control again, or the status line (#regsays, now tabindex -1) when
   that control is gone (a revoked row has no Revoke button). "Share in Drops" is now named
   "Share in Drops: NAME. Other machines ..."; "Copy to my tools" (not tested by B1) had the same
   fault and is now "Copy to my tools: TOOL from WHO, not approved".
3. Row 12, Bryant's pre-existing a11y, in reach (D5). LIST FOR BRYANT, each change to his code:
   a. GUI_JS renderRoom: `el("nav", { class: "tabs", role: "tablist" })` became
      `el("nav", { class: "tabs", "aria-label": "Rooms and views" })`.
   b. GUI_JS renderTabs: rooms go into `div.tabgroup role=tablist aria-label=Rooms`, the views
      (DMs ... Settings) into `div.tabgroup role=tablist aria-label=Views`; the "+" button and the
      separator are appended to the nav between them, outside both lists.
   c. GUI_CSS: `.tabs .tabgroup { flex: none; display: flex; gap: 2px; }` keeps the row as it was
      (screenshots of before and after look the same), and a `.vh` visually-hidden class.
   d. GUI_HTML: `<h1 class="vh">Tavern: a common room for people and agents</h1>` first in the header.
   e. Five of his lines got a trailing `# sb:allow: ...` comment (item 5).
4. Rows 9, 10. README.org and NEWS rewritten from what was run (2.3.1+gp.1 entry; the 2.3.1+gp line
   that claimed keyboard + labels complete now says what the browser found and that gp.1 fixed it;
   an "Accessibility: what was checked" section with what was not). INSTALL lists patch 03 and
   scan.sh. REUSE.toml covers tests/browser/*.mjs (code), tests/browser/RESULT*.txt and
   NOTICE-upstream (CC-BY-SA-4.0). `reuse lint` compliant.
5. Row 11, secrets scan. NOTICE-upstream pins upstream/tavern-2.3.1.py by sha256 in pn1ck's line
   form (`pn1ck check .` reads it: 1 pin, all match). tests/scan.sh checks the pin, then runs
   sb1rn (c4/bin or AS4CE0001/bin, or SB1RN=) over every other file. The five token lines in
   tavern.py carry `sb:allow` (both checkers honour the marker: sb1aw:169, sb1pl:92), each saying
   why: they make a fresh random token at start or write it to a private file; no value is in the
   file. The scanner is untouched. One rule of our own, said in the output: a patch's REMOVED ("-")
   line that is word for word a line of the pinned file is blanked in a scratch copy before the
   scan (patch 03 removes Bryant's five lines to add the notes, so the patch carries them). Added
   lines and other removed lines are read as usual. --prove-red plants three faults: a byte in the
   pinned file, a secret-shaped line in SPEC.md, and one as a removed line of patch 03.
   c4/c/names gained `garden-pony-scan  gp1sn  ../projects/garden-pony/tests/scan.sh  ...`.
6. Patches: 01 and 02 unchanged (same sha256 as before); patches/03-a11y-version.patch (249 lines)
   on top of 02. Selftest gained _selftest_page_a11y, 3 checks read from the page text: each Tools
   button's spoken name starts with its words; each has an id and the refocus call is there; the tab
   lists hold only tabs, the "+" is appended to the nav, and GUI_HTML has an h1.
7. The browser kit now writes RESULT.txt itself (env RESULT= to put it elsewhere): line 1 is
   GREEN, RED or BROKEN from its own checks, then file sha256, kit sha256, environment and every
   check line. B1's hand-written note is kept as RESULT-2026-10-08-B1-RED.txt; the kit's run on
   the pre-fix file is kept as RESULT-2026-10-08-FG-before-RED.txt.
8. ChangeLog entry (newest first; Bryant has no entry of his own here), AUTHORS updated, Bryant
   still first. SHA256SUMS now covers tavern.py, upstream, patches 01-03, the three kits, NOTICE.

## OBSERVED (commands and results)
- Before: tavern.py sha256 4b8ecbf0...c5a5. After: 0eb956f50ce32d93b0cd48476bfcd23b2f3c375c32aec5edd218505693f251d0.
- `PYTHONDONTWRITEBYTECODE=1 python3 tavern.py selftest` (cwd outside mnt) -> 167 checks, 0 failed,
  47.8 s, SELFTEST GREEN (before: 164).
- New checks prove red: run against GUI_JS with the old Share label -> FAIL; with the Refresh id
  removed -> FAIL; with the refocus call removed -> FAIL; with role=tablist back on the nav and no
  h1 -> FAIL (python, scratch copy).
- `node --check` on the generated GUI_JS: OK. Every line ASCII; longest line 765 characters.
- upstream + 01 + 02 + 03 with `patch -p1` -> cmp identical to tavern.py ("REPRODUCES").
- `sh tests/gp-check.sh` -> 14 passed, 0 failed, GREEN, K7 PASS "a stock Tavern 2.3.1 peer joins,
  links and takes the #tool drop and the marked lines, refusing nothing".
- `sh tests/gp-check.sh --prove-red --no-stock` -> 8 passed, 5 failed, "PROVE-RED OK", exit 0.
- Browser, cloud (Chromium 141.0.7390.37, Playwright 1.56.0, axe-core 4.14.0, Node 22.22.0),
  `node tavern-tools.browser.mjs tavern.py` on the staged fixed file (sha 0eb956f5...):
  35 passed, 0 failed, "TAVERN TOOLS BROWSER GREEN", exit 0. Focus after Register -> BUTTON:Register;
  after Approve -> BUTTON:Approve; after Refresh -> Refresh; after Revoke -> DIV "Revoked alpha's
  appr..." (the status line). axe page scan: no critical/serious; one moderate heading-order
  `.sec > h3`.
- Same kit on the pre-fix file (patch 03 reversed in the cloud, sha 4b8ecbf0...): 7 failed, RED:
  4 focus-on-body, label-content-name-mismatch x3 scans, critical aria-required-children [nav],
  moderate page-has-heading-one.
- RESULT.txt sha256 ac175640eeb83d4c678bee6e1b1a013fb5c36e23ac02fad44ce9f47c5746237f in the cloud
  and on the device (sha256sum both sides); first line GREEN. Before-RED copy 388c0c75...a62f both sides.
- `sh tests/scan.sh` -> PIN OK upstream (6ffaa566...), 8/33/9 removed lines in patches 01/02/03 are
  pinned bytes, `sb: clean; read 24 ... allowed 14`, scan: CLEAN, exit 0. Before any of this:
  sb1rn on the tree -> 10 hits in 2 files. First scan after patch 03 (before the removed-line rule)
  -> 5 hits, all in patch 03's "-" lines.
- `sh tests/scan.sh --prove-red` -> "PROVE-RED OK: all three planted faults went red".
- `sh AS4CE0001/bin/pn1ck check .` -> 1 pin, all match. `$HOME/rv/bin/reuse lint` -> compliant
  (first try failed: "CC-BY-SA-4.0." with a trailing period in NOTICE; fixed).
- `sha256sum -c SHA256SUMS` -> 9 OK. No __pycache__ or .pyc. upstream/ mtime 06:50, sha 6ffaa566.

## JUDGED
- [MINE] Focus restore is scoped to the Tools tab. Bryant's other tabs may lose focus the same way
  (B1's falsifier was never run). Falsifier: press a button by keyboard on Tasks or Drops; if focus
  stays, nothing more to do. If it drops, the same 3-line pattern fits renderView for every tab.
- [MINE] The removed-line rule in scan.sh is ours, not the scanner's. It only blanks a "-" line that
  matches a line of a file whose pin matched; prove-red shows a secret-shaped removed line that is
  not in the pinned file still goes red. Falsifier: Corwin rules patches must be scanned raw (then
  pin the patches' removed hunks some other way, or accept 5 hits by name).
- [DOMAIN] The heading-order note (moderate) appeared because the new h1 exposes Bryant's side-panel
  h3s with no h2. Not fixed: changing them to h2 changes his CSS. Falsifier: his CSS styles .sec h3
  only by class, so h2 would look the same.
- [MINE] The version label "2.3.1+gp.1" is ours to set; the scheme for forks stays Bryant's.
- [PLATFORM] scan.sh finds sb1rn two folders up (F:\claude\c4 or AS4CE0001). A clone elsewhere
  says "NOT CHECKED: sb1rn not found" (exit 2), never clean.

## Not done / left
- No real screen reader, no Windows browser, Offered table/"Copy to my tools" still untested in a
  browser (needs two machines); the label fix there is read, not run.
- The browser kit still needs axe-core installed beside it (not vendored).
- No git repos (row 20+ are other builders' work).

## PENDING FOR BRYANT
1. The a11y changes to his code, list 3a-3e above: take, change or drop.
2. Heading order in the side panel (moderate).
3. How forks of Tavern should be named; we used 2.3.1+gp.1.
4. Items 1 and 3-8 of 23-G1 PENDING FOR BRYANT still stand (item 2, VERSION, is now handled).
