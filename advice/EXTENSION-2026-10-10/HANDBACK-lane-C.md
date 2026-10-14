# Hand-back, lane C (docs, licence and release), 2026-10-10

*The extension edition's lane C: tasks C1-C5 of `DESIGN-extension-edition.md` §3, the stale docs of
study S2 part B, and GRAMMARY. Nothing committed, minted, installed or signed.*

## Per task

| task | state | in one line |
|---|---|---|
| C1 licence | **done** (the carriers' re-carry is Corwin's) | TERMS block healed to v1.1 (writing CC-BY-SA-4.0; the TA model and published essays keep CC BY 4.0); `bin/lc1ck` and its Ruby spec |
| C2 release | **done** | `--news-reason`, `--prose-gates`, `--gauge` (NEWS lag); two new refusals; NEWS 1.0.2-1.0.5; Tcl spec |
| C3 README | **done** | count, server table, switches table and floor minted from `SERVERS`, `prefs.KNOWN`, `editions.FLOOR`; awk spec with a planted seventh server |
| C4 GRAMMARY | **done** | line 1 a made word; 41 new entries + 3 pointer entries for Bryant, every entry with "Whose word"; seed reworded; `bin/gm1gk`; local model read it first |
| C5 upgrades, hooks, NOTICE | **done** | `UPGRADES.md`, `polygram/hooks.md`, gauntlet NOTICE at v1.5, each with a test |
| stale docs (S2 B4) | **done** | README.org, INDEX.md, PROJECT.md, and the README template inside `plugin.py` |

## Files changed

- Edited: `GRAMMARY.md`, `NEWS`, `polygram/plugin.py`, `bin/release`, `tests/test_plugin.py` (one
  line), `README.org`, `INDEX.md`, `PROJECT.md`, `SOFT-SKILLS/gauntlet/NOTICE.md` (one word),
  `c4/man/licensing-defaults.md`.
- New: `bin/lc1ck`, `bin/gm1gk`, `UPGRADES.md`, `polygram/hooks.md`, `conventions/TREE-WORDS.md`,
  `tests/lc1ck-spec.rb`, `tests/lc1ck-tests.sh`, `tests/release-gate-spec.tcl`,
  `tests/release-gate-tests.sh`, `tests/readme-count-spec.awk`, `tests/readme-count-tests.sh`,
  `tests/gm1gk-tests.sh`, `tests/hooks-tests.sh`, `tests/notice-version-tests.sh`.
- Lane files: `R-ROWS-lane-C.txt` (R21, R22), `CHANGELOG-lane-C.txt`, requests appended to
  `REQUESTS-conductor.txt`.
- Archived first: `c4/archive/2026-10/licensing-defaults-2026-10-10_Archived-by-rcw-01kr4zwy9ba6fvw5z6kd8cei.md`
  (sha16 f48e42bd0199e300; `cmp` with the pre-edit file: identical).

## Tests (OBSERVED, run on the linked computer at the end, 2026-10-10, 09:20-09:30 UTC)

New, each with `--prove-red` (`sh tests/NAME --prove-red`):

| suite | language (work / earlier tests) | green | prove-red |
|---|---|---|---|
| `lc1ck-tests.sh` → `lc1ck-spec.rb` | Ruby (sh+awk / sh) | `TOTAL pass=11 fail=0` | "a lc1ck that never counts a fault turns the spec red (4 FAIL rows)" |
| `release-gate-tests.sh` → `release-gate-spec.tcl` | Tcl (sh / sh) | `TOTAL pass=13 fail=0` | three plants red: NEWS gate always passes (3 FAIL), tag scan never finds (2), gauge never counts (1) |
| `readme-count-tests.sh` → `readme-count-spec.awk` | awk (Python / Python) | `TOTAL pass=4 fail=0` (+5 prove-red rows) | five plants red: README not following a seventh server (3 FAIL), typed "three servers" (1), hand-edit line (1), dropped switch row (1), wrong floor count (1) |
| `gm1gk-tests.sh` | sh (sh+awk) | 7 ok | a gauge that never counts a miss (1 FAIL); one that exits 1 on a miss (1 FAIL) |
| `hooks-tests.sh` | sh+awk | `TOTAL pass=3 fail=0` | "a row naming a missing folder goes red" |
| `notice-version-tests.sh` | awk | `TOTAL pass=3 fail=0` | "a planted 'version 1.4' in a scratch NOTICE goes red" |

Existing suites my files touch, before (08:52-08:58) and after (09:20-09:30):

- `python3 -m polygram.mcp --prove-red`: "prove-red PASS: every refusal fired on purpose", both runs.
- `python3 -m unittest tests.test_plugin tests.test_plugin_imports tests.test_editions`: before
  "Ran 78 tests ... OK"; after, run in two parts, `test_plugin` OK (2m38s) and
  `test_mcp_llamabridge test_plugin_imports test_editions` "Ran 19 tests ... OK" (`test_vendored_bytes`
  is in `test_mcp_llamabridge`: Bryant's bytes untouched).
- `tests/tp2mt-tests.sh` 17/17, `tests/release-gates-tests.sh` 24/24, `tests/release-note-tests.sh`
  6/6: same before and after.
- `sh bin/hb1ck --layout .` after the INDEX edits: "hb1ck: OK 1 -- FAULT 0".
- R21/R22 in a scratch harness: both PASS against the live `bin/`; both FAIL with the plants.

## What the new gauges say about the live tree (OBSERVED)

- `sh bin/release --gauge` with the NEWS as it was this morning (copy in a scratch garden): "the top NEWS
  heading is 1.0.1; 4 minted version(s) newer than it: 1.0.2 1.0.3 1.0.4 1.0.5". After the NEWS
  entries: "the top NEWS heading is 1.0.5; 0 minted version(s) newer".
- `sh bin/lc1ck` (the minted `dist/vibrobeast`, 88 prose files): 52 faults. 49 are SKILL.md footers
  carrying `SPDX-License-Identifier: GPL-3.0-or-later` in prose; 3 are TERMS-OF-SERVICE.md (line 52,
  the v1 writing licence, without ShareAlike, from the v1 block) and PRIVACY.md (names no licence). 68 footers use the short
  spelling CC-BY-SA4. A scratch `bin/tp2mt --out` after the heal: the ToS passes; PRIVACY.md still faults.
- `sh bin/release --prose-gates`: refuses today on 4 bare retired tags (`skills/build-loop/SKILL.md:132`,
  `skills/writing-forms/SKILL.md:83-85`), before it reaches the licence gate.
- `sh tests/readme-count-tests.sh --gauge README.org INDEX.md PROJECT.md dist/vibrobeast/README.md`
  (before the README.org edit and the re-mint): "three small mcp servers" at README.org:22 and "three
  servers" at dist README:241; the hand-edit line at dist README:106. The source no longer has them;
  the shelf's README changes at the next mint.
- `sh bin/gm1gk`: "81 entries in GRAMMARY.md; 0 with no "Whose word" line"; "2 of 34 tree words
  (TREE-WORDS.md) have no entry: RECIPE, carry-in"; spelling NOT CHECKED (no aspell or hunspell).
  On the old GRAMMARY: 36 entries, 36 without, 34 of 34 tree words missing.
- `c4 terms-check` after the heal: the canonical file CARRIES v1.1; five carriers DIFFER (7 lines
  each) and `modelthisbook/CORWIN.md` is MISSING from this mount.

## The local model as first reader (QA-2)

One async call (`delegate_async`, gemma4:12b-8k, think false, job dc0a5ab9fb61, about 20 minutes in the
shared queue) with the 29 entries of the first two new sections, "What it is" and "How it acts" only.
It returned 33 lines (asked for at most 20) and named soft skill, mint and egress as clearest. What I
took: mentcached, `AS4CE0001`, the JAILED fallback, "fired", "go red", "the house numbers", Corwin, C4,
MCP and the before-ship hook are now explained where first used; HEAVY now quotes Corwin's words and
says plainly "spend more, on purpose"; eclipse says it is a critique, not a code debugger. What I left:
its flags on tool codes (each entry names what the tool does), "a reading of it" for JUDGED, "the
wide reflection" (the lens skill's own words), and the extension spell (it has its own file). The
twelve lane-request entries went in after this read and were not read by it.

## Re-sign owed

- **No file I edited carries a signature** (checked for `.asc` beside each: none).
- **The TERMS block, by carriage.** `c4/man/licensing-defaults.md` is not signed itself (the aw2ri
  receipt says `sig=none`), but its block is carried word for word into `modelthisbook/CORWIN.md`,
  which is signed (licensing-carriers: sig good against claude/pub/corwin.asc). To finish the heal:
  `tm1ck --carry` to the five DIFFERS carriers (`c4/GHOSTWHEEL.org`, `AS4CE0001/book/CORWIN.md`,
  `<H>:/pub/RECIPE.org`, `<H>:/pub/persona/README.org`, `c4/README.md`), carry it into
  `modelthisbook/CORWIN.md`, and **re-sign CORWIN.md**: his act. Edit, written down, told; he re-signs.
- **The dated line for `claude--pub/.gate`**, prepared, not written (not my file):
  `licence: 2026-10-10 new writing on this shelf is CC-BY-SA-4.0 (TERMS v1.1); essays already published keep CC BY 4.0, the licence they went out with`

## Requests to other lanes (in `REQUESTS-conductor.txt`)

1. Fold R21, R22. 2. Run `release --gauge` and `lc1ck` at `make dist`. 3. `bin/tp2mt`: one licence
line in PRIVACY.md. 4. `labels.tsv` NO4C row and `models/SEMAPHORES.md` row 44 ("provisional") lag
GRAMMARY. 5. Two C4 man pages still say v1. 6. The later footer re-mint should cover the 49 GPL-on-prose
footers too.

Taken in from the others: every GRAMMARY term in `REQUESTS-lane-C.txt` from lanes A, B and D
(frame, reset, declared key, people.named and the writer rule, seatkeeper "no", pr1ef, persona ledger,
DIVERGED, "Whose inverse I carry", default voice, gp.1, READ/NOT REACHED/FENCED, grain of seating, kept
out of view, drop, counterpart, modes of work, the four tool codes). Lane A's note that
`test_every_unshipped_tool_is_marked` errored at 09:1x: that was my `plugin.py` mid-edit; the test now
reads `plugin.readme_text()` and passes.

## What surprised me (OBSERVED)

- **Another lane-C run had started before mine.** At my start (08:51) `bin/lc1ck`, its Ruby spec,
  `UPGRADES.md`, `polygram/hooks.md`, `tests/hooks-tests.sh`, `tests/notice-version-tests.sh`, the
  NOTICE edit, `QAPLAN-lane-C.md` and the aw2ri archive of licensing-defaults.md existed, stamped
  08:42-08:45 (`ls --time-style=full-iso`). No later writes to them appeared. I read each, ran its
  tests green and red, and kept it; this hand-back covers both runs.
- **The old NEWS gate could not match "Version 1.0.0"** (it wanted a space after the version).
- **The minted README printed ``python3`` with doubled backticks** (dist README line 90): the
  `{python}` placeholder sat inside backticks and was replaced with a backticked name. Fixed by the mint.
- **lc1ck reads any mention as a use:** a sentence that only reports the old licence by name is a
  FAULT unless it also names the TA model or published essays (this hand-back tripped it once). It is
  meant for shipped prose; fine for that, noisy for notes.
- **The README count gauge missed a count wrapped across a line** ("three\n small MCP servers") until
  it read each line with the end of the one before.

## JUDGED (each with a falsifier)

- The TERMS heal is v1.1 (writing line only), not the TERMS v2 draft (which also puts an LGPL "OR" on all
  code): the design asked for the writing line, and the code line is his to adopt. Falsifier: he says v2
  was meant; then replace the block with the draft's and bump to v2.
- The release will refuse every mint until the 4 tags and 52 licence faults are fixed or a reason is
  given, and that is the gate working, not a regression. Falsifier: he rules the SKILL.md GPL footers are
  meant (scripts' licence named in prose); then lc1ck should accept an SPDX line that also names
  CC-BY-SA, and the 49 drop out.
- GRAMMARY's "Whose word" for the 2026-07 seed is given by section, a guess from its own note. Falsifier:
  he names one seed word as a co-author's; then that bullet needs its own line.

---
Authored by Mentat (for Corwin; claude-opus-5-5).
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
