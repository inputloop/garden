# idea-3 A3

OBSERVED (sandbox bash, 2026-09-06T07:01Z):
- `ls c4/bin | grep '^[a-z][a-z0-9][0-9][a-z][a-z]$'` → 10 five-character names. `ep1nt` header:
  run-level 1 = "asks what is, writes one derived file."
- `c4/bin/c4prime` exists ("what C4 tells iT at the start of a turn"); `c4/CLAUDE.md` points at it.
  **A mechanical open already lives in C4**; A3 is its memory-facing sibling.
- `grep -n 'ms1dg\|mainmem' AS4CE0001/CLAUDE.md` → 0 hits: **the seat's door points at no gauge today.**
- `ms1dg`: exit 0/1/2, WORD states, `--prove-red`, `CARD` lines; 32/32 quoted, not run. `mainmem/`
  is outside the fence (§1b, quoted).

## row 1 (a-poet, tired)

Late, and the idea is lovely because it is small. One word said at the door and the session is home:
here is your memory, the gauge's word, the cards, the note you leave. Name: **`se1sn` — SEAT ENTER 1
SESSION NOTE** (S seat · E enter · 1 asks-what-is, writes one file · S session · N note). Run-level 1
fits: reads, writes `mainmem/OPEN-<date>.md`. B3 is the second stanza: the paper says "any folder of
notes, two readers, a gauge, a dial," and the script is what a reader runs without believing a word.
c4prime proves the shape here. I would ship it on the name alone. [MINE ~60% the pair is the
strongest 2×2 — the others need a renderer, a setting, or a wire.]

## row 2 (informed of row 1)

Row 1 valued the name over the running. Corrections, each with a falsifier:
1. **"The memory path" is two paths.** bash prints the seat; it cannot see A (§1, `ls /mnt/.claude` →
   `projects skills`). Print `seat:` and `auto: NOTVISIBLE from this reader` — never one line called
   "memory". Falsifier: an A path printed from the sandbox was invented.
2. **C7 was skipped.** A script nobody runs is prose. The only skill-free every-session hook is the
   project `CLAUDE.md` (§1) — A3 *is not a design without A2's line*; today's door has none.
   Falsifier next session: grep the mounted transcript for `se1sn` in the first five tool calls.
3. **Exit codes and failure words unspecified.** Sketched below; every non-zero exit ends in a WORD.
4. **One file per run fills `mainmem/`** (~250/year [MINE ~80%]). Append to `OPEN-<date>.md` under a
   `## <HH:MMZ> reader:` header.
5. **C2 half-held.** The script must already be in the project; A4's template puts it there.
6. Keep `se1sn`; stop polishing it.

## interface sketch

`sh bin/se1sn [--root DIR] [--ceremony N] [--auto DIR] [--no-write] [--tsv]` · `sh bin/se1sn --prove-red`
- ROOT = `$(dirname "$0")/..` (landcheck's idiom); seat = `$ROOT/memory`; never `mkdir`.
- Prints, in order: `seat: <path>` · `auto: <path|NOTVISIBLE from sandbox>` · `reader: sandbox|host` ·
  `index: <lines>/<bytes> of 200/25KB` · tail of the latest `OPEN-*.md` (resume warm) · the `ms1dg`
  summary line · every `CARD` line · `open: mainmem/OPEN-<date>.md`.
- `--ceremony`/`--auto` pass through to `ms1dg` untouched; default dial 2.
- Exit: **0 OPENED** · **1 OPENED-WITH-FAULT** (ms1dg exit 1; note still written) · **2 USAGE** ·
  **3 NOSEAT** (no `memory/`; prints the card to create it) · **4 NOWRITE** (OPEN append refused;
  prints the host line). Last line always `se1sn: <WORD>`.
- `--prove-red`: temp root with a dangling index line → must exit 1, OPENED-WITH-FAULT.
- Needs sh, sha256sum, awk, comm (ms1dg's). No skill, key, or network.

## loves

- **The cold session** — fierce: lands with a path, a number, yesterday's tail; guesses nothing
  about memory in its first turn.
- **Corwin** — firm ([HIS] "nothing I have to remember"): runs it, grumbles at the name. ~75%.
- **A stranger reading B3** — mild: a receipt they can run on their own notes folder.
- **seatkeeper / Mentat** — mild: `OPEN-<date>.md` is a hand-off note in a format they already read (C4).

## despises

- **The skills author** — firm: "seatkeeper move 1 does this"; shows it as an ENHANCE line. Answer:
  move 1 needs the rack; C1 says the rack may be empty.
- **Whoever runs `ls mainmem` in March** — firm if row 1's file-per-run ships; dissolved by fix 4.
- **Row 1's poet** — mild: the fixes make it a tool, not a couplet.

## verdict C1–C8

C1 holds (sh only; falsifier: a `Skill` call in the cold-project transcript). C2 half-holds (needs A4
in a fresh folder; falsifier: §6 cold-project test). C3 holds (root-relative). C4 holds (markdown +
ms1dg words). C5 holds (writes only `mainmem/`; falsifier: append refused → NOWRITE). C6 holds (dial 2
default). **C7 holds only with A2's line** — unknown until the next session's transcript. C8 holds
(reader stamped; OPEN file on the mount for the host).

## round question

**PASS, as A2's hand** — most users (anyone with sh), most flexibility (flags pass through), no-muss
(one door line), and the one risk I can explain: it prints the seat, not A, and says so. Standing
alone without the door line: HOLD.

## enhance

- ms1dg G12: WARN when today's `OPEN-<date>.md` is absent — the gauge reminds the open (C7 redundancy).
- The OPEN header carries the ms1dg summary, so a diff of two OPENs is the seam.
- A4 emits `bin/se1sn` + the door line in one template; B3 cites `se1sn --prove-red` as its runnable claim.

## mentat

Refine **Memory** ("I remember by your files") to "…and the open is a command I run, not a thing I
recall"; reorder **Diligence** so *open before working* precedes *finish before forking*.

---
*Marked (NEWS): for fiction or analysis — no ship dates or licensing or publication dates specifically defined.*
*Roll provenance: this reader was drawn by a random sample, not by the Roll-for-Bias fold; see h/LENS-2026-09-06-mechanical-open.md §drift (the corrected roll, rf1bm, overlaps this rack in 1 of 9).*
