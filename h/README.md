# h/ — Avalon tool home (this session's fallback for c4/h)

Tools home in **C4 (`c4/h`)** when it's mounted; C4 was **not reachable this
session**, so they were built here on Avalon (the §4 fallback: *land toward C4, or
Avalon, explaining when C4 isn't the fit*). Data masters live in the seat under
`../mainmem/`. To promote to C4 later: copy by sha256 identity, keeper lift+sign.

stdlib only. `python3 -m unittest test_ferry_core test_ferry test_lens` → 22 green.

## The one spine
- `ferry_core.py` — sha256 identity, receipts (wordwise format), hash-keyed TSV.
  Shared by both tools: *move a copy across a boundary, prove it landed by hash.*

## ferry.py — Task B, the offsite second FS
Backend-agnostic copier that proves the seat→store round-trip by hash.
```
python3 ferry.py roundtrip local:/tmp/mirror ../MEMORY.md   # full local proof
python3 ferry.py stage <seatfile>                           # record identity
python3 ferry.py verify <id> <fetched-back-file> --ref <r>  # assert by hash
python3 ferry.py status                                     # the manifest
```
The Drive leg is carried by the agent via the Drive MCP under
`../RUNCARD-ferry-drive-2026-09-01.md` (a sandbox can't reach Drive; pushing to the
keeper's cloud is a consent boundary). `DriveBackend` refuses to self-drive by
design. Degrades to a local mirror if Drive is gone.
- masters: `../mainmem/ferry/drive-manifest.tsv`, `../mainmem/ferry/receipts.log`

## lens.py — Task A, the cross-model LENS
Structures a LENS reading (six views) and measures cross-model (dis)agreement.
Subject material is pinned by sha256, so every model provably read identical bytes.
```
python3 lens.py views                                       # the six views
python3 lens.py pin <material> --title T --id S             # fix identity
python3 lens.py add --subject S --model M --view V --stance ST --claim C
python3 lens.py import-json <copilot.json> --subject S      # import a model
python3 lens.py converge --subject S                        # the measurement
```
Convergence = exact `stance`-token match across models; a difflib claim-similarity
rides along as a **hint only**, never the verdict. `--no-notes` on pin drops notes
(*detailed notes unless the writing itself is the danger*).
- masters: `../mainmem/lens/{subjects,lens}.tsv`, `../mainmem/lens/receipts.log`

Losers kept: `../.eclipse-increments/20260901-ferry-lens/contrast.md`.
