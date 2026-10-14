# DELTAS — mentat modeling shares, 2026-09-04 → 2026-09-05 (one file to ingest)

**Routing:** bank row **Q505** (this file is its receipt) · this file's own sha256 is the routing
code (last line of the manifest below; verify with `sha256sum -c` from `c4/h/`). **Open this
first** in the next C4 session, after `sh h/c4prime.h`. Everything named here already sits in
`c4/h/` as same-bytes copies of masters in `/f/claude/AS4CE/AS4CE0001/h/`; the keeper's tree is the
master, C4 holds the duplicate (duplication-c4-or-pmo: *may I copy it — yes; what happens when the
original changes — the manifest goes stale and says so*).

## How to ingest (the next session's first four moves)
1. `sh h/c4prime.h` — the door.
2. `cd h && sha256sum -c DELTAS-2026-09-05-mentat-modeling.sha256` — every line OK, or the
   master moved since and the diff is the delta to read.
3. Read the **delta column** below; open only what changed since your last C4 session.
4. Deal Q505 through the w0rk lane if a ruling is wanted; otherwise the MEMORY.md dated sections
   (2026-09-04 evening/late/latest, 2026-09-05) carry the narrative.

## The set, and the delta each carries

| file (in `c4/h/`) | what it is | delta vs before this pair of sessions | ingest as |
|---|---|---|---|
| `MODEL-2026-09-04-experiment-seat-contact-sheet.md` | contact sheet: where everything is, how to reach it, who holds it, freshness check | **new**; AS.CE fork closed 09-04 late | reference (read §4 when lost) |
| `MODEL-2026-09-04-person-intrinsic.md` | PERSON as an intrinsic of C4 toward publication (5 tiers, the floor, ep1nt, Q166) | **new**, pinned `d53b730c…`; A1–A6 pending in its LENS | model; v2 after the units land |
| `LENS-2026-09-04-person-intrinsic.md` | GRAIN=4 read of the above; PASS WITH AMENDMENTS; lens.py reader-sha finding (Q12) | **new** | measurement |
| `HYPOTHESIS-2026-09-04-csspt-prompt-by-model.{md,tsv}` | the model of how the ccspt/LENS prompt runs go, per model × behavior; blessed "the model until better" | **new**; bound to prompt S3 `f02435d0…` (seat runs S4 `e3957029…` — re-date at first scoring) | model + ledger |
| `HYPOTHESIS-2026-09-04-reflections-slide.md` | learnings beside the hypothesis after the slide expansion | **new** | note |
| `ENHANCE-2026-09-04-queue.md` | skilltank queue Q1–Q13, citations style | **updated 09-05**: Q11 extended with mutations 5–8 | intake for the forge desk |
| `DIAGRAM-2026-09-05-experiment-symbiosis.{json,svg}` + `dc1sv` | Corwin's drawing as the canonical diagram document + the fifth-fabric SVG reader | **new** (tool + doc + render; regenerate: `python3 dc1sv DIAGRAM….json`) | draft tool in `h/`; candidate for `bin/` at ship |
| `MODEL-2026-09-05-architecture-itself.md` | `H:\ta` from architecture's own viewpoint; verdict *high-five with a floor* | **new**, pinned `de90f0ca…`; A1–A8 pending two keeper rulings | model |
| `LENS-2026-09-05-architecture-itself.md` + `LENS-2026-09-05-roll.json` | three racks, 15 readers; the floor doesn't ship; loop idle since 08-29 | **new** | measurement + the roll receipt |
| `MODEL-2026-09-05-skills-focus.md` | skills from the sharers' perspective: four floors from memory grains against the palace + the resurrection pass | **new** | model; its Floor R is the resurrected ENHANCE list |
| `CHARACTER-2026-09-05-shopgarden.md` | the Garden as C4 sees it — a place-persona sheet | **new**; travels only with EM's concurrence (see its §9) | draft; the handle is the keeper's to give |
| *(bank)* `evidence/question-bank-iTNH.tsv` | Q503 picker-UX · Q504 the slide (OPEN → DEEPENED → ANSWERED-BY-KEEPER) · **Q505 this ingest** | rows appended 09-04/05 | rulings via w0rk |
| *(memory)* `MEMORY.md` | sections 2026-09-04 (evening · late · latest) and 2026-09-05 | appended | narrative |

## Deltas in one breath (what changed in the shop's understanding)
- The slide: `AS.CE` is a balanced pair with the run-level in the slot — the pattern `ep1nt`
  declares; 4 GRAIN · 9 GREAT · 17 GRAND; units withheld.
- ccspt is the context actor of the experiment; poly is *the issuer's spoke* (guess, ~60%).
- The person system: five tiers now (HOST joined); the floor's rule of rules is *only Corwin
  installs COPYING*; Q166's gate is still unbuilt.
- The architecture kit hugs the keeper's laws and defends words/records/people — but the floor
  (three scripts) does not ship with the one file, and the loop's log is idle at the hub.
- Skills here are conduct + receipt, never feature lists; the shipping rules live in the SHIP fort
  with no user in the room; *composability* is a word neither memory nor the palace uses — its
  names are self-contained-universe, tiers, hooks-to-knowledge.
- Mentat mutated twice (eight rules); the tool `lens.py` pins the subject but not the reader.

## Manifest (generated, not typed — `sha256sum` over the bytes in `c4/h/` at write time)
```
a5b4ee3534ff8986d6c296e9ab8824b91e8dd805d3a8ec1df113b93e0f30a8d9  MODEL-2026-09-04-experiment-seat-contact-sheet.md
d53b730c54863992916d5fb5fdaa42a1ed0856ad34f17995b8cb212413c2bbdf  MODEL-2026-09-04-person-intrinsic.md
953700fde852ba8b3c6936e25a311fbce75f75dc15e482e8245637fcc4a16c9b  LENS-2026-09-04-person-intrinsic.md
510f58e93b93a93d17d40fd8afabcf680a4be87aa8060a1346076926d7fef388  HYPOTHESIS-2026-09-04-csspt-prompt-by-model.md
e4ab73960fb4f545e7467044bb2e42842335b1193aac693618a5a804ab8ad46b  HYPOTHESIS-2026-09-04-csspt-prompt-by-model.tsv
477769df59918708026481014c2c5db19746431d4667799f881a028ce11d6a4e  HYPOTHESIS-2026-09-04-reflections-slide.md
9e837e70dc64e13d6cb9f047c30d1121c4b4c1a3f6aeada5e585bc73583abb81  ENHANCE-2026-09-04-queue.md
3bf944e0ad10642a8238ece69ba9d2a02b2ba1e89e18175df2eaf9befd68921c  DIAGRAM-2026-09-05-experiment-symbiosis.json
0cde1b5d41a3eacaac442d40e3d7a8b549ad4305faacdfab523af3cdcfa01f7c  DIAGRAM-2026-09-05-experiment-symbiosis.svg
fc9e088bfdc60f36be44a59dc3188a4b01b6fb038a7505d4815480c66cd4440d  dc1sv
de90f0cafe4f25e51dc477492945e86351ca10db1889ef15bd404ee1eb03f8e5  MODEL-2026-09-05-architecture-itself.md
db016ea577ca89dd4b59b0927d7b95bab2ea32f40f5ad0507e812e44a5f3fa3a  LENS-2026-09-05-architecture-itself.md
ddb5f4b0189068e9e9f030b28afee8074d1366f3d5d97721a3ec5c1528862478  LENS-2026-09-05-roll.json
723838e4a1ceea8635de0ea343493bea27dd5f7a1ae9e121a2c0d4671f6580dc  MODEL-2026-09-05-skills-focus.md
```

*Fable as Mentat, 2026-09-05. Masters: `/f/claude/AS4CE/AS4CE0001/h/`. Corwin decides what stays.*
