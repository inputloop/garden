# records/ — dated working records, lifted off the root on 2026-10-04

These files sat at the top of the project, one per working day that wrote them. They are kept
byte-for-byte (moved with `git mv`, so `git log --follow FILE` still shows each one's history) and
grouped by the month they were written. Nothing here is live: no tool reads these paths. Skills that
cite one of them do so by file name, as a receipt, and the name still finds it:

    ls records/*/SEATDIFF-2026-09-04b.md

| month | what is here |
|-------|--------------|
| `2026-07/` | `PLOT.md`, `PLOT-UTIL.md` — the plot shelf adopted 2026-07-08 |
| `2026-08/` | the 08-17 own-canon refactor and its signed consent (`OWN-CANON-CONSENT-*`, with `.asc`), the removal pass, the git-transport growth area, alto's regrow, a retire-stubs run card, `NET-NOTES.tsv`; and `INDEX-2026-08-17.md.asc`, the signature the root `INDEX.md` carried until today. It signed the map as it stood on 2026-08-17, which was never committed (the nearest commit is `26dfae3`), so it verifies nothing in this tree any more and is kept as a record |
| `2026-09/` | the memory-seat month: seat diffs, the memory snapshots (`*.tgz` with `.asc` and `.sha256`), the mind model, value-of-time, the whiteboard, the persona-drive grant (signed in place; still standing), run cards, `C4-SPOILERS.md`, and two nongnu-steward eval pages that sat in `outputs/` |

Signed files moved with their signatures beside them. A detached signature covers bytes, not a
path, so each pair verifies where it now stands: `gpg --verify FILE.asc FILE`.

`C4-SPOILERS.md` says of itself "kept LOCAL ... not pushed to cloud/Drive without Corwin's word".
It has been in this repository since commit `ff7b4bc` and is on the keeper-only remote. It has never
shipped: none of the 29 curation archives in `dist/` (0.5.4 through 0.8.91) contains it (checked
2026-10-04 with `tar tzf`), and the plugin is minted from `skills/` and `polygram/`.

Copyright (C) 2026 Corwin Brust <corwin@bru.st>.  Authored by Mentat (for Corwin).  CC BY 4.0.
