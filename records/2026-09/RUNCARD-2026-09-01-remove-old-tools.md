# RUN-CARD 2026-09-01 — remove the frozen old tool copies

WHY: `mainmem/` and `idea-additivity/` were homed to `c4/h/`; the sandbox could not delete the
originals under `AS4CE0001/tools/` (`rm: Operation not permitted` on the mount). You remove them by
hand. NO CARD NO RUN. Read top to bottom; stop if any PRECHECK fails.

## PRECHECK — the C4-homed copies exist and pass (never delete the only copy)
    ls /f/claude/c4/h/mainmem/mainmem.py /f/claude/c4/h/idea-additivity/idea-additivity.py
    ( cd /f/claude/c4/h/mainmem && python3 test-mainmem.py | tail -1 )                 # expect ALL PASS
    ( cd /f/claude/c4/h/idea-additivity && python3 test-idea-additivity.py | tail -1 ) # expect ALL PASS
Proceed ONLY if both files listed and both print ALL PASS.

## DO — remove the frozen originals
    rm -rf /f/claude/AS4CE/AS4CE0001/tools/mainmem
    rm -rf /f/claude/AS4CE/AS4CE0001/tools/idea-additivity
    # tools/MOVED.md is the tombstone; keep it, or remove too if you like:
    # rm /f/claude/AS4CE/AS4CE0001/tools/MOVED.md

## VERIFY
    ls /f/claude/AS4CE/AS4CE0001/tools/                 # expect: only MOVED.md (or empty)
    python3 /f/claude/c4/h/mainmem/mainmem.py where     # still resolves the seat (94 notes)

Done — the copies in `c4/h/` are the live ones.
