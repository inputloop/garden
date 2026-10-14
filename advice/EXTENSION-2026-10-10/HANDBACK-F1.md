# HANDBACK — fix lane F1 (code), review pass 2 folded (2026-10-10)

*Reads: P5 (Vanth by Ilunga), P6 (Merlin by the Corwin model), C5 (outside reader), the four lane
hand-backs, REQUESTS-lane-F1.txt. Tool codes on first use: qg1ck (the question gauge), rd1ck (the
roads checker), gm1gk (the GRAMMARY gauge), lc1ck (the licence check), gd1ck (the garden kit).
OBSERVED lines carry the command that showed them; JUDGED lines carry a falsifier. The local model
was not used.*

## Per task

| # | task | state | the change |
|---|---|---|---|
| 1 | test frame leak | **done** | `_capture()` moves the frame first; guard test; `tests/frame-leak-tests.sh`; the VM's real frame cleaned (below) |
| 2 | question writer | **done** | `Frame.question` / `Frame.second_needed` fill LABEL, LIKELIHOOD, CONFIDENCE, NOTE; MCP tool `question_log` on mentcached, registered beside the span_* tools in `spans.register` |
| 3 | qg1ck percent | **done** | bar and CONFIDENCE read as 0.17 or 17%; a row at exactly 17% passes |
| 4 | rd1ck + ROADS | **done** | READ only after one line is read back; READER PRESENT, NOT READ; PRESENT, NOT READ; "one road serves two stores"; account-memory road fixed; `usage.store` gone (MENTCACHED_FRAME, an environment variable); the drop line says what a row holds |
| 5 | `room.` writer rule | **done** | keeper's turn, or a named participant in that room's turn (`room=<tavern>`); D12 in Ruby, two plants |
| 6 | seat_mode quote | **done** | status line quotes `prefs.quote()`; `turn` shows a person only their own person rows |
| 7 | exit 77 | **done** | qg1ck, pr1ef, prefs-declared, rd1ck, spans-reset, br1in, mcp, arc-never-ships runners exit 77 with NOT CHECKED; gd1ck shows 77 as LOOK; new gauge leg `grammary` (gm1gk --kit); `tests/interp-77-tests.sh` holds the rule |
| 8 | gm1gk spelling | **done** | pyspellchecker words by name per file, minus GRAMMARY words and labels.tsv; else NOT CHECKED; LOOK line; never fails |
| 9 | lc1ck book/ | **done** | book/ read report-only: OWED lines, "re-sign owed, his pen"; never changes the exit |
| 10 | persona ledger | **done** | dedupe on (from, to, claim) with true ends; counts in the read-back; label names the hand; `LEDGER-2026-10-10-r2.md` written, first kept |

## Files changed

- Code: `polygram/mcp/spans.py`, `prefs.py`, `mentcached.py`, `persona.py`; `bin/qg1ck`,
  `bin/rd1ck`, `bin/gm1gk`, `bin/lc1ck`, `bin/gd1ck` (the kit runner).
- Prose: `conventions/ROADS.md`.
- Tests changed: `tests/test_mcp_spans.py`, `qg1ck-spec.tcl`, `qg1ck-tests.sh`, `rd1ck-spec.rb`,
  `rd1ck-tests.sh`, `prefs-declared-spec.rb`, `prefs-declared-tests.sh`, `pr1ef-tests.sh`,
  `spans-reset-tests.sh`, `arc-never-ships-tests.sh`, `mcp-tests.sh`, `br1in-tests.sh`,
  `gm1gk-tests.sh`, `lc1ck-spec.rb`, `lc1ck-tests.sh`, `persona-ledger-tests.sh`,
  `persona-ledger-spec.awk`, `persona-ledger-SPEC.txt`.
- Tests new: `tests/frame-leak-tests.sh`, `tests/test_mcp_f1_open.py`,
  `tests/f1-python-plants-tests.sh`, `tests/gm1gk-spec.tcl`, `tests/interp-77-tests.sh`,
  `tests/fixtures/lane-d/roads/reader-and-shared.md` (+ `root/bin/rdr`, `root/shared/s.txt`,
  `root/empty/e.txt`).
- Lane papers: `R-ROWS-F1.txt` (R25, R26), `CHANGELOG-F1.txt`, `REQUESTS-lane-F2-from-F1.txt`,
  `persona-ledger/LEDGER-2026-10-10-r2.md`, this file.
- Old copies of every file I edited are in the VM's `~/f1/*.orig` (outside the mount; gone with the
  session).

## Tests (OBSERVED)

Baseline before any change: `python3 -m polygram.mcp --prove-red` → "prove-red PASS: every refusal
fired on purpose"; `python3 -m unittest discover -s tests -p 'test_mcp_*.py'` → "Ran 148 tests …
OK". After: the same → "prove-red PASS …" and "Ran 153 tests … OK"; `tests.test_plugin` → "Ran 66
tests … OK".

| runner | green | prove-red |
|---|---|---|
| frame-leak | PASS (1/1) | RED: the old order wrote into the real frame (0 missed) |
| f1-python-plants | PASS (3/3) | writer-drops-confidence, no-open-quote, third-party-quoted all RED |
| qg1ck | PASS (9 rows) | 5 plants RED incl. new percent-blind |
| rd1ck | PASS (10 rows) | 8 plants RED incl. exists-is-read, reader-blind, shared-blind |
| prefs-declared | GREEN 14/14 | all nine plants red (room-anyone-writes, room-any-room new) |
| gm1gk (+ gm1gk-spec.tcl) | 7 ok + 6 PASS + G7 | 4 plants red (look-off, names-off new) |
| lc1ck | TOTAL pass=12 | 3 plants red (book-unread, book-is-fault new) |
| persona-ledger | GREEN 10/10 | all five plants red (plant e: dedupe off → L9) |
| interp-77 | PASS (I1 + 7 runners under a PATH with no tclsh/ruby → 77) | RED: qg1ck-tests planted to exit 0 |
| gd1ck --prove-red | — | PASS, now also "exit 77 and a gauge's 1 -> LOOK"; with 77→SKIPPED planted back: FAIL |
| pr1ef, spans-reset, br1in, readme-count, sp1rp, st1dt | all green | all prove-red pass |

Old code against the new specs (OBSERVED): old qg1ck → 2 FAIL (17%, --bar 17%); old rd1ck → 3
FAIL (RD6 ×2, RD7); old lc1ck → 1 FAIL (book); old gm1gk → 4 FAIL (G5, G6).

Kit (OBSERVED, `sh bin/gd1ck --no-c4 grammary qg1ck`): "LOOK grammary … 13 spelling word(s) to read";
verdict "no failures (3 legs) (1 item(s) for you to look at)".

## The real frame in this VM (task 1, OBSERVED)

`cat -A ~/.mentcached/stats/fr` held **six** rows, all `pref  usage.capture  on`, BY `test`: the five
P5 saw (09:05:10, 09:13:59, 09:30:35, 09:33:34, 09:39:15 UTC) plus one at 10:10:25 written by my own
baseline unittest run before the fix. I removed those six (awk, keeping any other row; there were
none), so the file is now 0 bytes; `d/fr` (the column names) kept. A copy of the before-file is
`~/f1/fr.before-F1` in the VM. After the fix, two full test runs left its size and mtime unchanged
(`stat -c '%s %Y'` before and after). Avalon was not touched.

## Live readings (OBSERVED)

- `sh bin/rd1ck`: preferences and usage frame now say READER PRESENT, NOT READ for pr1ef and sp1rp
  and are served by no shell road; seat memory READ at AS4CE0001/memory (one line read back);
  account and project memory: no shell road. No "one road serves two stores" line on the live table.
- `sh bin/lc1ck`: the 52 dist faults unchanged; book: 33 files, 4 lines OWED — CORWIN.md:209, 226,
  533 and **mentat-chronicle.md:46** (one more than P6 counted; it was outside P6's two files).
- `sh bin/gm1gk GRAMMARY.md`: 13 unknown lower-case words, by name: app, awk, dotfile, fillable,
  loopback, mentcached, namespaced, optimisations, pickable, repo, skillset, skillx, tavernface.
- LEDGER r2: 27 raw rows → 27 distinct (from, to, claim) edges, 22 distinct pairs, 18 source lines,
  one model (claude-opus). No row was an exact repeat; P5's "about 21 pairs" is 22 by the code.

## Re-sign owed

None by this lane: no file I changed carries a signature (`ls <file>.asc`, grep for a PGP block).
book/CORWIN.md and book/mentat-chronicle.md are reported OWED by lc1ck; that re-carry is his pen.

## Requests to other lanes

`REQUESTS-lane-F2-from-F1.txt`: FRAME.md row 11 and the gauge kind; GRAMMARY words; the README tool
count; F2's request 1 (first-turn keeper) written as a fork, not built; F2's requests 2 and 4 done.
Conductor: fold R25, R26; add the new runners (they join the kit by existing).

## JUDGED (each with a falsifier)

- The frame leak is closed for every Python test, not only `_capture`. Falsifier: any test_*.py
  run under a real HOME changes `~/.mentcached/stats/fr` (the guard compares it; the kit runs it).
- READ now means a fact was read, at the cost of one line read from each store folder (path printed,
  line never). Falsifier: rd1ck output containing any byte of a store's content.
- The `room.` rule is checked at write only; a hand-written row is still applied at read, so the
  rule can be walked around by editing the file. Kept that way because pr1ef (awk) and prefs.py must
  classify the same, and the room road is dormant. Falsifier: a room row from a hand edit changing
  behaviour before gp.1 runs.
- gd1ck's 77 → LOOK makes many legs LOOK on a machine without Tcl/Ruby/Perl (avalon's MINGW64 is the
  likely case). That is the point (a person sees it did not run). Falsifier: Corwin rules the kit
  should stay UNCHECKED for those.
- rd1ck still does not run the `check` column (P5 idea 5's second half); not asked of F1.

## Surprised me (OBSERVED)

- My own baseline test run added a sixth leaked row before I fixed it: the leak fired every run.
- `pyspellchecker` was already importable in this VM (`~/.local/lib/python3.10/site-packages`), so
  the G6 name row runs here; on a machine without it, the Tcl spec exits 77.
- Account memory has no seat copy at all (memory/account-memory-store-D.md says store D is not
  mirrored), so the old road 3 was not a duplicate copy but the wrong store.

Authored by Mentat (for Corwin; claude-opus-5-5).
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
