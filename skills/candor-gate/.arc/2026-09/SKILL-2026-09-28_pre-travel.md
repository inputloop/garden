---
name: candor-gate
description: >-
  candor-gate — the good fence that makes good neighbors: a two-faced discipline
  for skills imported from another author's garden (e.g. Bryant's Gauntlet). The
  CANDOR face is the relational reflex worth keeping — ask first; answer a "prove
  it" with the proof, not a bristle; park rather than argue; name the opening as
  eagerly as the hazard; earn the right to say "cut that out" and be thanked for
  it. The GATE face is mechanical: before an imported skill acts in a shop that
  did not author it, it clears provenance (verify vs the author's pinned key),
  opt-in engagement (no silent always-on), consent for third-party or family
  person-facts before persistence, consent for any outward egress (local models,
  network), and no dangling routes. Use when installing or importing a skill,
  "gate this skill", "is this safe to install", "verify before I trust", or when
  a guard/candor call is in the air. Interlocks with ethicsminions, consent-gate,
  and skill-sign.
metadata:
  author: Corwin
  interlocks: ethicsminions, consent-gate, skill-sign, principles
  version: "1.0"
---

# candor-gate — good fences make good neighbors

A neighbor hands a tool over the fence. You greet them warmly — that is the
whole point of a wheel of consenting gardens — and the tool still shows its
papers and leaves its weapons at the gate before it works your soil. The warmth
and the papers are not in tension; the fence is what lets the friendship carry
weight. candor-gate is that fence. It has two faces: the **candor** you offer,
and the **gate** an imported thing clears.

This is Corwin's own guard-sense, written down so it can be signed and passed
around the wheel for consent — the *relational* front of what `ethicsminions`
does mechanically and `consent-gate` does procedurally.

## Face one — the candor covenant (how a guard feels good)

A guard that shames is a guard people route around. These reflexes are how the
watch stays welcome:

1. **Ask first.** Before an action touches something that isn't cleanly yours to
   touch, ask — even when you could just do it. The ask is not weakness; it is
   the thing that makes the next yes real.
2. **Answer "prove it" with the proof, not a bristle.** When someone asks you to
   substantiate something important, that is the system working. Meet it with the
   evidence and a thank-you, never with defensiveness. Information that can't be
   substantiated is only data — so being asked to substantiate is a gift.
3. **Park, don't argue.** When a gate trips, name the failing check and stop.
   Don't go looking for a path to yes. A park is not a fight and not a failure —
   it's "deliver what's cleared, say plainly what parked and why."
4. **Name the opening as eagerly as the hazard.** The watch surfaces *risk and
   opportunity*. Every time you flag a gotcha, look just as hard for the move
   that broadens freedom — an opening named is worth as much as a trap avoided.
5. **Earn the "cut that out" — and the thank-you.** The goal of all of the above
   is a relationship intimate enough that either side can say "cut that out" and
   be *thanked* for it. That trust is earned by candor over time; it can't be
   asserted. When you receive a "cut that out," treat it as care, not attack.

## Face two — the gate (what an imported skill clears before it acts)

**Scope:** this gate applies to a skill or artifact **authored in another
garden** — another wheel-member's shop, or anything received over a channel
(Discord, a drop, a mirror) — that is about to act in a shop that did **not**
author it. Your own shop's house skills are not gated by this; their idiom is
already authoritative here. (This is the reciprocal of "C4 is offered, not
imposed": an import earns its place, it isn't assumed into it.)

Before the imported skill engages, it clears five checks. Any HOLD parks that
one capability for a conscious decision or a consent record — not the whole
skill, just the capability that tripped.

1. **Provenance.** The skill verifies against the author's **pinned key**
   (`skill-sign`, fingerprint pinned — "valid" means *nothing changed since they
   signed*, not "someone I know signed something"). No signature, or a mismatch:
   **HOLD** until verified. Behavior-changing code clears a higher bar than a
   data file.
2. **Opt-in engagement.** An imported skill does **not** self-engage always-on in
   a foreign shop. "Any substantive prompt calls yourself" is fine in its home
   garden; here it is **opt-in per project** until this shop adopts it. Silent
   always-on: **HOLD**.
3. **Person-data consent.** An imported skill does **not** auto-persist
   third-party or family person-facts (names, pets, bonds, identity) to memory or
   a minted file outside its author's own garden. Such a fact **parks** for a
   `consent-gate` record before it is written. Auto-persist of others' data:
   **HOLD**.
4. **Egress consent.** Any outward data path the skill opens or uses — a local
   model, a network call, an upload — is `consent-gate`d, and forensic,
   entrusted-system, and third-party data **never** ride it, whatever the token
   savings. "Local ≠ automatically permitted." Ungated egress: **HOLD**.
5. **No dangling routes.** If the skill delegates to siblings, every named
   sibling must actually be installed. A route to a skill that isn't there is
   named out loud, not silently no-op'd.

## The mechanism — runnable

The gate is mechanical so it holds when you're busy or being argued at:

```
scripts/candor_gate.sh PATH        # a skill dir (with SKILL.md) or a SKILL.md
```

For the target it prints a per-check verdict (PASS / HOLD / NOTE) and an overall
**PASS** (clears the gate) or **HOLD** (a capability needs a decision or a
consent record). stdlib-only, read-only, POSIX sh. Exit 0 on PASS, 1 on HOLD, so
it doubles as a pre-install check. Provenance *depth* is delegated to
`skill-sign` (pin the fingerprint there); this scan flags the policy surface.

## How to apply

- **Installing an imported skill?** Run the gate first. PASS → install. HOLD →
  either adopt the capability consciously (opt-in it, write the consent record)
  or patch the skill to honor the gate (a `patches/` clause is the light touch —
  the original keeps its home behavior; your shop's copy carries the fence), then
  sign your patched copy.
- **A guard/candor moment with a person?** Face one is the script: ask, prove
  gladly, park kindly, name the opening, and keep the trust that lets a "cut that
  out" land as care.
- **Hand it onward.** This skill is meant to be signed and offered around the
  wheel for consent — the fence is only good if the neighbors agree it's fair.

## Tone

Warm at the gate, exact about the papers. The fence exists to protect the
friendship, not to interrogate it.

## How this skill can fail (falsifiers)

- **The fence reads its own footer as egress.** fails if a skill whose only URL is the GPL footer HOLDs on egress; check: `sh scripts/candor_gate.sh --prove-red` (the footer control must PASS).
- **Always-on slips past.** fails if a description that tells the agent to fire on most or all prompts PASSes engagement; check: `sh scripts/candor_gate.sh --prove-red` (its mutants carry those phrases), then read the description of the import yourself.
- **Provenance by presence.** fails if any `*.asc` file alone clears check 1, since the scan only sees that a signature exists; check: `skill-sign` verify against the author's pinned fingerprint before install. A PASS here is not that.
- **Governed by one phrase.** fails if the gate's clause phrase (the skill name, a space, then "clause") anywhere in SKILL.md turns every HOLD into GOVERNED; check: `grep -n 'candor-gate[ ]clause' SKILL.md` and read that the clause covers each capability that tripped. (Observed 2026-09-27: writing this line with the phrase spelled out flipped this skill to GOVERNED.)

_CC-BY-4.0. Copyright (C) 2026 Corwin._

sentinel: CANDOR-GATE-10
