# RUN-CARD — pre-cut certification ("test yourself before you cut")

    # ============================================================================
    # CARD ID    : RUNCARD-2026-07-13-03-pre-cut-certification
    # PURPOSE    : answer ONE question — is this tree fit to become a release that
    #              a stranger will trust? Push ≠ cut. This card is the difference.
    # GATE       : keeper's own call (2026-07-13): "I feel like I should test
    #              myself before I do that." Correct, and this is that test.
    # DRIVER     : Corwin (keeper), on Avalon (host)
    # SIGNER     : Corwin — three skill trees still need his key (step 2)
    # PRECOND    : host MSYS shell; cwd = /f/claude/AS4CE/AS4CE0001; python3 on PATH
    # WRITES     : step 2 writes .skill-manifest + .signature.asc for 3 trees.
    #              Steps 0,1,3,4 write NOTHING — they only measure.
    # ABORT      : any test failure; any tree that cannot be made valid; any
    #              certification mismatch. A failed cert is not a formality —
    #              it is the release telling you it is not one.
    # ============================================================================

## Why you were right not to cut

**A push is a fact; a release is a claim.** Pushing says "here is the tree."
Cutting says "this is fit to use, and I stand behind it" — to strangers, under
your key, with a version number they will pin against. The first is reversible
by another commit. The second is a promise. Testing yourself between them is not
caution, it is the difference between the two acts.

And the honest reason it matters *tonight*: the writer of this tree is a machine
that was confidently wrong about a file path four hours ago and about the skill
count twenty minutes ago. **The instrument's own account of its work is not
evidence.** Run the tests.

## Step 0 — where the tree actually stands (measured, not asserted)

    cd /f/claude/AS4CE/AS4CE0001
    for d in skills/*/ ; do printf '%-16s ' "$(basename $d)" ; sh skills/skill-sign/scripts/skill-sign.sh verify "$d" 2>&1 | head -1 | cut -c1-46 ; done

**Measured from the sandbox, 2026-07-13, and stated so you can falsify it:**
**18** skill trees (not 14 — my release plan said 14 and was wrong; the count
includes trees I hadn't listed). **15 signed and valid.** **3 still need your
key: `consent-gate`, `sandboxer`, `skill-sign`** — exactly the three folds you
have not yet read. Your signing run stopped where card 01 broke; nothing else
drifted.

## Step 1 — the test kit (76 tests; the tree's own claim about itself)

    python3 -m pytest tests/ -q

**Observable:** all pass. **Any failure = ABORT the cut.** A red test is the tree
telling you the release is not one; there is no version number that makes a
failing test true.

## Step 2 — sign the three folds (read first; a signature is custody)

    sh skills/skill-sign/scripts/skill-sign.sh sign skills/sandboxer/
    sh skills/skill-sign/scripts/skill-sign.sh sign skills/consent-gate/
    sh skills/skill-sign/scripts/skill-sign.sh sign skills/skill-sign/
    for t in sandboxer consent-gate skill-sign ; do sh skills/skill-sign/scripts/skill-sign.sh verify skills/$t/ ; done

Then re-run **step 0**: the correct end state is **18/18 signature valid**.

## Step 3 — the certification sweep (the four-way agreement)

The claim a release makes is that four representations of one truth agree:
**installed == bundle == MANIFEST == repo.** One of them alone is data.

    sign.sh check-shelf
    sh skills/skill-sign/scripts/skill-sign.sh verify skills/seams/     # the new one, by name
    ls dist/*.skill | wc -l                                             # bundles present?

**Read in this order — coverage, control, targets:**

1. **Coverage:** does the sweep cover all 18 trees, or only the ones you
   remember? A sweep of 15 that reports "all good" is silence, not innocence.
2. **Control:** an untouched tree (e.g. `color-theory`) must verify — proof the
   checker can see.
3. **Targets:** the three folds + seams.

## Step 4 — only now, the cut

    $EDITOR NEWS         # 0.7.0 stanza
    bin/release --apply  # the one blessed path — never a hand-rolled wrapper

If the tests are green, 18/18 verify, and the shelf gate exits 0, the release is
a *measured* claim rather than a hopeful one. If any of those is red, the correct
outcome tonight is **no release, and a note saying why** — that is a good night's
work too, and it is the night you would want to have had.

## What this card deliberately does NOT do

It does not push, does not tag, and does not touch Avalon or the enclave. And it
does not ask you to trust my account of the tree: every claim above prints its
own evidence when you run it.

sentinel: RUNCARD-2026-07-13-03-PRE-CUT-CERTIFICATION
