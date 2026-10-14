# Hand-back, lane B, turn 2: Bryant's skills and the C4QL tag resolver

## Corwin's question first

> omni-tool (is this still missing? Did we just work on that? If something else replaces this for
> us check that ...)

Yes, it was still missing, and no, we hadn't worked on it. Our counterparts table said "none", and
no folder carried it. It is now a soft skill, `SOFT-SKILLS/omni-tool/`, Bryant's bytes whole, with a
notice. His own `frugal-offload` replaces one part of it: his v1.11 note (2026-09-17) moved the
decision of *when* to hand work to a local model out of the Omni-Tool and into `frugal-offload`.
That one is in too, at `SOFT-SKILLS/frugal-offload/`. Nothing here replaces the front door itself.

## Tasks

| task | state |
|---|---|
| 1. omni-tool and frugal-offload as soft skills, pinned, candor-gate run | done |
| 2. softskills.py unquotes YAML names, with a test | done |
| 3. bin/tg1rs, the C4QL tag resolver, spec test in a second language, run on today's data | done |
| NOTICE tables for gauntlet and parallax | done |

## What I saw (each with its command)

- **The newest drop.** `c4/from-bryant/2026-10-05-r3/gauntlet-nexus-skills-2026-10-05 2.zip`;
  `sha256sum` matches the intake's SHA256SUMS (`1bd59f27…`). Copied out by `unzip`, then `cp`:
  - omni-tool `SKILL.md` sha256 `d6fc0216fff7d167…` (27839 bytes), version note v1.11;
  - frugal-offload `SKILL.md` `8ecda65de33cb7c9…` (3740), `scripts/offload_gate.py` `ef35a1d24a16513e…` (2330).
  The 09-17 snapshot's omni-tool differs (`ad6351f8…`: routes to `schedule`, `consolidate-memory`).
- **No live secret in omni-tool.** `grep -niE 'secret|bearer|otp='`: every hit says the code lives
  in `WIRE-SECRETS.md`; v1.7 removed it from the file.
- **candor-gate** (`sh skills/candor-gate/scripts/candor_gate.sh DIR`):
  - omni-tool: HOLD provenance, engagement (always-on), person-data, egress; NOTE 1024-char
    description; NOTE routes.
  - frugal-offload: HOLD provenance, egress; PASS engagement, person-data; NOTEs the same.
  - `offload_gate.py --selftest`: 5/5; it imports only `sys`.
- **Routes** (backticked names checked against `skills/`, `SOFT-SKILLS/`):
  - frugal-offload: none dangle once omni-tool is in.
  - omni-tool: manifest, rosetta, primer, parley, wire-2fa, power-glove and mega-voltron are
    absent. takushi is installed on this account as a user skill. Each is named in the notice.
- **The quote bug.** `bin/ss1ls --tsv SOFT-SKILLS` and the python loader both showed gauntlet's
  and parallax's front-matter values with the quotes on. After the fix the loader gives
  `parallax 'parallax'`. ss1ls (awk) still shows them; I sent that on as a request.
- **The journals.** `persona_read` for mentat gen 1 and 2, vibrobeast gen 2, penumbra gen 2: every
  `leads-to:` is empty. That settles S9's falsifier in S9's favour.
- **tg1rs on today's data** (`sh bin/tg1rs sweep`, 13 s): 234 tags, all FORWARD-ONLY.
  - 152 are gloss rows naming Bryant and 68 name Corwin; 16 of those say "both".
  - 14 are counterpart rows that name a person.
  - None answered LINKED, BACK-ONLY, GAP or WORD.
  - Run again with `--journals` set to a scratch copy of the four front matters I read: the same
    234.
  - `seam` answers GAP ("table not reachable here: seat:notes"), because the seat is on C: and
    isn't mounted here.

## What I judge

- **The Omni-Tool reads safely as a soft skill.** Its always-on rule doesn't fire, because a soft
  skill is read only when someone asks for it. Falsifier: a session that read it once and then
  started opening every run with a Wire check.
- **frugal-offload closes a route that dangled in three places**: gauntlet's roster, the Omni-Tool
  itself, and llama-bridge's "full policy in `omni-tool`". The llama-bridge line still needs one
  paragraph in our part of that skill (request 5). Falsifier: a reader of llama-bridge who still
  can't find where the offload decision lives.
- **The back links are the real work.** tg1rs's first useful output is that nothing is LINKED. No
  journal yet writes `leads-to:`. Falsifier: one `persona_mutate` with `leads_to` set, after which
  `tg1rs persona NAME` should answer LINKED or BACK-ONLY for that row. If it doesn't, my
  back-link reader is wrong.
- **I chose the word, not the letter, as the `tag` key**, against S9's sketch. It is one cell of
  the cast table to change.

## Files

- New:
  - Bryant's soft skills: `SOFT-SKILLS/omni-tool/{SKILL.md,NOTICE.md}`,
    `SOFT-SKILLS/frugal-offload/{SKILL.md,NOTICE.md,scripts/offload_gate.py}`.
  - The resolver: `bin/tg1rs`, `conventions/c4ql-casts.tsv`, `conventions/C4QL-TAG.md`.
  - Tests: `tests/tg1rs-{SPEC.txt,spec.rb,tests.sh}`, `tests/softskills-quotes-{SPEC.txt,tests.sh}`,
    `tests/test_mcp_softskills_quotes.py`.
- Changed: `polygram/mcp/softskills.py`, `SOFT-SKILLS/gauntlet/NOTICE.md`,
  `SOFT-SKILLS/parallax/NOTICE.md`.
- In this folder: `R-ROWS-B.txt` (R37, R38), `CHANGELOG-B.txt`, `REQUESTS-B.txt`.

## Tests

| run | before | after |
|---|---|---|
| `python3 -m polygram.mcp --prove-red` | prove-red PASS | prove-red PASS |
| `unittest tests.test_mcp_softskills` (+ `_quotes`, `test_editions` after) | 19 OK | 37 OK |
| `sh tests/ss1ls-tests.sh` | 7/7 | 7/7 |
| `sh tests/notice-version-tests.sh --prove-red` | 2/2 | 4/4 (omni-tool v1.11 row added) |
| `sh tests/softskills-quotes-tests.sh` | (new) | 7/7; `--prove-red`: 5 red, PASS |
| `sh tests/tg1rs-tests.sh` (Ruby spec) | 1/22 before the tool existed | 23/23 under gawk and mawk |
| `sh tests/tg1rs-tests.sh --prove-red` | | three plants all red (back links, hop cap, sweep picking up any word); PASS |
| `test_skill_lint`, `test_plugin` | | 80 OK |
| `test_ft1mt` | | 2 FAIL, neither mine to fix: build-loop's body changed (lane T is editing it), and depth-overlap has no FOOTERS row. omni-tool and frugal-offload need rows too (request 1) |
| `editions-tests.sh` | | 19/20; E17 is about install sizes, which I didn't touch |
| R37, R38 in a scratch harness | | PASS; under the plants FAIL. R38's plant is a malformed tag, not a broken tool, so it is weaker than R37's |

## Re-sign owed

None from my files: none of them had a signature. Request 5 would be a re-sign of llama-bridge.

## Requests

These are in `REQUESTS-B.txt`:
- lane D: FOOTERS rows, and the stale gauntlet body field;
- lane T: three GRAMMARY terms;
- conductor: the counterparts rows for omni-tool and frugal-offload, a llama-bridge paragraph, and
  the same quote rule in `bin/ss1ls`.

## Local model

Not used.

## Seen arriving

| seen (UTC) | path | what | my reading |
|---|---|---|---|
| 17:22 | `SOFT-SKILLS/depth-overlap/SKILL.md`, `h/ENHANCE-2026-10-10-depth-overlap.md` | untracked, 13:49 | the other session's soft skill; it has no FOOTERS row, which makes `test_ft1mt` red; logged in ANOMALIES.md |
| 17:50 | AUTHORS, GRAMMARY.md, bin/tp2mt, plugin.py, a dozen `skills/*/SKILL.md`, Makefile, FOOTERS.org, `turn2/gv-shots/` | modified while I worked | lanes T, G and D at work in their own files, not arrivals |

## What surprised me

- `awk -v` turns `\[` into `[`, so my first scan matched `[not a tag]`. I moved the pattern into
  ENVIRON.
- The gauntlet notice said llama-bridge was "not in this garden", but it is in `skills/`. I
  corrected the row.

Mentat (for Corwin; claude-opus-5-5)
