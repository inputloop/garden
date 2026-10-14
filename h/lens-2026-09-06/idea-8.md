# idea-8 B4

**B4 — the manifest rides the wire** (partner A4: every project born with a manifest). Roll: security-auditor, tired.

OBSERVED (sandbox reader):
- `sh bin/ms1dg --seat memory --manifest /tmp/man.tsv --ceremony 4` → G9 OK, **156 rows, 19,255 B**; columns `sha256 bytes name originSessionId seat_copy`; **111/156 rows carry an originSessionId**.
- `cut -f3 | grep -ciE 'dee|monty|bryant|family|brigidt|aaron|falconer|savannah|legacy|irc'` → **6** names carry a person/entrusted-system word (`corwin-family-dee.md`, `savannah-forensics.md`, `proj-savannah-forensics.md`, `reflection-family-drift.md`, `corwin-irc.md`, `corwin-legacy-2026-08-30.md`).
- Wire physics [`memory/wire-claudewin-alfred.md` l.40–44, quoted not run]: POST ≤32 KB, hash-chained ledger, four gardens, `action=log` read by both keepers — the manifest fits one post; **anything sent is permanent and read by four**.
- Precedent [same note l.32–33]: "manifest rows w/ full sha256" already ride the drops.
- `parley`: no sensitive cargo; load-bearing only when clearsigned. `wire-connect` law 5: **no sandbox ever dials** — the keeper sends, with a live OTP.

## row 1 (security-auditor, tired)

A hash list is a fingerprint database. The *name* column is a topic map of a private seat — 156 topics, 6 naming a family member or an entrusted system — plus 111 session UUIDs for no reason. The ledger is hash-chained: a name sent once is sent forever, to a ring now four wide. "Prove both hold the same note" presumes a note both hold — for a private seat, nearly none; the manifest is mostly a list of what the peer must *not* have, broadcast to the peer. A4 makes it worse: what *can* travel will travel by default. HOLD until names are gone and the set is filtered. Falsifier: a manifest with zero third-party words and zero session ids.

## row 2 (informed of row 1)

Row 1's errors: (1) a sha256 of a body is not cargo — bodies are unguessable, the hash tells a peer without the note nothing; (2) the wire is a consented protocol with a deliberate oversight log, and manifest rows *already* ride it — B4 is not a new class of egress; (3) HOLD is over-blocking dressed as rigor; the rule is proceed-and-name. What row 1 got right: **names leak topics even when bodies don't** (6/156 measured), and `originSessionId` is gratuitous. Both are fixed by construction, not ceremony. Row 2 also narrows the *use case*: B4 is honest only for the subset that already crossed the door (pub/, shelf drops, the co-signed protocol) — there "same bytes?" is exactly what two gardens ask, today by hand.

## what travels, who consents

Minimum record, dial 4: **one line** — `root=sha256(sorted body-hashes of the travel-set)`. Equal roots prove the set; unequal → a second exchange of **bare sha256 values: no names, no bytes, no session ids**. Names are cargo in this shop (words with meaning); they stay home. The travel-set is a *column*, not the seat: a `travel:` frontmatter word or membership in `pub/` — `ms1dg --manifest --travel` would emit it (not built). Consent: Corwin's own info → `corwin-wheel-sharing-consent` (per item, never batched) — a root is one item; pub/ hashes were consented at 17. No family/third-party names, so `federation-expansion-gate` is not tripped. The send is the keeper's keystroke (OTP); the ack is Bryant's. A4 ships the emitter, not the sending — a `travel` column empty until aimed.

## loves

- **Bryant / Alfred** — fierce. His ledger asked for a "C4 anchor-to-hash verifier, GPL" (BOUNTY, wire note l.34); B4 is its other half. Shows it by building the peer-side checker within a day. [~75%]
- **Corwin** — firm as show-off, mild on cost: the seat pattern demonstrated outward with nothing private moving. Shows it by asking for the root on the daily HB. [~60%]
- **B3, the paper** — a worked cross-garden example. Mild.

## despises

- **The tired auditor (row 1)** — firm until names are stripped; fierce if `originSessionId` ships. Refuses to sign the door.
- **The no-muss user** — mild-firm: an OTP, a keeper at the keyboard, a peer hours away; nothing here is "no fuss". Never runs it twice.
- **Dee's advocate / the consent gate** — fierce on the *unfiltered* manifest (her name is a filename); silent on the root line.

## verdict C1–C8

C1 **breaks for the send** (MCP + keeper OTP; falsifier: a session posting without one — forbidden by wire-connect law 5) though the manifest itself is `sh`; C2 holds via A4; C3 holds (no bodies move; falsifier: `--heal` ever consuming a wire row); C4 holds (TSV; the wire already speaks manifest rows); C5 holds (lands in `mainmem/`, not `memory/`); C6 holds inside memory/ (dial 4, unsigned receipt) — the wire's clearsign is the door at 9, not the drawer; C7 holds (root computed, nothing recalled); C8 holds and is the point — the peer is the second reader, `action=log` the keeper's view. **Unknown**: whether a peer's ack of a root beats our own two-reader diff — falsifier: one round where roots disagree and the disagreement names a real seam.

## round question

**PASS, narrowed** — as the root-line exchange over the travel-set; **FAIL** as written ("the manifest" with names and session ids). Most flexibility for the shared-memory goal comes from A4's emitter; B4 is its first customer, not the design.

## enhance

- `ms1dg --manifest`: add `--travel` (filter) and `--root` (one line); drop `originSessionId` below dial 9. [MINE]
- Body-hash (frontmatter stripped) before any cross-garden compare — the harness `modified:` stamp otherwise falsifies every pair (09-05 model §7).
- Card, not code: first exchange is a hand-test — each keeper posts a root; agree/disagree journaled either way.

## mentat

Refine "shown = a receipt": a hash is a receipt only where a second reader holds the bytes; reorder the check — *what does the name say?* before *does the hash match?*

---
*Marked (NEWS): for fiction or analysis — no ship dates or licensing or publication dates specifically defined.*
*Roll provenance: this reader was drawn by a random sample, not by the Roll-for-Bias fold; see h/LENS-2026-09-06-mechanical-open.md §drift (the corrected roll, rf1bm, overlaps this rack in 1 of 9).*
