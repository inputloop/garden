# doubt-first

Reader: Fable sub-agent, 2026-09-06, assuming A2+A3 (+B3) FAILS. `se1sn` does not exist yet
(`find AS4CE0001 c4 -name 'se1sn*'` → nothing), so A3 is tested as *ms1dg wrapped, as specified*.
Numbers below are from commands run this session unless marked "quoted, not run".

## grind matrix

| claim | c4 | modelthisbook | AS4CE0002 |
|---|---|---|---|
| K1 door loads every session | HOLDS — `c4/CLAUDE.md` is in this session's prompt though c4 is not the home project | UNKNOWN — no `CLAUDE.md` exists, nothing to load; falsifier: keeper adds one, next session greps its prompt | HOLDS by absence (no `CLAUDE.md`) — but note the door cannot say "not here": it is per-mount, a session is a mount SET |
| K2 open prints seat, gauges, index head, writes `mainmem/OPEN` | BREAKS — no `memory/` (`ms1dg --seat c4/memory` → exit 2); no `mainmem/`; `c4/MEMORY.md` is 2241 lines / 203,779 B with 0 index-shaped lines | HOLDS* — `ms1dg` ran (OK 9 · WARN 3 · FAULT 0); *`mainmem/` absent, so the open must `mkdir` — a create, run-level 2 by ms1dg's own naming | BREAKS — no `memory/` (exit 2); any write is against `h/.gate` |
| K3 never touches project Y's memory | UNKNOWN — c4 has no `bin/se1sn`, only `h/ms1dg` (same sha); a door pointing at AS4CE0001's script names another mount, and the sandbox root name changes per session (3 seen); falsifier: the door line's text | HOLDS — ms1dg read only the `--seat` given | HOLDS — no glob over `/mnt/*` in ms1dg |
| K4 never edits another session's note, "fence-safe by construction" | HOLDS by discipline only — `c4/MEMORY.md` accepts a 0-byte append | BREAKS as worded — both `memory/*.md` accept the append; there is NO fence here, only the script's manners | UNKNOWN — prior-session files in `AS4CE0001/mainmem/` are OPEN, so a second same-day run appends to a log another session wrote; falsifier: two sessions, one date, diff `OPEN-<date>.md` |
| K5 rack empty works; skills consume without special-casing | BREAKS — seatkeeper reading `c4/MEMORY.md` as an index finds 0 lines; that is a special case | UNKNOWN — "grep transcript for `Skill` = 0" is contaminated: this session's `.jsonl` already holds 6 `Skill` calls; falsifier: a fresh session's transcript | UNKNOWN — same falsifier |
| K6 two readers differ only in G0/G4b/G8 | UNKNOWN — no host run exists (CARD 7 unrun); and G8 is stale TODAY: `/mnt/.auto-memory` is mounted read-only in bash (121 files, `MEMORY.md` 152 lines / 19,520 B) — "the shell cannot see A" is false this session | UNKNOWN — same | UNKNOWN — no seat to run |
| K7 nothing to remember beyond the door | BREAKS — two first moves (`c4prime.h`, `se1sn`); `CLAUDE.md` is signed, the line costs a re-sign | BREAKS — someone must remember to create `CLAUDE.md` + `mainmem/` and to `cd mnt/<folder>` (bash cwd resets) | HOLDS — nothing runs; what must be remembered is *don't* add the door, and no script checks that |
| K8 drops beside `c4prime` without fighting; into a fresh folder | BREAKS — signed door, no `memory/`, non-index journal, ms1dg homed in `h/` not `bin/` | UNKNOWN — index uses `:dim1:` labels, 7 dangling wikilinks, `DESIGN.md` forbids foreclosing the representation; falsifier: run se1sn there and count WARNs the keeper will accept | BREAKS — a candidate project with only this folder mounted plus A4's template writes `mainmem/OPEN` into the seat's tree; se1sn reads no `.gate` (ms1dg reads one only at dial 17, as a vouch map) |

Tally: HOLDS 7 · BREAKS 8 · UNKNOWN 9.

## strongest three failures

1. **The open prints the wrong memory.** The index the harness loads is store A (`/mnt/.auto-memory/MEMORY.md`, 152 lines, 118 index lines), shared by every project in this Cowork space. The seat index has 93 lines. `se1sn` prints the seat and calls it "where memory is"; A — the actually contagious store — is neither printed nor diffed, though bash can now read it. C3 is claimed for the store the harness does not load [MINE ~80%; falsifier: a session whose auto-memory path is the seat].
2. **c4, the named target, fails 5 of 8.** Signed `CLAUDE.md`, no `memory/`, a 203 KB journal where an index should be, and an existing first move. "Beside c4prime" is a second door on a door that is already sealed.
3. **No "not here."** The door is per-mount; the session is a set of mounts; `.gate` says silence ≠ consent and the script never reads it. AS4CE0002's fairness rests on the keeper remembering — exactly what C7 forbids.

## what would save it

- **Print both, name the seam.** `se1sn` passes `--auto /sessions/*/mnt/.auto-memory` when the mount exists and prints two heads: *loaded* (A) and *seat*; the diff of the two index-line sets is the first line of `OPEN-<date>.md`. Drop the stale G8 wording.
- **Seat by marker, never by default.** Run only where `memory/` exists AND no nearer `.gate` withholds it; otherwise print `NOSEAT`/`GATED`, write nothing, exit 0 with a card. No `mkdir`.
- **c4: one door.** Don't edit the signed `CLAUDE.md`; let `h/c4prime.h` call `[ -x bin/se1sn ] && sh bin/se1sn` — additively, as it already appends SK0L.
- **`OPEN-<date>-<sessionid>.md`**, so no run ever appends to another session's log.
- B3 ships only after the cold-project test runs in a *fresh* session (transcript `Skill` = 0 there, not here).

## receipts

`wc -lc` on the four `MEMORY.md`s · `mount | grep /mnt/` (17) · `( : >> f )` on 6 files, all 156 seat notes (98 fenced / 58 open), 2 `mainmem/` files (open), A (`Read-only file system`) · `sh bin/ms1dg --seat` ×3 (rc 0/2/2) · `grep -c '^- \['` both indexes (118/93) · `sha256sum` both ms1dg (equal) · `grep -rhoE '/sessions/[a-z-]+'` (3 names) · `grep -c '"name":"Skill"'` on the mounted transcript (6) · `cat` of AS4CE0002 README + both `.gate`.

---
*Marked (NEWS): for fiction or analysis — no ship dates or licensing or publication dates specifically defined.*
*Roll provenance: this reader was drawn by a random sample, not by the Roll-for-Bias fold; see h/LENS-2026-09-06-mechanical-open.md §drift (the corrected roll, rf1bm, overlaps this rack in 1 of 9).*
