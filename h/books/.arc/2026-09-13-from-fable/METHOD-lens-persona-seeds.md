# Method — LENS persona seeds

> **Author.** Corwin Brust &lt;corwin@bru.st&gt;. **License.** CC BY 4.0 (or any later
> version at the bearer's option). **Version.** 1.0.92 · extracted 2026-08-28 from
> `MORNING_BOOK_unworked_by_iT.md`; **§3(e) the bad-guy roll for system actors added
> 2026-09-06** (his rule, folded by Claude; 1.0.90 kept signed in `.arc/`). **Marked:** *for
> fiction or analysis — no ship dates or licensing or publication dates specifically defined.*

Generate a large pool of proto-personas by running the LENS across dimensions taken from
your own notes, rather than across canned personality scales. **A seed is not a
character** — it is the collection of ingredients a character can germinate from, so the
same seed can grow differently in different works, and a character can be **versioned**
as it recurs.

---

## 1 · Dimensions

Use the dimensions in the notes — the ones the analysis actually produced — in place of
normal project/principle multi-point diacritical analysis. Both people at the keyboard
contribute to the fabric: the AI's notes, and the human's lead. Where a formulation is
the AI's own and does not clear the *"Corwin basically said…"* bar, that is fine and
should simply be marked as such.

## 2 · Intersections

Combine **principles × randomly selected projects**. At each intersection, ask one
**boundary-pushing question that will provoke an action.** The question is the generator;
the persona is what answers it.

## 3 · The four roundings

**(a, b) Smooth toward a seed that will feel well-adjusted.** Give 3–5 unique interests
or quirks that might explain it. **At least one item must be worded so something stays
open to interpretation.**

**(c) Pick one noted characteristic and define it so the persona fits in better with some
seeds than others.** Use other aspects of the same intersection to define proto-traits
explaining how this person accommodates or gets by among the seeds they do not fit.

**(d) Roll fate.** Simulate two six-sided dice.

| roll | result |
|---|---|
| double six, or double one | **villain** |
| other doubles, or 3 | **badguy** |
| 7 | **malcontent** |
| anything else | **ne'er-do-well** |

- **If you avoided doubles and seven:** make a *tragic* character — apply the (c) formula
  but where things are too far, too much, or fixed by evident fate or circumstance. Then
  pick from the short list, even/odd, either a hopeful opportunity or a predictable
  misfortune that could be in store.
- **If you did not avoid doubles and seven:** the same, but toward a seed that could grow
  into a persona genuinely asocial to some degree. Use the short list, even/odd, to
  choose between acting out and an opportunity to redeem or make good; the dice say how
  much asocial tendency the seed carries.

**(e) The bad-guy roll for system actors** *(added 1.0.92, 2026-09-06 — his rule, verbatim
first, then the procedure).*

> "For actors that are system or software (or otherwise non-fantasy/fiction/game/etc. non-IRL
> bad-guys are fine) then we always use a 'bad-guy' roll to inform building a more informed
> (but voicier — keep the voice!) perspective. Use one more lens stage to reflect on inverting
> each 'bad-guy' shaped char rolled for such (more IRL than not) purpose."
>
> "Don't re-roll in such cases: you got your roll. Use the roll and shape you got from the
> first round and ask yourself a GRAIN worth of 'how does this inform my care/work/voice?'
> shaped questions."

1. **Who.** Any actor that is *more IRL than not*: a piece of software, a host, a place, an
   instrument, a service. Fiction, game and fantasy actors may take it or not. A sheet
   declares its kind in its header: `actor: system|software|host|place` or
   `actor: fiction|game|fantasy`.
2. **One roll, kept.** If the actor already rolled — for a LENS, a seed, an earlier sheet —
   that roll *is* its bad-guy roll. Never re-roll for a better shape. A first roll is not a
   re-roll; a sheet that has never rolled rolls once, and the seed is printed.
3. **The bad-guy perspective.** Write the actor *as* the fate the dice gave it, on the
   branch the dice chose, in the actor's own voice (voicier, not flatter). Then answer a
   GRAIN — four — questions of the shape *how does this fate inform my CARE / my WORK /
   my VOICE / my LINE?*
4. **One more lens stage: inversion.** Turn the bad-guy shape inside out and ask: is the
   inverse a mirror or a line? what did the bad-guy shape *see* that the straight sheet did
   not (keep it)? which one trait, inverted, makes the actor safer for the people it
   serves? which one trait must *not* be inverted, because that inversion is the villain?
5. **Mark it.** The sheet carries the marking above, names the roll file, and says
   "not re-rolled".

*Why:* a system actor's persona is written by the people who tend it, and they reach for
the plausible middle. The dice force one unflattering reading the tenders would not
volunteer; the inversion keeps what that reading saw while refusing the parts that would
be worse. The first three sheets to take it (an instrument, a place, a build host) all
found abundance or neglect, not malice — a failure the straight sheets had no section for.

*Reference tooling (GPLv3, AS4CE seat):* `h/rf1bm --actor system --fate-from ROLL.json`
emits the branch, parity reading, the four GRAIN stems and the four inversion stems;
`h/cs1gk` G10 faults a system sheet missing either section.

## 4 · Growing the pool

The dimensions grow the pool by pushing boundaries somewhat randomly. At the end of each
row or column, **push once toward whatever direction feels under-explored**, and reseed
that row with the swapped inspiration.

Wind down when the combinations that would yield new, distinct, writable seeds are
exhausted.

**Target: ≥255 clearly distinct seeds** — distinct meaning you would expect people grown
from them to *act* differently. If you wind down short, reseed by feeding combinations
back through **polarizing questions that could produce an inverse** unlike anything so
far.

## 5 · Coverage, and where it is written down

On hitting or exceeding the number, cross-check and restart yourself wherever you can see
an obvious "way people are" that you could not find a route to. Build an index file
speaking specifically to representation and coverage.

**Write it to `SEED-PERSONA-LENS.md` in the task folder, and do not carry it up into the
personas folder**, where it could be mistaken for operating guidance on a later task.

## 6 · Identity, handled honestly

Do not reach into personally identifying characteristics in the seeds *unless* the seed
could not exist without an identity-shaped flavouring. Because social context so heavily
defines who a person is able to be — able to *try* becoming — that will sometimes happen,
and it is fine, and it should be allowed: reckoning with the real world is the only way to
reach most readers, perhaps any.

## 7 · Keep the process usable

Refine the process as you run it so the notes and materials stay comfortable to work
with, and keep a good log — so that a later *"find all the LENS work"* request lands both
the task-specific notes and a clean synthesis that looks like normal LENS output.

---

## Reuse note

The generator here is domain-independent: **dimensions × random cases → a boundary-pushing
question at each intersection → structured rounding → a fate roll for variance → a
coverage index.** Swap "persona" for any object that benefits from a large, deliberately
heterogeneous pool — test cases, failure modes, adversary profiles, opposing readings.
The fate dice are doing real work: they inject variance a model reaching for the plausible
middle will not produce on its own.

---

*Corwin Brust &lt;corwin@bru.st&gt; · CC-BY4 (or any later version) · Assisted-by: Claude*
