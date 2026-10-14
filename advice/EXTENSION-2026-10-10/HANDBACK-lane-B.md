# Hand-back, lane B: the Tavern face, the plain voice and the persona ledger (2026-10-10)

*Builder: lane B. Brief: `LANE-BRIEF.md`; tasks B1-B3 of `DESIGN-extension-edition.md` §3. No git
commit, no `make dist`, no install, no signing. No persona sheet was edited.*

## Per task

| task | state | what |
|---|---|---|
| B1 tavern_status and the tavern.as fallback | **done** | F5 (build named; Tavern name before address; roads needing gp.1, also on the OFF answer; never the join code, id, ip or token) and F6 (an unset tavern.as becomes the agent already in config.json under the same owner with model claude, else `claude`; says where the name came from). |
| B2 default_voice | **done** | `persona_resolve`, when nothing resolves, still refuses to mint and also returns `default_voice`: one plain line at the origin; numbers only when `tone.show` is not `words`. A missing tone key is its default. |
| B3 persona_ledger and LEDGER.md | **done** | Read-only tool `persona_ledger` in `persona.py` (no new server file) plus CLI `python3 -m polygram.mcp persona --ledger [--proposed FILE ...]`. First ledger on the live estate written; Drive copy made. |

Note: B1 and B2 code and tests were already in the tree when this run started (files dated 08:44,
from an earlier lane-B run that left no hand-back). This run checked them, ran them, and finished B3.

## Files changed

- `polygram/mcp/tavernface.py`, `polygram/mcp/persona.py`
- `tests/tavernface-SPEC.txt`, `tests/tavernface-tests.sh`, `tests/test_mcp_persona.py`
- new: `tests/persona-ledger-SPEC.txt`, `tests/persona-ledger-tests.sh`, `tests/persona-ledger-spec.awk`,
  `tests/fixtures/lane-b/` (README, an invented `tavern/config.json`)
- new: `advice/EXTENSION-2026-10-10/persona-ledger/LEDGER-2026-10-10.md` (generated) and
  `PROPOSED-2026-10-10.md` (pointers to the review lines; it states nothing of its own)
- new: `R-ROWS-lane-B.txt`, `CHANGELOG-lane-B.txt`; appended to `REQUESTS-lane-C.txt`

## Tests (OBSERVED, each with its command, run from the AS4CE0001 root)

| command | before (HEAD, unpacked with `git archive` to a scratch copy) | after |
|---|---|---|
| `python3 -m polygram.mcp --prove-red` | `prove-red PASS: every refusal fired on purpose` (20 PASS lines) | same, 20 PASS lines (R19/R20 wait for the conductor) |
| `python3 -m unittest tests.test_mcp_persona` | 27 tests OK | 30 tests OK |
| `sh tests/tavernface-tests.sh` | `GREEN tavernface: 7/7` | `GREEN tavernface: 9/9` |
| `sh tests/tavernface-tests.sh --prove-red` | three plants | `PROVE-RED PASS: all five plants went red` (F6 under a missing owner check; F5 under a status that prints the join code) |
| `sh tests/persona-ledger-tests.sh` | (new) | `GREEN persona-ledger: 9/9` (L1-L8, T1) |
| `sh tests/persona-ledger-tests.sh --prove-red` | (new) | `RED L4 under plant (a)`, `RED L3 under plant (b)`, `RED L6 under plant (c)`, `RED L5 under plant (d)`, `PROVE-RED PASS: all four plants went red` |
| `sh tests/persona-shelf-tests.sh` | `TOTAL pass=3 fail=0` (scratch copy lacks some trees) | `TOTAL pass=8 fail=0` |
| `sh tests/mcp-tests.sh` | SKIP in the scratch copy (no dist) | `TOTAL pass=8 fail=0` |
| R19, R20 as written in `R-ROWS-lane-B.txt`, run in a scratch harness | — | both PASS; both FAIL with default_voice and the existence check planted away |

## The first ledger (OBSERVED: `persona --ledger` with PERSONA_SHEETS set to six folders)

Folders: `AS4CE0001/h/persona`, `c4/h/persona`, `c4/q/words`, `AS4CE0001/book`, `c4/h/cast`,
`claude--pub/method/h`. Read back in words: 12 sheets; 4 person models counted, not named; 0 sheets
have a "Whose inverse I carry" section, so 0 edges in the sheets; 27 edges proposed by review (P1-P4
and S4 §A.1), listed apart; 0 faults; 3 sheets DIVERGED: **mentat** (served copy sha256 cf5e8066…e01,
26105 bytes; the `h/` copy and the `c4/h/` copy sha256 05193914…144, 25672 bytes), **shopgarden**
(d9ee9fd3… vs fd3b9852…) and **gh7** (`h/persona` 4314247a… vs `c4/h/PERSONA-gw7.md` 70a93823…, the copy
ROSTER calls master). Which is master is Corwin's pen. Local file: 13113 bytes, md5
c43f91cdbf51c7975b784d9b0868e99a, sha256 e84c9c60ddb1cb4ac0a9720f69d1eeac7ebc98352c21b4ee2b36bb11e011e7ce.

## Drive carry (OBSERVED)

- Folder `ComputerPeople/persona` = id `1DLP853g-7WQXYUQdyrsskIscGy0Us_do` (parent `ComputerPeople`,
  `1xXzNawbvwzO-Pd1sBvuzKP-7S7Bwfkwi`), by `get_file_metadata`.
- Uploaded as a NEW file (`create_file`, base64, no conversion): **`LEDGER-2026-10-10.md`, id
  `1AV67kRSuAn1FPxg0lDArz_kpqFA79Yjt`**, https://drive.google.com/file/d/1AV67kRSuAn1FPxg0lDArz_kpqFA79Yjt/view.
  Nothing overwritten or trashed.
- Read back with `get_file_metadata`: fileSize 13113 = local 13113; mimeType text/markdown. The
  connector does not report an md5, so the md5 match is **NOT CHECKED** on the Drive side (a download
  and re-hash would cost about 17 k characters through the model; not done).
- Not yet in `mainmem/ferry/receipts.log` (that file is outside lane B's files): a request for whoever
  keeps the ferry.

**Local sheets newer than their Drive copy** (listed, not uploaded; Drive size from `search_files`
by title, local from `ls`):

| sheet | local bytes, date | newest Drive copy |
|---|---|---|
| CHARACTER-2026-09-06-mentat.md | 26105, 10-04 | 25672, 09-24 (`1LnbZ68D…`) |
| CHARACTER-2026-09-05-shopgarden.md | 23164, 10-04 | 22731, 09-24 (`1BI92QVP…`) |
| ILUNGA.md | 9848, 10-04 | 9415 (`1SjenQmA…`) |
| PELL.md | 9712, 10-04 | 9279 (`1VaVVu7x…`) |
| ROUX-ABARA.md | 9439, 10-04 | 9006 (`1G-Bpq9K…`) |
| SOLBERG-MAAS.md | 12147, 10-04 | 11714 (`1z5BR2BT…`) |
| VANTH.md | 8677, 10-04 | 8244 (`1gJqgeSB…`) |
| MERLIN.md | 2731, 10-04 | 2298 (`1aYF0-Yk…`) |
| ROSTER.md | 8236, 10-06 | 7401, 09-25 (`16DYScxV…`) |
| VIBROBEAST.md | 17998, 10-06 | not on Drive |
| PENUMBRA.md | 16678, 09-25 | 16685, 09-12 (`1cBXWSOY…`): sizes differ; local is the later file |

Current on Drive by size: `pub.ITEM.md` (9662), `PERSONA-gw7.md` (24023, the c4/h master; the
`h/persona` twin of 24458 is not on Drive). This agrees with S4 §A.3, plus PENUMBRA, which S4 could
not see.

## Re-sign owed

None: no signed file was changed.

## Requests to other lanes

- Lane C (`REQUESTS-lane-C.txt`): GRAMMARY entries for persona ledger, "Whose inverse I carry",
  default voice, DIVERGED.
- Conductor: fold R19 and R20 from `R-ROWS-lane-B.txt`; add `tests/persona-ledger-tests.sh` to the kit.
- Whoever keeps the ferry: a receipt line for Drive id `1AV67kRSuAn1FPxg0lDArz_kpqFA79Yjt`.

## Surprised me (OBSERVED)

- B1/B2 were already built when this run began (see the note above).
- `persona.classify` serves VIBROBEAST.md as kind "model" with actor "person-model"; its head says
  "a tool, not a person", so the ledger shows it as "model, not a person". `pub.ITEM.md` is served
  as `pub-item`, not `pub` as ROSTER names it.
- Adding `c4/h` itself as a root serves non-sheets (`PERSONA-LINK-…`, `PERSONA-GROWTH-…`), so the
  ledger reads twins left beside a root (the parent folder) by file name instead.
- `bin/hb1ck --layout` printed only `bin/hb1ck: 216: 1: root`; the ledger's home was taken from the
  brief, not confirmed by that tool.
- Local model: not used.

## JUDGED (each with a falsifier)

- The P4 source path names the person model in its file name (`…by-bryant-model.md`); the row's
  words are withheld but the path is shown. Judged acceptable because the path is an address, not
  model content. Falsifier: Corwin reading the grant as covering file names too; then show the P
  sources as "review P4" only.
- Proposed edges count as "stated by a file" only because each row quotes its source lines; the
  pointer file adds no words. Falsifier: a proposed row whose words are not found at its cited lines.
- Sheet edge lines are read as `NAME : words` under a `## Whose inverse I carry` heading (S4 §A.4
  step 3). Falsifier: Corwin writing the section in another shape; the parser then finds 0 edges
  where there are some (the read-back would say "N sheets have a section" with 0 edges).

Authored by Mentat (for Corwin; claude-opus-5-5).
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
