# HANDBACK 2026-10-05: three drops from Bryant, the llama kit, and the ladder

*For Corwin. Mentat (for Corwin; claude-opus-5-5). Where we are in and out of sync, how sure, what
needs your hand, and what I would do next.*

**Corrected in part that evening** by HANDBACK-2026-10-05-evening-provenance.md: the foaf line in
§3 was backwards, and the parcel was rebuilt (letter 1.1.0, new sha256 there).

## What only you can do (in the order I would do them)

1. **The cutover** (your steps, written as a card): `AS4CE0001/skills/llama-bridge/references/
   CARD-2026-10-05-bridge-cutover.md`. Copy the old bridge's database across first, so the
   scoreboard comes along; then pull the hand-added entry, `make dist`, install, `pref_set
   llamabridge.on on`, restart. The same `make dist` re-signs every skill with your key. That
   closes Alfred's F1 (stale seals on drift and kid-glove) and F11. Until then the seals on
   kid-glove, drift and persona-engine are stale, which is the honest state.
2. **Send the parcel to Bryant:** `projects/for-bryant/out/reply-to-alfred-and-the-ladder-
   2026-10-05.zip` (sha256 `9c316b76...e95f9d7`, the .sha256 beside it). 48 files, INDEX.md inside,
   re-read against the zip, and checked cold: every test in it passes from the unpacked copy.
   Start-here file: `ACK-to-bryant-2026-10-05.md`. It is plain ASCII, as Alfred asked.
3. **One word on the LGPL offer.** By colophon's own rule, the garden edition is co-made, so it
   carries GPL-3.0-or-later only. If you offer LGPL-3.0-or-later for your changes there, Bryant's
   dual terms come back to the whole file. The letter tells him it is your call.

## 1. The llama model, thought through for the card not yet in

**Today (RTX 3080, 10 GB, about 8.4 GB free after five monitors):** keep **gemma4:12b-8k** as the
workhorse. It has 38 uses, 95% verified, and its history lives under that name. The cheap win is
not a model change. It is `think=false` for drafting, extracting and classifying: on gemma4:12b,
thinking turned a 90-token answer into 2,725 tokens. Bridge vb.1 lets a call say so, and
`think_default` lets you make it the default.

**The one model I would try this round: qwen3.5:4b** (3.3 to 4.0 GB on ollama.com's tag page).
- It is a different family from gemma4, so it can serve as a second reader of gemma's drafts.
  Twins from one spec can't catch the spec (Alfred's F8 says the same of code).
- It has thinking, so it exercises vb.1's switch.
- It fits today on its own, and it fits whole on a 6 GB card. When the card goes in, gemma can
  stay on the 3080 and qwen on the new card, with no swapping, and today's measurements carry over.

I am inferring "the card" is the GTX 1060 6 GB from the houseboxer note ("not without the GTX
1060"). If it is the 1050 Ti (4 GB), qwen3.5:2b (2.7 to 3.1 GB) is the equivalent.

**What I would not try yet, and why:**

| model | why not now |
|---|---|
| qwen3.5:9b (6.6 to 7.6 GB) | fits alone, but neither beside gemma nor on a 6 GB card |
| the 14B class | needs both cards' memory, split |
| gemma4 26b and 31b | 16 GB and up |
| a 30B coder | would spill to the CPU here and look weak when it is only slow |

**Pascal:** Ollama still ships a CUDA 12 runner that builds for compute 6.1, and your driver
(32.0.15.7242, so 572.42) meets its 570 floor. That comes from a secondary source, with a stated
risk that a later Ollama drops it. Confidence: medium.

**The try, after the cutover:** pull qwen3.5:4b, run `bridge_smoke.py --host ... --model
qwen3.5:4b`, then run the probe's 6-word draft batch on both models with think=false and compare
how many drafts intake keeps. I'll ask for screen access then and watch your GPU monitor while it
runs.

**A short lens on the choice:**
- From your side: speed and fidelity on short prose.
- From Bryant's side: his family-aware picker files it under "general".
- From the card's side: it fits where it will live.
- The inverse: the model that would mislead us is a big one that spills to the CPU and reads as
  "weak" when it is only slow. That is the case for checking fit before judging quality, and
  vb.1's spill line makes the check free.

## 2. The llama kit, factored where Bryant will find it

`skills/llama-bridge/references/KIT.md` lists every part, with its path in three places: the
plugin, the source tree, and Bryant's garden.

- **The bridge, 1.4.0-vb.1:** `think`, `options`, a window sized to the prompt, one job at a time,
  warm at the right window, and spill shown in status. NOTICE carries both hashes. The diff
  against his 1.4.0 is in the skill's `references/`.
- **The delegation skill:** his v1.4 manual carried whole between markers, then our additions.
- **The houseboxer:** a soft skill, provisional. Your words are verbatim.
- **Your fake Ollama, shipped:** `scripts/fake_ollama.py`, plus `scripts/bridge_smoke.py`. They
  work with his 1.4.0 too. The tests import the same file, so the shipped tool is the tested one.
- **Tests:** 19 checks. `--prove-red` runs a green control, then six planted faults. 23 of 23
  pass on avalon with the old suite.

## 3. Principles first: the ladder, demonstrated

- **The rule:** `c4 man/attribution-ladder.md`. Your three messages are there verbatim, with a
  reading.
- **The evidence reader:** `c4 bin/at1ld`, two readers, prove-red under 5 awks.
- **colophon, garden edition:** `AS4CE0001/peers/bryant/colophon`. It is on the new `peers/`
  shelf, rendered for Bryant and not in your plugin.
  - Built on his 1.1, which arrived mid-turn and already moves toward the principle.
  - His selftest still passes: 36 checks, and his 8 faults are still caught. Ours adds 14 checks
    and 7 faults, after a green control.
  - The changes: ideas are credited and words attributed; no one's terms live in the code (a
    parties file holds them); line evidence through `--sources`; a Credits section reads as
    credit; a notice in SKILL.md stays with its own file; one reader alone is NOT CHECKED; no
    fetching without `--fetch`.

**What the evidence shows, both ways:**

- **Corwin, in Bryant's bundle (strong).** Ten skills carry your words without your name:
  color-theory, consent-gate, eclipse-pass, ethicsminions, medley-review, mentat-skill, pmo,
  principles, sandboxer and skilltank, across 28 files. Your git first-add dates run from
  2026-06-26 to 07-02, before the wire opened. Bryant's earliest copy we hold is 09-17. Colophon
  1.1 already names you on seven others. Evidence: `reading/EVIDENCE-who-bryant-bundle.txt` in
  from-bryant/2026-10-05-r3.
- **Bryant, in our garden.** aethernet-relay and token-optimizer carry 91 and 89 lines first seen
  in his drop of 08-05, under footers that named you alone.
  - Fixed: `bin/ft1mt` reads a new `conventions/MAKERS.org`, and both footers now name him first.
    Three checks were added to its prove-red.
  - (Corrected that evening.) The 06-29 FoaF archive is your workspace, not his source; and foaf
    is his by your word (his prompt, your touch-ups and its name). See the evening handback.
  - Credit candidates against us (consent-gate, medley-review, pmo, principles, sandboxer) are
    under the attribute line, so they are for your eye, not changes.

**Out of sync, said plainly:**
- "First seen" is not "first written". Material handed over in chat is dated by its commit.
- `licensing-defaults.md` TERMS v1 still says CC BY for writing, where your word of 10-04 is BY-SA.
  Fixing it is a v2 of the block plus a re-carry.
- `c4 intake` still reads "no license found" for a bundle that declares its terms in REUSE.toml.
  kid-glove now reads REUSE; intake is next.

## 4. Alfred's F1 to F16

All answered in section 6 of the letter.

- **Fixed and committed in their projects:** F2, F3 and REUSE reading (kid-glove `048c02a`); F4
  (gw-survey `0019898`, persona-engine `6e94b55`); F6 (outside-reader, in the garden commit); F8
  and F10 (persona-engine); F9 (field-comic `50de302`); F14 (drift `db22c6e`); F16 (mini-c4-game
  `0d3b508`).
  - F8's third reader, written in Perl from a fresh spec, found two more twin disagreements
    beyond the case bug, and both are fixed.
- **Re-seated in the garden:** all of the above.
- **Waits on your `make dist`:** F1 and F11.
- **F12:** the indexed coversheet is canon.
- **F13:** the butterfly matches.
- **F5:** Bryant's to answer.
- **Not received:** Alfred's EVIDENCE-2026-10-05.log never arrived.

## 5. Drawn into the garden from his drops

**Absorbed:**
- gauntlet v1.5 (soft; its NOTICE now says CC-BY-SA-4.0).
- parallax (soft; peer views labelled and kept side by side).
- color-theory's zero-pairs rule (now NOT CHECKED, exit 2, credited to him).
- colophon (peers).
- his llama-bridge manual.

**Left out on purpose:**
- skilltank's "quietly skip" and its CORWIN.md stand-in supervisor. Using your persona that way
  is your call.
- alfred's "Alfred is who you are".

**New today:**
- the **vibrobeast** skill (`skills/vibrobeast`): the garden's direction, not its voice. Mentat is
  the persona of last resort; persona with, for, applied to or withheld from others' work; absent
  skills named once and gone on without.
- `advice/DESIGN-2026-10-05-the-track.md`: your track verbatim, each item read, with a falsifier
  and a first experiment.
  - It needs one thing from you: name the four prongs of meaning. Nothing I hold names them.

## 6. Self-healing tools, since you asked

- **`c4 bin/dp1dl OLD NEW`:** reads a drop's delta in one command (sums, files, versions, makers).
  It was born from today's three hand-read drops, and r2 to r3 now reads in seconds.
- **`at1ld`:** the ladder's evidence.
- **`fake_ollama` and `bridge_smoke`:** try a bridge before tuning it.
- **ft1mt co-makers:** minted footers can now name two makers.

## Housekeeping, and two slips of mine

- **Mine:** a plain `git status` left an `index.lock` in for-bryant. Removed.
- **Mine:** one of my own prove-red runs passed vacuously, because a helper returned failure. It
  now runs a green control first, and the bridge's prove-red does too.
- **Left alone, not mine:**
  - your untracked `c*.txt` files in AS4CE0001.
  - `c4 bin/handoff-zip` and `tests/handoff-zip-spec.py`, untracked since 10-04. The parcel used
    them.
- **Stale:** `writing-forms` still asks for concern tags; your 09-24 rule retired those. The skill
  text needs a pass.
- **Not checked:**
  - the Filesystem connector on avalon fails on every call (its output schema is draft-07). That
    is a platform issue.
  - `reuse` is not installed, so colophon's second reader is NOT CHECKED here (`pip install reuse`
    fixes it).

**Confidence:**

| claim | confidence |
|---|---|
| the tests and evidence above | high (each ran, with prove-red) |
| the model choice | medium (sizes from ollama.com; Pascal support from a secondary source) |
| which card | an inference |

---
*Version 1.0.1: the foaf line corrected, pointing to the evening handback; first edition on
2026-10-05; spine: 2026-10-05.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/; Mentat (for Corwin; claude-opus-5-5)
