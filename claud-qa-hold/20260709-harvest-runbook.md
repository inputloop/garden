# Harvest runbook — curate + wear it, 2026-07-09 (pre-wire, pre-dark)

> Steps in ceremony order; commit messages ready to paste. Host shell for
> everything (never git the mount). Verify offers: after each signing step,
> tell Vibrobeast and it verifies from fresh bytes.

## Step 0 — placement check (SAVANNAH receipt, condition 1)

Confirm wire-mcp + WIRE-SECRETS.md live OUTSIDE every Cowork-mounted tree
(NOT under /f/claude or /f/SAVANNAH). A secrets file on a mounted path is
readable by any session — it breaks "the code never crosses the garden
boundary."

    python /path/to/wire_mcp.py --check   # names the exact secrets path

## Step 1 — re-mint the sandboxer manifest (one file stale)

The whole-tree manifest was signed before scripts/sig-fresh.sh.asc landed;
the tree now differs from the signed manifest. Re-mint:

    cd /f/claude/AS4CE/AS4CE0001
    sh skills/skill-sign/scripts/skill-sign.sh sign skills/sandboxer

(posix already verifies: "signature valid (pinned ECE77CF4…80F007)".)

## Step 2 — commits, host-side, in this order

### AS4CE0001 — three commits, story-shaped

    git add advice/ claud-qa-hold/ tests/fixtures/ && git add -u skills/
    git commit -m "Free All Hopefuls drill: Batch S verified, Batch D decided (#111 executed)

    All in-mount signatures verified GOOD vs pinned key; earlier BADs were
    stale sandbox reads. Stubs removed (handoff, posix, shell-tooling,
    reward-critique-blend; folds ride pmo #112-115); concise -> tests/fixtures.
    QA-3 stays gated. Signing idiom adopted: machine-parsed = detached or
    manifest, never clearsign. Advice trail + commit drafts at the desk."

    git add models/ .eclipse-increments/
    git commit -m "Alpha-C4-Wire2 campaign: ALPHA eclipse PASS, EP model minted

    8-stage keeper-signed campaign. models/c4/: contrast (P1-P5 offered
    upstream), c4-0.0.1-ALPHAv0.1.2, MODEL-right-to-execute (Execution
    Proposals: content+committer pins, scope, keeper counter-sign as grant),
    BUILD-CONTRAST (A local now, B ccspt on third consumer -> pmo #117),
    FINAL-SWEEP (baselines named; nothing in C4 may require an AI agent).
    Shelf amendments: readers-and-mounts reflex 8 (stale reader slanders
    good sigs), signing-ceremony (sigs attest bytes, not correctness);
    snapshots in models/.snapshots/. A2A v1.0 anchor dual-source verified.
    Lifted to Avalon stage + corwin/pub. Trail: .eclipse-increments/."

    git add skills/posix skills/sandboxer
    git commit -m "skills: posix authored for real; sandboxer enhanced

    posix: keeper draft finished out (trigger line: shell-as-deliverable
    fires, shell-as-medium never; house-idiom deference); tool.py = real
    advisory checker (bashisms-under-sh, transport smells, sh -n). Supersedes
    CONTRAST2 lexicon-only call; #114 stands as complement.
    sandboxer: description 1153->1018 (loads again; BAD-sig trigger added);
    scripts/sig-fresh.sh (freshen-then-verify; kills the six-times-by-hand
    copy-out loop). QA-11: rainbow-eval intake PASS (Bryant, pinned-key GOOD,
    credit kept), staged for keeper install."

### Avalon

    git add bin/lift.sh stage/
    git commit -m "lift.sh: remove dead blanket NO4C block; first ruled lift on record

    Old 'semantics provisional' park ran after the ruled RAISED/MENTIONED
    split, so MENTIONED files noted then parked anyway. Dead block removed;
    re-signed. Live-verified same day: MODEL-right-to-execute lifted with
    'NO4C mentioned (not raised) - lifting' + receipts. Patch record in
    stage/. MANIFEST regen rides pmo #116."

### pmo (if versioned)

    git commit -am "ledger: #111 DONE; add #112-#120 (folds, gate rule, EP wire
    thread, ccspt-bake trigger, percolation routes 3+4)"

### corwin (if versioned) + Vibrobeast-Meets-Claudewin

    corwin: "prompt: Alpha-C4-Wire2 rewrite (signed lineage in History);
             pub: +3 campaign models (signed); Inbox: 07-09 sv INTEL landed"
    V-M-C:  "wire: OUTBOUND-2026-07-09 draft staged (P6-P8, rainbow ack,
             EP teaser, dark-weeks notice)"

## Step 3 — wear it: bring the wire tools into session

The wire_* MCP tools are NOT visible in the current session. After
setup_wire.py + config edit: FULL app quit and reopen (a window refresh
isn't enough). Then, in order:
1. `wire_status` — no OTP, no network; shows config health + code
   fingerprint only.
2. First OTP call = `wire_ping` ("my code is NNNNNN" — fresh, ~90s window).
3. Then inbox + receipts + the OUTBOUND draft, ack-after-act.
Six wrong codes = growing cooldown (429); unpaired = 428 (pair via ?2fa=true).

## Step 4 — Bryant's incoming tools

As his signed drops land: candor-gate intake each (provenance vs his pinned
key 5D99…5DE7, opt-in, persistence, egress, routes), desk-stage, keeper
installs. Same road rainbow-eval just walked.
