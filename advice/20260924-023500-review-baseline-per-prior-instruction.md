# REVIEW-baseline — a sub-agent report, landed by the session (2026-09-24)

*Drafted by a sub-agent (opus, reviewing the two retro-apply records against prior-instruction) on Corwin's instruction to "make liberal use of sub-agents"; read-only over the mounts; landed unedited by the session except this header and the footer. Its claims are the sub-agent's; the session checked the ones it names in the handback. Authored by Mentat (for Corwin). GPL-3.0-or-later; WITHOUT ANY WARRANTY.*

# Review: the two baseline records, checked against prior-instruction

Corwin: read-only; nothing written under mnt/. Each claim names its file or command.

## A. Do the records follow §6, §3 and §5?

| | 09-23 record | 09-24 record |
|---|---|---|
| decision lines | 12 | 15 rows, 16 decisions (row 23 holds two) |
| DECIDED-BY | 8 (6 instruction, 1 default, 1 preference) | 12 (10 instruction, 2 default) |
| RETAINED / ROUTED / GAP | 1 / 2 / 1 | 0 / 3 / 2 |
| ROUTED lines with a real radius | 1 of 2 | 1 of 3 |
| gaps with a numbered footnote | 1 of 1 | 1 of 2 |

**§6.** Both records label every line, but the 09-23 record leaves out the *where* or *whose* on four lines:

- line 34 (foaf) gives no source;
- line 24 (F2) calls a design fact about `pref_set` an "instruction";
- line 35 gives a default with no owner;
- line 36 gives a preference with no location.

Line 34 was later found to be a misreading (09-24 line 19, `gpg --list-packets`), yet `grep -n -i 'correct\|misread\|list-packets'` finds no correction in the 09-23 record, and lines 85–87 still rest on it.

The 09-24 record's line 17 still says the rings question was "instruction → done … the front door". The paper's Correction section says the tree had already answered it.

**§3.** The 09-23 record's line 26 is the model: *"a note sent in his name reaches other people's inboxes and cannot be unsent."* Line 39 says "radius: none; routed because the VM cannot reach them". That is a decision that needs your seat, not a fork. §6 has no label for that case, so the session used ROUTED.

The 09-24 record's line 21 is the same case. Its sentence describes a coupling that is local and testable ("a few minutes at his seat"), and under §3 step 2 the test decides. Line 22 passes: the notice would harm another person. Line 23 has no radius. The 09-23 summary ("six routed forks became one") also miscounts its own second table.

**§5.** Both footnotes give numbers and say their percentage was invented. Both report "4 canon files … 9 advice/memory notes". The 4 are named; the 9 never are, and neither record says it was invented.

The footnote that mattered was never written. 09-24 line 23 lists "gap Q522" (the ccspd mount) with no footnote. Writing one would have meant listing the words searched, `ccspd` and `ceremony`, and the absence of `ring` would have stood out.

## B. Where the miss sits in §1's order

The miss was at **step one, canon**: the registry tables and the baked h/ method. The last commit, 30715e3 (09-11), is from before the session, and everything was already in it:

| hit for "ring" | since |
|---|---|
| `evidence/terms-of-art.tsv` row 8 | 08-08 (blame) |
| `facts/ghostwheel-ring-of-rings` | 08-06 |
| `h/METHOD-lens-and-granule-ring.md` (the wearer's dial, which you approved on 09-03) and `h/DIAGRAM-poly-ccspt-ring.html` | 09-11 |
| `g/edge.gw-rings` | 09-11 |

The paper (line 39) says "the registry had no `ring` row"; row 8 was there, in the transport sense.

The miss happened again at **step three, the session**. The REFORMAT's taxonomy check (lines 152–159) notes "the wire's 'ring' exists" and then banks it as Q-b without looking it up.

One mechanical step would have caught it. Before any analytical writing, run `ls c4/h c4/facts c4/g | grep -i <noun>` for each noun of the question sentence. For "ring", the METHOD file comes straight back. The rule: nothing HAND-TURNING is banked until that grep is empty.

Two caveats:

- **The session's remedy would not have caught it.** `wd1nn`'s live lookup skips `h/`. It also stops at the first terms-of-art row: `wd1nn ring` prints "practice · hand-turning" from row 8, not the pinned row 125, and gives no path. `g/ring` fixes this word, not the next one.
- **The enclave charter was not mounted then.** That was an access gap, and it belonged in the missing Q522 footnote.

Unverified: you said the CLAUDE.md you are removing says to mount the folder; two greps of `AS4CE0001/CLAUDE.md` (`ccsp\|mount\|projects/`; `-w 'ring\|rings\|folder'`) find no such line.

## C. The HEAL guesses: how much they carry

| row | what changes under the other sense | confidence |
|---|---|---|
| transversal → traversal | Little: wd1nn already crosses every place, and "direction of" favours traversal. | 80% |
| "intermuxing person" | A lot: the gloss slips in *persona* while claiming no heal; a human go-between would make shared instructions person to person, needing each ring's consent, not a lens rule. | 60% |
| express manifests: swept means the header pass | Little: one `manifest` subcommand serves both readings. | 80% |
| momentum/mass means piles→boulders→mountains | Nothing yet (no mass rule is built); a lot once promotion is automatic. | 70% |
| "it1" | A lot: by house naming it reads as a run-level-1 twin of `it4c`, which would make this a naming miss, not lost work. `find … -iname 'it1*'` finds nothing. | 50% |
| "no decisions 'bank' work was" | Some: it decides whether REFORMATs keep writing Q-rows. | 45% |
| "both versions" read as the removed CLAUDE.md files | A lot; placed between "your baseline" and "smoothing opportunities", it more likely means the two records or verbatim vs reading, which this review covers. | 25% |
| "ghostof, as played by" | Little unless a persona sheet is minted, which is your pen (AS4CE0001/CLAUDE.md line 162). | 70% |

## D. Development plan

Sizes use the house set GRAIN 4 · GREAT 9 · GRAND 17 (sub-agent counts in `c4/h/memory/subagent-grain-great-grand.md`, borrowed as sizes): GRAIN is one file plus its prove-red, GREAT is two tools or a tool with fixtures, GRAND is a sub-agent fan-out.

| # | what | lands | check | size |
|---|---|---|---|---|
| 1 | wd1nn: match file names in `h/` and `analysis/`; print every terms-of-art row with its path | `c4/bin/wd1nn` | Against `git archive HEAD`, `wd1nn ring` finds the METHOD file; a prove-red with two planted rows sees both. | GRAIN 4 |
| 2 | prior-instruction §1: search each noun of the question; an approved `h/METHOD-*` is canon. §5: the footnote lists the terms searched | the prior-instruction SKILL.md; last-swing chapter 03 | Re-running 09-24 prints `terms: ccspd, ceremony`. | GRAIN 4 |
| 3 | A retro linter: one label per row; ROUTED needs a radius sentence that is not "none"; GAP needs N/M/K/P and terms | `AS4CE0001/bin/pi1ck` | With both records as fixtures, it flags 09-23 line 39 and 09-24 lines 21 and 23. | GREAT 9 |
| 4 | A "decided, needs his seat" label in §6 | prior-instruction §6 | 09-23 line 39, relabelled, lints clean. | GRAIN 4 |
| 5 | Doors-agree: every `wd1nn --list` word resolves in `it4c usage`, then `g/` becomes it4c's seventh vocabulary | `c4/tests/doors-agree.sh`, `c4/f/it4c.fn.sh` | Red today (aarp, recutils, ring and ceremony are in `g/`, and `it4c usage` misses all four); green after, including the Emacs side. | GREAT 9 |
| 6 | Correction back-links: a dated CORRECTION appended under the original row | retro-apply step 6 | 09-23 line 34 and 09-24 line 17 carry back-links. | GRAIN 4 |
| 7 | A coverage gauge: terms-of-art terms with no `g/<term>/` (a count, no threshold); then the LIST of MEANING backfill through `wd2nn` | `wd1nn --coverage`; sub-agents | The gauge prints N of M; `wd2nn` refuses an absent neighbour. | GRAIN 4, then GRAND 17 |
| 8 | wd2nn checks where a leaf points (`g/ceremony/c` points into `analysis/`); a `ceremony` leaf to the wearer's dial | `c4/bin/wd2nn`, `g/ceremony/` | A prove-red refuses a misplaced leaf; `wd1nn ceremony` reaches METHOD in one hop. | GRAIN 4 |
| 9 | Canon after the door: nd1ck reads 46/5/1; the one REQUIRES is `session-rotate` (needs `model.md`), and prior-instruction §1 still opens with CLAUDE.md and model.md | session-rotate SKILL.md; prior-instruction §1 | `nd1ck --strict` exits 0. | GRAIN 4 |

Items 1–4 surface this miss and the §3/§5 slips mechanically; 5–8 fix places where a tool said nothing; 9 is debt from the no-door unit test.

## E. The call-back: an ENHANCE, or a spell?

Keep it a spell, with one exception. prior-instruction §6 is a per-decision discipline that fires on small moments, and its falsifiers are counted line by line. Requiring plans and hopes in every handback would put a ceremony on every turn, which Charter A and the paper rule out ("never levied downstream"). It would also freeze a form you said you will style. `spells/last-swing/` already runs §6 first and then adds the six parts: the skill owns the lines, and the spell owns the occasion. The exception is confidence with sources. A DECIDED-BY line carries no confidence today, and the foaf line shows that a confident wrong line reads like a right one. So give each DECIDED-BY line in §6 a confidence figure and a source-checked mark, and leave the rest in the spell.


---
Copyright (C) 2026 Corwin Brust <corwin@bru.st>. Authored by Mentat (for Corwin).
