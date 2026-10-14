# HANDBACK — lane A: preferences, spans and the frame (2026-10-10)

*Form: HANDBACK. Lane A of DESIGN-extension-edition.md §3. Builder: Mentat (claude-opus-5-5), the
second lane-A run. An earlier lane-A run stopped at 08:45 UTC partway through. Its files were left
unchanged from 08:45:51 to 08:50, and the brief was rewritten at 08:48. I took over its work (A1,
A3, most of A2), checked it, and built the rest.*

## Per task

| task | status | what |
|---|---|---|
| A1 the span reset | **done** (from the earlier run; checked) | `spans.py` `_is_reset`/`_legs`; `tokens_since_last: null`, `reset: true`; "N resets seen" with the caveat; `bin/sp1rp` the same in awk. Tcl spec `tests/spans-reset-spec.tcl`. R17. |
| A3 unknown rows, `pref_unset`, `bin/pr1ef` | **done** (earlier run; I updated it for A4) | `classify()` marks each row applied, superseded or ignored; `pref_list` lists ignored rows under `ignored:`; `pref_unset`; `pr1ef` in awk. Ruby spec `tests/pr1ef-spec.rb`. |
| A2 `usage.capture`, `tone.dial`, `tone.show`, the frame | **done** | Keys in `KNOWN` (earlier run). Frame writer in `spans.py` (earlier run). I added `Frame.pref` (the seatkeeper "no" mirror, card 22) and wrote **`FRAME.md`** (the twelve columns in words). R18. |
| A4 declared keys, prefixes, writer rule, seatkeeper "no" | **done** | `softskills.declared()` reads `preferences:` from SKILL.md front matter (soft roots, then the plugin's own `skills/`). `prefs.PREFIXES` (`person.`, `room.`, `skill.`), each with its reader and name check. `people.named` key. Writer rule at write and at read (new `turn`, `consent` columns). `skill.seatkeeper.<hash>` = `no: <path>`, with the hash checked. `pref_list` gains `declared`, `declined` (path in words) and the quote. `pr1ef` mirrors all of it in awk. Ruby spec `tests/prefs-declared-spec.rb`. |

## Files changed

`polygram/mcp/prefs.py`, `polygram/mcp/spans.py`, `polygram/mcp/softskills.py`, `bin/pr1ef` (new),
`bin/sp1rp`, `skills/seatkeeper/SKILL.md`, `FRAME.md` (new), `tests/test_mcp_spans.py`,
`tests/spans-reset-spec.tcl` + `tests/spans-reset-tests.sh`, `tests/pr1ef-spec.rb` +
`tests/pr1ef-tests.sh`, `tests/prefs-declared-spec.rb` + `tests/prefs-declared-tests.sh` (new),
`tests/fixtures/lane-a/` (`prefs-mixed.tsv`, `prefs-declared.tsv`, `declared/soft/{demo,quiet}`).
Lane notes: `R-ROWS-lane-A.txt`, `CHANGELOG-lane-A.txt`, requests to C, D and the conductor.

## OBSERVED (each with its command; run on the linked computer, 2026-10-10 08:5x–09:14 UTC)

- **Baseline before A4** (the earlier run's A1/A2/A3 in place): `python3 -m polygram.mcp --prove-red`
  printed "prove-red PASS: every refusal fired on purpose". `python3 -m unittest tests.test_mcp_spans
  tests.test_mcp_softskills tests.test_mcp_store` printed "Ran 78 tests … OK".
- `sh tests/spans-reset-tests.sh` → "GREEN spans-reset: 6/6"; `--prove-red` → "red plant
  'python-subtracts': 4 check(s) failed", "red plant 'awk-subtracts': 2 check(s) failed", "PASS: both
  plants of the old subtraction turned the spec red" (re-run after A4, same).
- `sh tests/pr1ef-tests.sh` → "GREEN pr1ef: 6/6"; `--prove-red` → "red plant 'python-drops': 3 …",
  "red plant 'awk-drops': 2 …", "PASS: both planted drops turned the spec red". The python plant had to
  be re-anchored after A4 rewrote its line ("kit broken: plant python-drops did not match" until then).
- `sh tests/prefs-declared-tests.sh` → "GREEN prefs-declared: 13/13"; `--prove-red` → seven reds:
  any-key-accepted 3, no-name-check 3, no-writer-rule 3, readback-without-path 1,
  awk-ignores-declarations 1, third-party-in-frame 1, no-hash-check 1; "PASS: all seven plants turned
  the spec red".
- `sh tests/sp1rp-tests.sh` → "TOTAL pass=15 fail=0". `sh tests/mcp-tests.sh` → "TOTAL pass=8 fail=0"
  (tavernface skipped: a Windows mint). `sh tests/fm-dupkeys.sh skills/seatkeeper/SKILL.md` → 0 findings.
- **After:** `python3 -m polygram.mcp --prove-red` → "prove-red PASS". `python3 -m unittest` over every
  `tests/test_mcp_*.py` plus `test_skill_lint`, `test_skill_sign_manifest`, `test_plugin`,
  `test_plugin_imports` → "Ran 231 tests", **1 error**:
  `test_plugin.TheReadmeServesAStranger.test_every_unshipped_tool_is_marked` (`bin/sp1rp` is not in
  `plugin._README`). `polygram/plugin.py` is lane C's file and was mid-edit (mtime 09:04:24). Not caused
  by lane A: no lane-A change touches `plugin._README`.
- R17/R18 run in a scratch harness (`~/r-harness.py`, which runs the rows' code): both PASS on this
  tree; with `_is_reset` → False and `capture_on` → True planted in a copy: "FAIL a reset never
  yields a negative count tokens_used=-3900 resets=0", "FAIL capture off writes no row 3 row(s)
  written".
- `python3 -c "from polygram.mcp import prefs; print(len(prefs.KNOWN))"` → 18.

## Re-sign owed

- `skills/seatkeeper/SKILL.md` (now sha256 `63c744b36f79172c…`): front matter `preferences:` and a new
  section on the remembered "no". I archived the signed copy, its signature and its manifest under
  `skills/seatkeeper/.arc/2026-10/*-2026-10-10_pre-preferences*`. That is the house `.arc/<month>/`
  convention (as aethernet-relay has it), not a `.signed-<date>` file next to the skill: a dot-folder is
  not swept into the skill. Its `.signature.asc` and `.skill-manifest` now read BAD until he re-signs.

## Requests to other lanes

- **Lane C** (`REQUESTS-lane-C.txt`): seven GRAMMARY terms (frame, reset, declared key, people.named,
  writer rule, seatkeeper "no", pr1ef); README facts (18 KNOWN keys, `pref_unset`); the test_plugin error above.
- **Lane D** (`REQUESTS-lane-D.txt`): the seatkeeper-"no" contract for st1dt ST5: the hash formula, the
  `no: <path>` value, and that `(unset)` means taken back.
- **Conductor** (`REQUESTS-conductor.txt`): fold R17/R18; have `seat_mode` (mentcached.py, no lane owns
  it) add `prefs.quote()` at session open (card 06); decide whether FRAME.md ships.

## JUDGED (each with a falsifier)

- **The writer rule, my reading of "a participant Corwin named".** I took it to mean *the keeper may
  write a row for a participant he named*, not *any named participant may write anyone's row*. The
  second reading would let Bryant write `person.corwin.*`, which P2 J5's falsifier forbids. Falsifier:
  Corwin says named participants may write each other's rows.
- **A consent id is recorded, not verified.** `prefs.py` cannot read consent-gate records, so any
  non-empty `consent` opens the writer rule for a *named* person (an unnamed one is still refused).
  `pref_list` says "consent row … (not checked here)". Falsifier: a `person.` row lands with a consent
  id that matches no record. Today nothing would catch it; that is the gap.
- **Pref mirroring is gated by `usage.capture`** like every frame row, so with capture off (the
  default) a seatkeeper "no" is not mirrored and qg1ck counts none. I chose one rule ("off means no
  row", R18) over card 22's always-mirror. Falsifier: he wants the mirror with capture off.
- **"Export" and "drop" of person rows** do not exist in this edition. Only the frame exclusion is built
  and tested (D9). Falsifier: an export path is found that already carries prefs rows.
- **SESSION holds the span id** (the earlier run's choice). That is fine for qg1ck, which reads by the
  §2 contract. Falsifier: a frame reader needs a session above spans.

## What surprised me

- The earlier lane-A run's work was all there, and its suites were green on arrival. Rebuilding it
  would have been the fault.
- A recursion trap: `softskills.roots()` reads a preference, so a skill scan inside `current()` would
  call itself. Fixed: `current()` reads known keys from the file alone, and only `classify()` scans.
- The local model was not used.

---
Authored by Mentat (for Corwin; claude-opus-5-5).
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
