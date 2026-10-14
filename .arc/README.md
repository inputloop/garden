# .arc/ — mirror-tree archive

Dotted on purpose: polygram's `discover()` skips dot-dirs and `dist`
never stages them, so nothing here feeds candidate scans, mints, or
skill discovery. Convention: an item parks at its **original relative
path** (`.arc/<relpath>`); restore = move it back to that same path.
Every entry gets a dated line here. Nothing is deleted — this is the
"timidly tired of" shelf, not a trash can.

## Ledger

2026-07-02 — initial tidy (Corwin: "can we tide?"), moved by Mentat:

- `archive/` — old foundry snapshot (tgz + manifest, 2026-06-29); folded
  whole so one archive convention remains.
- `baseline-testing/` — stale test scaffold, superseded by tests/.
- `debug/2026-27-06-18-01` — one-off debug snapshot.
- `corwin-wget-hardway---chrome-C-s/` — saved Gemini share capture.
- `SESSION-2026-06-29-CLOSE.md` — session close note (rich on purpose;
  preserved, just off the root).
- `sandboxer-enhancement-proposal.md` — folded into the sandboxer skill.
- `scripts_init-git.sh` — one-off init script.
- (removed same day: the empty `.torture-increments/` husk and a
  mv-capability probe file — both empty/contentless, nothing lost.)

Same tidy, not in .arc: book/persona corpus → `book/` (visible, not
archived); `.torture-*` → `.eclipse-increments/`.

2026-09-24 — the door, retired (Corwin: "Move `AS4CE0001/CLAUDE.md` to `.arc/`"), moved by Mentat:

- `CLAUDE.md` + `CLAUDE.md.asc` — the instrument-comrade door (14 KB, last hand-edited
  2026-09-16), parked at its original relative path with the signature that covers it. Nothing
  renders a door here until the keeper renders one (`.door/` holds this project's parts; see
  INDEX.md). Restore = move both back to the root. Receipt: `sh bin/nd1ck` reads `door absent`.

2026-09-25 — two stub skills retired, carrying out receipts D-1 and D-2 of
REMOVAL-PASS-2026-08-17.md (staged then, never run); moved by Mentat at Corwin's word
to fix the skill issues while working in the skill project:

- `skills/shell-tooling/` — a polygram-synth stub ("Edit me"; its description asked to
  be tightened before anyone relied on it). The shell layer lives in `posix` and
  `posix-gotchas`. REJECT recorded in `advice/` so the gate stops re-passing it.
- `skills/project-memory/` — an "UNAUTHORED STUB — do not rely on it yet". The
  authoring intention lives at pmo #110. REJECT recorded in `advice/`.
- `2026-09-25-stray/x.tmp` — an empty probe file from a write test. Safe to delete.
- releases/0.8.51 -> .arc/releases/0.8.51 (see .arc/releases/README).
