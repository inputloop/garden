# Hand-back, lane D (turn 2): dist, dist-fam, pub and the inputloop stages

Every task is done. One thing waits on Corwin: whether the memory folder may go to Bryant. One thing
waits on the conductor: pb2br has to learn the CC-BY-SA-4.0 ID.

**The garden cut for Bryant:** `G:\dist-fam\bryant\2026-10-10-garden-535d010.zip`,
sha256 `c88249b635f2620c5ef0f5b3e88ebc14dabf55afad68e0e307f4b5b477d3f0bd`. It holds 2996 files at garden
commit 535d010, less three LOCAL holds. Its second reading came back CLEAN. Sending it is Corwin's.

## Per task

| task | state |
|---|---|
| 1. fm1ct: `--prove-red`, class check, LOCAL test, `check` by recorded holds, CC-BY-SA-4.0, garden cut | done |
| 2. Read the dist-fam parcels; cut the garden for Bryant; `fm1ct check` | done |
| 3. pb1ck: claude.ai links and embargo words | done |
| 4. G:\dist README folder list | done |
| 5. Fold in the other session's work: footers for egress and family-shelf | done (those two read green; the suite is still red for others' skills, see below) |
| 6. INPUTLOOP-STAGES.md | done; nothing pushed |

## What I saw (with the command)

**The parcels already on the shelf.** `ls dist-fam/bryant` showed the C4 cut `2026-10-10-6a1fbf2.zip`
and its KEEPER note. I ran `sh c4/bin/fm1ct check` on it, and it reported:

> holds: today's d/family/HOLDS.tsv (this zip predates HOLDS-AT-CUT.tsv)
> fm1ct check: CLEAN of held paths, his hold list, claude.ai links, embargo words, unreviewed secrets; sums verify

I left that cut alone.

**fm1ct.** I wrote the spec first: cases S12 to S17 in `c4/tests/fm1ct-spec.py`. Run against the old
tool (`python3 tests/fm1ct-spec.py`), eight cases FAILED:
- S14: the MANIFEST still gave writing the TA model's licence (the pre-v1.1 line).
- S15a, S15b: `check` read FOUND, because a hold added after the cut was applied to the old zip.
- S17: the refusal ended in "... 2".
- S12: the cut went ahead on a hold of class MAYBE.
- S16a, S16b, S16c: "unknown option: --tree".

S13 (LOCAL) passed on the old tool. That is new coverage, not a fix. Now:
- `fm1ct-spec: ALL HELD`: 27 cases ok, and all 9 mutants caught. The five new mutants each fail one
  case: class not checked; check reads the live holds; MANIFEST keeps the old licence; garden reviews
  read from C4; garden holds file ignored.
- `sh bin/fm1ct --prove-red`: "PROVE-RED OK (every planted fault caught, the real tool clean)", exit 0.

**pb1ck.** I added RED 7 and RED 8 to its own prove-red first. Run against the old tool, it showed
four RED MISS lines (the claude.ai link, its exit code, the embargo LEAK, the NOT-checked verdict) and
ended "prove-red FAILED". Now every line reads RED OK and it ends "prove-red OK".
- On `H:\pub\persona` it reports `embargo ... none` and no claude.ai link.
- Its NOT CLEAN verdict there comes from 72 leakword hits (6 words × 12). The tool as it stood before my
  edit gives the same verdict, so those hits are older than this turn and not mine to judge.

**The garden cut.** It ran in phases with `--work`, because a background run is stopped when the
call ends.
- Phase 3 stopped the first attempt on nine unreviewed secret HIGHs. I read each line with long tokens
  masked. Seven are Tavern token variable names (`secrets.token_hex(24)`, `token=self.agent_token`) or
  hand-backs that name them. Two are test fixtures (`SECRET…`, `FIXTURE…`).
- I bound all nine into the new `conventions/SECRET-REVIEWED.tsv` and taught fm1ct to read a tree's own
  file. Then the cut finished.
- My first finished zip had a READ-FIRST that pointed at the MEMORY.md it holds back. I fixed
  read_first for other trees and cut again.
- The first pair is in `G:\dist-fam\_to_delete\`, because deletes aren't allowed on that mount. Corwin
  may delete that folder.
- `G:\dist-fam\SHA256SUMS` covers the shelf without that folder; `sha256sum -c` passes.
- The zip holds committed 535d010, so it has egress 1.0.1 and no family-shelf. The other session's
  copies are still uncommitted, and committing is not mine.

**The footers.** `ft1mt mint egress family-shelf` wrote 2 files and re-dated 1. egress is 1.1.2 by the
house rule, because the footer version is the release in NEWS; the skill's own text says 1.1.0. Both
read green now. `python3 -m unittest tests.test_ft1mt`: 1 failure, depth-overlap with no row.
`ft1mt check` grew from 4 breaks (17:27) to 13 (17:47) while I worked:
- three soft skills have no rows: depth-overlap, omni-tool, frugal-offload;
- ten skills' bodies are changing under lane T's first-person pass.

`ft1mt --prove-red` and `python3 -m polygram.mcp --prove-red` both pass (run after my work only; I did
not take a baseline before, and should have).

**RECIPE.org.** It is Corwin's file, so I edited it and say so here. `lc1ck --no-book RECIPE.org` went
from 4 faults to 0. His copy from before is `H:\pub\.c4\RECIPE-2026-10-10-before-licence.org`.

**G:\dist.**
- The README's table now separates what is on disk from what is planned (`door/`, `carry/`,
  `bastion/`).
- The one `[MINE]` became a sentence.
- Its SHA256SUMS line is updated, and `sha256sum -c --quiet` passes.

## What I judge, each with what would prove me wrong

1. **The garden holds are right for now, and they may be stale.** `memory/`, `mainmem/` and
   `MEMORY.md` are held as LOCAL on Corwin's signed 07-05 grant, which says his own information goes to
   Bryant "point by point -- each detail released only on his explicit per-item approval". Commit
   260f35e ("Dee is named in our work: the non-participant reading retired") may have loosened part of
   that.
   *Falsifier:* Corwin says the 10-10 rule "as much as possible" already covers the memory folder.
2. **The two-stage plan in INPUTLOOP-STAGES.md is the smallest one that keeps held bytes out of a
   history that may later go public.**
   *Falsifier:* Corwin or Bryant wants one repository, or the garden history public.
3. **pb1ck's new LEAK kinds will be noisy at first on older H:\pub items.**
   *Falsifier:* a run over every item under H:\pub reports no claude-ai-link LEAK.

## Files changed

- **C4 tree:**
  - `bin/fm1ct`
  - `tests/fm1ct-spec.py`
  - `bin/pb1ck`
- **Garden:**
  - `conventions/FAMILY-HOLDS.tsv` (new)
  - `conventions/SECRET-REVIEWED.tsv` (new)
  - `conventions/FOOTERS.org` (the egress row)
  - `SOFT-SKILLS/egress/SKILL.md` and `SOFT-SKILLS/family-shelf/SKILL.md` (footers only)
  - this folder: INPUTLOOP-STAGES.md, CHANGELOG-D.txt, R-ROWS-D.txt (R41, R42; R43 and R44 unused),
    REQUESTS-D.txt
- **G:\dist:** README.md, SHA256SUMS
- **G:\dist-fam:** README.md, SHA256SUMS, the new zip and KEEPER note, `_to_delete/`
- **H:\pub:** RECIPE.org, plus the copy in .c4/
- **c4 runs/turn2/ANOMALIES.md:** one row

## Re-sign owed

None. Nothing I touched carried a signature.

## Requests

These are in REQUESTS-D.txt:
- lane T: the RECIPE TERMS block line, and the egress prose SPDX;
- the conductor: pb2br learning CC-BY-SA-4.0, the ft1mt rows, and the `bridget` peer row.

## Seen arriving

| time (UTC) | what changed | my reading |
|---|---|---|
| 13:49 | `SOFT-SKILLS/depth-overlap/SKILL.md` (untracked) | the other session's soft skill; lane B logged it too |
| 17:30–17:40 | omni-tool, frugal-offload, the gauntlet and parallax NOTICEs, `conventions/C4QL-TAG.md`, `c4ql-casts.tsv` | lane B's own files |
| by 17:47 | ten skills under `skills/` show `M` in git status | lane T's first-person pass |

I added one row for that last sighting to ANOMALIES.md. I edited none of these files.

## Local model

Not used.

Mentat (for Corwin; claude-opus-5-5)

---
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
