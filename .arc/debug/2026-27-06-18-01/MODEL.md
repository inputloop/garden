# MODEL.md — introspection harvest, 2026-06-27 18:xx (run 01)

Pattern-harvest of a two-task request, captured per the (maybe-reusable)
Introspection Procedure. Folder name = `YYYY-DD-MM-HH-NN`. This file is the
token-aware summary; the detail lives in the numbered subfolders.

## Why this exists
We are **pattern-harvesting**: reaping notes from the working conversation to
feed two farming programs — **sandbox enhancements** and **skills**. Harvest is
the gather step that feeds the farm (distinct from *skill-shaping* = "is this a
skill?" and *skill-farming* = grow candidate → skill). Naming candidate for a
future "magic word."

## Map
- `1/` — Task 1: refactor + ship the PMO TODO list.
  - `01` pmo skill + ledger mechanics (operate the bespoke tool, don't reinvent).
  - `02` ★ the mount atomic-write gotcha (cross-device `mv` + delete-permission).
  - `03` slotting reasoning (terse-todo → projects/prio/tags; calls flagged).
- `2/` — Task 2: create `screenshot.md` modeling this conversation.
  - `01` session-history faculty (read my own past transcripts as data).
  - `02` ★ sub-agent fan-out + the QC AND-gate (map/reduce; cold-start economics).
  - `03` banter model + a session-id/title data-quality catch.
- `faculties-and-features.md` — cross-cutting cheat-sheet of harness faculties
  and how they chain (tools/skills/memory/mount) + what we have but didn't use.

## Top harvested enhancements (the reap)
1. **Atomic mount write** (★, 1/02): stage temp *in-dir* → `mv` is an atomic
   rename, no delete permission needed; always verify via bash re-read. ENHANCE
   for **sandboxer** (cross-device-mv + unlink-permission interaction).
2. **terse-todo refactor** (1/03): a repeatable recipe for turning shorthand
   into shippable PMO items — possible small skill once it recurs.
3. **pattern-harvesting** (2/02): the harvest step itself, with the strict-TSV
   sub-agent contract — candidate skill feeding polygram's farm.
4. **composite-key cross-check** (2/03): verify child-returned id↔title against
   an authoritative list before trusting either — a cheap verification gate.

## Reusable-process notes
- The **Introspection Procedure** and this whole "potentially reusable" framing
  are themselves harvestable into Magic Words (pattern-harvesting, skill-shaping,
  skill-farming). The `debug/<stamp>/{1,2}/` + `MODEL.md` layout is a clean,
  re-runnable harvest container.
- Optimize all our model files alike: lead with the map + the reap; push detail
  down; keep it legible to any audience and cheap to re-read.

`feeds →` polygram candidate pipeline (magic beans, #76), sandboxer ENHANCE,
and `skzb/pm/screenshot.md` (the screenshot-resume guide).
