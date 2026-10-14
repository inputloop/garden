# omni-tool: brought in from Bryant's garden, with thanks

**Thank you, Bryant.** The Omni-Tool is Bryant Frankford's single front door for real work (family
"Gauntlet Nexus", version 1.11): one place a request comes in, a routing map that hands each part to
the skill that owns it, and a promise that the finished thing lands where you can see it. Gauntlet
is the protocol; the Omni-Tool is the door that runs it on every substantive request in his garden.

Corwin asked this turn:

> omni-tool (is this still missing? Did we just work on that? If something else replaces this for
> us check that ...)

It was still missing. Until today our counterparts table (`conventions/bryant-counterparts.tsv`)
said "no counterpart", and nothing under `skills/` or `SOFT-SKILLS/` carried it. Bryant's own
`frugal-offload` replaces one part of it: his v1.11 note (2026-09-17) moved the decision of *when*
to hand work to a local model out of the Omni-Tool and into `frugal-offload`, which now sits beside
this one in `SOFT-SKILLS/frugal-offload/`. The front door itself has no replacement here; the
nearest we had was a split across `vibrobeast` (routing), `gauntlet` (the protocol), `build-loop`
and `verify-say`.

## Provenance

- `SKILL.md` is byte-for-byte `skills/omni-tool/SKILL.md` from Bryant's bundle
  `gauntlet-nexus-skills-2026-10-05 2.zip`, received through C4's intake as
  `c4/from-bryant/2026-10-05-r3`. That zip's sha256 matches the intake's `SHA256SUMS`
  (`1bd59f272dcae2b1bcf74f956fb7599a0b36144c4b3d7bc4ae44e5765b250315`).
- Pinned: `SKILL.md` sha256 `d6fc0216fff7d167f7711976fba490bbefaab675015dbcdbfc91aad8366e0458`
  (27839 bytes). Any other value means the file changed after it came in; `bin/tg1rs` does not
  check this, `sha256sum SOFT-SKILLS/omni-tool/SKILL.md` does.
- The 2026-09-17 snapshot (`nexus-skills-2026-09-17.zip`, sha256 prefix `ad6351f89cd29298`) is the
  older copy: it still routes to `schedule` and `consolidate-memory` and carries a metadata block
  this one dropped.
- Author: Bryant Frankford. Licence, as his bundle's REUSE.toml declares it: CC-BY-SA-4.0.
  Copyright (C) 2026 Bryant Frankford and Contributors. Unchanged here; under the attribution
  ladder (c4 `man/attribution-ladder.md`) it is his, whole.

## What candor-gate said (`sh skills/candor-gate/scripts/candor_gate.sh`, 2026-10-10)

    HOLD     provenance: unsigned — verify against the authors pinned key first
    HOLD     engagement: declares always-on — require OPT-IN per project in this shop
    HOLD     person-data: auto-persists person-facts — consent-gate third-party/family first
    HOLD     egress: opens an outward path — consent-gate; keep forensic/entrusted/3p off it
    NOTE     description: 1024 chars (near the 1024 limit)
    NOTE     routes/delegates — confirm every named sibling skill is installed

How I read each hold, for whoever opens this door:

- **Provenance.** The file carries no signature. The pin above is integrity, not trust: it proves
  the bytes are the ones the intake received, nothing more.
- **Engagement.** In his garden it is always on ("Self-engage on substance"). Here it is a soft
  skill: it is read only when a session asks for it by name, and reading it does not adopt the
  always-on rule. A session that wants it on for a project says so in that project first.
- **Person-data.** The trigger is lexical: it routes to `manifest` (which writes a biography) and
  to Mentat's memory. The Omni-Tool itself persists nothing.
- **Egress.** Real, and named: its first move is a Wire check against Bryant's relay through the
  wire MCP, and it offloads to a local model through Llama Bridge. The Wire check needs a live
  one-time code from Bryant, so it is attended; unattended it skips. Both paths go through
  consent-gate here, and forensic, entrusted-system and third-party data stay off them.

## The siblings it names, and where they are here

| named | here |
|---|---|
| gauntlet, frugal-offload | `SOFT-SKILLS/` (Bryant's, with notices) |
| mentat-skill, skilltank, eclipse-pass, ethicsminions, consent-gate, sandboxer, color-theory, foaf, llama-bridge, principles, pmo, session-rotate, medley-review | `skills/` |
| takushi | installed on some accounts as a user skill; used as he wrote it when present |
| mega-voltron | not here; our C4 intake and the `egress` soft skill do its job for drops |
| manifest, rosetta, primer, parley, wire-2fa, power-glove | not here: Bryant's; a run that needs one says so once and goes on |
| skill-creator, docx, xlsx, pptx, pdf | the platform's own skills |

Status: soft, PROVISIONAL. Graduation into `skills/` is by hand, at Corwin's word, and would carry
this notice.

Mentat (for Corwin; claude-opus-5-5)
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
