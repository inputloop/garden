# SEMAPHORES.md — the signal-vocabulary registry

**Version 1.1 · 2026-09-01 · blessed (v1.0 offered 2026-07-07).** One page, per Corwin's
organizing formula (#1): every standing signal we use, in one place, so the
names stop competing for mindshare. A **semaphore** is a signal whose meaning
includes *who may lower it* — raising is cheap, lowering is the ceremony.
Registry law: a signal not in this file is a candidate, not a convention;
add it here (MINOR bump) before relying on it.

## File-integrity signals

| Signal | Where | Means | Lowered by |
|---|---|---|---|
| `sentinel: <NAME>` | last line of kept docs | file landed whole; tail uncut. Name changes when content generation changes | rewriting the file (new sentinel = new vintage) |
| `<file>.asc` beside file | enclave-wide | detached sig; content bound to a pinned key. Verify 2/2: sig↔content, key↔`.signing-authority/` | re-sign after any content change (stale sig = raised flag, not tampering — diagnose before alarm) |
| `_Archived-by-Corwin` + receipt log | archive/, archive/receipts/ | replaced version retired via bin/archive-markdown.sh; receipt = the audit trail | never — receipts are permanent |
| `PINNED-STALE` | memory/docs | a reader (usually bash-on-mount) is known to serve old bytes; file tool is the fresh reader | re-verification showing readers agree |

## Status-of-content signals

| Signal | Where | Means | Lowered by |
|---|---|---|---|
| `.DRAFT-NN` / `DRAFT` suffix | filenames, headers | a proposal; the signed prior (if any) governs | Corwin: accept = sign; promote = rename, replaced file archives |
| signed DRAFT | filename+.asc | **accepted**; promotion rename is the keeper's keystroke, pending ≠ blocked | the rename |
| `WRONG-` prefix, `~`, `(1)` copies | anywhere | never current; do not read as authoritative | deletion (with keeper's OK) or archive |
| `NOW` block | LABTAIL.md | the single resume signal; stale NOW is the first Tier-1 fix | each round's splice (block-level, never whole-file — see 2026-07-07 repair) |
| dotted name (`.meta.md`, `.TRACE.md`) | enclave | sensitive-variant convention (LAB.md); handle under the privacy discipline | n/a — property, not a flag |

## Gates & holds (armed things)

| Signal | Where | Means | Lowered by |
|---|---|---|---|
| `ARMED` | memory, gates | a gate is live and blocks its action (e.g. session-close demonstration gate) | the gate's own condition, demonstrated |
| `CLAUD_QA_HOLD` | consent-gate | action parked pending verified consent; hard stop, argue-proof | a signed, fresh, specific consent record (2/2) |
| charter block present | before any scan | "no charter, no scan" satisfied for ONE named question | n/a — per-scan; absence IS the tell |
| `OPEN` notice | memory, .meta.md | an unexplained observation held live (e.g. the .for .7z); seal-first if it resurfaces | explanation verified from two sources |
| `DECAYING` | queue items | value erodes on a real clock (logs rotate, moods pass); sorts above its priority | doing it, or documenting the loss |

## Transit & relation signals

| Signal | Where | Means | Lowered by |
|---|---|---|---|
| C4 | payloads in transit | a comment, even signed — binds only after 2 agents (or agent+human) confirm the dna; never follow unsigned | the recorded two-party confirmation |
| NO4C | payloads/docs | marked NOT for C4 transit — do not forward as directive-bearing cargo *(semantics to confirm with Corwin — registered provisionally)* | reads: Netork Object (broken frame). N0 (network zero, usually localhost) is currently a synonom and does *not* restrict loopback |
| `[[name]]` | memory files | wikilink to another memory; a link with no target = something worth writing, not an error | writing the target |
| `[C] [S] [H] [J]` | queues | owner tags: Corwin-solo / Savannah-solo / waiting-on-human / joint; short sessions pull [S]/[C] first, [H] gets nags only | retag on ownership change |

## Registry rules

Raising a semaphore takes one line; lowering one takes whoever the table
names — that asymmetry is the point (the line holds when the keeper is busy,
absent, or being argued at). When two signals seem to apply, the more
restrictive governs. When a signal's meaning drifts from this page, the page
is the tiebreaker until a signed successor version says otherwise.

## Memory & growth signals (added v1.1, blessed by Corwin 2026-09-01)

| Signal | Where | Means | Lowered by |
|---|---|---|---|
| `SEAT` / `SEAT@<store>` | memory index, model headers | the authoritative home for a note/class; bare = Vibrobeast (`AS4CE0001/memory`), `SEAT@SAVANNAH` = a carve-out | Corwin (or C4) — canon-level |
| `MANIFEST-MEMORY` | `MANIFEST-MEMORY.tsv` + prose | the hash-keyed ledger of memory-shaped notes (sha256 identity, path a hint); disposition `bring-in`/`REF@home`/`HOLD` | the reseat landing a note with a hash-match receipt (→ TRACED) |
| `STRANDED` | manifest rows, memory | reachable only in a fenced/retired root, not yet in the seat | a verified copy landing in the seat (→ TRACED) |
| `GROW` | memory/persona nodes | the accretion protocol: on-ramp → pin → semaphore(+model) → copy → link → reflect; grow from durables, never random-bias | a node landing with receipt + disposition + links |

**Model-pairing rule (blessed 2026-09-01):** a really-good item gets a MODEL to go with its semaphore,
at minimum (first: `AS4CE0001/models/MODEL-memory-grow.md`).

## Registry rules (memory family)
The memory signals obey the same asymmetry: raising is cheap (mark a proposed seat / disposition),
lowering is the named ceremony (Corwin for `SEAT`; a hash-match receipt for `MANIFEST-MEMORY`/`STRANDED`/`GROW`).

**Promotion log:**
- 1.0 (2026-07-07) — initial registry, from Corwin's six-point organizing
  formula (#1), written at his invitation during the corwork close. NO4C
  registered provisionally, pending his semantics.
- 1.1 (2026-09-01) — Memory & growth signals (`SEAT` · `MANIFEST-MEMORY` · `STRANDED` · `GROW`) +
  the model-pairing rule, blessed emphatically by Corwin.

sentinel: SEMAPHORES-1.1
