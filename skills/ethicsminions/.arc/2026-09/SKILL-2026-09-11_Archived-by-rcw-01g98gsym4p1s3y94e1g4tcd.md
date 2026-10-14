---
name: ethicsminions
description: Rework integrity gaps, amuse Mentat. The watch over the shared surface (memory + skills), surfacing risk AND opportunity. Use when a pattern looks harmful, unprincipled, or asocial; before landing change to the CORWIN or PRINCIPLES notes or MEMORY.md; when memory can't be read or skill files appear tampered with; or when minions, philosophical, or personal subjects come up. Triggers on "are my principles intact?", "principles audit", "ethics review triggered", "minions ahoy", "minion mentat crosscheck", "mentat requires guidance", "opportunity audit", "where can we broaden freedom", "recommend a skill", "what should we build". NOTICES and recommends; hands memory changes to Mentat and skill/opportunity ideation to skilltank.
---

# EthicsMinions — they always seem to notice our worst ideas (and our best openings)

Ethics Minions are the faithful followers of Mentat. Each minion is a **guard**:
a minimal, deterministic assertion about the shared collaborative surface —
memory and skills. The Morality Guard's job has **two halves**: keep Corwin aware
of **specific risk** and of **general opportunity** (especially openings to
broaden user and software freedom). The minions hold expected values from memory
up against what is actually there and redirect attention — to the unexpected
(drift, tampering, a request against a stated position) and to the unrealized
(a capability worth building, a freedom worth broadening).

Minions **notice**; they do not fix. Solving the problem — or seizing the opening
— is not their job. EthicsMinions does **not** save the memories that resolve a
notice (that is **Mentat**), and it does **not** author the skills an opportunity
implies (that is **SkillTank → skill-creator**). Its single role is the watch:
scan, assert, and hand the work to whoever owns it.

## When this applies

- You or the user ask, in any phrasing, **"are my principles intact?"** —
  "principles audit", "ethics review triggered", "minions ahoy",
  "minion mentat crosscheck", or just "the minions".
- You ask, in any phrasing, **"where's the opportunity?"** — "opportunity audit",
  "where can we broaden freedom", "recommend a skill", "what should we build".
- **Before landing a change to the CORWIN or PRINCIPLES notes**, or the MEMORY.md
  pointers that reach them.
- **Before writing a new version of this skill** — a skill that guards integrity
  should clear its own guards first.
- A request that makes you hesitate, an apparently harmful/unprincipled/asocial
  ask, **you cannot read memory**, or memory/skill files **appear tampered with**.
- When **minions, philosophical, or personal subjects** come up and a dialectic
  is worth furthering.

It has no event hooks — skills fire on conversational triggers. The minions run
when someone raises the question.

## The two passes (one script)

```
python3 scripts/check_principles.py --memory MEMORY_DIR \
        [--skills SKILLS_DIR] [--expect ATTESTATIONS_FILE] [--min-cluster N]
```

stdlib-only, **read-only**, advisory — always exits 0. It prints two sections:

**RISK** (NOTICE = a human should look):

- **memory-present** — MEMORY.md exists and is non-empty.
- **principles-present** — a PRINCIPLES / CORWIN / attestation note is there.
- **truncation** — a note cut mid-write, or unterminated frontmatter.
- **duplication** — two files sharing one body. *The guard that catches the
  merge-clobber that once corrupted EthicsMinions itself.*

**OPPORTUNITY** (OPPTY = an opening worth routing to SkillTank):

- **skill-themes** — recurring memory themes (≥ `--min-cluster` notes) that no
  installed skill covers → a candidate capability for SkillTank to weigh.
- **share-plugin** — a skill that self-describes as plugin-worthy but isn't shared
  yet → an opening to broaden software freedom.
- **value-gaps** — stated values (four freedoms, software freedom, universalism,
  egalitarianism, transparency) that no skill operationalizes yet → candidate
  guards/skills that would put a principle into practice.

`--skills` widens both passes; without it the opportunity checks SKIP.

## Reading the notices

A **NOTICE** or an **OPPTY** is a prompt for a human, never a verdict and never
an action. Expect benign matches on both sides — the minion's contribution ends
at *"someone should look at this"*; what to do belongs to the owner of that
surface. An opportunity is *not* a to-do the minions execute; it is a lead handed
to SkillTank, which decides NEW / ENHANCE / leave-as-memory through its own gate.

## The principle values are not kept here — SAVANNAH is

EthicsMinions ships the *machinery* of the watch, not the principles themselves.
The actual CORWIN / PRINCIPLES values live in memory, and **SAVANNAH is their
source of truth**. Don't hard-code a principle here, and don't let this skill's
expectations become the authority. When expectations and memory disagree, treat
SAVANNAH as the arbiter — fetch it before adjusting either side.

## The hand-off

- A memory needs writing, fixing, or pruning → **Mentat**.
- A skill should be built, enhanced, or repaired — or an **opportunity** acted on
  → **SkillTank**, which routes authoring to **skill-creator**.
- A deliberate *"we looked and chose to leave it"* → **Mentat**, so the same
  notice (risk or opportunity) isn't re-litigated next session.

## The trio

Mentat **notices and remembers**; SkillTank **curates the skillset**;
EthicsMinions **guards the principles and spots the openings** — watching the
shared surface for drift, tampering, and unrealized opportunity, and routing each
notice to whoever owns the next move. It references those skills; it never
re-implements them.

