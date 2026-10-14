# idea-6 B2

B2: `dc1sv` renders the seat's state as a canonical diagram document each open; `--text` and the
SVG land in `mainmem/`; pair A2 (the door shows the picture). Roll: a-compliance-officer, tired.

OBSERVED (sandbox, this session): `sh tests/dc1sv-tests.sh` → `TOTAL pass=23 fail=0`; `--tally` on
the intersections doc → `shapes 28 edges 26 groups 5`; `--lint` → `lint faults 0`; `--text` diffs
clean against the shipped `.txt`; sizes json 11395 / svg 15000 / txt 4447 bytes (`wc -c`). Test line
65 already pins *regenerated SVG == shipped SVG* by sha. `dc1sv` is python3, in `h/` not `bin/`.
`mainmem/MS1DG-2026-09-05-sandbox.md` (quoted, not re-run): G1 155, G3 62 stranded, and the
stranded list names `corwin-family-dee.md`.

## row 1 (a-compliance-officer, tired)

A picture per session is a record I can file. I want it dated, hashed, immutable; the SVG should
*be* the evidence — if the seat later disagrees, the picture wins. Concerns: (1) python3 is a
dependency the shop's law (stdlib/POSIX) frowns on [DOMAIN, PLOT-UTIL]; (2) `mainmem/` gains
~30 KB a session, uncapped; (3) "can travel" — a rendering listing note filenames carries
`corwin-family-dee` outward; guard 2, family off-limits, is [HIS] and blocks; (4) never
hand-edited means signed at dial 9. Verdict: HOLD until signed.

## row 2 (informed of row 1)

Row 1's errors, named. **The picture is a rendering, not an audit record**: the record is the ms1dg
report with its receipts; if they disagree the *report* wins and the gap is an emitter bug, not a
seat finding. **Signing it is dial 9 — C6 forbids it**; the honest guard is
regeneration-equals-shipped (the test exists) plus a source hash in `_provenance`.
**Accessibility inverted**: the `--text` reading is the primary artefact — grep-able, diffable,
loadable as context; the SVG is the courtesy for eyes. **Sameness of form** is not the value; a
cold session reading one page and knowing its memory's place and state is. Concern (3) survives,
corrected: a picture generated from the seat never travels; one from a redacted source may.
Concern (1) is [MINE ~60%]: an awk emitter for the JSON is trivial; the renderer stays python3
until ported; C1 (no *skill*) is untouched either way.

## data source and proof

Generate FROM the ms1dg report (`[ WORD ] Gn … -- receipt: cmd` lines), never from the seat
directly: one awk pass → `DIAGRAM-<date>-memory.json` (shapes = stores A/B, index, mainmem,
manifest; groups = readers sandbox/host/keeper; edge labels = `G3: 62 STRANDED`). At dial 4 add
the manifest TSV's line count and sha as a note shape. `_provenance` carries the report's path and
sha256, `generated_by: dc1sv <sha>`, `reader:` (G0).
Stranger's check (prove-a-promise, universal × provenance): (1) round-trip — `dc1sv DOC.json |
sha256sum` equals the shipped SVG and `--text` equals the shipped `.txt`; (2) provenance — every
number in the `.txt` greps out of the report `_provenance` names, whose sha matches; (3) two
readers — host and sandbox `.txt` differ only on G0/G4b/G8. No eyes needed; `svg-a11y-test.sh`
7/7 is the picture's floor. Falsifier: an emitter drawing an edge the report has no line for.

## loves

- **Corwin** (fierce, ~80%): drawing-as-canonical-doc is his line; shown by opening
  `mainmem/PICTURE.txt` first each session.
- **A cold session / a stranger with a terminal** (firm): one page instead of a 60-line report.
- **Bryant / the other garden** (mild): the *pattern* picture (stores, fence, dial) travels; the
  case picture does not.

## despises

- **The compliance officer** (row 1, firm): wants evidence; it isn't; shown by demanding a `.asc`
  beside every SVG.
- **The minimalist on the bench** (firm): "the report already says it" — a second artefact per
  open is a second thing to drift. His check: `.txt` numbers vs report; any difference proves him.
- **ethicsminions** (fierce, if travel defaults on): note names in a picture bound for pub/.

## verdict C1–C8

C1 holds (no Skill call; python3 + sh). C2 holds if paths derive from the door (`./memory/`,
`./mainmem/`). C3 holds — per-project by construction. C4 holds (json/txt/svg; skills read text).
C5 holds — `mainmem/` is outside the fence [OBSERVED §1b: files outside `memory/` append open].
C6 holds only if no one signs it (row 1's instinct is the breach). C7 holds with A2: the door names
the file. C8 holds via the two-reader `.txt` diff; **unknown** whether `@mainmem/PICTURE.txt`
imports into a Cowork session — falsifier: the next session's prompt shows it or not.

## round question

**PASS (as A2×B2, travel OFF by default)** — most users get one readable page each open; most
flexibility because text/svg/json are three doors to one document; no-muss because it is
regenerated, never edited; the one risk I can explain is outward travel of note names, gated by
guard 2 and a redaction step.

## enhance

- `ms1dg --diagram` (or a 40-line awk): emit the JSON from the report; test: every edge label
  greps from the report.
- Stable names `mainmem/PICTURE.txt` + `.svg`; a dated copy only with `--keep`.
- `_provenance.travel: local` by default; `pub` needs a redacted source and the minions' concur.
- Port `--text` to awk so the text reading is POSIX where the SVG isn't.
- `dc1sv` from `h/` to `bin/` at the ship boundary (tool-lifecycle: Layer 0 first).

## mentat

Reorder: put "a rendering is not a record — the receipt is" ahead of "cite inline"; it refines
"shown = a receipt" by naming what is *not* one.

---
*Marked (NEWS): for fiction or analysis — no ship dates or licensing or publication dates specifically defined.*
*Roll provenance: this reader was drawn by a random sample, not by the Roll-for-Bias fold; see h/LENS-2026-09-06-mechanical-open.md §drift (the corrected roll, rf1bm, overlaps this rack in 1 of 9).*
