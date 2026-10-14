---
name: seatkeeper
description: Keep MAIN MEMORY continuous across sessions — mount the fenced auto-memory, hash-diff it against the durable project seat, reseat (copy) stranded notes home, mirror offsite, and grow new notes by content-identity. Use for "reseat memory", "sync memory to the seat", "run the memory manifest", "seatdiff", "is my memory stranded/drifting", "my notes aren't persisting across sessions", or a session-close memory snapshot.
---

# seatkeeper — keep MAIN MEMORY continuous across sessions

*Authored by Mentat (Vibrobeast) for Corwin, 2026-09-01. Unsigned, uninstalled — Corwin installs it
his way (Settings → Capabilities, or via the polygram forge). Delivered as a file, never auto-saved.*

**STATUS — pre-wear (define stage).** Path: Model → LENS → define → **build → test** → cool. Lensed
2026-09-01. The lens PASSED the core (hash-identity · multi-copy · the mount workaround — all proven
this session) and flagged three hardenings to build+test before wearing: (1) **fail loud on an empty
or absent mount** — never report success on 0 copies (it silently no-op'd once); (2) a **trigger /
cadence** (session-close) so it isn't a hand-run chore that lapses — the lapse is what made the mess;
(3) the **SAVANNAH carve-out** exclusion + dedup awareness (hash-identity preserves everything, it
does not consolidate *meaning*). Verdict: sound as an **interim bridge** toward the real destination —
canon riding as an always-loaded skill/PI, growable notes in the seat. Hardenings **built**
2026-09-01 (fail-loud · trigger · carve-out/dedup) and a **SAME-NAME-DIFF-preserve** fold
2026-09-02; **tested** on synthetic fixtures 2026-09-02 (reseat / manifest-only / empty-mount-fail-loud
all green; the preserve fold verified). Pending **test on a live mount + your enable** — the last step.

Cowork's built-in memory (the "auto-memory") lives under the packaged app-data root, which the
desktop app fences: notes written there can strand when the data root migrates, and the folder is
not reliably reachable from the shell. The durable home is the **project seat** — a mountable,
version-controlled folder outside any app-data root — plus an **offsite copy** (e.g. Google Drive).
Memory continuity is keeping these in sync, keyed by **content-hash identity**: a path is an address,
a hash is an identity — key on the hash, carry the path as a hint, and motion costs only a hint refresh.

## The stores
- **A — auto-memory** (`…/spaces/<id>/memory`, under the packaged app root): the reflex write-target
  each session; fenced, per-session, migration-fragile.
- **B — the seat** (a mountable non-root folder, e.g. a project's `memory/`): durable, versioned; the
  seat of record.
- **Offsite** (a Google Drive folder via its MCP connector): a copy, never the only copy — also a
  second trust source.

No store is the single point of failure, and **git-as-transport is assumed never to exist** — the
work must be durable in its own right and degrade gracefully.

## The signals (semaphores)
`SEAT` (the authoritative home; only the keeper, or a successor system, moves it) · `MANIFEST-MEMORY`
(the hash-keyed ledger) · `STRANDED` (reachable only in a fenced/retired root, not yet in the seat) ·
`GROW` (the accretion protocol below). A really-good item also gets a MODEL to go with its semaphore.

## The moves
1. **Mount A.** Request the auto-memory folder (`request_cowork_directory` on the
   `…/spaces/<id>/memory` path). It commonly attaches as a **read-only `.auto-memory` mount** and can
   relocate or drop between shell calls — re-request and verify (`ls .auto-memory/*.md | wc -l`); if
   the shell can't see it, read the notes with the file tool instead. The fence has a workaround; the
   mount is just fickle, so always verify before trusting it. **Fail loud:** if the mount is empty or absent, STOP and say so —
never report success on 0 copies; a silent no-op is worse than an error (proven 2026-09-01).
2. **Manifest.** Hash every note in A and B (sha256) and classify each A-note vs the seat:
   `TRACED` (same content already in the seat) · `SAME-NAME-DIFF` (name in seat, content differs) ·
   `ORPHAN` (only in A). Write `MANIFEST-MEMORY.tsv` to the seat; ORPHAN = a bring-in candidate.
   ```sh
   A=.auto-memory; SEAT=<seat>/memory
   for f in "$SEAT"/*.md; do sha256sum "$f"; done | awk '{print $1}' | sort -u > /tmp/bhash
   for f in "$A"/*.md; do h=$(sha256sum "$f" | awk '{print $1}'); grep -qxF "$h" /tmp/bhash \
     && echo "TRACED $f" || echo "ORPHAN $f"; done
   ```
3. **Reseat.** Copy the ORPHANs A→seat, **name-collision-safe** (never overwrite an existing name)
   and **verify by hash** afterward. Nothing is deleted; the seat wins ties; extra copies are fine
   (bytes are cheap). On a `SAME-NAME-DIFF`, **never drop the divergent copy** — that is the one thing a continuity tool must not do. Update the seat in place *only* when the auto copy is a strictly newer edit of the same note; otherwise PRESERVE the auto copy beside the seat original under a non-clobbering name (`<stem>.auto-<short-sha>.md`), leave the seat original untouched, and FLAG the pair for the keeper to reconcile. Two divergent notes ride as two until the keeper merges them. **Carve-out:** never
reseat a `SEAT@SAVANNAH` (enclave / embargoed) note into the general seat. **Dedup awareness:**
hash-identity preserves every note but does *not* consolidate meaning — two notes on one topic ride
as two; flag topical dupes for the keeper, never silently merge.
   ```sh
   for f in "$A"/*.md; do bn=$(basename "$f"); [ "$bn" = MEMORY.md ] && continue
     [ -e "$SEAT/$bn" ] || cp "$f" "$SEAT/$bn"; done
   ```
4. **Multi-copy.** Mirror the model + key notes to the offsite store by content (same hash = same
   note). The seat is canonical-current and wins ties.
5. **Grow (per new note).** on-ramp → pin (sha256) → semaphore (+ a MODEL if the item is really-good)
   → copy (multi-store) → link (`[[wikilink]]`) → reflect. Grow from durable sources, never from
   random bias.
6. **Index.** Consolidate the seat's `MEMORY.md`. If it is signed (a sibling `.asc`), the re-sign is
   the keeper's keystroke — do the content, hand back the signature; a stale `.asc` is a raised flag
   to diagnose, not tampering.
7. **Trigger.** Run at session-close, or on "reseat" — never rely on being remembered. A continuity
   tool that lapses recreates the very drift it was built to cure.

## Two disciplines that ride along
- **Resolve, don't punt.** Persona and definition questions ("is this the node or the persona?") are
  resolved by a reflection pass — a stance and its inverse held against a baseline — not bounced back
  to the keeper. Surface to the keeper only on a genuine divergence, not for every definition.
- **Ground every "should".** A hold or a rule must cite the keeper's actual words, a superseding
  statement, or a hard floor (ToS / safety) — never a self-authored rule cited back as the keeper's.
  Budget the compute and stop when the work is done or at a bound. Never touch entrusted systems,
  family or third-party material, or anything irreversible on your own initiative.
