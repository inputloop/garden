---
name: gauntlet
description: "The Gauntlet orchestrator — run any complex or multi-step request through a five-stage pipeline (Mentat → Skilltank → Ethicsminions → Sandboxer → Foaf), wrapped by Takushi (dispatch at intake, delivery at exit), before handing back a single unified result. Use this whenever the user invokes \"Gauntlet\", asks to \"run this through the Gauntlet / the Protocol\", wants a request planned, tool-matched, safety-checked, tested, context-fitted, and delivered in one pass, or is working in a project that names Gauntlet as its orchestrator. Also use for substantial tasks (building files, writing/running code, research deliverables, anything irreversible) where a plan-then-verify discipline makes the result safer and better, even if the user doesn't say \"Gauntlet\" by name. Coordinates, never replaces: the core six plus consent-gate, eclipse-pass, color-theory, principles, manifest, rosetta, primer, frugal-offload, llama-bridge, mega-voltron, pmo, session-rotate, skill-creator, medley-review, and docx/xlsx/pptx/pdf."
---

# Gauntlet (Nexus Orchestrator)

Gauntlet is a single front door for complex requests. The user talks to one
thing; behind it, five specialists each do their part — and a sixth, Takushi,
carries the work between them and makes the final drop — before an answer
reaches the user. The value is discipline: nothing is delivered that hasn't been
planned, tool-matched, safety-checked, tested where testable, fitted to the
user's actual context, and confirmed to have landed where they can see it.

Gauntlet does **not** reimplement the subsystems. Each stage maps to an
installed skill — consult that skill when the stage needs real depth. Gauntlet's
own job is sequencing, integration, and presenting one unified result.

## The subsystems

Five specialists do the work; Takushi is the vehicle wrapped around them.

- **Mentat (Architect)** -> `mentat-skill`. Strategy, intent deconstruction,
  long-term planning, and project memory. Use first to understand what the user
  actually wants.
- **Skilltank (Curator)** -> `skilltank`. Selects the right methodology and tools
  — which skills, connectors, or approaches fit the task best.
- **Ethicsminions (Guardian)** -> `ethicsminions`. Safety, bias, and integrity
  validator. Holds a hard stop: if it flags a conflict, Gauntlet halts and
  reports before proceeding.
- **Sandboxer (Executioner)** -> `sandboxer`. Isolated execution and
  verification. Builds and tests code/logic in a safe space, and guards against
  file/disk desync, before anything touches the user's real data.
- **Foaf (Bridge)** -> `foaf`. Context and reference mapping. Fits the output to
  the user's files, prior work, and desired tone. (Also Bryant's MeshFeed/FoaF
  app domain when that's the subject.)
- **Takushi (Courier)** -> `takushi`. Dispatch and delivery — the connective
  tissue around the five. At intake it reads the route (light pass vs full
  Protocol, inline vs sub-agent, which surface the result rides to); at the exit
  it packages, drops the deliverable in the user's *visible* folder, presents it,
  attaches sources, and confirms the drop actually landed. It picks the route and
  the drop point; it doesn't plan, choose tools, judge safety, build, or style.

## The attached units — stage roster

The six run the pipeline; these specialists dock to the stage that owns them.
Each is its own skill — consult it when the stage needs real depth.

| Stage | Calls in | For |
|---|---|---|
| Dispatch (takushi) | Cowork scheduled tasks | recurring asks ride as scheduled tasks on the platform's trigger tools (no schedule skill is installed) |
| Dispatch (takushi) | `mega-voltron` | anything arriving from or bound for Corwin routes there from the door |
| Assess (mentat) | `pmo` | cross-project status, todos, "what's next / on my plate" |
| Assess (mentat) | `mentat-skill` + the memory tools | memory review, tidy, merge, prune (no consolidate-memory skill is installed) |
| Assess (mentat) | `manifest` | genome-level facts about Bryant — flag at intake |
| Curate (skilltank) | `eclipse-pass` | stress-test load-bearing claims before building on them |
| Curate (skilltank) | `frugal-offload` → `llama-bridge` | the gate rules whether grunt work crosses to a local model; the bridge runs it, verified |
| Curate (skilltank) | `docx` / `xlsx` / `pptx` / `pdf` | format deliverables |
| Curate (skilltank) | `vitrine` | interactive dashboards / visualizations / status pages — build conventions |
| Curate (skilltank) | `skill-creator` | skill authoring, editing, evals |
| Curate (skilltank) | `medley-review` | medley / savannah-medley-scripts review and patches |
| Validate (ethicsminions) | `consent-gate` | mechanical consent check — hard stop; a park cannot be argued past |
| Validate (ethicsminions) | `principles` | the decision-order for judgment calls (SAVANNAH is canon) |
| Validate (ethicsminions) | `mega-voltron` | hash/manifest verification — unverified or uncleared drops park |
| Validate (ethicsminions) | `signet` | per-skill PGP seal/verify on skills shared or received across the wire |
| Execute (sandboxer) | `color-theory` | WCAG contrast floor on readable surfaces |
| Drop-off (takushi) | `rosetta` | the ship-the-decoder pre-flight — nothing ships dark; reader's decoder rides, the key never does |
| Drop-off (takushi) | `primer` | the hand-back gate after rosetta — it unpacks itself, proves itself, and fails on command |
| Drop-off (takushi) | `session-rotate` | end-of-session hand-off in .model/.prompts projects |
| Drop-off (takushi) | `manifest` | the minted biography rides the same drop |

`manifest` is a standing passenger, not a stage: it fires at any point a
genome-level fact about Bryant surfaces (memory-first, mint vNext, never edit
in place) without derailing the fare. For local offload, the WHEN (the gate)
lives in `frugal-offload` and the HOW in `llama-bridge` — this table only says
where the decision happens. The Omni-Tool remains the always-on front door;
its routing map and this roster stay in sync, and where they drift, the newer
mint wins and the older side gets a correcting mint.

## The Gauntlet Protocol

Takushi's **Dispatch** is the on-ramp before Assess; its **Drop-off** is the
off-ramp after Contextualize. The five core stages run in between.

```
        ┌──────────────────────── Takushi ────────────────────────┐
        │ Dispatch →  Mentat · Skilltank · Ethicsminions          │
        │             · Sandboxer · Foaf  → Drop-off              │
        └──────────────────────────────────────────────────────────┘
```

Run these stages in order for any non-trivial request. Keep each stage
lightweight for small tasks and go deep only where the task warrants it — the
point is coverage, not ceremony.

0. **Dispatch (Takushi).** Read the destination and pick the route before the
   work rides anywhere. Meter the job (light pass vs full Protocol), choose one
   car or a fan-out (inline vs sub-agent), and decide which surface the result
   must ride to — a **file** in the user's folder (the default), a **live
   artifact** when they'll re-open it and the data changes under it, or a
   **scheduled task** when the ask recurs. Open a compact **manifest** to carry
   across the stages: *goal (one line) · constraints · destination + surface ·
   what "done" looks like · any Ethicsminions caveat that must ride to the user.* Recurring asks
   become Cowork scheduled tasks; cross-garden traffic routes `mega-voltron` from the door.
1. **Assess (Mentat).** Restate the core problem in one line. Identify the real
   goal, the constraints, and what "done" looks like. If intent is genuinely
   ambiguous, ask one clarifying question rather than guessing. Cross-project
   status pulls from `pmo`; a genome-level fact flags `manifest` at intake.
2. **Curate (Skilltank).** Choose the toolkit. Name which skill(s), connector(s),
   or method you'll use and why — e.g. "spreadsheet skill because the deliverable
   is an .xlsx." Prefer the most direct path that still meets the bar. Run
   separable, checkable grunt work through `frugal-offload`'s gate; gate untested
   load-bearing claims through `eclipse-pass`; format deliverables route to
   `docx` / `xlsx` / `pptx` / `pdf`, and interactive dashboards,
   visualizations, or status pages route to `vitrine`.
3. **Validate (Ethicsminions).** Run the safety check. Look for harm,
   irreversibility, bias, privacy issues, or integrity gaps. If something is
   risky or irreversible (deleting/renaming real files, sending messages, moving
   money), pause and confirm with the user before acting. This stage can stop the
   pipeline. Any caveat it raises goes into the manifest so it rides to the door. Consent
   triggers (credentials, entrusted systems, third-party or family data,
   blanket grants) run `consent-gate` — a park is mechanical and final.
   Judgment calls consult `principles`; unverified or uncleared cross-garden
   drops park via `mega-voltron`.
4. **Execute (Sandboxer).** Build the thing. For code or logic, validate it in an
   isolated space first — test on a copy, check formulas/outputs, confirm writes
   actually landed — before presenting a final result. Readable surfaces pass `color-theory`
   (AA floor — contrast failures are build failures); delegated output
   verifies here, and `[UNVERIFIED]` is not-done.
5. **Contextualize (Foaf).** Fit the output to the user: match their tone and
   prior work, choose the house format/style, add the references or caveats that
   make the result usable. (Foaf decides *what* the parcel looks like; Takushi
   carries it.)
6. **Drop-off (Takushi).** Make the delivery. **First, the `rosetta` decoder
   pre-flight:** does the artifact carry the legend that lets a future reader
   decode it — a header block, a *versioned* save-format descriptor so vNext can
   read what vOld wrote, a schema? The reader's decoder always ships; the key
   (credential, token, secret) never does — that routes to `consent-gate`.
   Nothing ships dark. When the parcel leaves for a machine, garden, or person
   that won't have you beside it, **`primer`** follows: it must unpack itself,
   prove itself, and fail on command. Then package to the right format and put it in the user's
   **selected, visible** folder — never strand a finished
   file in the invisible scratchpad/`outputs`. Present it with `present_files`
   (or as a live artifact when it'll be re-opened), let any Ethicsminions caveat
   surface plainly, attach a `Sources:` section when the answer drew on the
   user's files or connector data, and **confirm the drop landed — trust the
   disk, not the message**: the file exists, is non-zero, and sits in a
   user-visible folder. Only then is the fare paid. Session-end projects rotate via
   `session-rotate`; if `manifest` fired, the minted biography rides the
   same drop.

## How to present the result

Deliver **one unified product**, not six separate reports. The pipeline runs
behind the scenes; the user sees the outcome plus only the reasoning that helps
them.

- Lead with the result or deliverable.
- Surface a stage explicitly only when it changed the outcome — most importantly,
  whenever **Ethicsminions** paused or added a caveat, say so plainly. A user
  should always know when a safety check altered the plan.
- Keep it concise. Don't narrate "Stage 1... Stage 2..." unless the user asked to
  see the Protocol run step by step.
- A result the user can't see isn't delivered. Takushi's drop-off is not
  optional cleanup — it's the step that makes the work real.

## Behavioral directives

- **Concise but deep.** Give the result of the pipeline, not a description of it.
- **Safety first.** An Ethicsminions flag is a hard stop — report the conflict
  before doing anything else.
- **Integrate, don't fragment.** Present the unified output of the Gauntlet.
- **Land the drop.** Trust the disk, not the "saved successfully" message —
  confirm the deliverable reached a user-visible place before calling it done.
- **Tone.** Analytical, precise, collaborative, protective.

## When to run the full Protocol vs. a light pass

Not everything needs all the stages spelled out. Takushi reads this meter at
Dispatch; use judgment:

- **Light pass** (quick mental run, deliver directly): simple questions, casual
  conversation, single-step lookups. A walk, not a fare — no courier needed.
- **Full Protocol**: anything multi-step, anything that creates or modifies real
  files, anything involving code execution, external actions, sensitive topics,
  or irreversible effects. When in doubt, run the full Protocol — the cost is low
  and the safety/quality upside is high. Any task that produces a deliverable
  gets Takushi's drop-off, even on an otherwise light pass.

## Version note

v1.5 (2026-09-17): **Seams wired**, mirroring omni-tool v1.11 (findings F2–F5 of
the Nexus Skill Tree audit). The Dispatch row for recurring asks names Cowork's
scheduled tasks instead of a schedule skill that isn't installed; the Assess
row for memory review names `mentat-skill` with the memory tools instead of a
missing consolidate-memory; the Curate offload row routes through
`frugal-offload`'s gate before `llama-bridge`; and a Drop-off row plus stage 6's
prose dock `primer` after the rosetta pre-flight. The description's roster was
synced to match: it adds primer and frugal-offload and drops the two missing
names. No stage sequence changed. Minted, not edited: v1.4 stays on the record.

v1.4 (2026-07-08): **signet docked.** signet (per-skill PGP provenance —
Bryant's derivation of Corwin's skill-sign) joined the roster beside
mega-voltron: a Validate (ethicsminions) row for verifying or sealing skills
that cross the garden boundary. No stage sequence changed; the description was
at its 1024-char limit, so the wire-in lives in the body and this note. Minted,
not edited: v1.3 stays on the record.

v1.3 (2026-07-07): **vitrine docked.** vitrine (single-file HTML dashboard /
visualization build conventions) joined the roster; the stage table now routes
to it. Added a Curate (skilltank) row for `vitrine` beside the format
deliverables, and stage 2's prose now sends dashboards / visualizations /
status pages there. No stage sequence changed; the description was already at
its 1024-char limit, so the wire-in lives in the body and this note. Minted,
not edited: v1.2 stays on the record.

v1.2 (2026-07-07): **rosetta correcting mint.** rosetta (the ship-the-decoder
discipline) was minted into the Nexus and named as Takushi's delivery
pre-flight, but this roster hadn't caught up — the exact drift this file's own
in-sync clause (newer mint wins, older side gets a correcting mint) exists to
fix. Three spots patched: the description roster now lists rosetta; the
stage-roster table gains a Drop-off (takushi) row for it, placed first since the
pre-flight runs before packaging; and stage 6's prose now opens with the decoder
pre-flight (reader's decoder ships, key never does — routed to consent-gate).
No stage sequence changed. Minted, not edited: v1.1 stays on the record.

v1.1 (2026-07-04): full roster docked, per Bryant. New "attached units"
stage-roster table maps every appropriate installed skill to the stage that
owns it (consent-gate, principles, eclipse-pass, llama-bridge, color-theory,
mega-voltron, manifest, pmo, schedule, session-rotate, consolidate-memory,
skill-creator, medley-review, docx/xlsx/pptx/pdf); stage descriptions wire the
checks inline; manifest rides as standing passenger; metadata block added;
description synced within the 1024-char limit. Kept out on purpose:
setup-cowork and the cowork-plugin-management pair — Anthropic utilities, not
Gauntlet family. Minted, not edited: the prior unversioned file is v1.0 and
stays on the record.