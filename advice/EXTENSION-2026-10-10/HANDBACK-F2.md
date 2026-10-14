# Hand-back: fix lane F2 (docs and what ships), review pass 2

*Folds C5 (outside reader) J1-J14, P6 #4 (licence blocks), P5 J1 (FRAME "Leaving"). Nothing
committed, minted, installed or signed. Local model not used.*

## Per task

| task | state | what |
|---|---|---|
| 1 ship GRAMMARY.md + FRAME.md | **done** | `plugin.SHIPPED_DOCS`; copied as bytes, in MANIFEST and the .plugin; a missing one is a stated problem; README points at both |
| 2 README template | **done** | new "Words this README uses" section before Install (switch, restart, keeper, people.named, persona, seat/garden/mint, GRAMMARY pointer); Verify explains an unsigned build; missing-Python step needs no checkout; persona row rewritten |
| 3 NEWS 1.1.0 | **done** | plain first paragraph; Unsigned bullet; fourth key `people.named`; GRAMMARY 47 added / 83 in all; TA and garden-pony glossed; 83% tied to 0.17 |
| 4 README.org, INSTALL, GRAMMARY header | **done** | docs CC-BY-SA-4.0; INSTALL floor eight (drift) pointing at `editions.FLOOR`; `make dist SIZE=` said equal to `make edition SIZE=`; GRAMMARY header count from gm1gk |
| 5 old typed GPL blocks | **done** | 54 skills (46 signed + 8 unsigned soft skills); foaf kept (its block is scoped and correct) |
| extra: FRAME.md | **done** | "Leaving" section (P5 J1); CONFIDENCE unit; "one rule, two numbers" (C5 J6) |

## OBSERVED (with command)

- Three sample skills (aethernet-relay, posix, hui): the typed block says GPL-3.0-or-later for the
  whole file; the minted footer below says "CC-BY-SA4 ... (scripts GPL-3.0-or-later)". So the block
  was the leftover P6 J5 said; removed. build-loop's block held one provenance sentence ("Staged
  2026-09-22 in c4/skills-mint/...") which was kept as prose.
- `sh bin/lc1ck skills SOFT-SKILLS`: before **64 faults**, after **10**. The 10 left are not
  SKILL.md (ethicsminions/references, pencil-your-own/ENHANCE-NOTES, seams/TEST-RECORD,
  skill-metrics/SPEC, five nongnu-steward/references) plus SOFT-SKILLS/egress (not ours).
- Removing the block changes each body hash, so `sh bin/ft1mt mint <the 53 mint rows>` was run:
  "53 file(s) written; 53 re-dated" (footers now "Version 1.1.0: edition revised from 1.0.1 on
  2026-10-10"). This writes conventions/FOOTERS.org (not in my file list; mechanical consequence;
  old table archived). `git diff` shows exactly those 53 rows changed. Side effect: seatkeeper
  (lane A's body change) is re-dated too.
- `sh bin/ft1mt check`: before 4 breaks (family-shelf, egress x2, seatkeeper); after 3 (family-shelf,
  egress x2). `python3 -m unittest tests.test_ft1mt`: 2 failures before and after, the same two
  (egress, family-shelf); a second-reader sweep of every mint row finds only egress mismatched.
- `python3 -m unittest tests.test_plugin`: before (with imports) 65 OK; after 66 OK (162 s).
  `tests.test_plugin_imports tests.test_plugin_broad`: 5 OK. `tests.test_editions`: 13 OK.
  `sh tests/readme-count-tests.sh`: TOTAL pass=4 fail=0 before and after. `sh tests/gm1gk-tests.sh`:
  pass=7 fail=0. `sh tests/lc1ck-tests.sh`: pass=11 fail=0. `python3 -m polygram.mcp --prove-red`:
  "prove-red PASS" (after only; my files do not reach it).
- Spec first: the three new test methods ran **red** before the code (4 failures: GRAMMARY.md not
  in the tree; README does not name it; no "Words this README uses"; missing doc not reported).
  Prove-red after the code, by plant (monkeypatch): `SHIPPED_DOCS = ()` -> 2 red of 2; README with
  the restart line, the unsigned paragraph, or the people.named step cut -> 1 red of 1 each.
- `sh bin/gm1gk`: 83 entries now; on `git show HEAD:GRAMMARY.md`: 36. Added 47 = 41 headings in
  three sections + 5 pointer headings + 1 seed bullet (NO4C). The old header's "forty-one ...
  three pointer entries" and NEWS's "43" were both wrong.
- `prefs.writer()`: `people.named` changes only on the keeper's turn; the keeper is
  `MENTCACHED_KEEPER`, default `corwin`.

## JUDGED (each with a falsifier)

- The README's people.named step is honest but not yet "no hand step": it tells a new user to have
  `MENTCACHED_KEEPER` set (an environment variable) before asking. Falsifier: a fresh install where
  `pref_set people.named alice` on alice's turn is accepted. Requested of F1 (REQUESTS-lane-F1.txt #1).
- The restart wording ("quit Claude completely and open it again; or turn the plugin off and on
  where the app lists your plugins") is generic, not checked against each app's current menus.
  Falsifier: an app where a plugin's server keeps its old switch after a full quit and reopen.
- The prove-red for the new Python tests is a monkeypatch run, not a second language. Owed under
  the house rule: a spec in another language (e.g. awk over a minted tree's MANIFEST) for "both
  docs ship". Falsifier: such a spec already exists (I found none).

## Files changed

polygram/plugin.py, tests/test_plugin.py (three tests added), FRAME.md, GRAMMARY.md (header),
NEWS (1.1.0 only), README.org (Copying), INSTALL (editions paragraph), INDEX.md (one line),
54 SKILL.md files (licence block only), conventions/FOOTERS.org (by ft1mt mint). Archives:
`.arc/2026-10/<folder>/<skill>/` (SKILL.md, signature, skill-manifest, each
`*_pre-licence-block-2026-10-10*`), `.arc/2026-10/FOOTERS.org_pre-licence-block-2026-10-10`,
`.arc/2026-10/plugin.py.pre-F2-2026-10-10`, `.arc/2026-10/test_plugin.py.pre-F2-2026-10-10`.
ChangeLog entry: CHANGELOG-F2.txt. Requests: REQUESTS-lane-F1.txt.

## Re-sign owed

Forty-six signed skills now read TREE CHANGED until Corwin re-signs them, because only their old
licence block (and the footer's date line) changed: aethernet-relay, altorewired, boundscheck,
build-loop (both copies: skills/ and SOFT-SKILLS/), color-theory, consent-gate, countable-gauge,
drawer-vs-door, eclipse-pass, emacs-tashaki, ethicsminions, fortress-palace, garden-usage,
hand-test, inculcat-boxer, instrument-panel, lens, medley-review, mentat-skill, pencil-your-own,
pmo, pocket-mentat, posix, posix-gotchas, principles, reformat-prompt, release-runbook, rolls,
run-card, sandboxer, savane-forensics, seams, seatkeeper (already owed from lane A), security-digest,
session-rotate, shelf-check, skill-metrics, skill-sign, skilltank, token-optimizer, two-columns,
verify-say, wire-connect, wire-ledger, writing-forms. The eight soft skills touched
(considerate-reader, grand-test-manifest, hui, intake, ngen, nongnu-steward, prior-instruction,
retro-apply) carry no signature, so nothing is owed for them. Each signed copy, signature and
manifest is kept in `.arc/2026-10/`.

## Surprised me

- The licence heal could not stop at the skills: test_ft1mt hashes each body, so a removed block
  forces a footer re-mint, which writes FOOTERS.org. P6 anticipated it ("ft1mt then re-dates them").
- test_ft1mt's first test stops at the first broken row (egress), so seatkeeper's break was hidden
  from it; `sh bin/ft1mt check` shows every break.
- A `nohup` background test run in device_bash died with the call and left no output; runs were
  redone in the foreground.

Authored by Mentat (for Corwin; claude-opus-5-5).
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
