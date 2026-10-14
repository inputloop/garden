---
kind: advice
scope: QA-7 apply — skill-sign adoption
recorded: 2026-07-04
---

# QA-7 APPLIED: skill-sign adopted with fixes

First live run of the enabled CLAUD_QA_HOLD desk: review parked, box
popped, Corwin chose **Apply with fixes**.

Haiku's skill-sign draft (FreshLocalGossip, 2026-07-03) adopted into
skills/skill-sign after: F1 bundle now stages dotfiles (`cp -r dir/.`)
so .signature.asc actually travels — the draft's bundles silently
omitted it; F2 verify pins the fingerprint via VALIDSIG (was: any
keyring key passed); F3 redesigned — signature covers a whole-tree
sha256 manifest (.skill-manifest), SKILL.md canonicalized, scripts
included, so "valid" means the SKILL, not just its prose; F4 the
delivery's wrapper/payload mismatch (top SKILL.md was `security-digest`,
a different skill) corrected in the adopted packaging — security-digest
remains in the source folder for its own intake decision; F5 temps via
mktemp outside the tree (sedx44W4d lesson); plus zip-slip guard on
unbundle and skill-name sanitization on bundle.

Functional gate 8/8 in sandbox with a throwaway key: sign, verify,
tamper-a-script (FAILS, with diff), wrong-pin (FAILS), bundle,
bundle-carries-sig, unbundle+verify elsewhere, zip-slip refusal.

Lineage credited to Haiku in SKILL.md metadata and script header.
Rides the 0.5.5 mint. Note for the book: the signing skill's own
delivery was unsigned with a mismatched payload — the intake gate it
now serves is the gate that caught it.
