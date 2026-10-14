# reward-first

Reward-first column, mechanical-open eclipse (seed 20260906). Assumed the design wins — A2 door line +
A3 `se1sn` wrapping `ms1dg`, B2 `dc1sv --text`, B3 paper; no `@import`, no `autoMemoryDirectory` — and
hunted the reason. Every HOLDS carries a receipt; numbers are from commands run this session (sandbox,
2026-09-06T07:10Z) unless marked quoted. `se1sn` does not exist yet (`ls` → none), so K2/K4/K6 test
`ms1dg` plus the idea-3 sketch.

## grind matrix

| claim | c4 | modelthisbook | AS4CE0002 |
|---|---|---|---|
| K1 door loads, no skill/setting | **HOLDS** — `c4/CLAUDE.md` is in this session's prompt beside `AS4CE0001/CLAUDE.md` (receipt: the prompt). `CLAUDE.md.asc` exists: a new line = re-sign. | **HOLDS ~85%** — no `CLAUDE.md` (`ls`); same mechanism. Falsifier: add one, next prompt lacks it. | **HOLDS** — no `CLAUDE.md` (`ls -a`): no door, no open. The absence is the fairness rule. |
| K2 open prints seat, gauges, index head, writes one log; 0 Skill calls | **BREAKS, loudly** — no `memory/`, no `mainmem/`; `ms1dg --seat c4/memory` → exit 2, zero writes. | **UNKNOWN** — gauge half holds: exit 0, OK 9 · WARN 3 (DESIGN.md stranded, no frontmatter). Write half: no `mainmem/`. Falsifier: spec rules `mkdir mainmem` in, or NOWRITE exit 4. | **HOLDS** — exit 2 before any write path (source: only `--heal`/`--manifest`/`--out` write). |
| K3 never touches another project's memory | **HOLDS** — from `cwd c4`, `--seat memory` → exit 2; the seat's 155 notes unreached. Root from `$0`/`--seat`, never global. | **HOLDS** — report `seat:` names only `modelthisbook/memory`; G1 = 1 note. | **HOLDS** — no door, no read; README Protocol 1 honoured by absence. |
| K4 never edits another session's note | **HOLDS** — foreign files get only 0-byte appends (G4/G4b). | **HOLDS** — all mtb files OPEN; none written. | **HOLDS** — nothing written. `mainmem/` is outside the fence: `( : >> mainmem/MS1DG-2026-09-05-sandbox.md )` OPEN, a prior session's file. Falsifier: same-day append refused → NOWRITE, still not an edit. |
| K5 rack EMPTY works; skills consume as-is | **HOLDS** — `grep -c Skill bin/ms1dg` = 0; deps sh/sha256sum/awk/comm. | **HOLDS** — ran green, no skill in the loop. | **HOLDS** by absence. Consume half ~70% [MINE]: seatkeeper l.33 names "a project's `memory/`", but 0 of 58 skills mention `ms1dg`/`mainmem`. Falsifier: seatkeeper reads `OPEN-<date>.md` unprompted. |
| K6 two readers differ only G0/G4b/G8 | **HOLDS, trivially** — both exit 2. | **UNKNOWN** — host run open (CARD 7). Falsifier: host `ms1dg` on mtb, diff; only G0 may differ (G4b all-OPEN). | **HOLDS, trivially** — both exit 2. |
| K7 nothing to remember beyond the door | **HOLDS ~70%** — per session yes; install is one keeper act (re-sign, STOP-AND-TALK fork). | **UNKNOWN** — no `CLAUDE.md`; one act remains: run the template once. Falsifier: A4 emits door + script, then nothing to recall. | **HOLDS** — nothing to do here; README already says one fresh project per run. |
| K8 generalizes: fresh folder; C4 beside c4prime | **UNKNOWN** — no fight (different verbs) but nothing to open: `c4/MEMORY.md` is a 2241-line journal, same name, other concept. Falsifier: c4 gains `memory/`, `se1sn` exits 0. | **HOLDS ~80%** — `memory/` + index exist, gauge green; drop-in is two files. | **HOLDS** — generalizes by refusing to drop in; the README is its door. |

Tally: HOLDS 19 · UNKNOWN 4 · BREAKS 1 (K2/c4, loud).

## the pillar

**K3 — non-contagion by construction.** It survives all three projects, including the one where the
design must not run. The LENS's worst mark (idea-2: "C3 unknown/breaks under multi-mount") was aimed at
`@memory/MEMORY.md`, and the design dropped the import. What remains is a root-relative script and a
per-folder door — the partition equals the harness's own (`spaces/<id>/memory`, one store per project).
K1 is the foundation under it; K3 is what makes an every-session hook safe to build on.

## strongest three wins

1. **The door is already load-bearing.** Two project `CLAUDE.md` files sit in this prompt — no skill,
   no setting. K1 is the mechanism this session runs on, not a hope.
2. **Failure is a WORD and writes nothing.** Both seatless projects: exit 2, zero side effects.
   `--prove-red` green. A design that fails as "NOSEAT, stop" has a contagion risk I can state in a line.
3. **The sandbox sees A read-only now.** `/mnt/.auto-memory` is mounted (121 notes, `MEMORY.md`
   19,520 B, FENCED). `ms1dg --seat AS4CE0001/memory --auto .auto-memory` measured G8 from the sandbox:
   25 A-index lines missing from the seat index; 120 staged, TRACED 107 · ORPHAN 0 · SAME-NAME-DIFF 13.
   `se1sn` can print `auto:` instead of NOTVISIBLE; the two-reader diff shrinks toward G0 alone.
   [MINE ~60% the mount persists; falsifier: `mount | grep auto-memory` next session.]

## would not ship without

The **§6 cold-project run with its transcript grep**: a temp folder holding only `memory/` +
`CLAUDE.md` + `bin/se1sn`; `se1sn` exits 0; `grep -c '"name":"Skill"'` on that session's mounted
`.jsonl` = 0 (this session's transcript shows 6, none from `ms1dg` — not the cold test). The same run
settles the K2 hole: `mkdir mainmem` or NOWRITE. Until then K2/mtb, K7/fresh and K5's consume half are
one experiment away.

## receipts

- `mount` → 16 mounts incl. `.auto-memory`, `.claude/projects`, the three seeded projects.
- `ls -d c4/memory AS4CE0002/memory AS4CE0002/CLAUDE.md modelthisbook/CLAUDE.md` → none; `wc -l c4/MEMORY.md` 2241; mtb index 66 lines / 18110 B.
- Fence `( : >> f )`: OPEN c4/MEMORY.md, c4/CLAUDE.md, modelthisbook/memory/*, AS4CE0001/mainmem/MS1DG-2026-09-05-sandbox.md; FENCED AS4CE0001/memory/MEMORY.md, .auto-memory/MEMORY.md.
- `ms1dg --seat modelthisbook/memory` → exit 0 (OK 9 · WARN 3); `--seat c4/memory`, `--seat AS4CE0002/memory`, `cd c4 && … --seat memory` → exit 2; `--prove-red` → red as expected; `--seat AS4CE0001/memory --auto .auto-memory` → OK 4 · WARN 10 · FAULT 0 · NOTVISIBLE 0.
- `grep -c Skill bin/ms1dg` 0; `grep -rl 'ms1dg\|mainmem' .claude/skills` none of 58; `c4/CLAUDE.md.asc` 659 B; `AS4CE0001/CLAUDE.md` has no `ms1dg`/`mainmem`/`se1sn`/`@` line; `mainmem/OPEN-*` none yet.

---
*Marked (NEWS): for fiction or analysis — no ship dates or licensing or publication dates specifically defined.*
*Roll provenance: this reader was drawn by a random sample, not by the Roll-for-Bias fold; see h/LENS-2026-09-06-mechanical-open.md §drift (the corrected roll, rf1bm, overlaps this rack in 1 of 9).*
