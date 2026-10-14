# ENHANCE notes, 2026-10-04 — what the day's work taught the garden

produced-by: skilltank (by hand) · subject: the 2026-10-04 session (egad, Word Garden, ck1sk, 1.0.0) · 2026-10-04 UTC

Each note: what happened (with its receipt), the skill or tool it touches, the proposed change, and its falsifier.
Proposals, not edits, except where marked DONE.

1. **llama-bridge: a call longer than 60 s cannot come back through the desktop bridge.**  `delegate_task` on
   `gemma4:12b` and every call after it (status, stats) answered "Device 'avalon' did not respond within 60s" while a
   generation ran; `delegate_async` returned a job id once the bridge was free, and the job ran for many minutes.
   Touches: Bryant's `llama-bridge` skill (his; a note to send, via candor) and `token-optimizer` here.  Proposed: from
   Cowork, always `delegate_async`, then poll `delegate_result`; `warm_model` first.  Falsifier: a `delegate_task`
   over 60 s that returns.
2. **reformat-prompt, a prompt that spans two projects.**  The 2026-10-04 prompt was landed verbatim in both
   `egad/.house/q/` and `mini-c4-game/.house/q/`, same sha256, each with its own worked reading.  Touches:
   `reformat-prompt`.  Proposed: say so in "With or without C4" (one verbatim copy per project, sha printed).
3. **public-stage (NEW soft skill, DONE).**  The standard form for a new standalone project, from his message of
   the day; first used by egad and Word Garden.  `SOFT-SKILLS/public-stage/SKILL.md`.
4. **sandboxer: gpg on a mounted Windows folder fails** ("can't allocate lock", "No agent running").  egad's archive
   test kept GNUPGHOME in its tree; moved to the system temp dir (DONE in egad).  Touches: `sandboxer` (Fingerprints).
   Proposed: a fingerprint line.  Falsifier: gpg keygen succeeding with GNUPGHOME on the mount.
5. **Emacs in the device shell, and $EMACS.**  C4's `he2ma jammy27` lands Emacs 27.1 in the VM; two egad scripts
   called `emacs` directly and could not use it (fixed, DONE).  Touches: `posix-gotchas` or `emacs-tashaki`.
   Proposed: "a test that needs Emacs honours $EMACS".
6. **Emacs Lisp's case-fold-search.**  egad's two declarative-layer readers disagreed on their first run: the elisp
   one accepted `:Key:` because `string-match-p` folds case by default.  Touches: `posix-gotchas` (or an Emacs gotchas
   list).  Proposed: a line.  Falsifier: none needed; it is a documented default.
7. **prove-red, when a mutant survives.**  The first planted mutant in egad's organiser (moods shared by default)
   was not caught, because a mood is closed twice (a flag and a list).  Not a weak test: defence in depth.
   Touches: `prove-a-promise` / the prove-red discipline.  Proposed: "a surviving mutant: first ask whether a second
   guard covers it; if so, say so and plant one past both".
8. **pb1ck on a project with no C4 conventions.**  Run over `git archive HEAD` of egad, it read 27 hits, every one an
   intended example (the 10.2.42.0/24 example net, the author's address, a Windows path in firewall instructions).
   Touches: C4's `pb1ck`.  Proposed: `--examples FILE` so a project can declare its examples without a `.c4/` folder.
9. **A slow check that already passed (NEW tool, DONE).**  `bin/ck1sk`, wired into bin/release and gt1sp.
   Falsifier: a skipped check whose content had changed (its self-test plants exactly that).
10. **Word Garden found a broken rule in C4's own tables.**  `d/m/t`'s third head, COMMAND, sits in column 1 of `m/t`
    (rule 2).  The game's first move swaps COMMAND and COMPILE in row C.  Touches: C4 (a carry-in; founding tables do
    not change by routine).  Also GROW and ORBIT, table names filed nowhere (the drawers note, v0.2).
11. **gauntlet brought in (soft, DONE), with thanks to Bryant.**  `SOFT-SKILLS/gauntlet/` with `NOTICE.md`
    (provenance, licence, candor-gate's three holds left to the reader).  Next: the six siblings it names that this
    garden lacks (takushi, manifest, rosetta, mega-voltron, schedule, consolidate-memory).
12. **The desktop's Filesystem MCP server refuses to list its folders**: `list_allowed_directories` fails with
    "invalid outputSchema: JSON Schema declares an unsupported dialect (draft-07)".  Touches: the user's local
    Filesystem server (not ours).  Proposed: say so to him; the device shell covers what it was for.
13. **Push from a session needs a key the session can reach.**  "Your key should be setup" (2026-10-04): no `~/.ssh`
    in the device shell or the cloud container, none in the connected folders.  Touches: `public-stage` step 9 and
    `wire-connect`.  Proposed: a stated place for a session's push key (a connected folder, ignored by every repo) and
    a one-line probe (`git ls-remote ssh://...`) before any push step.

## 14. A push key needs three proofs, in this order
The key file itself (no passphrase: `ssh-keygen -y -P ''`). The host (`ssh-keyscan` then show the fingerprint to the
owner: the first contact is trust-on-first-use, not checked). The account (`ssh -T -o BatchMode=yes`; if this says
"Permission denied (publickey)", the key exists but isn't registered on the forge). Run all three before telling him
it's ready, and copy the key only into the shell's scratch home, outside every repo.

## 15. The local model through the bridge: one small job at a time
gemma4:12b ran over 10 minutes on a two-sentence request while Ollama reported itself up. Treat llama drafting as
background work: send one job, check on it between other steps, never wait on it. sn1dr.py's ingest is tested
against a scratch copy, so the drafts can land whenever they arrive.
