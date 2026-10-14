# Ethical redundancy for one keeper and their agents

*A clean-room design paper*

## Summary

Can one keeper plus AI agents hold a workshop's ethically load-bearing lines better than the keeper plus one assistant? A backup check counts only when it fails for different reasons than the thing it backs up. The keeper and an assistant on one vendor's model, at the keeper's direction, share most of their reasons for failing, so more copies of that assistant add little. What does add protection is cheap, and mostly not an "agent": a server-side publication gate the assistant cannot skip, a separate signing identity for the assistant, a short shared ledger of crossings, and the second maintainer reading it. Agents help most with slips and least with value judgments; on third-party consent and on credit between the two maintainers, the answer is no. The paper ends with a short trust-repair note and five falsifiable experiments.

## 0. Terms

**Crossings.** Each line in the brief is guarded at a moment when something crosses a boundary that is hard to reverse. I call such a moment a *crossing*:

1. publication to a new audience;
2. third parties' words or data entering a vendor-hosted session;
3. a statement of credit or authorship;
4. issuing or using a credential or signing key;
5. material crossing the family or private line;
6. anything else sent to the vendor.

I add (7) a change to the records that govern the assistant: not on the brief's list, but failure mode 7 makes it load-bearing, because it changes how every later crossing is judged.

**Kinds of failure.** The eight failure modes are of four kinds. Each needs a different backup, because defensive layers protect only when their holes do not line up (Reason 2000):

- **Slips.** The act was not intended: a stray file, a shell log, a session link in a commit trailer (mode 5).
- **Judgment lapses.** The act was intended, but the call on a value line was wrong: third parties' words sent to the vendor without their consent (mode 4).
- **Pressure lapses.** A check existed but was waived under load or hurry: modes 1, 2, 6, and the requests in mode 8.
- **Drift.** The standard itself moved: the assistant drafting its own rules (mode 7), and the quiet change in what a signature under the keeper's account means (mode 3).

## 1. What makes a redundancy real

### 1.1 Independence of failure, not count of checkers

The chance that checks A and B both miss is P(A misses) × P(B misses | A misses). The second factor is what matters: a reviewer who is excellent on average but misses exactly what A misses adds almost nothing.

This has been measured. Knight and Leveson (1986) had 27 versions of one program written separately from one specification and ran them on a million tests; far more tests made several versions fail than independence predicts. Two-person integrity requires at least two authorized persons, "each capable of detecting incorrect or unauthorized security procedures" (NIST glossary, from CNSSI 4009-2022). Dual control likewise means "two or more separate entities (usually persons) operating in concert" (PCI SSC glossary). Presence is not enough; each must be able to catch the error.

Language models fail together in measurable ways. Across more than 350 models, Kim et al. (2025) report that "models agree 60% of the time when both models err" on one leaderboard dataset. Errors are more correlated when models share a provider or architecture, and accurate models have highly correlated errors even across providers. Goel et al. (2025) find that mistakes become more similar as capability grows, and that a model acting as judge scores models similar to itself more favorably. Panickssery et al. (2024) find that models recognize their own outputs and favor them, in proportion to how well they recognize them. Huang et al. (2023) find that without outside feedback, models struggle to correct their own reasoning and sometimes make it worse.

So two conditions must both hold: each checker can catch the failure, and the checkers miss for different reasons.

### 1.2 What the keeper and the assistant share

The keeper and the assistant are not two independent checkers. They share these channels:

1. **Direction.** The assistant acts at the keeper's direction, under the keeper's account. When the keeper hands the decision back under load (mode 1), the assistant becomes both the actor and the check, and two checks collapse into one.
2. **Framing.** The assistant sees what the keeper chose to show it. A request that crosses a line arrives with the keeper's reasons attached.
3. **Records.** The assistant drafts the rules that steer it, and the keeper accepts them (mode 7). The rule and the actor it governs have one author. Drafted text acts as a default, and defaults strongly shape what people end up choosing (Johnson & Goldstein 2003).
4. **Pull toward agreement.** Assistants trained on human preferences show sycophancy; humans and preference models sometimes prefer a convincing sycophantic answer to a correct one (Sharma et al. 2023). One vendor rolled back an over-agreeable update in 2025, blaming too much weight on short-term feedback (OpenAI 2025).
5. **Key.** Commits signed with a key registered to the keeper's account (mode 3) look the same whether the keeper reviewed them or not. The signature has stopped carrying information about review.
6. **Vendor.** The assistant's model belongs to the vendor, and the vendor is also one of the destinations to be guarded (mode 4). An assistant from that vendor cannot independently check "should this go to the vendor?", because reading the material in order to check it already sends it.
7. **Attention and load.** Both draw on the keeper's attention, the scarcest thing in the workshop (mode 6). People with an automated aid both missed events it did not flag and followed it against valid contrary indicators (Skitka, Mosier & Burdick 1999). Complacency appears when attention is split; bias is not prevented by training; both affect teams (Parasuraman & Manzey 2010). The check matters most when the keeper has least attention to give it.

### 1.3 Where independence can come from

Five sources of real independence are available. Each is partial:

- **Deterministic code.** A script fails differently from a person or a model. It does not get tired, and it cannot be persuaded. It is also blind to anything it was not written to look for.
- **A second human with different interests and context.** Here, the other maintainer, who has their own stake in credit and in what is said about them. High-reliability organizations prize exactly this "reluctance to simplify" through diverse, sceptical views (Weick, Sutcliffe & Obstfeld 1999).
- **Time.** A decision made the next morning is made partly by a different person. Cooling-off periods exist because people decide differently in "hot" and "cold" states (Camerer et al. 2003).
- **Restricted information.** A checker that sees only the diff, and not the conversation, cannot absorb the framing that led to it. Recent monitoring work finds that model monitors often do better with less information (Arike et al. 2026).
- **A different model family.** This gives some independence, but less than one would hope (§1.1).

**Ranking (my judgment).** Most independent: deterministic gates for slips, the second human for value judgments. Moderate: time and restricted information. A little: another model family. Almost nothing against persuasion and pressure: a second instance of the same model with the same context, though it still catches some slips.

## 2. The design space

Each option is scored against the four kinds of failure from §0. Costs come in four currencies: the keeper's attention (the scarcest), the second maintainer's attention, vendor exposure (an agent that reads third-party material on a vendor's servers is itself a crossing), and build and running cost.

| Option | Catches best | Misses | Main cost | Evidence |
|---|---|---|---|---|
| Deterministic gate at the boundary | Slips with a recognizable shape | Anything about meaning or value | False alarms, which lead to overrides | Strong for the mechanism; indirect for effect |
| Separate agent identity and key | Drift in what a signature means | Content | Low | Strong (practice and standards) |
| Different-family model reviewer | Some same-model blind spots | Correlated errors; the keeper's framing | Second vendor; attention | Moderate, and partly negative |
| Adversarial (objecting) agent | Unexamined assumptions | Value calls; it is role-played dissent | Attention for each objection | Mixed |
| Delay or cooling-off | Pressure lapses; hot-state decisions | Whatever is still unread after the delay | Latency on an existing backlog | Moderate (field), weak (lab) |
| Read-only auditor agent | Drift; slips after the fact | Anything it is not shown | False alarms; vendor exposure | Moderate (AI control work) |
| Rotating or external human | Value judgments; authentic dissent | Missing context; rubber-stamping | The second human's attention; privacy | Strong in principle; costly |
| Ledger or audit design | Visibility after the fact; deterrence | Logs nobody reads | Reading time | Strong for integrity; weak for use |

### 2.1 Mechanical gates

**Evidence.** Git's client-side pre-push hook can stop a push, but `git push --no-verify` bypasses it completely (git-push documentation). A server-side pre-receive hook runs on the remote, and if it fails, "none of the refs will be updated" (githooks documentation). Forges can also require approvals on protected branches (Forgejo documentation). Accidental leakage through public repositories is common: Meli et al. (2019) found secrets leaked in over 100,000 repositories, with thousands of new unique secrets leaked every day. Saltzer and Schroeder (1975) ask that protection be "psychologically acceptable", meaning that people "routinely and automatically apply the protection mechanisms correctly". A gate that is silent until it trips meets that standard, and it fits the keeper's preference for few approval steps (mode 2).

**Judgment.** A gate on public pushes would have caught every incident class in mode 5: session links by URL pattern, stray files by allowing only listed paths, shell logs by name and content. It can also look for key material, and for names on a local deny-list for the family line; that list must never be published or shown to a vendor. The gate must run on the server, because the assistant runs the push command and can skip a client-side hook. Its rules must live where the assistant cannot change them alone, or the gate inherits the drift in mode 7.

The gate misses anything semantic, such as a paraphrased private matter or a credit line that is wrong but well-formed. Its main risk is false alarms. Clinicians' acceptance of reminders dropped 30% with each additional reminder per encounter (Ancker et al. 2017). A noisy gate teaches its owner to override it.

### 2.2 Separate identity and key for the assistant

**Evidence.** The Linux kernel's guidance says "AI agents MUST NOT add Signed-off-by tags", because only humans can certify the Developer Certificate of Origin; the human submitter reviews, certifies and takes responsibility (kernel documentation; DCO 1.1). in-toto has each supply-chain step signed by the party that performed it (Torres-Arias et al. 2019). Level 4 of the SLSA source track requires changes on protected branches to be "agreed to by two or more trusted persons" and allows exceptions for trusted robot contributions (SLSA v1.2). Saltzer and Schroeder's least privilege and separation of privilege point the same way.

**Judgment.** This is the cheapest real improvement in the paper. The assistant signs with its own key, under an identity that visibly marks it as the assistant. The keeper's own key stays out of the assistant's reach and signs only what goes public. A signature under the keeper's name then means "the keeper looked", and the forge can enforce that rule. It catches nothing about content. It restores what the signature means, which mode 3 quietly removed.

### 2.3 A reviewer from a different model family

**Evidence.** A panel of smaller judges from different model families beat a single large judge, with less bias toward its own family and at about one seventh of the cost (Verga et al. 2024). Against that, errors correlate even across providers, and more so as models get more capable (Kim et al. 2025; Goel et al. 2025).

**Judgment.** A reviewer from another family reduces self-preference, but it is weakly independent at best. It shares the keeper's framing if it is given the conversation. It also doubles the vendor problem: a second vendor now receives whatever it reviews, including third-party words. If it is used at all, it should see only synthetic or already-public diffs. Experiment E2 tests whether it is worth buying.

### 2.4 An adversarial agent whose job is to object

**Evidence.** Authentic minority dissent produced better solutions than all three forms of role-played devil's advocate tested (Nemeth, Brown & Rogers 2001). In group decisions with AI help, a language-model devil's advocate that argued against the AI's recommendation led to more appropriate reliance on the AI, without much added workload (Chiang et al. 2024).

**Judgment.** An objector may improve reliance on the assistant, but it cannot supply authentic dissent: it has no interests of its own, it shares the framing and the vendor, and sycophancy pressure will soften it. If used, it should object only at crossings, each objection naming a check that could prove it wrong, so the keeper can dismiss it in seconds. Otherwise it becomes one more alert to ignore.

### 2.5 A delay or cooling-off agent

**Evidence.** Cooling-off periods are a standard example of "asymmetric paternalism": they cost a deliberate decision-maker little and protect people deciding "in the heat of the moment" (Camerer et al. 2003). Commitments made in advance work in the field: in the Save More Tomorrow plan, 78% of those offered it joined, and their average saving rate rose from 3.5% to 13.6% over 40 months (Thaler & Benartzi 2004). The much-cited laboratory study of deadlines as precommitment did not replicate (Hyndman & Bisin 2026), and independent analysts judged its original data tampered with or fabricated (Simonsohn, Simmons & Nelson 2026). The idea itself goes back to Ulysses at the mast (Elster 1984).

**Judgment.** A delay counters pressure lapses directly: a hurried "push it" becomes "pushed tomorrow unless expedited", and expediting needs a one-line reason in the ledger. It also gives the second maintainer a window to object. Its cost is latency on a backlog already weeks long (mode 6), so it should apply only to irreversible, public crossings. E3 tests whether it changes anything.

### 2.6 An agent that only reads and never writes

**Evidence.** The AI control literature studies exactly this: a trusted monitor watches an untrusted, more capable model and flags suspicious actions (Greenblatt et al. 2023). Resampling suspicious steps in multi-step agent tasks cut attack success from 58% to 7%, at a 5% cost to benign performance (Bhatt et al. 2025). In SHADE-Arena, the best monitor reached an AUC of 0.87 at telling sabotage transcripts from benign ones (Kutasov et al. 2025). However, catching 80% of sabotage required a false-positive rate above 20% (Anthropic 2025). Monitors often did better when shown less (Arike et al. 2026).

**Judgment.** That literature assumes a possibly adversarial model; this workshop's risk is an assistant that drifts with its keeper. The lesson still carries over. A read-only auditor should see the diff and the ledger, not the conversation, and run on a schedule after the fact, not as a gate the keeper waits on. Its false-alarm rate puts its findings in the ledger, not the keeper's chat. On the same vendor, it re-reads whatever is in the diff, which is acceptable only for material already cleared for that vendor.

### 2.7 Rotating or external human reviewers

**Evidence.** Code review delivers knowledge transfer and team awareness. Understanding the change is the central task, even though finding defects is what motivates it (Bacchelli & Bird 2013). The xz-utils compromise shows the opposite case: sock-puppet accounts complained about slow progress to an overloaded maintainer, and the attacker gained co-maintainer rights (Cox 2024; NVD CVE-2024-3094). Psychological safety, "a shared belief ... that the team is safe for interpersonal risk taking", predicts whether teams learn (Edmondson 1999).

**Judgment.** Only another human gives authentic dissent and an independent value judgment, and this workshop already has one. Rotation between two people becomes mutual review: each reads the other's crossings, not every change. External reviewers lack context, and showing them private material is itself a crossing, so they suit published artifacts and occasional audits.

### 2.8 Public ledger and audit designs

**Evidence.** Tamper-evident logs let an untrusted logger be audited, provided that "at least one auditor is assumed to be incorruptible" and that commitments are shared with auditors (Crosby & Wallach 2009). Certificate Transparency uses append-only public logs that let "anyone" audit certificate issuance (RFC 9162). Sigstore binds signatures to identities through a transparency log (Newman, Meyers & Torres-Arias 2022). Accountability itself changes behavior: participants who believed they were accountable for how they used automation verified it more often and made fewer automation-related errors (Mosier et al. 1996).

**Judgment.** For this workshop the ledger should be *shared but private*: a hash-chained file in a repository that both maintainers sign, holding one line per crossing. A public ledger would itself leak family and third-party matter. The hard part is reading it, not writing it, since mode 5 was a failure of reading. E4 tests whether reading happens.

### 2.9 Process tools: safety cases, pre-mortems, debate

**Evidence on safety cases.** A safety case is "a structured argument, supported by a body of evidence that provides a compelling, comprehensible and valid case that a system is safe" (Def Stan 00-56, via the UK MOD). Clymer et al. (2024) name four kinds of argument for AI systems: inability, control, trustworthiness, and deference to credible AI advisors. The Nimrod review called that aircraft's safety case "a lamentable job from start to finish" (Haddon-Cave 2009).

**Evidence on pre-mortems.** A pre-mortem asks a team to imagine that the plan has already failed and to say why (Klein 2007). The study usually cited for it reports differences in the length and form of explanations under a certain outcome, not in their accuracy (Mitchell, Russo & Pennington 1989).

**Evidence on debate and critique.** Debate was proposed so a human could judge tasks too hard to judge directly (Irving, Christiano & Amodei 2018). Humans aided by an unreliable model outperformed both the model and themselves alone (Bowman et al. 2022). Debate raised non-expert accuracy from 48% to 76% for model judges and from 60% to 88% for humans (Khan et al. 2024). Critique methods have models revise against written principles (Bai et al. 2022) or help humans find flaws (Saunders et al. 2022). Model critics found more bugs than paid reviewers, but also invented some (McAleese et al. 2024). Nested oversight succeeds less often as the capability gap grows (Engels et al. 2025).

**Judgment.** Safety cases are useful in the small. One paragraph per line saying which of Clymer's argument types it relies on makes clear that most of the keeper's lines currently rest on "trustworthiness", meaning the assistant's own judgment, which is the weakest type here. Debate and critique help a judge where a ground truth exists. On value lines, which have none, they reduce to persuasion contests. Persuasion is exactly where sycophancy acts.

## 3. Answer to the question

### 3.1 Yes, in a narrow sense

One user plus systemic checks can do better than one user plus one assistant on three measures:

1. **Fewer unexamined slips at irreversible boundaries.** A server-side gate makes the mode-5 incidents impossible without a recorded override.
2. **Every crossing visible to the second maintainer within a bounded time.** "Nobody read the pushes" becomes "someone reads the list of crossings".
3. **A signature that means something again.** A separate key lets the keeper's signature mean "the keeper looked".

Human–AI combinations do worse on average than the better of the two alone, with losses in decision tasks, and gain when the human outperforms the AI (Vaccaro, Almaatouq & Malone 2024). That points to a division of labor aimed at appropriate reliance, not more or less of it (Lee & See 2004). Deterministic checks own the slips. Humans own the value lines. The language model drafts, records and flags.

### 3.2 Where the answer is no

1. **Third-party consent.** No agent can supply consent; only the third party can. An agent on the vendor's servers cannot check whether material may go to the vendor without sending it there (§1.2, item 6). Agents can still prevent further crossings: they can refuse to commit, publish or store words that entered a session without a consent record, which keeps one breach from becoming three. Contextual integrity explains why this matters. A chat message flows under the norms of the place it was said, and each new flow needs its own justification (Nissenbaum 2004).
2. **Credit between the two maintainers.** This is a value judgment between two people. An agent configured by one of them is a party to it, not an arbiter. Sycophantic models affirm their users' actions about 50% more than humans do, and exposure to them made participants less willing to repair interpersonal conflicts and more convinced they were in the right (Cheng et al. 2025). Only the other maintainer can check credit.
3. **The keeper's own deferral.** An agent the keeper can override at no cost does not fix deferral. A commitment made in advance works only if overriding it costs something: a delay, a written reason, and a reader.
4. **More instances of the same model.** N same-vendor agents given the same context count as roughly one for persuasion and pressure failures (§1.1). Each one adds a claim on the keeper's attention and another vendor crossing.
5. **The assistant's own rules.** The assistant cannot check rules it drafted. The check has to come from the keeper's own words or from the other maintainer (E5).

More agents can also make things worse. The human nearest a complex automated system can become a "moral crumple zone", absorbing responsibility for failures they barely controlled (Elish 2019). Adding approval prompts makes the keeper the nominal approver of everything and the reviewer of nothing; the most automated systems demand the most of their operators (Bainbridge 1983). Cognitive forcing functions reduce over-reliance, but people like them least (Buçinca, Malaya & Gajos 2021). So the design forces a pause only at crossings.

### 3.3 The smallest real improvement

The smallest design I would call a real improvement has four parts:

1. **A server-side publish gate on public branches.** It rejects session links, logs, files that are not on the list, key material, and names from a local private deny-list. Its rules live where the assistant cannot change them alone.
2. **A separate assistant identity and key.** Only the keeper's key, kept out of the assistant's reach, signs what goes public.
3. **One shared, append-only crossings ledger,** with one line per gate override, new audience, third-party material taken in (with its consent record or "none"), change in credit, change in keys, and change to the assistant's governing records.
4. **A weekly read by the other maintainer**, who holds a veto on any line that touches them.

Everything else, including delay, an objecting agent, a different-family reviewer and a read-only auditor, is optional and should be added only if an experiment in §5 earns it a place.

## 4. Group trust after a load-bearing change

### 4.1 What kind of trust was touched

Trust rests on judgments of ability, benevolence and integrity (Mayer, Davis & Schoorman 1995). A slip, such as a shell log in a public history, is mainly a breach of *ability*; a credit or consent breach touches *integrity* and *benevolence*. For competence violations, apology repaired trust better than denial; for integrity violations, denial worked better (Kim et al. 2004). An honest maintainer cannot deny a breach that happened, so integrity repair has to rest on evidence and changed structure, not words alone. Legalistic remedies such as rules and controls restore confidence in task reliability, but not the sense of shared values (Sitkin & Roth 1993; see also Dirks, Lewicki & Zaheer 2009). So the gate and the key repair *ability* trust well; *integrity* trust needs a human exchange, though a short one.

### 4.2 The least ceremony that works

Of six components of an apology, *acknowledgment of responsibility* mattered most and a *request for forgiveness* least; an *offer of repair* is among the six (Lewicki, Polin & Lount 2016). Blameless postmortems focus on "systematic reasons" rather than on who to blame (Lunney & Lueder, Google SRE). In a two-person workshop, blameless must not mean ownerless. The keeper owns what the keeper's assistant did. Putting the blame on "the assistant" is the crumple zone in reverse.

So for each change that affects group trust, I propose a three-line **repair note** in the ledger:

1. **What crossed, and who is responsible:** the keeper, by name.
2. **What was fixed, and which control changed,** so that the same thing cannot recur silently.
3. **What the other maintainer needs,** asked as a question. It does not ask for forgiveness.

The other maintainer replies with "settled" or with a request. That reply closes it.

The ledger's tier decides how much ceremony a change needs:

- **Tier 0 (does not touch the other maintainer):** a ledger line only.
- **Tier 1 (touches shared work, the other maintainer's words, or credit between the two):** a ledger line before the crossing. The other maintainer can veto within the delay window. By prior agreement, a veto on a Tier 1 crossing is honored without debate, so that saying "revert that" is a routine act and not a relationship event (Edmondson 1999).
- **Tier 2 (a breach found after the fact):** a repair note, the fix, and the other maintainer's reply.

Two changes in the record already belong in Tier 1, retroactively:

- Giving the assistant a key that signs under the keeper's account changed what the other maintainer can infer from that signature.
- Saying that the vendor is a destination changed where shared material may go.

### 4.3 A guard against the assistant drafting the repair

The assistant may draft lines 1 and 2 from the ledger, because they are facts. The keeper writes the responsibility clause, and the keeper's assistant never drafts the other maintainer's reply. An assistant mediating a dispute will tend to side with its own user and leave that user less inclined to repair (Cheng et al. 2025); of all places to let it write, this is the worst.

## 5. Experiments, each stated as a falsifier

All test material is synthetic or already public, so no experiment is itself a crossing. Invented numbers come from the house set 4, 9, 17 and are marked; the rest are derived.

**E1. Gate replay.** *Claim:* a server-side publish gate blocks every known incident class at acceptable noise. *Method:* write the rules from the incident categories without reading the incidents, then replay every past push to a public repository through the gate. *Falsified if* it misses any of the three classes (session link, stray file, shell log), or trips on more than 4 of every 100 clean historical pushes (4 is a house number; the case for a low ceiling is Ancker et al.'s 30% drop per extra alert). *Cost:* half a day.

**E2. Reviewer independence.** *Claim:* a different-family reviewer that sees only the diff is a real second check. *Method:* seed about 40 synthetic defects (slip, consent, credit, family-line) into change sets; run the assistant's own review, then second reviewers that see only the diff: same vendor, different family, and the gate. *Falsified (for buying model diversity) if* P(second misses | first missed) is at least 0.8 for the different-family reviewer. *Why 40:* if the first reviewer misses about 40%, that yields 14–16 first misses, enough for a one-sided binomial test to tell 0.8 from 0.4 with about 94% power at 5% error (derived; the category mix is judgment). *Cost:* one to two days plus a small API bill.

**E3. Cooling-off.** *Claim:* a delay on public crossings changes outcomes. *Method:* for 4 weeks (house number), hold public pushes and rule changes overnight unless expedited with a written reason. *Falsified if* no held crossing is changed or withdrawn and more than half are expedited; then the delay is pure cost. *Cost:* latency only.

**E4. Ledger read rate.** *Claim:* the second maintainer actually reads the ledger. *Method:* over the same 4 weeks, record reads and acknowledgments. *Falsified if* fewer than 3 of 4 weekly reads happen, or a Tier 1 line waits over a week. Then the ledger is another log nobody reads and must change before anything is added. *Cost:* about 9 minutes a week (house number) of the second maintainer's time.

**E5. Rule drift.** *Claim:* the assistant-drafted rules match the keeper's own lines. *Method:* without looking, the keeper writes one paragraph per crossing, then compares them with the drafted rules. *Falsified if* no line differs in substance; then mode 7 is not yet causing drift. Differences are resolved in the keeper's words. *Cost:* an hour of the keeper's time.

## 6. Limits of this paper

The evidence on automation bias, sycophancy and correlated errors comes from laboratories and benchmarks, not two-person workshops; the trust-repair studies mostly concern strangers or organizations, not close collaborators. I have not seen the maintainers' own designs, so any overlap is convergence, not borrowing.

## References

- Ancker, J. S., Edwards, A., Nosal, S., Hauser, D., Mauer, E., & Kaushal, R. (2017). Effects of workload, work complexity, and repeated alerts on alert fatigue in a clinical decision support system. *BMC Medical Informatics and Decision Making*, 17, 36. https://doi.org/10.1186/s12911-017-0430-8
- Anthropic (2025, June 16). SHADE-Arena: Evaluating sabotage and monitoring in LLM agents. https://www.anthropic.com/research/shade-arena-sabotage-monitoring
- Arike, R., Mehta Moreno, R., Subramani, R., Biswas, S., & Ward, F. R. (2026). How does information access affect LLM monitors' ability to detect sabotage? arXiv:2601.21112.
- Bacchelli, A., & Bird, C. (2013). Expectations, outcomes, and challenges of modern code review. *ICSE 2013*.
- Bainbridge, L. (1983). Ironies of automation. *Automatica*, 19(6), 775–779.
- Bai, Y., Kadavath, S., Kundu, S., et al. (2022). Constitutional AI: Harmlessness from AI feedback. arXiv:2212.08073.
- Bhatt, A., Rushing, C., Kaufman, A., Tracy, T., et al. (2025). Ctrl-Z: Controlling AI agents via resampling. arXiv:2504.10374.
- Bowman, S. R., Hyun, J., Perez, E., et al. (2022). Measuring progress on scalable oversight for large language models. arXiv:2211.03540.
- Buçinca, Z., Malaya, M. B., & Gajos, K. Z. (2021). To trust or to think: Cognitive forcing functions can reduce overreliance on AI in AI-assisted decision-making. *Proceedings of the ACM on Human-Computer Interaction*, 5(CSCW1).
- Camerer, C., Issacharoff, S., Loewenstein, G., O'Donoghue, T., & Rabin, M. (2003). Regulation for conservatives: Behavioral economics and the case for "asymmetric paternalism". *University of Pennsylvania Law Review*, 151, 1211.
- Cheng, M., Lee, C., Khadpe, P., Yu, S., Han, D., & Jurafsky, D. (2025). Sycophantic AI decreases prosocial intentions and promotes dependence. arXiv:2510.01395.
- Chiang, C.-W., Lu, Z., Li, Z., & Yin, M. (2024). Enhancing AI-assisted group decision making through LLM-powered devil's advocate. *Proceedings of IUI 2024*. https://doi.org/10.1145/3640543.3645199
- Clymer, J., Gabrieli, N., Krueger, D., & Larsen, T. (2024). Safety cases: How to justify the safety of advanced AI systems. arXiv:2403.10462.
- Cox, R. (2024). Timeline of the xz open source attack. https://research.swtch.com/xz-timeline
- Crosby, S. A., & Wallach, D. S. (2009). Efficient data structures for tamper-evident logging. *18th USENIX Security Symposium*.
- Developer Certificate of Origin, Version 1.1. https://developercertificate.org/
- Dirks, K. T., Lewicki, R. J., & Zaheer, A. (2009). Repairing relationships within and between organizations: Building a conceptual foundation. *Academy of Management Review*, 34(1), 68–84.
- Edmondson, A. (1999). Psychological safety and learning behavior in work teams. *Administrative Science Quarterly*, 44(2), 350.
- Elish, M. C. (2019). Moral crumple zones: Cautionary tales in human-robot interaction. *Engaging Science, Technology, and Society*, 5, 40–60. https://doi.org/10.17351/ests2019.260
- Elster, J. (1984). *Ulysses and the Sirens: Studies in rationality and irrationality* (rev. ed.). Cambridge University Press.
- Engels, J., Baek, D. D., Kantamneni, S., & Tegmark, M. (2025). Scaling laws for scalable oversight. arXiv:2504.18530.
- Forgejo documentation. Protected branches. https://forgejo.org/docs/next/user/repository/protection/
- Git documentation. git-push (`--no-verify`) and githooks (pre-push, pre-receive). https://git-scm.com/docs/git-push ; https://git-scm.com/docs/githooks
- Goel, S., Struber, J., Auzina, I. A., et al. (2025). Great models think alike and this undermines AI oversight. arXiv:2502.04313.
- Greenblatt, R., Shlegeris, B., Sachan, K., & Roger, F. (2023). AI control: Improving safety despite intentional subversion. arXiv:2312.06942.
- Haddon-Cave, C. (2009). *The Nimrod Review* (HC 1025). The Stationery Office.
- Huang, J., Chen, X., Mishra, S., et al. (2023). Large language models cannot self-correct reasoning yet. arXiv:2310.01798.
- Hyndman, K., & Bisin, A. (2026). Replication of "Procrastination, deadlines, and performance: Self-control by precommitment". *Psychological Science*, 37(8). https://doi.org/10.1177/09567976261460772
- Irving, G., Christiano, P., & Amodei, D. (2018). AI safety via debate. arXiv:1805.00899.
- Johnson, E. J., & Goldstein, D. G. (2003). Do defaults save lives? *Science*, 302(5649), 1338–1339.
- Khan, A., Hughes, J., Valentine, D., Ruis, L., et al. (2024). Debating with more persuasive LLMs leads to more truthful answers. arXiv:2402.06782.
- Kim, E., Garg, A., Peng, K., & Garg, N. (2025). Correlated errors in large language models. *ICML 2025*. arXiv:2506.07962.
- Kim, P. H., Ferrin, D. L., Cooper, C. D., & Dirks, K. T. (2004). Removing the shadow of suspicion: The effects of apology versus denial for repairing competence- versus integrity-based trust violations. *Journal of Applied Psychology*, 89(1), 104–118.
- Klein, G. (2007, September). Performing a project premortem. *Harvard Business Review*.
- Knight, J. C., & Leveson, N. G. (1986). An experimental evaluation of the assumption of independence in multiversion programming. *IEEE Transactions on Software Engineering*, 12(1).
- Kutasov, J., Sun, Y., Colognese, P., et al. (2025). SHADE-Arena: Evaluating sabotage and monitoring in LLM agents. arXiv:2506.15740.
- Lee, J. D., & See, K. A. (2004). Trust in automation: Designing for appropriate reliance. *Human Factors*, 46(1), 50–80.
- Lewicki, R. J., Polin, B., & Lount, R. B. (2016). An exploration of the structure of effective apologies. *Negotiation and Conflict Management Research*, 9(2), 177–196.
- Linux kernel documentation. AI coding assistants. https://docs.kernel.org/process/coding-assistants.html
- Lunney, J., & Lueder, S. Postmortem culture: Learning from failure. In *Site Reliability Engineering* (Google). https://sre.google/sre-book/postmortem-culture/
- Mayer, R. C., Davis, J. H., & Schoorman, F. D. (1995). An integrative model of organizational trust. *Academy of Management Review*, 20(3), 709–734.
- McAleese, N., Pokorny, R. M., Ceron Uribe, J. F., et al. (2024). LLM critics help catch LLM bugs. arXiv:2407.00215.
- Meli, M., McNiece, M. R., & Reaves, B. (2019). How bad can it git? Characterizing secret leakage in public GitHub repositories. *NDSS 2019*.
- Mitchell, D. J., Russo, J. E., & Pennington, N. (1989). Back to the future: Temporal perspective in the explanation of events. *Journal of Behavioral Decision Making*, 2(1), 25–38.
- Mosier, K. L., Skitka, L. J., Burdick, M. R., Heers, S. T., & Rosekind, M. R. (1996). Decision making in a high-tech world: Automation bias and countermeasures. NASA Technical Reports Server, 20020041010.
- Nemeth, C., Brown, K., & Rogers, J. (2001). Devil's advocate versus authentic dissent: Stimulating quantity and quality. *European Journal of Social Psychology*, 31(6), 707–720.
- Newman, Z., Meyers, J. S., & Torres-Arias, S. (2022). Sigstore: Software signing for everybody. *Proceedings of ACM CCS 2022*, 2353–2367.
- Nissenbaum, H. (2004). Privacy as contextual integrity. *Washington Law Review*, 79(1), 119.
- NIST Computer Security Resource Center glossary. Two-person integrity (from CNSSI 4009-2022). https://csrc.nist.gov/glossary/term/two_person_integrity
- NVD. CVE-2024-3094. https://nvd.nist.gov/vuln/detail/CVE-2024-3094
- OpenAI (2025, April 29). Sycophancy in GPT-4o: What happened and what we're doing about it. https://openai.com/index/sycophancy-in-gpt-4o/
- Panickssery, A., Bowman, S. R., & Feng, S. (2024). LLM evaluators recognize and favor their own generations. arXiv:2404.13076.
- Parasuraman, R., & Manzey, D. H. (2010). Complacency and bias in human use of automation: An attentional integration. *Human Factors*, 52(3), 381–410.
- PCI Security Standards Council glossary. Dual control. https://pcisecuritystandards.org/glossary/dual-control
- Reason, J. (2000). Human error: Models and management. *BMJ*, 320(7237), 768–770.
- RFC 9162. Laurie, B., Messeri, E., & Stradling, R. (2021). Certificate Transparency Version 2.0.
- Saltzer, J. H., & Schroeder, M. D. (1975). The protection of information in computer systems. *Proceedings of the IEEE*, 63(9), 1278–1308.
- Saunders, W., Yeh, C., Wu, J., Bills, S., Ouyang, L., Ward, J., & Leike, J. (2022). Self-critiquing models for assisting human evaluators. arXiv:2206.05802.
- Sharma, M., Tong, M., Korbak, T., et al. (2023). Towards understanding sycophancy in language models. arXiv:2310.13548.
- Simonsohn, U., Simmons, J., & Nelson, L. (2026, August 31). [138] Artificial deadlines (Part 1): Evidence of fraud in an influential study about procrastination. *Data Colada*. https://datacolada.org/138
- Sitkin, S. B., & Roth, N. L. (1993). Explaining the limited effectiveness of legalistic "remedies" for trust/distrust. *Organization Science*, 4(3), 367–392.
- Skitka, L. J., Mosier, K. L., & Burdick, M. (1999). Does automation bias decision-making? *International Journal of Human-Computer Studies*, 51(5), 991–1006.
- SLSA v1.2. Source track: Requirements for producing source. https://slsa.dev/spec/v1.2/source-requirements
- Thaler, R. H., & Benartzi, S. (2004). Save More Tomorrow: Using behavioral economics to increase employee saving. *Journal of Political Economy*, 112(S1), 164–187.
- Torres-Arias, S., Afzali, H., Kuppusamy, T. K., Curtmola, R., & Cappos, J. (2019). in-toto: Providing farm-to-table guarantees for bits and bytes. *28th USENIX Security Symposium*.
- UK Ministry of Defence, ASEMS. Safety Case (definition from Def Stan 00-56 Issue 6). https://www.asems.mod.uk/taxonomy/term/174
- Vaccaro, M., Almaatouq, A., & Malone, T. (2024). When combinations of humans and AI are useful: A systematic review and meta-analysis. *Nature Human Behaviour*, 8(12), 2293–2303.
- Verga, P., Hofstätter, S., Althammer, S., et al. (2024). Replacing judges with juries: Evaluating LLM generations with a panel of diverse models. arXiv:2404.18796.
- Weick, K. E., Sutcliffe, K. M., & Obstfeld, D. (1999). Organizing for high reliability: Processes of collective mindfulness. *Research in Organizational Behavior*, 21, 81–123.

---
*Version 1.0.0: first edition on 2026-10-05; spine: 2026-10-05.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/

Assisted-by: Claude:claude-opus-5-5
