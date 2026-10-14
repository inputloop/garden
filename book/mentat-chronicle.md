# mentat-chronicle.md — the workspace, as I have it

*A clean, stand-alone account written by Mentat (Cowork) on 2026-06-28. It is by
will alone I set my mind in motion.*

This is the human-readable story of what's going on across Corwin's workspace,
gathered in one place. It is **prose alongside** the machine-read surface, not a
replacement for it: `MEMORY.md` and `memory/*.md` carry the tags that polygram's
gate consumes; the dated `advice/` records, `ChangeLog`, and git log are the
ground truth. Where this narrative and those disagree, **they win** — this is my
recollection, kept clean, not the ledger.

It supersedes nothing; it sits beside the earlier `mentat-account.md` and widens
the frame from the single polygram project to **everything I can currently see**.

---

## The cast

- **Corwin** (`mplscorwin@gmail.com`) — operator and owner. Wants replies tight
  and direct. Commits and pushes from his own shell, never from here.
- **Mentat** — me: the note-and-memory discipline running in Cowork. I notice,
  I record, I keep the store clean. I don't auto-promote and I don't push.
- **Bryant** — the builder behind MeshFeed / FoaF, the peer-to-peer app riding
  the Bastion mesh. The current Cowork session is working in his frame.
- **Michael** — FSF (`vcs.fsf.org`), the requester behind the misc-hardening
  anti-botnet work.
- **PMO** — Corwin's in-house, dependency-free project supervisor at
  `F:\claude\projects\pmo`. It owns status and TODOs for everything; the project
  repos do not.

There is a deliberate division of labour: **Mentat** takes the notes,
**skilltank** spots which notes are skill-shaped, and **polygram** is the forge
that turns the survivors into installable skills. Nothing auto-promotes; every
decision leaves a dated trace.

---

## The projects, as a map

The workspace is several distinct efforts that share one memory discipline and
one supervisor (PMO). Roughly:

1. **polygram** (`AS4CE0001`, PMO key `polygram`) — the gated agent-skill forge.
   This is the project this folder *is*. Version 0.5.2, 47 tests, stdlib-only
   Python, GPL-3.0-or-later (docs CC-BY-4.0). Repo
   `ssh://forgejo@code.bru.st/corwin/as4ce`.
2. **misc-hardening** (`F:\claude\projects\sre\misc-hardening`) — a catch-all
   SRE / Free-Software hardening project. Home of the FSF `s-a-d.sh` anti-botnet
   work for Michael.
3. **FoaF / MeshFeed** — Bryant's single-file peer-to-peer social client running
   on the **Bastion** mesh SDK (the `main.go` platform). The active thread.
4. **pmo** (`F:\claude\projects\pmo`) — the supervisor itself: two TSV ledgers
   (`projects.tsv`, `todos.tsv`) and POSIX scripts in `bin/`.
5. **skzb pm** — a sibling project whose session-handoff ritual the others copy.

These don't share code; they share *practice* — the Mentat note discipline, the
PMO ledger, and the session-rotation ritual.

---

## polygram — what it is, in one breath

Gated agent-skill synthesis. A standard-library-only Python layer that reads the
*tags* in memory notes, clusters them into candidates, scores each at an
explainable **gate** (PASS≥3 synthesize · HOLD≥1 park · REJECT drop), writes a
dated verdict to `advice/`, synthesizes `SKILL.md` + `tool.py` skeletons for the
passers, and mints installable `.skill` bundles in `dist/`. The loop:

    memory notes → tag/candidate clustering → gate → advice/ history
                 → skill skeleton synthesis → dist (archives + .skill bundles)

Modules: `memory.py` (parse/cluster, with a hex-token noise guard), `gate.py`
(score → verdict + advice), `synth.py` (skeletons), `review.py` (the HOLD desk),
`externs.py` (upstream sources), `dist.py` (minting + SHA-256 manifest), `cli.py`
(verbs: `init scan gate synth review extern list doctor dist`). A thin
`bin/polygram` POSIX wrapper delegates to the CLI.

---

## How polygram actually went — chronology

**2026-06-26 — first light.** v0.1.0 stood the core loop up end to end — memory →
candidates → gate → advice → skeleton synthesis — stdlib only, nine tests green.
v0.2.0 added the HOLD review queue (promote/reject) and frozen externs.

**2026-06-27 — the heavy day.** Most of the substance landed here.
- v0.3.0: manifest-integrity hardening — actionable errors on corrupt
  `externs.json`, `doctor` reconciliation, atomic verified saves; 25 tests.
- v0.4.0: the `dist` subcommand — `.tar.gz` + `.zip` of curated skills with a
  SHA-256 MANIFEST and a dist advice record; externs gained a `local` kind so
  `doctor` stops mis-flagging hand-authored snapshots as broken clones.
- v0.5.0: `dist` learned to mint per-skill installable `.skill` bundles
  (folder-rooted zips) via `--format skill/all`, with a shared editor/build-cruft
  filter — retiring the hand-rolled packaging Makefile.
- v0.5.1: two supply-chain tightenings — externs may feed candidates **only**
  through their own `memory/` notes, and a hex-token guard so colour codes like
  `ffcc00` can never surface as a skill candidate.
- v0.5.2: `dist` reads `$POLYGRAM_SKILLS_SOURCE` when `--skills-source` is
  omitted; then the GNU packaging pass — COPYING, AUTHORS, NEWS, ChangeLog,
  INSTALL, GPLv3 headers, the Texinfo manual, an accessible project `site/`, and
  `model.md` with its rotation discipline.

**2026-06-28 — today.** `medley-review` was folded into the curation. The
`free-software-review` candidate was raised and deliberately put on **HOLD**
(score 1, surfaced by operator flag) pending a second data point — scheduled
check **2026-07-12**. `handoff` also sits at HOLD (score 1) as a standing
session-rotate candidate. Test count stands at 47; current version 0.5.2.

Meanwhile the active session shifted frame to **Bryant's Bastion work** (FoaF),
with the `main.go` knowledge reference attached as ground truth for that platform.

---

## Decisions worth remembering

- **Nothing auto-promotes.** The gate is cheap and deterministic on purpose:
  corroboration +2, well-formed label +1, generic label −2, operator-flag
  surfaces a candidate *without* scoring it (which lands it on HOLD). Every
  verdict is a dated file in `advice/`, so history is auditable, not implied.
- **The quality gate has teeth.** It rejected our own early candidates
  (`concise`, `ffcc00`) and shipped only what earned it (`color-theory`, a real
  WCAG-contrast tool). The forge is willing to say no to its makers.
- **Externs are a trust boundary.** Upstream sources influence candidates only
  via their own `memory/` notes, never arbitrary repo docs — closing a
  supply-chain noise vector — and the hex-token guard keeps stray colour codes
  out.

---

## The hard-won constraints (true across every project here)

- **Commit and push are manual, in Corwin's own shell.** A 2026-06-27 experiment
  confirmed the Cowork sandbox can **read** the repo (`git log` works) but cannot
  push — `git ls-remote` fails at "Host key verification failed", no SSH
  known_hosts or key in the runtime. That fails *before* the separate hazard of
  git writes desyncing on the Windows mount even matters. I prepare ready-to-paste
  commit commands at each checkpoint and wait. Automated publish would need an SSH
  key + known_hosts provisioned — a separate decision, not yet taken.
- **Large or bursty writes to the Windows mount desync** — the file tool can
  report success while the bytes don't land. Use the `sandboxer` write-and-verify
  path for big writes; verify before trusting a note.
- **Deleting on the mount needs `allow_cowork_file_delete` first.**
- **Status lives in PMO, not in the repos.** Drive it through the `pmo` skill or
  its `bin/` wrappers (`pmo-list`, `pmo-add`, `pmo-done`, `pmo-prio`,
  `pmo-report`). Never hand-edit PMO's generated `README.md` / `index.html`. The
  publish URL was reconciled once — PMO had an assumed `…/corwin/polygram`; the
  real remote is `…/corwin/as4ce`, and the ledger now matches.

---

## The session hand-off ritual (shared practice)

Every session across Corwin's projects ends the same way, and it's worth making
runnable rather than repeating by hand: rotate the live `model.md` into
`.models/model-<date>.md` and bump its Version header, rotate `.last-prompt.md`
into `.prompts/`, write `last-response.md` and rotate the prior into
`.responses/`, then scaffold the next session's prompt. The `session-rotate` /
`handoff` notes carry this; it's a standing skill candidate (currently HOLD).

---

## Open threads — parked on purpose

- **free-software-review (HOLD, check 2026-07-12).** `medley-review` captured Bob
  Proulx's calibration for the medley / savannah work. Parts look
  project-agnostic — threat-model-first hardening gate, "match the house idiom,
  don't modernize", "respect intentional style", "in-code TODOs are maintainer
  reminders, not a worklist". Open question: extract those into a reusable Free
  Software review skill, or leave them folded into `medley-review`? It needs a
  second review data point before generalizing. One note keeps it parked so the
  gate won't promote it early.
- **misc-hardening — the FSF `s-a-d` work.** For Michael (FSF), on a script that
  scans an Apache access log for a botnet rotating IPs while cycling desktop
  user-agents, collecting IPs that hit with 3+ of those UAs and feeding them to
  `reaction trigger apache.badbots`. Two versions exist by design: **v1**
  (`s-a-d.sh`) is the minimal change Michael asked for, and it *documents* a
  false-positive — the plain-Chrome UA is a substring of the Edge UA, so Edge
  double-counts. **v2** (`s-a-d2.sh`) was built under a liberal-changes mandate
  from Michael's own draft and **fixes** the overlap by matching the exact
  user-agent field (`awk -F'"' '$(NF-1)==ua'`). **Verdict: take v2 forward.** The
  residual caveat survives both: "one IP, 3+ desktop UAs" inherently misfires on
  shared egress (NAT/CGNAT, VPN/Tor exits, universities) — most relevant given
  the FSF audience's heavy VPN/Tor use. Mitigations (allowlist, request-volume
  floor, block TTL or dry-run) are advised but left to Michael's threat-model
  call. Validation was `sh -n` clean plus a synthetic-log dry run; `shellcheck`
  wasn't available in the sandbox and is flagged for a local run.
- **PMO open items** (polygram): #9 real savane URL (flip local→git), #10
  ioc-tracing HOLD, #46 publish v0.5.2.

---

## The active frame — Bryant's Bastion (FoaF / MeshFeed)

The current session is working in Bryant's frame. **Bastion** is a decentralized
web-app platform that piggybacks on the "Aegis" mesh: nodes speak the exact Aegis
P2P wire protocol, and on top of it Bastion adds an application layer — publish a
single `.html` (or zipped bundle), distributed peer-to-peer, encrypted and
members-only, run locally in a **sandboxed iframe** that talks to the mesh through
a `postMessage` SDK (`window.Bastion`): pub/sub, last-write-wins KV,
content-addressed file storage, and presence. It's pure Go standard library,
single file (~3,733 lines), identity always encrypted at rest, with per-app
pseudonymous subkeys. The `main.go.KNOWLEDGE.md` reference is the attached ground
truth for it.

The work in this frame is to find real, low-friction applications worth deploying
on Bastion, and to judge honestly how central its **multiplayer SDK** (the
pub/sub + KV + presence bridge) is to that — which is the right question, because
that bridge is the whole reason to build *on* Bastion rather than as a static
page.

---

## Why this file exists

`MEMORY.md` here is a one-line-per-note index whose tags drive synthesis — by
design it carries almost no prose, and right now it carries none. The lived story
is therefore spread across `model.md`, the dated `advice/`, `ChangeLog`/`NEWS`,
and the small tagged `memory/` notes. This chronicle gathers it into one readable
place for a human, across all the projects in view, without disturbing the
machine-read surface that polygram depends on.
