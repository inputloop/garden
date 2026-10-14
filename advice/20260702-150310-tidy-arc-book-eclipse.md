---
kind: advice
scope: workspace layout
recorded: 2026-07-02T15:03:10
---

# Tidy: .arc/ mirror-archive, book/, .eclipse-increments/

Corwin ("can we tide?") chose a dotted `.arc/` mirroring the tree.
Rationale beyond taste: dot-dirs are invisible to polygram `discover()`
and never staged by dist, so archived material can't bleed into
candidate scans or mints — the archivist convention and the supply-chain
hygiene are the same move.

- `.arc/` created; ledger at `.arc/README.md`. Took: archive/ (folded
  whole), baseline-testing/, debug/, corwin-wget capture, 06-29 session
  close, sandboxer proposal, init-git script.
- `book/` gathers the persona/book corpus (13 files). **MINIONS NOTICE:**
  `CORWIN.md` — watched surface — was *moved* to `book/CORWIN.md`,
  content untouched (sha-stable move via mv). INDEX.md updated to the
  new paths. No PRINCIPLES/canon content changed.
- `.torture-*` → `.eclipse-increments/` — the renounced name is retired;
  increments live where eclipse-pass parks them.
- Session rotated v7→v8 (snapshot .models/model-2026-07-02_145835.md),
  fresh continuity files written with real content. model.md: tests 66,
  0.5.4-pending noted, Layout row added.
- dist/ observed empty: Corwin retired 0.5.3 artifacts ahead of the
  host respin. rm now enabled on the mount (granted this session).

Host to-do unchanged from advice/20260702-141732: respin 0.5.4, commit
everything (this tidy is all renames — git will track them cleanly on a
host-side `git add -A`).
