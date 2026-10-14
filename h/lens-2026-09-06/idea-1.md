# idea-1 A1

A1: `autoMemoryDirectory` → the project's own `memory/`. 2×2 partner B1 (the Memory Door).
Reader: one of nine (`h/LENS-2026-09-06-roll.json`, seed 20260906). Two piles kept; every guess wears ~N%.

**OBSERVED (this reader, 2026-09-06):**
- `code.claude.com/docs/en/memory` (fetched today) [PLATFORM]: `autoMemoryDirectory` is read from user, project, local, policy, `--settings`; value must be absolute or `~/`; set in a project's `.claude/settings.json` it is honored "under the same workspace trust rule as hooks"; default store is per project root (outside git: the folder). Cowork honoring it: the page does not say.
- `ls -d <mount>/.claude` across the seven mounts: **none** has a `.claude/` dir; `AS4CE0001/memory` (157 entries) and `modelthisbook/memory` (2 files, own `MEMORY.md`) are the only seats; `c4` has `CLAUDE.md`, no `memory/`.
- The session-tree `settings.json` is out of my reach (Glob refused: "outside this session's connected folders") — I cannot see what he set, or where.
- `memory/memory-situation-2026-09-05.md:44–50`: Q506 RULED autoMemoryDirectory-first; his three candidate files at ~25/55/35%; **the next session is the test** (`MODEL-…-mechanical-session.md §1`).

## row 1 (enthusiast-early-adopter, tired)

One setting and the whole reseat ritual retires — that is the pitch, and tonight I want it to be true. The vendor built the knob (`autoMemoryDirectory`, five scopes); the keeper already turned it; A *becomes* the seat, `ms1dg` collapses to one reader, the fence stops mattering because there is only one store. Zero new code, zero new files, no skill in the loop (C1 holds by construction). Pair it with B1 and the door renders the *real* memory, not a copy — the nicest demo the shop has. Verdict tonight: PASS, ship it, check the path tomorrow [~60% it just works]. If it does not, nothing broke — the setting is inert. Least muss available.

## row 2 (informed of row 1)

Row 1's errors, line by line:
- *"the keeper already turned it"* → he set it in the **main desktop configuration** (§1), i.e. **user scope**: one absolute path for **every** local project. `modelthisbook/memory/MEMORY.md` exists today (ls above); a modelthisbook session would write into AS4CE0001's seat. **C3 breaks at user scope** — not a risk, a certainty if honored [~85%; falsifier: open modelthisbook, ask its memory path].
- *"per project"* is only true at **project scope** (`<project>/.claude/settings.json`), and no mount has that file (ls above). Per-project A1 means one hand-typed **absolute** path per project (`~/` cannot derive the folder) — a "path someone must recall" [C7 strain, ~70%], softened only if a template emits it (that is A4, not A1).
- *"if it does not, nothing broke"* → the silent-ignore case leaves two stores and a keeper who *believes* there is one; the half-honor case (writes move, reads do not, or per-scope drift) splits notes. Only `ms1dg` G8 catches either — so A1 **depends on the gauge** for honesty, and the gauge is a house tool, not the vendor's.
- *"C1 holds by construction"* → true, and the strongest line in the idea; keep it.
- *"ship it"* → nothing to ship; a setting cannot be tested from inside this session (memory path fixed at start, §1). The PASS was a mood.
- B1 pairing: the door is fun; A1 does not need it and it does not repair A1's contagion.

## loves

- **The keeper** (`memory-situation-2026-09-05.md:44`, Q506 "autoMemoryDirectory-first") — **firm**: he already turned the knob; shows it by asking the next session "what is your memory directory?"
- **a-person-with-one-machine / one project** — **fierce**: one dir, one truth, no ritual; shows it by never running the reseat again.
- **ceremony-hater** — **firm**: dial stays at 2, no signature, no script; shows it by deleting `seatkeeper` from the rack.
- **vendor-representative** — **mild**: "use the supported setting"; shows it by pointing at the docs page.

## despises

- **a-second-garden / any two-project keeper** — **fierce**: at user scope, project Y's notes land in X's seat (C3); shows it by finding a modelthisbook note in `AS4CE0001/memory/` and filing a bank row.
- **security-auditor** — **firm**: project-scope `.claude/settings.json` in a mounted folder rides the hooks trust rule — a folder can redirect memory writes; shows it by asking who else can write `F:\claude\c4\.claude\`.
- **a-person-who-never-reads-docs** — **firm**: silently ignored setting, no error, two stores; shows it by asking "why did last week's note vanish?"
- **qa-lead** — **mild**: unfalsifiable from inside a session; shows it by refusing a PASS without the next-session receipt.

## verdict C1–C8

C1 **holds** · C2 **unknown** (falsifier: a fresh folder with only `.claude/settings.json` — does Cowork read project scope from a mount?) · C3 **breaks** at user scope, holds only at project scope · C4 **holds** (same markdown + index) · C5 **holds** (no index edit) · C6 **holds** (dial 2) · C7 **breaks** (an absolute path per project, typed by hand) · C8 **unknown** (falsifier: does bash see the relocated A as the mount? if A = seat, yes — one reader is finally enough).

## round question

**HOLD** — the best possible plumbing if honored at project scope, but tonight it is unverified, user-scoped (contagious), and untestable from here; the next session's printed path decides, and A1 is then a **companion** to A2 (the door moves the reads; the setting moves the writes; `ms1dg` G8 proves they agree) rather than the design.

## enhance

- `ms1dg`: add a G12 **SETTING** gauge — for each `.claude/settings*.json` in scope it can see, print `autoMemoryDirectory` and the word `USER-SCOPE-CONTAGIOUS` if two mounts share it; `NOTVISIBLE` for the session tree.
- `seatkeeper`: retire step 1 (mount A) *conditionally* — first ask the session its memory path; if it equals the seat, skip to consolidate.
- `sandboxer`: fingerprint — "the setting file Cowork reads sits in a tree the file tool cannot reach; say so, card it."
- A4's template should emit `.claude/settings.json` **with the absolute path derived from the folder** — the only way A1 clears C7.
- Hand-test for him (3 steps): open project P, "print your memory directory"; open project Q, same; `ls` both seats for a stray note.

## mentat

Reorder, no new trait: **Introspection before Optimization** this season — "I cannot see the setting" is the first line of any A1 report, ahead of the pitch; a vendor knob is data until a second reader prints its effect.

---
*Marked (NEWS): for fiction or analysis — no ship dates or licensing or publication dates specifically defined.*
*Roll provenance: this reader was drawn by a random sample, not by the Roll-for-Bias fold; see h/LENS-2026-09-06-mechanical-open.md §drift (the corrected roll, rf1bm, overlaps this rack in 1 of 9).*
