# RECEIPT — character sheets, three copies reduced to one content

2026-09-16, Avalon. Written by the instrument; nothing here is signed and nothing was deleted.

## What was wrong

Each sheet existed in more than one place, and the copies had diverged:

| sheet | `h/persona/` (new, with §00) | `c4/h/` and seat `h/` (the old pair) |
|---|---|---|
| CHARACTER-2026-09-06-mentat.md | 24510 B `9abf02024418` | 17971 B `6614be0b04aa` (identical to each other) |
| CHARACTER-2026-09-05-shopgarden.md | 22193 B `714a93c7f628` | 16099 B `42854b32c492` (identical to each other) |
| PERSONA-gw7.md | 23583 B `d70a79b34af7` | 15123 B `b38e2924fd1a` (c4 only; no seat copy, as its §00 says) |

The fork was two-way, not three-way: `c4/h/` and the seat's `h/` agreed with each other and both
disagreed with `h/persona/`.

**Why this mattered more than a tidiness complaint.** Every sheet's §00 carries a "how you check me"
command, and every one of those commands names the *old* location:

    cd /f/claude/c4 && python3 h/cs1gk h/PERSONA-gw7.md --corpus …

So a stranger following the sheet's own instructions gauged the stale bytes. The sheets that had been
made standalone were not the sheets anyone would actually reach. The §00 headers, the standalone work,
and (today) the shelf and build-log corrections all lived in a copy the documented command never opened.

## What was done

1. The old bytes were copied here first — `c4-h/` and `seat-h/` in this directory. Nothing deleted.
2. The `h/persona/` version of each sheet was copied over both other locations.
3. All copies now carry one sha per sheet (the `persona` column above).

## The check, run where each sheet says to run it

    cd /f/claude/c4
    python3 h/cs1gk h/<sheet>.md --corpus /f/claude/AS4CE/AS4CE0001/PERSONA-CORPUS.md

    CHARACTER-2026-09-06-mentat        cs1gk: OK 17 · WARN 0 · FAULT 0 · NOTVISIBLE 0
    CHARACTER-2026-09-05-shopgarden    cs1gk: OK 17 · WARN 0 · FAULT 0 · NOTVISIBLE 0
    PERSONA-gw7                        cs1gk: OK 14 · WARN 3 · FAULT 0 · NOTVISIBLE 0

gw7's three WARNs are `G2` (guards not named), `G3` (one growth paragraph without both evidence and
story), `G9` (no break-character section) — the exact three gw7's own §00 declares as known. The day's
edits added no warning to any sheet.

## The fork that is NOT resolved, and is the keeper's

Three identical copies is better than three different ones, but it is not consolidation — it is
synchronised duplication, and it will drift again the first time someone edits one. Which home wins is
a decision with real costs either way and it is not mine to take:

- **`c4/h/` wins** — every §00 command, the TSV sidecars, the diagrams and the roll JSONs already live
  there; `h/persona/` becomes a view. Cost: the consolidated folder the keeper asked for stops being
  where the sheets are.
- **`h/persona/` wins** — the folder matches the request ("consolidate the great character development
  work"), and the sidecars move with the sheets. Cost: every §00 command, and the gauge's `--twin`
  wiring, must be rewritten, and the c4 tree loses files other c4 prose points at.

Until it is taken, the falsifier for "they are still in sync" is one line:

    for f in CHARACTER-2026-09-06-mentat CHARACTER-2026-09-05-shopgarden PERSONA-gw7; do \
      sha256sum /f/claude/AS4CE/AS4CE0001/h/persona/$f.md /f/claude/c4/h/$f.md 2>/dev/null; done \
      | awk '{print $1}' | sort -u | wc -l

Three sheets in two places: expect **3** distinct hashes. Any other number means a copy moved alone.
