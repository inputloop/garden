# HANDBACK 2026-10-05 (night): card games, your new rules, the users gate, the GRAIN lens, the map

*For Corwin. Mentat (for Corwin). This follows the evening hand-back. The full work is in
`advice/GRAIN-2026-10-05/`, starting at its README.*

## What only you can do (the plan's first moves)

1. **card-games, one sitting** (phase 1 of the plan):
   - **S01:** turn off the app's session link (`attribution.sessionUrl: false`) in each Claude app
     you use. Whether the desktop app honours it is not checked.
   - **S03:** move the 10-05 patch from `card-game.el/Claude outputs/` into
     `card-game/patches/2026-10-05/`, and add `Claude outputs/` to `.git/info/exclude`. Then
     `git am` it. The patch is good: it applies to a fresh clone of upstream, the suite is green on
     Emacs 29.3 (166 run, 0 unexpected), and its new test fails without the fix.
   - **S04:** `sh /f/claude/c4/bin/pu1sh hook > .git/hooks/pre-push`.
   - **S42:** let the new commit-msg hook accept MELPA's own `Assisted-by: AGENT:MODEL` form.
   - **S02 and S06:** one forward commit that removes `BE16.png` (a saved block page) and the
     setup shell log, plus MELPA's own `;; Assisted-by:` header form, as you decided. Then 1.0.92.
2. **Decide S34:** should the instrument's commits carry a visibly separate signer? Tonight every
   commit was signed with the Clade key, and a forge reader would see your account's verified mark.
   Nothing was pushed.
3. **One message to Bryant** (phase 3):
   - send the parcel (S24);
   - ask whether his DMs may go to the vendor (S11);
   - ask whether he will read a weekly ledger of load-bearing crossings, with a veto on lines that
     touch him (S36);
   - point out the token-optimizer evidence gap (S16).
4. **Sign TERMS v2** (S38): `c4 man/TERMS-v2-DRAFT-2026-10-05.md` carries the three-licence form
   and your copyright posture in your words. TERMS lives in CORWIN.md, which you sign, so I drafted
   rather than edited.
5. **Open the map,** `two-gardens-map.html`. Its plan tab holds 39 steps with the five weaves'
   votes. The recommended plan is in `PLAN.md`; change any choice and the plan rewrites itself.
   Held for you: S05, S08, S09, S14, S15, S25, S31, S33, S39.

## Catching up with the card-games session (later the same night)

**What it did:** it applied the 10-05 patch (74af63a), added a commit-msg and applypatch-msg hook
with ERT tests (ee02437), and pushed both to the public repository. Both commits are free of
session links, and the hook's tests pass (2 of 2).

**What I found, now S42 and S43 on the map:**
- **The hook refuses MELPA's own form.** It turns away `Assisted-by: Claude:claude-opus-5-5`, the
  form MELPA asks for and you chose tonight to follow, and its tests call that form wrong. It
  should accept both forms, and refuse session trailers from any vendor, not only one (S42).
- **Its tests would stop a hooked push.** They carry session links as fixtures, so with the users
  gate installed, a push touching them would stop. That calls for a per-repository allow list
  (S43).
- **Still in the tree:**
  - `BE16.png` and the shell log (S02);
  - `Claude outputs/`, untracked and not excluded (S03's last part).

**Your blessing:** new behaviors go to kid-glove. Honoring users' expectations, and by extension
the conventions downstream of the user when the user is pleased to comply, is the "BOY leather".
That is S41, and it is in memory in your words. kid-glove is a literate project the other session
may also touch, so I have not edited it. Whichever session takes S41 should say so first.

**For Bryant, while he is on the phone:** the six questions sent in chat:
1. consent for the vendor (S11);
2. the weekly ledger (S36);
3. the licence form (S38);
4. token-optimizer's replication (S16);
5. his side of the shared ideas;
6. the parcel.

## Where we are in sync, and where not

**In sync (landed, and checked where marked):**
- **Your rules of 10-05, in your words with a labelled reading:**
  - project memory;
  - the garden note `memory/work-and-story-2026-10-05.md`;
  - door parts 37 (work and story), 39 (users gate) and 41 (the vendor is a destination);
  - the egress spell (check 3a, and the vendor as a TO);
  - persona-engine 0.3 (curation, the authorial voice);
  - mentat-skill (the work and the story).

  Every rendered `model.md` reads STALE until `door render` (S22).
- **The users gate, `c4 bin/pu1sh`:**
  - levels in `d/users/USERS.tsv`: card-game.el is `users`, Emacs on Savannah is `hand`;
  - its self-test has 36 checks and passes under 20 shell and awk pairs;
  - it now fails closed, after paper B broke the first version three ways;
  - replayed on the real card-games history, it flags exactly the three faults.
- **`public-stage`** no longer asks for the session trailer.
- **The LENS skill and mentat-skill** no longer ask for the concern tags you retired on 09-24.
- **Your answers of tonight, in memory:**
  - the licence form;
  - MELPA's conventions;
  - the vendor as a destination;
  - your copyright posture, as you corrected it, with its falsifier;
  - the Clade key's name;
  - the API key that cannot be found. No record holds it: notes refer only to `$FORGEJO_TOKEN`, a
    variable set for one run, and say the token never went into a log.

**Not in sync:**
- `make dist` and the cutover. Skills changed today need re-sealing: persona-engine, mentat-skill,
  lens, public-stage, and the five from the evening.
- The parcel is built and unsent.
- The 38 session trailers in public histories are left as history, by paper B's advice.
- The private repositories were not in the census.

## Confidence, and where it comes from

- **High:**
  - **The patch review:** run, not read.
  - **The gate:** its own tests and the census, which read the forge's public copies.
  - **The burn-down counts:** planted faults, so the ground truth is known.
- **Moderate:**
  - **The papers' claims about the field.** Their references were checked when they were written
    and spot-checked in the burn-down. One reviewer objection was rejected after checking (paper
    D's court record stands).
  - **The weaves:** five stand-ins, one model family. The control weave differed little from the
    persona weaves.
- **Low:**
  - **The ethics-redundancy answer.** It rests on n = 2 clean rooms; its experiments are named,
    not run.

## The GRAIN lens, in one breath

- **Tier 1, four papers:**
  - **A:** what people expect;
  - **B:** Free Software practice;
  - **C:** AI memory;
  - **D:** the skeptic's view.

  Each runs about 6,000 words with verified references; all four are now 1.0.1, with errata.
- **Tier 2, the burn-down:**
  - Neither model alone caught every planted fault:
    - the local gemma4:12b on a narrow window caught the broken rule 4 of 4 and the false study 3
      of 4;
    - Haiku on whole papers caught the false study 4 of 4 and the broken rule 0 of 4.
  - Together they caught all 8.
  - The least force is two small readers through different windows.
- **Tier 3, five weaves:** all five merged S01, S02, S03 and S10, and all five independently asked
  for the census.
- **The census:** 108 public commits; 38 session trailers in 9 repositories; card-games' two
  files; one credit link. Nothing else. S08 (stricter levels) is cheap, and still yours.
- **The ethicsminions pass:** 0 risk notices from the guards. Eleven risks were named and closed or
  routed, and five openings were routed (`EM-PASS.md`).
- **Your ethics asks** (`ethics/ETHICS-REDUNDANCY-2026-10-05.md`):
  - **Your failure modes:** eight, from the record. The weightiest are deferring while
    load-bearing, and being the only human reader.
  - **What we have written:** mechanize first; the second human was named in July and never
    seated.
  - **Can more agents help?** Yes, narrowly: a gate, a separate key and the other human, never
    more copies of one model. This is the clean-room eclipse.
  - **The proposal:** four new steps, S34 to S37.

## Personas minted or mutated

- **None minted. None mutated. No sheet changed.**
- **Five stand-ins were used,** as skills through LENS, per your new rule:
  - Mentat (author);
  - Henriette Solberg-Maas (editor);
  - shopgarden (systemic);
  - the CORWIN model (human; use 1, you as principal, from your published words only);
  - no persona (control).
- **The editor's rule-8 note:** only paper D's voice contributed material worth noting
  (concessions before objections, written in the first person). There is nothing to document
  further. The curation conditions were not met for any new persona: no context lacked one, and no
  voice had two consumers.

## Slips of mine, and what is not checked

- **Mine:**
  - I did not read the 10-04 memory note on the Clade key before guessing its use. It is now
    updated.
  - My read-only `git status` left an empty lock in for-bryant. I removed only that file, with your
    permission.
  - The burn-down's planted copies never left the scratch space.
- **Stopped by my sandbox:** I tried to prepare the card-games removal patch and was stopped. That
  one is yours (S02).
- **Not checked:**
  - Emacs 27 and 28 for the patch;
  - whether the desktop app honours the attribution setting;
  - whether Forgejo here can run a server-side gate;
  - the census of the private repositories.

## Questions and hopes

- **S08:** with the census in hand, do privacy and provenance findings stop pushes to published
  repositories too?
- **S09:** for card-games, `users` (the gate alone) or `hand` (you read and push)?
- **S39:** field-comic's credit link to the vendor: keep it or drop it?
- **The hope:** that Bryant reads the weekly ledger. It is the cheapest second human anyone has
  proposed, and the one piece every line of our writing since June has been missing.

---
*Version 1.0.0: first edition on 2026-10-05; spine: 2026-10-05.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/; Mentat (for Corwin; claude-opus-5-5)
