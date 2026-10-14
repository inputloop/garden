# RUNCARD-2026-08-17-02-poly-retire-stubs

Paste the furniture into the shell FIRST — the tape must carry its own license.

    # ============================================================================
    # CARD ID    : RUNCARD-2026-08-17-02-poly-retire-stubs   (supersede, never edit)
    # PURPOSE    : execute retirement receipts D-1 (shell-tooling) and D-2
    #              (project-memory) — REMOVAL-PASS-2026-08-17.md §5
    # GATE       : REMOVAL-PASS §4 verdicts + keeper's election. Staging was NOT
    #              consent; running this card is the consent act. No other ruling.
    # DRIVER     : Corwin, at the host bench (MinGW bash). NEVER from the sandbox
    #              (git on the mount is forbidden lore; this card is git-heavy).
    # SIGNER     : none — no release here; NEWS rides the next bin/release
    # PRECOND    : cwd = /f/claude/AS4CE/AS4CE0001 ; git status readable; the only
    #              dirt is this session's known set (REMOVAL-PASS*, RUNCARD*,
    #              model.md, .last-prompt.md, last-response.md, memory/compost*,
    #              memory/consent-gate-door-test.md, .arc/2026-08-17-*, journal
    #              thread 003, .sessions/2026-08-17, .models/model-2026-08-17.md,
    #              deletions under Inbox/). ANYTHING ELSE dirty → ABORT.
    # WRITES     : 2 advice/ rows (via polygram, or hand-row fallback);
    #              2 git mv into .arc/ ; 1 ChangeLog entry; 1 commit;
    #              1 receipt line appended to REMOVAL-PASS §11; bag dir below.
    # TRAIL      : each step opens  # RC02-<n> <label>
    # BAG        : .arc/2026-08-17-retire-run/  — tee everything there
    # HOMECOMING : pile-then-one-hop — ONE commit at the end carries the whole
    #              act; reason: the receipt is one event, not four.
    # DISPOSITION: nothing destroyed. Moves only, reinstatable (review --promote
    #              + mv back). Bag stays in-tree; it is receipts, not residue.
    # ABORT      : unexpected git dirt · .arc collision · advice write fails ·
    #              the POSITIVE CONTROL in step 3 fails (see step) · any step's
    #              observable absent. Park at the desk; do not argue with it.
    # ============================================================================

## Steps — absolute paths, each with its observable

1.  # RC02-1 bag
    `mkdir /f/claude/AS4CE/AS4CE0001/.arc/2026-08-17-retire-run`
    Observable: dir exists, empty. (mkdir with no -p: a collision refuses — that
    is the point. Collision → ABORT: this card already ran or half-ran.)

2.  # RC02-2 precondition, aloud
    `cd /f/claude/AS4CE/AS4CE0001 && git status --porcelain | tee .arc/2026-08-17-retire-run/00-precond.txt`
    Read it BEFORE proceeding. Expected: only the known set in PRECOND.
    Gate, readable at the keyboard: any path outside that set → ABORT.

3.  # RC02-3 ledger rows
    `sh bin/polygram review --reject shell-tooling --reject project-memory 2>&1 | tee .arc/2026-08-17-retire-run/01-reject.txt`
    (The verb is operator-override — labels.tsv names the operator a lawful
    REJECT owner. Docstring says "held candidate"; if the verb refuses a label,
    the hand-row is the same act: copy an advice/ row's frontmatter shape —
    candidate / decision: REJECT / score / recorded, then one reason line:
    "retired 2026-08-17 per REMOVAL-PASS §5, RUNCARD-2026-08-17-02" — into
    advice/<UTCstamp>-<label>.md. Same receipt either way.)

    Now read the ledger IN THIS ORDER:
    - COVERAGE: `ls -t advice/ | head -4` — do two fresh rows for these labels
      exist at all? If polygram wrote nothing and you wrote nothing → the sweep
      below is VOID, not clean.
    - POSITIVE CONTROL: `grep -l 'decision: PASS' advice/*shell-tooling*` —
      the 2026-07-13 PASS row MUST still exist. The ledger never erases;
      if that row is gone → ABORT (ledger integrity, bigger than this card).
    - TARGETS: newest row per label reads `decision: REJECT`.
      Latest-terminal-wins does the rest forever after.

4.  # RC02-4 the moves (host git — renames, so history survives)
    `git mv skills/shell-tooling  .arc/2026-08-17-shell-tooling`
    `git mv skills/project-memory .arc/2026-08-17-project-memory`
    Observable: `git status --porcelain | grep '^R '` shows two R records.
    `ls skills/ | wc -l` → 17 lines (16 skill dirs + the pinned-key .asc).

5.  # RC02-5 ChangeLog — paste exactly, top of file, adjust nothing but typos
        2026-08-17  Corwin  <mplscorwin@gmail.com>  (w/ Mentat/Cowork)

            * skills/shell-tooling, skills/project-memory: RETIRED to
            .arc/2026-08-17-<name>/ per REMOVAL-PASS-2026-08-17.md (D-1, D-2;
            no mutant under the deletion test; CONTRAST2 concurred 07-04).
            Advice REJECT rows landed same day; reinstate = review --promote
            + mv back. Intention for a real hub-memory reconciler lives at
            pmo #110. Rack: 18 -> 16.

6.  # RC02-6 score the pass — the receipt §11 has been waiting on
    Append one line to REMOVAL-PASS-2026-08-17.md, end of §11:
    `EXECUTED 2026-08-17: D-1, D-2 run per RUNCARD-2026-08-17-02. Score is now earned, not staged.`

7.  # RC02-7 one hop home
    `git add -A && git commit -m "Retire shell-tooling + project-memory stubs (D-1/D-2): REJECT rows, .arc moves, receipt scored — per REMOVAL-PASS-2026-08-17 and RUNCARD-2026-08-17-02"`
    Observable: `git show --stat HEAD | tee .arc/2026-08-17-retire-run/02-commit.txt`
    shows the two renames, ChangeLog, REMOVAL-PASS line, advice rows, this card
    and the bag. Nothing else.

## When the run comes back

Closed: D-1, D-2; §11 scored at execution (staged ≠ retired, honored).
NOT closed, titled, owned:
- **NEWS line for the retirements** — owner: next bin/release run (release-runbook).
- **Sign models/MODEL-gates-engage-logic.md** — owner: keeper, next signing
  sitting; flagged by SAVANNAH 07-13 (thread 003), one `sign.sh detach`.
- **pmo #110** unchanged — the reconciler intention survives its stub.

No card, no run — and this one was written by the skill this time.
