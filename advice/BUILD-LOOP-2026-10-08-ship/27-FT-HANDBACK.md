produced-by: fixer FT (Mentat, for Corwin; claude-opus-5-5) · 2026-10-08
licence of this note: CC-BY-SA-4.0

# FT hand-back: TopoForge fixes from QA pass 1 (FOLD-QA1 rows 1-5) and B1's browser findings

## What we handled (all in projects/topoforge; nothing written in Bryant/ or upstream/)
1. Story hint contrast (row 1): #storyAbout now uses --text-2.
2. Bryant's 1.5 accessibility faults (row 5, in reach per D5):
   - the menubar role
   - unlabelled document and inspector fields and selects
   - faint grey text
   - custom-data boxes named by tooltip only
   - while there: no h1
   All fixed. The list for Bryant is below.
3. README.org and NEWS (row 2) now describe 1.6 from what was checked. No stale "in progress" or "not checked" lines are left.
4. Release (row 3): the ship list, and so SHA256SUMS and the tarball, now include tests/ (with tests/browser/), spec/ and patches/. ship.sh also refuses to pack unless tests/browser/RESULT.txt says GREEN for the exact index.html being shipped.
5. REUSE (row 4): tests/browser/RESULT.txt and tests/fixtures/*.md are now CC-BY-SA-4.0. `reuse lint` is clean.
6. The browser kit now writes RESULT.txt itself, with a computed first line. It was rerun on the fixed file and came back GREEN, 33 of 33.
7. The patch was regenerated and reproduces index.html. run.sh, prove-red.sh and verify.sh are all green.
8. ChangeLog (GNU style, 2026-10-08) and AUTHORS are updated.

## OBSERVED (commands and results)
- Before: index.html sha256 3aec5110...27b6cc, the same file B1 tested.
- After: index.html sha256 681cac2e9017a11339720f9fae106a3f0d383601283445b2ed07b8012386355e.
- Contrast, computed with the WCAG formula (python, $HOME/cr.py):
  - Before, --text-3 #8a93a1 (light): 3.10 on #fff, 2.97 on #f8fafc, 2.82 on #f3f4f6. Dark #6f7885: 3.90 on #171a1f, 3.66 on #1c2026.
  - After, light --text-3 #646d7a: 5.24 on #fff, 5.00 on #f8fafc, 4.76 on #f3f4f6, 4.62 on hover #eef1f5.
  - After, dark --text-3 #868f9c: 5.33 on #171a1f, 5.00 on #1c2026, 5.78 on #0f1115, 4.58 on hover #222730, 5.50 on canvas #14171b.
  - #storyAbout uses --text-2. Light #5b6472: 5.98 on white. Dark #a3abb7: 7.53 on #171a1f.
- Browser kit, cloud workspace: Chromium 141.0.7390.37, Playwright 1.56.0, axe-core 4.14.0 (npm in scratch), node 22.22.0.
  - On the fixed file: exit 0, "33 checks passed, 0 failed", first line GREEN.
  - axe finds no critical or serious problem in main, props-selected or story-panel, in light or dark. One moderate is left: heading-order.
- Prove-red for the kit: the pre-fix file was rebuilt from upstream plus the OLD patch (it reproduced sha 3aec5110...). On it the same kit gave:
  - exit 1, first line RED, 9 FAIL
  - critical aria-required-children #menubar; serious color-contrast x8; #storyAbout contrast in both themes; both menu-button checks
  - Copy: 27-FT-RESULT-prefix-prove-red.txt (sha256 4d631e63...).
- RESULT.txt copied back to tests/browser/RESULT.txt. sha256 d7f062ae055ff6df9a44b4eeed5e9692a4d19d29d8e87b55b6a725904400bc14 on both sides, and its "File tested" line names 681cac2e....
  - The first commit attempt wrote a STALE copy (bee717..., from run 1), even though the outputs file had already been replaced. Re-staging under a new name fixed it.
  - [PLATFORM] Falsifier: a commit from a reused staged path matches the new bytes.
- Kit sha256: 18d3bf54255d6dbb5bcc2181344deb5179090d96e51854375fb1c2cc7be1492d.
- Patch: `diff -u --label topoforge-1.5/index.html --label topoforge-1.6/index.html upstream/topoforge-1.5.html index.html`.
  - sha256 a1dfc972c7b3ab1de5dec59896f24cdc12d10731ef867bafab8924d3d18ec236.
  - `patch -p1` onto a copy of v1.5 gives 681cac2e..., byte-equal to index.html.
- In the project folder: run.sh=0 (KIT GREEN), prove-red.sh=0 (PROVE-RED OK, 14 cases), verify.sh=0, bin/test.sh green, `reuse lint` (reuse 6.2.0 from $HOME/rv) =0 (46/46 files).
- SHA256SUMS was regenerated last and covers 51 files, 30 of them under tests/, spec/ or patches/ (it was 21 files before).
- Unpacked-release test: tar was made from the SHA256SUMS list and unpacked in a temp dir. There verify=0 (51 files), tests/run.sh KIT GREEN, bin/test.sh=0, and tests/browser/ is present.
- ship.sh gate, tried as its own lines:
  - GATE-PASS on this tree.
  - GATE-REFUSE when index.html differs by one byte.
- `find -newer` shows only the files listed in the ChangeLog entry changed. No new junk.

## Changes for Bryant (to his 1.5 parts; behaviour and look otherwise kept)
1. `#menubar`:
   - role="menubar" removed and aria-label="Menus" added, so the File...Help buttons stay ordinary buttons.
   - Each button has aria-haspopup="menu" and aria-expanded, kept true while its menu is open.
   - Escape in a menu now returns focus to its button.
   - Chosen as the smaller correct change over full menubar arrow-key semantics.
2. Inspector fields:
   - `inp()` gives every field an id: `fld-` plus its data-path.
   - `row()` ties its visible label with `for=`. That covers Document name, Page, Grid size, New links, and every device, connector and container field and select.
   - The X/Y/W/H words are now `<label for>`. CSS `.mini label` is styled the same as `.mini span`.
3. Custom data:
   - Visible "Field name" and "Value" words now sit above the boxes and name them through aria-labelledby. The value is named "Value <field name>".
   - The X button is named "Remove field <name>".
   - Look change: one small header line, in the same grey.
4. `--text-3`: #646d7a light, #868f9c dark (was #8a93a1 and #6f7885). It is slightly darker or lighter, but still below --text-2.
5. `.brand` is now an `<h1>` styled exactly as the div was (margin 0 6px 0 0, font-size inherit). The page now has a top heading.

## JUDGED
- [MINE] Dropping the role is better than building a full menubar. It is less code, and the buttons were already reachable by Tab. Falsifier: a screen-reader user finds the plain button row harder to use than an arrow-key menubar.
- [MINE] Tab now needs 76 presses (it was 35) to reach the tab row. I think this is only where the kit starts: it now runs after the menu check, which leaves the browser's starting point at File, before the palette. Falsifier: run the B1 order (no menu check first) on the fixed file; it should give about 35 again.
- [DOMAIN] tests/fixtures/*.md are story documents the app writes, so I called them prose (CC-BY-SA). If Corwin calls them test data (code), drop them from the new REUSE row.
- [MINE] ship.sh now depends on a browser run made elsewhere, recorded by sha. It is a gauge: it cannot tell a real run from a hand-edited RESULT.txt. Falsifier: someone edits RESULT.txt by hand to read GREEN, and ship.sh still packs.
- [SKILL] The kit expects playwright at /opt/npm-tools and Chromium at /opt/pw-browsers by default (env vars change these). As written, it only runs in a workspace like the cloud one.

## Left (not done)
- One moderate axe finding remains: heading-order (h1, then the panel h3s). Changing them to h2 touches the `.sec h3` CSS everywhere; left for Bryant or the next pass.
- Not tried: a real screen reader, Windows browsers, and drawing or moving shapes by keyboard alone.
- No tarball was cut and nothing was signed. ship.sh was not run in the tree, because dist/ would be created and deleting is not permitted. Corwin runs `sh bin/ship.sh 1.6` and then signs.
- ChangeLog has no entry from builder T1 for the 1.6 story work. Not mine to write; noted.
