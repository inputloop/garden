---
name: sandboxer
description: Safe reads and writes on a mounted folder when the file tool and the disk desync. Write-side: an Edit/Write reports success but the bytes never land — use on a LARGE mounted file, a burst of edits, or any "did that write land?"; provides atomic write-and-verify. Read-side: bash serves stale/truncated bytes while the file tool sees the real disk — cross-read two independent paths, never "repair" off one reader; edited files read stale, new files read fresh; a BAD signature from one reader is usually the reader; a timeout does not undo a write; absence from one reader is not absence. Execute-side: a stale .pyc/.elc shadows fresh source, cured by clearing it or a /tmp copy; the freshen rename-dance (mv away+back) cures a stale node. Also: delete blocked on the mount, git-mount desync (restore via git show HEAD:path), stale index.lock. Triggers on "did that write land", "is this read stale", "file looks truncated", "BAD signature on a mount", "why can't I delete this", "stale pyc", "old code keeps running".
---

# Sandboxer — crossing the sand

The mounted folder is open sand. The file (Edit/Write) tool keeps a cached
view of it, and that cache can drift from the real disk: the tool reports
*updated successfully* while the bytes never arrive. A footstep that looks
planted but never landed. bash on the mount writes the *real* disk — so when
the file is large or the crossing matters, cross the sand here and verify
your own tracks. *Trust the disk, not the message.*

## When this skill applies

- Writing or editing a **large** file (HTML, code, a long document) on a
  **mounted** folder — the hazard scales with size.
- A **burst** of edits to one file in quick succession (a dozen rapid
  Edits to the same large mount file can trigger desync even with no other
  red flags).
- Any moment you need to know **"did that write actually land?"** — or a
  file looks truncated: shorter than expected, cut mid-line, missing its
  closing tag.

It does **not** fire for ordinary small writes. Most memory notes and short
files are fine through the normal file tool. This is for the big crossings.

## The hazard, briefly

The desync is not caused by one single thing. Backticks in the payload
raise the odds, but a backtick-free file truncated too — so "no backticks"
is *necessary, not sufficient*. Size and bursty edit volume are the larger
drivers. After a desync, file-tool writes apply to the **stale cache**, not
the disk, and keep reporting success. That is why the tool's own word can
never be the proof.

## The crossing (how to write safely)

1. Build the full content and write it to a **VM-local** temp file (e.g.
   under `/tmp`), where the flaky mount is out of the loop. A bash
   heredoc is fine; prefer string concatenation over backtick template
   literals in JS payloads to keep trigger odds low.
2. Copy it onto the mount target **atomically and verified**:

   ```
   python3 scripts/safe_write.py [--validate] /tmp/staged.html TARGET_ON_MOUNT
   ```

   `safe_write.py` writes via temp-file + `fsync` + atomic `os.replace`,
   then reopens the target and confirms its length and sha256 match the
   source. Exit 0 means *verified, byte-identical*. Anything else: the
   write did not land — do not trust it.

   **Verify before promote.** With `--validate`, the staged temp file is
   checked for *validity* — not just intactness — **before** the atomic
   move, so a broken file never replaces the good one. The check is
   language-aware (`scripts/validators.py`): `.el` byte-compiles, `.py`
   runs `py_compile`, `.html` must carry its closing tag. A missing
   toolchain (e.g. no emacs on the box) is a SKIP, never a block — the
   byte/structure checks still guard truncation. Exit 2 = staged file
   failed validation, target left untouched.

3. The file-tool cache is now **stale**. Before you touch this file with
   Edit/Write again, `Read` it to resync — or just keep editing through
   bash, which never lies about the disk.

## The independent verifier

When you only need to *check* a file (not write it), or want a second
opinion after any write:

```
python3 scripts/verify.py FILE [--validate] [--expect-lines N] [--expect-sha SHA]
```

It always prints byte count, line count, sha256, and the last 3 lines, and
runs structural checks by extension (HTML: is `</html>` present; JS/HTML:
are `{} () []` balanced). With `--validate` it also runs the language-aware
validity check (compile/parse), so "intact" is raised to "intact *and*
valid". A line count that *drops* after an additive edit is truncation until
proven otherwise. Use two or more of these signals together; no single check
is proof.

## Recovery from a truncation

1. Find the cut: `tail -3 FILE` and `wc -l FILE` against what you expected.
2. Rebuild the **whole** correct content in a VM-local temp file (don't try
   to patch the tail through the file tool — that is the path that failed).
3. `safe_write.py TEMP TARGET`, then `verify.py TARGET` to confirm the
   close-tags and counts are whole.

### When the mount is a git repo: trust HEAD, not your memory

If the truncated files are committed, the authoritative content already
lives in **git objects** — you don't have to reconstruct from memory, and
you have an exact reference to measure against. Two moves:

- **Cross-check first.** Compare disk against HEAD instead of "what you
  expected": `git show HEAD:path | wc -l` vs `wc -l path`, or
  `git cat-file -s HEAD:path` vs the on-disk byte count. A disk shorter
  than HEAD *is* the truncation, confirmed against an authority.
- **Restore from the object, not the index.** `git show HEAD:path > path`
  (equivalently `git cat-file -p HEAD:path > path`) writes the real disk
  through bash and **never touches the index** — so it works even when
  `git checkout` / `git restore` are blocked by a locked index (see below).
  Then `verify.py path` or re-compare to HEAD to confirm.

### Mass desync — one truncation is rarely alone

A desync isn't always one file. A single bad crossing can leave **every**
file you recently wrote short of HEAD at once. When you catch one truncation
on a git mount, **scan the whole working set** before declaring victory:

```
git diff --name-only HEAD | while read f; do
  printf '%s  disk=%s  head=%s\n' "$f" \
    "$(wc -l < "$f")" "$(git show "HEAD:$f" | wc -l)"
done
```

Any row where `disk < head` is a truncated file; restore each with
`git show HEAD:path > path`. One loop fixes the mass case; don't restore
just the file that happened to throw the error.

## Deleting on the mount

Writing is only half the crossing. **Deletion from the sandbox is blocked** —
`rm` on the mount returns *operation not permitted*, whether the file is held
by a running app on the user's side (a stale `.elc` still open in their Emacs)
or is plain cruft (`src/battle-board.el`). bash can't remove it and the file
tool can't either. This is not a desync you verify your way past — the disk
simply refuses the sandbox's hand. No amount of retrying changes the answer.

Two real paths to delete:

1. **Hand it to the user's shell.** They run `rm`, a sweep target like
   `make clean`, or `git rm` for tracked files. This is the default for build
   cruft and anything their own tools hold open.
2. **The Cowork delete tool** — `mcp__cowork__allow_cowork_file_delete` — when
   the delete should happen from this side rather than theirs.

Either way, **confirm the file is actually gone on disk** afterward (`ls`,
`test -e`) — same discipline as a write: trust the disk, not the message.

A stale artifact you *can't* delete has a second cost beyond the clutter: it
can **shadow** the fresh source you *did* write, so the runtime keeps loading
the old behavior and a good edit looks broken. That failure mode — and how to
get past it without the delete — has its own section below: *When fresh source
still runs old*.

### A locked `.git/index.lock` — same refusal, wider blast radius

The same *operation not permitted* shows up on `.git/index.lock`. A git
process on the user's Windows side (an editor's VC layer, a half-finished
commit) leaves the lock behind; the sandbox can't `rm` it, and while it sits
there **every** index-touching git command fails — `checkout`, `restore`,
`add`, `commit`. It looks like git is broken; it's just one file the disk
won't let go of.

Two moves, and they compose with the recovery above:

1. **Don't wait on the lock to recover.** Restores that read objects and
   write the worktree — `git show HEAD:path > path`, `git cat-file -p` —
   never take the index lock, so a truncation can be fixed *while the lock
   still sits there*. Reach for these before anything that stages.
2. **Hand the lock to the user.** Only they can remove it: delete
   `…\.git\index.lock` (Explorer or PowerShell `Remove-Item`) once no git
   operation is actively running. Then staging commands work again.

As always, **confirm on disk** — `test -e .git/index.lock` should fail, and
`git status` should run clean — before trusting that git is whole again.

## When the read itself is stale — the read-side desync

The write-side desync is the file tool trusting a stale cache when it *writes*.
Its quieter twin is on the **read**: bash on the mount hands you old or truncated
bytes while the disk — and the file tool reading it — hold the whole, current
file. Same lie as the write-side, but now it corrupts what you *see*, not what
you save. And it is more dangerous than it looks: a phantom truncation can bait a
**destructive "repair"** — you rebuild and overwrite a file that was never broken,
clobbering good content with your reconstruction.

The tell we caught it by: the mount's `stat` reported the **same mtime to the
nanosecond** across reads that straddled a real resave, and the byte count sat
frozen (3465, cut mid-word at `chal`, no trailing newline) while the file tool's
`Read` showed the line whole. The mount reader was stuck on a stale view.

**Cache-busting inside bash does not clear it.** `cp` to `/tmp`, `dd`, a fresh fd
— all returned the same short bytes. The stale view lives in the mount layer, so
every bash-side reader inherits it; copying just propagates the bad bytes. The
write-side habit of "read it back in bash to confirm" is therefore **no proof for
reads** — the confirming reader is stale too.

**The detector is a cross-read across two independent paths.** The mount (bash)
and the file tool reach the disk by different routes; when a read matters, take
both and compare. `verify.py FILE` prints the mount-side fingerprint — byte count,
line count, sha256, last 3 lines — and the `Read` tool shows the file-tool view.
If the tails or line counts disagree, one reader is stale. Trust the copy with the
**complete tail / newer mtime**; treat the frozen one as the lie.

**The safety rule — never repair off a single reader.** Before you rebuild,
re-distill, or overwrite anything because it *looks* truncated, confirm the cut on
the independent path first. A file that reads short on the mount but whole through
the file tool is **not** truncated — it is a stale read, and "fixing" it would
destroy the good disk copy. Measure on both paths; only the agreement is proof.
*Trust the disk — but first make sure you are actually reading it.*

## Reader trust rules — when the seam moves from bytes to operations

The desyncs above are about one file's bytes. Four rules cover the wider
pattern we keep meeting: which *reader* to trust after which *operation*.

**1. The freshness law: new files read fresh; edited files read stale.**
A file *created* this session reads correctly everywhere. A file *edited
through the file tool* this session may serve stale bytes to every bash
reader from then on (observed ×3 in one round, plus a signature sweep that
read BAD off stale bytes while a fresh-named host copy verified Good).
Rule: after a file-tool edit, bash is no longer a valid verifier for that
file — verify through the file tool, or copy to a *fresh name* and verify
the copy.

**2. Verification is a read too.** A sha or signature check runs over
whatever bytes its reader serves. Run over a stale read it yields false
BROKEN — and a false BROKEN can trigger a destructive "repair" or a panic
re-sign. Never declare a file broken off a single reader; confirm the
failure on the independent path first (same law as the phantom truncation,
applied to ceremony).

**3. Absence is a reading too.** Existence checks desync in both
directions: bash can list a file the file tool's Glob reports missing
(observed 2026-07-07 on a just-renamed file), and vice versa. "No files
found" from one reader plus a hit from the other = a stale search, not a
missing file. Treat absence like any other claim: two independent sources
agree, or it is data, not proof.

**4. A timeout does not undo a write.** A wedged tool call that times out
may already have landed its appends; re-running it blind doubles them.
Verify the target's state through a fresh reader BEFORE any retry. For
heavy scans that time out, split the work into smaller commands rather
than re-running the whole thing.

*Trust the disk — through the reader that can still see it.*

## When fresh source still runs old — the execute-side desync

The write-side desync is the file tool trusting a stale **cache** over the
disk. There's a mirror image on the **run** side: the disk holds your fresh
source, but the *runtime* loads a stale **compiled artifact** sitting next to
it and runs the old behavior. Same lie, opposite direction — and it reads as
"my edit isn't taking effect" or "the old code keeps running" even though the
source on disk is provably correct. *Trust the disk, not the message* applies
here too; the message this time is the runtime's, not the file tool's.

Two runtimes do this by default:

- **Python** imports `__pycache__/<mod>.cpython-XX.pyc`. It normally recompiles
  when the `.py` is newer, but that check rides on mtime — and a mounted
  Windows folder hands back unreliable timestamps, so the **stale `.pyc`** can
  win and your edit never runs.
- **Emacs** prefers `foo.elc` over `foo.el` whenever the `.elc` exists, and it
  does **not** auto-recompile. A stale `.elc` silently shadows the `.el` you
  just fixed.

Confirm it the way you confirm a truncation — measure, don't assume. Compare
timestamps (`ls -l mod.py __pycache__/`), or make the source unmistakably
different (add a print/banner, or raise on import) and watch whether the change
shows up. If it doesn't, an artifact is shadowing.

Two cures:

1. **Clear the stale artifact** so the runtime falls back to source and
   recompiles — delete the `.pyc` / `__pycache__`, the `.elc`, or run the
   project's `make clean`. But deletion on the mount is often **blocked** (see
   *Deleting on the mount* above) and the artifact may be held open by the
   user's running app, so this usually means handing the delete to the user.
2. **Run a copy off the mount.** When you can't delete the artifact, copy the
   source to a VM-local path and run it there:

   ```
   cp mod.py /tmp/mod.py && python3 /tmp/mod.py
   ```

   The `/tmp` copy has no stale neighbor and lives on a normal filesystem, so
   recompilation works again — the execute-side twin of *writing* through
   `/tmp` to dodge the flaky mount. Bring along any sibling modules the script
   imports. This is the fast path to prove the fresh source is correct without
   waiting on a blocked delete.

This skill's own `validators.py` already respects the trap: after byte-compiling
an `.el` to validate it, it deletes the `.elc` it just produced — so a
validation pass never leaves a fresh shadow behind.

## Relationship to Mentat

Sandboxer stands alone — its hazard is large or bursty writes, which are
usually big build tasks, not note-taking. It does **not** belong inside the
`mentat-skill`. The one genuine overlap is a *bulk* memory rewrite (many
notes rewritten at once): there, Mentat should **reference** Sandboxer for
the write-and-verify step rather than re-implement it. Reference when the
need is *occasional*; never merge what is only *sometimes* shared.

## Known bad weather — treat the first read as suspect

The rules above fire when an anomaly *shows*. Bad weather moves the line
earlier: once this session has seen **any** desync, or the user reports
changing files from their own side, every **first** bash read of a mount
path is suspect *before* anything looks wrong. A stale mount can serve a
whole directory old — a deleted `.git/` still listed, a resaved README at
its old byte count with a frozen mtime — and nothing in that read will
flag itself. (Observed 2026-07-02: bash showed `pub/.git` present and
README.md at 1735 bytes after the user's own shell had rm'd the one and
saved the other at 2080.)

Under bad weather:

1. **Cross-read before trusting any first read** of a mount path — bash
   fingerprint (`verify.py`) *and* file-tool Read — especially after the
   user says they touched files from their side. Don't wait for a tell.
2. **The user's shell is a third, authoritative reader.** When they paste
   `ls`/`rm`/editor output, weigh it above both sandbox paths; if either
   sandbox reader disagrees with it, the sandbox reader is the stale one.
3. **Frozen-to-the-nanosecond mtime across a known change is the tell**
   that confirms it — a real resave moves the clock.

Bad weather clears with the session, not with one good read: stay on
cross-reads for the remainder once weather is declared.
