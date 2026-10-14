# PLOT-UTIL.md — the toolshed, as the crew that reaches into it

> Companion to PLOT.md (the garden). Offered by SAVANNAH-side Claude
> 2026-07-08 at Corwin's ask, for use by Vibrobeast and the keeper; a view,
> not an authority — amend freely, keeper's sign = adoption. This file is
> NOT content-gated, so everything case-shaped is redacted or omitted on
> purpose: tools and method travel, cases don't. Docs license CC-BY-4.0.

## How to read this
One bench, several shelves, one law binding them: **every instrument is
small, readable, stdlib/POSIX, and leaves a receipt; provenance is a
detached signature against a pinned key; the keeper turns the screws that
matter.** When two tools could do a job, the HOUSE tool wins over the raw
one (gpg, git bare) — a tool's real behavior is a live-probe fact: read it
before you recommend it.

## Shelf 1 — provenance (the spine)
- **pub/sign.sh** (`/f/claude/corwin/pub/`) — the durable signer.
  `sign` = clearsign in place, PROSE ONLY (it now refuses shebangs and
  script extensions — that guard was paid for); `detach` = executables and
  anything machine-parsed or byte-pristine; `unsign` (keeps +x), `body`,
  `verify`, `manifest` (per-file sha rows → edit WHAT → sign the MANIFEST:
  that's how verbatim texts like COPYING get pinned without being touched),
  `vouch-key`, `export-key`. Key pinned by fingerprint; `$PUB_SIGN_KEY`
  overrides.
- **skill-sign** (scripts/skill-sign.sh) — per-skill manifests: signature
  covers EVERY file in the skill; verify pins the keeper's fingerprint.
- **sig-report.sh** (enclave bin; travels well) — read-only ceremony
  sweeper: GOOD / BROKEN / UNPINNED / UNSIGNED / ORPHAN vs a
  `.signing-authority/` pin dir. UNSIGNED is the absence-guard class.
  Known want: a DOUBLE class for stale-detached-over-valid-clearsign.
- **ccspt** — provenance publisher (AGPL): ingest/verify/publish over
  skill output; Sigstore path parked for a later DESIGN cycle.

## Shelf 2 — movement (stage, lift, promote, archive)
- **Avalon** (`/f/claude/projects/Avalon`) — the open-surface kit that
  stages enclave METHOD tools outward. `bin/lift.sh`: no sig no lift →
  path-lint → NO4C raise-semantics park (keeper lowers with -f) →
  sha-manifest + permanent receipt. `utils/mailmove.sh`: file-mail to a
  project Inbox with mbox notices per `.subscribers` (pin that file before
  it ever feeds anything that gates). GNU-style Makefile: check =
  lint + sig-verify; dist = tarball + sha.
- **archive-markdown.sh** — promote a SIGNED .md into place; the replaced
  file + its .asc retire to the archive root under a dated
  `_Archived-by-` name; collision = refuse; full transcript receipt every
  run. Cross-tree since 07-07; `ARCHIVE_ROOT`/`SIGN_SH` overridable.
- **path-lint.sh** — dialect gate: ceremony files speak `/f/` only;
  sandbox and AppData paths are poison in anything signed. No lint pass,
  no MANIFEST.

## Shelf 3 — the foundry (this chamber)
- **polygram** — gated skill synthesis: memory tags → candidates →
  explainable gate (PASS/HOLD/REJECT; REJECT is durable; HOLD is a reading
  room, not a pause button) → advice/ history → skeletons → dist mints
  .skill bundles. `labels.tsv` is the label registry ("no consumer, no
  label"); GRAMMARY.md its grammar.
- **bin/release** (release-runbook skill) — mint → gate → sign → tag →
  publish to Forgejo, HOST-ONLY (the sandbox cannot push); exists because
  a hand-rolled wrapper once silently skipped the MANIFEST.
- **gatefile.py / .gate** — sign-post consent files; nearest .gate up the
  tree governs; `embargo` gates egress and NO timer ever lifts it — a
  human edits the sign.
- **bin/freshen** — mount-cache cure (rename dance forces re-resolution);
  the fallback is a host-side reset, disclosed and substantiated.
- **session-rotate** — close ritual for model.md projects: archive last
  prompt/response, snapshot to .models/, bump version.
- **pmo** (`/f/claude/projects/pmo`) — the supervisor: two TSVs + POSIX
  bin/; regenerate reports host-side when the mount lies.

## Shelf 4 — observation & recall
- **patternwalk** — shell recorder: tape + hash-chain, detach-signed.
- **learn/** (`/f/claude/projects/learn`) — journal-first Learning Center
  slice: `bin/jot.sh hard|oops|yay|ohhh "note" [pointer]` into
  journal.tsv; `.lckb/` semaphore spec (INERT; an entry gates only if
  signed-or-two-source, else it is data); MANIFEST.expected = the
  what-SHOULD-exist sweep seed. Case facts stay out; pointers travel.
- **Mentat memory + LABTAIL/NOW + dated seals** — continuity is files:
  read the NOW block and the newest seal before deriving anything.

## Shelf 5 — adjacent instruments (other gardens)
- **Wire / parley** — dead-drop relay conversation loop with the peer
  garden; sensitive cargo never rides it; receipts = id + sha256.
- **llama-bridge** — local-model delegation (MCP + dashboard); egress to
  local models is still egress: candor-gate consent applies.
- **Gauntlet skills** (omni-tool, takushi et al.) — imported, gate-checked
  at the fence (candor-gate); an ethicsminions flag is a hard stop there.
- Case-gated suites (forensic tooling, fleet scripts, host deploy) exist
  and are deliberately NOT described here — enclave surfaces hold their
  own documentation. This is the redaction, named rather than hidden.

## The binding conventions (crew reflexes)
1. **Two sources or it's data** — never trust one reader (bash mounts go
   stale; file tools and a signature are independent witnesses).
2. **Detached sigs for anything that runs or is machine-parsed**;
   clearsign only prose; never both on one file (double ceremony reads
   BROKEN).
3. **Receipts over recollection** — every promote, lift, release, and
   archive appends a transcript; trust the disk, not the message.
4. **House tool over raw tool; live-probe over prior** — read the tool.
5. **Method travels, cases don't** — the manifest travels in-drop; the
   selection law decides what leaves a surface.
6. **Dropped turn ⇒ resend or check transcripts** — never make the keeper
   retype; a turn that died was never seen.
7. **Keeper-only screws** — sign, commit-from-host, consent semantics,
   installation. Batch them (PLOT.md pattern) so the price stays payable.

## Gotchas ledger (paid for, don't re-pay)
clearsign-on-executable buries the shebang and executes armor ·
`unsign` via mv used to drop +x (cat-over now) · MSYS perms lie (never
gate on -x alone) · gpg canonicalizes line endings (detached sigs go
stale across a clearsign round-trip) · a stray scratch file once baked
into a minted release (the 0.5.3→0.5.4 respin lesson) · a signing wrapper
once skipped the MANIFEST · the sandbox cannot push · state tables die,
event/history tables remember.

sentinel: PLOT-UTIL-00
