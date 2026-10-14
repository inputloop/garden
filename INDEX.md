# INDEX.md — orientation map (refreshed 2026-07-02; amended 2026-09-13, 2026-10-04 and 2026-10-10, see the amendments below)

Lost? Read `model.md` first (the operating model; its Version line says which), then this.

**This table is the map, and it is checkable.** `sh bin/hb1ck --layout . --since FILELIST` compares where
a session's files landed against the directories named in backticks below. A deliverable outside every
documented home is a FAULT — either it moves, or this table gains a row and the amendment says why.

## Layout

| where | what |
|-------|------|
| `polygram/` + `tests/` + `bin/` | the code (stdlib-only; `make check` and `sh bin/gd1ck` say how many tests, and whether green) |
| `skills/` | curation of record — the version-controlled skills polygram mints |
| `SOFT-SKILLS/` | (2026-09-23) skills served **live** by mentcached's dynaloader (`soft_skills_list` / `soft_skill_read`, twin `bin/ss1ls`): one folder per skill, `SKILL.md` in the installed-skill format, nothing minted or installed. A soft skill that earns it graduates unchanged into `skills/` |
| `journal/` | the Grader's Tales — method, never cases, never third parties; keeper decides what ships |
| `h/` | **the keeper's scratch-pad.** Not an output shelf. Deliverables go to their documented home above; if something of mine is here it is mislaid |
| `mainmem/` | main-memory working area: ferry manifests, receipts, OPEN notes |
| `metrics/` | the skill-metrics store (2026-09-22): `log` (ITEM STATE CUR LAST DATE NOTE), `skill-metrics/<item>` (last STATE — `cat` it), `archive/` (content-keyed constituents). Written only by `bin/sk2mt` (→ `skills/skill-metrics/`), usually via `bin/gd1ck --record`. Contract: `skills/skill-metrics/SPEC.md` |
| `models/` | operating-model documents (distinct from `.models/`, which holds model.md snapshots) |
| `tools/` + `wire/` | host-side helpers, and the wire's working files |
| `archive/` + `Inbox/` | inbound and cold storage; `Inbox/` is intake, and intake gets dispositioned |
| `Claude outputs/` | the desktop app's per-turn spill: a drop-zone, not a curated shelf (gitignored) |
| `records/` | (2026-10-04) dated working records lifted off the root, by month (`2026-07/`, `2026-08/`, `2026-09/`), moved byte-for-byte with their signatures; nothing reads these paths. `records/README.md` says what is where |
| `dist/` | minted artifacts, written by `make dist` (gitignored; `make clean` removes it; the version minted is in `releases/`) |
| `conventions/` | (2026-10-04) the house conventions every tool reads once: `house.env` (who, which licence, persona, model, the local time zone: tools write UTC) and `FOOTERS.org` (per skill: version, revised, spine), from which `bin/ft1mt` mints each skill's footer; never typed by hand |
| `advice/` | the paper trail — every mint/decision leaves a dated note |
| `memory/` + `MEMORY.md` | Mentat notes + index; tags here drive synthesis |
| `book/` | the persona/book corpus (CORWIN.md, C4*, PROLOGUE, MTB stubs, mentat-account/chronicle, THE-ECLIPSE-PASS, SKILLS-REVIEW) |
| `.arc/` | mirror-tree archive of the dormant (ledger: `.arc/README.md`) |
| `.eclipse-increments/` | parked losing/contrast models from eclipse passes (ex-torture), **and superseded drafts**. The game books' three drafts sit here as `2026-09-13-books-draft-{1,2,3}/`, each with a MANIFEST and a README; draft 1 carries Corwin's twelve signatures. `sh bin/hb1ck --park book/games .eclipse-increments` refuses a shelf file whose bytes match no parked copy |
| `.models/` / `.sessions/` | model.md snapshots / rotated continuity files |
| `releases/` | (2026-09-24) one file per `make dist`: `start`, `from`, `finish` stamps written by `bin/rl2bp` around the mint (z bumps in `polygram/__init__.py`; a start with no finish is a torn build and the next run says so). Survives `make clean`, which removes `dist/` |
| `bin/tp2mt` | (2026-09-25) mints `TERMS-OF-SERVICE.md` and `PRIVACY.md` for each `make dist`, stamped with that build's version, from claims it checks against the server source first (a claim that no longer holds stops the build); every filter named; the same Words block in both; copies to the pub persona shelf when `/h/pub/persona` (or `$PUB_PERSONA`) is there. Tests: `sh tests/tp2mt-tests.sh [--prove-red]` |
| `.door/` | (2026-09-23) this project's door parts — `c4/bin/door render --for .` pulls them in after C4's; one rule per file, the mountain's way of finding a rule by context (`c4/analysis/context-stacking/MODEL-2026-09-22-the-upside-down-mountain.md`). Nothing renders until the keeper renders |
| `claud-qa-hold/`, `gated/` | held items awaiting consent/QA; sealed packs |
| `externs/` + `externs.json` | upstream sources (frozen or synced) |
| `doc/`, `site/` | Texinfo manual, accessible one-page site |
| GNU furniture | AUTHORS · COPYING · ChangeLog · INSTALL · Makefile · NEWS · README.org |
| live registers and desks at the root | `MEMORY.md` (the note index) · `labels.tsv` · `externs.json` · `PERSONA-CORPUS.md` (read by `bin/cs1gk`) · `GRAMMARY.md` (the lexicon) · `FRAME.md` (the usage record's columns, in words; both ship in the plugin) · `CLAUD_QA_HOLD.md` and `SIGN-QUEUE.md` (the desks) · `PROJECT.md` (PMO linkage) · `model.md`, `last-response.md`, `.last-prompt.md` (continuity) |
| `h/persona/` | the character-sheet masters (the Mentat and shopgarden CHARACTER sheets, `PERSONA-gw7.md`, `VIBROBEAST.md`) and `ROSTER.md`, the one place in `h/` that is a shelf; every sheet's home is listed in the roster |
| `peers/` | (2026-10-05) what our peers need, rendered beside what we use: `peers/<peer>/<skill>/` is a skill as we hand it back to that peer, their work with our changes and their tests still passing (`peers/README.md`) |
| `pub/` | the publication shelf's clone (gitignored): read here, published from there |
| pasted chats at the root | `c*.txt`, `21.txt`: his pasted transcripts (gitignored), kept where he put them; not an output shelf |
| `UPGRADES.md` | (2026-10-10) the suggestion book for Bryant's software we carry byte for byte (PROPOSED, ACCEPTED, DECLINED, SHIPPED; only Bryant moves an entry on) |
| `ERRATA` | what the build beside it still owes, and nothing else (his "ERATA file"; trimmed 2026-09-29): what, where, why it waits, the change, the check; fixed entries leave it for ChangeLog and NEWS |

## Keeper's own archives — check these before calling anything missing (2026-09-13)

`book/*.zip` and `book/*.7z` are **Corwin's** full-shelf snapshots, taken by hand at points during a
round. They are not generated by any tool here and no manifest in this tree lists them, so a sweep of
`.eclipse-increments/` will not see them.

This is written down because a session declared a draft destroyed after checking only the increments
tree; the draft was sitting in `book/book-20260913-1217.zip`. **Before reporting any artifact gone,
check `book/*.zip`, `book/*.7z`, `.arc/`, `archive/` and `Inbox/`** — and report absence as
*"I cannot see X in <place>"*, never as *"X is gone."*

Known, verified byte-identical to the parked drafts: `book-20260912.zip` = draft 1 ·
`book-20260913-1217.zip` = draft 2 · `book-20260913-1147.zip` = draft 3. The `.7z` additionally carries
`h/.arc/`, whose originals are still in place.

## What the map was missing (amendment, 2026-09-13)

This table was refreshed 2026-07-02 and then the tree grew. On 2026-09-13 a session wrote its
deliverables into `h/` — the keeper's scratch-pad — while `skills/`, `book/` and `advice/` sat here
documented and unread. The session's fault was not opening the map. The map's fault was that
`journal/`, `mainmem/`, `models/`, `tools/`, `wire/`, `archive/` and `Inbox/` had never been added to
it, so a reader who *did* open it would still have found a partial answer.

Both are now fixed: the rows are here, and `bin/hb1ck --layout` makes the map checkable so the next
drift is caught by a command rather than by the keeper's eye.

Not listed on purpose: `.git`, `.pytest_cache`, `.private`, `.synth-drafts` — machinery and holds, not
shelves anyone files to.

## The root, tidied (amendment, 2026-10-04)

Forty-odd dated files (session records, run cards, seat diffs, signed memory snapshots) had
collected at the top of the tree. They moved to `records/<month>/` with `git mv`, signatures beside
them; skills that cite them do so by name, and the name still finds them. A stale signature over the
2026-08-17 map (`INDEX.md.asc`) went with them, since it no longer matched this file. The root now
holds only what a reader or a tool needs there: the furniture, the four read-first files (README.org,
this map, model.md, ERRATA), and the live registers and desks in the table above.

## The skill network (data flow)
```
lived moment
   │  Mentat (notice + remember, tag)
   ▼
memory/ notes ──► SkillTank (spot: NEW/ENHANCE/LEAVE) ──► skill-creator
   │                                   ▲
   │  polygram (forge)                 │ EthicsMinions (guard the surface)
   ▼                                   │
gate → advice → synth → dist (.skill) ─┘
   │
   ▼
ccspt (consent + provenance + trust)  ──►  ghostwheel federation (signed exchange)
```

## Behavioral templates (now in book/)
| template | who | status |
|----------|-----|--------|
| `book/CORWIN.md` | Corwin | 1.4-sa (2026-10-04), flagship, pluckable (secret kept out) |
| `book/Bryant-MTB-Stub.md` | Bryant Frankford | seed v0.2 — his to fill |
| `book/Kelsey-MTB-Stub.md` | Kelsey | seed v0.1 — hers to fill |
| `CLAUDE.md` (root) | Claude / Mentat (instrument-comrade) | codename Vibrobeast. **Not in this tree** (checked 2026-09-27): the live project instruction is kept in the Cowork project, not as a file here |

Consent on each template is scoped by the **c4-consent-quartet** (identity ·
package · subscription · register). The eclipse method write-up:
`book/THE-ECLIPSE-PASS.md`.

## feeds →
`GRAMMARY.md` (the words) · `model.md` (the operating model) · `CLAUD_QA_HOLD.md`
