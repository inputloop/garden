# QA-10 — skilltank re-mint (0.6.1 candidate) :CLAUD_QA_HOLD:

Date: 2026-07-05 · Prepared by: Mentat (ring-check/fill run) · Status: **CORE CLOSED 2026-07-05 14:00** — keeper signed all 13 trees in place (skill-sign whole-tree scheme); skilltank's signature now blesses the reading-room text, verified 13/13 valid 2/2 (bench + instrument via freshened mount). The unsigned candidate bundle below is SUPERSEDED by keeper-signed trees. Remaining: fold signed trees into the 0.6.1 aggregate mint + reinstall at next release ceremony.

## Finding

The signed 0.6.0 line attests the WRONG skilltank text. Three-way check:

| copy | sha256(SKILL.md) | text |
|---|---|---|
| installed cache | de95c153… | old (2026-06-29) |
| 0.6.0 MANIFEST + bundle | de95c153… | old (2026-06-29) |
| workspace disk (file-tool true) | == git HEAD | NEW (reading room, --max-frac/--top, Jaccard merge) |
| git HEAD | f04b7486… | NEW |

Root cause (evidence-backed): the 0.6.0 mint ran through the bash mount, which
served **stale bytes** for skills/skilltank/SKILL.md at mint time — the same
reader failure caught four ways on 2026-07-05 and again this run (gate.py served
truncated at 4494 bytes mid-`except`; disk and git both valid; 76/76 tests pass
from git HEAD in /tmp). Memory's "certification 13/13" was measured through the
lying reader; disk truth is 12/13 + skilltank stale-in-bundle.

## Prepared change (not landed)

`skilltank-0.6.1-candidate.skill` (this directory),
sha256 `082cec87615f7eda3e12d96f77491b1efeef316603994e015243f68130d9abd1`.
Minted 2026-07-05 from **git HEAD bytes** in /tmp (never the mount reader);
bundle-internal SKILL.md verified == git HEAD (f04b7486…).

## To land (keeper, blessed path only)

1. Verify candidate hash above.
2. `bin/release --apply` for a 0.6.1 mint+sign on your machine (mint from a
   git-clean tree, NOT through the Cowork mount).
3. Install the signed skilltank bundle; installed==bundle==MANIFEST==git re-certifies.

## Lesson to fold (skilltank/ethicsminions)

Certification sweeps must hash through a reader that cannot be stale (git
objects or file tool), never the bash mount. Candidate for a NOTE in
sandboxer references and the release runbook.

## Related, same run

- gated/core-ethics-pack-2026-06-29.tgz: **corrupt** (gzip CRC, confirmed 2/2:
  Corwin's MINGW + sandbox). Excluded from fill; hope for regrow from backup.
- model.md revision-history table truncated at v4 (dangling pipe) though header
  says v10; carried in snapshots since ≥07-02. Cosmetic; fix at next rotation.
