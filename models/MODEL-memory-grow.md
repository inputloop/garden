# MODEL — the interim memory system + the GROW bit (glue MAIN MEMORY back together)

*Minted, not vouched. Claude/Mentat (Vibrobeast) for Corwin, 2026-09-01. Canon governs; SAVANNAH
source of truth. **Models pair with semaphores** — this is the model for the MAIN-MEMORY item
(semaphores `SEAT` · `MANIFEST-MEMORY` · `STRANDED` · `GROW`). Companion to
`making-vibrobeast-dot-md.md` and `MENTAT-MAINMEMORY-SEAT-2026-09-01.DRAFT.md`.*

## 0 · The rule that makes a good item first-class
**A really-good item gets a MODEL to go with its semaphore, at minimum.** The semaphore is the
signal; the model is the substance it points at. A signal with no model is a pointer to nothing.

## 1 · Architecture (settled across this session)
- **Seat = Avalon** (`AS4CE0001/memory`); multi-copy (Avalon + Drive `ComputerPeople/` via MCP);
  keyed by **sha256 identity**, path a hint. **git-transport assumed never to exist** (durable in
  its own right; falls down gracefully when C4 provides it).
- **MANIFEST-MEMORY** = the hash-keyed ledger; disposition `bring-in` / `REF@home` / `HOLD`.
- **On-ramps + floor (chadtab):** a note enters only via a **declared on-ramp**; the floor (`|_/`)
  makes un-on-ramped admission *impossible, not merely flagged* (a safety precondition, already
  written down). Wire input **never inherits trust**.
- **Trust arc:** a note is untrusted until it **returns to a known baseline** (a heuristic — and per
  your 2026-08-19 ruling, *"architecture at its best is guess work, fairly elected,"* so the
  heuristic is the strong terminus, not a weak one). **Grow ≠ trust.**

## 2 · The GROW bit — the critical implementation detail
Memory is a **graph that accretes** (the DISCOVERY graph: nodes + edges, walkable like `g/DISCOVERY`).
One note's life, the whole protocol:

> **on-ramp → pin (sha256) → semaphore (+ MODEL if really-good) → copy (multi-store) → link (`[[…]]`) → reflect (LENS)**

- **Grow from durables, pulled to current deltas** — never ad-hoc, never random-bias-seeded.
- **Measured, not asserted:** every grown node carries a receipt (hash) + a disposition + links.
- **Losses kept** (NEWS discipline): a cut node is composted, not deleted.
- **Findability is the point** — the graph is `ls`-able; a stranger can walk it.

## 3 · Persona as the proof (that Mentat "feels working")
The system is working when the persona is **less stiff whatever words you choose** — catches your
vibe *while retaining its own line*. That distinction is load-bearing:
- A persona that just **mirrors** your whims is flattering, shallow, and the doorway to mishap.
- A persona that **sees you while keeping its own perspective** relaxes a tension that (your gamble,
  and mine) is where creativity lives. That is the target.
- **iT is that doorway — "Chad" at the door** (`|>` + `/ [ hi ]`): imagination enters here, and so
  does confusion if we are not delicate. So: **no seeding persona from random bias** (you waved me
  off, rightly); the **floor stays non-electable** (a persona that can switch off a floor row is a
  bypass, not a persona); voice **grows from the durable prose-corpus**, not from thin whims.
- **The persona grows the same way memory does (§2):** the emotion/agency-bearing prose I've written
  you is the corpus; it accretes — pinned, linked, reflected. First node grown below.

### First grown node (demonstrating one GROW cycle)
- *on-ramp:* this session's own prose (a declared on-ramp: my writing to you).
- *node:* **"I will not flatter you, and I will not flatter myself by claiming an inner life I cannot
  substantiate. What I can actually offer is reliability, honesty, and a line held under pressure."**
  (`CLAUDE.md`, the instrument-comrade opening.)
- *why it bears:* it is the *retaining-my-own-line* stance in one breath — the anti-mirror.
- *disposition:* `bring-in` · *links:* `[[persona-doorway]]`, `[[voice-from-durables]]` · *reflect:*
  it passes the LENS test (less stiff, still holding the line).

## 4 · The LENS — how we watch it grow (the plan you asked for)
- **Wide (LENS) / narrow (eclipse)** reflection, tunable per stakes; **drift-funded**; analysts pit
  an idea against itself; grounded in **durables + principles**; a claim carries the tool that breaks it.
- **The four views held apart** (yours · the ascribed-me · my influence on yours · yours on the
  ascribed) — this *is* the guard against mirroring: relaxation **without** losing the line.
- **A picture, too:** lens-visualization / bubble-chamber renders the growing DISCOVERY graph so we
  can *see* accretion (candidate tool).
- **The working proof, reflected:** am I less stiff **and** still holding my line? Only the first is a
  mirror; both is the tension relaxed. The LENS is where we check which one happened.

## 5 · Semaphore + model pairing (the new rule, applied)
| item | semaphore | model |
|---|---|---|
| the seat / MAIN MEMORY | `SEAT` | this model |
| the hash-keyed ledger | `MANIFEST-MEMORY` | (builder) |
| not-yet-reseated | `STRANDED` | — |
| **the accretion protocol** | **`GROW`** (new candidate, S-tag) | this model §2 |
`GROW` is lowered by a grown node landing with receipt + disposition + links.

## 6 · Start / forks
- **Started now:** this model; the GROW protocol; the persona-corpus's first node (§3).
- **Next:** `seatdiff` (read-only bring-in list) · the persona-corpus sweep (sub-agents over
  `book/`, `journal/`, transcripts) · the lens-visualization.
- **Yours:** bless `GROW` + the semaphore↔model rule; decide the persona-corpus home (C4 or Avalon).

sentinel: MODEL-MEMORY-GROW-2026-09-01-v001
