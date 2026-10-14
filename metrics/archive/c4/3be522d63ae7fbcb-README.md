# C4 — Collaborative Consent Continuity Controls

A design language and shell-assembler for making **consent and accountability legible at the
seams where systems hand work to each other.** It adds no capability. It adds a place to pin
who agreed to what, at the transitions where that normally goes unrecorded.

The name descends from Simon Brown's C4 (context / containers / components / code), which
supplies the zoom-level idea, not the content.

**One thing this door has not settled, said here rather than decided quietly.** That opening
sentence is the lab's operational one. The project's *published* definition — at
`c4.ghostwheel.cloud` since 2025-08-17 — is a different sentence with different words:
*"C4 is Continuous Creation, Command & Control, a literate technology control framework built
atop OrgVM."* **"Literate" is Donald Knuth's 1984 coinage** ("Literate Programming," *The Computer
Journal* 27:2, 97–111) — cited, not just reused, as of 2026-09-11 at `context/c4-depiction.md` §7.5
(tier: SECONDARY, and why, stated there) and `h/RESEARCH-2026-09-11-knuth-citation.md` (the full
pass). This footnote does not change the sentence above; it makes the sentence citable. The word
"assembler" does not occur in it. Both expansions run today
(`facts/c4-is-a-seam-and-that-is-the-feature`), and which one belongs in the definition-shaped
slot above is an open question with the keeper's name on it — argued at
`context/c4-as-an-assembler-v2.md` (the G5 guard in its front matter, and OPEN POINTS item 1).
It is named here because editing this line to match either side, quietly, would move the
problem rather than settle it.

## Where do I write you down?

You know this problem. You have a fact and its relevance, and two ways to keep them: scribble
at the foot of the notes you already have, or make a new file. You usually scribble — not from
laziness but from arithmetic. The scribble costs one decision (head or foot, and tradition
answers that). The new file costs two hard ones: what to call it — and names are obnoxiously
durable, as anyone who involuntarily acquired a pet-name knows — and where to put it, which
you must then *remember*. Half your thought climbs into the filename and dies there.

C4's answer: **decide the row, inherit the address.** Here, a fact and its relevance sit side
by side in one line of a plain file; the file and the directory — the two hard decisions — are
supplied by where you already are, because in this tree **the path carries the meaning**. One
move writes four points of reference at a single address you remember as one thing. The foot
of the notes, generalized: every append lands at the foot of the *right* stack, automatically.

That is the access on which this project offers a little friendly competition to org-roam and
the rest of the just-use-a-database class. The trick is that your operating system already
ships the database — the filesystem — and it is the one store readable by `cat`, checkable by
`sha256sum`, and owned by you. The minimal reader here is `cat` plus `pwd`: bytes plus where
you stand. Nothing else is required. Which brings us to the point:

## No AI is required. That is the point.

**Nothing here needs an AI to use.** Every record is a plain file, and nearly every tool is
POSIX `sh` — 86 of the 93 executables in `bin/`, with the seven exceptions named rather than
rounded off: `archive-markdown.sh`, `logslice.sh`, `markers.sh`, `path-lint.sh`,
`sig-report.sh` and `snap.sh` are bash; `us1ct` is python3. Files that arrive from elsewhere
and cannot carry a bare register name — archives, images, third-party drops — are *interned*
under a declared convention (`intern assets`, in `.c4`) rather than pretended away.

The bearing of AI on this system is the reverse of the usual pitch: **C4 exists to restrict an
AI within the context of the system** — to make machine participation build tools rather than
act implicitly, to avow itself in filenames (the hyphen rule below), and to leave receipts a
human can re-derive without asking any model anything. An AI helped build this; none is needed
to run it, read it, or hold it to account.

> *"The real finesse to what I am doing, if this works at all, is that NO AI IS REQUIRED
> WHATSOEVER to use it. The main bearing of AI to the system is more or less to RESTRICT AI
> within context of the system."* — the keeper, on IRC, before this README existed

## What it is aimed at

**Ghostwheel is the target, and C4 is the principal means of implementing and designing it.**
That is more than a naming layer usually gets — GNU `as` did not design the x86 — and it is
the interesting strain: the machine and the language for it are being built through each
other. Ghostwheel is not an abstraction here; it has hosts, a ring-of-rings composition, and a
run-level state model that reaches into naming, so that a name existing at RL3 and not at RL0
is a fact about the target machine rather than a style preference.

**OrgVM is not the target.** It is an interoperability layer with utility outside the
C4/Ghostwheel context entirely. In the keeper's words, ruled 2026-09-10:

> *"Ghostwheel is the target for C4 and C4 is the principle means of implementing and designing
> ghostwheel. I conceive orgvm as an interoperability layer that has utility outside
> C4/ghostwheel context, perhaps even for people that don't Emacs or org directly but do have
> use-cases for literate virtual machines or clusters or networks of them that otherwise have
> little to do with our own … but probably do appreciate the README/RECIPE approach as being a
> meaningful, confidence inspiring [demonstration] each time they would be accepting a new
> upstream orgvm into their own work, thinking as such a person."*

What that person needs from us is not our instruction set; it is a reason to trust a thing
arriving from upstream, offered fresh **each time**. That is what the README/RECIPE convention
is for: `derive/emacs-recipe/RECIPE.org` unpacks into its own tools with `sh unpack.sh
RECIPE.org` and no Emacs required, `README.org` carries the same contract, and `c4mark` checks
doc against tools on every run. The full argument is §1.1 of `context/c4-as-an-assembler-v2.md`.
What that section does *not* yet do is argue Ghostwheel's run-level and ring model as an
execution model the way it argues GNU `as` against its own manual. That section does not
exist. Its absence is a gap in the paper, not a doubt about the ruling.

## Describing a complexity: three languages, one of them real

The intent is that you can describe a complexity at whatever height suits you — directly in
ASSY token streams, in fenced META, in a C4QL look, or in prose with a tool's help. Stated in
the order of what actually exists today, which is not the order the names suggest:

- **ASSY** — direct instruction; *walks*. **Real, and measured.** The discipline runs in
  production: `bin/he2ma` is HOST ENVIRONMENT 2 MARKER ARRAY, four register letters each
  resolving to a facet word its own `m/t` row carries, with the run-level digit at the hinge.
  33 tools in `bin/` carry that five-character shape; 33 of 33 gloss their own name on line 2;
  20 decompose entirely inside `m/t`, and the ones that don't borrow words from outside it.
  `h/assy.sh` is the house tokenizer and the first tool that could *fail* the language
  document's round-trip claim. It does not.
- **META** — hints, weights, meaning; *weighs*. **Not yet.** There is no META parser and
  nothing effects it. By this shop's own rule — a type is real when something can do it — every
  claim about META is reported here, never asserted.
- **C4QL** — introspection, reflection; *looks*. **Not yet.** `h/c4qa.sh` v0 implements
  selection and says in its own header that its three constraint guards are STUBBED BY NAME.
  No grammar card exists.

So the ladder is well supplied at the bottom and thin in the middle. You are owed that shape
rather than the impression of three equally furnished levels. Working notes:
`h/DIFF-2026-09-10-E2-complexity-layers.md`, §3 for the measurement and §6 for where the frame
does not hold.

## Status: CANDIDATE. Nothing here is certified.

Read that literally. Individual files carry signatures; **a good signature here means "this
file has not changed since it was signed," and nothing more.** It is not review, not
endorsement, and not a claim that the idea inside is correct. See `SIGNATURES.md`.

## What this does NOT do

Stated up front, because a document that only lists what it does lets you infer coverage
nobody claimed:

- **It does not sandbox, contain, or restrict any running program.** It records intent and
  consent; it does not enforce them.
- **It is not audited.** No formal review of any part of this has been performed by anyone.
  Two outside readers have read the tree and written up what they found
  (`from-bryant/2026-08-05/`, `h/LENS-2026-08-30-edrx-mathforward-boards.md`) — that is
  reading, not audit, and not endorsement.
- **It has no release, no versioned interface, and no stability promise.** Paths and
  vocabulary change between sessions.
- **This tree is deliberately UNLICENSED while pre-release.** `COPYING` is present and 0
  bytes on purpose: a tombstone marking where the licence act will land at release — not a
  gap, and not permission. No licence text ships in internal shares, precisely so that no
  collaborator acquires an implicit obligation to share changes before the release act is
  chosen together. The keeper's stated hope is eventual release as free software; the act
  that makes it so is a ceremony this tree has not yet performed. The licence gauge
  (`man/derived/licence.org`) owns the measurement, so this sentence can rot without taking
  the fact with it.

## Authorship, disclosed by construction

**A hyphen in a name is an avowal that a machine had a hand in it.** It is carried in the
filename rather than in metadata, so it survives copying, quoting, and being read by someone
who opened nothing else. Where you see it, an AI participated. A human keeper signs.

And the negative case is the load-bearing one: unless a machine hand has been specifically
**disavowed** somewhere, the avowal stands. A disavowal is not a private note — it is a
controlling disclosure, and it propagates to whoever gets this next.

## Your first three commands

Each runs from the tree root and changes nothing:

1. `sh bin/c4prime` — the state of the shop, generated fresh each run; it cannot go stale.
2. `sh bin/fi1nd WORD` — where does this word live? Every hit names its register letter, or an
   honest dash where the hit is not in a register.
3. `sh bin/ma3nual --check` — does the manual match the tree right now? OK, or a diff.

**The manual — `man/c4.org` — is the guided walk; this file is only the doorstep.** Take that
as a charter, not a boast: the manual is a self-declared CANDIDATE seed whose concept section
is still five TODO stubs, each naming its source rather than paraphrasing it. The long-form
arguments live in `context/`.

Single lowercase letters in this tree are C4 *registers*, and the test is mechanical rather
than typographic: a single-letter top-level directory carrying a `.c4` marker is a register,
and anything else honestly is not one. `d/` and `u/` are letter-named and carry no marker;
`l/` and `o/` are marked `mock`; `Z/` carries a marker and is not lowercase. `bin/` holds the
tools, `facts/` the small settled statements, `decks/` the reasoning, `evidence/` the ledgers
and measurements — and the rest is the shop's own furniture, which the manual introduces in
the order that teaches. Filenames stay boring on purpose — bare paths, no spaces, nothing
shell-significant — so that every name can be a word in a sentence a tool can read.

`Z/` holds the keeper's more sensitive material. It is counted, read with care, and **not
walled** — the standing instruction is to say so out loud when something wants handling. There
was a rule here once that fenced `Z/`, `a/` and `p/` off as no part of this project. On
2026-08-03 it was audited, found to appear in zero verbatim quotes of the keeper's — the
machine had written it into `.c4` and `CLAUDE.md` and then cited it back to him as his own —
and retired from both, and from `bin/c4prime`. His replacement is a principle rather than a
fence:

> *"C4 should be focused on provably looking on the right thing not dependent on not having
> wrong things sitting around to be not looked at."*

A fence proves nothing and depends on compliance. A receipt is a measurement. That is the
whole design, visible in one retired rule.

## If you find a fault

Say so out loud — you'd be surprised how welcome that is here. ASKANCE (question it) and
OFFERING (contribute to it) both land by mail: Corwin Brust <corwin@bru.st>. Questions are
banked in the tree, dated, kept visible until answered. Silence is not consent, downloads are
not adoption — say something, and it becomes real.
