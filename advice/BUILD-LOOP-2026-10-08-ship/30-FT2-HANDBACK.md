produced-by: fixer FT2 (Mentat, for Corwin; claude-opus-5-5) · TopoForge, FOLD-QA2 rows 1, 8, 9, 10 · 2026-10-08
licence of this note: CC-BY-SA-4.0

# FT2 hand-back: TopoForge after QA pass 2

## What we handled
1. Row 1, licence lint. `.gitignore` now opens with SPDX lines (CC-BY-SA-4.0, Bryant first in the
   copyright line). It also ignores `dist/` (where bin/ship.sh writes the tarball) and `out-*/` (where
   the browser kit writes its scans). `reuse lint` is clean again: 47 of 47 files.
2. Row 8, heading order. The panel headings are now h2 (they were h3 under the page's h1). In the Story
   tab, "Recent changes" and the page line are h2, and the story's sections are h3 (they were h3 and h4).
   The CSS selectors moved with the tags (`.sec h2`, `.story h2`, `.story h3`), so the page looks the same.
   22 lines changed in index.html. The jsdom harness now reads the story headings as h2 and h3.
   The browser kit has a new check: "headings do not skip a level". It is red if any axe scan reports
   heading-order.
3. Row 9, ChangeLog. A GNU-style entry for builder T1's 1.6 Story work (tf_ref and ensureRefs, FACTS v=1
   and spec/FACTS-v1.md, storyOf and changesOf, the Markdown export with sha256 lines, the Story tab, the
   tests/ kit, the patch). It sits after the FT entry and before T2's. Plus an FT2 entry for this pass, at
   the top. The import entry for Bryant's 1.5 stays at the bottom, as the first event in the history.
4. Row 10, README. A new section, "Check it in a real browser". It says what to install
   (`npm i playwright axe-core`, `npx playwright install chromium`), gives the exact command and the
   PW_MODULE/AXE/CHROMIUM/RESULT settings, and explains how to read RESULT.txt (GREEN or RED on the first
   line, the sha256 of the tested index.html that ship.sh needs, which axe levels fail a check, and the
   exit codes 0/1/2). The kit's header comment now says what the code does. The code also changed in a
   small way, to match the README: it looks for ./node_modules/playwright first, and when there is no
   /opt/pw-browsers/chromium it lets Playwright use its own Chromium.
   README and NEWS no longer list the heading finding as open. NEWS now says the kit passes 34 checks.

## OBSERVED (commands and results)
- Device: `git diff --stat index.html` gives 22 lines in and 22 out. Sha256 of index.html went from 681cac2e... to
  779c5383fe359876364ff7e54b2782a105e933d5fed9a5a16d3c1ea9396be856.
- Cloud (Chromium 141, Playwright 1.56.0, axe-core 4.14.0): I staged index.html, upstream and the kit, then ran
  `AXE=.../axe.min.js node tests/browser/topoforge.browser.mjs index.html out` -> TOPOFORGE BROWSER GREEN,
  exit 0, 34 of 34 checks. All seven axe scans report "no violations" (before this pass each one showed a
  moderate heading-order finding).
- Prove-red (cloud): I made a copy with one panel heading put back to h3 ("Document"). The kit went RED, exit 1,
  failing only on "headings do not skip a level :: main:heading-order, main-dark:heading-order".
- RESULT.txt was copied back with device_commit_files. Its sha256 is baef6072d50fd613452bdb3f39aaa3257e59810631f23cc0aac9a1fdbd387c71
  in the cloud and on the device. Its "File tested" line has 779c5383..., which matches index.html.
- Cloud: `npm i jsdom` in scratch, then `node tests/harness/ui-jsdom.js index.html` -> "story headings: Page 1 of 1:
  ... | Outside in | Groups | Connections | Gaps ...", errors: [], exit 0.
- Patch: `diff -u --label topoforge-1.5/index.html --label topoforge-1.6/index.html upstream/... index.html`.
  This method rebuilds HEAD's old patch byte for byte (cmp silent). The new patch has 827 lines, sha256 37530777....
  `patch` on a copy of upstream gives index.html exactly (cmp silent).
- `sh tests/run.sh` -> KIT GREEN, exit 0. `sh tests/prove-red.sh` -> PROVE-RED OK (14 cases). `sh bin/test.sh`
  -> exit 0 (it includes the project-files kit, which shows 4 planted faults).
- `sh bin/sums.sh` was run last -> 51 files. Then `sh bin/verify.sh` -> both OK, exit 0. `reuse lint` -> exit 0,
  compliant. `git check-ignore -v dist/x out-topoforge/x` -> both are matched by the new lines.
- `git status --short`: 10 modified files. Nothing was committed and .git was not touched. upstream/ and Bryant/ were
  not written. There is no __pycache__ and no out-* folder in the tree.

## JUDGED
- [MINE] Changing h3 to h2 alters Bryant's markup in 16 panel builders. Unlike FT's earlier fixes, this is not
  a CSS-only change, so it goes on Bryant's list (below). Falsifier: if Bryant's own CSS anywhere else targets
  `h3` inside .sec, the look would change. A grep finds none, and the axe and harness runs show nothing broken,
  but no one has compared the look side by side with a screenshot.
- [MINE] The kit's code change (playwright/Chromium lookup) is a small widening, not only a comment fix.
  Falsifier: on a receiver's machine `node topoforge.browser.mjs` still exits 2 after `npm i playwright axe-core`
  and `npx playwright install chromium`. I did not test that on a clean machine. The cloud run used /opt paths.
- [DOMAIN] Heading order has its own check now, so a moderate finding can turn the kit red. Every other
  moderate finding is still only listed.

## Not done
- No commit (by your instruction). The main session will rebuild the history.
- No `bin/ship.sh` run: it would write dist/, and that folder is now ignored anyway.
- The rows of FOLD-QA2 that belong to Tavern (rows 1 and 8 for garden-pony, and 2-7, 11-14) were not touched.

## Pending for Bryant (add to his hand-off)
- His panel and Layers headings are now h2, not h3, with the matching `.sec h2` selector. The page looks the same.
  This is the fix for the axe heading-order note.
