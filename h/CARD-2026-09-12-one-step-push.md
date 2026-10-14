# CARD — make `git push` one step (2026-09-12)

Everything below runs on **avalon**, in MSYS2, in `/f/claude/AS4CE/AS4CE0001`.
Nothing below can be done from the sandbox: `never run git against the mount`
(memory/git-fails-on-windows-mount), and the sandbox cannot push (no SSH trust
for code.bru.st) or delete a mounted file.

---

## 1 · WHEN: before anything else. Clear the lock I left.

**DO**

    cd /f/claude/AS4CE/AS4CE0001
    rm -f .git/index.lock

**CHECK** `ls .git/index.lock` prints "No such file".

**TELL-ME** nothing. But know why it is there: **I made it.** This session's first
`git status` created `.git/index.lock`, could not unlink it (the mount refuses
`rm` on a mounted file), warned once, and left it. Every later `git status` is
silent about it, so it is easy to miss — and it would have made your next
`git add` fail with "Unable to create '.git/index.lock': File exists". I asked
for delete permission to clear it myself; the request was refused by the
harness, not by you, so it is your hand. Written up with its falsifier in
`memory/sandbox-ephemeral-per-session.md`.

---

## 2 · WHEN: before you commit. One decision, and only one.

**26 untracked files name an individual `memory/sharing-policy.md` calls
check-first** (your 2026-06-29 rule: Bryant and Kelsey green, other real people
checked with you first). Thirteen of them are seat notes naming **Dee**; one names
**Monty**; the rest are Brigidt/Bridget/Skye mentions in `h/` and `memory/`.
`sh bin/gt1sp --check` prints the list.

Two facts that size the decision, both measured this session, not assumed:

- `code.bru.st/corwin/as4ce` is **private**. Anonymous GET returns 404 and the
  repo is absent from the public `/explore/repos` listing (which does show
  `corwin/vibrobeast`, so the listing works).
- Your own charter (`GIT-TRANSPORT-AREA-2026-08-17.md` A1) rules that a push to
  code.bru.st is **TRANSPORT, not publication**.

**DO** — one of:

- **(a) ship it all** — nothing extra to do; go to step 3. *This is what I'd pick:*
  the repo is private, the push is transport by your own ruling, and a
  half-tracked `memory/` leaves `MEMORY.md` linking to notes that are not there.
- **(b) hold the seat back** — keep `memory/` out of this commit entirely:

        printf '\n# 2026-09-12: seat held back from transport, keeper call.\nmemory/\n' >> .gitignore

  All-or-nothing on purpose; dropping the 26 files individually breaks the index.

**TELL-ME** which, if you pick (b) — I will re-cut the commit message, which
currently describes the seat as landing.

---

## 3 · WHEN: after 1 and 2. The single step.

**DO**

    sh bin/gt1sp

That is the whole thing: it runs the guards, prints the reports, shows you the
three plain-git commands it is about to run, asks once, then does
`git add -A`, `git commit -F h/PUSH-2026-09-12-commit-msg.txt`,
`git push upstream HEAD`, and appends a transport receipt to `h/TRANSPORT.log`.

Prefer to see it first and decide: `sh bin/gt1sp --check` changes nothing and
prints the same three commands for you to run by hand. Plain git is untouched —
`gt1sp` is a command you type on purpose, not an alias, hook or wrapper.

**CHECK** `git log --oneline -1` shows the new commit; `git status` is clean
except the paths `.gitignore` names; `tail -1 h/TRANSPORT.log` shows the push.

**TELL-ME** if a guard refuses and the reason is not one of the two it names.

---

## 4 · WHEN: whenever you feel like it. Not a blocker.

**21 detached `.asc` files are stale against their file** — edit-after-sign, the
benign cause, confirmed through `sig-fresh.sh` so it is not the stale-reader bug.
The list is in `sh bin/gt1sp --check` and in SIGN-QUEUE rows 34/35 plus the
two-tier note at the end of SIGN-QUEUE.md.

**The one ruling worth making**, because it is one sentence and it clears a
standing confusion: `skill-sign verify` reads **Good on all 44** garden skills
(the manifest tier is current), while **ten** `skills/*/SKILL.md.asc` read BAD
against their own `SKILL.md` (the older per-file tier is behind). A stranger who
checks the old way is told the wrong thing. Either re-run `sign.sh` over those
ten, or retire the per-file `.asc` convention through `aw2ri` and let the
manifest be the only signature. Either dissolves it; the split is the problem,
not which side wins.

---

## Also yours, found this session, no action forced

- `skills/ECE77CF417C76C1ACFCE7C2B5B6135511580F007.asc` — your pinned public key —
  had been **deleted from the working tree** by the 2026-09-11 garden sweep with
  **no archive beside it** anywhere on the two mounts; only git still had it.
  I restored it from HEAD (3817 bytes, byte-identical) and `make garden` still
  reads STRAY 0. Had the deletion been committed, the tree would ship signed
  bundles no reader could verify.
- `h/SEAL-2026-09-09-hypothesis-vibrobeast.sha256` says *"the plaintext is NOT on
  disk."* It was — in the untracked `Claude outputs/` spill. Copied beside its
  receipt as `h/SEALED-2026-09-09-hypothesis-vibrobeast-arm.md`; sha256
  `201fffdf7f37f1ae…` matches the seal exactly. The receipt is left as written;
  it was true when sealed and it is the record.
- The **c4actual arm's** sealed plaintext at
  `.arc/2026-09-09-sealed-hypothesis-c4actual-arm/…md.asc` is a **symmetrically
  encrypted PGP MESSAGE**, not a signature — passphrase-only. If you no longer
  have that passphrase, that arm's plaintext is gone. I did not attempt it.
