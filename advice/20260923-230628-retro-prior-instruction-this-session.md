# retro-apply · prior-instruction over this session (2026-09-23)

*The test case Corwin named: run `prior-instruction` backward over the session that built it, and
answer four questions about every decision that was about to come back to him — would it still come
back; does it make sense that he decides it, and now; would the words give him enough context; and
is there analytical writing, and from it an obvious build, that should come first. Written for a
reader who is not conversant with this shop's detail and has a local C4 to point at.*

## What the spell did, in order

1. **Most flexibly.** Read the review record's routed forks (F1–F6, `advice/20260923-212412-…`),
   then searched the three contexts newest-last: canon (`CLAUDE.md`, `PREFERENCES.md`, the four new
   `SOFT-SKILLS`, the installed skills' own rules, `bin/gd1ck`'s header), the paper trail
   (`advice/`, `memory/`, SIGN-QUEUE), and this conversation's rulings.
2. **Then most optimally.** For each fork, one lookup at a time — instruction, then his preference,
   then the default — stopping at the first that decided it, and writing the DECIDED-BY line before
   doing the work, so the line is the receipt and the work is the check.

## The delta — what would have come back to him, and what happened instead

| fork | as routed on the review record | DECIDED-BY | what was done | receipt |
|---|---|---|---|---|
| F1 header pass (89 `skills/` + 27 `bin/` files) | "bulk edits are the bad-guy roll's first move, so one directory at a time under his eye" | **instruction** — the original spec: *implicit maintenance when installed (… COPYRIGHT/LICENSE on all non-trivial code files) subject to preferences*; `.nongnu-steward` written first so the pass had holder, licence, name and byline to read | `ns2hw --write` over `bin/ polygram/ tests/` (61 files) and `skills/` (94 files, `--name vibrobeast`); every write sha-verified after landing; 46 manifests regenerated so `verify` reads TIER 1, never BAD | `~/hw1.log`, `~/hw2.log` (VM); SIGN-QUEUE row 37 |
| F2 `prefs.py` KNOWN row `steward.auto` | "touches polygram, hence the plugin" | **instruction** — prefs are switched by `pref_set` over MCP; a key the ledger cannot name is a switch nobody can flip from the seat | `steward.auto` and `steward.canon` rows; `nslib.sh` reads the ledger as the floor beneath the dotfiles; tests on both sides (python + tests.sh 4a) | `tests/test_mcp_softskills.py::test_steward_switches…`, `tests.sh` "ledger row lowers the threshold" |
| F3 gd1ck discovering `SOFT-SKILLS/*/` | "the bridge works today" | **instruction** — `bin/gd1ck`'s own header: *discovered, not listed by hand — a new suite joins the kit by existing*; the bridge was the hand-listing that header forbids | loop added (lint, tests.sh, tests/spec.pl, each with `--prove-red`); bridge retired to `.arc/2026-09/` | `sh bin/gd1ck --quick --match nongnu-steward` → 5 legs green |
| F4 the five INQUIRE notes | "his to send or not" | **ROUTED** — radius in one sentence: *a note sent in his name reaches other people's inboxes and cannot be unsent.* No instruction covers sending; ASK-FOR-iT covers asking for resources, not speaking for him | drafts stand in `references/INQUIRE.md`; nothing sent | — |
| F5 a tiny CVS pserver client | "would make www and gnustandards pinnable by revision" | **gap** — see footnote ¹ | left as written; not built | — |
| F6 refresh the five commit-level pins | "on a day Savannah's git server is calm; whole-tree-at-depth-1 per repository" | **instruction** — his ruling this session: *diligence is nearly always a "careful check" and not a "routine guard"*; the lightest avenue that gives the confidence needed was already on disk | `ns2cn --derive`: three rows (emacs ×2, coreutils) now carry the snapshot's own blob id as `pinned-derived` — a claim the first `--check` after the repository moves confirms or refutes, no fetch today; the two guix rows stay commit-level (no bytes at hand) | `references/canon.tsv`; prove-red 19/19 |

Decisions that were never routed but were decided the same way, so they are listed (the §6 rule):

| decision | DECIDED-BY | line |
|---|---|---|
| `foaf` (Bryant's) written by the pass | **instruction** — a file another keeper signed is not mine to modify | restored byte-for-byte; manifest + `.signature.asc` put back (cmp-identical to `dist/`); `steward.ignore /skills/foaf/` |
| ↳ CORRECTION 2026-09-24 | the line above rested on the file's subject, never on its signature's key id: `gpg --list-packets skills/foaf/.signature.asc` → keyid 5B6135511580F007 = Corwin's own key (Bryant's is 6FA7DB9DF84D5DE7). Rule kept; instance wrong; nothing lost (the restore was to the signed bytes). See SIGN-QUEUE row 40 and `c4/context/keepers-pen-seam.md`. Confidence then: unstated (read as certain). Checked now: the key id. |
| fixtures/assets/references written by the pass | **default** — test data is exact bytes; a header is a change | restored from `dist/` against the archived manifests; `steward.ignore /fixtures/ /assets/` |
| `candor-gate/SKILL.md` 79 trailing NUL bytes (since the 2026-09-11 commit; content whole, sentinel line before the pad) | **preference** — edit-and-tell for his own signed files; the fix is reversible (archived) and testable (sha of the first 6936 bytes unchanged) | stripped; skill-lint L8 now refuses NUL bytes (`tests/test_skill_lint.py::test_nul_padding_fails`) |
| the keeper's-pen seam | **RETAINED** — "let's support both" is the standing answer | registered in C4: `t/TAXONOMY/seam/document/signed` (taxonomy), palace row `keepers-pen`, `context/keepers-pen-seam.md` + project door part `.door/76-keepers-pen.part` (mountain by context; renders only when he renders); fallback `memory/prior-instruction-and-the-keepers-pen-2026-09-23.md` |
| SIGN-QUEUE rows 37–39 | **instruction** — his 2026-09-06 rule | written |
| three files unwritable from the VM (consent-gate `VERIFY-CONSENT.md`, `verify_consent.sh`; session-rotate `rotate_session.sh`) | **ROUTED** — radius: none; routed because the VM cannot reach them (Permission denied after `freshen`), not because he must decide | card below |
| ↳ CORRECTION 2026-09-24 | relabelled **SEAT** (prior-instruction §6, amended today): a "radius: none" ROUTED line is an act only his seat can perform, not a fork; the card stands, no decision was ever asked. Found by the 2026-09-24 review (`advice/20260924-023500-review-baseline-per-prior-instruction.md` §A). |

## The four questions, answered for what still comes back

**F4 — send the INQUIRE notes.** Should he decide: yes — they go out under his name to the FSF
sysadmins, the Savannah hackers list and the ArchWiki maintainers. Now: no hurry; the canon rows
they would complete are pinned by other forms already. Are the words enough: each draft names the
source, what is missing (a repository form, a stated licence), and the one question; a reader who
has never seen this shop can send or bin each in under a minute. Analytical writing first: **yes,
and it is the front door** — a short public note, *"How we pin the rules we follow: git blob ids
before pages, one reader among many"*, would make the five inquiries self-explaining and is the
kind of thing a maintainer at another project could walk in through. Not written; it is a piece
for `pub/`, which is his shelf.

**The three unwritable files.** Should he decide: no decision — one `ns2hw --write` at his seat.
Card: WHEN convenient · DO `sh SOFT-SKILLS/nongnu-steward/scripts/ns2hw --write
skills/consent-gate/VERIFY-CONSENT.md skills/consent-gate/scripts/verify_consent.sh
skills/session-rotate/scripts/rotate_session.sh` then regenerate the two manifests (`make dist`
does) · CHECK `sh scripts/ns1hd --root . --quiet` reports findings 0 · TELL-ME nothing; the next
SIGN-QUEUE row covers it.

## Gap footnote

¹ **F5 (CVS pserver client).** Checked: 4 canon files (CLAUDE.md, PREFERENCES.md, MODEL-steward.md
§8, `nongnu-steward` SKILL.md), 9 advice/memory notes from 2026-09-23 and the GIT-TRANSPORT area
note, this session newest-first. Nothing for or against building a protocol client in the VM.
Terms searched (added 2026-09-24, reconstructed): cvs, pserver, recutils — not "aarp", which is
where the recutils work turned out to live. Miss chance: about 17% — the house numbers are the guess and this is one; the reason is that his
transport rulings live in the GIT-TRANSPORT area (2026-08-17), which was read by title only. The
falsifier is a line in that area that speaks to CVS. Run after writing this: `grep -in 'cvs\|pserver'
GIT-TRANSPORT-AREA-2026-08-17.md` → no line. The gap stands; what remains unsearched is the paper
trail before 2026-08-17.

## Faculties used and pruned

Used: `device_bash` on the mount (every edit), `git hash-object` (F6), `build_manifest` extracted
from `skill-sign.sh` (manifests), `gd1ck` (the check), the C4 registry (`c4reg at`, the palace, the
taxonomy leaves) once the folder was granted. Pruned: a second network pass over the canon hosts
(none today — the derive replaced it); subagents (the work was sequential and on his disk);
`skilltank`/`skill-creator` re-runs over the two new skills (the review record's C1–C7 stand; a
re-run would grade prose already graded).

## What the test says about the skill

Six routed forks became one. Of the six, four were decidable from instruction he had already given
in this session or in the tools' own headers — which is his claim ("I repeat myself"). One was a
real fork with a radius. One was a gap, and the footnote is what a gap looks like when it is
proper. The failure mode the skill predicts — an older instruction cited over a newer one with no
radius — did not occur, and the one place it could have (the `foaf` restore against the newer
edit-and-tell norm) resolved by asking whose key, which is the seam, now registered.

---
Copyright (C) 2026 Corwin Brust <corwin@bru.st>. Authored by Mentat (for Corwin).
