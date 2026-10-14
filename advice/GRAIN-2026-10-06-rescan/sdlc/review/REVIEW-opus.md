<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
# Review: Team W (wild) and Team G (garden), Larder software side

Reviewer: Opus, 2026-10-06. Not blind: G's vocabulary gives it away. I worked on copies under `/tmp/rv`; the sha256 of all 101 team files matched before and after.

## What I ran (OBSERVED)

| Step | W | G |
|---|---|---|
| Suite | `sh 5-TEST/run-tests.sh`: 35 checks, 0 failed, 0 skipped, exit 0 (dash, 3.9 s) | `sh 5-TEST/lr1ck`: 42 passed, 0 not checked, exit 0 (dash, mawk, Emacs 29.3, node 22, gpg) |
| Prove it can fail | `--self-test`: green baseline, 27 of 27 planted faults caught by the check named for each, exit 0 (107 s) | `--prove-red`: green control, 38 planted faults plus the exit-2 and exit-3 paths caught, exit 0 (10 s) |
| Regenerate from the one source | `sh gen.sh -o /tmp/rv/w-regen`, then `diff -r out`: identical. `FREE_ONLY=1` drops exactly the seven `nff` names. | `sh bin/lr1tg -C … recipes.org`: identical to `out/`. `org-babel-tangle-file` (Org 9.6.15): also identical. |
| My line-deletion probe (30 code lines per team, seed 4917, each team's own full suite) | 28 killed, 2 survived (`close(dest)`, a usage arm in `fanmark`) | 20 killed, 10 survived (see below) |
| W's package names checked against G's signed trixie 13.7 index | every name exists; all seven `nff` flags are correct; only `larder-tools` (flagged `local`) is absent | — |

**G's survivors that matter (OBSERVED).**
- Deleting `lr1op:52` (`if [ "$run" = 0 ]; then`) makes `lr1op --run library` print "would run" and exit 0, so every click does nothing, and the whole suite stays green. Nothing tests the dispatcher's real-run path (the ERT tests use a stub or dry mode).
- Four survivors are refusal paths in `lr1tg.awk` (block-name, `:mkdirp` and others). `5-TEST/fixtures/bad-*.org` exist for exactly these cases, and by hand I confirmed `lr1tg` refuses each one. But no check runs them: the fixtures are not wired into the suite.
- One survivor is the work-hash line in `lr1st`. The remaining four are docstrings, and a fullscreen call that batch mode cannot see.

## Scores per stage (JUDGED)

| Stage | W | G |
|---|---|---|
| 1 Ideation | **4**: seven approaches scored against eight needs (NixOS, Flatpak/OCI and a metapackage repo among them), with a defensible pick and borrowings from the losers. Guix is dismissed on one quote. | **4**: seven approaches, deeper on free bases (Parabola, Debian Libre Live, a recipes-only option). Its inverse persona produced a real finding ("six languages; simple for whom?"). Space goes to ritual, and the pick partly models what Corwin would want. |
| 2 Analysis | **4**: twelve risks, each with a falsifier and tagged [web]/[mem]/[obs]. Several change the plan: Sideband against Python 3.13 sets the fallback order, i386 means striking a spec line, and `usbguard` could lock out the RNode. It missed that Debian packages enable their daemons on install. | **4**: thirteen risks, each with an owner and a falsifier. It found the daemon auto-enable from `tor`'s postinst (R5), a standing permission against a per-work OK (R7), and rights checked per title and per right (R8). Its falsifier thresholds use invented house numbers. It missed Sideband/Kivy and never names what the group loses without the mesh. |
| 3 Design | **4**: three crisp rules, all five profiles, a button only if its program exists, fallbacks, and deny pins. The author edition is data on the media partition, so there is one signed OS image for everyone. There is no dark mode or assistive tech, and a failed click is silent. | **3**: strong accessibility, a free-by-default split and an author gate. But four of five profiles have no mesh stack, the group's radio stack, and no chat or network button, and the cost is never stated. The page is written by hand, not generated. The author edition changes the image. `homelab` carries ansible, nmap and libvirt. |
| 4 Build | **4**: it runs and comes from one source. It is 679 lines (over the "few hundred" asked for), POSIX sh and awk, no network, SPDX lines everywhere. The generator refuses 24 kinds of bad recipe. | **3**: it runs, and two independent readers produce identical bytes, which I confirmed. It is 1,255 lines in six languages, plus 344 KB of evidence. No network and correct SPDX lines; it followed PROBLEM's licence over the house dual licence, which was right. |
| 5 Test | **5**: meaningful checks (escaping of hostile text, a real exec on a stub PATH, a dry run that cannot start anything). The planted faults run the full suite, and the team swept 393 single-line deletions. Green means "consistent with itself", and the team says so. | **4**: evidence-grounded checks (names against the signed index, programs against Contents, four readers of the offer rule, contrast computed in awk and in node, Modus colours compared to Emacs). It has exit-2 and exit-3 discipline. But the fixtures are dead and the run path is untested, and E3/E4 test the documents' ritual, not the product. |
| 6 Review | **5**: frank on size, on stubs, on tests sharing one reading, and on the sweep's survivors. It disclosed the stray `/expect.el` (it is still there). Its next steps are ordered. | **4**: honest; it disclosed listing directories beyond the six allowed files, and its next steps are good. Its "largest social risk" is Corwin's reaction, not the group's. It asks reviewers to break the awk boundary but did not notice its own fixtures are unwired. |

## Overall (JUDGED)

- **Usefulness to the organizing group.** W is ahead. Its sticks carry what the spec is for: mesh chat, network, Nextcloud files and the library. Its pages are generated per profile, so a button cannot outlive its program. Keeping one OS image for every edition protects the hash shown on the e-ink. G's default sticks leave the LoRa radio's software out, and G never prices that. G adds what W lacks: services that would start at boot, and package names verified against a signed index.
- **The author variant (the author's rights; a draft, not a grant).** G is clearly safer. Its notice is headed DRAFT, SIGNED: no, "grants nothing", with blanks and a list of questions for counsel. Each title and each right goes through a gate. The stamp refuses unless the author's own signature verifies. W's notice is a well-formed first-person public grant behind a DRAFT banner, with a mark bound to the notice's hash, which is good. But its fuse (`LEGAL_REVIEW=yes`) belongs to whoever builds the stick, not to the author, and the notice it grants ("anyone, anywhere") would conflict with terms W never saw. One cost on G's side: the gate assumes the author keeps a GPG keyring, which is shop culture, not an author need.
- **User freedom and licensing.**
  - Both see that Reticulum's field-of-use clauses and Sideband's NC licence are non-free, and both flag GPLv3 section 6. Neither builds a source offer.
  - W ships non-free firmware and the non-DFSG mesh in every profile, labelled, with a `FREE_ONLY` switch.
  - G makes the free profiles main-only, puts firmware and mesh in add-ons, and B10 enforces it.
  - W alone caught that a CC-BY-SA mark sentence would ride in every fan work.
- **Accessibility.** G is ahead: light/dark with a two-way override, 30 contrast pairs measured twice, an on-screen keyboard and a screen reader, a mouse on the console via gpm, and the Emacs frame shows a failed click. W is light only, three pairs at 7:1, with large targets.
- **Cost.** W: 679 build lines, 718 test lines, about 7,000 words of documents. G: 1,255, 1,135, about 11,400 words, plus 344 KB of evidence. My probe found W's suite tighter per line. Both overshoot the brief.

## What G's context changed, stage by stage

**Ideation.**
- *Improved:* Corwin's door images seeded A2–A4 with real prior art (Guix, Arch, Parabola, the FSF's list, GPLv3 section 6). The LENS inverse persona surfaced maintainer cost.
- *Harm:* the LENS frame put "what Corwin would want" (b.B) next to the spec author's choice. The ideation carries a hash-pinned head line and dagger counts.
- *W, without context:* covered a wider technical span (NixOS, OCI, a metapackage repo) and got to the same pick, Debian, faster.

**Analysis.**
- *Improved:* R7 and R8 come straight from the context (Dad's terms; publishers hold print licences, not rights) and change the author design the most of anything in either submission. R13 quotes section 6 exactly. The seams rule ("two readers is evidence") plausibly drove reading `postinst` scripts, which produced R5.
- *Harm:* the invented thresholds (4, 9, 17) make arbitrary falsifiers look quantitative. U9 points risk at the shop owner rather than the group.
- *W found, G missed:* Sideband against Python 3.13/Kivy, `usbguard` default-deny locking out the radio, and the CC-BY-SA mark sentence.
- *G found, W missed:* `tor` and `i2pd` sit in W's `desktop` and would be enabled at boot, against the spec's "Tor available but not forced". live-build skips `#` lines and *runs* `!` lines, which answers W's U4.

**Design.**
- *Improved:* the light/dark pattern, Modus tokens, the console-mouse Emacs frame (from EMACS-AS-APP), a book gate per right, a signature-gated stamp, and free-by-default profiles.
- *Harm, borrowed values:* the free-software ranking pushed the mesh out of every profile the group would use. The house frame let that read as principled when it is a cost no one named.
- *Harm, doctrine:* the "two representations" rule kept the page hand-written, so a change takes two edits.
- *W, better without context:* a button only if its program exists, and the edition as data that keeps the image hash constant.

**Build.**
- *Improved:* the literate Org source with two readers is real and verified, and the names are checked against a signed index.
- *Harm:* the pipeline is roughly 1.8 times W's size in six languages, `xx1yy` names that mean nothing to a newcomer (`lr1op`), and inline script on the page (W's page has none).

**Test.**
- *Improved:* exit 2 means NOT CHECKED, never a pass, and exit 3 prints a heal prompt. Facts are tested against external evidence.
- *Harm:* checks spent on house ritual (E3 LENS head line, E4 dagger counts). The unwired fixtures and the untested run path show that a ritual count of planted faults (40, each found by its own `--only` check) is weaker than W's whole-suite plants plus its mutation sweep. The irony: the context's own hazard was "must RUN, not merely render", and the run path is the one G left untested.

**Review.**
- *Improved:* the OBSERVED/JUDGED split, and the disclosure of the extra directory listings.
- *Harm:* the attention points inward (Corwin's reaction, daggers).
- *W, without the rule:* equally honest.

## Bottom line

- **Where context helps most:** the author variant and stakeholder facts (rights per title, the standing-vs-per-work question, a draft that is not a grant, the author's own key as the gate), concrete accessibility patterns, and the test exit-code discipline (NOT CHECKED is never green). No amount of general skill recovers these from the problem text.
- **Where it helps least or hurts:** the base choice (both landed on Debian). House ritual (LENS head lines, daggers, the 4/9/17 numbers, `xx1yy` names, checks on documents) roughly doubled the size without finding product faults. Values given as rankings displaced the group's core need (the mesh) without the cost being named. Doctrine (two readers, a hand-written second page) added rigidity.
- **A minimal context pack for the next task:**
  1. Stakeholder facts and who decides, here the author's terms and the rights per title.
  2. Values as *defaults with a duty to price them against the group's stated purpose*.
  3. The accessibility pattern.
  4. Prove-red with an exit 2 for NOT CHECKED.
  5. Pointers to prior art and to legal duties (door images, GPLv3 section 6) as facts, not methods.

  Leave out naming conventions, LENS/seams procedure, house numbers and document-meta checks.
