# RUN-CARD — the signing party (0.7.0 pre-flight)

    # ============================================================================
    # CARD ID    : RUNCARD-2026-07-13-01-signing-party
    # PURPOSE    : re-seal every artifact the instrument broke the seal on today,
    #              so the 0.7.0 tree is fully provenanced before the cut
    # GATE       : the standing loop — "I break seals as needed to do the work,
    #              Corwin signs (maybe grumbles)" (PLOT, 2026-07-08). Nothing here
    #              is a new authority; it is the second half of a paid-for trade.
    # DRIVER     : Corwin (keeper) — the only holder of the key
    # SIGNER     : Corwin, on Avalon (host). Keys never travel; the sandbox never
    #              signs and cannot push.
    # PRECOND    : you are on the HOST shell (MSYS), not in the sandbox;
    #              gpg agent unlocked; cwd = /f/claude/AS4CE/AS4CE0001
    # WRITES     : *.asc signatures; .skill-manifest re-mints; NEWS/VERSION (step 6);
    #              one git commit (step 7). Nothing else is touched.
    # TRAIL      : each step opens with a label comment; the shell history is the tape
    # BAG        : the tree itself; receipts are the .asc files + the commit
    # HOMECOMING : one commit at the end; push is yours, on your clock
    # DISPOSITION: nothing to destroy — no case data, no third-party data in scope
    # ABORT      : any BAD signature that is NOT explained as a stale artifact;
    #              any sha mismatch after a re-mint. Park it; do not argue with it.
    # ============================================================================

## Read-order for this card

**Coverage first:** this card covers *only* files the instrument changed on
2026-07-12/13 in `AS4CE0001` — the folds, the new skill, the new tool, the
journal, the desk notes. It does **not** cover `/f/claude/projects/Avalon`
(different train, two rulings still open) and does **not** cover anything in
the enclave. If you find yourself signing something not on this list, stop:
either the list is wrong or the tree is.

**Positive control second:** step 0 proves your instrument works before any
verdict from it is trusted. A verify sweep that reports "all good" from a
broken toolchain is silence, not innocence.

**Targets last:** steps 1–7.

---

## Step 0 — positive control (prove the instrument sees)

    # LABEL: signing-party step 0 — positive control
    cd /f/claude/AS4CE/AS4CE0001
    gpg --verify models/MODEL-seams.md.asc models/MODEL-seams.md

**Observable:** `Good signature ... ECE7 7CF4 ...`. That file is untouched
today, so a GOOD here means the checker is working. **A BAD here means stop —
the instrument is broken, and nothing below can be trusted.**

## Step 1 — the stale seams signature (the release blocker)

    # LABEL: step 1 — re-detach-sign seams SKILL.md (stale .asc, S12)
    sign.sh detach skills/seams/SKILL.md
    scripts/skill-sign.sh sign skills/seams/
    scripts/skill-sign.sh verify skills/seams/

**Why:** the existing `.asc` reads BAD over bytes that hash-match the signed
manifest — a stale signature artifact, not tampering. Re-sign, then re-mint the
whole-tree manifest so the two agree.
**Observable:** `verify` prints Good + every file accounted for.

## Step 2 — the folded skills (seals I broke; you re-seal)

    # LABEL: step 2 — re-sign the three folded skill trees
    scripts/skill-sign.sh sign skills/sandboxer/
    scripts/skill-sign.sh sign skills/consent-gate/
    scripts/skill-sign.sh sign skills/skill-sign/
    scripts/skill-sign.sh verify skills/sandboxer/ && \
    scripts/skill-sign.sh verify skills/consent-gate/ && \
    scripts/skill-sign.sh verify skills/skill-sign/

**What changed in each** (read before you sign — a signature is custody):
- `sandboxer` — F1–F7 from the eclipse verdict: name the copier; mtime is never
  a tiebreaker; absence widened to directory churn; "fresh reader" defined; git
  scoped (object-reads only, index-touch never, **whose HEAD is it**);
  writes-vs-reads asymmetry; triggers widened beyond file-tool edits.
- `consent-gate` — the door opens too (strip-the-urgency; credential-class =
  value/scope/lifetime/audience) + NO4C raised/mentioned/carried.
- `skill-sign` — signature form follows artifact class (detach runnables,
  clearsign prose) + the stale-sig corollary.

## Step 3 — the new tool

    # LABEL: step 3 — sign the thread renderer (executable → detached)
    sign.sh detach bin/thread.sh

**Observable:** `bin/thread.sh.asc: written and verified`.
**Note:** you already signed `site/threads/garden-tales-001.html`
(`0aa03c45…`) and proved it regenerates byte-true from this tool. That property
— *the signed page reproduces from the signed generator* — is the thing worth
keeping, and it is why the tool gets signed too.

## Step 4 — the day's prose (clearsign; these are records, not runnables)

    # LABEL: step 4 — clearsign the models, journal, and desk notes
    sign.sh models/MODEL-gates-engage-logic.md
    sign.sh journal/threads/garden-tales-001/001-SAVANNAH.md
    sign.sh journal/threads/garden-tales-001/002-VIBROBEAST.md
    sign.sh claud-qa-hold/QA-12-sign-queue-2026-07-13.md
    sign.sh claud-qa-hold/QA-13-release-0.7.0-plan.md
    sign.sh claud-qa-hold/RUNCARD-2026-07-13-01-signing-party.md

**MODEL-gates-engage-logic first, and deliberately:** it is the day's
load-bearing artifact and everything else cites it. An unsigned model that
everything cites is a seam with no tiebreaker.

## Step 5 — the shelf gate (fail-closed check, not a vibe)

    # LABEL: step 5 — prove the whole shelf still verifies
    sign.sh check-shelf

**Observable:** every governed file SIGN/NOSIG/FURNITURE per the signed `.gate`,
exit 0. **Any BAD that is not explained as a stale artifact = ABORT.**

## Step 6 — the release bump (only if you're cutting 0.7.0 tonight)

    # LABEL: step 6 — NEWS + VERSION, then the one blessed path
    $EDITOR NEWS                     # 0.7.0 stanza (draft below, in the commit msg)
    bin/release --apply              # the ONLY signing path; no hand-rolled wrapper

**Why the wrapper rule:** a hand-rolled signer once silently skipped the
MANIFEST. That lesson is already paid for; don't buy it twice.

## Step 7 — the commit (host git only — never from the sandbox)

    # LABEL: step 7 — commit on the host
    cd /f/claude/AS4CE/AS4CE0001
    git add -A
    git commit -F .git/COMMIT_MSG_0.7.0      # message staged for you; see below
    git log -1 --stat                        # read it back before you push

## When the run comes back

Read it all. Say what closed, what didn't, what is still open with an owner.
Open by design after this card: the **GUARDS/root-compromise audit** (QA-12
HORIZON — our own pins are single-key and we know it), the two **Avalon
rulings** (drop.sh scope, movepack's home), and the **MASKING-RULING tiers
extract** (must come from the enclave, blessed).

sentinel: RUNCARD-2026-07-13-01-SIGNING-PARTY
