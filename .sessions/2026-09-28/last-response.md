# last response -- 2026-09-27 (night; rolled at 0.8.58, before his 0.8.90 build)

## The incantation
    make dist RELEASE=0.8.90 NOTE="why this build"
RELEASE names the version (greater than the current one). NOTE is new tonight: rl2bp writes it into
releases/0.8.90 as a `note` line, and after `rl2bp finish` the same note is offered to Mentat's seat
(seam polygram-releases) by polygram/mcp/seatnote.py -- through the seat's own store code, since a
shell cannot speak MCP and does not need to. It finds the seat the way the plugin's server does,
including C:\Users\corwi\.mentcached\seat as msys2 sees it ($USERPROFILE), never creates one, and
never stops the build. Check first, read-only: `python3 -m polygram.mcp.seatnote --where`.
Tests: tests/release-note-tests.sh (6 + prove-red); seatnote --prove-red (6).

## Polish toward 0.8.90 (each with a planted mutant caught)
- Secrets checkers: an unreadable FOLDER is named `UNREAD path/`; a FILE named .git is read (sb1aw
  used to skip it while sb1pl read it). cl1ck counts "not checked" apart from a SEAM.
- Seven garden scripts gained self-checks; they found and fixed a validator that left __pycache__
  beside files and a vocabulary check that matched substrings.
- consent-gate G2 parses dates without GNU `date -d`; seat_append names the missing field's reason.
- Two BAD detached signatures no longer ship (kept in .arc as the record).

## Rolled
- AS4CE0001 model.md v15 -> v16 (snapshot .models/model-2026-09-27.md; prior continuity files in
  .sessions/2026-09-27/). Version and Tests rows current; standing rulings of the evening folded in.
- C4 model.md 0.8.4 -> 0.8.5 (prior kept by `c4 archive keep`); prior continuity files in
  .sessions/2026-09-27/.
- Tagging: nine rows in c4/evidence/terms-of-art.tsv, all hand-turning.

## Gates at the roll (the gate pin)
- QA-3 (persona-withhold double-torture): PREPARED, GATED -- his go; unchanged.
- QA-10 (doubled-nine kit): RESOLVED, promoted on his word.
- Signing: 38 of 46 garden skills carry unsigned manifests; 8 verify as signed. His `make dist`
  (signed) re-signs; `bin/release 0.8.90` also signs dist/vibrobeast.plugin.

## Open, his
candor-gate CC-BY vs GPL · foaf's licence (Bryant's) · altorewired and token-optimizer fire-broadly
wording · example paths in the plugin (pb1ck's 224 rows) · NEWS says "Version 0.8.90 (unreleased)".

Full record: Inbox/HANDBACK-2026-09-27-lens-family.md, Inbox/HANDBACK-2026-09-27-hardening.md.
