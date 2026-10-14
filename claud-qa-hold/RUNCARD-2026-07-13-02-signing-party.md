-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

# RUN-CARD — the signing party (0.7.0 pre-flight) — **02, supersedes 01**

> **Card 01 is dead. Do not run it.** It named `scripts/skill-sign.sh` at the
> repo root; the tool actually lives at `skills/skill-sign/scripts/skill-sign.sh`.
> I wrote a paste-ready card without pasting it anywhere first — the card's own
> cardinal sin (*a card must be pasteable, not interpretable*), and the exact
> shape of S16: **a written step is not a proven step.** Every command below has
> now been resolved and run (all but the ones that need your key, which cannot be
> rehearsed here). Cards supersede, never edit — 01 stays as the record.

    # ============================================================================
    # CARD ID    : RUNCARD-2026-07-13-02-signing-party   (supersedes -01)
    # PURPOSE    : re-seal every artifact the instrument broke the seal on today
    # GATE       : the standing loop — instrument breaks seals to do the work,
    #              keeper signs (PLOT, 2026-07-08). No new authority is claimed.
    # DRIVER     : Corwin (keeper) — the only holder of the key
    # SIGNER     : Corwin, on Avalon (host). Keys never travel; the sandbox
    #              cannot sign and cannot push.
    # PRECOND    : host MSYS shell; gpg agent unlocked;
    #              cwd = /f/claude/AS4CE/AS4CE0001   (step 0 checks this)
    # WRITES     : *.asc signatures; four .skill-manifest re-mints; NEWS/VERSION
    #              (step 6, optional); one commit (step 7). Nothing else.
    # TRAIL      : each step opens with a label comment; shell history is the tape
    # HOMECOMING : one commit at the end; the push is yours, on your clock
    # DISPOSITION: nothing to destroy — no case data, no third-party data in scope
    # ABORT      : any BAD signature not explained as a stale artifact; any sha
    #              mismatch after a re-mint. Park it; do not argue with it.
    # ============================================================================

## Read-order

**Coverage.** This card covers only what the instrument changed in `AS4CE0001`
on 2026-07-12/13. It does **not** cover `/f/claude/projects/Avalon` (different
train; two rulings still open) and touches nothing in the enclave. Signing
something not on this list means the list is wrong or the tree is — stop.

**Positive control.** Step 0 proves the instrument sees before any verdict from
it is trusted, and proves the four trees that *should* be dirty are the only
dirty ones.

**Targets.** Steps 1–7, in order. Paste one line at a time if you like; nothing
below depends on a multi-line block surviving your terminal.

- ---

## Step 0 — positive control (prove the instrument, prove the scope)

    cd /f/claude/AS4CE/AS4CE0001
    gpg --verify models/MODEL-seams.md.asc models/MODEL-seams.md
    for t in seams sandboxer consent-gate skill-sign color-theory eclipse-pass ; do printf '%-14s ' "$t" ; sh skills/skill-sign/scripts/skill-sign.sh verify skills/$t/ 2>&1 | head -1 ; done

**Expected, and read it in this order:**

- - `MODEL-seams.md` → **Good signature** (untouched today). A BAD *here* means the
  checker is broken and nothing below can be trusted — **ABORT**.
- - `seams`, `sandboxer`, `consent-gate`, `skill-sign` → **TREE CHANGED**. That is
  correct: those are the four I edited. (Verified from the sandbox at
  2026-07-13.)
- - `color-theory`, `eclipse-pass` → **verify OK**. Untouched trees still good =
  the change is scoped to what the card claims.

If a tree you did *not* expect reports TREE CHANGED, stop and look before you
sign anything.

## Step 1 — seams: the release blocker (its `.asc` was stale)

You already ran `sign.sh detach skills/seams/SKILL.md` — that half is done. The
manifest still needs re-minting over the new bytes:

    sh skills/skill-sign/scripts/skill-sign.sh sign skills/seams/
    sh skills/skill-sign/scripts/skill-sign.sh verify skills/seams/

**Observable:** `verify` prints OK with every file accounted for (SKILL.md,
SKILL.md.asc, TEST-RECORD + its .asc).

## Step 2 — the three folded skill trees

Read the fold before you sign it; a signature is custody, not a rubber stamp.

    sh skills/skill-sign/scripts/skill-sign.sh sign skills/sandboxer/
    sh skills/skill-sign/scripts/skill-sign.sh sign skills/consent-gate/
    sh skills/skill-sign/scripts/skill-sign.sh sign skills/skill-sign/
    for t in sandboxer consent-gate skill-sign ; do sh skills/skill-sign/scripts/skill-sign.sh verify skills/$t/ ; done

**What changed:**

- - **sandboxer** — F1–F7 from the eclipse verdict: name the copier; mtime is
  never a mount tiebreaker; absence widened to directory churn; "fresh reader"
  defined (+ the checker-is-not-the-runtime line your `sh -n` episode earned);
  git scoped (object-reads only, index-touch never, **whose HEAD is it**);
  bash = trustworthy writer, suspect reader; triggers widened beyond file-tool
  edits.
- - **consent-gate** — the door opens too (strip-the-urgency; credential-class =
  value/scope/lifetime/audience) + NO4C raised/mentioned/carried.
- - **skill-sign** — signature form follows artifact class (detach runnables,
  clearsign prose) + the stale-sig corollary. *Note the recursion: skill-sign
  signs itself last, which is fine — the manifest is minted before the signature
  is taken.*

## Step 3 — the new tool (executable → detached)

    sign.sh detach bin/thread.sh

**Observable:** `bin/thread.sh.asc: written and verified`.
You already signed the page it renders (`site/threads/garden-tales-001.html`,
`0aa03c45…`) and proved it regenerates byte-true from this generator. Signing the
generator is what makes that property mean something.

## Step 4 — the day's prose (clearsign; records, not runnables)

    sign.sh models/MODEL-gates-engage-logic.md
    sign.sh journal/threads/garden-tales-001/001-SAVANNAH.md
    sign.sh journal/threads/garden-tales-001/002-VIBROBEAST.md
    sign.sh claud-qa-hold/QA-12-sign-queue-2026-07-13.md
    sign.sh claud-qa-hold/QA-13-release-0.7.0-plan.md
    sign.sh claud-qa-hold/RUNCARD-2026-07-13-02-signing-party.md

**MODEL-gates-engage-logic first, deliberately:** everything else cites it, and
an unsigned model that everything cites is a seam with no tiebreaker.

## Step 5 — the shelf gate

    sign.sh check-shelf

**Observable:** every governed file SIGN / NOSIG / FURNITURE per the signed
`.gate`, exit 0. Any BAD not explained as a stale artifact = **ABORT**.

## Step 6 — the bump (only if 0.7.0 is being cut now)

    $EDITOR NEWS
    bin/release --apply

`bin/release --apply` is the **one blessed path** — a hand-rolled wrapper once
silently skipped the MANIFEST. That lesson is paid for; don't buy it twice.

## Step 7 — the commit (host git only)

    git add -A
    git commit -F claud-qa-hold/COMMIT_MSG_0.7.0.txt
    git log -1 --stat

The message is already clearsigned by you; `git commit -F` takes it verbatim,
armor and all — if you'd rather the log stayed plain, strip the PGP envelope
first. Read the `--stat` back before you push.

## When the run comes back

Say what closed, what didn't, and what is still open **with an owner**:

- - **GUARDS / root-compromise audit** (QA-12 HORIZON) — our own pins are
  single-key and we know it. Post-trip, C4 lineage. *Owner: both shops.*
- - **Avalon rulings** — `drop.sh` scope, `movepack`'s home. *Owner: you.*
- - **MASKING-RULING tiers extract** — must come from the enclave, blessed.
  *Owner: SAVANNAH.*

sentinel: RUNCARD-2026-07-13-02-SIGNING-PARTY

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEE7Od89BfHbBrPznwrW2E1URWA8AcFAmpUhcUACgkQW2E1URWA
8AfmdQv/ZnDHIJFqPH6xw1mW/JfUVqWm20YCDZJDCaMFmutpwqTJZN6zayJwCbdx
ARxHHyPD2Wu3f54HJYJcwXTZFIK3Nb6yMRjnqsP23UIAwttLL+7lY62O90UXD0A6
GKa8h30qcaSw2jMur4M2anH84aRPO+zj7T6o5+5M9dDOHxSmGgSvdSxefo9EDf17
I7IVMFn2++/vyZ4oPpnzPU/TsxPPX2gZzy3w9x/kx3BabC1DYTdVBopJZ7a9l8BO
ki1e8WLM+yC2VwoHNQ0zv4dgFxDFt8H4aeWZHceA2jJAlaf0j3ezc8TtwduN+Evt
7We1yoTh1mNERY2es6pHgqIXVSdiJJS0CQzeYlfsvGSxoKyGgx1o6ngzvWNBu50a
hminr1wrczhVZjaQICoCJ/l1/F0V6n1C6hCAhN54p6yZBJQRvWYPZpx5pMU2B/hB
XKHADFqVgFTXAzTmGEUxcBoMDSJYAfbDQHbRX+2GQg+oMTXe89x2DlGoLc8w5taX
ErxVRpsv
=k8DR
-----END PGP SIGNATURE-----
