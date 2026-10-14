# CARD — 2026-09-07, the bench, `skill`, and one drift worth your ruling

Leave-the-UI card. WHEN / DO / CHECK / TELL-ME. Harsh verdicts welcome.

---

## 1 · The three pages, newest first

    /f/claude/c4/site/bench.html                      NEW  the bench
    /f/claude/c4/site/project-browser.html            projects (full, local)
    /f/claude/c4/site/project-browser-shareable.html  projects (egress-cut)
    /f/claude/c4/site/memory-browser.html             memory

**WHEN** you want to move things around rather than read a list.
**DO** open `bench.html`. Place a set, drag some hunks, select two, press `g`, press `c`, press `f`.
Then **Arrangement…** — what you built is a tab-separated table with its column names on the header
line. Edit it, press **Load this arrangement**, and it comes back.
**CHECK** the round trip: export, load, export — the text should be byte-for-byte the same. If
anything got dropped it will say **PARTIAL** and name what it lost, rather than pretending.
**TELL ME** whether the bench, the two-phase browser, or neither is the answer to *"jumps around and
doesn't quite fit things to page well as I scale."* I guessed reflow; I am not sure I was right.

Rebuild any of them:

    cd /f/claude/c4
    sh bin/gh1wk --house
    sh bin/gh1wk --out /tmp/other.html 'notes=n/mn:NID:SUMMARY:STORE?seat=want!frame:memory notes'

---

## 2 · `skill` — poly reached by its own name

    sh /f/claude/c4/bin/skill              the forge (S implicitly poly)
    sh /f/claude/c4/bin/skill env          the calling environment + e/p
    sh /f/claude/c4/bin/skill list --forge everything we authored, with state
    sh /f/claude/c4/bin/skill NAME         one skill: agreement, sig, description
    sh /f/claude/c4/bin/skill NAME signed | md | test | enhance | where

**CHECK** `skill list --forge`. It reports 8 skills whose files differ from what you wear, 1 with
install furniture only, 3 authored-here-but-not-worn. Most differences are a trailing newline.
**TELL ME** if the furniture/divergence split is drawn in the wrong place — the tool treats
`.skill-manifest`, `SAYS-SO`, `check.sh` and `*.asc` as things the installer adds, not as tampering.

---

## 3 · SIGN-QUEUE #12 — sign now, per your own call

**WHEN** — you said the signing pair does not wait.

    cd /f/claude/AS4CE/AS4CE0001
    sh skills/skill-sign/scripts/skill-sign.sh sign   skills/skill-sign
    sh skills/skill-sign/scripts/skill-sign.sh verify skills/skill-sign

**WHAT CHANGED** — one typo in the description, `.skill bundlbe` → `.skill bundle`. Nothing else;
4297 → 4296 bytes, exactly one line. The forge copy is now byte-identical to the one you wear.
**WORTH KNOWING** — the typo was *signed in*. Canonical sha before (`3372b901…`) matched
`.skill-manifest` exactly, so `verify` was clean on SKILL.md and the typo rode under the signature.
**ALSO SWEPT UP** — the scripts under that skill had already drifted from their own manifest
(`SAYS-SO` and `check.sh` present but unlisted, `skill-sign.sh` changed, `tests.sh` new). Re-signing
clears all of it in one manifest.
**REVERT** — copy back `AS4CE0001/archive/2026-09-07-skill-sign-pre-typo-fix/` (all four artefacts).

**The other half of the pair is clean:** `corwin/pub/sign.sh` verifies **Good** against
`ECE7 7CF4 17C7 6C1A CFCE 7C2B 5B61 3551 1580 F007`, and `sign.sh check-shelf` → **SHELF: PASS n=14**.

---

## 4 · THE ONE THAT NEEDS YOUR RULING — attestation 3

Connecting `F:\claude\corwin` found `pub/corwin.txt` — the evolved pointer your own instructions told
me to ask about. Signed, **Good**, pinned fingerprint.

**It names three standing attestations. So do six other sources. Your Personal Instructions name two.**

| source | count |
|---|---|
| `SAVANNAH/CANON.md` · `SAVANNAH/PRINCIPLES.md` · the signed 07-09 landing delta | 3 |
| `corwin/PRINCIPLES.md` · `corwin/pub/PRINCIPLES.md` · `corwin/pub/corwin.txt` | 3 |
| the installed `principles` SKILL | 3 |
| **Personal Instructions loaded into a session** | **2** |

The loaded copy is the **only unsigned one**, and the only one that governs a running session. Stale
since **2026-07-09**.

> **3. No abandonment.** I do not give up on people, opportunities, or problems — I reach out. The
> cloister-crack made a covenant: people are lost not because an idea is unshareable but because
> they were never taught how to ask, and I will not let that be the ending.

**Why it is not just a count.** Your charge to the guard is to name *"specific risk **and** general
opportunity… Naming an opening matters as much as flagging a gotcha."* Attestation 3 **is** the
opportunity half. The one missing from the loaded copy is precisely the one that governs naming
openings rather than only hazards.

**DO** — update the Personal Instructions to three, with that line. Your text, your settings; I did
not touch it.
**FALSIFIER** — if two is deliberate for the runtime copy, this finding is wrong. Say so and I will
retract the note.

---

## 5 · Still open, and yours

- **Is `WORK` a sense of PROJECT you hold, or one I invented?** An instrument caught me shipping it;
  the question has never been put to you.
- **The fork you have not ruled:** should the ungated full build exist at all
  (`tool-not-claude-gates` ↔ `inward-his-outward-gated`, `c4/c/i`).
- **Literate fold-up by feature** — the big C4 README unpacking many RECIPEs. Raised twice by you,
  engaged zero times by me. Named so it stops being invisible.
- **`bin/w0rk` lines 104 and 118** — two real bugs in the card-dealing lane, left for you.
- **Are the three non-moving letters A, C and E?** My inference, flagged `[MINE]` in `c4/c/skill`.
- **`evidence/share-hold.tsv` has zero data rows** and `enforces.tsv` files its best-evidenced row as
  a candidate. Both named 05:00, both still yours.
