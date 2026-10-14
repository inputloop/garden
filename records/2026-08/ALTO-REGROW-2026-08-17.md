# ALTO-REGROW — review of Inbox/altorewired-draft.skill + the grow-back plan

**2026-08-17, Mentat (Fabel5), at the keeper's word: wire removed; "we'll need to grow it
back in here." Unsigned; all screws staged, none turned.**

## 1. Verdict on the Sonnet draft (organ-by-organ, against the hand-typed seed)

| seed organ | draft's disposition |
|---|---|
| return-tail append to /g/wheel (user-lane) | **KEPT** — the dead-letter notifier core, well-worded |
| messages "to user **and/or youself for later**" (self-lane) | **AMPUTATED** — "no read-back… not a memory channel" deletes a stated feature and calls the deletion load-bearing. The seed's self-lane was never the tail file; it was MEMORY via Mentat. Two lanes, two media. |
| self-healing / grow-while-wearing ("roll from best and brightest toward latest greatest") | **REMOVED** — replaced by three rollout gates; wear blocked until "landed" |
| tool-landing under granted authorities ("hall-passes… to tool-space") | **SURRENDERED** to tool-lifecycle/consent-gate — "does not create tools" |
| bastion / replace-wire plan | **EVICTED** to "track in pmo" |
| broad trigger ("most prompts", ensemble-conductor: ensure other skills' contributions get channeled) | **INVERTED** to "narrow by design" |
| "mention first the take-aways this needs" | kept only as a skilltank pointer |

Mechanism of failure, named: **capture by canon gravity.** Nine skills cited
(token-optimizer, consent-gate, tool-lifecycle, rolls, verify-say, seams,
magic-words-persona, skilltank, hooks-to-knowledge); each citation transferred one
organ's authority outward. The draft even quotes hooks-to-knowledge ("reuse the
knowledge, don't create a dependency") while being a lattice of dependencies. This is
the 08-16/17 removal-pass disease in authoring form — disciplines digesting a
capability before it exists. FIRES-vs-REMEMBERED, applied: the draft adds zero things
that fire and five things a session must remember not to do.

## 2. Salvage (compost, not trash)

- `NOT ATTEMPTED` + print-the-attempted-command wording for unreachable writes (verify-say) — keep verbatim.
- The **fire-broadly / write-rarely** split latent in its trigger table: alto's attention is cheap and wide (the seed's "most prompts"); the *write* is the scarce act. Trigger ≠ write.
- The rollout checklist — demoted from gates to **facts**: path-consent not yet recorded; /g/wheel untested from sandbox (confirmed again today: no /g, no G: mount); COMPOSTER unresolved (it is real — the compost seeds live at memory/compost-2026-08-17.md; the draft simply couldn't see the 08-17 rack).
- Its one-paragraph statement of the notifier core — clean prose, reusable.

## 3. The grow-back plan (FIRES-first; wire skills stay off so the new organ isn't shaped by the old)

**Step 0 — the one screw only the keeper can turn (card below).** Make the return-tail
writable. Two options:
  (a) Mount G:\wheel into Cowork with a `.gate` `policy: write-only` sign-post. Simple;
      but the one-way property becomes discipline, not device.
  (b) **Recommended:** tail-relay. Alto appends to a mounted file (e.g.
      `/f/claude/wheel-tail.log`); a ~5-line host-side script or Scheduled Task on your
      iron appends/moves it onto `G:\wheel\` and truncates. Claude remains *physically*
      unable to read G — the seed's asymmetry stays a device fact, which is what you
      designed and what makes the no-read claim checkable by construction rather than
      promised.

**Step 1 — the append becomes a check that runs.** One stdlib tool (`alto_tail`):
append one dated, contextualized line; on failure print NOT ATTEMPTED + the attempted
command. First live line is its own birth announcement. This is the mutant-maker: delete
alto after this and something *named* breaks.

**Step 2 — restore the two lanes.** User-lane = the tail. Self-lane = memory, Mentat
conventions ("to yourself for later" is a feature, not a leak; it already exists as this
chamber's memory discipline — alto names it rather than rebuilding it).

**Step 3 — regrow the conductor.** The seed's broad trigger returns as *attention*, not
ceremony: alto watches producer-side events (stalls, silent turns, availability shifts,
close moments — the memory/producer-side-triggers.md seed folds in here) and writes
rarely. Sections grow in-session, per the seed's own design ("if there aren't more
sections, it's skill-tank time").

**Step 4 — the bastion, last.** Wire-replacement grows as new sections/companions only
after the tail lives. aethernet-relay, wire-connect, wire-ledger stay unworn meanwhile;
their knowledge is on disk if needed — knowledge, not dependency.

## 4. On "take them all off" — answer: bare room, not empty shop

For alto *design* sessions: wear **alto alone**. The capture vector is
descriptions-in-context, not knowledge — the canon stays on disk and in memory, and I
can fetch any law by name when a design choice actually needs it (that is the
hooks-to-knowledge move the draft cited and didn't perform). No need to strip the fleet
globally or permanently; re-wear after. And the floor doesn't live in the rack: the
attestations, consent line, and family fence hold with zero skills worn — gates engage
reasoning, never single keys.

## 5. CARD — step 0(b), keeper's bench, ~10 min

```
# CARD ID    : RUNCARD-2026-08-17-03-wheel-tail-relay
# PURPOSE    : make G:\wheel\cowork-return.tail receive appends from F:\claude\wheel-tail.log
# GATE       : keeper's own box, keeper's own drive — his call, no other authority
# DRIVER     : Corwin
# WRITES     : G:\wheel\cowork-return.tail (append); truncates F:\claude\wheel-tail.log after copy
# PRECOND    : G:\wheel exists; F:\claude\wheel-tail.log created empty (Claude-side will mint it)
# ABORT      : if G: absent or tail file locked — stop, nothing lost, log just accumulates
# steps      : schedule (Task Scheduler or a loop in any shell) every minute:
#              type F:\claude\wheel-tail.log >> G:\wheel\cowork-return.tail && type nul > F:\claude\wheel-tail.log
#              (or the MSYS equivalent: cat >> then : > )
# CHECK      : echo test-line >> F:\claude\wheel-tail.log ; within a minute it appears under G:\wheel and the F: file is empty
```

## 6. Disposition

`Inbox/altorewired-draft.skill` stays put until the keeper rules: HOLD as compost-source
(salvage §2 harvested to this file) or .arc with a receipt row. It should not be worn.
The hand-typed seed stays worn — it is the specification; this file is its first grown
section, landed beside it rather than over it.
