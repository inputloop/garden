# What Leaves, and Under Whose Name: A Free Software Release-Engineering Review of the C4 Workshop and Its Users Gate

## Abstract

This paper reads a two-person AI-assisted workshop (Corwin Brust's C4 tree and skill garden, with Bryant Frankford's workshop beside it) as a Free Software maintainer and release engineer would: what leaves the shop, under whose name and licence, and what can a stranger check afterwards? The case study is a slip in `card-games`, a published Emacs package in review for MELPA, whose public history gained a vendor session URL in a commit trailer, a web block page saved as a `.png`, and a shell log; and the workshop's answer, `pu1sh`, a pre-push "users gate". Against current practice (AI-disclosure rules and bans, the DCO, REUSE/SPDX, git's guidance, SLSA, and the peer-reviewed supply-chain literature), the workshop's instincts are mostly sound: humans sign and the AI never does, attribution follows GNU's own threshold, checks report NOT CHECKED as a distinct result. Its weaknesses are in the plumbing. `pu1sh` passes its 21 self-tests yet lets the whole slip through in three reproducible situations, because a range git cannot read counts as "0 commits, 0 flags" instead of NOT CHECKED, the house's own rule; and a client-side hook is bypassable by design. The garden's licence statements disagree with each other in a way REUSE tooling would flag. Seven ranked recommendations begin with an eight-line change that makes the gate fail closed; six experiments are proposed as falsifiers.

## 1. Introduction

The workshop is POSIX shell tools with self-tests, a door of rules rendered into every project, licence defaults (writing CC BY-SA 4.0, software GPL-3.0-or-later, linkable parts on the LGPL's terms), an attribution ladder, and an AI instrument ("Mentat") that keeps notes. Most of it never leaves the shop. The exception is the one this paper is about. In Corwin's words of 2026-10-05: "Card games is the only project where we really could have made this error and we did."

Free Software release engineering is built around exactly that boundary. Inside the tree, maintainers do as they please. At a push, a tag, a tarball or a package, conventions apply so that strangers can rely on what they receive: who wrote it (author, sign-off, ChangeLog), under what terms (licence notice, SPDX, REUSE), whether it is what it claims (signed tags, reproducible builds, provenance), and whether history stays put. The workshop says the same in its own idiom: "sign at the door, not in the drawer -- only where a named reader relies on it" (keeper-top-block.md).

The question is therefore narrow: at the door, does this workshop do what Free Software practice expects, where does it improve on it, and where would a maintainer reviewing its patches push back?

## 2. Background from the field

### 2.1 Freedom, copyleft, and the copyright it rests on

Copyleft licences (GPL, LGPL, CC BY-SA) deliver the four freedoms only where copyright exists. The US Copyright Office concluded in 2025 that "the mere provision of prompts" does not make an output copyrightable, while human expression perceptible in it, or a human's creative selection, arrangement or modification of it, remains protectable [27]; the D.C. Circuit held that "the Copyright Act of 1976 requires all work to be authored in the first instance by a human being" [28]. How much human contribution suffices in a long human-directed session is open (US law only).

The LGPLv3 "incorporates the terms and conditions of version 3 of the GNU General Public License, supplemented by the additional permissions listed below" [12]: it *is* GPLv3 plus section 7 permissions. CC BY-SA 4.0 is one-way compatible with GPLv3: BY-SA material may go into GPLv3 works, not the reverse [13]. Machine-readable licensing uses SPDX identifiers (`CC-BY-SA-4.0`) [14] and REUSE 3.3, under which every covered file carries copyright and licensing information as a valid SPDX expression [15].

### 2.2 Authorship records in git

The Developer Certificate of Origin is a human statement ("created in whole or in part by me") [16]. Hence the kernel's rule: "AI agents MUST NOT add Signed-off-by tags. Only humans can legally certify the Developer Certificate of Origin" [1]. Attribution goes in an `Assisted-by:` trailer: `AGENT_NAME:MODEL_VERSION [TOOL1] [TOOL2]` in the 7.1 documentation, from Sasha Levin's patch of December 2025 [1, 2], and the shorter `Assisted-by: LLM [TOOL1] [TOOL2]` in the development documentation as fetched on 2026-10-05 [1]. Either way it names a model, never a session. Kernel commit messages should be "understandable without external resources," with `Link:` tags to public background, and every `Co-developed-by:` needs that co-author's own `Signed-off-by:` [3], which an AI cannot give.

Other projects converge on the same trailer. Fedora's policy (proposed 2025-09-25, approved by its Council in October 2025, the approval reported by news) says "the contributor is always the author and is fully accountable" and recommends `Assisted-by:` [7]. MELPA's contributing guide, directly relevant to card-games, now asks for "a Linux-style 'Assisted-by' line under your files' Author line," of the form `;; Assisted-by: AGENT_NAME:MODEL_VERSION`, and says the human author "should be the *first* and *most thorough* reviewer" [8]. A draft policy circulated on the GCC list in April 2026 says "the correct trailer to use is Assisted-by and not Co-authored-by"; it is a draft under debate [31]. GNU Emacs's CONTRIBUTE (GitHub mirror) does not mention AI and uses `Co-authored-by:` for human co-authors with addresses [9], as GitHub does for accounts [33a].

Not every project accepts AI output. Gentoo (2024-04-14) forbids it, citing copyright, quality and ethics [4]; NetBSD presumes it "tainted" and requires core's prior written approval [5]; QEMU declines it because DCO clauses (b) and (c) cannot be certified for it [6]. The Software Freedom Conservancy asks projects not to shun such contributors, asks contributors to disclose "what LLM-gen-AI system was used, its version, and a brief description of how the system assisted," and holds that "Copyleft Everything" is safest [29]. The FSF, per news reporting of a GNU Tools Cauldron talk in October 2025, is still forming a position; its Licensing and Compliance Lab suggested recording which LLM was used, the prompt, and which portions it produced [30, news]. curl ended its bug bounty in January 2026 to remove the incentive for unresearched, often AI-generated reports [32, news].

GNU has long had a numeric threshold for when a contribution matters for copyright: "more than around 15 lines of code and/or text," counted cumulatively per person [10]; Emacs says "a dozen or so lines of non-trivial changes" [9]. GNU change logs exist "so that people investigating bugs in the future will know about the changes" and may be generated from version-control logs [11].

### 2.3 History, signatures and provenance

Git's documentation is blunt: rewriting "a branch that others have based work on is a bad idea" [17c], and for a wrong tag already pushed, "the sane thing" is to "admit you screwed up, and use a different name" [17b]. SLSA v1.2's Source Level 2 requires that a branch "can only be updated to point to revisions that descend from the current revision" [19a]. GitHub's guidance puts rotating a leaked secret first, notes that rewritten commits survive in clones and forks, and says a rewrite "may not be warranted" afterwards [33b].

Git signs with OpenPGP by default and, since 2.34, with SSH keys checked against an "allowed signers" file [17b, 18]; Sigstore's gitsign uses short-lived certificates tied to an OpenID identity and a transparency log [21]. The peer-reviewed supply-chain literature adds in-toto, which records which steps were performed, by whom and in what order [20]; Sigstore [21]; and reproducible builds, where "any party can recreate bit-by-bit identical copies" [22]. SLSA Build Level 1 asks only that provenance exist [19b].

### 2.4 Gates at the way out

A pre-push hook receives the remote's name and URL as arguments and one line per ref on standard input; a remote ref that does not exist is "the all-zeroes object name" [17a]. `git push --no-verify` bypasses the hook "completely" [17d], and hooks are not cloned with a repository. Server-side `pre-receive` hooks run on the receiving repository and can refuse an update [17a]. Forgejo, the forge behind code.bru.st, ships with custom server-side hooks disabled (`DISABLE_GIT_HOOKS = true`) because they allow "arbitrary code execution on the host" [35].

The established tools here are secret scanners and licence linters. Secrets leak into public repositories at scale: more than 100,000 repositories and "thousands of new, unique secrets" a day (NDSS 2019) [23]. gitleaks (MIT) scans history and ranges with a large default rule set and entropy checks [34a]; git-secrets (Apache-2.0) also checks commit messages through a commit-msg hook [34b]; pre-commit (MIT) manages hooks for many stages, with stock checks such as `detect-private-key` [34c]; `reuse lint` (GPL-3.0-or-later) runs as a pre-commit hook [15]. On AI specifically: LLMs reproduce existing open-source code at measurable rates (0.88% to 2.01% for the best models) and "fail to provide accurate license information, particularly for code under copyleft licenses" (ICSE 2025) [24]; and developers already paste AI conversation links into commits and issues, enough to build datasets from (MSR 2024) [25, 26 (preprint)].

## 3. Analysis

### 3.1 The body of work, read at the door

**Who signs.** The keeper's rule is that the secret key "lives only on my device... so Claude verifies but never signs. Signing is my ceremony, always" (keeper-top-block.md). This matches the kernel's rule for the DCO. The drawer-vs-door skill extends it with a test every release engineer would accept: before any signing work, name the reader who relies on it across a boundary; with no reader, sign nothing. For code that moves, the shipped bundle's single `SHA256SUMS` is signed once at the ship boundary, roughly SLSA Build Level 1 provenance made by hand [19b].

**How credit is given.** The attribution ladder (attribute, credit, acknowledge, thank) attributes when more than 15 lines of one author's sources are reused over the body of a work, and credits ideas, because "copyright covers words and code, not ideas" (attribution-ladder.md, its own reading). The threshold is GNU's, cumulative per author [10]. The FINDING's method for who made what (a party's own dated statement first, mtime last; CONTESTED or NOT KNOWN where records do not reach) is provenance in the in-toto spirit: several independent records, agreement as evidence.

**How tools prove themselves.** Every tool ships `--prove-red`: a green control, planted faults, and NOT CHECKED as its own exit. Free Software has the same idea in GNU Automake's test harness, where exit 77 means "skipped" and 99 means "hard error," distinct from failure [37]. The workshop's version is stricter about saying why. Its own letter of 2026-10-05 found the defect this rule exists to catch in a peer's tool: "colophon 1.1 check exits 0 when its second reader... could not run" (letter, finding B1).

**Licence hygiene (observed).** In the 26 skill and soft-skill files in the pack, 14 carry `SPDX-License-Identifier: GPL-3.0-or-later` and also a minted footer that says the text is CC BY-SA 4.0 "(scripts GPL-3.0-or-later)"; 1 (foaf) carries `SPDX-License-Identifier: CC-BY-SA-4.0`; 11 carry no SPDX line; 24 carry the footer token `CC-BY-SA4`, which is not an SPDX identifier [14]; two write the identifier with a trailing period (`GPL-3.0-or-later.`). The attribution ladder itself records that the canonical TERMS v1 block still says CC BY 4.0 for writing while the keeper moved to BY-SA on 2026-10-04. Judged: for 14 files the machine-readable layer and the human layer disagree about one fact, the file's licence. Because BY-SA 4.0 flows into GPLv3 but not back [13], a reader who trusts the SPDX line receives fewer permissions for the prose than the footer grants. The fix is cheap because the footers are generated in one place (`bin/ft1mt` from `conventions/FOOTERS.org`).

**The LGPL form.** The FINDING credits Bryant with the *form* "GPL-3.0-or-later, with the LGPL's permissions for linking" and Corwin with the *idea*. Judged: by the LGPLv3's own first sentence [12], that form is the LGPL by another description, close enough that a licensing reader will ask what, if anything, differs, and SPDX has no standard way to say it except `LGPL-3.0-or-later` or a `LicenseRef-`. Credit for the wording is fair; it is worth knowing that the substance converges. Separately, the LGPL's vocabulary ("Library," "Application," "Combined Work") fits linkable code poorly when the "linkable parts" are Markdown prompts copied into other people's work.

### 3.2 The case study, read by a maintainer

**The session URL in a trailer.** A commit message is a permanent public record that should make sense without external resources, with links to public, durable background [3]. A vendor session page fails both tests for every reader but the account holder. Nor is it the disclosure the field asks for: the kernel, Fedora, MELPA, the SFC and the FSF's lab ask for the *agent and model* (the FSF's lab, also the prompt), recorded in the commit or file itself [1, 7, 8, 29, 30]. The trailer is a vendor default: the vendor's documentation lists `attribution.sessionUrl`, default "unset (session URL is included)," for cloud and Remote Control commits, and `attribution.commit`, default `Co-authored-by: Claude <claude@anthropic.com>` [36]. Corwin's rule of 2026-10-05 ("Do not install references to claude.ai into our work-product unless I have asked you to do that") retires the trailer in his repositories; the rule is right by the field's standards. One seam remains: the public-stage soft skill, step 1, still tells agents that commits "carry the author as the person and the Co-Authored-By / Claude-Session trailers," so every new public stage started from it reintroduces the fault.

**The block page and the shell log.** Neither is a secret by the brief's account. The block page is a third party's HTML under a `.png` name, with no licence. The log carries a local Windows path and push-authentication failures. A REUSE-compliant repository would have flagged both at commit time as files without licensing information [15], which is a generic catch for exactly this class of stray. Whether either reached *users* depends on the MELPA recipe: the default `:files` specification packages `*.el` and documentation, not images or logs [8b]; a card game whose recipe adds card images might ship the block page into installs. That is checkable in one look at the recipe.

**Rewrite or leave.** The history is public, mirrored, tagged `1.0.91`, and under MELPA review. Git's own guidance [17b, 17c], SLSA's continuity requirement [19a] and GitHub's note that rewritten data survives in clones [33b] all point the same way: leave the history; remove the files in a forward commit with a plain message; never move the tag; the next release is `1.0.92`. History is rewritten only for a live secret (and then rotation comes first), for third-party material of real substance under incompatible terms, or for other people's personal data. None of the three faults is any of these. This matches the house's own rule that deletion is for undoing our own mistakes while the record is archived: the forward commit deletes from the tree, and the history remains the archive.

**The patch of 2026-10-05.** By the field's standard it is a model fix: a destructive `sort` on Emacs 28 and earlier is replaced by sorting a copy, a regression test fails without the fix, and the full suite of 166 tests passes. The fault was where the app saved it, a `Claude outputs/` folder inside the work tree. The house's answer, ignoring such folders in `.git/info/exclude` rather than a shipped `.gitignore`, uses git's per-clone ignore mechanism exactly as intended.

**The missing disclosure.** The 10-04 and 10-05 sessions wrote code for a package now in MELPA review, and MELPA asks for `;; Assisted-by: AGENT_NAME:MODEL_VERSION` under the Author line [8]. Whether card-games carries it was not checked (the repository was not reachable from here). The house's own footers write `Assisted-by: Mentat (for Corwin; claude-opus-5-5)`, which is right inside the house and wrong in a MELPA header: MELPA's `AGENT_NAME` is a product ("Claude"), and a persona name is not one. The house's own work-and-story rule already covers this: a commit or header shape owned by someone else is a must-follow form.

### 3.3 pu1sh, reviewed as code

`pu1sh` is 298 lines of POSIX shell, GPL-3.0-or-later with an SPDX line, depending on git, awk, `od` and `head -c` (POSIX since Issue 8, 2024 [38]), with a fallback when `mktemp` is absent. It is readable and changeable by its keeper, which is freedom 1 made practical. The levels (local, private, published, users, hand) are a policy idea none of the reviewed tools has: gitleaks, git-secrets, pre-commit and `reuse lint` know patterns, not audiences.

**Observed** (scratch copies; git 2.43, dash, mawk, bash):

| # | situation | result |
|---|---|---|
| 0 | `pu1sh --prove-red` under dash, under `PU1SH_AWK=mawk`, under bash | 21 of 21 pass, each run |
| 1 | `check --range deadbeef..HEAD` | "0 commit(s) checked; 0 flag(s)", exit 0 |
| 2 | hook installed; the slip pushed with `--force` over a remote tip never fetched | push succeeds; remote receives `BE16.png` and the log; "Invalid revision range... 0 commit(s) checked" |
| 3 | hook installed; slip pushed as a new branch in a `--object-format=sha256` repository | push succeeds; the hook compares against a 40-zero name, the remote's is 64 zeros |
| 4 | fetch URL unregistered, push URL registered `users`; slip pushed | graded "published", three ADVICE lines, push succeeds |
| 5 | added `claude.md` (lower case), `AGENTS.md`, `GEMINI.md`, `.cursor/rules` | 0 flags |
| 6 | added `setup.log` holding a Windows path and an auth failure | 0 flags |
| 7 | an existing real PNG modified into an HTML block page | 0 flags (only added files are byte-checked) |
| 8 | `github_pat_`, `glpat-`, `sk-ant-`, `ASIA…`, `AIza…` token shapes | 0 flags |
| 9 | ChatGPT and Gemini share links, a `ChatGPT-Session:` trailer | 0 flags |
| 10 | a Git LFS pointer named `.png` | FLAG MISNAMED (false positive) |
| 11 | message "Drop the claude.ai session trailer from the template" | FLAG LINK (false positive) |
| 12 | planted-fault switches in the code vs. those exercised by `--prove-red` | 5 exist (`no-link`, `no-secret`, `no-aimed`, `no-magic`, `crash`); 2 exercised |

The house reports that a read-only replay on the real card-games history flags exactly the three faults †. (The dagger marks a claim with one source; the history was not available here.)

**Judged.** Rows 1 to 3 share one root cause: `for c in $(commits ...)` discards git's exit status, so a range git cannot read becomes an empty list, and an empty list passes. That is the "comparison that never ran is reported as a pass" defect the house named in colophon the same day, and its own rule ("NOT checked is not CLEAN," the egress skill) condemns it. Rows 2 and 3 matter most because each lets the *whole* card-games slip through the very hook built from it. Row 4 is a classification from the fetch URL when git hands the hook the destination URL as `$2` [17a]. Rows 5 to 9 are coverage: AIMED and LINK know one vendor's file and domain names; the secret floor knows five patterns where gitleaks's default rule set is maintained by a community [34a]; MISNAMED looks only at added files. The script says plainly that the secret check is "a floor, not the full check," but the hook runs only the floor. Rows 10 and 11 are tolerable false positives with obvious exemptions. Row 12: for three of five checks a switch exists, but no test shows the harness going red without the check.

A tested repair for rows 1 to 4 (Recommendation 1) changes eight lines: NOT CHECKED (exit 2) when git cannot list the commits; an all-zeros object name of any length means a new or deleted ref; a remote tip that is not a local commit falls back to "not on any remote-tracking ref"; and the hook's `$2` is passed through a new `--url` option, with `git remote get-url --push` otherwise. With it the self-test still passes 21 of 21, row 1 exits 2 with "NOT CHECKED: git could not list the commits to check," and rows 2 to 4 each refuse the push with three FLAG lines.

## 4. The six questions

### 4.1 What is proven

- **The gate works on its fixture and fails open around it.** `pu1sh --prove-red` passes 21 of 21 under dash, mawk and bash; as shipped it lets the full slip through in three reproducible situations, and an eight-line change closes all three (Section 3.3). Evidence: the workshop's own tests plus reproducible probes. Confidence: high.
- **The garden's licence statements disagree with themselves** in 14 of 26 skill files, and 24 use a non-SPDX token. Evidence: counts any reader can redo with `grep`. Confidence: high.
- **Client-side hooks are advisory.** `--no-verify` bypasses them completely [17d]. Evidence: primary documentation. Confidence: high.
- **AI output is not authored in the copyright sense; human expression in or around it can be.** [27, 28]. Evidence: a federal appellate decision and an agency report (US only). Confidence: high for the rule, low for where the line falls in long directed sessions.
- **LLMs reproduce open-source code and mislabel copyleft licences at measurable rates** [24]; **secrets leak into public repositories at scale** [23]. Evidence: peer-reviewed. Confidence: high for the phenomena; their rates in this shop are unmeasured.

### 4.2 What is held

- **By the field:** that AI-assisted contributions are acceptable with human accountability and an `Assisted-by:` trailer (kernel, Fedora, MELPA, a GCC draft) [1, 7, 8, 31]; or that they are unacceptable because the DCO cannot be certified for them (QEMU, NetBSD, Gentoo) [4, 5, 6]. Both are policy positions, not findings, and they move: the kernel's trailer format changed between 7.1 and the current development documentation [1].
- **By the collaborators:** that "if we don't know that they have users they probably don't"; that a named reader is the right test for a signature; that self-healing heal prompts (`he1al`) shorten repair; that persona bylines ("NAME (for PRINCIPAL)") with copyright to the human principal describe authorship truthfully; and, Corwin's account, not yet put to Bryant, that the tools grew by *incremental tool synthesis*. None has a measurement yet, and drawer-vs-door's own "one command per re-sign" measurement rests on one observation †.

### 4.3 What synergizes

- "Claude verifies but never signs" is the kernel's DCO rule [1]; the hand level applies it to releases. The house already writes `Assisted-by:`, the trailer the field is converging on [1, 7, 8, 31].
- The 15-line attribute rung is GNU's threshold [10]; NOT CHECKED is Automake's skip/hard-error distinction [37]; "otherwise archive" is git's and SLSA's "never rewrite what others have" [17c, 19a].
- The two-reader rule (seams) is the logic of independent rebuilders [22] and multi-party records in in-toto [20]; the egress skill is what pre-push and pre-receive hooks are for.
- POSIX tools the keeper can change make freedom 1 practical, and his default rule ("pick the ones that make it easy to enable more clicks rather than the ones that make it hard to disable extra clicks," PREFERENCES.md) is Emacs's conservatism about defaults.

### 4.4 What challenges it

Each concern carries a falsifier.

- **A hook is a reminder, not a control.** An agent with a shell can pass `--no-verify`, and a new clone has no hook. The enforcing layer is the server (`pre-receive` on code.bru.st) or the forge's CI. *Falsifier:* Experiment 4 logs no bypass across 17 agent sessions (house number, invented).
- **The gate violates the house's own NOT CHECKED rule** (rows 1 to 3). It is uncomfortable that the same day's letter faulted a peer's tool for this shape. *Falsifier:* the fixed tool's `--prove-red` with the three new fixtures goes red when the fix is reverted.
- **vs Undeclared means advice.** The default ("published, no known users") turns every stop except SECRET into advice, so the gate's safety rests on the registry being complete. Free Software release practice would key on visibility (public is public). This is Corwin's explicit rule; this paper does not override it. *Falsifier:* Experiment 1 finds AIMED and MISNAMED produce false positives in his published histories, which would justify keeping them advisory.
- **`Co-Authored-By:` for a model borrows a human-authorship form.** The kernel's analogous `Co-developed-by:` requires the co-developer's own sign-off, a GCC draft prefers `Assisted-by:`, and copyright law does not treat the model as an author [3, 28, 31]. The work-and-story rule keeps `Co-Authored-By` lines as Corwin set them. *Falsifier:* MELPA review of card-games accepts the `Co-Authored-By:` commits without asking for the header line.
- **Copyleft may bind less than the copyright lines suggest.** Where text and code are substantially machine-written, the GPL and BY-SA notices may cover less than they claim [27, 28]. The workshop's records of the keeper's rulings, reviews and edits are its best evidence of human selection and arrangement, which is a reason to keep them, not to drop the licences. *Falsifier:* a licensing opinion (Experiment 6) that the shop's process plainly suffices.
- **The methods do not travel upstream unchanged.** QEMU, NetBSD and Gentoo refuse such patches by policy [4, 5, 6]; GNU projects that require copyright assignment [9, 10] raise the question of what can be assigned for machine-written lines. *Falsifier:* the target project's published policy permits the contribution as made.
- **The vendor's default inserts the session link and a co-author line** [36], so a gate that stops them becomes a recurring cost unless the default changes at source. *Falsifier:* after Recommendation 2, pu1sh records no LINK flag in agent commits for a month.
- **SPDX lines on drawer files may be ceremony a two-person shop does not need.** This does not block; Recommendation 5 is limited to what ships. *Falsifier:* a peer's tool misreads the licence of a drawer file that lacked one.

### 4.5 What is an obvious win

Five are cheap and low-risk, each detailed in Section 5: the eight-line fail-closed change to `pu1sh` (Rec. 1); `attribution.sessionUrl: false` in the *user* settings file, not a project's `.claude/` directory, which AIMED rightly blocks (Rec. 2); one line in public-stage step 1 (Rec. 2); a forward commit and MELPA's header line in card-games (Rec. 3); and one SPDX expression per file, minted once in `FOOTERS.org` (Rec. 5).

### 4.6 Which experiments are most valuable

Each is a falsifier with a rough cost. Costs in hours are invented house numbers (4, 9, 17) unless derived.

1. **False-positive census.** Replay the fixed `pu1sh` read-only over the full history of every repository Corwin has published. Claim tested: AIMED and MISNAMED are quiet enough to stop at the published level. Falsified by any false positive per check. Cost: about 4 hours. Value: decides the one point where his rule and the field's differ, from his own data.
2. **A second reader from a fresh spec, in another language.** Write the four checks as a one-page spec, implement them in Perl or Python without reading `pu1sh`, run both over the fixtures and the 12 probes. Claim tested: `pu1sh` does what its comments say. Falsified by any disagreement that is not a spec ambiguity. Cost: about 9 hours. This is Corwin's own standing rule for anything that got past the tests.
3. **Cross-tool replication.** Run gitleaks over the same histories and over a seeded corpus of current token formats; run `reuse lint` on the card-games tree at the 10-04 commit. Claims tested: the secret floor misses nothing real in his repositories; REUSE compliance would have caught both stray files. Falsified by a gitleaks finding the floor misses, or by `reuse lint` passing that tree. Cost: about 4 hours, once the tools are installed by the keeper.
4. **Bypass study.** For 17 agent sessions that push to users-level repositories, log every push command and refusal. Claim tested: a client-side hook is adequate policy for an agent. Falsified by one `--no-verify`, one remote rewrite, or one push from a fresh clone without the hook. Cost: log reading, about 4 hours. Value: scientific (agent behaviour at a gate) and social (it decides whether a server-side hook is needed).
5. **Reproducible door.** Run `make dist` twice on two machines from the same commit and compare `SHA256SUMS`. Claim tested: the signed sums describe a reproducible artifact. Falsified by any difference. Cost: about 4 hours.
6. **Licence clarity, asked of the experts.** Put two questions to the FSF's licensing team or the SFC: is "GPL-3.0-or-later with the LGPL's permissions" different from `LGPL-3.0-or-later`, and does the shop's record of human direction and review support the copyright lines on machine-drafted text? Falsified (for the current notices) by an answer that the forms differ materially or that the record does not suffice. Cost: an afternoon of writing, weeks of waiting. Value: mostly social; the answer would be public for other projects.

## 5. Recommendations (ranked)

**1. Make the gate fail closed.** The tested change:

```diff
-  for c in $(commits "$2"); do n=$((n + 1)); check_commit "$c" >> "$TMP/out"; done
+  cl=$(commits "$2") || notchecked "git could not list the commits to check (${range:-HEAD not on $2})"
+  for c in $cl; do n=$((n + 1)); check_commit "$c" >> "$TMP/out"; done
...
-  [ -n "$r" ] && { url=$(G remote get-url "$r" 2>/dev/null) || notchecked "no remote named $r"; }
+  if [ -n "$url_arg" ]; then url=$url_arg
+  elif [ -n "$r" ]; then url=$(G remote get-url --push "$r" 2>/dev/null) || notchecked "no remote named $r"; fi
...  (in the hook text)
-  [ "\$lsha" = "\$z" ] && continue
-  if [ "\$rsha" = "\$z" ]; then rng="\$lsha --not --remotes=\$1"; else rng="\$rsha..\$lsha"; fi
-  sh "$here/pu1sh" check --remote "\$1" --range "\$rng" || st=\$?
+  case \$lsha in *[!0]*) ;; *) continue;; esac
+  rng="\$lsha --not --remotes=\$1"
+  case \$rsha in *[!0]*) git cat-file -e "\$rsha^{commit}" 2>/dev/null && rng="\$rsha..\$lsha";; esac
+  sh "$here/pu1sh" check --remote "\$1" --url "\$2" --range "\$rng" || st=\$?
```

plus a `--url` argument and the removal of the 40-zero constant. Add rows 2, 3 and 4 of Section 3.3 to `--prove-red` as fixtures, and use the three unexercised plants. A check after the change:

```
sh bin/pu1sh check --range deadbeef..HEAD; echo $?
```
- [ ] SEE `NOT CHECKED: git could not list the commits to check` then `2`

**2. Stop the trailer at its source.** In the user settings file, `"attribution": {"sessionUrl": false, "commit": "Assisted-by: Claude:<model>"}` [36]; the documentation names cloud and Remote Control sessions, and whether the desktop app that made the 10-04 commits honours it is NOT CHECKED. Fix public-stage step 1. For MELPA, write the header line in MELPA's form, not the persona's.

**3. Close the card-games slip the sane way.** Forward commit, no history rewrite, no re-tag; check the recipe's `:files` for images; sign the next release tag, which has a named reader (anyone checking the release; the keeper usually signs tagged releases). SSH signing is simpler to set up and gitsign avoids long-lived keys at the cost of an outside identity provider and a public log [18, 21]; nothing here argues for leaving the shop's published OpenPGP key.

**4. Put the check where it cannot be skipped.** For repositories declared `users`, run the same checks in a `pre-receive` hook on code.bru.st (enabling Forgejo's custom hooks for the administrator only, mindful of its code-execution warning [35]) or in the forge's CI. Keep the client hook as fast feedback. In the layered-assurance skill's terms, the client hook is the "count the cards" floor and the server is the core.

**5. One licence statement per file, machine-readable.** Generate `SPDX-License-Identifier: CC-BY-SA-4.0` on prose, `GPL-3.0-or-later` on code, and an `AND` expression only where a file truly mixes both; write the LGPL form as `LGPL-3.0-or-later` or a documented `LicenseRef-`; bring TERMS v1 to BY-SA; run `reuse lint` in egress.

**6. Delegate the secret catalogue.** At the users level, run `c4 secrets-run` or gitleaks over the pushed range [34a]; when neither is available, print NOT CHECKED and stop, with a named off switch (for example `PU1SH_SECRETS=floor`), as the public-stage form asks of every check.

**7. Widen coverage, vendor-neutrally.** AIMED: lower-case `claude.md`, `AGENTS.md`, `GEMINI.md`, `.cursor/`, `.aider*`, `.github/copilot-instructions.md`, and logs by content (local paths such as `C:\Users\`) rather than by name. LINK: other vendors' share hosts and any `*-Session:` trailer key. MISNAMED: modified files too, with Git LFS pointers exempt. LINK in messages: match URLs, not mentions of the domain.

## 6. Limitations

The card-games repository was not reachable at the addresses tried, so the case study's facts and the replay result rest on the workshop's account; the paper reproduced the slip as a fixture, not the history itself. `reuse lint`, gitleaks and busybox were not run. The legal sources are US-only. Policies here change quickly (the kernel's trailer format differs between its 7.1 and current development documentation), and three sources are news [30, 32, Fedora's approval in 7]. Fedora's final policy page and one FSF licensing essay could not be fetched and are not cited. A release engineer's lens favours upstream conventions; the keeper's top block rightly warns against importing process "before/unless you can articulate... the lift to those our labors most properly may serve," and several recommendations here (server hooks, SPDX everywhere) should be read against that test, which is why each is limited to what ships.

## 7. Methods

**Sources.** All pack files named in the brief were read in full (BRIEF, `pu1sh.sh`, the three `advice/` designs and finding, `attribution-ladder.md`, `keeper-top-block.md`, `work-and-story-2026-10-05.md`, `PREFERENCES.md`, `C4.md`, the evening hand-back, the letter, and the skills listed below). External references were located with web search and opened with a page fetcher; every cited item was opened, and claims are cited only to what the fetched page showed. Peer-reviewed sources [20–24], a peer-reviewed dataset paper [25] and a preprint [26] are kept apart from news [30, 32, Fedora approval in 7]. No private conversation is quoted; the FINDING's conclusions are cited, not its paraphrases of messages.

**Execution.** `pu1sh.sh` (the case-study artifact, not a skill) was copied into a disposable scratch directory and run under dash, mawk and bash against throwaway local repositories and bare remotes; nothing was installed, and nothing outside the scratch directory and this paper was written. The repair in Recommendation 1 was applied to a second scratch copy and the self-test and probes were rerun against it.

**Workshop skills applied as methods.**
- *drawer-vs-door*: the named-reader test decided which signatures to recommend (the next release tag) and not to recommend (anything in the drawer), and framed the session URL as a reference with no reader who can follow it.
- *prove-a-promise*: `pu1sh`'s promise ("flags exactly the three faults") was split into the universal check (green control plus planted faults, which pass) and a coverage check, which found that only two of five plants are exercised and that unreadable ranges are never covered.
- *hand-test*: every command whose result is reported, including the check in Recommendation 1, was run before being written down.
- *countable-gauge*: licence disagreement, planted-fault coverage and probe outcomes are reported as counts (14 of 26, 2 of 5, rows 1 to 12), not adjectives.
- *seams*: used to find three splits between two representations of one truth (SPDX line vs footer; public-stage vs the 10-05 rule; fetch URL vs push URL), and to mark single-sourced claims with †.
- *layered-assurance*: placed the client hook as the observation floor and the server-side hook as the enforcing core (Recommendation 4).
- *egress* (soft skill): its rule "NOT checked is not CLEAN" was the criterion that turned rows 1 to 3 into defects rather than edge cases.
- *public-stage* (soft skill): its form was compared with REUSE and MELPA practice, which found the stale trailer instruction and supplied the "named off switch" in Recommendation 6.

**Not checked.** The card-games history and MELPA recipe; whether card-games carries an `Assisted-by` header; whether `attribution.sessionUrl` governs the desktop app; REUSE's handling of a trailing period after an identifier; Forgejo's per-repository hook interface beyond its configuration flag.

## References

1. Linux kernel documentation, "AI Coding Assistants" (`process/coding-assistants`), development version as fetched 2026-10-05: https://docs.kernel.org/process/coding-assistants.html ; 7.1 source: https://docs.kernel.org/7.1/_sources/process/coding-assistants.rst.txt
2. S. Levin, "[PATCH v2] docs: add AI Coding Assistants documentation," linux-kernel mailing list, 2025-12-23: https://lkml.iu.edu/hypermail/linux/kernel/2512.2/04871.html
3. Linux kernel documentation, "Submitting patches": https://docs.kernel.org/process/submitting-patches.html
4. Gentoo Council, "AI policy" (adopted 2024-04-14): https://wiki.gentoo.org/wiki/Project:Council/AI_policy
5. NetBSD, "Commit Guidelines," section 2: https://netbsd.org/developers/commit-guidelines.html
6. QEMU, "Code provenance" (developer documentation): https://www.qemu.org/docs/master/devel/code-provenance.html
7. Fedora Council, "Council Policy Proposal: Policy on AI-Assisted Contributions," 2025-09-25: https://communityblog.fedoraproject.org/council-policy-proposal-policy-on-ai-assisted-contributions/ ; approval reported (news): GamingOnLinux, 2025-10-23: https://gamingonlinux.com/2025/10/fedora-linux-project-agrees-to-allow-ai-assisted-contributions-with-a-new-policy
8. MELPA, "CONTRIBUTING.org" (section "Attribution for AI-generated code"): https://github.com/melpa/melpa/blob/master/CONTRIBUTING.org ; 8b. MELPA README (default `:files`): https://github.com/melpa/melpa/blob/master/README.md
9. GNU Emacs, `CONTRIBUTE` (GitHub mirror): https://github.com/emacs-mirror/emacs/blob/master/CONTRIBUTE
10. GNU Maintainers' Information, "Legally Significant Changes": https://www.gnu.org/prep/maintain/html_node/Legally-Significant.html
11. GNU Coding Standards, "Change Logs": https://www.gnu.org/prep/standards/html_node/Change-Logs.html
12. GNU Lesser General Public License, version 3: https://www.gnu.org/licenses/lgpl-3.0.html
13. Creative Commons, "CC BY-SA 4.0 now one-way compatible with GPLv3," 2015-10-08: https://creativecommons.org/2015/10/08/cc-by-sa-4-0-now-one-way-compatible-with-gplv3/
14. SPDX License List, "CC-BY-SA-4.0": https://spdx.org/licenses/CC-BY-SA-4.0.html
15. REUSE Specification 3.3 (2024-11-14): https://reuse.software/spec-3.3/ ; reuse-tool: https://github.com/fsfe/reuse-tool
16. Developer Certificate of Origin 1.1: https://developercertificate.org/
17. Git documentation: 17a. githooks: https://git-scm.com/docs/githooks ; 17b. git-tag ("On Re-tagging"; `-s`, `gpg.format`): https://git-scm.com/docs/git-tag ; 17c. git-rebase ("Recovering from upstream rebase"): https://git-scm.com/docs/git-rebase ; 17d. git-push (`--no-verify`): https://git-scm.com/docs/git-push
18. GitHub Blog, "Highlights from Git 2.34," 2021-11-15 (vendor blog): https://github.blog/open-source/git/highlights-from-git-2-34/
19. SLSA v1.2: https://slsa.dev/spec/v1.2/ ; 19a. Source track requirements: https://slsa.dev/spec/v1.2/source-requirements ; 19b. Build track basics: https://slsa.dev/spec/v1.2/build-track-basics
20. S. Torres-Arias, H. Afzali, T. K. Kuppusamy, R. Curtmola, J. Cappos, "in-toto: Providing farm-to-table guarantees for bits and bytes," USENIX Security 2019 (peer-reviewed): https://www.usenix.org/conference/usenixsecurity19/presentation/torres-arias
21. Z. Newman, J. S. Meyers, S. Torres-Arias, "Sigstore: Software Signing for Everybody," ACM CCS 2022 (peer-reviewed), doi:10.1145/3548606.3560596 ; gitsign documentation: https://docs.sigstore.dev/cosign/signing/gitsign/
22. C. Lamb, S. Zacchiroli, "Reproducible Builds: Increasing the Integrity of Software Supply Chains," IEEE Software 39(2):62–70, 2022 (peer-reviewed), doi:10.1109/MS.2021.3073045 ; definition: https://reproducible-builds.org/docs/definition/
23. M. Meli, M. R. McNiece, B. Reaves, "How Bad Can It Git? Characterizing Secret Leakage in Public GitHub Repositories," NDSS 2019 (peer-reviewed): https://ndss-symposium.org/ndss-paper/how-bad-can-it-git-characterizing-secret-leakage-in-public-github-repositories
24. W. Xu, K. Gao, H. He, M. Zhou, "LiCoEval: Evaluating LLMs on License Compliance in Code Generation," ICSE 2025 (peer-reviewed): https://conf.researchr.org/details/icse-2025/icse-2025-research-track/73/LiCoEval-Evaluating-LLMs-on-License-Compliance-in-Code-Generation ; preprint: https://arxiv.org/abs/2408.02487
25. T. Xiao, C. Treude, H. Hata, K. Matsumoto, "DevGPT: Studying Developer-ChatGPT Conversations," MSR 2024 Mining Challenge, doi:10.1145/3643991.3648400 ; https://arxiv.org/abs/2309.03914
26. T. Xiao, Y. Fan, F. Calefato, C. Treude, R. G. Kula, H. Hata, S. Baltes, "Self-Admitted GenAI Usage in Open-Source Software," arXiv preprint 2507.10422: https://arxiv.org/abs/2507.10422
27. U.S. Copyright Office, "Copyright and Artificial Intelligence, Part 2: Copyrightability," released 2025-01-29: https://copyright.gov/newsnet/2025/1060.html
28. *Thaler v. Perlmutter*, No. 23-5233 (D.C. Cir. 2025-03-18): https://media.cadc.uscourts.gov/opinions/docs/2025/03/23-5233.pdf
29. Software Freedom Conservancy, "Recommendations When Using LLM-backed Generative AI Systems for FOSS Contributions" (2024): https://sfconservancy.org/llm-gen-ai/llm-backed-generative-ai-recommendations.html
30. LWN.net (news), "The FSF considers large language models," 2025-10-14: https://lwn.net/Articles/1040888/
31. J. Wakely, "Policy on use of LLM tools and bug fixes," gcc mailing list, 2026-04-17 (discussion of a draft): https://gcc.gnu.org/pipermail/gcc/2026-April/247987.html
32. The Register (news), "Curl shutters bug bounty program to remove incentive for submitting AI slop," 2026-01-21: https://www.theregister.com/2026/01/21/curl_ends_bug_bounty/
33. GitHub Docs: 33a. "Creating a commit with multiple authors": https://docs.github.com/en/pull-requests/committing-changes-to-your-project/creating-and-editing-commits/creating-a-commit-with-multiple-authors ; 33b. "Removing sensitive data from a repository": https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository
34. 34a. gitleaks: https://github.com/gitleaks/gitleaks ; 34b. git-secrets: https://github.com/awslabs/git-secrets ; 34c. pre-commit: https://pre-commit.com/ and pre-commit-hooks: https://github.com/pre-commit/pre-commit-hooks
35. Forgejo, "Configuration Cheat Sheet" (`DISABLE_GIT_HOOKS`): https://forgejo.org/docs/latest/admin/config-cheat-sheet/
36. Anthropic, Claude Code documentation, "All settings" (`attribution`, `attribution.commit`, `attribution.sessionUrl`; vendor documentation): https://code.claude.com/docs/en/settings-reference.md
37. GNU Automake manual, "Scripts-based Testsuites" (exit statuses 77 and 99): https://www.gnu.org/software/automake/manual/html_node/Scripts_002dbased-Testsuites.html
38. POSIX.1-2024 (Issue 8), `head`: https://pubs.opengroup.org/onlinepubs/9799919799/utilities/head.html


## Errata (after review, 2026-10-05)

- The bracketed concern tags ([HIS], [DOMAIN], [SKILL], [PLATFORM], [MINE]) are removed. The keeper retired them on 2026-09-24; the LENS skill still asked for them, and that line is now fixed.
- The card-games repository is public at `https://code.bru.st/corwin/card-game.el` (the paper tried
  `card-games`, which does not exist). The commissioning session cloned it there and replayed the
  gate on `ff7a9f6..e78fe38`: it flags exactly the three faults (`BE16.png`, MISNAMED; the shell
  log, AIMED; e78fe38's session link, LINK). The claim marked with a dagger is now checked.
- Recommendation 1 is done, with the paper's rows 2 to 4 as fixtures. `pu1sh` has changed since this paper reviewed it; its new shape is in the set's preface
  (README.md).
- `public-stage` step 1 no longer asks for the session trailer (garden commit 8743b5d).

---
*Version 1.0.1: edition revised from 1.0.0 on 2026-10-05; spine: 2026-10-05.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/

Assisted-by: Mentat (for Corwin; claude-opus-5-5)
