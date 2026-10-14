# Hand-back: fix lane F3 (review pass 3)

*Folds C5b (outside reader, pass 3), P6b (Merlin, pass 3) and C6 (the peer agent in Bryant's modes).
Nothing committed, minted, installed or signed. The local model was not used. `dist/vibrobeast` was
NOT re-minted, so the shipped PRIVACY.md, TERMS-OF-SERVICE.md, README.md and GRAMMARY.md there still
show the old text until the next `make dist`.*

## Per task

| # | task | state | what |
|---|---|---|---|
| 1 | PRIVACY.md names the usage record | **done** | three checked claims in `bin/tp2mt` (file and names file, MENTCACHED_FRAME, off by default, writes nothing while off); a stores-table row; how to stop and remove it |
| 2 | Terms "Licenses" bullet; lc1ck long form | **done** | the bullet was a hand-typed copy inside `bin/tp2mt` (not from `c4/man/licensing-defaults.md`, whose TERMS v1.1 block was already right); now CC BY-SA 4.0, TA model and published essays pointed at the TERMS block. `bin/lc1ck` faults "Creative Commons Attribution 4.0" spelled out |
| 3 | GRAMMARY entries and dangling paths | **done** | buoyancy, steward/nongnu-steward, altorewired; header 89 (its parts add up); one sentence at the top, and "(in the author's tree, not shipped)" after each run of unshipped paths (86 of 93 source-tree paths); none deleted |
| 4 | README order | **done** | Words before the table (new "The servers" heading), so "see Words, above" is true; "every word" softened to "the project's own words"; "Skills that fire broadly -- read before you install" sits above Install and says what to do after |
| 5 | usage.store | **nothing to change** | `grep -rn usage.store` (excluding .arc, advice, h): only `conventions/ROADS.md:59`, which already says "there is no `usage.store` setting", and the ChangeLog |
| 6 | question_log writer | **done** | bare number above 1 refused ("write 17% or 0.17"); `second_needed` for a never-logged id refused while capture is on |
| 7 | question-economy soft skill | **done** | `SOFT-SKILLS/question-economy/SKILL.md`, footer by `ft1mt`, FOOTERS row; the loader finds it (test), `ss2gr` lists it (0 reads, soft) |
| 8 | hooks.md delivered row | **done** | says "not yet a hook: proposed"; hooks-tests counts every row and faults a row with neither a place nor those words |
| 9 | br1in modes | **done** | the three asked, plus the index.php dot (C6 idea 7); new Ruby spec; re-runs written as `<drop>.run-r2.{md,tsv,ACK.txt}` |
| 10 | UPGRADES U2, U3; kid-glove note | **done** | scope line widened; U2 signet, U3 Alfred's map; `NOTE-kid-glove-condition.md` |

## OBSERVED (with command)

- Baseline before any change: `python3 -m polygram.mcp --prove-red` "prove-red PASS: every refusal fired on
  purpose"; `test_mcp_*` "Ran 153 tests ... OK"; `tests.test_plugin` "Ran 66 tests in 165.476s OK".
- After: `--prove-red` "prove-red PASS"; `test_mcp_*` "Ran 156 tests in 22.558s OK"; `tests.test_plugin`
  "Ran 66 tests in 171.530s OK"; `tests.test_plugin_broad` OK.
- Red first (spec before code): test_mcp_spans 2 failures; tp2mt-tests "pass=17 fail=4"; lc1ck-spec
  "FAIL long form"; README tests 2 failures; QuestionEconomy 1 failure; hooks-tests 2 FAIL;
  grammary-paths spec 84 FAIL (83 unmarked paths and no header sentence); br1in-modes spec "pass=2 fail=5",
  reproducing C6's parallax, connector-forge, aetherflow-runner (twice) and aethernet-relay cases.
- Runners with `--prove-red`, after: tp2mt "PASS: harness correctly went red"; lc1ck 15/15 and three
  prove-red rows red (7, 1, 1 FAIL rows); hooks 5/5, both plants red; grammary-paths 6/6, both plants red;
  br1in-modes 7/7, four plants red (3, 1, 1, 1 FAIL rows); br1in-tests "5 red as planned, 0 missed";
  br1in-real "PASS"; gm1gk, readme-count 9/9, ss2gr, prefs-declared ("all nine plants"), frame-leak
  ("0 missed"), qg1ck ("0 missed"), spans-reset, interp-77 ("0 missed"); editions 20/20.
- `sh bin/lc1ck dist/vibrobeast` after the lc1ck change: 5 faults, the new one
  the writing-licence fault at `TERMS-OF-SERVICE.md:24` (C5b J2's falsifier fired). A fresh `tp2mt --out` mint
  reads 0 faults.
- `sh bin/ft1mt check`: 3 breaks before and after (egress x2, family-shelf). `tests.test_ft1mt`: 2 failures
  before (F2's note), 1 after (egress); `ft1mt seed` added the missing family-shelf row as well as mine.
- R27 and R28 run in a scratch harness: PASS; each FAILs with its plant (R-ROWS-F3.txt says which).
- The real frame `~/.mentcached/stats/fr`: 0 bytes, mtime 10:14, unchanged by my runs.
- br1in re-runs (rc 0 each): 11 changed "extracted" lines per drop; parallax now `'what the other AI
  said', ...` with no apostrophe fragment; aetherflow-runner shows no loop or gate from its title or "the
  runner"; aethernet-relay's sentence runs past index.php.
- kid-glove: our `skill-sign.sh verify` over `dist/vibrobeast/skills`, pinned key in a scratch keyring:
  "signed=21 valid=21". signet (his) was not re-run; the agreement figure is C6 O12's.

## JUDGED (each with a falsifier)

- PRIVACY.md says "Two counts only" for the start and prompt rows and names the other rows the frame keeps
  while on (preference mirror, logged questions). The task said "two counts only"; the code writes more,
  so I wrote both rather than an untrue sentence, and changed the matching `usage.capture` switch text in
  `prefs.py`, which said "nothing else". Falsifier: a frame row of kind pref or gauge that capture-on never
  writes (spans.py `Frame.pref`, `Frame.question` say it does).
- The marker is per run of adjacent paths, not per path ("`a`, `b` (in the author's tree, not shipped)").
  Falsifier: a reader who takes the first path of such a run for shipped.
- The re-run reports are named `.run-r2.` because `2026-10-05-r2.md` already exists (it is the r2 drop's
  report); a plain `-r2` suffix would have overwritten it. Falsifier: none; a naming choice, said.
- br1in now loses a quoted trigger that itself contains an apostrophe ('why won't my connector
  authenticate'). That is the cost of never pairing in-word apostrophes. Falsifier: a drop whose only quoted
  trigger has an apostrophe inside it, now printed as no trigger.
- The UPGRADES scope line now covers "his software that reads ours". C6 called that an unlikely option and
  Corwin's call; the task asked for U2 there, so it is written. Falsifier: Corwin preferring U2 in the next
  ACK instead; the entry moves with no other change.

## Files changed

bin/tp2mt, bin/lc1ck, bin/br1in, polygram/plugin.py, polygram/mcp/spans.py, polygram/mcp/prefs.py,
polygram/hooks.md, GRAMMARY.md, UPGRADES.md, conventions/FOOTERS.org, tests/tp2mt-tests.sh,
tests/lc1ck-spec.rb, tests/hooks-tests.sh, tests/test_mcp_spans.py, tests/test_mcp_softskills.py,
tests/test_plugin.py, tests/test_plugin_broad.py. New: SOFT-SKILLS/question-economy/SKILL.md,
tests/grammary-paths-spec.awk, tests/grammary-paths-tests.sh, tests/br1in-modes-spec.rb,
tests/br1in-modes-tests.sh, advice/EXTENSION-2026-10-10/br1in/2026-10-05{,-r2,-r3}.run-r2.{md,tsv,ACK.txt},
NOTE-kid-glove-condition.md, R-ROWS-F3.txt, CHANGELOG-F3.txt, this file. Old copies:
`.arc/2026-10/*.pre-F3-2026-10-10`.

## Re-sign owed

None. No signed file changed (no `.asc` or clearsigned text beside any file above; no `skills/` folder
touched). The new soft skill is unsigned, as soft skills are.

## Requests to other lanes

None (the only lane running).

## Surprised me

- The Terms bullet was not taken from the TERMS block at all: it is typed into `bin/tp2mt`, so healing
  the c4 source would have changed nothing.
- `interp-77-tests` caught my first br1in-modes runner: a guard written as a loop over interpreter names
  is not one its static check can see. Rewritten as the plain `command -v ruby ... || { ...; exit 77; }`.
- `tests/br1in-real-tests.sh` exits 0, not 77, when the drops are not mounted (line 19). Not changed here.
- C5b O10 (FRAME.md "spans.tsv, below" with nothing below) is still open; it was not in this lane's list.

---
Authored by Mentat (for Corwin; claude-opus-5-5).
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
