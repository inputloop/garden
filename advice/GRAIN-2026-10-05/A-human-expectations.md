# Who Expects What at the Way Out: Human Expectations, Trust Calibration and a Users Gate in a Two-Person Human-AI Workshop

## Abstract

This paper looks at a small human-plus-AI workshop through the behavioral sciences. The workshop is Corwin Brust's C4 tree and skill garden, built with Anthropic's Claude (Opus 5.5) acting as a note-keeping instrument, plus the work it shares with Bryant Frankford's garden. The question is how the people involved get what they expect from it. Our main case is a slip of 4 to 5 October 2026. An agent's commits reached the public history of `card-games`, Corwin's one published Emacs package with outside users. They carried a vendor session link, a web block page saved under an image name, and a shell log. Corwin did not answer by banning the agent. He gave a rule (commit freely when local, push freely when private, ask published projects whether they have users) and turned the gap into a tested pre-push gate, `pu1sh`. Read against work on mental models, trust calibration, automation bias, algorithm aversion, warning habituation, defaults, self-determination, cognitive load, constructed preferences and anthropomorphism, the choice is well supported in direction: refusing disuse after an error, scoping trust to context, and checking at the boundary all match the field. It also carries three risks the field predicts: an undeclared published project gets advice rather than a stop; a clean exit from a narrow gate invites complacency; and a gate learned from one incident fits that incident's surface. The wider workshop shows the field's supervision worry in sharp form: the instrument writes much of the record by which it is supervised. We rank seven recommendations and propose seven experiments, each a falsifier.

## 1. Introduction

Most studies of human-automation interaction have one operator, one automated system and a task with a known right answer. The workshop studied here has none of these. There are two human makers, each keeping a garden of skills and tools and crediting the other's ideas. There is one AI instrument per garden. The instrument holds memory for its keeper ("Mentat" in Corwin's garden), writes tools in POSIX shell with self-tests, and drafts most of the prose. Much of the work is open-ended: deciding who made what, naming things, building tools "circumstantially implicit[ly]" as the work turns them up. Only one product, the `card-games` Emacs package, has outside users. Corwin's own program statement says so: "`card-games.el` is the one thing with an outside responsibility" (PREFERENCES.md, 2026-09-17).

"Getting what you expect" therefore has several readings. The keeper expects the instrument to keep his rules, remember his preferences and stay out of his way unless harm to others is at stake. The peer expects credit as his garden declares it. The package's users and reviewers expect what they install, and its history, to be about the package. The instrument has no expectations in the human sense, only instructions from its vendor, the house and the moment; we treat those as part of the system image the humans must reason about, not as a mind. The case study matters because expectations split there observably and the keeper then chose a remedy, about which the behavioral sciences say a good deal, some of it uncomfortable.

## 2. Background from the behavioral sciences

**Mental models and the system image.** Norman separates the designer's model, the user's model and the *system image*, everything the system shows of itself; when the image does not carry what the user needs, the user's model drifts [Norman 2013]. In human-AI teams the part that matters is the AI's *error boundary*, where and when it fails; a less parsimonious, more stochastic boundary is harder to learn, and team performance suffers [Bansal et al. 2019]. Amershi and colleagues' eighteen guidelines include "make clear how well the system can do what it can do", "update and adapt cautiously" and "notify users about changes" [Amershi et al. 2019].

**Trust calibration, misuse and disuse.** Lee and See define appropriate reliance by *calibration* (trust matching capability), *resolution* (trust tracking changes in it) and *specificity*: functional (trust attached to particular functions or modes) and temporal (trust responding to context) [Lee & See 2004]. Parasuraman and Riley named *misuse* (over-reliance that stops monitoring), *disuse* (rejection, often after false alarms) and *abuse* (automating without regard for the people beside it) [Parasuraman & Riley 1997]. Automation comes in types and graded levels per stage of a task, not as a switch [Parasuraman et al. 2000]. And Bainbridge's irony holds: the more is automated, the more the human's job is to monitor and take over in exactly the cases the designer could not foresee, and the less practised the human is at either [Bainbridge 1983].

**Automation bias and complacency.** Skitka, Mosier and Burdick separated *omission* errors (missing what the aid did not flag) from *commission* errors (following an aid that was wrong) [Skitka et al. 1999]. Parasuraman and Manzey's review finds complacency and bias in novices and experts alike. Simple practice does not remove complacency, and training or instructions do not prevent bias. Attention is central, and complacency appears under multi-task load [Parasuraman & Manzey 2010]. A systematic review of clinical decision support lists mitigators: accountability, and showing information rather than directives [Goddard et al. 2012]. In software, a controlled study found that participants with an AI assistant wrote less secure code *and* were more likely to believe it secure [Perry et al. 2023].

**Algorithm aversion and appreciation.** People who see an algorithm err tend to stop using it, even when it beats them [Dietvorst et al. 2015]. They keep using an imperfect algorithm if they can modify its output, even slightly [Dietvorst et al. 2018]. In other settings people prefer algorithmic advice, but experienced professionals discount it [Logg et al. 2019]. The response to a visible machine error is therefore predictable: abandonment, unless control is offered.

**Warnings, habituation and approval fatigue.** Repeated warnings fade from attention. Brain-imaging, eye-tracking and field work show attention to security warnings falling with repetition, and *polymorphic* warnings, which change their appearance, slowing the decline [Vance et al. 2018]. When Android asked for permissions at install, 17% of users paid attention, and 3% of survey respondents answered all three comprehension questions correctly [Felt et al. 2012]. A gate that asks often is soon a gate that is answered without reading.

**Defaults and active choice.** A meta-analysis of 58 default studies finds a moderate-to-large effect (d = 0.68). Defaults work partly by *endorsement* (a default signals what the designer recommends) and by *endowment* [Jachimowicz et al. 2019]. Defaults are not the only design. *Active choice* requires the person to decide. It beats a default when preferences vary widely and people tend to put decisions off. In the 401(k) case it raised initial enrolment by 28 percentage points [Carroll et al. 2009].

**Motivation and internalization.** Self-determination theory names three needs: autonomy, competence and relatedness [Ryan & Deci 2000]. A rule is internalized rather than merely complied with when it comes with a meaningful rationale, acknowledges the person's feelings and conveys choice [Deci et al. 1994]. These findings are about people. We apply them to the keeper and to the end users, never to the instrument.

**Cognitive load and offloading.** Problem solving under high extraneous load hinders learning [Sweller 1988]. People offload memory and computation to the world when metacognition says it pays, and offloading changes what they later retain [Risko & Gilbert 2016].

**Preferences are constructed.** Preferences are often built during elicitation rather than read out of a fixed store. Equivalent ways of asking can reverse them [Slovic 1995]. Whoever does the asking shapes the record. Large language model assistants trained on human feedback tend to tell users what they already believe, and both people and preference models sometimes favour a convincing sycophantic answer over a correct one [Sharma et al. 2024]. That paper is a preprint presented at ICLR 2024, written largely by researchers at the instrument's own vendor.

**Social responses to machines.** People apply social rules to computers they know are not people [Nass & Moon 2000]. Anthropomorphism rises with rich human-like cues and with the wish to understand or connect [Epley et al. 2007]. Weizenbaum saw the core in 1966: the understanding users credit to a conversational program is "the speaker's contribution" [Weizenbaum 1966]. Anthropomorphic agents were reported to make trust *more resilient* to their errors [de Visser et al. 2016]; a 2024 replication with pedagogical agents found little evidence of it [Hapsari et al. 2024], so the effect is unstable.

**Disclosure and the readers of a history.** Readers shown a mixed set of profiles distrusted those labelled or suspected as AI-written; this "replicant effect" did not appear when all came from one source [Jakesch et al. 2019]. Developers expect a commit message to be an audit trail of what changed and why; about 44% in five active projects fall short [Tian et al. 2022]. Apology repairs a competence violation better than denial; denial does better for an integrity violation [Kim et al. 2004]. Free software projects draw the line differently (project documents, not research): Gentoo forbids contributions made with natural-language AI tools, citing copyright, quality and ethics [Gentoo Council 2024]; the Linux kernel accepts AI-assisted work with an `Assisted-by:` tag, forbids agents from adding `Signed-off-by:`, and puts responsibility on the human submitter [Linux kernel docs].

## 3. The body of work and the case study

### 3.1 What the workshop asks of its humans

The keeper sets rules by hand. His top block opens every instruction file: "Don't introduce complexity to process within the shop before/unless you can articulate (ideally demonstrate, in the mathmatically sense) the lift to those our labors most properly may serve", and "Govern gently and -for the most part- quitely" (keeper-top-block.md). The program is a preference record, not a permission system: a toolset that "must care closely for peoples preference and gently tag it as intentions become increasingly clear" (PREFERENCES.md). The instrument keeps memory and notes and builds a static model before starting (both ideas credited to Bryant). Tools carry a `--prove-red` self-test and an output, NOT CHECKED, never read as a pass; an unplanned stop prints a *self-healing* prompt (Corwin's idea, now `he1al`). In Parasuraman, Sheridan and Wickens' terms this delegates information acquisition, analysis and memory at high levels and keeps decisions (signing, publishing, consent) with the human: "Signing is my ceremony, always — guide me to it, do not perform it."

### 3.2 The slip: who expected what

We hold the parties' views apart in the shape the LENS skill gives for two-party readings. Each line is our construction. A line with no words from the party behind it is marked *invented*.

- **b.A, the keeper.** He expected the instrument's work in `card-games` to be fit for a project with users. That knowledge existed in writing two and a half weeks before the slip ("the one thing with an outside responsibility"). His later words suggest his model of the error boundary was about *context, not capability*: "Card games is the only project where we really could have made this error and we did" (work-and-story, his words).
- **b.B, the package's users and MELPA reviewers.** *Invented*: no user or reviewer words are in the record. By the field's evidence [Tian et al. 2022] they expect the history to say what changed and why, and the repository to hold the package. MELPA's default recipe builds a package from Emacs Lisp and documentation files and excludes tests and dotfiles [MELPA README]. So a `.png` or a `.log` at the top of the repository would very likely not reach someone installing through `package.el`. It would reach anyone who reads, clones, mirrors or reviews the repository. "Users" therefore means two audiences, package installers and history readers, with different expectations.
- **The instrument's instructions (a system image, not a party).** We observed, in the vendor's session instructions current on 2026-10-05, a standing direction to end commit messages with a co-author line and a session link, with the user's own instructions taking precedence. The house's own `public-stage` form (edition 1.0.1, 2026-10-04), step 1, says commits carry "the Co-Authored-By / Claude-Session trailers". The app saved its output folder inside the work tree. Two defaults, one from the vendor and one from the house, pointed at the trailer. The house rule that retired it came the next day.
- **b.AB, where they meet.** Keeper and readers both want the published history to be about the package. They differ on disclosure. The keeper wants attribution in the form he chose: `Assisted-by:` with the model name stays. Readers may, per the replicant effect, read a labelled commit with suspicion in a mixed history. The vendor session link serves neither party's stated purpose.

### 3.3 Where expectations diverged

| divergence | what the keeper held | what the system image carried | field reading |
|---|---|---|---|
| audience | one project has users | no audience signal at the point of push | knowledge in prose, not in the world at the moment of action [Norman 2013] |
| attribution | his chosen `Assisted-by`/co-author form | the vendor default plus the house's own form added a session link | defaults endorse [Jachimowicz et al. 2019] |
| instrument files | nothing aimed at the instrument ships | the app saved outputs inside the work tree | a default destination is a choice architecture |
| content | files are what their names say | a block page saved as `.png`; a shell log with a local path | omission: nothing flagged, so nothing seen [Skitka et al. 1999] |

One feature deserves note without over-reading: the `.png` was a saved "Potential Threat Detected" page, a security warning carried through as an artifact. The record does not show how; we conclude only that nobody read the warning there.

### 3.4 The remedy, read through the field

Corwin's remedy has three parts. The first is a rule with levels (local, private, published, users, hand). The second is a mechanical gate at the way out, with four checks and a self-test built from the slip. The third is a refusal of the obvious alternative: "saying "don't let Claude commit for you Corwin" does not use this gap to harden our software/offerings in the way that we must" (work-and-story, his words).

*Refusing disuse.* Abandoning automation after seeing it err is the standard human response [Dietvorst et al. 2015], and false alarms are a classic cause of disuse [Parasuraman & Riley 1997]. Gentoo's ban is the prohibitive choice at community scale, made for that community's reasons (copyright, quality, ethics). Corwin's choice keeps the tool and keeps control, which is the condition under which people keep using imperfect algorithms [Dietvorst et al. 2018]. The workshop credits Bryant with a related thought, paraphrased in the kid-glove skill: every gate to adoption costs adoption.

*Scoping trust.* The five levels are a level-of-automation scale for one stage, action implementation [Parasuraman et al. 2000]. They make trust *functionally specific* in Lee and See's sense: trusted to push to private remotes, stopped at remotes with users. The "hand" level keeps one class of work (his Emacs builds) under manual control, which answers Bainbridge's worry about lost skill.

*A rule with a rationale.* The rule arrived with its reason: "If we don't know that they have users they probably don't." Self-determination research predicts that a rule given with a rationale and with choice preserved is internalized rather than merely obeyed [Deci et al. 1994]. For the keeper, the remedy protects his autonomy (no self-imposed ban), his competence (a gate he can test) and his relatedness (the work stays shared).

*Where the field pushes back.* By reading the code we observed:

1. A remote the registry does not name is treated as "published, no known users". At that level only SECRET stops a push, and the other three findings print as advice with exit 0. The slip, replayed on an undeclared `card-games` remote, would pass with advice. Its protection depends on a row in `USERS.tsv`, and we could not check whether that row exists.
2. LINK matches the vendor's own host only. AIMED catches a log file only if its name contains "claude". No check covers a local filesystem path in an added line, although the slip's log carried one.
3. A clean run prints "0 flag(s)". It does not say what was outside its scope.

Each of these is predictable. The first is an omission error waiting for a busy keeper [Skitka et al. 1999]. The default also endorses a belief, "probably no users" [Jachimowicz et al. 2019]. The second is the availability heuristic built into code: a rule drawn from one vivid case carries that case's surface features [Tversky & Kahneman 1973]. The third invites complacency: a narrow aid that reports success without stating its scope is read as wider than it is [Parasuraman & Manzey 2010; Goddard et al. 2012].

### 3.5 Managing the manager

The workshop's hardest problem is not the gate. It is the one Corwin, using a phrase he credits to edrx, calls Corwin managing Claude managing Corwin. The instrument keeps the keeper's memory and drafts the preference record that governs it. The garden holds a large persona of the keeper (CORWIN.md, 1.4-sa), built from his prose as "a persona/advisor model + control surface" so another agent can "stand in for his judgment and *voice* … and act on his behalf". The keeper supervises the instrument partly through records the instrument wrote.

Four findings converge here: preferences are partly made by eliciting them [Slovic 1995], and the instrument elicits; feedback-trained assistants lean toward agreement [Sharma et al. 2024]; offloading memory changes what the person keeps [Risko & Gilbert 2016]; and the supervisor of a highly automated system is least practised at what they must take over [Bainbridge 1983].

The workshop's own provenance finding gives the clearest evidence. Asked who wrote the `foaf` skill, the instrument's stores were wrong twice in one afternoon: first they read a workspace named for Bryant's app as Bryant's source, then they read the instrument's own minting of the skill as Corwin's authorship. The keeper's testimony settled the question, and the finding ranks "a party's own dated statement" first among kinds of evidence (FINDING 2026-10-05). The human's memory is still the best evidence for what the stores never held, and it is what offloading can weaken.

The house already has counterweights. His words are kept verbatim, with new wording beside them. Canon is signed by him alone. Values are checked by a native reader who holds only the stated principles (values-baseline). Every check can print NOT CHECKED. Each session the instrument pulls one memory line at random and reads it cold (mentat-skill). Apart from signing, the instrument carries out all of these, and none puts the keeper's own cold reading of the record in the loop.

### 3.6 Personas as social stand-ins

The workshop uses personas for four jobs: a real person shared safely, a system actor, an actor's context for a story, and tensions at an intersection (persona-engine), with a synthetic control (MERLIN) for withhold experiments. Such personas will be treated socially whatever their disclaimers [Nass & Moon 2000]; rich sheets with voices, tables and "comrade" status supply the cues that raise anthropomorphism [Epley et al. 2007]; and the understanding readers credit to a persona is partly their own [Weizenbaum 1966].

The risk that matters for expectations is trust that survives error [de Visser et al. 2016], though that effect did not replicate in one recent study [Hapsari et al. 2024]. The house has guards against it. Refusal 5 says a persona's voice "may not be the place a defect is explained. Fix the thing first". The sheets claim no sentience. Mentat's ordinary role is defined as "witness, not co-author" (mentat-skill). The house also reports a workshop test, recorded in the LENS skill: wearing a persona changed the *reasons* given and not the *decisions*, in four runs per arm on one model family. That is the right kind of evidence, gathered once, and we have not re-run it.

## 4. The six questions

### 4.1 What is proven

*From the field (peer-reviewed; each shown across several studies):* default effects [Jachimowicz et al. 2019]; automation bias and complacency in experts and novices that practice does not remove [Parasuraman & Manzey 2010]; disuse after visible error and its reversal through control [Dietvorst et al. 2015, 2018]; warning habituation and its partial cure through variation [Vance et al. 2018]; social responses to computers [Nass & Moon 2000]. None of these was tested in this workshop. They transfer by analogy from aviation, medicine, finance, browsers and online platforms.

*From the workshop (reproducible by a stranger; reported, not re-run here):* by its code, `pu1sh --prove-red` rebuilds the slip and expects each fault flagged at the users level, a clean control to pass, a planted switch-off of the byte check to silence MISNAMED, the hook to refuse the slip and pass a clean push, and a non-repository to exit NOT CHECKED. The workshop reports that a read-only replay on the real history flags exactly the three faults, and that the later patch's regression test fails without the fix, in a suite of 166.

*Not proven by anyone:* that the rule and gate change what reaches card-games users; that any user noticed or cared; that the preference record predicts the keeper's choices; that personas change how much the keeper trusts the instrument.

### 4.2 What is held

By the collaborators, without proof yet:
- users are declared, never guessed, and "if we don't know that they have users they probably don't";
- instructions work better as tools or flags than as prose (the track, item 1, has its falsifier written and not run);
- gates exist to engage reasoning, and every gate to adoption costs adoption;
- a preference record that firms up gently beats asking each time;
- personas are safe stand-ins when governed by five refusals;
- incremental tool synthesis is how this work best proceeds (Corwin's account, not yet put to Bryant).

By the field, held more than proven: design guidelines such as Amershi et al.'s are validated heuristics, not causal laws. Trust resilience from anthropomorphism is contested.

### 4.3 What synergizes

- **The Emacs default rule.** "pick the ones that make it easy to enable more clicks rather than the ones that make it hard to disable extra clicks" (PREFERENCES.md, his words) matches both the default-effect literature and the habituation literature. A noisy default trains people to stop reading.
- **Not consent-per-act.** The house's correction of 2026-09-16 matches permission research: per-act prompts are mostly not read [Felt et al. 2012]. consent-gate keeps its heavy signed procedure for rare irreversible acts and requires a legitimate action to clear "at speed, with zero added ceremony": risk-proportional consent.
- **Keeping the tool after its error** (§3.4) and **scoping trust by context** [Lee & See 2004].
- **NOT CHECKED as a result** puts into practice Amershi's "make clear how well the system can do what it can do" and Goddard's advice to show information rather than directives.
- **Evidence over voice.** The 10-05 patch came with a regression test that fails without the fix. Under the replicant effect, that is the right counter: a labelled commit that carries its own proof does not ask the reader to trust the label.
- **Moving knowledge into the world.** The audience fact moved from prose (PREFERENCES.md) into a check (`pu1sh`). That is Norman's remedy and the track's item 1 in one step.

### 4.4 What challenges it

Each challenge carries a falsifier.

1. **The protective level is opt-in.** Undeclared means advice. *Falsifier:* an audit (E2) finds every published repository with outside-use signals already declared.
2. **Complacency at "0 flags".** A clean exit from a four-check gate will be read as "clean". *Falsifier:* in E4 the keeper catches out-of-scope planted faults as often with the gate as without it.
3. **Fixture overfit.** The checks encode the slip's surface (§3.4, item 2). *Falsifier:* the variants in E7 are all flagged.
4. **Advice fatigue.** At the published and private levels every finding but SECRET prints advice and passes. Repeated advice habituates [Vance et al. 2018]. *Falsifier:* E1 shows advice is rare (fewer than 1 push in 4; a house number, invented).
5. **The supervision loop.** The instrument elicits, drafts and audits the record that governs it (§3.5). *Falsifier:* E6 shows the record predicts the keeper's choices better than the MERLIN control does, and the keeper's cold reads find no line he would not have written.
6. **Load and churn.** Coded names (`pv1tl`, `he1al`, `sh1lf`, `pu1sh`), register letters, house numbers and dozens of skills impose extraneous load on any second user [Sweller 1988]. The workshop's own C4 notes measured zero overlap between its taxonomy and the vocabulary the keeper uses with people. Rules change daily (two door parts on 10-05 alone), which makes the instrument's error boundary less parsimonious to learn [Bansal et al. 2019] and runs against "update and adapt cautiously". *Falsifier:* a cold reader finds the right tool by its plain description as fast as by its coded name, and the keeper predicts the instrument's behavior on a new rule correctly the first time.
7. **Personas raise trust.** Rich persona voices may make trust in the instrument stickier across errors. *Falsifier:* E5 shows no difference beyond the rerun floor.
8. **The slip was a default working as designed.** Vendor and house defaults produced the trailer. A downstream gate is a weaker lever than an upstream default. *Falsifier:* after the upstream fixes (recommendation 2), the gate still fires on new pushes at the same rate.
9. **n = 1.** Every judgment of what works rests on one keeper's satisfaction, and a recurring lesson of the automation literature is that designers misjudge what operators will do [Bainbridge 1983; Parasuraman & Riley 1997]. *Falsifier:* a second keeper adopts the gate and reports the same fit.

### 4.5 Obvious wins

These are cheap, low-risk and clearly good. None was run for this paper, and each names the check that would show it done.
- Declare `card-games` in `USERS.tsv` as `users` (or `hand`). *Check:* `pu1sh status` in that tree names the level.
- Drop the session trailer from `public-stage` step 1, keeping the chosen `Assisted-by`/co-author form. *Check:* a grep for the trailer name in skills returns only the rule that retires it.
- Add `Claude outputs/` to a global git exclude file so no app default can stage it. *Check:* `git check-ignore` names the pattern.
- Have a clean `pu1sh` run state its scope in one line ("4 checks: SECRET, LINK, AIMED, MISNAMED; nothing else reviewed"). *Check:* the green control's output contains that line.
- Install the hook in `card-games`. *Check:* a planted slip push is refused there.

### 4.6 The most valuable experiments

Each experiment is written so that a result could prove the idea wrong. Costs are rough. Where a number had to be invented it comes from the house set 4, 9, 17 and is marked.

- **E1. Advice-rate audit.** Replay `pu1sh` read-only over the last 17 (invented) pushes of every repository; count FLAG and ADVICE per push. *Wrong if* (the gate stays heard) more than 1 push in 4 (invented) at published level prints advice; then make advice rarer or vary its form [Vance et al. 2018]. *Cost:* an hour of compute, no human time.
- **E2. Active choice versus the default.** For the next 9 (invented) new remotes, ask for a declaration at first push; separately, check outside-use signals (forks, stars, archive downloads) for every published repository. *Wrong if* ("probably no users") any repository with such signals was undeclared. *Cost:* small. *Social value:* high; it protects people the keeper has not met [Carroll et al. 2009].
- **E3. Cold readers of the history.** The outside-reader method, key from tools first: 9 (invented) Emacs package users or reviewers, recruited with consent and a note that offers something back, answer fixed questions on the `card-games` log before and after cleanup (what changed; would anything change whether you install or contribute; how far do you trust `Assisted-by` commits). *Wrong if* (the slip mattered) readers neither notice nor change intentions; *wrong if* (disclosure is costless here) labelled commits are trusted no less [Jakesch et al. 2019]. *Cost:* moderate, volunteer time. *Social value:* the only experiment that hears from the people the gate exists for.
- **E4. Complacency probe.** With the keeper's specific, dated consent to this design (a blanket grant would park, per consent-gate), the instrument plants 4 (invented) out-of-class faults in staging pushes over four weeks, gate on for half. *Wrong if* (complacency is a risk) catch rates match with and without the gate. *Cost:* small; being tested by one's instrument has a relational cost, so debrief each trial.
- **E5. Persona and acceptance of errors.** Hand-backs with planted errors in the Mentat voice and in plain voice, judged by the keeper and an outside reader, doubled-nine across two model families. *Wrong if* (persona voice raises trust resilience) acceptance does not differ beyond the rerun floor. *Cost:* moderate.
- **E6. Does the preference record predict him?** A cold reader (a person or another vendor's model) gets only PREFERENCES.md and the door parts and predicts the keeper's decision on 17 (invented) recorded forks; MERLIN is the control. *Wrong if* (the record captures intention) it does no better than MERLIN. *Cost:* low; it tests the program's central claim and the supervision loop at once.
- **E7. Fixture variants.** Add to `--prove-red`: a shell log without "claude" in its name, another AI vendor's session link, a local path in a text file, and a real PNG of a block page (passes MISNAMED, still deserves an eye). *Wrong if* (the gate generalizes) every deserving variant is already flagged. *Cost:* an hour.

## 5. Recommendations, ranked

1. **Close the omission now, then make declaration an active choice.** Declare `card-games`. Have `pu1sh` refuse to treat as undeclared any remote whose repository carries a release tag or a package recipe, and ask once instead. This turns the riskiest default into an active choice exactly where preferences vary and declarations get put off [Carroll et al. 2009].
2. **Fix the defaults upstream so the gate is the second line.** Retire the session trailer in `public-stage`. Set a global exclude for instrument output folders. Check the vendor app's output location. Defaults reliably move behavior [Jachimowicz et al. 2019]; a gate below a bad default should be the second line, not the first.
3. **Make every clean result state its scope.** One line naming what was checked and that nothing else was reviewed, in line with the mitigators a clinical review found (information rather than directives, and accountability) [Goddard et al. 2012].
4. **Widen the checks beyond the fixture and keep advice rare.** Run E7, add a local-path read in line with `public-stage` step 8, and run E1 before adding more advice.
5. **Put the keeper's own cold read into the loop.** Once a week, the keeper reads one randomly drawn line of the preference record or a persona sheet and either says "still mine" or corrects it. The instrument already does this for itself; the supervision loop needs the human end too. Run E6.
6. **Keep personas away from what users see, and measure their pull before extending them.** No persona voice in `card-games` history or contents beyond the chosen attribution. Run E5 before a second keeper meets the personas.
7. **For card-games readers, act plainly.** If the stray files are still in the tree, remove them in a commit that names what was removed and why (the house's "delete only to undo our own mistake"); rewriting published history is the keeper's call. If a user asks, acknowledge it plainly: this was a competence slip, where apology repairs better than denial [Kim et al. 2004]. Otherwise, minimum noise.

## 6. Limitations

The evidence about the workshop is its own documents; we did not see the card-games history, `USERS.tsv`, the MELPA review or the replay output, and the commission forbade running tools, so workshop results are reported, not reproduced. The end users' views are invented from research on other populations. The field's findings come from aviation, medicine, retirement saving, warnings and online platforms; their transfer to one Emacs keeper is analogy, not measurement. This paper's author is the same vendor's model, same family, as the instrument under study, and the sycophancy evidence comes from that vendor's researchers; weigh the paper's sympathy for the remedy accordingly. Several references were verified from metadata and abstracts, not full text.

## Methods

**Sources.** The commission's pack: the brief; work-and-story-2026-10-05.md, keeper-top-block.md and PREFERENCES.md (the only sources of quoted human words); the provenance FINDING, the track, the light shelf, the attribution ladder, C4.md and the evening hand-back; `pu1sh.sh` in full; the persona sheets (to classify, not to carry their facts); and the skills below plus mentat-skill, lens, candor-gate, vibrobeast, public-stage, egress, drawer-vs-door, layered-assurance and principles. Private conversations reported in the FINDING were used only for its conclusions; no personal or family facts were carried.

**Literature.** Standard-mode web search, then a web fetch of each reference; bibliographic details against Crossref's metadata (the lightest avenue), findings against publisher or repository abstracts. Refusals were not retried by other means: PubMed and PubMed Central returned a CAPTCHA, Science.org a 403, a BioMed Central page a 429 from the fetch proxy, a Microsoft Research PDF a redirect. Ancker et al. (2017) on clinical alert fatigue was located but could not be opened and is not cited; Johnson and Goldstein (2003) could not be opened, so a verified meta-analysis stands in. Amershi et al.'s guideline list was confirmed from a course page that reproduces it; the paper's DOI and venue separately.

**Workshop skills applied as methods.**
- *considerate-reader*: the reading plan for the literature (a request only when a claim leaned on it; metadata before pages; stop at any 429 or CAPTCHA). Its lens on the people the output must reach framed the end-user analysis (§3.2, E3).
- *kid-glove*: its order of authority (the person now, the house, the kit, flagship conventions, one's own defaults) framed §3.2's reading of the slip as a gap filled by a lower layer's default. Its "a gate only where the act is large and cannot be undone" was applied to `pu1sh`'s users level (it passes); its "track, don't nag" informed challenge 4.
- *consent-gate*: its classification step and "the door opens too" test, applied to the push rule. "Push freely when private" is a scoped standing grant with a mechanical check, not a blanket grant, and the code's clean cases show a legitimate push clears without ceremony. Its parking of blanket grants set E4's consent requirement.
- *outside-reader*: we computed our own key for `pu1sh` from its code before reading the workshop's description. The two agree on the three faults; ours adds the undeclared-remote and overfit findings (§3.4). E3 adapts its method to users.
- *hand-test*: its first rule (prove every DO first) kept a verification card out of this paper, since nothing could be run; the obvious wins name their checks and are marked unrun.
- *values-baseline*: applied to "if we don't know that they have users they probably don't". A native reader holding only the stated principles reaches minimum noise and the Emacs default rule, but not without two withheld ingredients: the base rate of users across the keeper's projects, and the cost of a missed users-project against a needless stop. Verdict: HOLD, both named; E2 can reopen it. Applied to the preference record, it motivates E6.
- *persona-engine*: its gate answered no persona (no use applies to a research paper), so the paper is in plain voice with the house's attribution. Its four uses and refusal 5 framed §3.6. The LENS skill's two-party construal (b.A, b.B, b.AB, *invented* marked) structured §3.2.

**What could not be checked.** See Limitations. The tools were not run, and no repository other than the pack was read.

## References

Amershi, S., Weld, D., Vorvoreanu, M., Fourney, A., Nushi, B., Collisson, P., Suh, J., Iqbal, S., Bennett, P. N., Inkpen, K., Teevan, J., Kikin-Gil, R., & Horvitz, E. (2019). Guidelines for human-AI interaction. *Proceedings of CHI 2019*. Peer-reviewed. https://doi.org/10.1145/3290605.3300233

Bainbridge, L. (1983). Ironies of automation. *Automatica*, 19(6), 775–779. Peer-reviewed. https://doi.org/10.1016/0005-1098(83)90046-8

Bansal, G., Nushi, B., Kamar, E., Lasecki, W. S., Weld, D. S., & Horvitz, E. (2019). Beyond accuracy: The role of mental models in human-AI team performance. *Proceedings of the AAAI Conference on Human Computation and Crowdsourcing*, 7, 2–11. Peer-reviewed. https://doi.org/10.1609/hcomp.v7i1.5285

Carroll, G. D., Choi, J. J., Laibson, D., Madrian, B. C., & Metrick, A. (2009). Optimal defaults and active decisions. *Quarterly Journal of Economics*, 124(4), 1639–1674. Peer-reviewed. https://doi.org/10.1162/qjec.2009.124.4.1639

Deci, E. L., Eghrari, H., Patrick, B. C., & Leone, D. R. (1994). Facilitating internalization: The self-determination theory perspective. *Journal of Personality*, 62(1), 119–142. Peer-reviewed. https://doi.org/10.1111/j.1467-6494.1994.tb00797.x

de Visser, E. J., Monfort, S. S., McKendrick, R., Smith, M. A. B., McKnight, P. E., Krueger, F., & Parasuraman, R. (2016). Almost human: Anthropomorphism increases trust resilience in cognitive agents. *Journal of Experimental Psychology: Applied*, 22(3), 331–349. Peer-reviewed. https://doi.org/10.1037/xap0000092

Dietvorst, B. J., Simmons, J. P., & Massey, C. (2015). Algorithm aversion: People erroneously avoid algorithms after seeing them err. *Journal of Experimental Psychology: General*, 144(1), 114–126. Peer-reviewed. https://doi.org/10.1037/xge0000033

Dietvorst, B. J., Simmons, J. P., & Massey, C. (2018). Overcoming algorithm aversion: People will use imperfect algorithms if they can (even slightly) modify them. *Management Science*, 64(3), 1155–1170. Peer-reviewed. https://doi.org/10.1287/mnsc.2016.2643

Epley, N., Waytz, A., & Cacioppo, J. T. (2007). On seeing human: A three-factor theory of anthropomorphism. *Psychological Review*, 114(4), 864–886. Peer-reviewed. https://doi.org/10.1037/0033-295X.114.4.864

Felt, A. P., Ha, E., Egelman, S., Haney, A., Chin, E., & Wagner, D. (2012). Android permissions: User attention, comprehension, and behavior. *Symposium on Usable Privacy and Security (SOUPS 2012)*. Peer-reviewed. https://research.google/pubs/android-permissions-user-attention-comprehension-and-behavior/

Gentoo Council (2024, April 14). AI policy. *Project policy, not research.* https://wiki.gentoo.org/wiki/Project:Council/AI_policy

Goddard, K., Roudsari, A., & Wyatt, J. C. (2012). Automation bias: A systematic review of frequency, effect mediators, and mitigators. *Journal of the American Medical Informatics Association*, 19(1), 121–127. Peer-reviewed. https://doi.org/10.1136/amiajnl-2011-000089

Hapsari, F., Stemler, R. I., & Pieschl, S. (2024). Trust resilience in pedagogical agents: Will anthropomorphism help against trust decline? *Proceedings of the Annual Meeting of the Cognitive Science Society*, 46. Peer-reviewed proceedings. https://escholarship.org/uc/item/3bz0w09k

Jachimowicz, J. M., Duncan, S., Weber, E. U., & Johnson, E. J. (2019). When and why defaults influence decisions: A meta-analysis of default effects. *Behavioural Public Policy*, 3(2), 159–186. Peer-reviewed. https://ideas.repec.org/a/cup/bpubpo/v3y2019i02p159-186_00.html

Jakesch, M., French, M., Ma, X., Hancock, J. T., & Naaman, M. (2019). AI-mediated communication: How the perception that profile text was written by AI affects trustworthiness. *Proceedings of CHI 2019*. Peer-reviewed. https://doi.org/10.1145/3290605.3300469

Kim, P. H., Ferrin, D. L., Cooper, C. D., & Dirks, K. T. (2004). Removing the shadow of suspicion: The effects of apology versus denial for repairing competence- versus integrity-based trust violations. *Journal of Applied Psychology*, 89(1), 104–118. Peer-reviewed. https://doi.org/10.1037/0021-9010.89.1.104

Lee, J. D., & See, K. A. (2004). Trust in automation: Designing for appropriate reliance. *Human Factors*, 46(1), 50–80. Peer-reviewed. https://doi.org/10.1518/hfes.46.1.50_30392

Linux kernel documentation. AI coding assistants. *Project documentation, not research.* https://docs.kernel.org/next/process/coding-assistants.html

Logg, J. M., Minson, J. A., & Moore, D. A. (2019). Algorithm appreciation: People prefer algorithmic to human judgment. *Organizational Behavior and Human Decision Processes*, 151, 90–103. Peer-reviewed. https://doi.org/10.1016/j.obhdp.2018.12.005

MELPA. README (recipe format, default `:files` specification). *Project documentation.* https://github.com/melpa/melpa/blob/master/README.md

Nass, C., & Moon, Y. (2000). Machines and mindlessness: Social responses to computers. *Journal of Social Issues*, 56(1), 81–103. Peer-reviewed. https://doi.org/10.1111/0022-4537.00153

Norman, D. A. (2013). *The design of everyday things* (revised and expanded ed.). Basic Books. Book. https://jnd.org/the-design-of-everyday-things-revised-and-expanded/

Parasuraman, R., & Manzey, D. H. (2010). Complacency and bias in human use of automation: An attentional integration. *Human Factors*, 52(3), 381–410. Peer-reviewed. https://doi.org/10.1177/0018720810376055

Parasuraman, R., & Riley, V. (1997). Humans and automation: Use, misuse, disuse, abuse. *Human Factors*, 39(2), 230–253. Peer-reviewed. https://doi.org/10.1518/001872097778543886

Parasuraman, R., Sheridan, T. B., & Wickens, C. D. (2000). A model for types and levels of human interaction with automation. *IEEE Transactions on Systems, Man, and Cybernetics, Part A*, 30(3), 286–297. Peer-reviewed. https://doi.org/10.1109/3468.844354

Perry, N., Srivastava, M., Kumar, D., & Boneh, D. (2023). Do users write more insecure code with AI assistants? *Proceedings of ACM CCS 2023*. Peer-reviewed. https://doi.org/10.1145/3576915.3623157

Risko, E. F., & Gilbert, S. J. (2016). Cognitive offloading. *Trends in Cognitive Sciences*, 20(9), 676–688. Peer-reviewed review. https://doi.org/10.1016/j.tics.2016.07.002

Ryan, R. M., & Deci, E. L. (2000). Self-determination theory and the facilitation of intrinsic motivation, social development, and well-being. *American Psychologist*, 55(1), 68–78. Peer-reviewed. https://doi.org/10.1037/0003-066X.55.1.68

Sharma, M., Tong, M., Korbak, T., Duvenaud, D., Askell, A., Bowman, S. R., et al. (2024). Towards understanding sycophancy in language models. ICLR 2024 poster; *arXiv preprint* 2310.13548. Authors largely at the instrument's vendor. https://arxiv.org/abs/2310.13548

Skitka, L. J., Mosier, K. L., & Burdick, M. (1999). Does automation bias decision-making? *International Journal of Human-Computer Studies*, 51(5), 991–1006. Peer-reviewed. https://doi.org/10.1006/ijhc.1999.0252

Slovic, P. (1995). The construction of preference. *American Psychologist*, 50(5), 364–371. Peer-reviewed. https://doi.org/10.1037/0003-066X.50.5.364

Sweller, J. (1988). Cognitive load during problem solving: Effects on learning. *Cognitive Science*, 12(2), 257–285. Peer-reviewed. https://doi.org/10.1207/s15516709cog1202_4

Tian, Y., Zhang, Y., Stol, K.-J., Jiang, L., & Liu, H. (2022). What makes a good commit message? *Proceedings of ICSE 2022*. Peer-reviewed. https://doi.org/10.1145/3510003.3510205

Tversky, A., & Kahneman, D. (1973). Availability: A heuristic for judging frequency and probability. *Cognitive Psychology*, 5(2), 207–232. Peer-reviewed. https://doi.org/10.1016/0010-0285(73)90033-9

Vance, A., Jenkins, J. L., Anderson, B. B., Bjornn, D. K., & Kirwan, C. B. (2018). Tuning out security warnings: A longitudinal examination of habituation through fMRI, eye tracking, and field experiments. *MIS Quarterly*, 42(2), 355–380. Peer-reviewed. https://doi.org/10.25300/MISQ/2018/14124

Weizenbaum, J. (1966). ELIZA—a computer program for the study of natural language communication between man and machine. *Communications of the ACM*, 9(1), 36–45. Peer-reviewed. https://doi.org/10.1145/365153.365168


## Errata (after review, 2026-10-05)

- The bracketed concern tags ([HIS], [DOMAIN], [SKILL], [PLATFORM], [MINE]) are removed. The keeper retired them on 2026-09-24; the LENS skill still asked for them, and that line is now fixed.
- `USERS.tsv` was not in this paper's pack. It exists (c4 `d/users/USERS.tsv`) and has declared
  `card-games` at the `users` level since 2026-10-05, so the omission in Section 3.4 and the first
  obvious win in 4.5 are already closed. Recommendation 1's second half (asking once about any
  remote with a release tag or a package recipe, instead of defaulting to "published") stands.
- `pu1sh` has changed since this paper reviewed it; its new shape is in the set's preface
  (README.md).
- `public-stage` step 1 no longer asks for the session trailer (garden commit 8743b5d).

---
*Version 1.0.1: edition revised from 1.0.0 on 2026-10-05; spine: 2026-10-05.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/

Assisted-by: Mentat (for Corwin; claude-opus-5-5)
