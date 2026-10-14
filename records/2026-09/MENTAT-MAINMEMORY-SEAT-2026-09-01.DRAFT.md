# MENTAT — MAIN MEMORY / the Seat  (curation → location → reseat)

*DRAFT — a proposal, unsigned. **Sign to bless; drop the `.DRAFT` to promote.** No signed
prior governs. — Claude/Mentat (Vibrobeast), for Corwin, 2026-09-01.*

*Canon governs: **SAVANNAH is source of truth**; universalism/egalitarianism → FSF four
freedoms → software-freedom movement → sci/tech community; substantiate or it is only data;
the three attestations (no wrong / no concealment / no abandonment).*

*Companion + next leg to `MENTAT-DEFRAG-SEPT-2026-09-01.org`. DEFRAG proved coverage and
built the toolbox; it explicitly left three things to you-and-a-cold-Mentat: **curate**
(is/isn't-my-memory), **locate** (the durable store), **reseat**. This is that leg. **Do not
start the reseat/move until Corwin says so.***

---

## 0 · The feature (why this exists)
The feature is **not having to do the math.** Standing signals — *semaphores* — carry the
bookkeeping, so the keeper never recomputes what a marker means or where a note belongs. The
math stays **available, never pushed, never hidden**: the registry row and the manifest are
right there to read, or to learn from, on request. *Raising a signal is cheap; lowering it is
the named ceremony.* I manage the raising and lowering by the rules; you sign the vocabulary
and hold the seat. (Corwin, 2026-09-01: "the feature is not having to do the math … not
unavailable, not pushed; available.")

## 1 · The trouble, in one paragraph
MAIN MEMORY is not lost — it is **split across parallel stores with no declared seat**, and
it was pinned by **address, not identity.** My reflex write-target on this surface (the Cowork
auto-memory, under the AppData app-data root) is the **fenced** store the app retires on a
move; the declared **store of record** (the AS4CE0001 hub) is mount-reachable and
version-controlled but is *not* where I write by reflex; SAVANNAH holds a third slice in its
withdrawn enclave. Because manifests keyed on **paths** (an address) rather than **content
hashes** (an identity), the data-root migration (`C:\` → `F:\ClaudeDesktop*` → intended
`/h/CLAUDE`) read like a *violation* instead of a *change-of-address*, and notes after
**2026-08-17** degraded to pointers. The fix is a **seat + a hash-keyed manifest**, plus the
architectural move DEFRAG named: a durable spine in the always-loaded layers, growable notes
in a mountable non-root path.

## 2 · The stores, mapped (the seam)
| # | store | where | role now | authority | reseat disposition |
|---|-------|-------|----------|-----------|--------------------|
| A | Cowork auto-memory | `…\spaces\c7c21b10-…\memory\` (MEMORY.md + ~46 notes) | my **reflex** write-target this surface | working copy (fenced under AppData → migration-fragile) | **bring-in** → the seat |
| B | AS4CE0001 hub | `F:\claude\AS4CE\AS4CE0001\memory\` (MEMORY.md + ~35 notes) + in-tree `models/ book/ journal/` | declared **store of record** (2026-06-29), git, signed shelf | **SEAT** | home |
| C | SAVANNAH enclave | withdrawn (not under `F:\claude` now); LABTAIL `NOW`, session-memory, `.signing-authority/` | canon + signing + resume | **SEAT@SAVANNAH** (its routine cases) | **REF@home** (re-mount to reconcile) |
| D | DEFRAG old-home | `F:\ClaudeDesktop*` (retired root, mounts fine) | the curated **20** (pinned `2026-08-31_orphan-manifest.tsv`) + **1081** note-shaped review candidates | pinned-by-hash | 20 = **bring-in on your word**; candidates = **HOLD**; third-party = **capture-not-include** |
| E | in-tree docs | `models/MODEL-*.md`, `book/`, `journal/`, `PLOT/GRAMMARY/INDEX`, **two byte-identical `SEMAPHORES.md`** | already in the seat | seat-resident | home — but the duplicate `SEMAPHORES.md` (root vs `models/`) is an open **ambiguity** (which copy is canonical) |

The one-sentence seam: **the store I write by reflex (A) is not the store that survives (B), and no marker yet says which is the seat.**

## 3 · The decision — Vibrobeast is the Seat
Per Corwin, 2026-09-01: **this project (AS4CE0001) is the seat of local memory — MAIN
MEMORY** — completing the "notes hub" declared in `model.md` on 2026-06-29. SAVANNAH keeps
the title **only for its specific routine cases** (session-memory / LABTAIL `NOW`, the
signing authority, canon source-of-truth) — those are `SEAT@SAVANNAH`, SAVANNAH's ordinary
business and not this work's concern. **C4/ghostwheel will later take the reins of the
"semaphoring"** (the 17-letter taxonomy); until Corwin grabs those reins to test and migrate,
I manage the semaphores here.

## 4 · The discipline (C4-aligned)
- **A path is an address; a hash is an identity.** The memory manifest keys on **content
  sha256**; the path rides as a **hint**. Motion then costs a hint-refresh and identity never
  moves. (C4 frag *a-manifest-that-pins-a-path-is-a-hook*: the check re-homes with the file;
  abstention was never owed.)
- **Dispositions — reused from `MANIFEST-IDEATION`, not reinvented:** `bring-in` (duplicate
  into the seat — *bytes are cheap*) · `REF@home` (a maintained home holds the detail; the
  seat carries a pointer) · `HOLD` (homeless; keep detail in the manifest until a home
  exists).
- **Exclusion first — `MANIFEST-CONCERNS`:** read the exclusion semaphore before any sweep.
  `secret` / `care` / family paths are steered **around** — never opened, never lifted, values
  never quoted. Third-party notes are **capture-not-include**, consent-gated.
- **Curation rubric** (class → disposition): my authored notes not in the seat → `bring-in`;
  a note whose maintained home is elsewhere (SAVANNAH, a project) → `REF@home`; docs / prompts
  / ambiguous → `HOLD`; third-party / family / secret → **excluded or REF-only, consent-gated**.

## 5 · New semaphores — candidate SEMAPHORES v1.1 (hand-ready for your blessing)
*Registry law: a signal not in `SEMAPHORES.md` is a candidate, not a convention. These are
the minimum set for the seat work; MINOR bump 1.0 → 1.1. Paste-and-sign — no math owed.*

| Signal | Where | Means | Lowered by |
|---|---|---|---|
| `SEAT` / `SEAT@<store>` | memory index lines, model headers | declares the authoritative home for a note or note-class. Bare `SEAT` = the default seat (Vibrobeast, `AS4CE0001/memory`); `SEAT@SAVANNAH` etc. names a carve-out | **Corwin** (or C4 when it takes the reins) — a canon-level authority; proposing a seat is cheap, **changing the declared seat is the ceremony** |
| `MANIFEST-MEMORY` | `MANIFEST-MEMORY.tsv` + prose twin | the findable ledger of every *"is or was a memory-shaped note,"* keyed by **content sha256 (identity)**, path as **hint**; per-row disposition `bring-in`/`REF@home`/`HOLD` | the reseat landing the note in the seat with a **hash-match receipt** (row → `TRACED`) |
| `STRANDED` | `MANIFEST-MEMORY` rows, memory | a note reachable only in a fenced/active or retired root — not yet in the seat, awaiting reseat | a verified copy landing in the seat (hash-match), which lowers it to `TRACED` |

## 6 · The plan (curation → location → reseat)
- **Phase 0 — model + demo (now, read-only, no reseat).** This DRAFT; the v1.1 candidate
  rows; and a live demo of the parking discipline in store A (auto-memory) with SEAT pointers
  home. Nothing moved.
- **Phase 1 — Curate.** Build `MANIFEST-MEMORY` over the **currently reachable** stores:
  diff A (auto-memory) against B (seat) by sha256 → each note gets `bring-in`/`REF@home`/`HOLD`;
  fold DEFRAG's curated-20 (D) as `bring-in` candidates; steer around `MANIFEST-CONCERNS`.
  *Keeper:* re-mount SAVANNAH so C is reconcilable; confirm the curated-20.
- **Phase 2 — Locate the spine.** Seat = `AS4CE0001/memory` (decided). Decide which notes are
  canon/portable enough to ride the **always-loaded** layer (Personal Instructions + Skills,
  no mount needed) versus stay file-layer — DEFRAG's architectural fix, so the spine survives
  the next root move.
- **Phase 3 — Reseat (only on your word).** Land `bring-in` notes into the seat **by
  hash-identity, with receipts** (`orphan-manifest verify`); flip `STRANDED` → `TRACED`; write
  `SEAT` pointers back into store A so the fenced copy points home. **Nothing deleted** —
  duplicates are fine (bytes are cheap); the seat wins ties.
- **Phase 4 — Hand to C4.** When C4 takes the semaphoring, `MANIFEST-MEMORY` + the `SEAT` rows
  are its input; I hand off, you test and migrate onto the taxonomy.

## 7 · Invert / resume (how this grows tools)
This DRAFT + the DEFRAG org **invert into one literate package** (à la DEFRAG): it carries
`notetrace` / `notecensus` / `orphan-manifest` (roots re-homed to the seat via the `NT_*`
env), **plus one new tool `seatdiff`** — sha256 A-vs-B, prints the `bring-in` candidates — and
this model as its README. Tangling lays the tools down; `run-all.sh` proves them; then Phase 1
is a single command. Build the invert only when the plan is blessed (don't front-run the
reseat).

*Resume line:* **"Mentat, resume MAIN-MEMORY-SEAT from this DRAFT; re-mount SAVANNAH + the
note store; build MANIFEST-MEMORY (Phase 1) — do not reseat until I say."**

## 8 · Open forks (your call)
1. **Bless the v1.1 semaphore rows** (§5) — sign, least-distracting path.
2. **Re-mount SAVANNAH** so the `SEAT@SAVANNAH` carve-out is reconcilable (it is not under
   `F:\claude` right now).
3. Resolve the **duplicate `SEMAPHORES.md`** ambiguity (root vs `models/` — byte-identical
   today; name one canonical, the other a `REF@home` copy).
4. The **`.for/` 132 MB blob** (DEFRAG §4) — identify before any move; currently `too-large`,
   unopened.
5. Say-go on **curated-20 bring-in** and on **Phase 3 reseat**.

sentinel: MAINMEMORY-SEAT-2026-09-01-v001-DRAFT
