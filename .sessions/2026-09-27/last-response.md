# last response -- 2026-09-25 (session close, after 0.7.14)

## 0.8.50 is prepared, not cut
The run-card is c4/runcards/RUNCARD-2026-09-25-01-release-0.8.50.org, tangled to
release-0.8.50.card.sh. Its steps: 0 clear the two stale index.locks · 1 make dist RELEASE=0.8.50
(signed) · 2 the inline commit message + bin/gt1sp · 3 bin/release dry-run · 4 --apply +
verify_dist · 5 --push · 6 unset the token · 7 commit c4 (local) and pmo (pushed).
Rehearsed twice in the VM on a copy of the tree: steps 1-3 unsigned gave 0.7.14 -> 0.8.50 and a
clean commit, then all 7 gates ok (205 rows match; 12 rows from outside the repo). Signing, tag
and push can't be rehearsed there.

## Buffed while preparing (tests for each, with --prove-red)
- bin/release: a content gate replaces the "artifacts postdate HEAD" timestamp gate, which could
  never pass (make dist writes tracked files, so the clean-up commit always follows the mint).
  tests/release-gates-tests.sh.
- rl2bp start --to X.Y.Z, and make dist RELEASE=X.Y.Z.
- polygram dist moves stale bundles of retired skills to dist/.retired-bundles/.
- session-rotate: repeated rolls no longer clobber a snapshot or archived continuity files (found
  by rolling three times in a row); --no-bump for c4; the PARK message names it.
- Strays archived: __init__.py.tmp.5, gb1md-tests.sh.new (AS4CE0001/.arc/2026-09-25-stray/).

## Pins at close
- 0.8.50: the card is Corwin's to run on Avalon. Its STEP 1 signs every skill (including
  session-rotate, whose manifest changed again).
- Open holds: Bryant's persona model (consent line); beyondconventions (Dee and David).
- The writing ingestion was still syncing at last word.
- The rotation itself: AS4CE0001 v14 -> v15 (snapshot model-2026-09-25_193703.md); c4 --no-bump
  (its version is untouched; snapshot .models/model-2026-09-25.md). Earlier same-day archives
  intact.
