---
name: skilltank
description: Spot skill-shaped patterns and decide whether they earn a skill. Use when you or the user step back to ask "should this be a skill?", "is this skill-shaped?", "should we make/extend a skill for this?" at an end-of-project retro, or when a repeated manual procedure or a cluster of related memory notes suggests a capability worth capturing. Scans memory (and an optional transcript) for recurring themes, cross-checks them against the skills you already have, and labels each NEW / ENHANCE / LEAVE-AS-MEMORY. Triggers on "should this be a skill", "find skill candidates", "review our skills", "audit memory for skills", "what have we done repeatedly", "is there a skill in this", "rainbow pass", "what skill am I missing". Also covers promotion etiquette at the desk — "promote this candidate", "hold or reject?" — HOLD is the reading room; REJECT is durable and never a pause button. It NOTICES and recommends; it hands authoring to skill-creator.
---

# SkillTank — where capabilities are cultured

A tank doesn't build the thing; it grows a candidate until you can see what
it is, then you decide whether to decant it. SkillTank looks back over what
you've been doing — the notes Mentat kept, the procedures you repeated — and
surfaces the patterns that *might* be skill-shaped. It does not author skills
(that is **skill-creator**) and it does not take notes (that is **Mentat**).
Its one job is the judgment in between: *is there a skill here, and is it new
or an enhancement?*

## When this applies

- You or the user ask, in any phrasing, **"should this be a skill?"** —
  including "is this skill-shaped?", "should we make a skill for this?",
  "is there a skill in what we just did?"
- An **end-of-project / end-of-session retro**: a deliberate look back for
  capabilities worth keeping.
- A **smell** worth checking: a cluster of related memory notes piling up on
  one theme, or the same manual procedure run several times across a session.

It does **not** fire on every memory write or every Sandboxer action — skills
have no event hooks, only conversational triggers. SkillTank runs when someone
*asks the question*, not automatically.

## The scan

```
python3 scripts/scan_candidates.py --memory MEMORY_DIR \
        [--skills SKILLS_DIR] [--transcript FILE] [--min-cluster N]
        [--max-frac F] [--top N]
```

- `--memory` — the memory directory (the folder holding the note `.md`
  files and `MEMORY.md`). Required.
- `--skills` — a directory tree of installed/staged skills (each a folder
  with a `SKILL.md`). Lets the scan say ENHANCE vs NEW instead of guessing.
- `--transcript` — an optional saved transcript; flags steps repeated 3+
  times as automation candidates.
- `--min-cluster` — how many notes must share a theme before it counts
  (default 3).
- `--max-frac` — the *ceiling*: a theme present in more than this fraction
  of all notes (default 0.7) is ambient context — the project's own name,
  the working medium — and is suppressed (listed on one line, not ranked).
- `--top` — show at most N candidates (default 25; 0 = all). The tail is
  counted, not printed.

stdlib-only, read-only, advisory (always exits 0). It clusters themes across
notes, folds same-note-set themes into one row (rest shown as `aka:`), merges
*near*-duplicate clusters (Jaccard ≥ 0.8 — 'git' over 8 notes and 'mount'
over 7 of the same 8 are one conversation, not two candidates), counts how
many notes in a cluster read as *procedural* (a "How to apply:" / numbered
steps smell), and uses wikilink references as a centrality hint.

## Reading the labels

- **NEW** — a recurring *procedure* no existing skill covers. A real
  candidate; take it to the gate below.
- **ENHANCE** — the theme already maps to a skill you have. Don't spawn a
  rival; fold the new lesson into that skill (this is the common, healthy
  outcome — most findings enhance, few found).
- **LEAVE-AS-MEMORY** — recurring *facts*, not a procedure. Facts are
  Mentat's job; they don't become skills.

A label is a prompt, not a verdict. Always run the candidate through the gate.

## The gate (skill-vs-memory)

1. Does it ship what memory can't — a **runnable script/resource**, or a
   **self-triggering description**? If the payoff is only prose, it stays a
   memory note.
2. Is the need **recurring**, or was this a one-off?
3. **One capability.** New skill, or does it ENHANCE / merge into an existing
   one? Merge only when two capabilities are *always* needed together;
   reference (one-way) when only *sometimes*; otherwise one skill = one
   capability.

## The reading room (promotion etiquette)

When a candidate reaches polygram's desk, three verbs exist and they are not
interchangeable. **HOLD** parks a candidate for review — it is *not terminal*
and never overrides the ledger. **PASS / promote** synthesizes. **REJECT is
durable**: it lands in the advice ledger and only a later deliberate promote
clears it.

The etiquette that follows from those semantics:

- *"Have I read this thing I'm going to sign?"* is the right question, always.
  The signing is the moment that confers the dignity; nothing before it is.
- Need time to read? **Park at HOLD.** That is what HOLD is for — a reading
  room, not a penalty box. Wanting to think is not a problem to route around.
- **Never REJECT to buy reading time.** A reject-then-promote pair leaves a
  durable scar in the ledger that records diligence as refusal. If you find
  such a pair, it usually means the operator needed a pause and the tooling
  only offered a "no".
- Signing happens inside the blessed path (`dist` / release tooling in-signs).
  Don't hand-roll signing wrappers to compensate for a pause you didn't know
  you were allowed to take.

## The rainbow pass — rainbow-tank (after Bryant's Rainbow_Eval v1.0)

Credited import, folded not forked: the boundary-scan method from Bryant
Frankford's Rainbow_Eval (Gauntlet Nexus, 2026-07-06), run under this
shop's gates. Trigger: "rainbow pass", "rainbow-tank", "rainbow eval",
"what skill am I missing", "fill the gap".

1. **Lay out the spectrum** — every installed skill: name, one-line lane,
   declared boundaries. Bands, not judgments.
2. **Find gaps at the boundaries, not the centers.** A gap is work with no
   owner: hand-procedures done twice+ (journals and ledgers are the
   evidence lockers), memory notes clustering where no skill claims,
   hand-offs where two lane statements both say "not mine", workarounds
   invented live then reinvented. Rank by receipts, never by fun.
3. **Label the top gap** with the house taxonomy: only NEW survives;
   ENHANCE routes to the owner's mint; LEAVE-AS-MEMORY goes to Mentat.
   No NEW = say so and stop — a rainbow with no missing color needs no
   paint.
4. **One gap per pass, and it exits through the standard hand-off below** —
   skill-creator authors, the desk (CLAUD_QA_HOLD) adjudicates, the keeper
   signs and installs. Never straight to the rack (house rider; Bryant's
   original delivers installable — fine in its home garden). Output is
   pub-safe by construction: method travels, cases don't.

## The hand-off

SkillTank stops at the recommendation. To act on it:

- Build a **NEW** skill, or **ENHANCE** an existing one → hand off to
  **skill-creator** (it authors, edits, and evals skills).
- A **synth-generated** skill (polygram or any forge) is not done when it
  exists: consult **skill-creator** AFTER generation — authoring pass +
  description eval — BEFORE it rides any release or install. A placeholder
  description travels all the way into the live rack otherwise (the
  stub-litter lesson, 2026-07-08).
- Record the decision — including a deliberate *"we chose not to"* → hand off
  to **Mentat**, so the reasoning is kept and the same candidate isn't
  re-litigated next session.

## The trio

Mentat **notices and remembers**; Sandboxer **forces a result through a flaky
mount**; SkillTank **curates the skillset itself** — turning repeated practice
into the question of whether it deserves a skill, then routing the answer to
skill-creator or back to Mentat. SkillTank references those skills; it never
re-implements them.


