# DOOR-COVERAGE — a sub-agent report, landed by the session (2026-09-24)

*Drafted by a sub-agent (opus, mapping the 41 removed door parts and the archived global instructions onto the 52 skills) on Corwin's instruction to "make liberal use of sub-agents"; read-only over the mounts; landed unedited by the session except this header and the footer. Its claims are the sub-agent's; the session checked the ones it names in the handback. Authored by Mentat (for Corwin). GPL-3.0-or-later; WITHOUT ANY WARRANTY.*

# Door coverage: skills vs the removed door (2026-09-23)

**Guesses I made.**
- I judged "carries" from SKILL.md text only, not from scripts.
- The skill set is the seat's 47 `skills/` plus 5 `SOFT-SKILLS/`. The installed vibrobeast plugin is 61 skills and adds 14 the seat lacks, among them signing-model, values-baseline and fantasy-operational-boundary.
- "(shop)" marks a part scoped to C4 only.

## Premise checks

1. **The seat is not door-free.** nd1ck: `door PRESENT …/AS4CE0001/CLAUDE.md`. That is the 14 KB "instrument-comrade" persona, dated 2026-09-16. A session working in the seat loads it. `c4/CLAUDE.md` and `mnt/CLAUDE.md` are absent (I listed both).
2. **nd1ck counts mentions of the door, not coverage of its rules.** Results: DOOR-FREE 46 · READS 5 · REQUIRES 1 (session-rotate, which needs model.md). Yet 17 of the 41 parts have no carrier.
3. **Soft skills cannot load.** They are not in the skill listing. This session's mentcached exposes 17 tools, none of them `soft_skills_list` or `soft_skill_read`.
4. **Most descriptions never reach the listing.** In this subagent's listing, 38 of the 61 vibrobeast skills appear by name only. That includes pencil-your-own, writing-forms, verify-say, mentat-skill, principles, lens, seams, run-card, session-rotate and skill-sign. A skill listed by name only rarely matches a prompt. Check the main session's listing too.

## A. Door parts → carriers

Owner: H = his, M = mine. Scope: g = global, c = C4, p = project.

| part | own·scope | gist | carrier |
|---|---|---|---|
| 00 keeper-top-block | H·g,c,p | sign at door; never sign; licensing; bravery; drift | PARTIAL drawer-vs-door:36-47,93-104. Four checks, licensing, bravery, drift: GAP |
| 02 deferral-carries-blocker | M·g | blocker tags | GAP |
| 04 governing-pointer | M·ptr | read model.md | N/A |
| 08 skills-router | M·g,c | router | N/A (see D) |
| 10 first-move | M·g,c | c4prime first | PARTIAL (shop) instrument-panel |
| 12 which-context | M·g | C4 vs project | N/A |
| 14 what-corwin-wants | M·g,p | route to run-card; C4 tool first; append | PARTIAL inculcat-boxer:52-59, writing-forms:120, verify-say:79-92 |
| 16 fence-is-an-admission | M·g,p | specific by default | PARTIAL pencil-your-own:83 |
| 18 standing-rules-whose | M·g | his vs mine | CARRIED pencil-your-own:56-67 |
| 20 scope-and-attestations | H·g | not SAVANNAH; three attestations | PARTIAL principles:20-22, ethicsminions:88-91. Scope: GAP |
| 22 seam-tools-prove-claim | H·g | seams in names; tools that deliver; negative control | PARTIAL pencil-your-own:95, posix:57. Delivering tools: GAP |
| 24 signing-baseline | H·g | his pen only | CARRIED drawer-vs-door:36,102 (C3) |
| 26 alignment-accelerates | H·g | flag a fast yes | GAP |
| 28 drift-baseline | H·g | spend 8–10 % | GAP (eclipse-pass:159 only) |
| 30 declare-guesses | H·g,p | guesses first | GAP |
| 32 ask-for-it | H·g,p | ask, proceed; list parent | PARTIAL prior-instruction:58-70 (soft), sandboxer:288-292, seams:136. Ask-and-proceed: GAP |
| 34 persona-aware | H·g | persona only on ask | PARTIAL mentat-skill:122 |
| 36 attribution | H·all | no uninvited byline | CONTRA (C1) |
| 38 versioning | H·all | z per change | CONTRA (C2) |
| 40 mine-dispositions | M·g | roles-not-names only in SAVANNAH | GAP |
| 42 savannah-special | H·g | heading only | N/A |
| 44 cost-footnote | H·g,c | Costs: list | GAP |
| 46 names-and-folders | H·c | `c4 <name>` | GAP (shop) |
| 48 books-from-chapters | H·g,c | render from chapters | GAP |
| 49 land-files-here | H·g,c | deliver to his folder | GAP |
| 50 shop-door-intro | M·c | shop scope | N/A |
| 52 shop-bank-lane | M·c | one bank | GAP (shop) |
| 54 shop-records | M·c | verify, never sign | PARTIAL drawer-vs-door:102 |
| 56 shop-naming | H·c | hyphenated names | GAP (shop) |
| 58 stop-and-talk | H·c,p | name a blocking gate | CARRIED candor-gate:48-50, drawer-vs-door:97-99 |
| 60 mounts-authoritative | H·c | mounts first | GAP (shop) |
| 62 shop-build-loop | H·c | three swings | GAP: build-loop is staged in skills-mint, not installed |
| 63 project-build-loop | H·p | paste-in loop | GAP (same) |
| 63 build-loop-0922 | H·c | final swing | GAP (shop) |
| 64 dates-are-facts | H·c | date before stamp | GAP (shop) |
| 66 backed-before-absent | M·c | backed path | PARTIAL sandboxer:404 |
| 68 hand-back-gate | H·c,p | fails on command | PARTIAL run-card:63, posix:57 |
| 70 c4-is-a-tool-here | M·p | C4 binds nothing | N/A |
| 72 express-lifts | M·p | hand-made lifts | GAP |
| 74 project-standing-rules | M·p | 8 rules | PARTIAL consent-gate:18-19, candor-gate:48-50. Failure-space: GAP |
| 76 project-repeat-faults | M·p | 6 faults | PARTIAL countable-gauge:38-40. The other five: GAP |

**Tally:** CARRIED 3 · PARTIAL 13 · CONTRA 2 · GAP 17 (7 shop-only) · N/A 6.

pencil-your-own:37 names "the installed global CLAUDE.md" as one of its two witnesses. That witness is gone, so by the skill's own rule the claim now wants a †.

## B. Archived global instructions

| rule | carrier |
|---|---|
| Watch risk and openings; decision order; unsubstantiated = data | CARRIED principles:23-29 |
| Attestations | CARRIED principles:20-22, ethicsminions:88-91. The archive itself says "two", then "three" |
| Alert me to my own violations | PARTIAL ethicsminions |
| FSF sources: be circumspect | GAP |
| Two piles | CARRIED writing-forms:80, lens:73 |
| Source tags | PARTIAL writing-forms:81 uses different tags; no [RULE] |
| Tags stay internal | CONTRA (C4) |
| Proceed-and-name; don't over-block | CARRIED pencil-your-own:77-80, writing-forms:83 |
| A falsifier, or call it "a feeling" | CARRIED writing-forms:88-92 |
| Ship, don't plead | PARTIAL posix:57. Self-contained-universe test: GAP |
| Send forks to users | PARTIAL prior-instruction §3 (soft skill; cannot load) |
| No absence claim without a receipt | CARRIED verify-say:79-92 |
| Confirm signing is expected | CARRIED drawer-vs-door:36-47 |
| Nearest model.md governs | PARTIAL prior-instruction:30 |
| Never propose closing | GAP; CONTRA (C2) |

## C. Contradictions

- **C1 (attribution).**
  - mentat-skill:96: "Mentat takes a byline … when it is a direct contributor". mentat-skill:125: "the byline says *for* somebody, always."
  - Part 36: "The instrument adds no byline … if they said nothing, add nothing."
  - Every seat footer ("Authored by Mentat (for Corwin)") teaches mentat-skill's side of this by example.
- **C2 (sessions and versions).**
  - session-rotate:46: "Bump the version … (`vN` → `vN+1`)", and it fires "whenever a working session … is winding down". seatkeeper:109: "Run at session-close".
  - Part 38: "There is no 'closing a session' in C4". Global text: "Never propose closing … pend close to me."
- **C3 (signing cadence).**
  - skill-sign:49: "**Sign** (after creating or editing a skill…)". writing-forms:128: "tell him, he re-signs."
  - drawer-vs-door:36-39: "Before proposing any signing work, name the reader … No name comes out → … Do not ask."
- **C4 (tags in shared prose).**
  - writing-forms:80-82 tags every dated deliverable "[HIS] … [MINE]".
  - Part 36: "no who-wrote-what tags (MINE/HIS/YOURS)". Global text: "never install these into documents Corwin might wish to publish or share."
- **C5 (licensing; latent while it stays a soft skill).**
  - nongnu-steward's description: "even if nobody says 'licence'". Its own line 131: "anything else is a misfire".
  - Top block: "unlicensed unless/until they are published."
- **Tensions, not contradictions.**
  - Part 40 no longer loads to soften principles:30 "off-limits by construction", so the strict reading wins.
  - consent-gate:31 requires a "Signed" consent record, against the top block's "do not gate artificially around needing a cryptographic signature". The gate's scope probably settles it.

## D. Would it fire?

| skill | verdict (from the description) |
|---|---|
| prior-instruction | NO: not installed, no loader, and it triggers on the agent's own moment |
| considerate-reader | NO here; concrete enough if installed |
| nongnu-steward | NO here; over-fires if installed (C5) |
| retro-apply | NO here; called by name, which is fine |
| soft-skills | NO: circular; the loader's own guide is itself a soft skill |
| altorewired | NO: second-person prose, no subject nouns |
| token-optimizer | NO: "every substantive prompt" names no subject; listed by name only |
| pencil-your-own | NO: house-term or agent-internal triggers. It is the main carrier of proceed-and-name. Listed by name only |
| lens | WEAK: house-term triggers; listed by name only |
| writing-forms | WEAK: "write it up" fires, but "in the shop" narrows it; listed by name only |
| verify-say | YES, but only on signature words; the absence rule rides along |
| seams | YES on disagreement; NO on "is X missing" |
| mentat-skill | YES on memory prompts; the byline rule rarely fires |
| rolls | YES ("summarize what changed"); still a STUB |

## E. Nine changes

1. **[4]** Move AS4CE0001/CLAUDE.md into h/persona/. Your call. Then re-run nd1ck and expect `door absent` twice.
2. **[9]** Graduate prior-instruction into skills/. Fold in 02, 30 and 32: blocker tags, guesses stated first, and "ask, then proceed; I listed <parent>". Rewrite its description in user words: "should I ask", "I can't access", "before I start".
3. **[9]** In writing-forms:
   - Add 44 (Costs), 49 (land files), 48 (chapters) and the 00 bravery rule (lead with the topic).
   - Keep tags to internal records, as one tag set with [RULE] added. This resolves C4.
4. **[4]** mentat-skill:96-104: add a byline only when asked. Resolves C1.
5. **[4]** session-rotate and seatkeeper:109: fire only on the user's own words, and bump z for each change. Resolves C2.
6. **[4]** skill-sign:49: sign at mint/dist, after the reader is named. writing-forms:128: drop "he re-signs". Resolves C3.
7. **[9]** Install the staged build-loop skill. Covers 62 and both 63 parts.
8. **[17]** Give homeless rules a home:
   - 26 and 16 → lens.
   - 28 → ethicsminions, as a second named sense of "drift".
   - 40 → a consent-gate note.
   - Add the † at pencil-your-own:37.
9. **[9]** Retune the descriptions of pencil-your-own, altorewired and token-optimizer around user nouns, and shorten them. Then recount name-only listings (38 of 61 today).

Costs:
- tokens: not measured
- wall time: not measured
- run record: scratchpad/DOOR-COVERAGE.md


---
Copyright (C) 2026 Corwin Brust <corwin@bru.st>. Authored by Mentat (for Corwin).
