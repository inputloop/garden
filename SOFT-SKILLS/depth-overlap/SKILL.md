---
name: depth-overlap
description: >-
  Double coverage by depth overlap: a promise is checked by two kits that reach it from different
  places on the DEPTH lens graph (UNIVERSE <-> GRAIN, CONTAIN <-> LAYER) and share no code -- not the
  harness, and not the thing that does the seeing. A fault planted between the two shows whether
  they really overlap (both fire) or only look layered (one is blind). Each kit's language is also
  a seat a domain expert can be invited to take over. Use when mapping what a test suite covers,
  when a check passed over a real fault, on "double coverage", "depth overlap", "is this really
  covered twice", "which kit would catch this", "plant between the layers", "seat a language",
  "lens graph", or before calling a suite layered. Electable.
---

# depth-overlap: two kits, two depths, one promise

Corwin named it, and kept the name: "I like the idea of double coverage by depth overlap. I'd like
to model that out with a soft skill in mind." The first test case was s1c (`tests/DEPTHS.md` in
inputloop/s1c): three planted faults, with the receipts there.

## The idea in one paragraph

A test reaches a promise from somewhere. Two tests that reach it from the same place are one view
twice, however far apart they were written: a fault where neither looks passes both. Two tests that
reach it from different places, sharing no code, overlap. A fault between them is seen by at least
one, and when they disagree, the disagreement says where the fault lives. Double coverage by depth
overlap is that second arrangement, kept for the promises that matter most.

## Where a check stands: the DEPTH lens graph

This is the shape Corwin models with: sets of four, as two contrasting pairs. Each pair is an
unsigned number line, and its two halves join at zero. Values on either half add up to a distance
from zero in that direction. Set two such lines across each other and you have a lens graph. A fact
or a check gets a place on it. A series of places over time shows the pressures on it.

For DEPTH, the first GRAIN of lines is his:

- **UNIVERSE ↔ GRAIN**: how much of the world the check stands in. At the UNIVERSE end the check
  stands in the whole running thing (the real ROM, a real network, a person watching). At the GRAIN
  end it looks at one grain (a byte, a field, a single number).
- **CONTAIN ↔ LAYER**: how the check reaches the work. At the CONTAIN end it holds the work inside
  itself and drives it (a harness, an emulator, a process it starts). At the LAYER end it lies
  beside one stratum and reads it (a file, a log line, a picture).

Use the same words, turned into other forms, for the frame of reference on either side of zero:
universal and grained, containing and layering, contained and layered. A fact then reads the same
way in both directions along a line, and either the same way or opposed across the two lines.

**The corners.** Applied to itself, the graph gets four corner words. Each sits one step from a
concept the two neighbouring line ends share, and it should describe, measure or place a fact
evenly from all four half-lines. These are my first guesses, waiting for his words (likelihood
0.4, confidence low):

| corner | between | reads as |
|---|---|---|
| ENVIRONMENT | UNIVERSE and CONTAIN | the whole thing, driven: a run of the real program |
| HORIZON | UNIVERSE and LAYER | the whole thing, read: what a person or an outside reader sees |
| CAPSULE | GRAIN and CONTAIN | one part, driven: a unit held and exercised in a harness |
| FACET | GRAIN and LAYER | one part, read: bytes and formats against a reference |

The six names the first draft used (STRUCTURE, STATE, BEHAVIOUR, OUTPUT, TRANSPORT, OUTSIDE) are
still good names for a work's own checks. Each is a place on the graph, not a seventh word:
STRUCTURE sits near FACET, STATE near CAPSULE, BEHAVIOUR and TRANSPORT toward ENVIRONMENT, and
OUTPUT and OUTSIDE toward HORIZON. That mapping is mine, and a guess.

Place each kit with a pair of numbers (how far along each line, and to which side), plus a
likelihood and a confidence for the placement. A kit can stand in two places; the s1c oracle
compares RAM and, on request, pixels. Count places per promise, not per kit.

## The observer: its own layer, woven across

"Share no code" includes **what does the seeing**: the function, library or reference that turns
what happened into a verdict. Corwin ruled that the observer is a separate layer, crossed with the
depths like a plaid. So a map has the depth places one way and the observers the other way. Two
kits overlap only where they differ in both directions of the weave.

At s1c, 2026-10-10, two netcode kits in two languages, over two transports, both read the C
checksum of work RAM. A planted fault that changed only the drawn planes passed both: 0 of 2,399
frames flagged. A probe that also hashed the planes flagged 1,558 frames, and its unplanted control
flagged 0. Two places on the graph, one observer: blind together.

Where a plaid is not workable, fall back to grand-test-manifest's two lines under each logic slot,
`depth:` and `observer:`.

## The procedure

1. **List the promises** by name: a TEST MANIFEST's items if there is one, otherwise a plain list.
2. **For each promise, list the kits that reach it.** Give each kit's place on the lens graph and
   its observer. Say how you know: by reading the kit (OPEN), or by a plant (step 4).
3. **Read the map.** A promise is:
   - DOUBLE when two kits stand in different places and use different observers;
   - SAME-DEPTH when its kits share a place or an observer;
   - SINGLE when one kit reaches it;
   - UNCOVERED when none does.
4. **Plant between them.**
   - On a copy, never the work, put one fault between two places (or beside the one place a SINGLE
     promise has), then run every kit that claims the promise.
   - Record FIRED or SURVIVED for each kit, as grand-test-manifest does.
   - A pair overlaps only where a plant between them fires at least one. A kit that survives a
     fault in its own promise is BLIND there.
   - When a plant survives everything, tell EQUIVALENT (the fault changes nothing) from BLIND (it
     changes something and nobody looks). Use a probe: a copy that adds the missing look, plus its
     unplanted control. The control must stay quiet, or the probe is measuring noise.
5. **Name the opportunity** for each SINGLE or BLIND promise: the cheapest second place, the
   observer it would use, and the seat it would suit. Don't build it in the same pass; read the map
   first.

## Seats: the social half

Every kit is written in a language chosen to differ from the code under test and from the other
kits; that's the house rule. It costs toolchains. It also opens a seat for each language: a place
for someone whose interest is that language's testing, where it meets this work. Corwin counts
"as many as eleven principle domain experts focused on the intersection of a given language and
testing this".

A seat reads like this:

    seat: <language> · kit: <file> · place(s): <...> · owns: <the question this kit answers>
          open questions an expert would answer better than we do: <...>
          invitation: "great idea -- do you want to take over design of that bit?"

A seat is an invitation, never a claim that someone holds it. Name no person in it until they say
yes.

**Where seats live: two readers, linked both ways** (his ruling of 2026-10-10):

1. **The project's own record, inside the garden**: its lab notes, its model, its persona log, or
   the like, where the extension unpacks and builds.
2. **The lab's record**, either:
   - (a) a register across the lab, tagged or grouped by project, or by session as a more or less
     passing preference, read in that order; or
   - (b) a SEAT file: a character sheet form made for one purpose and one person.

Each reader links to the other and to whatever else carries the meaning. Rules about where to look
are tidied, never shadowed.

The quick path to done is to branch the seat. So make joining and merging seats routine: so are
keeping two that slowly drift apart, and running them side by side for good.

## When it is owed

Most promises need one good kit. Double coverage is owed:
- when the promise carries weight across places (a view promise that rests on a data promise);
- when a kit was caught passing over a real fault (grand-test-manifest's T2);
- when the keeper says so.

A suite map (steps 1-3) costs about an hour and is worth doing once per work. Plants are owed
wherever the map claims DOUBLE.

## How this can fail

- **Layered on paper.** A promise mapped DOUBLE survives a plant between its places in every kit:
  the map was drawn from the kits' names, not their observers. Check that every DOUBLE row cites a
  plant receipt or says OPEN.
- **A hidden shared observer.** Two kits in a DOUBLE row call the same verdict code. Check by naming
  the observer in each row, then grep both kits for it.
- **Places assigned after the fact.** A kit was placed to make a row look double. Check that the
  place names what the kit reads or drives (a file, a log line, a pixel, a process it starts),
  quoted from the kit.
- **A noisy probe.** A probe's unplanted control flags mismatches, so "BLIND" was noise. Check that
  the control's count is in the receipt and is 0.
- **Corners that don't hold.** A corner word fails to read evenly from all four half-lines for some
  fact. Check one fact against all four; if one reading strains, the word goes back to him.
- **Seats as decoration.** A seats list that never reaches a person. This can't be judged in a
  day; he asked to see results before assuming what they will say.

Off-switch: say "no depth map on this", or remove this folder.

## LENS (six lines, carried)

```
LENS · depth-overlap
a  my view:            two checks only overlap where a fault between them is seen; plant to prove it
b  the view I ascribe: double coverage on a lens graph, plus a seat per language; toolchains buy friends
c  their pull on mine: four, not six -- two opposed lines through zero, and corners from the ends
d  my pull on theirs:  the corner words, offered as guesses until he names them
persona / inverse:     the plant keeps every survivor / the inverse: most promises owe one good kit
principles reframe:    plain words; each seat an open invitation; receipts anyone can rerun
```

<!-- footer: minted by bin/ft1mt from conventions/house.env and conventions/FOOTERS.org; edit those, not this -->
*Version 1.1.4: edition revised from 1.1.3 on 2026-10-10; spine: 2026-10-10.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/ (scripts GPL-3.0-or-later); Mentat (for Corwin; claude-opus-5-5)
<!-- /footer -->
