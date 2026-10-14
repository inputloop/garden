# HANDBACK: lane D (four new tools), 2026-10-10

*Form: HANDBACK. Lane D of the extension edition (`DESIGN-extension-edition.md` §3 Lane D), with
D4 enlarged at Corwin's ask (Bryant-modes ingestion). Two piles: OBSERVED lines name the command
that showed them; JUDGED lines carry a falsifier. Tool codes: st1dt (the seating detector), rd1ck
(the roads checker), qg1ck (the question gauge), br1in (the Bryant drop intake).*

## Per task

| task | status | what landed |
|---|---|---|
| D1 `bin/st1dt` | done | nearest `.gate` walking up; markers; one grain (none, light, full) with reason and falsifier; one question with lettered choices; a remembered "no" (lane A's contract) said, nothing asked; secret-class entries as a count only, invoices named only with `--names`; never writes; ends with "What the model was shown". |
| D2 `conventions/ROADS.md` + `bin/rd1ck` | done | eleven stores (W's rows less the fenced `c4/Z/from/Bryant` road, with T's per-class "Tavern drop: yes/no"); rd1ck prints READ, NOT REACHED or FENCED, never "absent"; NOT REACHED names the seat, the parent it listed and the request; `--tsv` mints the tool TSV from the Markdown. |
| D3 `bin/qg1ck` | done | reads `gauge` rows (its reading of the columns is in its header, from W A3 (a)); a two-question frame above 0.17, or with no number, is a fault; counts unglossed GRAMMARY terms, misses and `pref` mirror rows; reads only. |
| D4 `bin/br1in` (enlarged) | done | integrity intake (sums beside and inside, signature issuer against the pin, every file hashed, nothing of his run); (a) prior copy from the earlier dated drops, plus copies in `externs/claude-bryant/` and `Bryant/`, never `c4/Z/`; (b) name, version, sha256, NEW / UNCHANGED / CHANGED / DROPPED, one-line summary from description, headings and files; (c) counterpart from `conventions/bryant-counterparts.tsv` (34 rows seeded from S1), then by name; (d) modes of work, marked "extracted, not judged"; (e) mechanical open questions; words report, TSV and ACK. Reports kept for 10-05, -r2, -r3 in `br1in/`. |

## Files changed (all new)

- `bin/st1dt`, `bin/rd1ck`, `bin/qg1ck`, `bin/br1in`
- `conventions/ROADS.md`, `conventions/bryant-counterparts.tsv`
- `tests/st1dt-tests.sh`; `tests/rd1ck-spec.rb`, `tests/rd1ck-tests.sh`; `tests/qg1ck-spec.tcl`,
  `tests/qg1ck-tests.sh`; `tests/br1in-tests.sh`, `tests/br1in-noedit-spec.rb`,
  `tests/br1in-real-tests.sh`
- `tests/fixtures/lane-d/br1in/mkdrops.sh` (builds the fixture drops in scratch),
  `tests/fixtures/lane-d/roads/` (four tables, a mount root, two recorded outages),
  `tests/fixtures/lane-d/qg1ck/GRAMMARY.md`
- `tests/lane-d-SPEC.txt` (the SPEC lines, written before the tests; it was already on disk from an
  earlier start of this lane, with `lane-D/DESIGN-lane-D.md`, `QAPLAN-lane-D.md` and the four `SWING-*`)
- Lane papers: `R-ROWS-lane-D.txt`, `CHANGELOG-lane-D.txt`, `REQUESTS-lane-A.txt`, a lane-D block
  appended to `REQUESTS-lane-C.txt`; reports in `br1in/`.
- Moved, not deleted: the earlier start's hand-made fixture zips (`tests/fixtures/lane-d/br1in/from/`)
  to `lane-D/_to_delete/old-fixtures/`; the generator replaces them.

## Tests (OBSERVED, last runs)

| suite (language) | green | prove-red |
|---|---|---|
| `sh tests/st1dt-tests.sh` (sh) | `st1dt tests: PASS` (6 rows, ST1-ST6) | `st1dt prove-red: 0 missed` (6 plants red: never-off, gate-blind, writes, two-questions, forgets-no, no-readback) |
| `sh tests/rd1ck-tests.sh` (Ruby runner) | `rd1ck tests: PASS` (7 rows, RD1-RD5, two recorded outages) | `rd1ck prove-red: 0 missed` (fence-off, read-off, say-absent, no-parent, tsv-source) |
| `sh tests/qg1ck-tests.sh` (Tcl spec) | `qg1ck tests: PASS` (7 rows; 0.18 red, 0.17 passes) | `qg1ck prove-red: 0 missed` (bar-off, bar-off-by-one, gloss-blind, writes-frame) |
| `sh tests/br1in-tests.sh` (sh + Ruby no-edit check) | `br1in tests: PASS` (10 rows, BR1-BR7; one flipped byte FAILs) | `br1in prove-red: 5 red as planned, 0 missed` (out-in-drop, write-into-drop, fence-off, sums-off, compare-off) |
| `sh tests/br1in-real-tests.sh` (sh, real drops) | `br1in real tests: PASS` (BR8, 4 facts) | `br1in real prove-red: 3 fact(s) went red as planned` |
| `python3 -m polygram.mcp --prove-red` before (`lane-D/baseline-mcp-prove-red.txt`) and after | `prove-red PASS: every refusal fired on purpose` both times; lane D touched no Python | n/a |

Also: `dash -n` clean on all four bins; shellcheck NOT CHECKED (`command -v shellcheck` finds none).
Swing: each of D1-D4 closed with `sw1ng complete` on QA pass 1 of 3, clean; no redesign.

## What br1in found (OBSERVED, `sh bin/br1in --out advice/EXTENSION-2026-10-10/br1in c4/from-bryant/<drop>`)

- It rediscovers S1's facts: 09-17 against 08-05 has 0 SKILL.md that differ; its new garden skill is
  primer (the other 10 new are the Anthropic and plugin folders). 10-05 against 09-17: exactly the 11
  SKILL.md changes S1 lists, new caterpillar, colophon, parallax. r2: token-optimizer only (v1.2-public
  to v1.3, 7048 to 17056 bytes, `scripts/tokenomics.py` added). r3: colophon (v1.0 to v1.1, plus
  `colophon.py`) and signet (SKILL.md and `signet.sh`).
- Changes S1's sketch did not list: eclipse-pass changes by files only (the stray `scripts/sedx44W4d`
  appears 09-17, gone 10-05); wire-omnibus lost a `.skill-manifest` between 08-05 and 09-17.
- 10 skills DROPPED at 10-05 (the 8 Anthropic and 2 plugin folders of 09-17).
- Mechanical open questions it raised: alfred routes to `consolidate-memory`, `schedule` and
  `explain-usage`, found in no intake place (S1's B6, found mechanically); gauntlet (1032) and
  omni-tool (1030) descriptions are over 1024 characters; signet (r3), vitrine and wire-2fa (10-05)
  changed SKILL.md with no version change; files not named by any sum (MANIFEST.md in each, plus our
  own reading files in r3).
- Transport: every sum line OK in all three (197, 101, 101 lines); verdict PASS.
- Our own writes sit inside two drops: `2026-10-05/unpacked/` and `2026-10-05-r3/ACK...`, `reading/`.
  br1in reads them as part of the drop and says so (an `.asc` under `unpacked/` is signed by key
  5B6135511580F007, not the pin).

## Re-sign owed

None. No signed file was changed.

## Requests to other lanes

- Lane A (`REQUESTS-lane-A.txt`): which path string the seatkeeper hash is taken over. st1dt uses the
  path from the mount root (the same in every session), with `--as` for the person's own path. Also:
  `questions.skip_bar` is not in KNOWN; qg1ck takes `--bar` until it is.
- Lane C (`REQUESTS-lane-C.txt`): GRAMMARY entries for road, READ / NOT REACHED / FENCED, grain,
  kept out of view, drop, counterpart, modes of work, and the four tool codes.
- Conductor (`R-ROWS-lane-D.txt`): R24 "br1in never writes into a drop", code tested in a scratch
  harness (PASS; red with the out-in-drop plant). R23 stays reserved (rd1ck has no server face).

## Surprises

- OBSERVED: an earlier start of this lane had left the design, QA plan, SPEC lines, swing files and
  hand-made fixture zips, but no tools. I kept the design, plan and SPEC, and replaced the zips with a
  generator (`ls -la advice/EXTENSION-2026-10-10/lane-D`, 08:43-08:44 timestamps).
- OBSERVED: sorting drop folders by `name/` puts `2026-09-26-r2` before `2026-09-26` ("-" sorts before
  "/"). br1in sorts bare names; caught on the first real run.
- OBSERVED: the first test of the off-pin signature made 10-05 FAIL; an issuer other than the pin is
  now a question, and only a BAD verify fails.
- OBSERVED: key 5B6135511580F007 (fingerprint ECE77CF417C76C1ACFCE7C2B5B6135511580F007) also signs
  `AS4CE0001/.gate` (`gpg --list-packets` on its signature block). JUDGED: it is Corwin's key, so the
  `.asc` is ours, not Bryant's. Falsifier: `gpg --list-keys 5B6135511580F007` on avalon names someone else.
- JUDGED: the heading changes in alfred, power-glove, mega-voltron and signet ("Boot order — first
  moves" to "Boot order: first moves") are his em-dash removal, not new content; br1in counts them as
  +N/-N headings. Falsifier: a pair whose texts differ by more than the dash.
- JUDGED: the seatkeeper hash path is the likeliest place a "no" gets lost between st1dt and pref_set.
  Falsifier: lane A's skill names the mount-relative path, and one round trip (st1dt, then pref_set
  with that value, then st1dt) says "not asking again".

## Local model

QA-2 cold read (gemma4:12b-8k, think false, `delegate_async`, one call, job `5412ae543aa6`, queued
09:21Z): NOT ANSWERED. After about 3 minutes it still had 3 jobs ahead of it (`delegate_result`, twice),
so I did not wait on the shared GPU. The prompt asks three questions the TSV answers (r2 changed:
token-optimizer; r3: colophon, signet; written into a drop: no) and asks it to name any unclear word.
`delegate_result 5412ae543aa6` will show its answer when it runs. QA-2 was optional in the plan; QA-1
is complete without it.

---
Authored by Mentat (for Corwin; claude-opus-5-5).
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
