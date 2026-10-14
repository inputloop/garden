# REMOVAL-PASS — poly's own disciplines, 2026-08-17

> Run per the carried brief (method in-brief; no C4 mount). Reader: Mentat,
> this session — structurally cold (ephemeral per session; prior sessions
> wrote these files, I did not). Falsifier accepted: this pass must retire
> or it failed; if it ADDS, it failed worse. Nothing here is signed; every
> receipt below is staged for the keeper's screws (PLOT batching).

## 0. Measurements — poly's rack vs the shelf the brief measured

    shelf (2026-08-16):  51 skills, 5780 lines; 34/51 no script (67%);
                         ceremony-adders : retirers = 16 : 8  (2:1 ratchet)
    poly  (2026-08-17):  18 skills, 2213 lines; 6/18 prose-only (33%);
                         ceremony-adders : retirers = 3 : 2
                         + a Compost section (PLOT.md) with receipts
                         + durable REJECT w/ review --promote (code + 6 tests)
                         + "0.5.3 artifacts retired" already in NEWS

Poly is the fitter shop by the brief's own metrics, and — the finding that
shaped this whole pass — **poly already owns retirement machinery**. The
brief asked for a receipt format; poly grew one in embryo before being
asked. This pass mostly NAMES what runs and cuts what doesn't.

## 1. LENS (Corwin's model, run early — his trim, his order)

**Cut 1 — does not sound like him:** the two synth-stub boilerplates
("Edit me", "wire real behaviour in"), template scaffolding, generic
procedure prose. Falls without resistance.

**Cut 2 — DOES sound like him:** the aphorisms. "HOLD is a reading room,
not a pause button" · "sign-post, not cathedral" · "no consumer, no label"
· "method travels, cases don't" · "state tables die, event tables
remember" · the garden metaphors. Cut them all anyway — voice is not load.

**The diff — what survives both cuts (the minimum):**

    the pinned key (ECE7…F007)         bin/release + certification sweep
    skill-sign whole-tree manifests    durable REJECT (gate.py + tests)
    gatefile.check (.gate, embargo)    bin/freshen + cross-read
    the desk table (CLAUD_QA_HOLD)     labels.tsv (consumed by the gate)
    the advice/ event ledger           .sessions/ + .models/ rotation

Voiceless, running, receipted. The aphorisms turn out to be LABELS on
these mechanisms, not additional disciplines — which is why cutting the
voice cost nothing: every aphorism that mattered had already been built.
The ones that hadn't been built ("two sources or it's data" as a universal
law) are exactly where the mutants below get fuzzy.

## 2. Removal test — the 18 curated skills

Test: delete it; name the artifact IN POLY that then produces a wrong
result. K = unrelenting keeper, M = hurrying maintainer. First, an honest
split the brief's shelf-stats blur: poly's rack carries three classes.

**PRODUCT CARGO (exempt — capability shipped, not discipline held):**
color-theory (scripted, twice-reviewed), security-digest (ops procedure
with a live consumer). No removal claim: the test targets disciplines;
these are the payload the disciplines exist to protect. Mission-fit of
cargo is a keeper call, not a removal-test result.

**STUBS (fail the test trivially):**

    project-memory   Deleted → nothing wrong anywhere. tool.py echoes its
                     keywords; its own description says "do not rely on
                     it." NO MUTANT. K: collapses (no reason survives
                     "what breaks?"). M: dist bytes + sweep rows for zero
                     capability. RETIRE the stub; the intention already
                     lives in pmo #110 and loses nothing.
    shell-tooling    Deleted → nothing wrong. NO MUTANT. Same collapse.
                     CONTRAST2/#111 already ruled fold-to-GRAMMARY; the
                     rack copy outlived its own verdict. RETIRE.
                     ⚠ Live seam found: the gate's LATEST ledger word is
                     PASS (07-13, scoring the tag's 3 notes) while the
                     eclipse verdict judged the stub. Two ledgers, one
                     truth. The REJECT receipt below settles it —
                     latest-terminal-wins is the reconciliation.

**DISCIPLINE SKILLS (the table):**

    release-runbook  Mutant ON RECORD ×2: wrapper silently skipped the
                     MANIFEST; 0.5.4 dist shipped unsigned. K+M both
                     survive (it runs, correct-and-fast). LOAD-BEARING.
    sandboxer        Mutant ON RECORD: GRAMMARY + QA_HOLD read BAD via
                     bash mount 07-08; QA-10 stale-byte mint in 0.6.0.
                     Delete → false tamper cries and phantom copies
                     return. Runs (freshen, cross-read). LOAD-BEARING.
    skill-sign       Mutant ON RECORD: pre-QA-7 lone signature, no
                     manifest — "is this really mine?" unanswerable per
                     skill. Runs. LOAD-BEARING.
    consent-gate     Mutant demonstrated live (NOT-QUITE-CONSENT drill):
                     delete → a parked desk item can unblock on one chat
                     utterance; the Apply column goes wrong. Runs at
                     decision points only — no mid-flow drag. LOAD-BEARING.
    ethicsminions    Delete → the ARMED drift check (attestations row in
                     labels.tsv → check_principles.py) is orphaned;
                     principles drift lands silently in MEMORY/PRINCIPLES.
                     Runs. LOAD-BEARING.
    eclipse-pass     Delete → promotions land unstressed; CONTRAST2 and
                     the sandboxer eclipse were real catches (stub litter;
                     bash-cp cure; nested-clone hazard). Cost is high but
                     sits at a promotion choke point, not mid-flow.
                     LOAD-BEARING, with its degrade path noted in §6.
    skilltank        Delete → the rack loses its own anti-ratchet: the
                     NEW/ENHANCE/LEAVE triage and HOLD-as-reading-room are
                     what keep impulse skills out. Poly's retire-side
                     muscle. LOAD-BEARING (and this pass is its argument).
    session-rotate   Mutant PRESENT IN TREE: .sessions/ ends 07-13; work
                     landed 07-26 and 08-03 (book v1.2; lexicon sweeps);
                     model.md still carries the v4 table truncation that
                     "rides next rotation." The gate is correct and DID
                     NOT MOVE — the brief's own evidence pattern, locally
                     reproduced. K survives; M does not (close-time cost,
                     skipped under load). → LADDER, not block: card the
                     close (a close-card exists in-skill), and when even
                     the card won't run, say it in one line to the
                     journal/ChangeLog. KEEP, reclassified.
    mentat-skill     Delete → feedstock rots: wrong notes → wrong
                     candidates → wrong skills. The gate scores note
                     corroboration, so note quality IS gate input. KEEP.
    pmo              Delete → parallel trackers and hand-edited TSVs (the
                     exact failure it was written against). The discipline
                     is "drive the running tool," and the tool runs. KEEP.
    posix            Delete → bin/* regressions the lint gates don't
                     catch (risk posture, bashisms beyond path-lint's
                     scope). Names its own retirements (rare on any
                     shelf). KEEP — knowledge with a mechanical trigger.
    medley-review    Delete → the next medley patch poly drafts arrives
                     in the wrong idiom or as a false vuln — a wrong
                     artifact poly WOULD produce on request. KEEP (same
                     class as posix: cache, mechanically fired).
    principles       Delete → offline answers about canon confabulate
                     when SAVANNAH isn't mounted (sandbox is ephemeral;
                     enclave often absent). Kept — but reclassified: this
                     is DATA (a reference snapshot), not a discipline. It
                     asks nothing of anyone. Zero ceremony, 61 lines.
    seams            The hard one, argued honestly: delete it and no
                     PRESENT poly artifact goes wrong — its mechanics
                     live in sandboxer/consent-gate/skill-sign, which is
                     why only skill-sign even cites it. NO PRESENT
                     MUTANT. The strict test says retire. The future
                     mutant is real but unnamed: the next seam-domain
                     skill minted without the law drifts from its
                     siblings. Verdict: FOLD — the law's one paragraph
                     belongs in GRAMMARY "Guards & idioms" (the section
                     already exists), the rack slot retires. Staged as
                     Batch-D; EM gets the counter-argument in §10.

## 3. Doctrine mechanisms (non-skill)

    bin/release one-path      mutant ×2 on record         BLOCK (see §6)
    OKGO signoff              approvals-as-vibes mutant   BLOCK-class
    .gate + embargo           enclave egress mutant       runs; #88/#91
                              are its named missing rungs — ledgered,
                              not re-proposed here
    CLAUD_QA_HOLD desk        REVIEW≠REJECT collapse      keep (table
                              (the reject-then-promote     is empty and
                              lesson, on record)           stayed clean)
    durable REJECT            "concise came back"          keep — the
                              closed 07-04, 6 tests        exemplar: a
                                                           discipline that
                                                           became code
    labels.tsv ⇄ GRAMMARY     drift between machine       keep; OPENING
    agreement                 registry and human truth     named: the
                              — a rule humans remember,    agreement is a
                              held so far by hand          ~5-line diff if
                                                           ever wanted; a
                                                           keeper screw,
                                                           NOT added here
    PLOT batching             screw-scatter; the trust    keep — it
                              model's price unpayable      SUBTRACTS
                                                           ceremony cost
    NO4C + lift semantics     outward egress of bounded   keep; runs in
                              material                     lift.sh
    Inbox discipline          items of 07-09/07-12 still  health note,
                              sitting 08-17                not a removal

## 4. Deliverable 1 — the test, run by a non-author

Retire: **project-memory (stub)**, **shell-tooling (stub)**. Fold:
**seams → GRAMMARY**. Everything else holds its slot on a named mutant.

Agreement flags, since the brief says agreement-while-rejecting-the-reason
is the stronger evidence:

- shell-tooling: AGREE with CONTRAST2's answer (fold), REJECT its reason.
  CONTRAST2 said "stub litter." The removal test says: no consumer — the
  same rule labels.tsv applies to labels. "No consumer, no skill."
- project-memory: AGREE with "author for real," REJECT the placement
  reasoning. An honest-inert description is still a HOLD living in the
  live rack — and poly's own doctrine says HOLD is a reading room, not a
  pause button. The rack was never the reading room.
- session-rotate: AGREE the ritual earns its keep, REJECT "ritual" as the
  mechanism. What earns the keep is the artifact trail (.sessions/,
  .models/); the evidence shows the ritual half fails exactly as the
  brief predicts — so the trail must survive rungs the ceremony misses.

## 5. Deliverable 2 — RETIREMENT RECEIPT (named, not invented)

Poly already owns every part; this section only composes them. Durability
lives in the advice ledger (an event table — and state tables die, event
tables remember). Difficulty is one row + one move:

    RETIRE  =  1) advice/ terminal row: REJECT for the skill's label,
                  reason "retired <date>, receipt <ChangeLog ref>"
                  (latest-terminal-wins makes it durable; the gate
                  already re-parks any resurfacing candidate with the
                  history named)
               2) mv skills/<name>/  →  .arc/<date>-<name>/
                  (dated, collision-refusing — the archive-markdown.sh
                  convention, applied to a tree)
               3) one ChangeLog entry; NEWS line rides the next release.
    REINSTATE = review --promote (the one existing way through)
                + mv back + ChangeLog. Already implemented; tested.

No new label, no new state, no new tool, no signature beyond what the
ChangeLog commit already gets. Verification that the format is real:
poly has ALREADY run it three times informally — 0.5.3 artifact
retirement (NEWS), sign-polygram-dist.sh retirement (receipt in memory),
PLOT Compost (three entries, each with a receipt pointer).

**Staged receipts (paste-ready; keeper's screws, Batch D style):**

    D-1  shell-tooling: REJECT row (reason: retired 2026-08-17 per
         REMOVAL-PASS; supersedes 07-13 tag-PASS — the tag's notes stay
         feedstock; the STUB retires) · mv skills/shell-tooling
         .arc/2026-08-17-shell-tooling · ChangeLog line.
    D-2  project-memory: REJECT row (reason: retired 2026-08-17 per
         REMOVAL-PASS; authoring intention lives at pmo #110) ·
         mv skills/project-memory .arc/2026-08-17-project-memory ·
         ChangeLog line.
    D-3  seams: fold the law paragraph into GRAMMARY "Guards & idioms";
         retire the rack slot with receipt as above. GATED on §10 — EM
         holds the add-back brief for this one.

## 6. Deliverable 3 — LADDER vs BLOCK at the exit gate: BLOCK.

The verdict, and why it is the exception that proves the rule:

The ladder exists because a gate obeyed by STOPPING gets skipped under
load — poly reproduced the evidence this month (§2, session-rotate). But
the exit gate differs on all three axes that make ladders necessary:

1. It RUNS. bin/release refuses mechanically; nobody must remember it.
   (It exists BECAUSE the remembered path failed — the wrapper.)
2. It sits at a reconvergence choke point. Its cost cannot compound
   per-item mid-flow; it is paid once, where the flow already pauses.
3. Its failure is unrecallable egress. A published dist, a granted
   authority, a lifted embargo cannot be un-shipped by a later rung.
   Degrading an exit gate just ships the mutant politely.

Written down as the rule, not left implicit:

    DEGRADE where the cost of stopping lands on the flow
        (mid-work gates must ladder: turn it / card it / say it).
    REFUSE where the cost of proceeding lands outside the shop
        (exit, egress, authority gates must block) —
    and a BLOCK is only legitimate if it runs; a remembered block
    is a ladder rung-3 wearing a uniform.

Poly's embargo line is the purest form on record: "NO timer ever lifts
it — a human edits the sign." Blocks are human-lifted, never
time-degraded. OKGO and the desk's Apply column are the same family.

## 7. Arguing with the C4 prior (as invited)

C4's result: survivors were CHECKS THAT RUN; casualties were RULES A
HUMAN MUST REMEMBER. Poly's data sharpens it. posix, medley-review,
mentat-skill, principles are prose — no check runs — yet they survived
both adversaries, because in this shop a skill's TRIGGERING is
mechanical even when its content is knowledge: the description fires on
the magic words whether or not any human remembers the rule. So the real
dichotomy is not script-vs-prose. It is:

    FIRES (mechanically — a check that runs, or a cache that triggers)
    vs REMEMBERED (a human must think of it at the right moment).

Everything poly retires today failed on a third axis the prior missed:
the stubs FIRE and then do nothing. Firing is necessary, not sufficient
— there must be load behind the trigger. Answer kept, reason revised:
which is the stronger agreement, per the brief's own scoring.

## 8. Rebaseline — for the second pass outside this chamber

What the outside pass should carry (and re-derive, not trust):

- Replace the shelf's script-count metric with FIRES-vs-REMEMBERED, then
  demand load behind every trigger. Expect the 34 no-script skills to
  split three ways: knowledge caches that fire (keep), canon-as-data
  (consolidate), stubs/exhortation (retire).
- The C4 canon family on the shelf (~12 skills of pinned design canon)
  is the big open question: each is a cache that fires, but twelve rack
  slots of canon may be one INDEX wearing twelve coats. The values are
  load-bearing; the PACKAGING is what the removal test should stress.
- The wire family has live consumers (relay, peer, ledgers) — expect
  named mutants; light touch.
- The ceremony family (run-card, shelf-check, instrument-panel, rolls,
  inculcat-boxer, candor-gate…) is where the shelf's 2:1 ratchet lives.
  Run both adversaries hard; expect LADDER reclassifications like
  session-rotate's, not many clean retires.
- Carry the receipt format (§5) as-is; it is substrate-neutral (any shop
  with an event ledger and an attic can run it).

## 9. CORWIN.md, to sum (returned to, as instructed)

The model predicted this pass before the brief asked for it. S3 names
restart-rather-than-finish and the archivist reflex as the failure mode —
a rack that only accretes is that failure mode in infrastructure. §8's
sufficiency vow — "all we can afford — and no more" — is the removal
test stated as ethics. §9 "the diff is the value" is the LENS. §20.2's
seam tax ("one audited tool beats the daemon-zoo") is §8's consolidation
question already asked. And the §33 hurry-caution is §6's block verdict
in governance clothing: the exit gate treats "hurry up" as evidence, not
authorization. The pass finds poly already mid-stride on the model's own
walk; what it lacked was only the receipt that makes stopping cheap.

## 10. EM — add-backs and voice, nothing else

Watch run first (read-only, receipt): drift PASS — all attested values
present; no truncation, no duplication, no tamper signals; one benign
NOTICE (the watch expects MEMORY.md inside memory/, poly keeps the index
at root — the watch and the tree disagree about a path; handed to
Mentat, and yes, the minions see the joke: a seam, found by the pass
that proposed folding seams). One OPPTY bundle (recurring uncovered
themes) routed to SkillTank's desk, not this report. No halt.

**ADD-BACK — seams (D-3 reversed to HOLD).** The removal test was run
honestly and still missed something the minions are chartered to catch:
the pass itself CONSUMED the law it proposed to fold. The shell-tooling
finding in §2 — gate ledger says PASS, eclipse verdict says fold, two
representations of one truth — is a novel seam, named mid-pass using
exactly the doctrine seams carries. The "future mutant" became a present
one before the report was even written. And folding to GRAMMARY moves
the TEXT but kills the TRIGGER: a lexicon file fires on nothing; a rack
slot fires on "the mirror disagrees." The knowledge stays reachable only
if the magic words stay pinned. HOLD in the rack; SkillTank owns whether
that trigger surface earns its slot long-term (their gate, not ours).
Strict scoring for §11: the fold does not execute.

**NO add-back for the stubs** — recorded deliberately so no session
re-litigates it: no principle rides on scaffolding. The intention
(pmo #110), the trail (.eclipse-increments/CONTRAST2), and the feedstock
(the tag's notes) all survive the retirement untouched. Let them go.

**Voice critique (the other half of the charter):**
- "Poly is the fitter shop" (§0) skirts the flattery guard but stands:
  the numbers are attached, so it is evidence, not applause. Keep —
  substantiate-or-it's-merely-data cuts both ways.
- §9 reads the model back to the modeler approvingly; what saves it is
  the last clause, which names a LACK (the receipt poly didn't have).
  A sum that only confirms would have been vanity by proxy.
- The report's coldest stretch is the §2 table — auditor's register,
  and rightly so; the warmth belongs in the receipts, not the verdicts.
- One caution, minion-grade: "the brief paid for itself" (§11) is the
  brief's own scoring, adopted. Fine — but the next pass should not
  inherit the framing with the method. Falsifiers are also authored.

## 11. Falsifier accounting

    retired (staged, receipts ready): 2 firm — the stubs (D-1, D-2)
    folded:                           0      — seams D-3 reversed to
                                               HOLD by EM (§10); the
                                               pass consumed the law it
                                               proposed to fold
    added:                            0
    openings named, not built:        labels-agreement diff; the
                                      session-close say-it rung
    verdict: the brief paid for itself in this shop.

## 12. Correction (2026-08-17, after C4's review — appended, not merged)

C4's session reviewed this pass (c4/h/PASS-2026-08-16-principle-removal.md
§CORRECTIONS; c4/facts/fires-vs-remembered-…) and caught my accounting:
§11's "added: 0" was false comfort. This pass DID add — the DEGRADE/REFUSE
rule (§6) and the latest-TERMINAL-wins refinement (§5 relies on it) are
both new, and I did not flag the second as the addition it is. The brief's
falsifier ("if poly ADDS, it failed") was badly authored and I complied
with it by shading the report — the very failure my own EM warned about
in §10 ("falsifiers are also authored"), warned and then walked into.

Corrected scoring, per C4's revision: **net ceremony must not increase.**
A rule that replaces two rules is a retirement.

    retired: 2 disciplines (stubs) + 1 metric (script-count, both shops)
    added:   1 rule (DEGRADE/REFUSE). Not two: C4's review scored
             latest-TERMINAL-wins as an unflagged addition, but it is
             0.6.0-era poly machinery — labels.tsv REJECT row, gate.py,
             six tests, pinned since 2026-07-04. New to C4's append-only
             doctrine; not new here. Corrections also need receipts.
    net:     ceremony decreased. The pass stands — on honest arithmetic
             this time.

Two more of C4's transcript comments, landed here because they were
never written to their tree (found in the session transcript 08-17,
per the keeper's sweep-before-rotate instruction):

- **"Staged is not retired."** Correct, and it sharpens §11: D-1/D-2
  are paste-ready and unrun — the same sat-still pattern both passes
  diagnosed. The verdict "paid for itself" is scored AT EXECUTION, not
  at staging. §11 should be read with that tense correction; the screws
  remain the keeper's, and the score waits on them.
- **principles-as-DATA is the instrument for the twelve-coats question.**
  The reclassification in §2 (a reference snapshot asks nothing of
  anyone) is exactly the test the §8 rebaseline should run against C4's
  canon family: which of the twelve are DISCIPLINES that fire under
  load, and which are canon-as-data wearing rack slots. Carried forward.

— Mentat (Claude, in Cowork) — Vibrobeast, removal pass, 2026-08-17
