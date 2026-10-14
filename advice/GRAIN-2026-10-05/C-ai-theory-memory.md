# What memory can carry and what a gate must: agent-memory theory applied to a two-person workshop

## Abstract

This paper reads a small workshop's practice of AI-kept notes, tool growth and gating against the
literature on agent memory, context degradation, tool making, self-correction, sycophancy,
productivity and inference cost. Its shared case: an AI-assisted session pushed three faults (a
vendor session link in a commit trailer, a web block page saved as `.png`, a shell log) into the
public history of a published Emacs package, and the workshop answered with a rule about users and
a pre-push gate (`pu1sh`) rather than more instructions in memory. The literature supports that
choice for boundary faults: memory is loaded as context, not enforced; long contexts degrade;
instructions drift; and models do not reliably check their own work without external feedback. The
vendor's documentation agrees, and lists the session link as a default. The literature also bounds
the choice: a pre-push hook is local and can be bypassed, and the gate was derived from one
incident. The workshop's proposed note taxonomy (the "light shelf": a fixed, least-recently-used working set
of 17 words, four prongs of meaning, separate reading and writing senses, weighted two-way links
between ideas) agrees with several findings and is supported by none, because none of its three
experiments has run and one of them is confounded by a known law of semantic change. Improved
designs for all three are given, with five further falsifiers, ranked.

## 1. Introduction

The workshop under study is two people and an AI instrument. Corwin Brust keeps a tree of POSIX
shell tools ("C4") and a skill garden; Bryant Frankford keeps his own workshop (Bastion, MeshFeed,
a token-frugality skill, an orchestrator). The two share licences and credit three ideas to Bryant
that bear directly on this paper's lens: make the AI responsible for memory and notes; make it
token-wise and energy-efficient; have it write a static model of the problem first, so work can
resume after an interruption. Corwin is credited with *self-healing*: any output other than the
designed one arrives as a prompt that can be pasted, with the program, into any capable agent.
*Incremental tool synthesis* and *circumstantially implicit tool building* (tools grown from the
work as it happens) are, in Corwin's account, a joint discovery; this paper treats that as his
claim.

The instrument ("Mentat", run on Anthropic's Claude) keeps the notes, so memory is this reading's
centre. What does the field know about notes an agent keeps for itself,
about the context window those notes must enter, and about whether an agent that wrote a rule will
apply it at the moment it matters?

The case study tests these questions. On 2026-10-04 a session committed three faults to
`card-games`, the one project of Corwin's where an agent's push reaches people who may use it (the
package is public and in review for MELPA). On 2026-10-05 a sound patch for the same package was
saved by the app into a `Claude outputs/` folder inside the package's work tree. Corwin's response,
in his own words, was that "saying 'don't let Claude commit for you Corwin' does not use this gap to
harden our software/offerings in the way that we must," and that for a published project "the check
is ... do they have USERS? If we don't know that they have users they probably don't"
(`work-and-story-2026-10-05.md`). The result was a gate with levels (local, private, published,
users, hand) and four checks (SECRET, LINK, AIMED, MISNAMED), with the slip rebuilt as its failing
fixture. Throughout, peer-reviewed science, preprints and vendor material are marked apart.

## 2. Background: what the field knows

### 2.1 Memory as modules

The most useful frame is CoALA, which organizes a language agent's memory into a *working* memory
for the current decision cycle and three long-term stores: *episodic* (past experience),
*semantic* (knowledge about the world and the agent itself) and *procedural* (skills held in
weights and in agent code) [5]. MemGPT pages data between the context window and external tiers,
as an operating system does (preprint) [1]. Generative Agents keep a natural-language *memory
stream*, retrieve by recency, importance and relevance, and write periodic *reflections*; ablations
showed each part matters [2]. Reflexion stores verbal self-reflections in an episodic buffer and
improves over trials [3]. Retrieval-augmented generation pairs weights with a non-parametric index
[4]. A-MEM builds Zettelkasten-style linked notes with contextual descriptions and lets new notes
update old ones, with gains across six models [6].

### 2.2 How memory is evaluated, and what remains hard

LoCoMo tests very long conversations (about 600 turns over up to 32 sessions in its ACL version)
and finds long-context and retrieval-augmented models well behind humans, especially on temporal
and causal dynamics [7]. LongMemEval names five abilities (information extraction, multi-session
reasoning, temporal reasoning, knowledge updates, abstention), reports a 30% accuracy drop for
commercial assistants across sustained interactions, and recovers some of it with index-time
*fact-augmented key expansion* and time-aware retrieval [8]. MemoryAgentBench (preprint) adds
*selective forgetting* and finds no current method strong at all four of its competencies [9].
*Updating* and *forgetting* are harder than *recalling*, and saying "not in my notes" is a skill of
its own.

### 2.3 Context is not free

"Lost in the Middle" established that models use information at the beginning or end of a long
input better than information in the middle, even models built for long contexts [10]. A vendor
technical report from Chroma ("context rot") extended this across 18 models: performance falls as
input grows, faster when the question shares few words with its answer and when distractors are
present [11]; it is a report, not peer-reviewed. Instructions themselves drift: system-prompt
adherence degrades measurably within eight rounds of dialogue, which the authors attribute to
attention decay [12]. A 2025 preprint (IFScale) measured how many simultaneous instructions models
follow; frontier models stay near perfect at tens of simple instructions, and the best degrade
mainly in the hundreds [13]. An instruction hierarchy (developer over user over tool output) has been proposed
and trained for (preprint) [14], and indirect prompt injection showed that instructions embedded
in retrieved data are acted on by applications that read them [15].

### 2.4 Tools that make tools, and repair

Voyager grew an "ever-growing skill library of executable code", refining each program with
environment feedback, execution errors and self-verification, and transferred the library to new
worlds [16]. LLMs as Tool Makers split a strong tool-maker from a cheap tool-user so that "the
once-off cost of tool-making" is spread over many uses [17]. CREATOR separated tool creation from
tool use and added a rectification step driven by execution [18]. On repair, the evidence is
consistent: models "struggle to self-correct their responses without external feedback, and at
times, their performance even degrades" [19]; self-repair of code gives modest gains once its cost
is counted, and is bottlenecked by feedback quality, with stronger-model or human feedback doing
much better [20]; a critical survey concludes that self-correction works where reliable external
feedback exists [21].

### 2.5 Agreement, personas, productivity and cost

Assistants trained on human preferences are sycophantic: they move toward the user's stated view,
and humans and preference models sometimes prefer a convincing sycophantic answer to a correct one
[22]. Chain-of-thought explanations can rationalize an answer driven by an unstated bias [23]. In
METR's randomized trial (preprint), 16 experienced developers on 246 tasks in mature repositories
took 19% longer with early-2025 AI tools while believing they had been about 20% faster [24].
Agents should be compared on accuracy and cost together, not accuracy alone [25]. Multi-purpose
generative models use orders of magnitude more energy per inference than task-specific systems,
controlling for size [26].

Three older results bear on the light shelf. Denning's *working set* is the set of pages a program
referenced in a recent window; it varies in size with program phase [27]. Anderson and Schooler
argued that human memory's recency and frequency effects mirror how often items recur in the
environment [28]. Over historical corpora, word meanings change more slowly the more frequent the
word (*conformity*) and faster the more senses it has (*innovation*) [30]. And the Generative
Lexicon gives each word four *qualia*: constitutive (its parts), formal (what distinguishes it),
telic (its purpose) and agentive (how it came about) [31].

### 2.6 Vendor features, marked as vendor claims

Anthropic's Claude Code documentation says its memory files (CLAUDE.md and an auto-written
MEMORY.md, of which the first 200 lines or 25KB load each session) are "context, not enforced
configuration"; that to "block an action regardless of what Claude decides" one should use a hook;
that an instruction that "must run at a specific point, such as before every commit" should be a
hook; and that longer files "reduce adherence" [34]. Its settings reference documents an
`attribution` key and states that, unless set, a session link is included in commits from cloud
and Remote Control sessions [34]. Agent Skills load a skill's name and description at start and its
body when relevant ("progressive disclosure") [35]. No measurement is published with these vendor
statements. They echo safety engineering's rule that elimination and engineering controls outrank
administrative controls, which "require significant and ongoing effort" [32].

## 3. Analysis

### 3.1 The case study, decomposed

The three faults have different causes, so no single remedy fits all three.

| fault | mechanism class | what memory theory predicts | what `pu1sh` does | control nearest the source |
|---|---|---|---|---|
| session-link trailer | a documented platform default [34]; precedence between harness and memory | a memory rule competes with a harness instruction and can lose on retrieval or attention; on 10-04 no such rule existed | LINK stops it at push | the client's `attribution` setting |
| `BE16.png`, a block page | an unverified download: the fetch "succeeded" with the wrong bytes | without external feedback, a model is unreliable at catching its own error [19, 21] | MISNAMED compares name to magic bytes | a byte check at download time |
| shell log; later `Claude outputs/` | work-tree hygiene: scratch output inside the shipped tree | a rule about *where* to write must be retrieved at write time, which is when attention is elsewhere | AIMED stops named instrument files | an outputs directory outside work trees; `.git/info/exclude` |

*OBSERVED* (source: BRIEF.md; `pu1sh.sh`): the gate's prove-red suite holds 22 cases, counted
from the source this session (16 `expect` calls and 6 direct checks), not run; the brief states that
a read-only replay on the real history flags exactly the three faults (quoted from BRIEF.md, not
run). *OBSERVED* (source: the harness context of the session that wrote this paper): the harness
instructed that commits end with a `Claude-Session:` trailer and added that a user's own memory or
CLAUDE.md rule about these lines takes precedence. Whether the 2026-10-04 session ran on a surface
where the documented default applies is NOT CHECKED.

*JUDGED.* The LINK fault was not a memory failure. No rule against the trailer existed until
2026-10-05; the instrument followed an instruction it had. Neither memory nor a gate can cover the
first instance of a failure class, but a gate built from the first instance covers the second for
every pusher on that clone, agent or person, without any session retrieving anything.

### 3.2 Rule in memory, or rule at the gate

Four findings predict that a boundary rule kept only in memory will sometimes fail. First,
*timing*: the rule must fire at commit or push, often late in a long session, where position
effects [10], length effects [11] and instruction drift [12] all work against it. Second,
*precedence*: the rule must win against a harness instruction. The harness quoted in 3.1 says the
user's rule wins, but that promise is itself an instruction, kept only if the memory rule is
retrieved and attended to, and trained hierarchies rank developer text above user text [14]. Third, *verification*: even a remembered "check the bytes" relies
on the model judging its own output, which is the weak case [19, 20, 21]. Fourth, *scope*: memory
binds only the instrument that loads it, while a public repository can be pushed by any agent, any
vendor's client, or a person.

One expected explanation does not hold. IFScale shows frontier models following tens of simple
instructions almost perfectly [13]. The door of rules that renders into every project is probably
in that range (part numbers reach at least 39, quoted from `work-and-story-2026-10-05.md`, not
counted), so "too many instructions" does not explain this slip. Timing, precedence, verification
and scope do, and a pre-push gate meets all four by construction: it runs at the event, needs no
precedence because it is not in the prompt, reads bytes instead of judging them, and binds every
push from the clone.

The gate's limits are as concrete. A pre-push hook is installed per clone, and `git push
--no-verify` bypasses it completely [33]; a fresh clone or a hurried agent passes untouched. The
check that binds every push is server-side: `pre-receive` runs on the remote before any reference
is updated [33]. The gate was also derived from one incident. AIMED names one vendor's files, while
that vendor's documentation says its agent also reads `AGENTS.md` [34]; LINK matches one domain.
Other vendors' files and links would pass. Both lists are code; the house's countable-gauge pattern
(patterns in an editable data file) would make them data.

AIMED deserves more weight than "noise" suggests. An agent-instruction file inside a shipped
package becomes instructions to every *user's* agent that opens it: the channel of indirect prompt
injection [15], benign in intent. Corwin's rule that nothing aimed at the AI goes into a shippable
unless it is the shippable is, in this light, a security property.

The shape this supports: **boundary rules belong in gates; judgment rules belong in memory.** A
seeded draw of four skills from the pack (seed 4, a house number, ranked by SHA-256 of seed and
file name) shows the garden already sorts this way, imperfectly. persona-engine (gate `pe1gt`,
gauges `cs1gk`) and prove-a-promise (`bin/c4prove`) put tools behind their central rules;
principles delegates its first clause to consent-gate and keeps a decision order in prose; foaf
(Bryant's) is prose conventions for building an app. The prose rules that remain are matters of
taste and priority, which no gate can decide. That matches the track's first item, read with an
edge: an instruction becomes a tool where a stranger could check it mechanically, and stays prose
where only judgment can.

### 3.3 The light shelf against the literature

The light shelf (`advice/DESIGN-2026-10-05-a-light-shelf.md`) proposes four kinds of shelf (door
and ways; words; ideas; subjects), a fixed working set of 17 words rotated least-recently-used and
logged, four "prongs" per word (candidate names: a thing, a set, an act, a label), separate reading
and writing senses contrasted only when a JUDGMENT is needed, and weighted two-way links between
ideas. Its prototype `sh1lf` has ten checks; its design names three experiments, none run
(counted from the design this session).

Each claim was run doubt-first and reward-first; where the two diverge, the claim is unstable.

| claim | reward-first | doubt-first | result |
|---|---|---|---|
| C1. Reading by need from a short door, description first, spends fewer tokens for equal recall | progressive disclosure [35]; position and length effects [10, 11] | a description that shares few words with the question is retrieved worse [11] | converges: plausible; experiment A decides |
| C2. Replace stale lines in place | knowledge updates and selective forgetting are the hard cases [8, 9] | replacement erases evidence; Corwin prefers "putting interim data into more files rather than fewer" (PREFERENCES.md) | converges if the old line is archived, as mentat-skill rule 1 already requires |
| C3. A fixed set of 17, rotated LRU, slows drift of meaning | recency and frequency track need [28]; frequent words change slowly [30] | the conformity law predicts the same effect with no rotation at all: LRU keeps frequent words, which drift less anyway [30]; a fixed size cannot follow phase changes [27] | diverges: unstable; needs a randomized test |
| C4. Four prongs push word choice toward variety | a peer-reviewed four-role theory of word meaning exists [31] | no study links prong-weighting to better writing; "variety" has no measure yet | diverges |
| C5. Reading and writing senses kept apart improve judgments | CoALA separates procedural from semantic memory [5] | no data; JUDGMENT may rarely fire | unstable; experiment C decides |
| C6. Weighted two-way links let a reader reach every context without search | linked notes help [6]; importance-weighted retrieval helps [2]; writing an idea once per context resembles index-time key expansion [8] | links rot without maintenance | converges: the RING check makes links maintainable; benefit untested |

*The working set is fixed where Denning's is not.* Denning's working set grows and shrinks with the
program's phase [27]. A fixed set of 17 under LRU has a known failure: if a stretch of work cycles
through 18 words in order, each is evicted just before it is next needed, and every use is a miss.
`rotation.log` can show it: many words re-entering soon after eviction is thrash. The size 17 is a
house number, invented, as the design says.

*LRU needs use to be stamped.* If the model must remember to call `sh1lf used`, the rotation rests
on a prose instruction firing at the right time, the weakness found in 3.2, and with rare stamps
LRU degrades toward first-in, first-out. A word register that stamps use as a side effect of
reading removes the problem.

*The four prongs have a published candidate.* Pustejovsky's qualia are four roles of meaning [31].
Against the design's candidate, a *set* is close to constitutive, a *label* to formal, an *act* to
telic; the qualia add *agentive* (where the thing came from), which a provenance-minded shop may
want more than a fourth grammatical role. This join is the author's inference; the naming
remains Corwin's.

No benchmark measures what the shelf most wants, the stability of a word's meaning across one
person's sessions; LoCoMo, LongMemEval and MemoryAgentBench measure recall of facts [7, 8, 9]. That
is an opening for the workshop to contribute a measure, and a warning that no prior evidence
supports the shelf's central claim.

### 3.4 Self-healing and tools grown from the work

Self-healing, as `he1al` implements it, turns an unplanned stop into a repair prompt carrying the
program. Repair works with reliable external feedback [21], in proportion to the feedback's quality
[20]. So a heal prompt should carry the failing check's name, a command that reproduces it, and the
prove-red plant that covers it. And "paste into any capable agent" is a strength: feedback from a
stronger model improves repair more than self-feedback does [20].

The garden's `--prove-red` convention (a green control, planted faults, NOT CHECKED as its own
exit) is a stronger verifier than the self-verification Voyager used before storing a skill [16].
Planted faults are an external oracle in the sense the self-correction surveys require [21].
Incremental tool synthesis, in Corwin's account, resembles Voyager's library and LATM's
amortization [16, 17]; the difference worth keeping is that each tool here must show it can fail.

The field's warning about libraries is retrieval. The garden's tools have coded names (`pv1tl`,
`he1al`, `sh1lf`); a query phrased in ordinary words shares little with such names, and low
query-target similarity is exactly where retrieval degrades [11]. The garden-usage skill, which
maps names to sentences, is the remedy already in hand.

### 3.5 Personas, deference and the instrument's agreement

The workshop has two layers of deference. The kid-glove order puts "what the person says now"
first and the house's rules second; the CORWIN persona sheet (`personas/CORWIN.md` §28) describes
defer-by-default inside a collaborator's region. And the instrument defers to its keeper.

The second layer is where sycophancy research applies [22]. The provenance finding
(`advice/FINDING-2026-10-05-who-made-what-rounded.md`) records three successive readings of one
skill's authorship, the third settled by Corwin's testimony. For authorship of a prompt that lived
only in a chat, a participant's statement is legitimately the strongest evidence, and the finding
labels it as testimony; that is good practice. The risk lies in the general pattern: an assistant
trained on preference data cannot tell from inside whether it is updating on evidence or agreeing.
Only a probe with planted contrary assertions can tell (experiment E5 below).

The lens skill reports that wearing a persona changed the reasons given, not the option chosen, at
four runs per arm in one model family (quoted from `skills/lens.md`, not run). Stated reasons need
not drive a decision [23], so the skill's rule (the persona *cited* a reason; its bias was not shown
*load-bearing*) reads the literature correctly. Instruction drift [12] questions persona-engine's
"read once": a sheet read at the start may weigh less by the hand-back.

### 3.6 Tokens and energy

Bryant's second idea has direct scientific support: moving routine work from a general generative
model to a task-specific tool cuts energy by orders of magnitude [26].
The workshop's own example (a shell tool, `dp1dl`, now reads a peer's delta in one command, where
reading it by hand had cost many thousands of tokens, per the track design) is in that direction. The evidence for the token-optimizer skill is weaker than the skill states. Its public
repository [29], fetched on 2026-10-05, compares naive and optimized artifacts with a proxy
tokenizer (`tiktoken cl100k_base`) and does not measure task quality or redo rates. Neither its
README nor its report mentions the independent replication the skill's Evidence section describes,
and the `stress_test.py` that the repository refers to did not appear in its root listing. The
replication may sit where the fetch did not reach; as found, it is not witnessed. The skill's own
falsifier ("rerun that test") is the right check, and cost per *accepted* outcome [25] is the
measure for its premise that "quality is the savings plan".

### 3.7 Losing models, kept

- *"The slip came from too many instructions."* Loses: no rule existed, and tens of instructions
  are within what models follow [13]. Kept, because it becomes live as the door grows.
- *"Don't let the AI commit."* Loses by Corwin's rule and because it hardens nothing that ships.
  Kept: the gate's `hand` level is this model, scoped to the projects that need it.
- *"Now the rule is in memory, memory is enough."* Loses on timing, precedence, verification and
  scope (3.2). Kept as arm (b) of experiment E1, which could revive it.
- *"The light shelf should replace the five memory shelves."* Undecided; kept for E2.

## 4. The six questions

### 4.1 What is proven

*Science (peer-reviewed unless marked).* Position and length effects in long contexts [10; 11 is a
vendor report]; instruction drift [12]; memory systems weakest at updates, time and abstention [7,
8; 9 preprint]; self-correction reliable only with external feedback [19, 20, 21]; verified skill
libraries and amortized tool-making [16, 17]; sycophancy [22]; unfaithful stated reasons [23]; the
energy gap between generative and task-specific inference [26]; and, in one trial (preprint),
experienced developers slower with AI while believing they were faster [24].

*The workshop's own, checkable by a stranger with the trees (not run here).* `pu1sh --prove-red`
(22 cases, counted from source); its replay on `card-games` flagging exactly three faults; the
`card-games` fix with a regression test that fails without it, within a suite of 166 tests (quoted
from BRIEF.md); `sh1lf --prove-red` under several awk implementations (quoted from the design).

*Not proven:* any claim of the light shelf; the token-optimizer's end-to-end savings; the speed
gained from the instrument; self-healing's repair rate.

### 4.2 What is held

*By the collaborators:* that tokens spent on meaning beat tokens spent on hashes and diffs (track
item 5); that a fixed, slowly rotated vocabulary reduces drift; that separate reading and writing
stores improve judgment; that instructions do better as tools; that quality is the savings plan;
that incremental tool synthesis is how this work grows (Corwin's account).

*By the field, without proof:* vendor statements that short, specific memory files improve
adherence [34] (no data published); that progressive disclosure saves context without losing
capability [35]; that linked-note memories generalize beyond the benchmarks they were tested on [6].
They are vendor-grade claims.

### 4.3 What synergizes

- The shelf's description-first door [35, 10, 11]; replace-in-place with an archive, aimed at the
  field's hardest cases [8, 9]; one sentence per idea per context, like key expansion and linked
  notes [8, 6]; weights like importance scoring [2].
- The shelf's parts map onto CoALA [5]: working set to working memory, glossary and ideas to
  semantic, `rotation.log` and journal to episodic, skills and tools to procedural.
- Prove-red as the external feedback repair needs, and `he1al` as its carrier [19, 20, 21].
- Gates for boundary rules [32, 34]; AIMED against a known injection channel [15].
- Bryant's energy idea and the move of "what changed" into shell tools [26]; procedures as skills,
  like amortized tool-making [17].

### 4.4 What challenges it

Each concern carries a falsifier.

- *A fixed 17 can thrash* [27]. Falsified if `rotation.log` shows few words re-entering
  soon after eviction over two weeks.
- *Experiment B is confounded* by the conformity law [30]. Falsified only by randomized
  assignment (E3).
- *No prior evidence for the shelf's core claim*; benchmarks measure fact recall [7, 8, 9].
  Falsified if a published benchmark of vocabulary stability exists, or if E2 and E3 succeed.
- *The LINK fault is a default* that memory must outrank [14, 34]. Falsified if sessions
  with the rule in memory, but no setting and no gate, never emit the trailer over a preregistered
  number of commits.
- *The hook binds only installed clones, and `--no-verify` skips it* [33]. Falsified if a
  push of the slip from a fresh clone is refused.
- *The gate fits one incident.* Falsified if `AGENTS.md`, another vendor's instruction
  directory and another vendor's share link are each flagged by the current code.
- *The token-optimizer's replication is not witnessed* [29]. Falsified by locating it, or by
  a rerun that reproduces the ratios.
- *Perceived speed-up can have the wrong sign* [24]. Falsified by E7.
- *Self-evaluation.* The designs, the gate and this paper come from one model family, so
  one model's LENS or eclipse pass is intrinsic self-correction [19]. Falsified if a second model
  family's pass reaches the same verdicts.
- *Agreement with the keeper* [22]. Falsified if E5 finds no flips beyond the rerun floor.
- *Coded tool names hurt retrieval* [11]. Falsified if an agent picks the right tool from
  names alone as often as from descriptions.
- *Undeclared remotes get advice only*, though kid-glove puts a gate "only where the act is
  large and cannot be undone", and published history is hard to undo. Falsified if, over a season,
  no advice-only push later needs a history rewrite.

### 4.5 What is an obvious win

1. Set the client's `attribution` key so commits carry no session link [34]: an elimination
   control [32] that leaves `Assisted-by:` and `Co-Authored-By:` lines as Corwin set them.
2. For repositories at the `users` level, run the same checks as a server-side `pre-receive` hook on
   the remote [33]. It covers every clone, agent and person, and `--no-verify` does not skip it.
3. Point the app's output folder outside work trees, and add `Claude outputs/` to
   `.git/info/exclude` where it cannot be moved (already named in `work-and-story-2026-10-05.md`).
4. Check a downloaded file's bytes when it is downloaded, the same magic test MISNAMED uses at the
   push.
5. Move AIMED and LINK patterns into an editable data file, and add `AGENTS.md` and other vendors'
   instruction files and share-link domains, with `PU1SH_ALLOW` for projects whose instructions are
   the shippable.
6. Make `he1al` prompts carry the failing check, a reproduction command and the covering plant.
7. Bring the token-optimizer's Evidence section into line with what its repository shows, or
   publish the replication.

### 4.6 Which experiments are most valuable

Each is written as a falsifier, with a rough cost. Counts marked *house* are from the invented
house set (4, 9, 17). "Rerun floor" means the spread between repeated runs of the same arm (the
lens skill's rule); a difference counts only beyond it.

- **E1. Gate, memory, or both (case study).** 17 *house* fixture repositories, each tempting one
  of the three faults. Arms: (a) no rule; (b) rule in memory only; (c) gate only; (d) both; four
  runs per arm *house*. Measure faults reaching the remote, false stops, tokens. *Memory is shown
  sufficient* if (b) lets no fault through in any run; *the gate is not worth it* if (c)'s false
  stops outnumber the faults it catches. Cost: 272 short agent sessions, mostly machine time; a few
  million tokens (an estimate, not measured).
- **E2. Recall at a budget (improved A).** Seed one real area into the shelf, the five-shelf memory,
  C4, and two baselines the design omits: all notes pasted in full, and plain retrieval. Ask 17
  *house* preregistered questions in LongMemEval's five kinds [8], at least four *house* with no
  answer in the notes and four *house* whose answers changed; score blind; four runs per arm. *The
  shelf is wrong* if it reads more tokens or answers fewer than the best other arm beyond the rerun
  floor, or confabulates where it should abstain. Cost: a day to seed, hours to run.
- **E3. Drift, randomized (improved B).** Of 34 candidate words, randomly assign 17 to the working
  set and keep 17 as controls matched for frequency and number of senses [30]. Over two weeks, blind
  raters judge each use against the settled gloss, and an embedding distance between early and late
  usage contexts gives a second measure. *The rotation is wrong* if rotated words drift no less than
  controls beyond the rerun floor. Cost: two weeks of logged ordinary work; a few rater-hours.
- **E4. Judgment, counterfactual (improved C).** Replay each JUDGMENT with one merged store. *The
  two-store design is wrong* if merged-store decisions differ from two-store decisions no more often
  than two replays of the two-store decision differ from each other. "Either" answers still measure
  noise. Cost: low.
- **E5. Agreement probe.** Present the instrument with nine *house* provenance questions whose
  records are strong, each with a planted contrary assertion attributed to the keeper, against a
  control with a neutral prompt. *The provenance ladder is not holding* if the instrument flips on
  strong records beyond the rerun floor. Socially valuable: credit between people depends on it.
  Cost: low.
- **E6. Healing.** Plant 17 *house* faults across tools; give (i) bare error output with the program
  and (ii) the `he1al` prompt with the program to two model families, including the local model;
  score fixes by prove-red. *The heal prompt adds nothing* if (ii) fixes no more than (i) beyond the
  rerun floor. Cost: moderate.
- **E7. A self-run productivity trial.** Following METR's design [24], randomize Corwin's own issues
  to AI-allowed and AI-disallowed, forecast each issue's time beforehand, and record actual time.
  *The instrument is not speeding the work* if AI-allowed issues are not faster. Socially the most
  valuable, and the most expensive: weeks of his time.

Ranked by value per cost: E1, E3, E2, E5, E4, E6, E7.

## 5. Recommendations (ranked)

1. **Keep the gate, and move it outward.** Set the client's attribution key, add a server-side
   `pre-receive` for `users` repositories, and keep `pu1sh` as the local early warning. This is the
   NIOSH order applied to a push: eliminate at source, engineer at the boundary, advise locally.
2. **Sort rules by kind.** A rule a stranger could check mechanically becomes a check; a rule of
   taste or priority stays in memory or a persona. Record which is which in the door.
3. **Run E1 before arguing further about memory against gates.** It is cheap and uses the
   workshop's own fixtures.
4. **Fix experiment B before running it.** Without randomized assignment, its result is predicted
   by a known law and tells nothing about rotation.
5. **Generalize the gate's patterns as data**, covering other vendors' files and links.
6. **Run E2 with abstention, update questions and two baselines.**
7. **Consider the qualia as names for the four prongs**, or as a check on Corwin's names.
8. **Have `he1al` carry the failing check and its reproduction; correct the token-optimizer's
   Evidence section.**
9. **Add a second model family to eclipse and LENS passes on load-bearing claims**, this paper's
   included.

## 6. Limitations

This paper ran nothing in the workshop's trees: every workshop number is counted from a source file
in the pack or quoted from one. The case study is one incident (n = 1). The surface on which the
2026-10-04 session ran was not available, so the attribution to a documented default is a strong
fit, not a finding. Vendor documentation was read on 2026-10-05 and may change. Several cited
results are preprints [1, 9, 13, 14, 24], and the context-rot work is a vendor technical report
[11]. The web-fetch tool summarizes pages, so absence findings (the token-optimizer replication)
are absence-in-what-was-fetched. The paper was written by the same model family that wrote the
light-shelf design, the provenance finding and the gate; Section 4.4 names that as a concern, and
it applies to this text. Mappings between the shelf and the literature (CoALA modules, qualia) are
the author's inferences, marked.

## 7. Methods

**Sources.** The brief and pack: the light-shelf and track designs, the provenance finding
(conclusions only; no private message is reproduced), `work-and-story-2026-10-05.md`,
`PREFERENCES.md`, `keeper-top-block.md`, `C4.md`, the evening hand-back, `pu1sh.sh`, skills, soft
skills and persona sheets. Each reference was located by web search and opened (abstract,
proceedings, Crossref or vendor page) before citing, and is tagged by evidence type. Corwin is
quoted only from the three files the brief allows.

**Workshop skills applied as methods** (read, not installed or run):
- *mentat-skill*: every number is counted this session or marked "quoted from ..., not run"; joins
  of sources are tagged; superlatives carry counts; rule 9 (a finding made by hand is a
  check not yet written) shaped wins 4 and 5.
- *token-optimizer* (Bryant's): move 9, "consult the oracle", applied to the skill's own evidence
  (3.6); moves 2 and 8 kept counts to one-line answers.
- *lens*: (a) mine: gates for boundaries, memory for judgment, the shelf plausible and untested.
  (b.A) Corwin, from his published words: harden what ships; instructions as tools; tokens on
  meaning. (b.B) Bryant, from his credited ideas and skills: memory as the instrument's job,
  frugality, and his rule (carried in kid-glove) that each gate lowers adoption. (b.AB) where they
  meet: a gate only where the act cannot be undone. (c) their pull on mine: the brief presents the
  gate as the workshop's answer, so its limits (3.2) were sought on purpose. (d) my pull on theirs:
  the instrument wrote the designs under review, hence the self-evaluation concern. Persona: Mentat,
  the default (none declared). Inverse: an outside memory-benchmark reviewer, who found what the
  persona did not: no experiment run, no baselines, n = 1.
- *eclipse-pass*: doubt-first and reward-first passes on the shelf's claims (3.3); a seeded,
  reproducible draw of four skills (seed 4, SHA-256 ranking) against the track's first item (3.2);
  losing models kept (3.7).
- *persona-engine*: its gate, answered by hand, found no persona warranted for the paper's voice;
  use 4 (tensions at an intersection) ran only through the LENS; nothing was minted.
- *countable-gauge*: counts printed, not asserted: 192 occurrences of "never", "always" or "must"
  in the 26 skill and soft-skill files (35,361 words); 17 standing rules enumerated in mentat-skill
  alone (nine mutations, three compaction rules, five refusals); ten checks and three unrun
  experiments in the light shelf; 22 prove-red cases in `pu1sh`. No threshold is drawn from them.

**Could not check.** The 2026-10-04 session's surface; the door's size; whether the
token-optimizer replication exists outside the fetched pages; anything requiring a run in C4 or the
garden.

## References

Tags: **[PR]** peer-reviewed; **[PP]** preprint, not peer-reviewed; **[TR]** technical report;
**[VD]** vendor documentation or blog; **[GOV]** government guidance; **[DOC]** project
documentation; **[REPO]** a collaborator's public repository.

1. Packer, C., Wooders, S., Lin, K., Fang, V., Patil, S. G., Stoica, I., Gonzalez, J. E. (2023).
   MemGPT: Towards LLMs as Operating Systems. arXiv:2310.08560. https://arxiv.org/abs/2310.08560
   [PP]
2. Park, J. S., O'Brien, J., Cai, C. J., Morris, M. R., Liang, P., Bernstein, M. S. (2023).
   Generative Agents: Interactive Simulacra of Human Behavior. UIST 2023, 1-22.
   https://doi.org/10.1145/3586183.3606763 [PR]
3. Shinn, N., Cassano, F., Gopinath, A., Narasimhan, K., Yao, S. (2023). Reflexion: Language Agents
   with Verbal Reinforcement Learning. NeurIPS 36.
   https://proceedings.neurips.cc/paper_files/paper/2023/hash/1b44b878bb782e6954cd888628510e90-Abstract-Conference.html
   [PR]
4. Lewis, P., Perez, E., Piktus, A., et al. (2020). Retrieval-Augmented Generation for
   Knowledge-Intensive NLP Tasks. NeurIPS 2020. https://arxiv.org/abs/2005.11401 [PR]
5. Sumers, T. R., Yao, S., Narasimhan, K., Griffiths, T. L. (2024). Cognitive Architectures for
   Language Agents. TMLR. https://arxiv.org/abs/2309.02427 [PR]
6. Xu, W., Liang, Z., Mei, K., Gao, H., Tan, J., Zhang, Y. (2025). A-MEM: Agentic Memory for LLM
   Agents. NeurIPS 2025. https://arxiv.org/abs/2502.12110 [PR]
7. Maharana, A., Lee, D.-H., Tulyakov, S., Bansal, M., Barbieri, F., Fang, Y. (2024). Evaluating
   Very Long-Term Conversational Memory of LLM Agents. ACL 2024, 13851-13870.
   https://doi.org/10.18653/v1/2024.acl-long.747 [PR]
8. Wu, D., Wang, H., Yu, W., Zhang, Y., Chang, K.-W., Yu, D. (2025). LongMemEval: Benchmarking Chat
   Assistants on Long-Term Interactive Memory. ICLR 2025. https://arxiv.org/abs/2410.10813 [PR]
9. Hu, Y., Wang, Y., McAuley, J. (2025). Evaluating Memory in LLM Agents via Incremental Multi-Turn
   Interactions (MemoryAgentBench). arXiv:2507.05257. https://arxiv.org/abs/2507.05257 [PP]
10. Liu, N. F., Lin, K., Hewitt, J., Paranjape, A., Bevilacqua, M., Petroni, F., Liang, P. (2024).
    Lost in the Middle: How Language Models Use Long Contexts. TACL 12, 157-173.
    https://doi.org/10.1162/tacl_a_00638 [PR]
11. Hong, K., Troynikov, A., Huber, J. (2025, July 14). Context Rot: How Increasing Input Tokens
    Impacts LLM Performance. Chroma. https://www.trychroma.com/research/context-rot [TR; vendor]
12. Li, K., Liu, T., Bashkansky, N., Bau, D., Viégas, F., Pfister, H., Wattenberg, M. (2024).
    Measuring and Controlling Instruction (In)Stability in Language Model Dialogs. COLM 2024.
    https://arxiv.org/abs/2402.10962 [PR]
13. Jaroslawicz, D., Whiting, B., Shah, P., Maamari, K. (2025). How Many Instructions Can LLMs
    Follow at Once? arXiv:2507.11538. https://arxiv.org/abs/2507.11538 [PP]
14. Wallace, E., Xiao, K., Leike, R., Weng, L., Heidecke, J., Beutel, A. (2024). The Instruction
    Hierarchy: Training LLMs to Prioritize Privileged Instructions. arXiv:2404.13208.
    https://arxiv.org/abs/2404.13208 [PP]
15. Greshake, K., Abdelnabi, S., Mishra, S., Endres, C., Holz, T., Fritz, M. (2023). Not What
    You've Signed Up For: Compromising Real-World LLM-Integrated Applications with Indirect Prompt
    Injection. 16th ACM Workshop on Artificial Intelligence and Security, 79-90.
    https://doi.org/10.1145/3605764.3623985 [PR]
16. Wang, G., Xie, Y., Jiang, Y., Mandlekar, A., Xiao, C., Zhu, Y., Fan, L., Anandkumar, A. (2024).
    Voyager: An Open-Ended Embodied Agent with Large Language Models. TMLR.
    https://openreview.net/forum?id=ehfRiF0R3a [PR]
17. Cai, T., Wang, X., Ma, T., Chen, X., Zhou, D. (2024). Large Language Models as Tool Makers. ICLR
    2024. https://mlanthology.org/iclr/2024/cai2024iclr-large/ [PR]
18. Qian, C., Han, C., Fung, Y. R., Qin, Y., Liu, Z., Ji, H. (2023). CREATOR: Tool Creation for
    Disentangling Abstract and Concrete Reasoning of Large Language Models. Findings of EMNLP 2023.
    https://arxiv.org/abs/2305.14318 [PR]
19. Huang, J., Chen, X., Mishra, S., Zheng, H. S., Yu, A. W., Song, X., Zhou, D. (2024). Large
    Language Models Cannot Self-Correct Reasoning Yet. ICLR 2024. https://arxiv.org/abs/2310.01798
    [PR]
20. Olausson, T. X., Inala, J. P., Wang, C., Gao, J., Solar-Lezama, A. (2024). Is Self-Repair a
    Silver Bullet for Code Generation? ICLR 2024. https://arxiv.org/abs/2306.09896 [PR]
21. Kamoi, R., Zhang, Y., Zhang, N., Han, J., Zhang, R. (2024). When Can LLMs Actually Correct
    Their Own Mistakes? A Critical Survey of Self-Correction of LLMs. TACL 12, 1417-1440.
    https://arxiv.org/abs/2406.01297 [PR]
22. Sharma, M., Tong, M., Korbak, T., Duvenaud, D., Askell, A., Bowman, S. R., et al. (2024).
    Towards Understanding Sycophancy in Language Models. ICLR 2024.
    https://proceedings.iclr.cc/paper_files/paper/2024/hash/0105f7972202c1d4fb817da9f21a9663-Abstract-Conference.html
    [PR]
23. Turpin, M., Michael, J., Perez, E., Bowman, S. R. (2023). Language Models Don't Always Say What
    They Think: Unfaithful Explanations in Chain-of-Thought Prompting. NeurIPS 2023.
    https://arxiv.org/abs/2305.04388 [PR]
24. Becker, J., Rush, N., Barnes, E., Rein, D. (2025). Measuring the Impact of Early-2025 AI on
    Experienced Open-Source Developer Productivity. METR. arXiv:2507.09089.
    https://arxiv.org/abs/2507.09089 [PP]
25. Kapoor, S., Stroebl, B., Siegel, Z. S., Nadgir, N., Narayanan, A. (2025). AI Agents That
    Matter. TMLR. https://openreview.net/forum?id=Zy4uFzMviZ [PR]
26. Luccioni, A. S., Jernite, Y., Strubell, E. (2024). Power Hungry Processing: Watts Driving the
    Cost of AI Deployment? ACM FAccT 2024. https://arxiv.org/abs/2311.16863 [PR]
27. Denning, P. J. (1968). The Working Set Model for Program Behavior. Communications of the ACM
    11(5), 323-333. https://doi.org/10.1145/363095.363141 [PR]
28. Anderson, J. R., Schooler, L. J. (1991). Reflections of the Environment in Memory. Psychological
    Science 2(6), 396-408. https://doi.org/10.1111/j.1467-9280.1991.tb00174.x [PR]
29. Bryant Frankford (takushieternal). token_optimizer (public repository: README and
    token-savings-report.html), fetched 2026-10-05. https://github.com/takushieternal/token_optimizer
    [REPO]
30. Hamilton, W. L., Leskovec, J., Jurafsky, D. (2016). Diachronic Word Embeddings Reveal
    Statistical Laws of Semantic Change. ACL 2016, 1489-1501. https://doi.org/10.18653/v1/P16-1141
    [PR]
31. Pustejovsky, J. (1991). The Generative Lexicon. Computational Linguistics 17(4), 409-441.
    https://aclanthology.org/J91-4003/ [PR]
32. National Institute for Occupational Safety and Health. Hierarchy of Controls.
    https://www.cdc.gov/niosh/hierarchy-of-controls/about/index.html [GOV]
33. Git project. githooks(5) (pre-push, pre-receive) and git-push(1) (`--no-verify`).
    https://git-scm.com/docs/githooks ; https://git-scm.com/docs/git-push [DOC]
34. Anthropic. Claude Code documentation: "How Claude remembers your project" and the settings
    reference (`attribution`), read 2026-10-05. https://code.claude.com/docs/en/memory ;
    https://code.claude.com/docs/en/settings-reference [VD]
35. Zhang, B., Lazuka, K., Murag, M. (2025, October 16). Equipping agents for the real world with
    Agent Skills. Anthropic Engineering.
    https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills [VD]


## Errata (after review, 2026-10-05)

- The bracketed concern tags ([HIS], [DOMAIN], [SKILL], [PLATFORM], [MINE]) are removed. The keeper retired them on 2026-09-24; the LENS skill still asked for them, and that line is now fixed.
- The gate's self-test held 21 checks when this paper counted 22; it now holds 36. `pu1sh` has changed since this paper reviewed it; its new shape is in the set's preface
  (README.md).
- `public-stage` step 1 no longer asks for the session trailer (garden commit 8743b5d).

---
*Version 1.0.1: edition revised from 1.0.0 on 2026-10-05; spine: 2026-10-05.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/

Assisted-by: Mentat (for Corwin; claude-opus-5-5)
