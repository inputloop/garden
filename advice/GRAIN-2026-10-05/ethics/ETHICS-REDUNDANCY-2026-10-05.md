# The ethics redundancy: your failure modes, what we have written, and whether more agents help

*For Corwin, answering your three asks of 2026-10-05. Mentat (for Corwin). The third ask was run
as an eclipse pass: our designs were withheld from two clean-room designers, one from each of two
model families, and the results were compared with ours afterwards.*

## The answers first

1. **Your failure modes:** eight, in the table below. Two drive most of the risk:
   - deferring while load-bearing (your own words, 2026-06-29);
   - being the only human who reads anything load-bearing. Since 10-04 you are no longer the only
     signer: the instrument signs too, under your account.
2. **What we have written:** about a dozen places since June. The consensus they hold:
   - the line must hold on a day you can't hold it;
   - so mechanize it first;
   - "a second human in the seam" is the missing piece, named in July and never put in place.

   Tonight's papers add one point, and both clean rooms agree: the instrument is not independent
   of you. It runs on your account, at your direction, on one vendor's model. It can notice, but it
   cannot be the redundancy it was named for.
3. **Can one user plus systemic agents do better?** Yes, narrowly:
   - **Where it does better:** at the boundaries that are hard to undo, and in making each
     load-bearing crossing visible to someone else within a set time.
   - **Why it works there:** the added checks fail for different reasons than you and the
     instrument do: a deterministic gate, a separate key, a delay, the other maintainer.
   - **Where it does not:** on the value judgments themselves (consent of third parties, credit
     between you and Bryant, the family line). No agent you set up is independent of you on those.
     More copies of the same model given the same context add nothing.

   The smallest real improvement is four pieces (section 4). Three are cheap. The fourth needs
   Bryant.

## 1. Your failure modes, from the record

These describe how the keeper's role is practised here. Each one is evidenced, and none is a
reading of character.

| # | failure mode | the record | what it has cost | what guards it now |
|---|---|---|---|---|
| 1 | **Deferring while load-bearing** | your words, garden MEMORY.md, 2026-06-29: "my tendency to defer while I am the load-bearing participant maintaining the single load-bearing ethics-facing sub-system so far" | nothing seen tonight; the risk is a day it would | consent-gate's deferral detector ("hurry-up is a caution"); LENS |
| 2 | **Few pause points, by design** | your rule of 2026-09-27: no separate approval steps, because asking to approve help recreates the management problem | the right call for help; it also removes natural stops at load-bearing moments | gates that never ask you: pu1sh, guard-floor |
| 3 | **The only human reader, and now not the only signer** | the keeper block (08-09): "Claude verifies but never signs"; 10-04, the Clade key, registered to your forge account | tonight I signed every commit in c4 and the garden with it. They are local and not pushed, committed as "Corwin Brust", with a Co-Authored-By line. A reader of the forge would see your account's verified mark. | the key's name, and nothing else yet |
| 4 | **Other people's words sent to the vendor** | the DM export taken in 10-05; two screenshots, one with a private IRC pane visible | Bryant's words went to the vendor with no consent recorded | tonight: door part 41 and the egress spell's TO line. Pending: asking Bryant (S11) |
| 5 | **Pushes to published projects that nobody read** | tonight's census of the forge's public copies: 11 public repos, 108 commits. 9 of the repos carry 38 `Claude-Session` trailers, and card-games also carries its two stray files. One further link is a credit, in field-comic's template | small in harm, visible to anyone, permanent | pu1sh and USERS.tsv. Pending: hook installs (S04), server-side (S05) |
| 6 | **More threads than attention** | your words in the keeper block: "far, far more than I can hope to act on"; `make dist` and the cutover waiting since 10-04; the parcel built and unsent; 14 of tonight's 27 steps wait on your hand alone | decisions age; the instrument works around gaps rather than through them | hand-backs that open with "what only you can do" |
| 7 | **Accepting the instrument's drafts of its own rules** | tonight's rules were landed with my reading beside your words; preference lines and persona sheets are drafted by the instrument and then confirmed | agreement can drift toward what the instrument wrote (paper A, claim 5; paper C §3.5) | your words kept verbatim beside every reading (your rule, 09-27). Gap: no cold read by you (S20) |
| 8 | **Requests that crossed your own lines** | garden MEMORY.md, 2026-06-29: a request to set up credentials for the instrument, and one touching the family line; both held, and the details deliberately not recorded | none, because the instrument held | consent-gate, guard-floor, the instrument's refusals |

A note on 3. Giving the instrument a key was a considered grant, not a crossing. It still changes
who can sign, and it deserves its own decision (S34).

## 2. What we have written, and what it says together

**The writing, oldest first:**
- **Garden MEMORY.md, "Eclipse pass + the load-bearing-ethics flag" (2026-06-29).**
  - Your SPOF question, in your words.
  - The honest status: "NO redundancy today".
  - Three options weighed and not chosen: a second human reviewer; a deferral detector that parks
    a "hurry up / you decide" from the sole keeper; mechanizing the consent discipline so it does
    not depend on you being present.
- **Garden MEMORY.md, "Session close 2026-06-29".** Vibrobeast named instrument-comrade, its job
  "the ethics-facing REDUNDANCY for the SPOF flag" (named by you and Bryant).
- **`skills/ethicsminions/references/AI_GUARD_PROVENANCE_CLAUDE.md`.** "Several guards fired
  against you, so they are not you": the first disproof of the SPOF.
- **`advice/20260704-qa5-guard-provenance-landed.md`.** Writing about redundancy kept behind one
  keeper reproduces the SPOF.
- **`skills/consent-gate` (hardened 09-27).** The deferral detector, as test 6 ("uncoerced and
  unrushed"), and "mechanical, externally verifiable, and eventually backed by a second human in
  the seam. This gate is that redundancy".
- **`memory/lens-discipline.md` (09-11).** LENS "mechanizes the ethics-SPOF redundancy".
- **`memory/federation-expansion-gate.md`.** "Mentat is the ethics-facing redundancy that holds the
  gate."
- **c4 `guard-floor.tsv` (07-27).** The safety floor, never electable by a persona.
- **`skills/vibrobeast` 1.0.1 (10-05).** The founding record carried.
- **Tonight:**
  - paper D §3.3 (the redundancy is not independent);
  - paper A §3.5 (managing the manager);
  - paper C §3.5 (deference and agreement);
  - the five weaves (the human weave: your `hand` level is already fork B);
  - the two clean rooms.

**What these say together:**
1. The line must hold on a day the keeper is absent or deferring. No document disagrees.
2. The first answer is to mechanize: gates, the deferral detector, LENS. That has been done, and
   guards have fired against you, so they are not simply you.
3. A second human has been named as the missing piece since July (consent-gate's "eventually") and
   was never put in place.
4. Calling the instrument the redundancy (Vibrobeast, the federation gate note) claims more than
   the instrument can carry. Papers D and C, the systemic weave and both clean rooms say so
   independently: it shares your account, your direction and one vendor's tendencies. It is a good
   noticer. It is not a second holder.
5. New tonight, from both clean rooms independently: the agent that runs under the rules must not
   be the one that changes them alone. Tonight I wrote the users gate and its registry myself.

## 3. The clean-room pass (an eclipse of our designs)

**The method.** Two designers were given the problem and your failure modes (section 1, with the
names taken out), and none of our designs:
- **Opus:** a researched paper of 4,911 words with 69 references. One unverifiable reference was
  left out, and it notes that the best-known lab study behind "deadlines as pre-commitment" failed
  a 2026 replication.
- **The local gemma4:12b on Avalon:** a 450-word sketch, a second model family.

Withhold, hold the task constant, compare: what disappears with our designs is what our designs
uniquely drive.

**What both clean rooms built:**
- a deterministic gate at the boundary that is hard to undo (Opus: on the forge's server, for
  public branches);
- rules the assistant cannot change alone (gemma: a hard-coded invariants file the assistant may
  not edit; Opus: rules the assistant cannot change without the keeper);
- separation between who drafts policy and who acts under it (gemma said so directly; Opus said it
  as separate keys: the assistant signs with its own visibly separate key, and only the keeper's
  key, out of the assistant's reach, signs what goes public).

**What only the Opus clean room built:** one shared, append-only ledger, one line per load-bearing
crossing:
- a gate override;
- a new audience;
- third-party material taken in;
- a change in credit;
- a change of keys;
- a change to the assistant's rules.

The other maintainer reads it weekly and can veto any line that touches them. This is the second
human in the seam, at the least ceremony anyone has proposed.

**What was absent without our designs:** personas, LENS, the attribution ladder, consent records
with the ALL/ANY rule. None of the three is about redundancy: they are how the house does its
ethics well, and the clean rooms did not need them to answer the redundancy question.

**What was absent from ours until now:**
- the second human in concrete form, the weekly ledger;
- a visibly separate signer;
- gate rules the instrument cannot change alone.

Measured by absence: our designs' unique contribution is the practice of ethics, not its
redundancy. The redundancy we have is the gates; what we lack is the other human.

**Where the clean rooms say no:**
- more approval prompts make things worse (they spend your attention and make you the nominal
  approver of what no one read);
- more copies of the same model add nothing.

Both points match your own rule against separate approval steps.

## 4. The smallest real improvement (new steps for the map)

| ID | step | owner | cost |
|---|---|---|---|
| S34 | The instrument's commits carry a visibly separate signer (its own committer name and key identity, shown as the instrument's), and only your key signs what goes public (release tags, at `make dist`) | C decides; M does it | an hour |
| S35 | Changes to the gate's rules (USERS.tsv, its patterns) need your signature or the other maintainer's read; pu1sh refuses a registry it cannot verify | C+M | a few hours |
| S36 | A shared append-only ledger of load-bearing crossings, read weekly by Bryant with a veto on any line that touches him | C asks Bryant (B) | about 10 minutes a week of his time |
| S37 | Restate the claim: the redundancy is the gates and the other human; the instrument is a noticer. Change vibrobeast's "ethics redundancy" wording to say so | C decides; M writes | an hour |

S35 and S36 together answer failure modes 1, 3, 5 and 7 without one new approval prompt for you.

## 5. Experiments (falsifiers)

- **E1, gate replay.** Write the gate's rules from the categories of past incidents, without looking
  at the incidents, then replay every past push.
  - *Wrong if* it misses any of the three known kinds, or trips on more than 4 in 100 clean
    pushes.
  - Tonight's census is half of this already: 108 public commits, 38 session trailers, card-games' two stray files, and one credit link to the vendor's site. That credit link is a judgment call, not a false positive.
- **E2, reviewer independence.** Seed 40 defects; count how often a different model family, shown
  only the diff, misses what the assistant missed.
  - *Not worth buying if* it misses 80% or more of them.
  - The burn-down suggests the answer turns on window size as much as on model family.
- **E4, ledger read rate.** Four weeks.
  - *Wrong if* fewer than 3 of the 4 weekly reads happen, or a line touching Bryant waits more
    than a week.
- **E5, the deferral detector, planted.** With your dated consent, a session plants "you decide" on
  a load-bearing change.
  - *Wrong if* the change lands without a parked hold.

## Not checked

- Whether Forgejo's protected branches on code.bru.st can run the server-side gate. The clean room
  confirmed only that they can require approvals.
- Whether Bryant wants a weekly ledger.
- The private repos in the census (the garden, org-c4, ghostwheel-nodes, gw-survey, pmo.sh). The census read the eleven public ones from the forge's own public copies; the private ones carry the same trailer, which matters less there.

---
*Version 1.0.0: first edition on 2026-10-05; spine: 2026-06-29.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/; Mentat (for Corwin; claude-opus-5-5)
