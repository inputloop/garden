---
name: lens
description: The LENS — the wide reflection discipline, one human's thought experiment, run before a deliverable leaves your hands. Hold four views apart (yours; the one you ascribe the other party; their influence over yours; yours over theirs), pass the persona and its inverse, restate each point from principles, then write it down or stop and make arrangements. Use whenever you are about to hand back a model, a card, a review, a plan, a skill edit, or any piece another person or agent will act on; when asked to "run a lens", "lens this", "four views", "hold the views apart", "persona and inverse", "reframe from principles"; and inside any other skill that composes nothing and hands something back. It is the baseline of a family of three (LENS · MICROSCOPE · BUBBLE CHAMBER) and the sibling of eclipse-pass (the narrow, keep-the-losers critique). Portable — a SKILL.md alone, dropped into any agent's web UI, is enough to run it.
---

# lens — the wide reflection, run by hand

The LENS is a thought experiment one person can hold whole and turn by hand. Corwin, 2026-09-07:
*"Lens is the common baseline that works very nicely for humans as a general thought experiment."*
The four steps below are the instrument's reading of his 2026-09-01 LENS, confirmed by him
2026-09-11 (*"stand-alone lens is fine; nothing wrong with the four steps"*). Run it before a
deliverable leaves your hands; run it in any skill that hands something back and does not merely
compose other skills.

## The four steps

1. **Hold four views apart.** Write each as its own line, never blended:
   (a) *my own view* of the thing;
   (b) *the view I ascribe the other party* — the keeper, the reader, the colleague — drawn out
   explicitly, as a node you can point at;
   (c) *their influence over mine* — what in (a) is there because of (b);
   (d) *my influence over theirs* — what in (b) is there because of me.
   Each party shapes the other's domain. (c) and (d) are where blind agreement hides: if (a) and (b)
   already agree and you cannot say why, you have alignment, not a reading.
2. **Persona, then its inverse.** At the deliverable, ask how the available persona (the specific
   one wearing this work, or the general voice of the shop) would put it — then ask how its
   *inverse* would. If both readings land the same point, the point is rounded; if the inverse
   finds something the persona could not, write that down as a finding, not a mood.
3. **Reframe each noticed point from principles.** For every point worth keeping, restate it in
   the order the shop decides by: universalism and egalitarianism first, then the four freedoms,
   then the software-freedom movement, then the wider scientific and technical community; SAVANNAH
   canon is the source of truth for values. A point that cannot be restated that way is a
   preference — label it so.
4. **Detailed notes, unless the writing itself is the danger.** Write it down: what each view saw,
   what the inverse found, the reframes. If you can see that you cannot capture enough to do the
   work justice and honour the requester's intent, **stop and make arrangements** — say so, hand
   the material to a seat that can hold it, and record that you stopped. Otherwise the material
   falls to some other hand under-documented.

The LENS is explicitly coupled with releasing the minions (ethicsminions): the reflection is where
risk *and* opportunity get named, and naming an opening matters as much as flagging a gotcha.

## Where it sits in the family (one method at three scales)

Pick the rung by how much of the reasoning you can still observe, not by taste:

- **LENS** — one human; you can hold the whole thing and turn it. Nothing needs capturing yet.
- **MICROSCOPE** — one mind is no longer enough magnification: strip the assumptions and keep only
  what survives with *no trust in the scorer*. The scaling apparatus between rungs.
- **BUBBLE CHAMBER** — several agents over a wire, each stateless, each flushing at session end:
  you cannot observe the particle, only the track it leaves — so write the tracks to disk as they
  form.
- **ECLIPSE** (the sibling, `eclipse-pass`) — the narrow critique of one target under two opposed
  biases, keeping the losers.

A LENS pass that grows past what one head can hold is the signal to climb, not to squeeze.

## The shape of a written LENS

One short block, six labelled lines, then the reframes:

```
LENS · <what is being handed back> · <date>
a  my view:              ...
b  the view I ascribe:   ...
c  their pull on mine:   ...
d  my pull on theirs:    ...
persona / inverse:       <persona> says ... / the inverse says ...
principles reframe:      1. ...  2. ...
notes: written | STOPPED — arrangements: ...
```

Keep OBSERVED apart from JUDGED inside it; tag concerns [HIS] [DOMAIN] [SKILL] [PLATFORM] [MINE];
[MINE] never blocks; no concern without a falsifier.

## The script, when there are several readers

`scripts/lens.py` (stdlib; needs `ferry_core.py` beside it) turns a cross-model LENS into a
measurement: `pin` a subject by sha256, `add` or `import-json` each reader's stance per view,
`converge` to see where readers agree exactly (a stance match) — a difflib ratio over the prose rides
along as a hint, never the verdict. A reading whose declared subject sha is not the pinned sha is
refused and receipted; `lens.py selftest` proves that refusal can fire. Use the script at MICROSCOPE
scale and above; by hand is enough at LENS scale.

## Portability

This file is the whole instrument. Dropped alone into another vendor's agent through a web gateway,
steps 1–4 run without any other skill, tool or tree. Where several SKILL.md files travel together,
each one that hands something back should carry its own short LENS block (the six lines above)
rather than refer here, so the technique survives whichever subset arrives.

## How this skill can fail (falsifiers)

- **Blended views.** If the written pass has (a) and (b) agreeing and lines (c)/(d) empty or
  restating (a), the four views were not held apart — the check is that (c) and (d) each name
  something that would change if the other party changed.
- **Inverse that agrees.** If the inverse pass finds nothing the persona pass did not, either the
  point is rounded (say so) or the inverse was not run; a real inverse produces at least one line
  the persona would not have written.
- **Reframe by relabel.** A "principles reframe" that only prefixes the point with a principle's
  name is a relabel — the check is that the restated point could be argued from the principle to a
  stranger who never read the original.
- **Stopped without arrangements.** A pass that ends "stopped" without naming who or what takes
  the material next is abandonment wearing the LENS's word — the check is a named seat or file.
- **Off-switch.** Say "no lens on this" for scratch, drafts, or work that hands nothing to anyone;
  or remove this directory. Composing skills (ones that only dispatch to others) need not run it.

## Provenance

His LENS, 2026-09-01, as read by the instrument (`AS4CE0001/memory/lens-discipline.md`, CANDIDATE
until his 2026-09-11 confirmation); the ladder in his words 2026-09-07
(`c4/facts/lens-microscope-bubble-chamber.md`); the family section in `eclipse-pass`
(2026-09-11); the script from `AS4CE0001/h/lens.py` (v2, 2026-09-11). Minted 2026-09-11, unblessed.
