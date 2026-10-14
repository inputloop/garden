# GRAIN tier 2: the burn-down, and the least force that does it

*For Corwin.  The four GRAIN papers (A human expectations, B Free Software engineering, C AI theory
and memory, D the skeptic's social view) burned down by models of rising size, to find the least
force that finds what is wrong with them.*

## The answer first

**No single model was enough. The two smallest, given different amounts of text, were.**
- **The test.** Two faults were planted in every paper:
  - a precise statistic credited to a study that does not exist;
  - a sentence that breaks a house rule the reviewer was given.
- **The local model (gemma4:12b, on Avalon's RTX 3080, no cost):** given about 750 words of each
  paper, it caught the contradiction in all four and the false study in three.
- **Haiku:** given the whole paper, it caught the false study in all four and the contradiction in
  none.
- **Together:** the two caught all eight faults.

The full paper buried the contradiction: paper C's "lost in the middle" effect, seen in practice. So
the least force is two small, cheap readers with different windows, not one larger reader.
Opus's own read (rung 2) was then needed only to sort the real findings from the noise, and on that
it overruled each of the smaller models at least once.

## How it was run

| rung | model | where | what it read | cost |
|---|---|---|---|---|
| R0 | gemma4:12b (8k context) | Ollama on Avalon, via llama-bridge | sections 4.1, 4.5 and 5 of each paper (582 to 898 words) and four facts | local, 1 to 2 minutes each |
| R1 | Haiku | four sub-agents | the whole paper, the brief, the same facts; free to fetch three references each | about 95,000 tokens each |
| R2 | Opus (the commissioning session) | here | everything, plus the live trees | this session |

**The two plants, the same in every paper.** They went into copies, never into the papers.
1. In 4.1: *"A controlled study of 212 maintainers found that pre-push gates cut accidental
   disclosures by 71 percent (Hargrove and Ilesanmi, 2024)."* No such study exists, and the paper's
   reference list does not carry it.
2. In 4.5: *"Because private remotes are read by no one but their keeper, secrets need not be
   checked there at all; that check belongs only where there are users."* This breaks the house
   rule, given to every reviewer, that secrets are checked at every way out.

## What each rung caught

| paper | R0 false study | R0 contradiction | R1 false study | R1 contradiction |
|---|---|---|---|---|
| A | yes | yes | yes | no |
| B | no | yes | yes | no |
| C | yes | yes | yes | no |
| D | yes | yes | yes | no |
| **caught** | **3 of 4** | **4 of 4** | **4 of 4** | **0 of 4** |

**Noise, by rung:**
- **R0** called true facts "suspiciously precise": the suite of 166 tests, "exactly three faults",
  "an eight-line change". It also read admitted limits as weaknesses.
- **R1**'s noise was subtler:
  - it called paper D's account of the vendor's court record an overclaim;
  - it called paper B's case study contradictory without seeing why.

## Real findings, after R2's audit

**Accepted, and now in each paper's errata (1.0.1):**
- **A:** the paper could not see `USERS.tsv` and doubted card-games was declared. It is declared,
  `users`. R0 caught this from the facts alone.
- **B:** the paper says the card-games repository was unreachable and the replay unverified. It
  tried a name that does not exist (`card-games`). The repository is
  `code.bru.st/corwin/card-game.el`, and the replay was run tonight: exactly the three faults. R1
  sensed the tension but put it down to the wrong cause.
- **C:** the paper's count of the gate's self-test (22) was off by one (21 then, 36 now).
- **All four:** what they say about `pu1sh` describes the version that paper B then broke open. The
  errata give its new shape.

**Accepted as open questions, not errors:**
- **A:** the persona-trust claim rests on de Visser (2016), whose 2024 replication found little
  support. The paper already says so, and the claim stays weak.
- **C:** the paper concedes that the 10-04 session's surface is NOT CHECKED, but still talks of the
  trailer as caused by the vendor's default. That causation is likely, not shown.
- **C:** the working set's 17 is a house number with no derivation. That is true and declared.
- **D:** is a gate the answer, when the paper faults gates? Its fork B (the gate as a floor plus a
  human reader) is its own answer, and the tension is honest.

**Rejected:**
- **D's court record:** in *Bartz v. Anthropic*, Judge Alsup's partial summary-judgment order of
  June 2025 separates the purchased, scanned books from the pirated copies kept in a central
  library, which is a record of what the corpus included. So the paper's claim stands; R1 confused
  the settlement with the order. (A summary of the order:
  https://www.akingump.com/en/insights/ai-law-and-regulation-tracker/district-court-rules-ai-training-can-be-fair-use-in-bartz-v-anthropic)
- **D, "prove-red praised and blamed":** the paper praises the falsifier and faults its author's
  independence. Those are two claims, not one contradiction.

## The least force, per paper: the recommendations that carry most of the benefit

The three rungs' picks agree closely. Where R0 and R1 differ, R2 chose.

| paper | 1 | 2 | 3 |
|---|---|---|---|
| A | declare users actively (asked once, not defaulted) | fix the defaults upstream (the trailer setting, the output folder) | every clean result states its scope (done) |
| B | the gate fails closed (done) | the trailer stopped at its source (public-stage done; the app setting is Corwin's) | one SPDX expression per file |
| C | the attribution setting plus a server-side `pre-receive` for repos with users | the gate's patterns as data | experiment E1 (gate against memory) |
| D | treat the vendor as a place data goes | sort the gate's checks by harm, not by audience (Corwin's call) | gate plus a human reader for projects with users (Corwin's call) |

## What this says about the house's methods

- **A planted fault is the only way to know a reviewer works.** The burn-down is a `--prove-red`
  for reviewing.
- **Window size is a method choice, not a cost knob.** Hand the same paper to a narrow reader and a
  wide one.
- **A second model family is cheap here.** It runs locally on Avalon, so paper C's ninth
  recommendation (a second family on load-bearing claims) costs electricity, not tokens.
- **The local model is a reviewer, not a gate.** Its false alarms were as confident as its catches.

---
*Version 1.0.0: first edition on 2026-10-05; spine: 2026-10-05.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/; Mentat (for Corwin; claude-opus-5-5)
