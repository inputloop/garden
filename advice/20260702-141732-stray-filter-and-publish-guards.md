---
kind: advice
scope: dist, publish (corwin hub)
recorded: 2026-07-02T14:17:32
---

# Temp-file stray filter + publish v0.0.4 guards

## What changed (sandbox side, tests green 66/66)

polygram/dist.py — new `_is_tmp_stray()` wired into `_is_junk()`:
sed -i mkstemp siblings (`sed` + 6 alnum, requiring a digit/uppercase so
"sediment"/"sedations" never trip), vim swaps (`.*.sw[pox]`), emacs
lockfiles (`.#*`). Root cause of the 0.5.3 `sedx44W4d` residue; filter is
mint-time, so a respin cannot carry strays. tests/test_dist.py grew unit +
bundle coverage incl. the false-positive check (`sediments` ships).

corwin hub, publish 0.0.4 r2 -> r3 (bin/publish):
- `hub_root()` honors `PUBLISH_HUB`, and either way asserts hub-ness via
  `PRINCIPLES.md` or dies — the inside-hub guard no longer silently aims
  wrong after graduation/deeper install.
- mirror-image sync guard: a CHECKOUT that *contains* the hub (e.g.
  F:\claude itself) is refused, matching the inside-hub refusal.
- `pubdir` failures now propagate (`|| exit 1` at audit/manifest/sync
  call sites) — fail closed, never operate on an empty path.
- usage text updated; guard matrix exercised 7/7 in /tmp (assert-hub,
  PUBLISH_HUB override, inside-hub, contains-hub, legit outside, default
  pubdir). `sh -n` clean.

## For the host (manual, per audits-and-commits-from-host rule)

1. Respin dist as **0.5.4** from the host: filter now upstream; verify no
   `sed?????\?` names in the new MANIFEST; retire 0.5.3 artifacts.
2. Commit polygram (dist.py, test_dist.py) and hub bin/publish from the
   host — sandbox cannot push, and this session re-confirmed BOTH mounts
   serve new-bytes-at-old-length to bash after file-tool edits (dist.py,
   test_dist.py, and bin/publish all did it). File tool = ground truth.
3. publish v0.0.4 cold-review can proceed: OPEN (b) closed host-side
   (pinned detached README sig), hub_root + containment guards now in.
   OPEN (c) (FURNITURE vouches existence not content) still stands for
   v0.1 via `sign.sh detach`.

## Opportunity carried forward

The pinned-fingerprint dual-source pattern (pub shelf + Savannah GPG page)
is the shape #86 tree-verify wants; when publish graduates, the same audit
gate can vouch Savannah-bound artifacts. Filed by the corwin-side twin;
seconded here — it folds the lab work back into freedom infrastructure.
