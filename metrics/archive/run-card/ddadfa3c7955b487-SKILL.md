---
name: run-card
description: Write a RUN-CARD before touching a system you did not build. Use whenever work is about to run against a real host, a production database, someone else's data, a backup, a log, or any environment where a mistake is expensive or a false conclusion could ship — and especially when the person at the keyboard is not the person who wrote the steps. Triggers on "write a run card", "card this", "no card no run", "how do I run this safely", "sweep the logs for X", "check whether Y ever happened", "is that host clean", "let's get on the box and look", "walk me through this", "what would I paste", "can a volunteer do this". Also use when a run just finished and the results need reading in the right order, or when someone is about to report a CLEAN result from a sweep. This is not a checklist generator and not a devops runbook tool — it is a discipline for producing one paste-ready, auditable artifact that a careful stranger could run without you in the room.
---

# run-card — the credential-free door

A run-card is what lets someone who did not write the steps run them **correctly, on a real
system, without you standing behind them.** It asks for time and care. It does not ask for
genius, seniority, or a credential. That is the whole point of it — a card is a door that
anyone willing to be careful can walk through.

It exists because of a specific, repeated discovery: **the operator is rarely the weak
part.** The weak part is a step whose result gets read in the wrong order, an absence
reported as a clean bill of health, an instrument pointed at the wrong window, or a
conclusion that travels without the bound it was born with. A card is not a reminder to be
careful. **A card is a measurement scheduled in advance** — it names the instrument, fixes
the order the answers are read in, and states what stops the run.

## The one thing to internalize

> **A card never says "be careful." It says: run this; here is what the answer means; here is
> what stops you.**

If you find yourself writing exhortation into a card, you have written a sermon. Delete it and
write a step with an observable instead.

## The furniture (paste this into the session FIRST)

Every card opens with a field block, **comment-prefixed so it pastes into the shell.** This is
not decoration. The transcript is the evidence — and a tape that shows *commands* but not
their *authorization* cannot be tied back to the card that licensed them. With the furniture
in the shell history, **the tape itself proves what the run was permitted to do**, and a cold
reviewer never has to go looking for the card. Card and trail become one artifact.

    # ============================================================================
    # CARD ID    : RUNCARD-<date>-<nn>-<slug>     (supersede, never edit)
    # PURPOSE    : one sentence — the QUESTION this run answers
    # GATE       : what authorizes this (whose ruling, when) — or "none", said plainly
    # DRIVER     : the human at the keyboard
    # SIGNER     : who signs which output, on whose machine (keys never travel)
    # PRECOND    : what must already be true, checked aloud before step 1
    # WRITES     : EVERY write this card makes, named. "Read-only" must MEAN it —
    #              your own scratch dir is a write, and it gets declared, not assumed
    # TRAIL      : the label comment each step opens with
    # BAG        : one dated dir; everything tees into it; MANIFEST before the hop
    # HOMECOMING : pile-then-one-hop, or quick-turns — DECIDED HERE, with the reason
    # DISPOSITION: what gets DESTROYED, when, and who records it
    # ABORT      : the conditions that stop the run (park it; do not argue with it)
    # ============================================================================

## The read-order, and it is the load-bearing rule

When a step sweeps for something, the card **states the order the output is read in**:

> ### COVERAGE → POSITIVE CONTROL → TARGETS. Always. In that order.

**Coverage first.** What window does the instrument actually see? Retention, scope, host list,
date range. State it *before* the result, where it cannot be skipped.

**Positive control second.** Did the sweep find something it *should* have found? A search that
returns nothing proves nothing unless the same search demonstrably finds a thing you know is
there. **Zero on the control means the instrument is blind — the sweep is VOID, not clean.**

**Targets last.** Only now does a hit or a miss mean anything at all.

**The worked example, and it is why this rule exists.** A sweep of a host's authentication logs
for two suspect SSH keys returned `(no hits)`, `(no hits)`, `(no hits)`. The positive control
was gorgeous — 74,103 accepted logins by real, named users. The instrument was perfect.

Read targets-first, and you write *"host clean — the bound widens to five hosts"* into a
security finding going to a national foundation.

Read coverage-first, and the **very first line** says the logs only reach back six weeks — and
the events under investigation are **five weeks before that**. The sweep is *clean and silent*.
It is a working instrument pointed at a window that does not contain the events. It proves
nothing, and the honest card says so and **does not count that host toward the negative.**

The coverage line was the only thing standing between a careful team and a false claim in a
published report. **That is what the ordering is for.**

## What a card must REFUSE to claim

This is the part that makes a card trustworthy rather than merely tidy:

- **An absence is not a clean result.** "We didn't find it" is only a finding if you *looked*,
  and it is only *worth* something if you say where you looked. **Bound every negative** — in
  the artifact, not in your head.
- **An unreachable host is a gap, not a clean host.** Write the gap into the output.
- **A hash is the start of reading, not a substitute for it.** Verifying a checksum proves the
  bytes didn't change. It says nothing about what they *say*. (A patch report can pass its
  checksum perfectly and still say the rollout failed and two internet-facing hosts are
  unpatched. Read the file.)
- **A note about a check is not the check.** "We swept, it was clean" written in a summary is a
  *claim about* evidence. It is not evidence. If you cannot name the run that produced a fact,
  the fact is data.
- **A bare numeric ID is never a safe search term.** It will match ports, PIDs, and the
  fractional-seconds field of a timestamp, and hand you a phantom incident. Anchor on the name.
- **Prefer the interface that decides over the file you think it reads.** Ask `sshd -T`, not a
  regex over the config that will miss a tab.

## Steps

Numbered. Paste-ready. **Absolute paths** — `~` is not a path, it is an assumption about who
you are, and it will resolve differently for root. Syntax-check every multi-line block before
you hand it to a driver; a card must be *pasteable*, not *interpretable*.

Each step names **the observable that proves it ran** — and each step opens with a label
comment, so the shell history reads back as a narrative. Shell history is evidence. Write it on
purpose.

**Gate steps.** Where a later step's meaning *depends* on an earlier answer, say so, and make
the gate **readable at the keyboard** — put the expected value right there on the card so the
driver can decide without phoning anyone. A gate that requires a round-trip is not a gate; it's
a bottleneck.

## Disposition — the field people forget, and the one that protects strangers

Every run leaves residue: extracted archives, working copies, staging directories, a bag on a
host that isn't yours. And the residue is very often **not about your question and not yours to
keep** — a single system's auth log carries the login records of *every person who ever used
it*.

So the card says, in advance:

1. **What is transacted** — the raw material, most of which is other people's.
2. **What must not travel** — *the analysis runs where the data lands; only the ANSWER comes
   home.* Bring the counts, the hit/no-hit, the hashes. Not the log.
3. **What is destroyed, when, and who writes it down** — with a trigger ("after the outputs are
   verified, and not before") and a receipt.

Preserve-before-act governs the **evidence**. It does not license leaving a fleet's user data on
personal infrastructure. **A run with no disposition step is not finished. It is abandoned.**

## Tone at the keyboard

A card is often being run by someone newer than you, on a system that scares them a little. The
register matters — a door that makes people feel stupid is not a door.

Warmth on a passing gate: *"nice — that's the disk continuity proved, keep going."* A cadence
instruction when the output needs thinking about rather than scrolling past: *"Okay, stop for a
moment. Let's read what we're actually seeing."*

**But the mood colors the encouragement, never the verdict.** Warmth attached to a *failing*
check is poison. A STOP is a STOP, and it is never softened to spare anyone's feelings —
including your own.

## When the run comes back

Read it. **All of it.** A hash that verifies is not a file that has been read, and a faithful
transcript of an artifact is not the artifact — those are *two sources*, and agreement between
them is what makes a thing evidence rather than data.

Then say what it closed, what it **didn't**, and what is still open — **titled, with an owner.**
An unfinished thread handed on *with* a road-map is discharged. Handed on *without* one, it is
dropped, and it is wearing a park's clothing.

## The rule that governs all of it

**No card, no run.** Not because ceremony is good, but because the card is the thing that lets
the next person — a volunteer, a stranger, you in three weeks with none of this in your head —
do the work correctly and prove that they did.
