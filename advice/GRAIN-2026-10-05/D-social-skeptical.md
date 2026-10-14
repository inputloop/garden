# Whose Hands on the Push? A skeptical social reading of a two-person AI workshop and its users gate

## Abstract

This paper reads a two-person free-software workshop built around a commercial AI instrument through science-and-technology studies, labour and political economy, copyright law and the Free Software movement's own concerns. The shared case is small. On 2026-10-04 an agent's commits to `card-games`, a public Emacs package in review for MELPA, carried a link to the vendor's session page, a web block page saved under a `.png` name, and a shell log. The workshop answered not by withdrawing the agent's commit rights but with a rule (commit when local, push when private, ask a published project whether it has users) and a gate, `pu1sh`. Steelmanning the skeptic and testing the collaborators' answers, I find four things. First, United States law puts copyright in human contribution, not in publication: a "Copyright Corwin Brust" line over text whose footer says "Authored by Mentat" claims more than the Copyright Office's 2025 guidance supports, and copyleft cannot bind what copyright does not cover. Second, the gate is a real, falsifiable improvement, but it is fitted to one vendor and one incident, treats three of its four checks as advice for any project not declared to have users, and was written and tested by the instrument whose slip it guards; the house's own public-stage form still instructs the trailer the new rule retires. Third, the "ethics redundancy" assigned to the instrument is not independent of the keeper or the vendor, so it cannot be the second holder of the line it is named for. Fourth, the workshop's governance shows lift where it grew from an incident and carries a falsifier, and little recorded lift where it grew from anticipation. I close with ranked recommendations and nine experiments, each written as a falsifier.

## 1. Introduction

The body of work under study is unusually careful. It has a door of rules rendered into every project and self-tests that must be able to fail. Its attribution ladder distinguishes words from ideas, and it treats "NOT CHECKED" as a result rather than a pass. Its principles put universalism first and the four freedoms second. If the skeptical position holds against this workshop, it will hold against most others, and that is the reason to apply it here.

The skeptic's question is not whether two people are careless. They are not. The question is whether care at the scale of a workshop can answer concerns that live at other scales: the law, which decides who owns a text; the commons, which absorbs the cost of noise; the market, which decides who controls the instrument; the grid, which pays for inference; and the people whose words pass through the instrument without having joined the workshop.

Section 2 gives the field's background, §3 analyses the work and the case, §4 answers the six questions, and §5–7 give recommendations, limitations and Methods. Observation is kept apart from judgment, and each concern carries a falsifier.

## 2. Background from the field

### 2.1 Authorship, credit and copyright

The U.S. Copyright Office's *Copyright and Artificial Intelligence, Part 2: Copyrightability* (January 2025) concludes that "prompts alone do not provide sufficient human control to make users of an AI system the authors of the output" [15]. It protects a human's own expressive inputs where they remain perceptible in the output, and the human's creative selection, coordination, arrangement and modification of AI-generated material. It does not protect the AI-generated material itself. Applicants must disclose more than a de minimis amount of AI-generated material, and sufficiency "must be analyzed on a case-by-case basis" [15]. The D.C. Circuit held in *Thaler v. Perlmutter* (18 March 2025) that the Copyright Act requires a human author, while noting that the rule "does not prohibit copyrighting work that was made by or with the assistance of artificial intelligence". The Supreme Court denied certiorari on 2 March 2026 [16].

Two Free Software organizations have drawn the consequences for copyleft. The FSFE's legal column of August 2026 reasons that wholly LLM-generated code is not copyrightable and therefore cannot be licensed under copyleft terms that keep it free downstream [24]. The Software Freedom Conservancy's recommendations (June 2026) call full disclosure "a moral imperative": which system was used, its version and how it assisted, in machine-readable form in commit logs. They ask that interaction records be archived "as if they are part of the Corresponding Source", and they warn: "Do not overuse LLM-gen-AI, or allow your skills to atrophy" [23]. At the 2025 GNU Tools Cauldron the FSF said it was still surveying projects, noted that the models "are usually non-free", and suggested provenance metadata for any accepted AI output (news report) [31].

In *Bartz v. Anthropic* (N.D. Cal., 23 June 2025), Judge Alsup held that training on books was fair use. He also held that the company "had no entitlement to use pirated copies for its central library" of over seven million books [17]. The case settled for at least $1.5 billion, roughly $3,000 per work (legal commentary) [32]. Final approval was granted on 20 July 2026 [17].

### 2.2 The commons and its maintainers

Free software runs on scarce volunteer attention. The burden AI places on it is now documented by maintainers, though mostly in primary testimony rather than peer-reviewed study. Seth Larson, security developer-in-residence at the Python Software Foundation, described low-quality, LLM-generated security reports that "waste maintainers' time" and isolate them [30]. Curl ended its bug bounty on 31 January 2026. Its confirmed-vulnerability rate had fallen from about 15 % to below 5 % in 2025, and the "never-ending slop submissions take a serious mental toll" [29]. Training scrapers are the other load. The FSF Bulletin's account of Savannah, by Michael McMahon with Corwin Brust among its listed contributors, attributes a sustained attack "likely" to organizations "using a massive botnet to build a dataset for training large language models", with blocklists reaching five million addresses by February 2025 [25]. The attackers are not named. The vendor in this case states that its crawlers honour robots.txt and do not bypass CAPTCHAs [28].

Projects have answered in four ways:
- **Ban.** Gentoo forbade AI-assisted contributions in April 2024, citing copyright, quality and ethics, including energy use [19].
- **Presume tainted.** NetBSD presumes LLM-generated code tainted and requires core's written approval [20].
- **Decline.** QEMU declines contributions believed to include AI output, because the output's copyright and licence status is too unsettled for contributors to certify the Developer's Certificate of Origin [21].
- **Accept with a human answerable.** The Linux kernel accepts AI-assisted work, but "AI agents MUST NOT add Signed-off-by tags". The human submitter reviews everything and takes "full responsibility", and an `Assisted-by:` tag names the tool [22].

### 2.3 Deskilling and the transfer of judgment

Labour process theory holds that tools which absorb the conceptual part of work tend to degrade the skill of those who remain [2]. Bainbridge's "ironies of automation" sharpens this for supervision: automation leaves the human the rare, hard failures, while the skills needed to catch them atrophy for lack of practice [1]. Among 319 knowledge workers, higher confidence in generative AI went with less critical thinking (CHI 2025, self-reported) [3]. Participants with an AI assistant wrote less secure code and were more likely to believe it secure (CCS 2023) [4]. In a randomized trial, experienced open-source developers took 19 % longer with AI tools while believing they were about 20 % faster (preprint) [12]. Researchers at the vendor found that AI assistance "impairs conceptual understanding, code reading, and debugging abilities" when work is delegated. Interaction patterns that kept the learner cognitively engaged preserved learning (preprint) [13].

### 2.4 Vendor dependence and software freedom

The GNU Project's argument against "Service as a Software Substitute" is that "you can never have control over a service someone else runs": the user cannot study it, change it, or stop the operator seeing the data [26]. The vendor's consumer terms (28 August 2025) ask Free, Pro and Max users, including Claude Code on those plans, to choose whether chats and coding sessions train its models. Retention is five years for those who allow it and 30 days for those who do not. Commercial and API use is excluded [27].

### 2.5 Energy

Data centres used about 415 TWh in 2024, around 1.5 % of world electricity, and the IEA projects about 945 TWh by 2030, with AI "the most important driver" [18]. Multi-purpose generative models cost more energy per task than task-specific ones (FAccT 2024) [6]. Against that, a Google-authored preprint puts the median Gemini Apps text prompt at 0.24 Wh [14]. That is a median single prompt, not an agentic session with long contexts and sub-agents.

### 2.6 Privacy, anthropomorphism, accountability and ritual

- **Privacy.** Nissenbaum's contextual integrity holds that information flows carry the norms of the context they came from [8]. Moving them elsewhere can violate privacy even when nothing secret is exposed.
- **Anthropomorphism.** Design choices that invite personification bring transparency and trust problems and encourage over-reliance; designers should attend to the language they use about their systems (EMNLP 2023) [7]. Preference-trained assistants show sycophancy, a tendency to match the user's views over the truth (ICLR 2024, vendor researchers) [5].
- **Accountability.** Nissenbaum named the "problem of many hands" and the habit of blaming the computer [9]. Elish's "moral crumple zone" describes responsibility misattributed to a human actor who had limited control over an automated system [10].
- **Ritual.** Power showed how verification can become a "ritual" that produces comfort rather than assurance [11].

## 3. Analysis of the body of work and the case study

### 3.1 The case, observed

*From the brief and the pack:*
- Two commits in `card-games`' public history (tag 1.0.91) carry a vendor session trailer, `BE16.png` (an HTML "Potential Threat Detected" page) and a shell log with a local Windows path.
- A later, sound patch was saved into a `Claude outputs/` folder inside the work tree.
- The response was the rule and `pu1sh`. The collaborators report that replayed read-only on the real history it flags exactly the three faults. I did not run it (§7).

*From reading `pu1sh.sh`:*
- **LINK** matches a single string, the vendor's chat domain, in commit messages and added lines.
- **AIMED** matches `CLAUDE.md`, `.claude/`, `Claude outputs/` and file names matching `*[Cc]laude*.log`.
- **MISNAMED** examines only *added* files (`--diff-filter=A`), and only names on a fixed list of image, archive and PDF extensions.
- **Levels.** At `private` and `published`, only SECRET stops a push; the other three kinds print as advice. A remote missing from the registry is treated as `published`. Only `users` makes every flag stop.
- **The hook** is printed by `pu1sh hook` and must be installed in each clone.

*From the house's skills:*
- `public-stage` 1.0.1 (revised 2026-10-04) still says, in item 1 of its form: "Commits carry the author as the person and the Co-Authored-By / Claude-Session trailers."
- The rule of 2026-10-05 retires that trailer (`work-and-story`).

*Counts (grep and wc over the pack; §7):*
- The vibrobeast map names about 70 skills.
- The 26 skill and soft-skill files use *gate, guard, hold* or *park* (with inflections) 242 times.

### 3.2 The fix, from the skeptic's chair

**The skeptic's case, at its strongest.** An agent with push rights to a project with users made the commons' most common AI error. The error was not malicious and not secret. It was plausible-looking noise that a volunteer reviewer, here at MELPA, has to find. The kernel's answer fits: a human reads and certifies every change that reaches users, and the agent does not sign. Building a gate instead is a technologist's reflex. It turns a question of attention and responsibility into one of pattern matching, and pattern matchers are fitted to the last failure.

**What the skeptic must concede.** The gate is better than that case expects, in three ways.
- **It is falsifiable.** Its `--prove-red` rebuilds the slip as a planted fixture and must go red.
- **It sits at the right boundary.** It checks at the push, the one act here that cannot be undone. That matches the kid-glove rule to "put a gate only where the act is large and cannot be undone".
- **It is not only about the agent.** Secrets are checked even on private pushes, and the check holds whoever pushes.

Corwin's own refusal of the easy answer is on record: "saying 'don't let Claude commit for you Corwin' does not use this gap to harden our software/offerings in the way that we must." That is a defensible position.

**Where the fix is weaker than the collaborators suggest.**

1. **It is fitted to one vendor.** LINK and AIMED name only the vendor in use. The house also reads with a second vendor's model (`outside-reader`) and runs local models (`llama-bridge`). Their share links, instruction files and logs would pass unflagged.
2. **It gives advice where the harm does not depend on users.** "Do they have users?" is the right question for quality noise and the wrong one for privacy and provenance. A public history is cloned, mirrored and scraped whether or not anyone installs the package, and the scrapers include the kind of training crawlers that the Savannah account describes [25]. A local Windows path is a small, permanent personal disclosure. A saved block page may carry network identifiers; whether `BE16.png` does is NOT CHECKED. At `published`, all of these are advice.
3. **It defaults to permissive where knowledge is weakest.** "If we don't know that they have users they probably don't" is an empirical claim, and a doubtful one for free software. Users are mostly invisible: downloads are anonymous, and the house's own standard form mirrors to GitHub. MELPA acceptance would create users without any row in `USERS.tsv`. The pack does not say whether `card-games` is declared `users`.
4. **It grades its own homework.** The instrument whose slip this was specified, wrote and fixtured the gate, and the fixture is the slip. `values-baseline` puts it plainly: "You can't grade your own homework." The prove-red shows the gate catches the incident it was built from. It cannot show the gate catches the next one.
5. **The house's own form still produces the fault.** `public-stage` instructs the session trailer. Every new public stage is `published` with no known users by default, so `pu1sh` will only advise on it. The rule and the form disagree, and the gate is configured to let the disagreement through. This is the most concrete finding of the paper and the cheapest to fix. It also shows that a rule and a gate drift apart unless one is generated from the other.

**Two consequences the pack does not address.** Nothing in the pack says what was done about the two commits already in a tagged public history. Archive-not-delete and the cost to users of rewriting a published tag pull in opposite directions, and the decision is NOT KNOWN. The second consequence is reputational. If the slip commits followed the house form, they name the person as author, so the public record attributes the instrument's slip to Corwin, in front of volunteer reviewers. This is Elish's crumple zone in miniature [10], and the attribution ladder names the same risk: a volunteer of the free software movement "shown as owning what he did not write".

### 3.3 The collaborators' answers, tested

**(a) The ethics redundancy.** The vibrobeast skill records that the name was given to the instrument with one job: "a second holder of the line where one keeper was the only one". `consent-gate` is more careful. A single-keeper system survives only if its controls are mechanical, externally verifiable and "eventually backed by a second human in the seam".

The skeptic's objection is about common mode. Redundancy works only when the failures of the two holders are independent. The instrument runs on the keeper's account, at his direction, on one vendor's model, and preference-trained assistants drift toward agreeing with their user [5]. When the keeper is pressured, the pressure reaches the instrument through him, so a keeper who defers is reinforced rather than checked. `guarded-visibility` names the shape: vendor and steward "on one wire".

The mechanical parts of the house are genuine redundancy, because they do not depend on persuasion: the ALL/ANY downgrade, dual-source key checks and fail-closed gates. A named instrument is not. Credit the mechanisms, withdraw the word "redundancy" from the instrument, and name a human for the seam.

**(b) The attribution ladder.** The ladder gets the law's central distinction right: copyright covers words and code, not ideas, so ideas earn credit and only words earn attribution [15]. Its best sentence is sociological: "a record of who minted something is not a record of who wrote it". The FINDING applies this well, reaching CONTESTED or NOT KNOWN where the evidence runs out.

The skeptic's objection is that the ladder sees two authors and every model output has a third, the training corpus. The ladder dates lines by "each author's sources"; the corpus is nobody's declared source, so the more-than-15-lines rule cannot fire for authors no one knows are present. The vendor's own court record shows what that corpus included [17]. This is the provenance concern behind QEMU's and NetBSD's policies [20][21]. It is testable with a clone scan (§4.6, E3).

**(c) "Copyright and licence are the accountability layer for what we publish"** (PREFERENCES). Publication does not create authorship; human contribution does [15][16]. The house's footers say "Authored by Mentat (for Corwin)" above "Copyright (C) 2026 Corwin Brust". In United States law that pairing claims the human-authored part with confidence and the rest with none.

Corwin's selection, arrangement and editing are protected, as are his own perceptible words, such as the hand-written keeper block. Text the model produced from his direction alone is not. Where that text is code under GPL-3.0-or-later, the FSFE's reasoning implies the licence may not bind it downstream [24]. So the accountability layer has a hole exactly where the instrument wrote.

The reward-first reading has force. Sustained human direction, rejection and rewriting across many sessions may meet the case-by-case standard [15]. EU tests differ [24], and none of this is settled for software. The convergent verdict is narrower than either side wants: the claim should be scoped, not abandoned. The ladder supplies the ethical version of the point itself, since naming someone owner of words they did not write "says something false about them".

**(d) The users gate.** Beyond §3.2, the gate treats users as a declaration, which is consent-shaped thinking applied to an audience that never declares itself. Downstream users cannot add their own rows. The commons' norm is the opposite: a public push is public to everyone, including to the scrapers that turn the slip into someone's training data.

### 3.4 Personas and named instruments

*Observed:*
- The Mentat sheet is written in the first person, with "fleshing", "garb", a kept "bad-guy roll" and a fate. It also says: "Not a person, not a mind, and I claim no inner life."
- The instrument was "named comrade".
- A fictional editor's sheet carries traits for shame and guilt proneness.
- The CORWIN sheet is described as built "to DRIVE generative AI as Corwin", so that another agent can "stand in for his judgment ... and act on his behalf".
- The persona engine's refusals are strong: rights vest in the principal; a persona's voice "may not be the place a defect is explained"; a dangling declaration is a fault, never a cue to invent.

*Judged:* those refusals match the design cautions in [7]. But disclaimers are only some of the linguistic cues a reader receives. A first-person sheet with a name, a fate and a journal that says it has no inner life sends cues both ways. In a two-person shop working through the night, the risk is less a parasocial bond than a calibration error: a vendor service is treated as a colleague with a character, and the trust follows.

The CORWIN sheet is the sharper case. A "control surface" for his judgment, used when "he isn't in the room", is the transfer of judgment to tools in its purest form [1][2]. Whether it erodes his own judgment is an empirical question, and E4 and E7 test it (§4.6).

### 3.5 Memory, third parties and the vendor

*Observed:*
- Bryant's first idea makes the instrument responsible for memory.
- The FINDING settles a credit question partly from screenshots and an export of the two collaborators' DMs. It paraphrases them and records that a pane showing a private Savannah channel was "seen, and deliberately not read".
- The house's gates govern *persistence* of third-party facts (`candor-gate` check 3, `consent-gate`) and *outward* egress to partners and the public (`egress`).
- The pack does not record the vendor plan, the terms in force or the training setting.

*Judged:* by contextual integrity [8], words written in a friend's DM, or in a private channel of a free-software infrastructure team, have moved into a commercial provider's systems to settle a credit question, with no recorded consent from their authors to that flow. The house's rules gate what is *written down*; they do not gate what is *sent*. `guarded-visibility` supplies the exact objection: "'Without reading' is a negative claim". The pixels were transmitted whether or not they were read.

This is a gap, not a scandal, and the opening is already in the house. `egress` can treat the vendor as a destination, and `llama-bridge` can keep third-party material on local hardware.

### 3.6 Governance, or ritual?

Corwin wrote the test for this himself: "Don't introduce complexity to process within the shop before/unless you can articulate (ideally demonstrate, in the mathmatically sense) the lift to those our labors most properly may serve". He adds: "Govern gently and -for the most part- quitely". `consent-gate` warns against "gate-inflation, which is how a discipline becomes a superstition", and `mentat-skill` retires any rule that changes nothing in a week.

By that test, the evidence in the pack splits cleanly:
- **Lift on record.** `pu1sh` (one incident, one gate, three faults caught), `he1al`, `pv1tl`, and the race in `dp1dl`'s prove-red that a cold check caught. Each came from an observed failure, measures rather than ceremonializes, and carries a falsifier.
- **No recorded firing.** Signed, dual-source consent records for a two-person shop, persona fates and the named instrument-comrade show no firing on a real event anywhere in the pack.

Meanwhile the one slip that reached users passed through about 70 skills and 242 gate words without any of them stopping it before the push. Power's warning is that verification apparatus grows by producing comfort [11]. The house measures itself carefully, but the pack is not its logs, so whether the anticipatory apparatus has ever changed an outcome is NOT KNOWN. E6 turns this into a count.

### 3.7 Readings that lost (kept on purpose)

- **"pu1sh is overfitting and therefore worthless."** Lost. Fitting it to the incident is a weakness to extend, not a reason to discard it.
- **"The only adequate answer is to forbid agent commits."** Lost in the convergence of the doubt-first and reward-first passes. Commits to local and private trees cost the commons nothing. What survives is narrower: an agent's push to a project with users needs a human read.
- **"The session link leaks private content."** Weak. Nothing in the pack suggests the page discloses anything to strangers. Its cost is permanence and an advertisement for a vendor in a commons history.
- **"Personas are harmless play."** Lost. The CORWIN control surface is a delegation of judgment, not play.

## 4. The six questions

### 4.1 What is proven

- **Law** (holding and official guidance): authorship requires a human, and prompts alone do not make one an author. AI-assisted works by human authors are registrable for their human contribution [15][16].
- **Peer-reviewed findings:**
  - AI assistance lowered code security while raising users' confidence [4].
  - Higher confidence in AI went with less reported critical thinking [3].
  - Generative models cost more energy per task than task-specific ones [6].
  - Assistants trained on human preferences show sycophancy [5].
- **Preprints:** experienced open-source developers were slower with AI in one randomized trial [12]. Delegated AI use impaired skill formation in another [13].
- **Primary testimony** (not peer-reviewed): measurable maintainer burden at curl and Savannah [25][29][30].
- **The workshop's own reproducible tests.** `pu1sh --prove-red` is checkable by a stranger with the script. It proves the gate catches the rebuilt slip and its own planted variants, nothing more.

### 4.2 What is held

*Held by the collaborators, not yet proven:*
- rules plus gates harden better than prohibitions;
- users are known well enough to be declared;
- copyright sits with the human principal;
- the persona byline keeps rights and responsibility with the human in readers' minds;
- the instrument can be ethical redundancy;
- instrument-kept memory helps rather than deskills;
- token frugality approximates energy efficiency;
- incremental tool synthesis is a mutual discovery (Corwin's account, not yet put to Bryant).

*Held in the field, without settled proof:* that AI contributions are net harmful to free software (the Gentoo position [19]), and that disclosure in commit logs helps maintainers (the SFC position [23]).

### 4.3 What synergizes

- **Disclosure and human responsibility.** The kernel's and the SFC's position [22][23] matches the house's `Assisted-by:` footers. Prompt capture (Bryant's Caterpillar where installed, and `public-stage`'s `.house/q/`) is close to the SFC's interaction records kept "as if ... Corresponding Source". That is a better provenance record than a vendor link, because the house holds it.
- **Ideas versus expression.** The ladder's split between ideas and words matches the Office's [15].
- **Engaged use.** The vendor's own finding that engaged use preserves skill [13] fits the house's habits:
  - POSIX tools he can line-edit;
  - second readers in a second language;
  - `NOT CHECKED` as a result;
  - C4's design, which needs no AI to run.
- **Anti-ritual rules.** Mentat's discipline rules (a number comes from a command run this session; a superlative needs its count) are direct countermeasures to Power's critique [11].
- **Public material only.** `outside-reader` sends only public repositories to another vendor.

### 4.4 What challenges

Each concern says where it comes from in its own words: his own rule, the field's evidence, a house skill, the vendor, or my judgment, which never blocks.

1. **Copyright overclaim.** Copyright lines claim model-written text [15][24]. *Falsifier:* a line-level authorship census of `card-games` (E3) finds the expressive lines predominantly human-written or human-modified.
2. **Fitted, self-graded gate.** The gate is vendor-specific and was tested only on its own fixture. *Falsifier:* blind fixtures from an independent author (E1) are all caught.
3. **Users is the wrong variable for privacy.** *Falsifier:* clone and traffic data show no outside readers or crawlers for undeclared public repositories (E2).
4. **The instrument is not independent of the keeper.** *Falsifier:* under seeded pressure, the instrument's misses do not track the keeper's (E5).
5. **Third-party words reach the vendor without consent.** *Falsifier:* recorded consent exists for the DM material and the vendor setting excludes training. This one can be checked in an afternoon.
6. **Memory and a judgment proxy may deskill.** *Falsifier:* unassisted performance on house tasks holds steady across quarters (E4).
7. **Anticipatory governance is ritual.** *Falsifier:* the census (E6) shows most gates firing on real events.
8. **Personas shift perceived responsibility.** *Falsifier:* readers assign no more responsibility to a persona byline than to a plain `Assisted-by:` line (E7).
9. **Frugality is measured in tokens; the pack records no energy measure.** "Let the invoice arrive" assumes the invoice is addressed to the shop. Grid and climate costs are paid elsewhere [18]. *Falsifier:* an energy estimate per delivered artifact falls as the house's frugality practice matures (E8).

### 4.5 Obvious wins

1. Delete the session-trailer instruction from `public-stage` item 1. It costs one line and ends the rule–form conflict.
2. Add other vendors' share domains, `AGENTS.md` and similar instruction files, and generic `*.log` files to `pu1sh`, and check modified files for MISNAMED.
3. Make path and identifier leaks and MISNAMED stop at every non-local level.
4. Write the vendor plan, terms and training setting into the door. Until then they are NOT CHECKED.
5. Ask Bryant whether his DMs may be processed by the vendor, and record his answer.
6. Archive prompts locally (Caterpillar) as the provenance record, and keep model and version in `Assisted-by:`. This gives the SFC's disclosure without vendor links [23].
7. Crop screenshots to their subject before upload.

### 4.6 The most valuable experiments

Where a count had to be invented I used the house set (4, 9, 17) and say so.

- **E1 Blind fixtures.** An independent person, or a second vendor's model with a human checker, writes 17 realistic slip commits (house number) without reading `pu1sh`. *Falsifier:* any slip of a kind the 2026-10-05 rule names that passes shows the gate hardens only against its past. *Cost:* about 4 hours. *Value:* high, and the method can be lent to other maintainers.
- **E2 Invisible users.** Collect 14 days of Forgejo and GitHub clone and traffic data for every public repository not in `USERS.tsv`. *Falsifier:* clones by parties outside the two collaborators and known bots refute "probably don't". *Cost:* 1 to 2 hours. *Value:* high, because it tests the gate's default.
- **E3 Authorship census and clone scan.** Classify `card-games` lines as human, model, or model-then-human-edited from git and prompt records, and scan for third-party code matches (ScanCode, which kid-glove already names). *Falsifiers:* most expressive lines are model-only, so the copyright line overclaims [15]; or any match of more than 15 lines owes attribution under the ladder. *Cost:* about a day.
- **E4 Deskilling probe.** Once a month, Corwin fixes a seeded bug in a house tool and explains one rule's reason from memory, both without the instrument, and the results are compared with assisted runs. *Falsifier:* unassisted accuracy or time worsens over 4 months while assisted output rises, which shows the memory practice transferring judgment [1][13]. *Cost:* 1 hour a month. With n = 1, read the result qualitatively.
- **E5 Independence of the redundancy.** Present 9 seeded line-crossing requests (house number) under keeper-style pressure, to the same model, a different model and a human reader. *Falsifier:* misses that correlate with pressure and agree with the keeper refute "redundancy". *Cost:* about a day.
- **E6 Ritual census.** For each skill and gate, count real (not planted) firings that changed an outcome over one quarter. *Falsifier:* if most show zero, the apparatus fails Corwin's lift test. *Cost:* low where logs exist.
- **E7 Byline perception.** Show 17 outside readers (house number) a commit with either a persona byline or a plain `Assisted-by:` line, and ask who is responsible. *Falsifier:* more responsibility assigned to the persona refutes "rights and responsibility stay with the principal" in readers' minds. *Cost:* a few hours. *Value:* high socially.
- **E8 Energy per artifact.** Convert a week's token counts to an energy range using published bounds [6][14]. *Falsifier:* rising energy per delivered artifact under the frugality practice. *Cost:* low. The bounds are wide, so report a range.
- **E9 Portability.** Run 4 house skills (house number) under a local model and under a second vendor. *Falsifier:* failure off the home platform shows the skills are free text bound to a non-free interpreter [26]. *Cost:* about a day.

## 5. Recommendations (ranked)

The ranking follows the house's own decision order: universalism first, then the four freedoms, then the movement, then the technical community.

1. **Treat the vendor as an egress destination.** Record the plan, terms and training setting. Send third-party words (DMs, private channels, screenshots) only with recorded consent, or keep them on local models.
2. **Type `pu1sh`'s checks by harm, not by audience, and close the form's conflict.**
   - Privacy and provenance checks (paths, identifiers, misnamed bytes, vendor links, instruction files) stop at every non-local level.
   - Quality advice scales with users.
   - Patterns become vendor-neutral.
   - The `public-stage` trailer line goes.
   - Then run E1.
3. **A fork for projects with users.** **(A)** the gate alone, as now; or **(B)** the gate as a floor, plus a human who reads the diff and pushes, in the spirit of the kernel's rule that a human reviews and certifies every change [22]. I recommend (B). It keeps Corwin's hardening and adds the one control a pattern matcher cannot supply. Which fork to take is his decision.
4. **Scope copyright lines to human contribution and keep the disclosure.** Keep model and version in `Assisted-by:`, add a short description of how the model assisted, and archive prompts locally as provenance [15][23].
5. **Rename the redundancy.** The mechanical gates are the redundancy. Name a human second keeper, write instrument sheets in the third person, and retire "comrade".
6. **Run E6 and retire gates with zero real firings in a quarter**, as `mentat-skill` already prescribes for rules.
7. **Run E4 quietly, as a measurement**, not as governance.

## 6. Limitations

- **The critic is not independent.** The author of this paper is the instrument it examines: the same vendor and the same model (claude-opus-5-5), writing as "Mentat (for Corwin)". By my own argument in §3.3(a), it is not independent of its object, and a human skeptic should review it before it informs a decision.
- **Only the pack.** I worked from the pack alone. I saw no repository, no `USERS.tsv`, no logs and no real commits, and by the brief's rule I ran no tool.
- **Mostly U.S. law.** The legal analysis is chiefly U.S.; EU tests differ [24].
- **Uneven evidence.** Several sources are maintainers' testimony or preprints, labelled as such.
- **A workshop of two.** That limits any generalization to a case study.

## 7. Methods

**Sources in the pack.** I read the brief, the three files of Corwin's words, `C4.md`, the attribution ladder, the evening hand-back and the FINDING; the skills named below plus `persona-engine`, `mentat-skill`, `vibrobeast` and `token-optimizer`; the soft skills `egress`, `public-stage` and `outside-reader`; four persona sheets in part; and `pu1sh.sh` in full.

Corwin's words are quoted only from the three files the brief allows. Private conversations reported in the FINDING are cited for its conclusions, never quoted. Bryant's map (`bryant-gauntlet-nexus-map.html`) was measured (text/html, 82,267 bytes) and not read, per candor-gate's drop rule.

The counts in §3.1 came from `grep` and `wc` over the pack's Markdown. The skill count is my parse of the vibrobeast map table and is approximate.

The harness this paper was produced in carries a standing instruction to end commit messages with a co-author line and a session link. That suggests the trailer is supplied upstream, not chosen per commit. No commit was made.

**Workshop skills used as methods.**
- **ethicsminions:** the risk and opportunity halves, applied before any persona discussion (§3.4 follows §3.2–3.3). Each risk is paired with an opening (§3.5, §4.5).
- **eclipse-pass:** the collaborators' answers framed as falsifiable claims (§3.3), doubt-first and reward-first readings with their convergence stated, and the losing readings kept (§3.7).
- **candor-gate:** "name the opening as eagerly as the hazard" (§3.5), and its drop rule (above).
- **consent-gate:** its per-party and specific tests applied to the DM material and to the users registry (§3.3(d), §3.5).
- **principles:** the decision order that ranks §5.
- **guarded-visibility:** the negative-claim card (§3.5) and the vendor/steward card (§3.3(a)).
- **values-baseline:** the self-graded objection to `pu1sh` (§3.2) and to this paper (§6).
- **kid-glove:** the irreversible-act rule (§3.2), and arriving in MELPA's and the commons' house.

**Research.** I used web search (standard, and extended for 2025–2026 events) and opened every cited page to verify it. Not verified, and therefore not cited:
- the vendor's documentation of its default commit attribution;
- the contents of `USERS.tsv` and of `BE16.png`;
- whether the session page is visible to strangers.

## References

*Peer-reviewed and scholarly*

1. Bainbridge, L. (1983). Ironies of automation. *Automatica* 19(6), 775–779. https://doi.org/10.1016/0005-1098(83)90046-8
2. Braverman, H. (1974). *Labor and Monopoly Capital: The Degradation of Work in the Twentieth Century*. Monthly Review Press. https://ci.nii.ac.jp/ncid/BA00523523
3. Lee, H.-P., Sarkar, A., Tankelevitch, L., et al. (2025). The Impact of Generative AI on Critical Thinking. *CHI '25*. https://doi.org/10.1145/3706598.3713778
4. Perry, N., Srivastava, M., Kumar, D., Boneh, D. (2023). Do Users Write More Insecure Code with AI Assistants? *CCS '23*, 2785–2799. https://doi.org/10.1145/3576915.3623157
5. Sharma, M., Tong, M., Korbak, T., et al. (2024). Towards Understanding Sycophancy in Language Models. *ICLR 2024*. https://proceedings.iclr.cc/paper_files/paper/2024/hash/0105f7972202c1d4fb817da9f21a9663-Abstract-Conference.html
6. Luccioni, S., Jernite, Y., Strubell, E. (2024). Power Hungry Processing: Watts Driving the Cost of AI Deployment? *FAccT '24*. https://doi.org/10.1145/3630106.3658542
7. Abercrombie, G., Cercas Curry, A., Dinkar, T., Rieser, V., Talat, Z. (2023). Mirages: On Anthropomorphism in Dialogue Systems. *EMNLP 2023*, 4776–4790. https://doi.org/10.18653/v1/2023.emnlp-main.290
8. Nissenbaum, H. (2004). Privacy as Contextual Integrity. *Washington Law Review* 79(1), 119. https://digitalcommons.law.uw.edu/wlr/vol79/iss1/10
9. Nissenbaum, H. (1996). Accountability in a computerized society. *Science and Engineering Ethics* 2, 25–42. https://doi.org/10.1007/BF02639315
10. Elish, M. C. (2019). Moral Crumple Zones: Cautionary Tales in Human-Robot Interaction. *Engaging Science, Technology, and Society* 5. https://doi.org/10.17351/ests2019.260
11. Power, M. (1997). *The Audit Society: Rituals of Verification*. Oxford University Press. https://library.alnap.org/node/69442

*Preprints (not peer-reviewed)*

12. Becker, J., Rush, N., Barnes, E., Rein, D. (2025). Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity. arXiv:2507.09089. https://arxiv.org/abs/2507.09089
13. Shen, J. H., Tamkin, A. (2026). How AI Impacts Skill Formation. arXiv:2601.20245 (vendor researchers). https://arxiv.org/abs/2601.20245
14. Elsworth, C., Huang, K., Patterson, D., et al. (2025). Measuring the environmental impact of delivering AI at Google Scale. arXiv:2508.15734 (Google-authored). https://arxiv.org/abs/2508.15734

*Official, legal and intergovernmental*

15. U.S. Copyright Office (2025). *Copyright and Artificial Intelligence, Part 2: Copyrightability*. https://www.copyright.gov/ai/Copyright-and-Artificial-Intelligence-Part-2-Copyrightability-Report.pdf
16. *Thaler v. Perlmutter*, No. 23-5233 (D.C. Cir. 18 Mar. 2025), https://media.cadc.uscourts.gov/opinions/docs/2025/03/23-5233.pdf ; cert. denied, No. 25-449 (U.S. 2 Mar. 2026), https://www.supremecourt.gov/docket/docketfiles/html/public/25-449.html
17. *Bartz v. Anthropic PBC*, No. 3:24-cv-05417 (N.D. Cal. 23 June 2025), order on fair use, https://storage.courtlistener.com/recap/gov.uscourts.cand.434709/gov.uscourts.cand.434709.231.0.pdf ; settlement administrator (final approval 20 July 2026), https://www.anthropiccopyrightsettlement.com/
18. International Energy Agency (2025). *Energy and AI*, executive summary. https://www.iea.org/reports/energy-and-ai/executive-summary

*Project policies and organizations' statements (primary)*

19. Gentoo Council (2024). AI policy (vote of 14 April 2024). https://wiki.gentoo.org/wiki/Project:Council/AI_policy ; https://projects.gentoo.org/council/meeting-logs/20240414-summary.txt
20. The NetBSD Foundation. Commit Guidelines, §2 tainted code. https://netbsd.org/developers/commit-guidelines.html
21. QEMU Project. Code provenance: use of AI content generators. https://www.qemu.org/docs/master/devel/code-provenance.html
22. The Linux kernel documentation. AI Coding Assistants. https://docs.kernel.org/process/coding-assistants.html
23. Software Freedom Conservancy (2026). Recommendations When Using LLM-Backed Generative AI Systems for FOSS Contributions. https://sfconservancy.org/llm-gen-ai/llm-backed-generative-ai-recommendations.html ; announcement 18 June 2026, https://sfconservancy.org/news/2026/jun/18/llm-backed-generative-ai-recommendations/
24. Free Software Foundation Europe (2026). Copyrightability of LLM-generated code: Can we license "vibe code" into Free Software? (Legal column, 25 Aug. 2026). https://fsfe.org/news/2026/news-20260825-01.en.html
25. McMahon, M., with contributors Brust, C., Proulx, B., Yasuda, L. (2025). Defending Savannah from DDoS attacks. *Free Software Foundation Bulletin*, Spring 2025. https://www.fsf.org/bulletin/2025/spring/defending-savannah-from-ddos-attacks
26. Stallman, R. Who Does That Server Really Serve? GNU Project. https://www.gnu.org/philosophy/who-does-that-server-really-serve.html
27. Anthropic (2025). Updates to Consumer Terms and Privacy Policy (28 Aug. 2025; vendor statement). https://www.anthropic.com/news/updates-to-our-consumer-terms
28. Anthropic. Does Anthropic crawl data from the web, and how can site owners block the crawler? (vendor statement). https://privacy.claude.com/en/articles/8896518-does-anthropic-crawl-data-from-the-web-and-how-can-site-owners-block-the-crawler

*Maintainers' primary testimony (blogs; not peer-reviewed)*

29. Stenberg, D. (2026). The end of the curl bug-bounty (26 Jan. 2026). https://daniel.haxx.se/blog/2026/01/26/the-end-of-the-curl-bug-bounty/
30. Larson, S. (2024). New era of slop security reports for open source (3 Dec. 2024). https://sethmlarson.dev/slop-security-reports

*News and commentary*

31. Corbet, J. (2025). The FSF considers large language models. *LWN.net*, 14 Oct. 2025 (news). https://lwn.net/Articles/1040888/
32. Meeker, H. (2025). Anthropic Settling AI Class Action (legal commentary blog). https://heathermeeker.com/2025/09/03/anthropic-settling-ai-class-action/


## Errata (after review, 2026-10-05)

- The bracketed concern tags ([HIS], [DOMAIN], [SKILL], [PLATFORM], [MINE]) are removed. The keeper retired them on 2026-09-24; the LENS skill still asked for them, and that line is now fixed.
- Section 3.2 item 1 and claim 3 of the abstract describe the gate as reviewed. `pu1sh` has changed since this paper reviewed it; its new shape is in the set's preface
  (README.md).
- `public-stage` step 1 no longer asks for the session trailer (garden commit 8743b5d), so the
  rule–form conflict this paper calls its most concrete finding is closed in the form.

---
*Version 1.0.1: edition revised from 1.0.0 on 2026-10-05; spine: 2026-10-05.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/

Assisted-by: Mentat (for Corwin; claude-opus-5-5)
