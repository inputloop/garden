# The resulting plan (from the Two Gardens Map, 2026-10-05)

Owners: C Corwin; M the instrument, once he says go; B Bryant.

## Done tonight
- D1: pu1sh fails closed, vendor-neutral, PATH, changed files, scope line (c4 4af7de1)
- D2: public-stage step 1: no session trailer (garden 8743b5d)
- D3: card-games declared users; Emacs on Savannah hand (c4 8b83e6e)
- D4: his rules of 10-05 landed: memory, garden note, door parts 37 and 39, egress 3a, persona-engine, mentat-skill
- D5: the vendor is a destination: door part 41, egress TO
- S28: the census of the public forge: 11 repos, 108 commits
- D6: card-games session: the 10-05 patch applied and pushed (74af63a); a commit-msg hook pushed (ee02437); both clean of session links

## Phase 1 card-games, one sitting
- [ ] S01 (C): Turn off the app's session link (attribution.sessionUrl: false, and your chosen commit line) in each Claude app you use
- [ ] S03 (C): card-game.el: move the 10-05 patch from `Claude outputs/` to the project's `patches/2026-10-05/`, add `Claude outputs/` to `.git/info/exclude`, apply with git am
- [ ] S04 (C): Install pu1sh's pre-push hook in card-game.el (before the cleanup push)
- [ ] S02 (C): card-game.el: one forward commit removing BE16.png and the shell log; no rewrite; release 1.0.92
- [ ] S06 (C): card-games headers in MELPA's own form (;; Assisted-by: Claude:MODEL under the Author line). Decided: we follow MELPA.
- [ ] S42 (C (a patch), or M on your word): card-games' new commit-msg hook refuses MELPA's own form (Assisted-by: Claude:MODEL), and its tests call that form wrong: accept both forms, and refuse session trailers from any vendor

## Phase 2 rules and identity
- [ ] S34 (C decides, M does): The instrument's commits carry a visibly separate signer; only your key signs what goes public (tags at make dist)
- [ ] S35 (C+M): Changes to the gate's rules (USERS.tsv, patterns) need your signature or the other maintainer's read; pu1sh refuses a registry it cannot verify
- [ ] S40 (M): The hand level lets its keeper push after the full check (it now stops your own hooked pushes too)
- [ ] S30 (M): Ask once: the first push to a repo with a release tag or package recipe but no USERS.tsv row asks you and records the answer
- [ ] S18 (M): The gate's patterns as a data file beside USERS.tsv
- [ ] S19 (M): At the users level, the full secrets catalogue (c4 secrets-run or gitleaks); NOT CHECKED when absent
- [ ] S37 (C decides, M writes): Restate the claim: the redundancy is the gates and the other human; the instrument is a noticer (vibrobeast wording)
- [ ] S10 (C+M): The vendor as a destination: done in the door (part 41) and the egress spell; still to write: the plan, terms and training setting you use
- [ ] S22 (M): door render, so every model.md carries parts 37, 39 and 41
- [ ] S41 (M): kid-glove learns the user's downstream conventions: honor users' expectations and the conventions of places the house has chosen to join (MELPA, GNU ELPA), should it please the user to comply ('BOY leather'). Blessed 10-05; coordinate with the card-games session
- [ ] S43 (M): pu1sh: per-repo allowed paths in USERS.tsv (card-games' hook tests carry session links as fixtures, which would stop a hooked push)

## Phase 3 Bryant, one message
- [ ] S24 (C): The Bryant parcel: send it (with or without tonight's users rule and pu1sh); whether to say the joint terms line
- [ ] S11 (C, B): Ask Bryant whether his DMs may be processed by the vendor; record his answer
- [ ] S36 (C, B): Ask Bryant to read a weekly ledger of load-bearing crossings, with a veto where a line touches him
- [ ] S16 (B): token-optimizer: its Evidence section against its repository, or the replication it names (Bryant's skill)

## Phase 4 licence and the garden
- [ ] S38 (C): TERMS v2: adopt the draft (the three-licence form), re-sign CORWIN.md, re-carry
- [ ] S07 (C+M): One SPDX expression per file across the garden, in the new form, minted from FOOTERS.org; reuse lint in egress
- [ ] S26 (C): Retire the SOFT-SKILLS/build-loop leftover
- [ ] S23 (C+M): One garden reinvention pass, staged: the story out of what ships, SPDX footers, vendor-link scrub
- [ ] S27 (C): The cutover and make dist (re-seals the skills changed today)

## Phase 5 science and standing checks
- [ ] S21 (M): A second model family (the local gemma) on load-bearing claims, two windows
- [ ] S29 (M): A second reader for pu1sh, from a fresh spec in another language, tested on slips someone else wrote
- [ ] S17 (M): Heal prompts carry the failing check, a reproduction and the covering plant
- [ ] S20 (C+M): Your cold read: once a week, one random line of the preference record or a persona sheet
- [ ] S32 (M): Count each gate's real firings for a quarter; retire what never fires (your lift test)

## Held (each waits on what its line names)
- S05: A server-side pre-receive on code.bru.st for repos with users
- S08: Stop privacy and provenance findings at more levels. The census: 108 public commits, 38 session trailers, nothing else but card-games' files. Cheap; your rule
- S09: For a repo with users: the gate alone (A), or the gate plus a human who reads and pushes (B). Your hand level already is B
- S14: Experiment E1: gate against memory against both
- S15: Light-shelf experiments, fixed first (random assignment; abstention; baselines)
- S25: The light shelf: the four prongs, 17, beside or instead of memory
- S31: An agreement probe: a contrary claim planted in your name (with dated consent)
- S33: Test the human read with planted faults (with dated consent)
- S39: field-comic's template credits Claude with a link to the vendor's site: keep it (a credit) or drop it

## Dropped or settled
- S12: Scope copyright lines to human contribution. Decided: keep your copyright and licences (your posture of 10-05); Assisted-by stays
- S13: Restate the ethics redundancy: superseded by S34 to S37

---
*Version 1.0.1: edition revised from 1.0.0 on 2026-10-05; spine: 2026-10-05.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/; Mentat (for Corwin; claude-opus-5-5)
