# Pending steps from the GRAIN papers and tonight's work (candidates for the plan)

Each has an ID, an owner, and its sources (papers A to D, the burn-down, earlier hand-backs).
**Owner:**
- **C:** Corwin's hand or decision.
- **M:** the instrument (Mentat), once he says go.
- **C+M:** his decision first, then the instrument's work.
- **B:** a question for Bryant.

## Done tonight (not to vote on)
- D1: pu1sh fails closed, with vendor-neutral checks, PATH, changed files, and a scope line
  (c4 4af7de1; 36 checks).
- D2: public-stage step 1 no longer asks for the session trailer (garden 8743b5d).
- D3: card-games declared `users` in USERS.tsv; Emacs on Savannah declared `hand` (c4 8b83e6e).
- D4: his rules of 10-05 landed (memory, garden note, door parts 37 and 39, egress check 3a,
  persona-engine, mentat-skill).

## Candidates

| ID | step | owner | sources |
|---|---|---|---|
| S01 | Set the app's attribution setting (`attribution.sessionUrl: false`, and the commit line he chooses) in the user settings of each Claude app he uses | C | A, B, C |
| S02 | card-game.el: one forward commit removing `BE16.png` and the shell log; no history rewrite; next release 1.0.92 | C (or M on his word) | A, B, D |
| S03 | card-game.el: move the 10-05 patch out of `Claude outputs/` into `patches/2026-10-05/`, add `Claude outputs/` to `.git/info/exclude`, apply with `git am` | C | review |
| S04 | Install the pu1sh pre-push hook in card-game.el | C | A, B |
| S05 | A server-side `pre-receive` on code.bru.st for repos declared `users` (Forgejo custom hooks, admin only) | C | B, C |
| S06 | card-games file headers: MELPA's `;; Assisted-by: AGENT:MODEL` form under the Author line | C decides the form | B |
| S07 | One SPDX expression per file across the garden, generated from FOOTERS.org; `reuse lint` in egress | C+M | B |
| S08 | Sort pu1sh's checks by harm, not by audience: privacy and provenance findings stop a push at every non-local level (changes his rule) | C | D, A |
| S09 | For projects with users: (A) the gate alone, or (B) the gate as a floor plus a human who reads the diff and pushes | C | D |
| S10 | Treat the vendor as a place data goes: write the plan, terms and training setting into the door; send third parties' words only with recorded consent, or keep them on local models | C+M | D |
| S11 | Ask Bryant whether his DMs may be processed by the vendor, and record his answer | C, B | D |
| S12 | Scope copyright lines to human contribution; keep the `Assisted-by` disclosure; archive prompts locally (Caterpillar) as provenance | C | D, B |
| S13 | Restate the ethics redundancy: name a human second keeper; count the mechanical gates as the redundancy; reconsider "comrade" | C | D |
| S14 | Run experiment E1: gate against memory against both, 17 fixture repos x 4 arms | M | C |
| S15 | Fix light-shelf experiment B (random assignment, matched controls), then run it, and run E2 with abstention and two baselines | M | C |
| S16 | token-optimizer: bring its Evidence section in line with its repository, or publish the replication it names | B | C |
| S17 | Heal prompts carry the failing check, a reproduction command and the covering plant | M | C |
| S18 | The gate's patterns (AIMED, LINK) as a data file beside USERS.tsv | M | C |
| S19 | At the users level, the full secrets catalogue (`c4 secrets-run` or gitleaks); NOT CHECKED when absent, with a named off switch | M | B |
| S20 | The keeper's cold read: once a week, one random line of the preference record or a persona sheet, "still mine" or corrected | C+M | A |
| S21 | A second model family (the local gemma) on load-bearing claims, as in the burn-down | M | C, burn-down |
| S22 | `door render`, so every model.md carries parts 37 and 39 | M | tonight |
| S23 | One garden reinvention pass: move the story out of the work product into the journal; SPDX footers; a vendor-link scrub; staged and gated on S07 and egress 3a | C+M | his ask; A, B, D |
| S24 | The Bryant parcel: send as built, or add tonight's users rule and pu1sh; say the joint terms line; say "incremental tool synthesis" to him | C | earlier |
| S25 | The light shelf: name the four prongs, confirm 17, beside or instead of the memory shelves | C | earlier |
| S26 | Retire the SOFT-SKILLS/build-loop leftover | C | earlier |
| S27 | The cutover and `make dist` (re-seals the skills changed today) | C | earlier |

## Added after the weaves (not voted)

S28 to S40 come from the census, the ethics-redundancy work and the editor's notes; they are in the
map. Three more came from catching up with the card-games session:

| ID | step | owner | sources |
|---|---|---|---|
| S41 | kid-glove learns the user's downstream conventions: honor users' expectations and the conventions of places the house has chosen to join (MELPA, GNU ELPA), should it please the user to comply ("BOY leather"; blessed 10-05) | M, coordinated with the card-games session | his blessing |
| S42 | card-games' commit-msg hook refuses MELPA's own form (`Assisted-by: Claude:MODEL`), and its tests call that form wrong: accept both, and refuse session trailers from any vendor | C (a patch), or M on his word | catch-up review |
| S43 | pu1sh: per-repo allowed paths in USERS.tsv (card-games' hook tests carry session links as fixtures) | M | catch-up review |
