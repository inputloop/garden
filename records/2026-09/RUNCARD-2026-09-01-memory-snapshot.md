# RUN-CARD — memory snapshot tgz (2026-09-01)

**WHEN:** whenever you want a durable, off-mount backup of MAIN MEMORY — the belt-and-suspenders copy
the design calls for, and a stable dataset that doesn't depend on the fickle auto-memory mount.
**Read-only:** it tars and hashes; it changes nothing, deletes nothing.
**WHO runs it:** you, at your keyboard on Avalon (MinGW/bash). Review the commands, then run.

## DO (paste, review, run)
```sh
cd /f/claude/AS4CE/AS4CE0001
ts=2026-09-01
# the seat (holds the reseated union: its 32 + the 58 brought in = ~90 notes) + this session's artifacts
tar -czf memory-snapshot-$ts.tgz \
  memory/ MEMORY.md MANIFEST-MEMORY.tsv \
  making-vibrobeast-dot-md.md models/MODEL-memory-grow.md \
  C4-SPOILERS.md PERSONA-CORPUS.md SEATDIFF-2026-09-01.md RECAP-2026-09-01.md \
  ../../SEMAPHORES.md
sha256sum memory-snapshot-$ts.tgz | tee memory-snapshot-$ts.tgz.sha256
```

## CHECK
- `tar` lists ~90+ `memory/*.md` with no error; the `.sha256` prints one hash — keep it beside the tgz.
- **Two newest notes live only in the auto-memory (A), not yet reseated:** `heuristic-is-access.md`,
  `corwin-verbosity-signal.md`. For a *complete* A-side copy, also tar the reflex store (optional):
  ```sh
  # A lives under the packaged app root; adjust <id> to your spaces GUID:
  tar -czf auto-memory-$ts.tgz -C "$LOCALAPPDATA/Packages" \
    "$(ls -d "$LOCALAPPDATA"/Packages/Claude_*/LocalCache/Roaming/Claude/local-agent-mode-sessions/*/*/spaces/*/memory 2>/dev/null | head -1)"
  ```

## TELL-ME
The `sha256` (so I can pin it in `MANIFEST-MEMORY.tsv` as the snapshot receipt) and where you stashed
the tgz. No card, no run — and this card runs on *your* key, not mine.
