---
# MEMORY SITUATION — the model, the gauge, the pattern, the cards (2026-09-05, late evening)
Author: Fable (Mentat/Vibrobeast). Tool: `/f/claude/AS4CE/AS4CE0001/bin/ms1dg` (+ `tests/ms1dg-tests.sh`,
32/32, `--prove-red` PASS; `--ceremony 1|2|4|9|17`). Report of the first live run: `mainmem/MS1DG-2026-09-05-sandbox.md`.
Two piles throughout: OBSERVED carries its command; JUDGED wears a tag.
---

## 1 · The stores, as they can be proven from inside (OBSERVED)

| store | what it is | sandbox `bash` sees | file tool sees | write | delete | receipt |
|---|---|---|---|---|---|---|
| **A** auto-memory | `…/spaces/<space>/memory/` under Claude's app data; harness-owned; index loaded ≤200 lines/25KB [PLATFORM] | **nothing** (`ls /mnt/.claude` → `projects skills`) | read + write | yes (Write/Edit) | untested | `request_cowork_directory` refuses the path ("inside Claude's own application data") |
| **B** the seat | `F:\claude\AS4CE\AS4CE0001\memory\` (153 files) | rw FUSE mount | read + write | new files yes; **`MEMORY.md` append denied** | **`rm` refused** | `mount`; `: >> MEMORY.md` → Permission denied; `rm .probe-2` → Operation not permitted |
| transcript | this session's `.jsonl` (12 MB) | `/mnt/.claude/projects/<mangled outputs path>/<session>.jsonl` | — | — | — | `find .claude/projects -maxdepth 3` |
| **D** account memory | Settings → Memory (chat) | no | no | — | — | vendor article says local Cowork "doesn't use memory" — it means D, not A [MINE ~85%; falsifier: A stops persisting] |

**The seam, in one line:** A and B are one *idea* held by two readers that cannot both see both stores.
The shell sees B; the file tool sees A and B; the keeper on the host sees everything. So every claim
about "the memory" is a claim from one reader until a second reader agrees — `seams` doctrine.

**Measured tonight (sandbox reader, `bin/ms1dg`):** seat notes 152 · index 13,135 B / 126 lines (limit
200/25KB) · **59 notes on disk with no index line** · index not append-writable from the sandbox ·
strays `.probe-2` (mine, tonight) `.probe-renamed` · 1 divergence pair (`persona-doorway`) · 11 notes
without frontmatter · 15 dangling `[[wikilinks]]` · with A's index staged: **24 A-index lines the seat
index lacks**, **2 A notes with no seat file** (now seated via the file tool: `journal-2026-09-05-interim`,
`desktop-commander-path-grant`).

### 1b · The lock was never on the index — it is a per-file fence on `memory/` (found after §1 was written)

OBSERVED (0-byte appends, `( : >> f )`, nothing changed): **98 of 156** seat notes refuse the append from
the sandbox; the split is exact — every note dated 09-01 12:26 / 09-04 06:07 (other sessions) is denied,
every note this session wrote is open. The same probe on pre-existing files *outside* `memory/` —
`AS4CE0001/CLAUDE.md` (07-08), `MANIFEST-MEMORY.tsv` (09-01, beside the memory dir), `c4/h/c4prime.h`
(08-08), `pub/README.md` (07-12), `ta/MEMORY.md` (08-28) — **all open**. Only `AS4CE0001/memory/` is
fenced, and only for notes this session did not create.

JUDGED [MINE ~65%]: the harness guards a mounted project's directory named `memory/` the way it guards
its own auto-memory — a later session may add notes but may not alter another session's. Falsifiers:
(1) CARD 7's host run — if G4b reads 0 fenced on the host, the fence is the sandbox's; (2) a seat dir
under another name would not be fenced (not tested — a directory probe is a stray I can't remove).

CONSEQUENCE for the seat's design (the thing to consider before the next skill-garden move): the seat
index `MEMORY.md` can never be *edited* by a later session from inside; it can be appended by the host
(CARD 1) or **regenerated** — and regeneration needs a name the fence doesn't hold, i.e. a fresh file
per session (`MEMORY-<date>.md`) that the host folds, or the index moves out of `memory/` (to
`mainmem/INDEX.md`, say) where every session can write it. Both are forks for the keeper; neither is
done. `ms1dg` now measures this as **G4b** on every run.

## 2 · What is sourcable from the web (tagged [PLATFORM], read 2026-09-05)

`https://code.claude.com/docs/en/memory` — auto memory lives in `<config>/projects/<project>/memory/`;
`MEMORY.md` is loaded to **200 lines or 25 KB, whichever first**; an over-limit write *succeeds* and the
remainder is dropped on the next load (a silent seam — G2 guards it); the harness stamps `modified:`
into frontmatter on write (why A and seat copies never byte-match after a Write — expected, not
drift); **`autoMemoryDirectory`** in `settings.json` relocates the store (Claude Code; Cowork honoring
it is unverified); `/memory` opens the auto-memory folder; subagents don't load the main memory.
`https://support.claude.com/en/articles/14116274-organize-your-tasks-with-projects-in-claude-cowork`
— memory is scoped per project; "local Cowork sessions don't use memory" (read as store D, above).

## 3 · The troubleshooting pattern (the CALLED SHOT applied to a memory fault)

1. **GUESS** — write the shot first: which store, which reader, what number you expect.
2. **TRY** — run `ms1dg` from the reader you have. It prints a WORD per gauge and the command.
3. **TEST** — run it again from the *other* reader (the keeper, on the host). Lay the two reports side
   by side. **Agreement is evidence; disagreement is the seam**, and the seam is the finding.
4. **WRITE** — the drift between the shot and the two measurements goes in the journal; the heals go
   on cards (index lines, strays, pairs) or through `--heal` (new files only, hash-verified).

What the pattern refuses: repairing from one reader ("BAD" from bash on a mount is usually a stale
read — `sandboxer`); editing the index from the sandbox in a retry loop (it is locked, say so);
deleting anything (`rm` is refused; and a continuity tool must never drop a divergent copy).

**Accessible to people:** every gauge is a sentence with a word state; every card is a paste-ready
line for a human hand; no color; no dependency beyond `sh`, `sha256sum`, `awk`, `comm`. A stranger
with a terminal can run it against any folder of markdown notes with an index — the pattern is not
Claude-specific; only the *paths* are.

## 4 · Try it (hand-test, 3 steps, ~2 minutes)

- [ ] **DO** (host, MSYS2): `cd /f/claude/AS4CE/AS4CE0001 && sh tests/ms1dg-tests.sh && sh tests/ms1dg-tests.sh --prove-red`
      **SEE**: `TOTAL pass=32 fail=0` then `PASS: harness correctly went red`.
- [ ] **DO**: `sh bin/ms1dg --seat /f/claude/AS4CE/AS4CE0001/memory --auto "/c/Users/corwi/AppData/Roaming/Claude/local-agent-mode-sessions/948346fb-5634-4a0d-bbc2-9a649c945411/8460b5c5-7709-448e-a1b9-45577b5e1670/spaces/c7c21b10-7abd-420b-91d9-e2037f3027bf/memory" --out mainmem/MS1DG-2026-09-05-host.md`
      **SEE**: `reader: host`; G4/G4b — how many notes append from the host? (**0 fenced on the host = the fence is the sandbox harness's; >0 = something on the host holds them**); G8 — ORPHAN/SAME-NAME-DIFF counts for the real A.
- [ ] **DO**: `diff mainmem/MS1DG-2026-09-05-sandbox.md mainmem/MS1DG-2026-09-05-host.md | grep '^[<>] \['`
      **SEE**: only G0 and G4/G8 lines differ. Anything else that differs is a seam worth a bank row.
- [ ] *(optional)* **DO**: `sh bin/ms1dg --seat … --auto … --heal --dry` then without `--dry`.
      **SEE**: `copied, verified` per orphan; `<stem>.auto-<sha8>.md` beside each divergent pair; the index untouched.

## 5 · The bridge question (MCP), answered honestly

Desktop Commander is uninstalled (his word, tonight) — it drops out. Remaining bridges, cheapest first:

1. **`autoMemoryDirectory` → the seat** [PLATFORM setting; Cowork support **unverified**, ~40%]. One
   session's test: set it in the session's user settings, start a session, read the memory path in
   the system prompt. If it holds, A *is* B, the reseat ritual retires, and `ms1dg` becomes a
   single-reader gauge. Risk: if Cowork ignores it, nothing changes; if it half-honors it, notes
   split — `ms1dg` G8 catches that. **CARD 6.**
2. **The host run** (§4) — a human hand, two minutes, zero new reach. The default until 1 is answered.
3. A purpose-built stdio MCP with two read-only tools (`memory_gauge` → runs `ms1dg`; `memory_stat`)
   — host shell reach from inside a session, so `containment-during-exec` applies: capability-scoped,
   read-only, its own consent tumbler. Not built; not proposed until 1 is answered. [MINE]

## 6 · ENHANCE `sandboxer` — a memory-stores section (reauthor through the forge; Q14 in the tree)

Fingerprints to add, each a sentence, each receipted tonight:
- A is **not a mount**: bash sees nothing of it; the file tool does; `request_cowork_directory` refuses
  it by policy — never `ls` for it, never say it's absent.
- Seat `MEMORY.md` **append denied while mode reads rwx** → say "locked from this reader", card the host
  line, never retry. The lock's owner is unknown until the host run (G4) says.
- `rm` refused → **never create a probe** (I did tonight: `.probe-2` is on the card). Detect strays you
  find; don't make them to test.
- `mv` onto an existing file fails ("unable to remove target") — `cp` overwrites in place.
- A note written by the file tool comes back with a harness `modified:` stamp — **A and seat copies
  never byte-match after a Write**; compare bodies, or record "copied, re-written".
- The session transcript is at `/mnt/.claude/projects/<…>/<session>.jsonl` — the reader for
  out-of-bounds audits (Q7).
- Canary for all of the above: `bin/ms1dg --seat <seat>` — run it before claiming anything about memory.

## 7 · Enhance suggestions for the gauge itself (honest gaps)

- G8 stages only what the file tool copies; a full A manifest from inside costs one Write per note.
  Cheaper: stage A's `MEMORY.md` alone (done) — index-diff is the 80% signal.
- No `--tsv` line for `rolls`/dashboard ingestion yet; the summary line is grep-able as is.
- Body-hash (frontmatter stripped) would let A/seat pairs match despite the harness stamp — G8 would
  then report TRACED-BY-BODY. One awk. Next version.
- The 59 unindexed notes: `--index-lines` could *print* candidate lines from each note's frontmatter
  `name`/`description` for the keeper to paste — still never writes the index.

## 9 · The ceremony dial — minimum reasonable ceremony, per store, on the shop's ladder

His ruling, 2026-09-05: *"I am not going to clearsign individual memory files"* — and the design must
suit different preferences, not argue one. Where the signing assumption came from: not tonight's files —
`seatkeeper` move 6 ("if it is signed, the re-sign is the keeper's keystroke") and the one historical
`blessed-principle.md.asc` in the seat; a cold session reads both as precedent.

The dial reads **1 · 2 · 4 · 9 · 17** — the shop's own ladder (4 GRAIN, 9 GREAT, 17 GRAND; 1 and 2 beneath
them), and the number means something a stranger can check: **the size of the ring the ceremony is meant to
convince.** `bin/ms1dg --ceremony N` runs the same gauge at any stop; the keeper sets it per store.

| stop | ring | what the store carries | mechanism (gauge) | what a signature would add here |
|---|---|---|---|---|
| **1 HASH** | yourself | identity only — sha256 is the note's name | G1–G5, G8 | nothing; a hash answers "same note?" |
| **2 WORDS** | a pair | + provenance as frontmatter words a second reader acts on: `originSessionId`, `modified:` (harness), `seat_copy:` (instrument), `blessed: <date>` (keeper-typed) | G6, G7 | nothing a grep can't read |
| **4 GRAIN** | a small ring | + a regenerated hash manifest, checkable without reading the notes | G9 (`--manifest`, automatic at 4) | a third opinion on a question two readers answer |
| **9 GREAT** | strangers | + a sibling `.asc` per note verifying against a pinned key | G10 (`UNVERIFIED-NO-KEY` when the keyring lacks the signer — never "BAD" for a missing key) | this is where a key earns its place |
| **17 GRAND** | a shelf | + `.gate` vouch map, license, `check-shelf` | G11 | publication ceremony |

**Settings tonight:** `memory/` = **2**, or **4** when a manifest is wanted (never 9 — the ruling);
`pub/` = **17**; the C4 `bin/` at the ship boundary = 9 (the runbook). Below 9 a stray `.asc` beside a note
is FURNITURE, never an expectation; `seatkeeper` move 6 becomes an ENHANCE line under Q1: *the index is
never signed; consolidate and hand back the words.* The one existing `.asc` may stay as history or go —
a one-word ruling. [MINE ~70%] the low stops are also the more portable floor: a stranger's notes folder
has hashes and frontmatter and no keyring, and the pattern composes with it as it stands. Off-ladder
values are warned by the tool (G0) until the pick is explained in C4's terms.

## 8 · Cards (keeper hands)

- **CARD 6** — `autoMemoryDirectory` test (§5.1): WHEN a quiet session; DO set
  `"autoMemoryDirectory": "F:/claude/AS4CE/AS4CE0001/memory"` in the session's user `settings.json`
  (location per `/memory` → open folder → parent's `settings.json`), start one Cowork session, ask it
  "what is your memory directory?"; CHECK the path it prints; TELL-ME either way — it decides §5.
- **CARD 1** (grows): 24 A-index lines → seat index (list in `mainmem/MS1DG-2026-09-05-sandbox.md` G8);
  35 seat-native unindexed notes (G3) — `--index-lines` (§7) would draft them; until then, hand.
- **CARD 2** (grows): `rm memory/.probe-2 memory/.probe-renamed` and `AS4CE0002/h/kit/__pycache__/`.
- **CARD 7** — host run + diff (§4). Two minutes; it answers the lock question for good.
