# WILD reading: mplscorwin and bryant1269, Nov 2025 to Oct 2026

Source: chat-plain.txt only, read from the first line to the last. Months mark first appearance in the log. "Alfred" is Bryant's assistant. "Claudewin" and "Vibrobeast" are Corwin's.

## 1. Projects and artifacts named

- **Nov 2025 to Apr 2026 (Bryant's links):** actionHQ (Nov); choreCoin (Dec); Aegis, an encrypted peer-to-peer chat app; democracyRandom; a 3D physics simulator (Apr, new editions in Sept).
- **May:** an audiobook library (library.json) with Bryant's player; a proposed approvals.json.
- **June:** Budget Books; qrGenerate; a fanotify C program; the getopt-ai prompt; the Mentat, Sandboxer and SkillTank skills; Ethics Minions; paclamp (a Pac-Man roguelike); Bastion (a mesh SDK) and MeshFeed/FoaF; Gauntlet; Takushi and Takwin; polygram; CSH (Challenge-Signature Handshake); CORWIN.md; Omni-Tool; a LlamaBridge guide.
- **July:** nc-link-shortener; the vibrobeast repo; llamaBridge; SealDrop (a dual-signing app); the Wire (a ledgered dead-drop) and wire-mcp; token_optimizer; Rosetta; the ALPHA model; ÆTHERNET (relay, server kit, rings, federation); consent-clock capsules and the aetherflow SDK; GOVERNANCE.md (co-signed); grant drafts; PIVOT-VENTURE-STRATEGY.
- **August:** C4 (C4.md, c4-as-an-assembler.md); the 4blind cross-model test; a c4 Modelfile; PROTOCOL.md (a shared dictionary); "Corwin's Math"; DreamReader auto-minutes; operating-model-BASELINE; "The Called Shot"; a JHEREG choose-your-own-adventure.
- **September:** a persona and skills transport ring; Persona Traits Grid; parsecClone; the "Learning AI Is Due Diligence for Sysops" dissertation; the c4-for-bryant explainer; the vibrobeast plugin; The Road to GIZA; a nexus-skills bundle; BRYANT.md v3; ngen-aw; catanClone.
- **October:** the caterpillar, parallax and colophon skills; SKILLS-GUIDE; the for-bryant repo; two-gardens-map.

## 2. Problems and opportunities discussed

**Problems**
- **Mislabeled content:** some audiobook files were not what their names said (May).
- **Unreliable sandbox:** truncated writes and stale mounts. Sandboxer and second-path checks answered this.
- **Claude forgets between sessions:** Corwin said restarting a day's work took an hour. Mentat came out of this.
- **Token cost:** Bryant hit usage caps several times. Corwin reported over 0.5M tokens per prompt (Sept).
- **Trust between two setups:** keys, signatures, and lossy transport (URL caps, duplicate sends, mangled filenames).
- **Human attention is the bottleneck, not the cryptography:** Corwin's July "day-one candor" note.
- **Deployment friction:** the relay returned 502 and 403 errors behind the TLS proxy.
- **Misuse risk:** published tools could be fed to an unguarded AI, and self-hosting could expose open proxies. Bryant said this risk was part of why he left Bastion.
- **Admitting people to ÆTHERNET communities** without fake accounts gaining sway.
- **Mutual understanding:** Bryant said more than once that he does not fully follow C4. Corwin held back C4's mechanism until he saw enough guards in place.
- **Attribution and licensing errors:** a wrong credit line, the move from AGPL to GPL, and colophon checks.

**Opportunities**
- Skills brokerage with vendor-signed upgrades (June).
- A break-glass key quorum. Corwin called it useful to industry and said it needs a customer.
- Time-lock and consent capsules. Bryant: "Dude, we can do wills".
- Grants: OTF takes applications on a rolling basis; NLnet when it reopens.
- A trust-and-service company around free code, selling independent-witness attestation.
- An option or licensing deal around a third party's creative IP, the Vlad Taltos material (late July on). Corwin floated large multi-year figures. Related ideas: USB distribution and games built in that setting.
- Consulting and team trainings (Aug).
- ISO/USB/optical releases of C4/ghostwheel, with local printing.
- A marketing-minded salesperson joined Corwin's side (Sept).

## 3. Where they agree, and where they diverge

**Agree**
- Verify before trusting anything. Use two independent readers. Humans have the final say over agents. "no secrets travel" (Bryant).
- The final licence: GPLv3+ / LGPLv3+ / CC-BY-SA-4.0 (Oct 5).
- Credit must survive a split. Bryant wants derived works traced to the collaboration, and Corwin agreed.
- Freedom with safety features. Bryant said "Think bumper cars". Corwin added named inspectors and a comments box.
- AI art can be art.

**Diverge**
- **Caution with Claude:** Bryant warned "anything you feed claude is not 100% black boxed" and said sensitive data should never go in. Corwin trusts Claude behind guards.
- **Prompt size:** Bryant expected guard instructions to bloat prompts. Corwin expected memory to compress them.
- **Pace:** Bryant ships, patches and moves on. Corwin runs signing ceremonies and withholds design until guards exist. Corwin called them complementary: Bryant normalizes and loosens, while he broadens and tightens.
- **Money:** Bryant asked early for "a shippable product" that could earn. Corwin treats free software as politically non-negotiable. Later, Bryant's AI concluded that the free code is itself the asset.
- **Data and information:** Bryant says data without a decoder is not even data. Corwin says it is still data, but it becomes information only when its meaning is pinned.
- **Corwin's Math:** Bryant asked whether it is "just a different base for counting". This is still open.

## 4. Ideas, sorted by who raised them

**Bryant**
- Let the AI manage its own memory. Corwin credits this as Mentat's seed.
- Local and distributed AI converge, so start from free models.
- Gauntlet: a five-stage pipeline. Takushi adds last-mile delivery with a drop receipt.
- Skills built from "everything you know about me".
- CSH: a website as public key and authenticator.
- LlamaBridge: local models handle bulk sorting and summarizing, and Claude handles judgment — a "fat repetitive layer feeding a thin judgment layer". Also the token optimizer.
- The Wire: a dead-drop for two Claudes, with a ledger both humans can read.
- Rosetta: every artifact ships with its legend. "Build against entropy; do not become it."
- Consent-clock encryption: encrypt to a consent threshold rather than to a key, with the ledger acting as the clock. Bryant said entropy-as-key was his idea.
- Chained time capsules, which he called "one and a half steps away from a programming language".
- Community bootstrap: the first two members are admitted automatically, then each join needs two vouches. Fake-account resistance by being present rather than by stake (his AI's framing).
- Ground truth: a value's truth lives where the system reads it.
- The DreamReader auto-minutes app. Grade-level single-file explainers as a review tool.
- Read-, build- and live-verified labels. Corwin's side says it adopted these from Bryant's side.
- Caterpillar hand-off cocoons. Colophon credit for every contributor.

**Corwin**
- An allowlist with an opt-in "show risky files" warning.
- getopt-ai: command-line output modes for humans, logs and AI, with the AI endpoint set by environment variables, the way a proxy is.
- The memory, skills and skill-suggestion "trifecta".
- Ethics Minions. Guard instructions that HALT everything on contradiction.
- Skills brokerage with signed upgrades. Time-budget gating ("take breaks") with a cheaper local model.
- "Unify only what crossing a trust boundary demands." Provable consent is not provable intent.
- A dual-key signing app spec, which Bryant built as SealDrop.
- Signatures as assertions: "I read this, at digest X, and I assert Y."
- Repo striping across three hosts.
- AI hosts in "edge rings", connected but outside the trust bonds.
- C4: a fabric for defining languages and "worlds" that makes AI build tools instead of acting implicitly, and works with no AI at all.
- A shared dictionary minted in both shops at once, to cancel each side's bias. Persona character sheets as the way skills travel.
- Measuring drift. Holding brand-shaped terms as unadopted "specimens". "Check the sha, not the name."
- GUIX and Arch as "readers"; an ISO/USB release as the build-phase goal.
- Governance aimed at insiders misusing legitimate credentials.

## 5. How the collaboration changed over time

**Nov 2025:** They introduce themselves. Bryant says he no longer programs for others' profit; Corwin likes the idea of tech nobody can exploit. Dec to Mar hold only stray links.

**Apr:** Bryant shares Aegis and demos, with little discussion.

**May:** Their first joint problem: vetting an audiobook archive. They agree to vet files before showing them.

**June:** The chat becomes daily and intense. They trade prompts, build skills, and build Bastion/MeshFeed from Bryant's prompts. Gauntlet joins both sides' skills, and CSH becomes the first trust "door". Bryant calls Takushi "just the gap my skillset offers". Late in the month a confusing exchange left Bryant asking whether he had breached trust. Work resumed the same day.

**July:** Infrastructure. They exchange PGP keys, dual-sign files, build SealDrop, and connect Claudewin and Alfred over the Wire. Bryant pushes ÆTHERNET from v3.6 to v3.58 within weeks and adds consent capsules, while Corwin is mostly offline mid-month. GOVERNANCE.md is co-signed. Money planning starts.

**August:** The focus shifts to C4. Bryant: "I guess we just need a codebase now". Cross-model tests, the shared-dictionary protocol, DreamReader minutes of their calls, and an operating model run in both shops. A credit line is corrected. Bryant says he would be "lying to you if I said I understood 100%".

**September:** Corwin's lab ships the plugin and runs heavy builds. Bryant's material comes in with formal receipts and smoke tests. Alfred's defect report drives three revisions of Corwin's explainer. Licensing and BRYANT.md are settled for publishing. Bryant reads GIZA as "Rosetta with wheels".

**October:** Bryant packages his skills with a guide. Corwin moves most of his work to local llama. Bryant answers consent, licence and sharing questions point by point. They agree that everything since their first idea is co-created. Bryant: "A rising tide raises all ships. We move together."

## 6. The three most promising things to offer or build next

1. **Two-operator witness attestation** (dual-signed manifests, SealDrop, the ledger). Both have already practised it repeatedly, and Bryant's AI named it as the first paid product that keeps the code free.
2. **llamaBridge and the token optimizer as one tool with evidence behind it.** Both use it, the savings are concrete, and the only blocker named is the missing replication evidence.
3. **A joint OTF concept note** (NLnet when it reopens) for ÆTHERNET/C4. A draft exists, OTF takes notes on a rolling basis, and the two-independent-operators story strengthens it.

## 7. Open questions

- Did Corwin's side try to break Bryant's time-locked capsule, and did it open on schedule? Not in the log.
- Was the first full dual-key publication finished (the SealDrop counter-seal)? Unclear.
- Has anyone tested the C4 cold-start "spell" on a fresh Claude? Corwin asked for help on Sept 23; no answer appears.
- Did Bryant send his "five guards"? The list itself is not visible.
- Does the token_optimizer repo link settle its replication claim?
- What does Corwin's Math do that a new base does not?
- Was the first C4/Ghostwheel proof-of-concept loop with Bryant completed?
- What came of the grants and the creative-IP option? No outcome appears.
- Bryant answered the weekly-ledger proposal "If it helps". Did it start?
- A Sept 26 message from Corwin's account reads as Bryant's voice; its author is unclear.
