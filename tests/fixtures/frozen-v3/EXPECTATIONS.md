# What the frozen v3 notes MEAN

**This file was written by hand, by reading the bytes.** It was not generated,
and it must never be generated. That is the entire reason it is worth anything.

It is the companion to `tests/fixtures/frozen/EXPECTATIONS.md`, which states
the meaning of the v2-era notes. That file is untouched and stays untouched.
This one exists because on 2026-09-15 the generation filename lost its
timestamp — 42 characters became 25 — and **an archive-only store cannot
migrate**, so from that day the tree holds two name shapes forever and both
eras need a witness that is not the code.

    v2 (archived)   g0001-20260915T120000Z-df2c139fa0f0d3be.md    42
    v3 (minted)     g0001-79d299c7ead11b05.md                     25

## The rule, unchanged, and it is the whole discipline

**If a change breaks this file, the change is wrong until proven otherwise.**

Do not re-emit the fixtures. Do not "update the expected values." Either fix
the code, or — if the format genuinely had to move again — write a MIGRATION
note beside these and freeze a NEWER generation next to them. The old bytes
stay. A fixture you regenerate is a fixture that agrees with whatever you just
did.

## Why these three statements exist

The v2 fixtures could not witness the v3 change, because they are v2. A suite
whose only frozen bytes are from the old era proves that the old era still
reads — which is necessary and is only half the question. The other half is
whether the NEW shape is read by the same rules, and whether the two shapes
sit in one directory without either becoming invisible.

The failure this guards against does not announce itself. A reader that does
not match a filename does not report an error; it simply does not see the
file. **A seam whose files are all invisible reads exactly like a seam with
nothing in it.** That is "lose the files" in its purest form, and it is the
one thing the shortening was forbidden to buy.

---

## carrying-sixteen — THE MIXED-ERA SEAM, and the reason this directory exists

This seam holds three generations and **two name eras**:

    g0001-20260915T120000Z-df2c139fa0f0d3be.md    v2, 42 chars
    g0002-20260915T120001Z-03a13e819d19944d.md    v2, 42 chars
    g0003-d0359020960ec64a.md                     v3, 25 chars

Generations 1 and 2 are **byte-for-byte copies** of the two files under
`tests/fixtures/frozen/carrying-sixteen/`. Their meaning is stated once, in
that directory's EXPECTATIONS.md, and it is deliberately NOT restated here. A
second human statement of one fact is a second thing that can drift, and this
project's thesis is that two records of one fact must be *free* to disagree,
not made to agree by copying. What is asserted about them here instead is
byte-identity with the originals — a claim the copies cannot satisfy by
themselves.

Only generation 3 gets a statement, because only generation 3 is new:

## carrying-sixteen / g0003-d0359020960ec64a.md

    seam                 = carrying-sixteen
    gen                  = 3
    by                   = frozen-witness-v3-2026-09-15
    from                 = the frozen v3 fixture
    triggers.count       = 0
    first-seen           = g0001-20260915T120000Z-df2c139fa0f0d3be.md
    prev.hex16           = 03a13e819d19944d
    cited-at-write       = 0
    unit                 = 16
    mode                 = SEATED
    body.first-word      = Generation
    filename.hex16       = d0359020960ec64a

Three things are frozen here that nothing else in this tree can see.

**`first-seen` carries a V2 NAME inside a V3 FILE.** That is spec v3 N5 made
visible: the pin is inherited from the previous generation and never
recomputed, so it names the file that is actually on disk. A reader that
"normalised" it to the new shape would be inventing a filename that does not
exist — and the note it points at would be gone, which is the precise failure
this whole exercise was measured against.

**`prev` reaches ACROSS the era boundary.** `03a13e819d19944d` is the first
sixteen hex digits of the sha256 of generation 2's whole bytes, and it is also
generation 2's own filename stem — a v2 stem, quoted by a v3 file. Two
mechanisms, two places, no read-time path between them, and now two name
shapes as well. That agreement is free; nothing forces it; which is what makes
it evidence rather than bookkeeping.

**`unit` survived the era change.** Generation 3 was appended with no `unit`
argument and still reads 16, because a revision inherits rather than resetting.
A format change that quietly reset the declared mark at the era boundary would
be invisible to every other test in this tree — and it is exactly the shape of
the 2026-09-15 ghost, which inverted the compaction queue while 207 tests
stayed green.

**`cited-at-write` reads 0 where generation 2 read 9, and that is correct, not
loss.** That field is a snapshot of how many lines the seam's citation log held
at the moment the generation was written, and the seat this generation was
minted in had no citation log at all. It is the honest number for that write.
Say it here because a reader coming to these bytes cold could otherwise read
the drop as a format change eating a count — which is exactly the kind of quiet
wrong belief a hand-written statement is for.

---

## plain-v3 — a chain that has only ever been v3

## plain-v3 / g0001-79d299c7ead11b05.md

    seam                 = plain-v3
    gen                  = 1
    by                   = frozen-witness-v3-2026-09-15
    from                 = the frozen v3 fixture
    triggers.count       = 2
    triggers.first       = shortening
    first-seen           = (empty)
    prev                 = (empty)
    cited-at-write       = 0
    unit                 = 9
    mode                 = SEATED
    body.first-word      = A
    filename.hex16       = 79d299c7ead11b05

Generation 1 leaves `first-seen` empty for the same reason it did under v2: the
filename is the hash of the whole file, so a gen-1 `first-seen` would name the
file it is written inside. Empty means "this file". Taking the date out of the
name changed nothing about that.

The mark is **9**, and it is neither 1 nor 16 on purpose. A bug that made every
note read as 1 hides behind a fixture that declares 1; a bug that copied the
other directory's value hides behind a fixture that declares 16.

## plain-v3 / g0002-68d26ebb0f17769f.md

    seam                 = plain-v3
    gen                  = 2
    triggers.count       = 0
    first-seen           = g0001-79d299c7ead11b05.md
    prev.hex16           = 79d299c7ead11b05
    cited-at-write       = 0
    unit                 = 9
    mode                 = SEATED
    filename.hex16       = 68d26ebb0f17769f

**The free agreement got easier to see, not harder.** Under v2 a reader
comparing `prev:` to generation 1's filename had to skip a 16-character date in
the middle of the name to find the 16 characters that matter. Here the whole
stem is the handle:

    first-seen:  g0001-79d299c7ead11b05.md
    prev:        sha256:79d299c7ead11b05b13e932ca0f71c94d5612aa0971aa2968bc...

That is one glance instead of two, on the one comparison the frozen-fixture
discipline was built around. It is the only findability claim in this change
that runs in the *better* direction, and it is stated here so it can be argued
with rather than assumed.

---

## The arithmetic these bytes pin

The declared mark is only worth freezing if it still drives the number it is
supposed to drive. Given the marks above, `dl2.score(pressure, unit)` must
return, in thousandths (chainspec U1–U4, truncated toward zero):

    plain-v3          pressure=0   score = -1000    nothing has leaned on it
    plain-v3          pressure=1   score =  -888    truncation, not floor
    plain-v3          pressure=4   score =  -555    truncation, not floor
    plain-v3          pressure=9   score =     0    exactly neutral buoyancy
    plain-v3          pressure=18  score = +1000    act
    carrying-sixteen  pressure=0   score = -1000    nothing has leaned on it
    carrying-sixteen  pressure=9   score =  -437
    carrying-sixteen  pressure=32  score = +1000    act

`-555` is this directory's equivalent of the other's `-437`: it is only
reachable with a mark of 9, and −5000/9 is −555.55…, which **floors to −556 and
truncates to −555**. One number that witnesses the mark, the arithmetic and the
rounding rule at once. `-888` is a second one, from −8000/9 = −888.88…, so a
reader that got the rounding right by luck on one value has to get it right
twice.

## The name lengths these bytes pin

    carrying-sixteen/g0001-...  42 characters   v2
    carrying-sixteen/g0002-...  42 characters   v2
    carrying-sixteen/g0003-...  25 characters   v3
    plain-v3/g0001-...          25 characters   v3
    plain-v3/g0002-...          25 characters   v3

25 is not decoration and it is not a round number somebody liked. It is
`g` + 4 padded digits + `-` + 16 hex + `.md`, and every one of those pieces is
argued for in chainspec's v3 block with a named cost: the padding costs 3
characters and buys `ls` order (and C2 checks it); the 16-character handle
costs 4 characters over the collision-safe minimum and buys C3's work factor on
the head of a chain; hex over base32 costs 3 characters and buys the eyeball
comparison two paragraphs above.

If a future writer makes these names shorter still, these five numbers are what
it has to explain.
