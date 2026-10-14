# GRAIN weave: control

## 1. The weave

### 1.1 What the four papers agree on

- **Keep the agent and harden the boundary.** A reads the remedy as refusing disuse after a visible error and scoping trust to context. B finds the instincts sound: humans sign, the agent never does, and none of the tools it surveyed has the levels idea. C finds that boundary rules belong in gates, because memory is loaded as context and not enforced. D, steelmanning the skeptic, concedes that the gate is falsifiable and sits at the one act that cannot be undone.
- **The gate as reviewed fitted one incident and one vendor.** A calls this the availability heuristic built into code. B shows it with probes, and C with one domain and one family of file names. D adds that the gate grades its own homework.
- **"Undeclared means advice" is the weakest default.** All four push against it, each by its own route: active choice (A), visibility (B), irreversibility (C) and harm (D).
- **Stop the session link at its source.** For disclosure, use `Assisted-by:` with a product and model name, which is where the field is converging.
- **A client hook is not the last layer.** B and C say so directly; D gets there through a human reader.
- **The checker is not independent of what it checks.** A calls this the supervision loop, C calls it self-evaluation within one model family, and D calls it common mode among keeper, vendor and instrument. All three cite the same sycophancy study, written largely by researchers at the instrument's vendor.
- **Prove-red and NOT CHECKED are the workshop's strongest practice.** B matches them to Automake's skip and hard-error codes, C to the external oracle that repair needs, D to a counter to ritual, and A to showing how well the system can do what it does.

### 1.2 Where they truly disagree, and why

1. **Should a human sit behind the gate?** D recommends that, for projects with users, a person read the diff and push. The norms B cites back this up: the kernel requires a human who certifies the change, and MELPA wants the human author to be the first and most thorough reviewer. B's own remedies, though, are mechanical (fail closed, a server hook). A's evidence predicts that the reader fades: complacency survives practice, warnings habituate, and a "0 flags" result from a narrow check gets read as a wide one. C argues that rules kept in memory fail because they must fire late, when attention is elsewhere, and judge bytes by eye. By extension (my reading, not C's text) the same argument applies to a human reader. The split follows what each field measures. STS and Free Software practice ask who answers for a change; human factors and agent theory ask what reliably catches a fault. Neither side's evidence settles the other's question. Only planted faults against the human read can settle it (N-CONTROL-3).
2. **What should the stop key on?** The papers share a direction, but their variables are not interchangeable. A keeps the keeper's rule and adds one question at first push. D replaces audience with harm for privacy and provenance findings. B notes that release practice keys on visibility, which would stop every published push on every check; A's habituation evidence warns against that if false stops are common. The deciding number is the false-positive rate per check on his own histories, and nobody has measured it (N-CONTROL-2).
3. **What counts as independence?** C proposes a second model family, D a second human, and A the keeper's own cold read. The burn-down supports C's version for finding faults in text. D's objection still stands: any reader the keeper directs, on his account, shares his pressure. A second model family answers model bias, not the shared direction.
4. **Copyright.** This disagreement is smaller than it looks. B and D both say to scope the copyright lines, keep the licences and keep the records of human direction. They differ only on how to settle the question: ask the FSF or SFC (B), or count lines (D).

### 1.3 What each lens sees that the others miss

- **A (human expectations).** "Users" means two audiences. Installers are likely shielded from a stray `.png` or `.log` by MELPA's default recipe; readers of the history are not. Advice is not free, because it habituates. The supervision loop lacks its human end: a cold read by the keeper. For a competence slip, apology repairs trust better than denial.
- **B (Free Software engineering).** B alone ran the gate. It found three ways the whole slip got through while all 21 self-tests passed, and its tested repair was adopted, with its probes as fixtures. Licence statements contradict themselves in 14 of 26 skill files. "GPL with the LGPL's permissions" is the LGPL under another description. MELPA's header wants a product name, not a persona. Forgejo disables server hooks for a reason.
- **C (AI theory and memory).** Sort rules by kind: boundary rules become checks, and judgment stays in memory. AIMED is a defence against prompt injection, not tidiness. Light-shelf experiment B is confounded by the conformity law, and a fixed working set of 17 under least-recently-used rotation can thrash. Heal prompts help in proportion to the quality of their feedback. The token-optimizer's evidence was not found where C fetched.
- **D (the skeptic's social view).** Privacy harm does not wait for users. The house gates what it writes down, not what it sends: third parties' words went to the vendor. The training corpus is a third author the attribution ladder cannot see. Footers say "Authored by Mentat" above a human copyright line. The public record may pin the slip on Corwin. Tools born from an incident show lift; apparatus built in anticipation shows no recorded firing.

### 1.4 What the burn-down changes

- **Facts corrected.** card-games is declared `users`, which closes A's main omission. The repository is `card-game.el`, and the replay flags exactly the three faults, which clears B's dagger. C's count was 21 at the time; it is 36 now.
- **Most obvious wins are done.** As the errata describe it, commit 4af7de1 closes all but one of B's twelve probe rows. The gate now fails closed, LINK and AIMED are vendor-neutral, a PATH check is new, MISNAMED reads changed files, and every run ends with a scope line. The exception is row 8, newer token shapes, which the errata do not mention (S19). The overfit concern shrinks to D's point about self-grading: the widening was written and fixtured by the same model family, so no independent fixtures exist yet (N-CONTROL-1).
- **Untouched: the levels.** The two decisions the burn-down sends to the keeper, sorting checks by harm (S08) and the fork (S09), are disagreements 2 and 1 above.
- **Method.** Planted faults are the only test of a reviewer, and two small readers together caught all eight plants where neither did alone. Two limits apply. The burn-down varied model family and window size together, so it cannot say which one did the work. Its sorter (R2) is from the papers' own model family, so its accept-and-reject split carries the self-evaluation concern C and D raise. It tested how accurately the papers read, not whether their recommendations are right. This weave shares both limits: same family, and no plants.

## 2. Votes

| ID | step | vote | rank | reason |
|---|---|---|---|---|
| S01 | app attribution setting | MERGE | 4 | Three papers: stop the trailer at source; desktop-app coverage still NOT CHECKED. |
| S02 | card-game.el forward commit, 1.0.92 | MERGE | 1 | Removes strays from the one users project; matches git, SLSA and house rules. |
| S03 | land the 10-05 patch | MERGE | 5 | Lands a tested fix users need; keep `patches/` out of the shipped tree. |
| S04 | pre-push hook in card-game.el | MERGE | 2 | Minutes; without it the users declaration is not checked at push. |
| S05 | server `pre-receive` | HOLD | | Value depends on S09; merge if agents push to users repositories. |
| S06 | MELPA `Assisted-by` header | MERGE | 6 | MELPA asks for it in review; use the product name, not Mentat. |
| S07 | one SPDX expression per file | MERGE | | 14 of 26 files state two licences; one generator fixes all. |
| S08 | sort checks by harm | MERGE | 7 | Public history is permanent whether or not users exist; census tunes, not decides. |
| S09 | gate alone, or gate plus reader | MERGE | | His fork; lean B for card-games: likely few pushes, cheap reads; test via N-CONTROL-3. |
| S10 | vendor as a destination | MERGE | 3 | Nothing else gates what is sent; D found third parties' words already sent. |
| S11 | ask Bryant about his DMs | MERGE | | The specific consent S10 needs; ask as its own explicit question. |
| S12 | scope copyright lines | HOLD | | Archive prompts now; scope wording after an authorship census or FSF/SFC answer. |
| S13 | restate the redundancy | HOLD | | Common-mode point is sound; a second keeper needs a person, not a rename. |
| S14 | E1, gate against memory | HOLD | | No outcome removes the gate; reuse its 17 fixtures in N-CONTROL-1. |
| S15 | fix light-shelf B; run E2 | MERGE | | Fixing a confounded design is cheap; running it lets S25 rest on evidence. |
| S16 | token-optimizer evidence | MERGE | | Unwitnessed where fetched; ask Bryant as a question, not a fault. |
| S17 | heal prompts carry check, reproduction, plant | MERGE | | Repair quality tracks feedback quality; cheap to add, testable by C's E6. |
| S18 | gate patterns as data | MERGE | | Keeper edits patterns without code; rule and gate stop drifting apart. |
| S19 | full secrets catalogue at `users` | MERGE | | The secret floor is not a catalogue; leaks need rotation; fail closed when absent. |
| S20 | keeper's weekly cold read | MERGE | | Only step putting the human end in the supervision loop; minutes weekly. |
| S21 | second model family | MERGE | | Local and cheap, but burn-down varied family and window together; separate them. |
| S22 | `door render` | MERGE | | Rules of 10-05 reach no project until rendered; mechanical and cheap. |
| S23 | garden reinvention pass | HOLD | | Depends on S07; scope to what ships, to limit the churn A warns of. |
| S24 | the Bryant parcel (holds a keeper-only element) | MERGE | | His decision; include pu1sh and users rule; S11, S16 as explicit questions. |
| S25 | light shelf: prongs, 17, placement | HOLD | | No evidence yet; decide after S15; "beside" is the reversible choice. |
| S26 | retire SOFT-SKILLS/build-loop | MERGE | | Duplicate copies drift; archive, then retire, per his delete rule. |
| S27 | cutover and `make dist` | MERGE | | Seals today's skill changes; build twice to test reproducibility (B's experiment 5). |

The top seven merges, in order: S02, S04, S10, S01, S03, S06, S08. There is no DROP: every step has a paper's evidence or his own request behind it, and each HOLD names what it waits on.

## 3. New steps

- **N-CONTROL-1: a second reader for pu1sh.** Owner: M. Write a one-page spec of the checks and levels, and implement it, without reading pu1sh, in a language other than shell or awk. Have another author write fixtures blind (the local model under a human check, or a person). Run both readers over all fixtures and over paper B's probe rows. *Why:* pu1sh passed 21 self-tests while failing open three ways, and its widening was written and fixtured by the same model family. Paper B notes that a new spec in another language is Corwin's standing rule for anything that got past the tests. S14's fixtures can be reused here.
- **N-CONTROL-2: a census of published repositories.** Owner: C+M. (a) Replay the current pu1sh read-only over the full history of every published repository, and count FLAG, ADVICE and false positives per check. (b) Collect two weeks of clone and traffic data for each undeclared public repository. *Why:* (a) sets what S08 would cost in false stops and tests A's advice-fatigue falsifier (B's experiment 1, A's E1). (b) tests the premise that an undeclared repository has no users (A's E2, D's E2). It takes hours of machine time; C supplies forge access.
- **N-CONTROL-3: test the human read with planted faults.** Owner: C+M. If S09 takes fork B, plant faults outside the gate's checks in staged `users`-level pushes over four weeks, with the gate on for half of them (A's E4), under Corwin's specific, dated consent. *Why:* this settles the accountability-versus-detection disagreement on evidence. The burn-down shows that a reviewer is known to work only through planted faults; without them, a human read risks becoming the ritual D warns of.

## 4. Composite ideation

1. **Declared users, checked at the source** (ground-truth × pu1sh): before pu1sh grades a remote from `USERS.tsv`, ground-truth checks the declaration against the forge itself (a release tag, a package recipe, a MELPA listing). A mismatch asks once instead of defaulting to "published", which is A's recommendation 1 made mechanical.
2. **Credit from published self-statements** (manifest × pv1tl): pv1tl reads Bryant's versioned Manifest, where it is published, as a dated first-party store, so credit questions rest on public statements rather than private messages. *Touches keeper-only material if it is pointed at Corwin's account of joint tool building; keep that out of anything sent.*
3. **One licence line, failing closed** (colophon × ft1mt): ft1mt generates one SPDX expression per file from `FOOTERS.org`, and colophon checks it whenever files leave either garden. When its second reader cannot run, colophon reports NOT CHECKED, never success, which fixes the defect paper B cites.
4. **Heal locally first** (frugal-offload × he1al): heal prompts that carry the failing check, a reproduction command and the covering plant (S17) go first to a local model through frugal-offload, and to the vendor only if prove-red stays red. One run tests C's E6 and Bryant's frugality idea.
5. **A legend for every coded name** (rosetta × garden-usage): every C4 tool ships a rosetta legend line that maps its coded name to one plain sentence, and garden-usage answers from it. The idea fails if a cold reader finds tools no faster with the legend than without it.

## 5. Persona note

none (control)

---
*Version 1.0.0: first edition on 2026-10-05; spine: 2026-10-05.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/; no persona (control), for Corwin; claude-opus-5-5
