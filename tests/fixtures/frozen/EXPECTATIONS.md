# What the frozen notes MEAN

**This file was written by hand, by reading the bytes.** It was not generated,
and it must never be generated. That is the entire reason it is worth anything.

A renderer and a parser written by one hand agree with each other by
construction; their agreement is one witness read twice. These fixtures are a
*different* witness — bytes written by a past version of the program, which
cannot be updated to match a new belief — and this file is a *third*: a human
statement of what those bytes say, in a form no code in this tree emits.

Corwin, 2026-09-15:

> *"It isn't enough to have a second reader: we have to draw/consider different
> data from within the same set and reach the mutually supporting conclusion
> that information begins to show a signal strength."*

## The rule, and it is the whole discipline

**If a change breaks this file, the change is wrong until proven otherwise.**

Do not re-emit the fixtures. Do not "update the expected values." Either fix
the code, or — if the format genuinely had to move — write a MIGRATION note
beside the old fixture and freeze a NEW generation next to it. The old bytes
stay. That is the archive rule, applied to the test suite instead of to memory,
and for the same reason: a fixture you regenerate is a fixture that agrees with
whatever you just did.

## Why these three files exist

On 2026-09-15 a rename of the front-matter key `unit` → `carry`, applied
correctly and consistently to all three sites in `dl2.py`, passed **all 207
tests** while silently flipping a stored seam from

    unit=16  pressure=9  score=-437  act=False

to

    unit=1   pressure=9  score=+8000  act=True

— inverting the compaction queue — with the three independent chain readers
green and truthful throughout. They were truthful: C1–C4 check position, name,
self-hash and link. **None of them can see meaning.**

The round-trip test that should have caught it,
`test_render_parse_round_trips_to_identity`, is *structurally* blind: it asserts
`model → doc → model → doc` is identity, which is invariant under a consistent
rename of the key on *both* sides. It round-trips the pair through itself.

The missing witness was TIME. Notes already on disk were written by code that
no longer exists, and nothing in the suite asked them anything.

---

## carrying-sixteen / g0001-20260915T120000Z-df2c139fa0f0d3be.md

    seam                 = carrying-sixteen
    gen                  = 1
    by                   = frozen-witness-2026-09-15
    from                 = the frozen fixture
    triggers.count       = 2
    triggers.first       = compaction
    first-seen           = (empty)
    prev                 = (empty)
    cited-at-write       = 0
    unit                 = 16
    mode                 = SEATED
    body.first-word      = An
    filename.hex16       = df2c139fa0f0d3be

Generation 1 leaves `first-seen` empty on purpose: under spec v2 the filename is
the hash of the whole file, so a gen-1 `first-seen` would name the file it is
written inside. Empty means "this file".

## carrying-sixteen / g0002-20260915T120001Z-03a13e819d19944d.md

    seam                 = carrying-sixteen
    gen                  = 2
    triggers.count       = 0
    first-seen           = g0001-20260915T120000Z-df2c139fa0f0d3be.md
    prev.hex16           = df2c139fa0f0d3be
    cited-at-write       = 9
    unit                 = 16
    mode                 = SEATED
    filename.hex16       = 03a13e819d19944d

`prev` names generation 1 by the sha256 of its whole bytes, and its first
sixteen hex digits are generation 1's own filename stem. Those two facts are
recorded in two different places by two different mechanisms, and they must
agree. That agreement is free — nothing forces it — which is what makes it
evidence rather than bookkeeping.

**The mark survived a revision that declared nothing.** Generation 2 was
appended with no `unit` argument and still reads 16, because a revision inherits
rather than resetting. A change that made revisions reset to 1 would be invisible
to every other test in this tree.

## plain-atom / g0001-20260915T120000Z-25ba2852b0bc5b1f.md

    seam                 = plain-atom
    gen                  = 1
    cited-at-write       = 0
    unit                 = 1
    mode                 = SEATED
    filename.hex16       = 25ba2852b0bc5b1f

Nothing was declared, so the mark is 1 — the honest answer when the writer had
no points of meaning mapped. This file is here so that a bug which made *every*
note read as 1 cannot hide behind the file above it.

---

## The arithmetic these bytes pin

The declared mark is only worth freezing if it still drives the number it is
supposed to drive. Given the marks above, `dl2.score(pressure, unit)` must
return, in thousandths (chainspec U1–U4, truncated toward zero):

    carrying-sixteen  pressure=0   score = -1000    nothing has leaned on it
    carrying-sixteen  pressure=9   score =  -437    well under its ceiling
    carrying-sixteen  pressure=16  score =     0    exactly neutral buoyancy
    carrying-sixteen  pressure=32  score = +1000    act
    plain-atom        pressure=0   score = -1000
    plain-atom        pressure=1   score =     0    exactly neutral buoyancy
    plain-atom        pressure=2   score = +1000    act

`-437` is the one that catches the ghost: it is only reachable with a mark of
16, it is a truncation (−437.5 floors to −438 and truncates to −437), and it is
therefore a single number that witnesses the mark, the arithmetic and the
rounding rule at once.
