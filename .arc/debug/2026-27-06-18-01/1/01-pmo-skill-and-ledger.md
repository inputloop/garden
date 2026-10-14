# 1/01 — pmo skill + ledger mechanics (Task 1)

**Faculty:** Skill tool (`pmo`) → local POSIX tooling on a mounted folder.

## Flow observed
1. `Skill: pmo` expands the SKILL.md *as guidance into context* (it does not
   "run" anything) — it told me the interface so I didn't guess it.
2. The tool itself is `bin/*.sh` POSIX scripts over two TSV ledgers
   (`projects.tsv`, `todos.tsv`). I drove them from **bash**, not the Skill —
   the Skill is the map, bash is the territory.
3. Robust invocation: `export PMO_DIR=<bash-mount-path>` then call scripts by
   full path. The mount path (`/sessions/.../mnt/pmo`) ≠ the host path
   (`F:\claude\projects\pmo`); only bash uses the former.

## Interface nuances worth keeping
- **TSV = source of truth; `README.md`/`index.html` are generated.** Never
  hand-edit the generated views — `pmo-report` overwrites them.
- `pmo-done ID [STATE]` is misnamed — it sets *any* state (TODO/DOING/DONE).
- `pmo-add` *warns but still adds* on an unknown project key → a typo silently
  spawns a phantom project. I verified keys first.
- Core loop that prevents drift: **read → mutate (one script call) → `pmo-report`
  → verify the write via bash re-read → present.**

## Contrast
This is Corwin's *own* tracker — not Jira/Asana. The skill exists specifically
to stop Claude from building a parallel tracker. Reusable principle:
**when a bespoke local tool exists, operate it faithfully; don't reinvent.**
