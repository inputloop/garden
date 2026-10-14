---
kind: advice
scope: vibrobeast pub shelf — first consented public ship
recorded: 2026-07-05
---

# vibrobeast ships: the pub shelf goes to the open internet

Corwin, 07:01: "I have read and consent. Let's see if we can ship it."
Cleared 07:14 after three gate catches, each of which made the record
more honest:

1. **Stale-read scare** — five MANIFEST hash mismatches + a failed zip
   sig looked like tamper; `bin/freshen`'s rename dance proved all five
   were bridge-cache lies (the tell: a file can't fail its sha and pass
   its clearsign on the same bytes). 11/11 after the dance.
2. **CEZB** — every WHAT column stamped with one opaque token by perl
   one-liner. Flagged; Corwin: "not quite getting it — put it back."
   Restored to TODO, per-row draft written.
3. **Signed the TODOs** — re-signed before filling the WHATs. Caught;
   WHATs adopted per the hello-principles mint rule (instrument drafts,
   keeper reads + signs). Final signature 07:14:35, endorsed
   "wholeheartedly."

Final chain: pinned clearsign OK · 11 rows, 0 TODOs · 11/11 per-file
sha · zip detached sig OK · .gate read-write, no embargo, "public by
construction" · content scrub clean (no third parties beyond Bryant's
countersigned public key — a federation act; QA-6 closes: v1.0 travels
in hello-principles.md).

Wire before ship: vibrobeast@106ea86 already public and level with
upstream; nothing from the morning's fumbles ever left the machine.

LANDED, verified 2026-07-05 ~07:25 via the incognito-screenshot pattern:
commit 27ca351fe5 "(v0.6.0)free latest mutations, corwin-pub.zip and
polgyram" live at code.bru.st/corwin/vibrobeast (2 commits, master,
443 KiB) — MANIFEST, corwin-pub.zip(+.asc), releases/, runbook, and
WHATS-draft.md all public. Corwin's send-off: "be free."

Note for the book: the shelf's first shipment is the method itself —
CEREMONIES.md publishing the very gates that caught the three errors
that preceded its shipping. Publication guard satisfied: supervision
(present, consenting), review (this chain), receipts (above).
