# mentat-account.md — my version of events

*A standalone narrative companion to the machine-read `MEMORY.md`. Written by
Mentat (Cowork). It is by will alone I set my mind in motion.*

This file is for a human reader who wants the story in one place. It does not
drive any tooling — `MEMORY.md` and `memory/*.md` are the tag-bearing notes that
polygram's gate consumes; this is prose alongside them, not a replacement. If
the two ever disagree, the dated `advice/` records and `ChangeLog` win over my
recollection here.

Reconstructed 2026-06-28 from `model.md`, `ChangeLog`, `NEWS`, the `advice/`
history, the `memory/` notes, git log, and the sibling `misc-hardening` project.

## Cast and frame

- **Corwin** (`mplscorwin@gmail.com`) — operator and owner. Wants replies tight
  and direct. Commits and pushes from his own shell, not from here.
- **Mentat** — me, the note-and-memory discipline running in Cowork.
- **polygram** — the thing we are building: a gated agent-skill *forge*.
- **PMO** — Corwin's in-house, dependency-free project supervisor at
  `F:\claude\projects\pmo`. It owns status and TODOs; this repo does not.

There is a deliberate division of labour across the wider workspace: **Mentat**
takes the notes, **skilltank** spots which notes are skill-shaped, and
**polygram** is the forge that turns the survivors into installable skills.
Nothing auto-promotes; every decision leaves a dated trace.

## What polygram is, in one breath

Gated agent-skill synthesis. A standard-library-only Python layer that reads the
*tags* in memory notes, clusters them into candidates, scores each at an
explainable **gate** (PASS≥3 synthesize · HOLD≥1 park · REJECT drop), writes a
dated verdict to `advice/`, synthesizes SKILL.md + tool.py skeletons for the
passers, and mints installable `.skill` bundles in `dist/`. The pipeline:

    memory notes → tag/candidate clustering → gate → advice/ history
                 → skill skeleton synthesis → dist (archives + .skill bundles)

Modules: `memory.py` (parse/cluster, with a hex-token noise guard),
`gate.py` (score → verdict + advice), `synth.py` (skeletons), `review.py` (the
HOLD desk), `externs.py` (upstream sources), `dist.py` (minting + SHA-256
manifest), `cli.py` (verbs: `init scan gate synth review extern list doctor
dist`). A thin `bin/polygram` POSIX wrapper delegates to the CLI.

## How it actually went — chronology

**2026-06-26 — first light.** v0.1.0: the core loop stood up end to end —
memory → candidates → gate → advice → skeleton synthesis — stdlib only, nine
tests green. v0.2.0 the same span added the HOLD review queue (promote/reject)
and frozen externs.

**2026-06-27 — the heavy day.** Most of the project's substance landed here.
- v0.3.0: manifest-integrity hardening — actionable errors on corrupt
  `externs.json`, `doctor` reconciliation, atomic verified saves; 25 tests.
- v0.4.0: the `dist` subcommand arrives — `.tar.gz` + `.zip` of curated skills
  with a SHA-256 MANIFEST and a dist advice record; externs gained a `local`
  kind so `doctor` stops mis-flagging hand-authored snapshots as broken clones.
- v0.5.0: `dist` learned to mint per-skill installable `.skill` bundles
  (folder-rooted zips) via `--format skill/all`, with a shared editor/build-cruft
  filter — retiring the hand-rolled packaging Makefile. The real local skills
  were folded into `skills/` as the curation of record.
- v0.5.1: two supply-chain tightenings — externs may feed candidates **only**
  through their own `memory/` notes (not arbitrary repo docs), and a hex-token
  guard so colour codes like `ffcc00` can never surface as a skill candidate.
- v0.5.2: `dist` reads `$POLYGRAM_SKILLS_SOURCE` when `--skills-source` is
  omitted, so the common case needs no flag. Then the GNU packaging pass —
  COPYING, AUTHORS, NEWS, ChangeLog, INSTALL, GPLv3 headers, the Texinfo manual,
  README.org, an accessible project `site/`, and `model.md` with its rotation
  discipline. QC-gated throughout: **color-theory shipped; concise and ffcc00
  were rejected** by the quality gate.

**2026-06-28 — today.** medley-review was folded into the curation. The
`free-software-review` candidate was raised and deliberately put on **HOLD**
(score 1, surfaced by operator flag, well-formed label) — see below. Test count
stands at 47. Current version 0.5.2.

## Decisions worth remembering

- **Nothing auto-promotes.** The gate is cheap and deterministic on purpose:
  corroboration +2, well-formed label +1, generic label −2, operator-flag
  surfaces a candidate without scoring it (which lands it on HOLD). Every verdict
  is a dated file in `advice/`, so the history is auditable rather than implied.
- **Quality gate has teeth.** It rejected our own early candidates (`concise`,
  `ffcc00`) and shipped only what earned it (`color-theory`). The forge is
  willing to say no to its makers.
- **Externs are a trust boundary.** Upstream sources influence candidates only
  via their own `memory/` notes, never arbitrary docs — closing a supply-chain
  noise vector — and the hex-token guard keeps stray colour codes out.

## The publish constraint (don't forget this one)

The repo is `ssh://forgejo@code.bru.st/corwin/as4ce` (git remote `upstream`).
A 2026-06-27 experiment confirmed: the Cowork sandbox can **read** the repo
(`git log` works) but **cannot push** — `git ls-remote` fails at
"Host key verification failed", there being no SSH known_hosts or key in the
runtime. That fails *before* the separate, known hazard of git writes desyncing
on the Windows mount even matters. So the standing rule: **commit and push are
manual, in Corwin's own shell.** I prepare ready-to-paste commit commands at each
checkpoint and wait; I do not push. Automated publish would need an SSH key +
known_hosts provisioned in the runtime — a separate decision, not yet taken.

The publish URL was also reconciled once: PMO's `projects.tsv` had an assumed
`…/corwin/polygram`; the real remote is `…/corwin/as4ce`, and the ledger now
matches.

## Status lives in PMO, not here

This project's PMO key is `polygram`. Open items, priorities, and risk live in
the PMO ledger (`projects.tsv`, `todos.tsv`), driven through the `pmo` skill or
its `bin/` wrappers (`pmo-list polygram`, `pmo-add`, `pmo-done`, `pmo-prio`,
`pmo-report`). PMO's generated `README.md`/`index.html` are never hand-edited.

## Session hand-off ritual

Every session across Corwin's projects (skzb `pm`, polygram itself) ends the
same way, and it's worth runnable-izing rather than repeating by hand: rotate the
live `model.md` into `.models/model-<date>.md` and bump its Version header,
rotate `.last-prompt.md` into `.prompts/`, write `last-response.md` and rotate
the prior into `.responses/`, then scaffold the next session's prompt. The
`session-rotate` note carries this; it's a standing skill candidate.

## Open thread — parked on purpose

**free-software-review (HOLD).** `medley-review` captured Bob Proulx's
calibration for the medley / savannah-medley work. Parts of it look
project-agnostic — the threat-model-first hardening gate, "match the house idiom,
don't modernize", "respect intentional style", "in-code TODOs are maintainer
reminders, not a worklist". The open question is whether to extract those into a
reusable skill for reviewing *other* Free Software upstreams, or leave them
folded into medley-review. Deliberately not synthesized yet: it needs a second
review data point before generalizing. Scheduled check: **2026-07-12.** Until
then it stays HOLD by design — one note keeps it parked so the gate won't
promote it early.

## Sibling project — misc-hardening (the FSF s-a-d work)

Related work lives in `F:\claude\projects\sre\misc-hardening`, a catch-all SRE /
Free Software hardening project. There the requester is **Michael** (FSF,
`vcs.fsf.org`) and the work was on `s-a-d.sh` — a script that scans an Apache
access log for a botnet rotating IPs while cycling a set of desktop user-agents,
collects IPs that hit with 3+ of those UAs, and feeds them to
`reaction trigger apache.badbots`, archiving hits so already-blocked IPs are
skipped next run.

Two versions exist by design:
- **v1 (`s-a-d.sh`)** — the deliberately minimal change Michael asked for: pull
  the user-agent list out of the script into `user-agents.txt`, match with
  `grep -F` (literal strings), write per-UA `ua-NNN-ips.txt`, guard a missing
  list. Behaviour otherwise unchanged. It *documents* a false-positive: the
  plain-Chrome UA string is a substring of the Edge string, so Edge requests
  double-count toward the threshold.
- **v2 (`s-a-d2.sh`)** — built from Michael's own draft under a liberal-changes
  mandate, using his in-code TODO as the spec: validate the list has UAs, give
  each UA a unique descriptive filename (`slug()` → `c145win`, `e144win`, …), and
  **fix** the overlap by matching the *exact* user-agent field
  (`awk -F'"' '$(NF-1)==ua'`) instead of a line substring.

**Verdict recorded there: v2 is the one to take forward** — it fixes the
false-positive v1 only documented, is immune to the UA string appearing in
referer/request fields, and is easier to debug. v1 stays as the minimal
historical baseline. The residual caveat survives both: the "one IP, 3+ desktop
UAs" fingerprint inherently misfires on shared egress (NAT/CGNAT, VPN/Tor exits,
universities, libraries) and on long log windows where one person auto-updates
Chrome across majors — most relevant given the FSF audience's heavy VPN/Tor use.
Mitigations (allowlist, request-volume/time floor, block TTL or dry-run cycle)
are advised but left to Michael's threat-model call. Validation was `sh -n` clean
plus a synthetic-log dry run that proved the overlap fix and the empty-list
guard; `shellcheck` wasn't available in the sandbox and is flagged for a local
run. Full detail is in that project's `README.md`, `MODEL-s-a-d*.sh.md`, and
`*-ADVISORY.md`.

## Why this file exists

`MEMORY.md` here is a one-line-per-note index whose tags drive synthesis — by
design it carries almost no prose, and right now it carries none. The lived story
is therefore spread across `model.md`, the dated `advice/`, `ChangeLog`/`NEWS`,
and the small tagged `memory/` notes. This account gathers it into one readable
place for a human, without disturbing the machine-read surface that polygram
depends on.
