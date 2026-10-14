# 2026-09-14 — mint note: `skills/drawer-vs-door`

**Decision:** land a new skill at `skills/drawer-vs-door/SKILL.md`, hand-authored, unsigned.

**Who asked:** Corwin, 2026-09-14 — *"Install whatever you need to to make sure we do not hit this
again and I can install and review that as a single step when you perform the update."* Installed to
the account in one `save_skill` step; this repo copy is the curation of record.

## What "this" was

A recurring cost, not a one-off. `c4/bin` holds **56 detached signatures**, **44 of them sharing a
single batch timestamp (2026-08-08T14:10)**. Each generates a re-sign ask on every edit to its tool,
and none has a reader: `c4/bin` is not a boundary — `Avalon/bin/lift.sh` is the door and gates there,
and `c4/bin/externalize.sh` says in its own header that the drawer copy takes *"provenance in a
sidecar, no pen."* So the asks were paying nobody, and kept arriving.

His question was whether the answer is simply **never sign locally**. It is nearly that, and it is
already his written rule — *"dev tools sit in the drawer … it earns the pen at the ship boundary …
the resign cadence just equals the tool's own churn."* The practice had drifted from the rule; the
skill brings it back and makes the check reflexive rather than re-derived each time.

## Why a skill and not a tool, a fact, or a CLAUDE.md line

- Checked `signing-model` first (the canon skill for signing) — it owns **how** to sign (clearsign vs
  detached, what "signed" and "versioned" MEAN) and has nothing on **whether** to sign. Confirmed gap,
  not a duplicate. Also checked `shelf-check` (when the gate runs) and `verify-say` (the wording).
- Not a tool: the failure was a judgement made wrongly and repeatedly, not a computation nobody could
  perform. Adding tool #91 to a shop where the live problem is finding tool #57 would be the wrong
  move twice over.
- Not a `facts/` entry: facts record a decision; this needs to *fire* when a `.asc` reads BAD, which
  is what a skill description does.

## What it carries

The gate — **name the reader before proposing any signing work; no name, no ask** — plus three
dispositions (REMOVE / RE-SIGN / **FREEZE**, the third being archived copies where the BAD signature
*is* the record), the prohibition on keep-and-ignore (a softened guard is worse than an absent one),
the SIGNING SILENCE default, and the two canary legs any signature survey owes before its verdicts
mean anything.

## Unsigned, on purpose

By the skill's own gate: a skill in the curation of record earns its signature at **mint/dist**, where
an installer relies on it. That is Corwin's pen, at the door. Signing it here, in the drawer, would be
the exact error the skill was written to stop — and writing it that way was the cheapest available
test that the rule is livable.

## Receipts

- Population and per-file dispositions: `../../c4/evidence/SIGDISPOSITION-2026-09-14-drawer-vs-door.tsv`
- Underlying survey (2710 detached signatures, both canary legs green):
  `../../c4/evidence/SIGSWEEP-2026-09-13-full-estate.tsv`
- Measured cost of a door-class re-sign, same day: one command —
  `sign.sh verify FILE || sign.sh detach FILE`. The cadence was never the burden; unearned
  signatures were.

## Open, named rather than hidden

- `bin/secret-sweep.asc` is **HOLD**, not classified — it is the one drawer tool with a live external
  reader argument (a security gate), and a pending patch must edit it anyway. Decide with that patch.
- **[BLOCKED: bash]** — the sandbox shell has been down since the 2026-09-08 Windows update, so
  `sh bin/hb1ck --layout .` could not be run to confirm this landing against `INDEX.md`. The two homes
  used (`skills/`, `advice/`) are both documented rows in that map, and each was stated in chat before
  the write, per the map's own requirement. Run `hb1ck` when the shell returns.
