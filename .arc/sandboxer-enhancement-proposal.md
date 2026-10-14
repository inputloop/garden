# Sandboxer enhancement proposal

Source: polygram v0.3.0 session, 2026-06-27. Three things this session proved
that the current `sandboxer/SKILL.md` does not yet cover. Paste-ready; drop
into the skill via Settings → Capabilities (I can't modify the installed cache
from a session).

---

## 1. Description front-matter — add the small-file + import signals

The current `description:` says the hazard is *large* files and bursts. A
**10-line `__init__.py` version bump truncated** this session, and the bad
write was invisible to `cat` but caught by a fresh import. Add these triggers
so the skill fires on those cases too:

> … any time you need to know whether a write actually landed — **including
> small files once a desync episode has started, where even a one-line edit
> can land stale**. Verify by re-running the artifact (a fresh
> `python3 -B -c import`), not only by re-reading bytes, because a stale
> `.pyc` or a stale mount read can show the new content while the program
> still runs the old. Triggers on … **"cat shows new but it still runs old",
> "stale pyc", "the version didn't change".**

## 2. Correct the "small writes are fine" claim

The "When this skill applies" section currently says:

> It does **not** fire for ordinary small writes. Most memory notes and short
> files are fine through the normal file tool. This is for the big crossings.

Replace the qualifier — true in calm conditions, false mid-episode:

> Ordinary small writes are usually fine through the normal file tool — **but
> once a desync has been observed in a session, that immunity is gone: small
> files truncate too** (a one-line version bump did, this session). After you
> have seen *one* bad crossing, treat *every* write to that mount — large or
> small — as suspect until verified on disk.

## 3. New subsection — "Verify the running artifact, not just the bytes"

Add under "The independent verifier":

### Verify the running artifact, not just the bytes

Byte/line/sha checks prove the *file* is intact. They do **not** prove the
*program* sees it. Two stale layers sit between your write and execution:

- **Stale `.pyc`** — Python may run a cached bytecode compiled from the old
  source. Clear it and disable it for the check:
  `find . -name __pycache__ -type d -exec rm -rf {} +` then run with
  `python3 -B` (no bytecode cache).
- **Stale mount read** — right after a `cp`, the mount can hand the import
  machinery old bytes while `cat` already shows new ones. Seeing the two
  disagree *is* the desync, not a paradox.

So the final gate for code is a **fresh runtime check**, not a re-read:

```
python3 -B -c "import yourpkg; print(yourpkg.__version__)"   # or run the test suite
```

If `cat FILE` and the import disagree, the write has not truly settled —
re-`cp` from the `/tmp` staging copy and re-check until they agree.

## 4. Recovery recipe — rebuild SOURCE files in /tmp, then cp (no per-file restore)

The "Recovery from a truncation" steps already say rebuild the whole file in a
VM-local temp. This session is a clean worked example worth citing: when
`cli.py`, `externs.py`, and a test file all truncated mid-edit, the reliable
fix was to write each **complete** file to `/tmp`, `ast.parse` it there, `cp`
onto the mount, then verify with line count **+** `ast.parse` **+** fresh
import. Trying to re-apply the lost tail through Edit just re-truncated. Add a
one-line pointer: *for source files, parse the staged `/tmp` copy before `cp`,
and import the deployed copy after — the byte check alone misses a stale
runtime.*
