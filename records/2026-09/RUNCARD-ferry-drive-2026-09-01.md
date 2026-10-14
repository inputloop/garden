# RUN-CARD — seat → Drive hash-mirror (the offsite second FS)

*Mentat (Vibrobeast) for Corwin, 2026-09-01. Minted, not vouched. Canon governs;
SAVANNAH source of truth. This card is a STOP: it wants your go before any byte
lands on your Drive.*

## Why this is a card, not a silent action
Writing to your Google Drive is a **new side-effectful action this session** and a
consent boundary (your standing rule: *stop-and-route me to a run-card for anything
wanting my key or consent*). The first Drive write was blessed once; this is a new
one. Nothing here runs until you say go.

## What it does (one sentence)
Mirror a chosen set of **seat** files to `Drive/ComputerPeople/` as **byte-identical
copies**, and **prove each landed by sha256 round-trip** (upload → download back →
re-hash → assert equal), writing receipts — the `wwtrack` via-C4 discipline, through
the Drive MCP instead of C4.

## The finding that shaped this card
The existing `ComputerPeople/making-vibrobeast-dot-md.md` (Drive id
`1rmq7gVoSrzvAgUSQ6btYZ5mA9FLCze1e`, **5608 B**) is a hand-edited *condensation*,
**not** a hash-mirror of the seat file (**11221 B**). By §4 (*a matching-hash copy
in any store is the same note*) it is a different note. Fork for you: keep it as a
human-readable *rendering* **and** add a true hash-mirror beside it, or replace it.
Default proposed: **keep the rendering, add mirrors under a `seat/` subfolder** so
the two never masquerade as each other.

## Method (chosen for byte-fidelity)
Upload with `create_file(base64Content=<raw bytes>, contentMimeType=
'application/octet-stream', disableConversionToGoogleType=true, parentId=<folder>)`.
Octet-stream = opaque blob: Drive stores the exact bytes (no Docs conversion, no
CRLF/encoding normalization). Verify with `download_file_content` (raw base64) →
sha256 → compare. If any file comes back with a different sha, that is a **real
finding** (Drive not byte-faithful for that type), reported, not hidden — the mirror
for that file is marked MISMATCH and held, never claimed landed.

## The proposed set (seat paths + current sha16 + bytes)
| # | seat path | sha256(16) | bytes |
|---|---|---|---|
| 1 | `making-vibrobeast-dot-md.md` | `b7d9acc54fb4a57f…` | 11221 |
| 2 | `models/MODEL-memory-grow.md` | `1a349d482fcf9ffa…` | 5631 |
| 3 | `MANIFEST-MEMORY.tsv` | `e4a68e61f9dda7d6…` | 5123 |
| 4 | `mainmem/lens/lens.tsv` | `7aa1103a5f80a3c0…` | 2678 |
| 5 | `mainmem/lens/subjects.tsv` | `f093434e7938b3ce…` | 247 |
| 6 | `h/ferry.py` | `f0f66f7d9303a631…` | 10295 |
| 7 | `h/lens.py` | `b58de249f764e175…` | 12916 |
| 8 | `h/ferry_core.py` | `1ddec92a702c735f…` | 4816 |

Target folder: `ComputerPeople/` = Drive id `1xXzNawbvwzO-Pd1sBvuzKP-7S7Bwfkwi`
(owner `mplscorwin@gmail.com`). Proposed to land under a new `seat/` subfolder.

## GUARDS (checked against this set)
- **Nothing third-party / family / secret / credential.** All eight are your own
  model/memory/tool files. The `copilot` rows in `lens.tsv` are a reconstructed
  reading of a public AI product, not third-party personal data. No keys, no
  passwords, no case facts.
- Seat stays canonical; Drive is a **copy, never the only copy**. If Drive is gone,
  the tool degrades to a local mirror — the store is durable in its own right.

## STEPS (what I run on your go — agent via MCP)
For each file N in the set:
1. `python3 h/ferry.py stage <seatpath> --store drive:ComputerPeople` → records
   sha + bytes in `mainmem/ferry/drive-manifest.tsv`, receipt `stage OK`.
2. MCP `create_file` into `ComputerPeople/seat/` (octet-stream, no conversion) →
   capture the returned Drive `id` as the row's `ref`.
3. MCP `download_file_content(id)` → save bytes to `mainmem/ferry/back/<id>`.
4. `python3 h/ferry.py verify <id-or-name> mainmem/ferry/back/<id> --ref <driveid>`
   → asserts downloaded sha == staged sha; receipt `verify OK` (or `FAIL`).

## CHECK (how we both know it worked)
- `python3 h/ferry.py status` shows every row `verified` with a Drive `ref`.
- `mainmem/ferry/receipts.log` has a `stage OK … staged` **and** a `verify OK …
  landed` line per file, sha printed in both.
- Any `MISMATCH` row is reported with want/got shas; that file is **not** claimed
  landed.

## GIVE-UP / STOP conditions
- A Drive write errors or is declined → stop, report which file, change nothing else.
- A file returns MISMATCH on two attempts → stop mirroring that file; report Drive
  byte-fidelity as the finding; the seat copy is untouched and remains canonical.

## TELL-ME (what I report back)
Per-file: landed+verified (sha), or MISMATCH (want/got), or errored (message). Plus
the `status` table and the receipts tail.

---
**Your go, please** — and pick scope: (A) all 8 as proposed, (B) a subset, or
(C) the operating-model trio only (#1–#3). Also: mirror under `seat/` subfolder
(default) or straight into `ComputerPeople/`?

sentinel: RUNCARD-ferry-drive-2026-09-01
