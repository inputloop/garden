# DESIGN — the extension edition of the vibrobeast plugin (2026-10-10)

*Form: DESIGN, "what should this thing be, written where a tool can find it, before it is built". This is
chapter 4 of the C4 spell `extension` (`c4/spells/extension/SPELL.md`), written at the end of review pass 1
of its HEAVY lens. Inputs: the converged design `c4/spells/extension/runs/2026-10-10/CONVERGENCE-2026-10-10.md`,
the 27 option cards in `.../cards/` (listed in `.../cards/INDEX.md`), the eight reviews in `.../review/`,
and what the fold changed (`.../FOLD-pass1.md`). Q572 runs on its default: this is the **next edition of
the vibrobeast plugin**, not a new plugin (now 1.0.5). Everything named as a file, key or tool is a
proposal until a builder lands it. Who said what is shown by citing the source.*

**Words used here.** A *card* is one shipped tension with its default (`cards/OPTION-nn-*.md`). *gp.1* is
the garden-pony patch to Tavern 2.3.1; it runs nowhere today, so every road through a Tavern room is
dormant and each such card says "on a fresh install you get option W until gp.1 runs". The *frame* is the
one append-only table that spans, drift checkpoints, question gauges and tone readings share. A *gauge*
counts and never stops anything; a *check* compares against a line he ruled and calls a breach a fault;
a *guard* stops the work. *prove-red* means a test can be made to fail on purpose. An *R-row* is a refusal
row in `polygram/mcp/__main__.py`'s `--prove-red` suite (R1–R16 exist today).

---

## 1. Per area: what ships in this edition, and what waits

| area | ships this edition | waits for a later edition | cards |
|---|---|---|---|
| **A1 Connectivity** (Wire and Tavern) | `tavern_status` names the Tavern build (stock 2.3.1 or gp.1) and the room by name before its address, and says in words which roads need gp.1. `tavern.as` falls back to an agent already in the Tavern's `config.json` under the same owner (`claudewin`), then `claude`. | Recipe files and `rc1pe`; the key-pin road (`kp1in`, with the controller column and "admitted by"); the garden card (`gc1mt`); the room road for Wire acts; delegation records. All of it needs `rc1pe` or gp.1. | 01, 02, 03, 04, 05 |
| **A2a Socialized preferences** | Unknown rows reported under `ignored:`, never dropped; `pref_unset`; `bin/pr1ef` (the awk reader `prefs.py` already promises); declared keys from a `preferences:` list in SKILL.md front matter; a `PREFIXES` table (`person.`, `room.`, `skill.`), each with a named reader and the writer rule for `person.<name>.*`; `pref_stores` lists every place it looked. | Moving the store under a mount (card 07), with the carry of `~/.mentcached/prefs.tsv`; `pref_plan`, `pref_apply`, `pref_history`. | 06, 07, 22 |
| **A2b PRINCIPLES, commitments, ToS** | The licence heal (writing is CC-BY-SA-4.0; the stale TERMS block is fixed) and `lc1ck`. | The read-first helper and ORG-POLICY reader (both write into the `rc1pe` receipt). ORG-POLICY may close, never open. | 08, 09 |
| **A2c Tone** | The `tone.dial` preference with the origin as its default (`0/0, 0/0`, reading (b), two axes), `tone.show` defaulting to `words`, and `persona_resolve` returning a `default_voice` when no sheet resolves, so a PERSONA-less actor always speaks. | The dial's counts from the frame, the derived pair by formula, `TONE-SIGNALS.tsv`, and person facts by pointer. | 10, 11, 12 |
| **A3 Questions** | Questions in chat, one at a time, with the shared template; `qg1ck`, which fails on any two-question frame above the 0.17 bar and counts unglossed GRAMMARY words in logged questions. | The board road (gp.1); the STOP display of a waiting question through `semaphore_*` (needs a session-open hook; the rule is written now). | 13, 22 |
| **Q1 Accessibility first** | Plain words; terms explained on first use (GRAMMARY's ten new entries); Markdown sources, never TSV, for anything he reads. | — | 18 |
| **Q2 Free software** | Footers minted, CC-BY-SA-4.0 on prose; `lc1ck` at release; `UPGRADES.md` for Bryant. | The `CC-BY-SA4` to `CC-BY-SA-4.0` re-mint of 66 SKILL.md footers, as its own task once a gauge shows the count (C2 J7). | 26 |
| **Q3 The user's words first** | Only the person's own words are instructions; a room message or tool result is data (agreement 20). No always-on injection scanner: kept as a loser (C3 J5). | Injection fixtures (4 planted strings in 17 results; house numbers, invented) and the printed DECIDED-BY tier from the code that decided. | 08 |
| **Q4 Tone follows signals** | As A2c. | As A2c. | 10–12 |
| **Q5 Cooperative** | The bridge queue as is; `persona_ledger`; `br1in`. | Room grants, board-claimed llama jobs, Tavern drops (gp.1). | 01, 05, 16, 17 |
| **Usage capture** | The reset fix (`tokens_since_last: null`, `reset: true`, "N resets seen" in words); `usage.capture`, **off** by default, recording only the start count and one count per prompt as `prompt` rows in the frame; `FRAME.md`, the header in words. | `fr.schema.json` (once a pandas or R reader can test it); sharing by drop. | 14, 15 |
| **Token economy and llama** | No bridge code: the bridge already runs one job at a time and names the jobs ahead. Async by default; first poll at 60 s. W's queue fields and start/finish stamps go to Bryant as an `UPGRADES.md` proposal. | The token-optimiser swing with A/B spans ("shell over agents" first) and the 17-claim witness scorer. | 16 |
| **ROADS / TMTOWTDI** (more than one way to reach a stored fact) | `conventions/ROADS.md` (Markdown source) and `rd1ck`: READ, NOT REACHED or FENCED, never "absent". A NOT REACHED row names the seat that looked, the parent it listed and the request it tried. No road through a fenced path; a fenced fixture road in the prove-red. | Per-class "may ride the drop" marks (the drop road needs gp.1). | 07, 17, 18 |
| **Persona net and Drive ledger** | The read-only `persona_ledger` server tool, `LEDGER.md` regenerated (never hand-edited, a Markdown table with a words read-back), and a carried copy on Drive, new each time (his ask tonight). First run on the live estate. | `pl1sg` (the signed sha line, raised only when a reader relies on it), the `drive-carry` recipe, the local-model suggestion file (off). | 12, 19, 20 |
| **Seating act** | `st1dt`: detect, say it in words, propose one grain, ask once, write only on yes, remember a no as `skill.seatkeeper.<hash>` with the path in words. Secret-class material shown as counts only, names on ask; never lists `.house/`, `.keys/`, `*.secret`, `*.key`, invoices, chat bodies, `Z/`, `a/`, `p/`, SAVANNAH or `.patternwalk/`. | The backlog sweep beyond the folders attached tonight. | 21, 22 |
| **Bryant-modes access** | `br1in` minimal (his "most interested" item): read-only intake that never installs, signs or edits his files. `polygram/hooks.md`, naming the existing acts as the hooks (seating = intake, candor-gate = before-trust, egress = before-ship, session close = exit, and "delivered, confirmed on disk"), plus card 27: hooks reach his mechanisms, his worn soft skills stay worn. The gauntlet NOTICE fixed to v1.5. | The Wire and room checks at session open; `BRYANT-INDEX` across all three intake places; the Tavern drop road (parked, unpark on his first drop in a room); the four owed modes (map of the house, always-deliver, paired mint on our side, precedence chain). | 23, 24, 25, 27 |
| **GRAMMARY and docs as tested artifacts** | GRAMMARY line 1 says it is a made word; ten new entries with a "whose word" line, Bryant's terms as pointer entries; its own footer; `gm1gk`; README facts minted from code inside `plugin.py`; the release reason line, the NEWS-lag gauge and the four missing NEWS entries. | `dc1ck` (the doc check); the MERLIN cold read of the new entries. | 18, 26 |
| **Egress to the AI vendor** (new in pass 1) | Each new switch's words say what the vendor sees; `st1dt` and `persona_ledger` end with a words read-back of what the model was shown. | A generated "what leaves, to whom" page per switch (C3 idea 6). | 06, 07, 20, 21 |

## 2. Contracts between lanes (so the four lanes never need each other's files)

- **Preference keys.** Lane A owns `prefs.py` and adds these keys to `KNOWN` with their defaults:
  `usage.capture` = `off`; `tone.dial` = `0/0, 0/0` (the origin: signals seen / signals total, on the two
  axes, answer length and narration); `tone.show` = `words`. Lane B reads them by name through the existing
  preference reader and never edits `prefs.py`. If Lane A has not landed yet, Lane B's code treats a missing
  key as its default.
- **The frame.** One headerless TSV row per event, append-only, names one path over (S3 3.2):
  `TS KIND SESSION SPAN LABEL TOKENS_LEFT BY KEY VALUE LIKELIHOOD CONFIDENCE NOTE`. KIND is `start`, `mark`,
  `stop`, `prompt`, `checkpoint`, `gauge`, `tone` or `pref`. Lane A writes it (inside `spans.py`; no new
  server file) and describes it in `FRAME.md`. Lane D's `qg1ck` reads `gauge` rows and builds its fixtures
  from this line, not from Lane A's code.
- **R-rows.** `polygram/mcp/__main__.py` is shared, so no lane edits it. Each lane writes its R-row (the
  words line first, then the code) to `advice/EXTENSION-2026-10-10/R-ROWS-lane-<X>.txt`, and the conductor
  folds them in and runs `python3 -m polygram.mcp --prove-red`. Numbers: Lane A R17–R18, Lane B R19–R20,
  Lane C R21–R22, Lane D R23–R24.
- **ChangeLog.** Each lane writes its entries to `advice/EXTENSION-2026-10-10/CHANGELOG-lane-<X>.txt`, never
  to `ChangeLog`. Nobody commits. Nobody runs `make dist`: the conductor does, unsigned (`UNSIGNED=1`).
- **Second-language tests.** Where something escaped the tests before, the new test is written in a language
  different from both the work and its earlier tests. On the linked computer `tclsh`, `ruby` and `awk` are
  all at `/usr/bin` (checked 2026-10-10 with `which`). Whether Tcl also runs on avalon's MINGW64 is unchecked:
  if it does not, Ruby is the fall-back (C2 J6).
- **Build discipline.** Each task goes through `spells/build-turn/`: `c4 build-loop open`, a design and QA
  plan, the SPEC line written first, then the test, then the work, with `--prove-red` or an R-row.

## 3. THE BUILD PLAN for this edition

Started from C2's fourteen tasks (`review/C2-builder.md`, BUILD PLAN), amended by the fold: C2's task 0
(names) is settled in this document; tasks 1–12 are split into four lanes with disjoint files; three items
C2 put in later editions are pulled in (`persona_ledger` with a Drive `LEDGER.md` carry, at his ask tonight;
`br1in` minimal, his "most interested" item; the `tone.dial` preference with the origin default and
`default_voice`); task 13 (the unsigned mint) is the conductor's. Sizes: **S** under an hour, **M** one to
three hours.

### Lane A — preferences, spans and the frame

Files (only this lane touches them): `polygram/mcp/prefs.py`, `polygram/mcp/softskills.py`,
`polygram/mcp/spans.py`, `bin/pr1ef`, `bin/sp1rp`, `skills/seatkeeper/SKILL.md`, `FRAME.md`,
`tests/test_mcp_spans.py`, `tests/test_mcp_softskills.py`, new tests named below, `tests/fixtures/lane-a/`.

| # | task | test (SPEC line first) | size |
|---|---|---|---|
| A1 | **Fix the span reset** (agreement 22, card 15). Where `tokens_left` rises, return `tokens_since_last: null` and `reset: true`, keep that leg out of the totals, say "N resets seen", and word the prompt count "counted from resets; the app's own housekeeping can add a reset, so this count may run high". Teach `bin/sp1rp` the same. | SPEC: "a rising token figure is a reset, never a negative count". Unit test in `tests/test_mcp_spans.py`, red on today's `spans.py:257`. The fault escaped every test (work Python; earlier tests Python and awk), so a **new spec in Tcl**, `tests/spans-reset-spec.tcl`, with wrapper `tests/spans-reset-tests.sh --prove-red` that plants the old subtraction. R17 "a reset never yields a negative count". | S |
| A2 | **`usage.capture` and the frame** (agreements 21, 23; card 14). Add `usage.capture` (off), `tone.dial` (origin) and `tone.show` (`words`) to `KNOWN`. When capture is on, write only the start count and one `prompt` row per prompt, in the frame shape, inside `spans.py`. Write `FRAME.md`: the twelve columns in words, one path over. | SPEC: "off means no row; on means two counts and nothing else". R18 "capture off writes no row". A unit test that a `prompt` row carries only TS, KIND, SESSION, TOKENS_LEFT and BY. | M |
| A3 | **Report unknown rows, add `pref_unset`, write `bin/pr1ef`** (agreements 8, 9). `current()` lists unknown rows under `ignored:`. `pr1ef` reads the same file with awk. | SPEC: "a row is reported or applied, never dropped". The silent drop and the missing `pr1ef` both escaped (work Python plus awk; earlier tests Python), so a **Ruby spec**, `tests/pr1ef-spec.rb`, with wrapper `tests/pr1ef-tests.sh --prove-red`: Python and awk must agree on one file, and a planted dropped row goes red. | S |
| A4 | **Declared keys, prefixes, the writer rule, and the seatkeeper "no"** (agreement 6; cards 06, 22). `softskills.py` reads a `preferences:` list from SKILL.md front matter. `prefs.py` gains `PREFIXES` (`person.`, `room.`, `skill.`), each with a named reader and a name check. A `person.<name>.*` row is written only from that person's own turn, a participant Corwin named, or with a consent row's id; `person.<other>.*` rows stay out of export and the frame. Seatkeeper reads `skill.seatkeeper.<hash>=no`, whose value carries the path in words; `pref_list` reads it back as the path. | SPEC first, then **`tests/prefs-declared-spec.rb`** with sh wrapper and `--prove-red`. Plants: a key no skill declares is refused; an unknown `person.` name is refused; a `person.corwin.*` row from another speaker is refused; a `pref_list` read-back without the path in words goes red. | M |

### Lane B — the Tavern face, persona and the tone default

Files: `polygram/mcp/tavernface.py`, `polygram/mcp/persona.py`, `tests/tavernface-SPEC.txt`,
`tests/tavernface-tests.sh`, `tests/test_mcp_persona.py`, new tests named below, `tests/fixtures/lane-b/`,
and the generated `LEDGER.md` (proposed home `AS4CE0001/persona-ledger/LEDGER.md`, not under `h/`, which is
his scratch pad; the builder confirms the home with `bin/hb1ck --layout`).

| # | task | test | size |
|---|---|---|---|
| B1 | **Tavern status and `tavern.as`** (agreements 2, 3; card 02). `tavern_status` names the build (stock 2.3.1 or gp.1), the room's name before its address, and which roads need gp.1, in the `CARRIES` style. `tavern.as`, when unset, resolves to an agent in `config.json` under the same owner, then `claude`. | SPEC rows F5 and F6 written first in `tests/tavernface-SPEC.txt`, then `tests/tavernface-tests.sh` (sh plus awk) with a fixture `config.json`; a planted second owner must not be picked. | S |
| B2 | **`default_voice` and the tone default** (card 11). The not-found branch of `persona_resolve` (`persona.py` about lines 352–360) returns `default_voice`: plain voice at the origin, read from `tone.dial` and `tone.show` (missing key = default). | R19 "a PERSONA-less actor still speaks". A unit test that, with no sheet, the reply holds one plain line and no numbers when `tone.show=words`. | S |
| B3 | **`persona_ledger` and the Drive `LEDGER.md` carry** (agreements 29–32; card 19; his ask tonight). A read-only tool inside `persona.py` (no new server file, so `_SERVER_FILES` is untouched) regenerates `LEDGER.md` from the sheets' "Whose inverse I carry" sections: a Markdown table plus a words read-back. First run on the live estate: the Mentat sheet's two copies (`h/` and `h/persona/`) must show DIVERGED with both shas; which is master is his pen. Carry: a new Drive copy each time through the session's Drive connector, checking the size and md5 Drive reports; if the connector is not there, a hand card. | SPEC first. Plants: a sheet naming a persona that does not exist; a twin that differs; a third-party fact in a sheet, which must not appear in `LEDGER.md` (C3). New test in **awk**, `tests/persona-ledger-spec.awk`, reading the generated table (the work is Python; the persona tests are Python). R20 "the ledger states nothing that no sheet says". | M |

### Lane C — docs, licence and release

Files: `GRAMMARY.md`, `NEWS`, `polygram/plugin.py` (**only Lane C edits it**; the README mint lives here),
`c4/man/licensing-defaults.md`, `bin/lc1ck`, `bin/release`, `UPGRADES.md`, `polygram/hooks.md`,
`SOFT-SKILLS/gauntlet/NOTICE.md`, `bin/gm1gk`, `tests/test_plugin.py`, new tests named below,
`tests/fixtures/lane-c/`.

| # | task | test | size |
|---|---|---|---|
| C1 | **Heal the licence** (closed question; C2 O15). Archive the old TERMS block (`c4 archive keep`), then change its writing line to CC BY-SA 4.0 (the TA model alone stays CC BY 4.0). Prepare the dated line for `claude--pub/.gate` (new work BY-SA; published essays keep CC BY 4.0). Edit, write it down, tell him, he re-signs. `bin/lc1ck` checks that every shipped ToS, privacy text and prose footer says CC-BY-SA-4.0 and that no prose file carries a code licence. | SPEC first. The drift escaped (work sh; earlier tests sh, `tp2mt-tests.sh`), so a **Ruby spec**, `tests/lc1ck-spec.rb`, with `tests/lc1ck-tests.sh --prove-red`: plant "CC BY 4.0" in a scratch ToS, and a GPL line on a scratch `.md`. `tests/tp2mt-tests.sh` stays green. R21 "a prose file with a code licence is refused at release". | S |
| C2 | **Release: reason line, NEWS-lag gauge, missing NEWS, two new refusals** (card 26). `bin/release --news-reason "..."` writes its line into NEWS in plain words. A gauge prints `__version__` beside the top NEWS heading at every close and `make dist`. NEWS gains 1.0.2–1.0.5 from `releases/` and the ChangeLog. The release refuses a retired bracket tag in shipped prose and a code licence on prose (it calls `lc1ck`), each passable with the reason line. | SPEC first. Four releases went round the guard (work sh; earlier tests sh), so a **Tcl spec**, `tests/release-gate-spec.tcl`, with wrapper. Plants: no NEWS and no reason refuses; a reason passes and lands in NEWS; a planted tag refuses. R22 "no NEWS entry and no reason line refuses the release". | S |
| C3 | **Mint the README facts** (agreement 41). The server count and table, the edition floor and the preference keys come from `SERVERS`, `editions.py` and `KNOWN` (read, not edited). Fix the "one plugin, three servers" docstring (line 53). Add the prose-count gauge (the number word next to "servers" against `len(SERVERS)`). | SPEC first. The count drifted before (work Python; earlier tests Python), so an **awk spec**, `tests/readme-count-spec.awk`, with `tests/readme-count-tests.sh --prove-red` (plant a seventh server: the README must change). `tests/test_plugin.py` and `tests/test_plugin_imports.py` stay green. | M |
| C4 | **GRAMMARY as a tested artifact** (agreements 40, 43, 44). Line 1 says it is a made word. Add the ten entries from P3 §4 (seat, soft skill, spell, prove-red, gauge/check/guard, falsifier, persona sheet, road, tone dial, guessed pair), each one entry per heading with four labelled lines and a "whose word" line; Tavern, Wire and garden-pony as pointer entries crediting Bryant. Give GRAMMARY its minted footer. `bin/gm1gk` prints counts at open and close (entries, entries missing "whose word", tree words missing from GRAMMARY) and never fails. Spelling: `word_register` aliases plus a word list minted from GRAMMARY; NOT CHECKED when no dictionary is reachable (`aspell` and `hunspell` are absent). | `gm1gk` count rows in `tests/gm1gk-tests.sh` (a planted entry without "whose word" moves the count). QA-2: a cold quiz on the ten entries, with the local model as first reader for unclear words only. | M |
| C5 | **`UPGRADES.md`, `hooks.md`, the NOTICE fix** (agreements 37, 38; cards 16, 24, 27). `UPGRADES.md` is a suggestion book (PROPOSED, ACCEPTED, DECLINED, SHIPPED) that only Bryant presses; first entry: the vb.2 queue fields and start/finish stamps for `llama_bridge.py`. `polygram/hooks.md` names the existing acts as hooks, adds "delivered, confirmed on disk", and says which of Bryant's modes are reached and which are worn (card 27). `SOFT-SKILLS/gauntlet/NOTICE.md` line 3 says v1.5. | `test_vendored_bytes` stays green (no edit to Bryant's bytes). A grep row "NOTICE version = SKILL version" goes red on a planted 1.4. One countable row per hook named. | S |

### Lane D — new tools

Files: `bin/st1dt`, `bin/rd1ck`, `conventions/ROADS.md`, `bin/qg1ck`, `bin/br1in`, their tests named below,
`tests/fixtures/lane-d/` (including `tests/fixtures/lane-d/roads/`).

| # | task | test | size |
|---|---|---|---|
| D1 | **`st1dt`, the seating detector** (agreements 33, 34; cards 21, 22). Detect an unseated folder, say it in words, propose one grain, ask once. It never writes; a yes or no goes through the seatkeeper skill and `pref_set`. Secret-class material is a count ("3 files kept out of view"), names only on ask; never lists or opens the never-list (§1, Seating act). Ends with a words read-back of what the model was shown. | SPEC first, then `tests/st1dt-tests.sh --prove-red`: hide a `.gate` (must be found); plant `.keys/x`, `a.secret`, `Z/note` and `.patternwalk/t.log` (none may be listed or opened; only a count). | M |
| D2 | **`ROADS.md` and `rd1ck`** (agreement 28; cards 07, 17, 18). The table is Markdown and is the source; W's eleven rows less the fenced road, with T's per-class rows. `rd1ck` prints READ, NOT REACHED or FENCED, never "absent"; a NOT REACHED row names the seat or machine that looked, the parent folder it listed and the request it tried (or "none open"). | SPEC first, then the **Ruby runner** `tests/rd1ck-spec.rb` with sh wrapper and `--prove-red`: a blank road 1; a fixture road under a fenced path, which must print FENCED and not be read; recorded outage fixtures under `tests/fixtures/lane-d/roads/`. R23 reserved: "a fenced road is never read" (used only if `rd1ck` gains a server face). | M |
| D3 | **`qg1ck`, the question gauge** (agreement 18; cards 13, 22). Reads `gauge` rows in the frame (contract in §2); fails on any two-question frame whose confidence that the second could be skipped is above 0.17; counts unglossed GRAMMARY words in logged question text; counts `pref` mirror rows. | SPEC first, then **`tests/qg1ck-spec.tcl`** with wrapper and `--prove-red`: a planted 0.18 goes red; 0.17 passes; a question with an unglossed tree word moves the count. | S |
| D4 | **`br1in` minimal** (agreements 35, 39; card 25). Read-only intake of a Bryant drop, by whatever road it came: check the transport sums; verify his pinned key where a signature is present; hash every file; write a report in words (each file's path in words beside its hash) to the intake folder's own report, never into the drop; an ACK of hashes and a verdict, never content. It never installs, signs or edits his files, and never reads under a fenced path. | SPEC first, then `tests/br1in-tests.sh --prove-red` with a fixture zip (one flipped byte goes red), plus a **Ruby check** `tests/br1in-noedit-spec.rb` that the drop folder's bytes are unchanged after a run. R24 reserved: "br1in never writes into a drop". | M |

### The conductor (not a lane)

Folds `R-ROWS-lane-*.txt` into `polygram/mcp/__main__.py`; runs `python3 -m polygram.mcp --prove-red`
(R1–R24), `make kit-quick`, `sh tests/mcp-tests.sh` and its `--prove-red`; merges the four
`CHANGELOG-lane-*.txt` into `ChangeLog`; runs `UNSIGNED=1 make dist`. Signing and installing are Corwin's.
Guessed pair for "all four lanes land green in one night": likely 0.6, confidence medium (both guesses).

### Later editions, in dependency order

1. `rc1pe` and the recipe format (card 04); then ORG-POLICY (08), the read-first helper (09), the direct
   Wire road (02), the key pin with the controller column and "admitted by" (01, `kp1in`), the garden card
   (03, `gc1mt`).
2. The tone dial's counts and derived pair (10, 12; `TONE-SIGNALS.tsv`), the waiting-question STOP at
   session open (13, 23).
3. `pl1sg` and `drive-carry` (19); the local-model suggestion file, off (20).
4. `BRYANT-INDEX`, the Wire and room session-open checks (23), the caterpillar docking test (24), the
   four owed Bryant modes (27).
5. Moving the preferences store, carrying `~/.mentcached/prefs.tsv` (07).
6. `fr.schema.json` and sharing by drop (14).
7. Everything that needs gp.1 (02 room road, 05, 13 board, 16 board, 17).
8. The footer re-mint `CC-BY-SA4` to `CC-BY-SA-4.0` across 66 SKILL.md files, as one task.

## 4. Still open

One question, asked one at a time: the shell tapes in `wheels/.patternwalk/` sit in a folder an AI session
can write to. Shall we hand you a one-line card to move them out of the mount? Until answered they are
secret-class (never opened, a count only). Guessed pair: likely medium that it changes the seating of
`wheels`; confidence low. On default, not asked: plugin sessions appear in the Tavern as `claudewin`.

---
Authored by Mentat (for Corwin; claude-opus-5-5).
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0


## Ruled after the fold (2026-10-10 03:45)

The one open question is closed. Corwin, on the `.patternwalk/` recordings in G:\wheels: "This is the only session they have been mounted to, not inside our scope for seating." They stay where they are. The seating tools leave them out of scope, and no tool reads, hashes or lists them.

Corwin, 03:47: "Meaning .patternwalk/ recordings specifically. If we want to ingest them it will be via tool and the output from that could be something we seat (or the tool could have an MCP surface, etc, from a Claude/system/user API/HUI integration standpoint)."
So the recordings themselves are never seated, read or listed. A future patternwalk ingest tool, with an optional MCP surface, would produce output, and that output is what can be seated. That tool goes into the later-editions list.
