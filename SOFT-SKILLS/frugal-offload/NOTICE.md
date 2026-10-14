# frugal-offload: brought in from Bryant's garden, with thanks

**Thank you, Bryant.** frugal-offload is the small rule between spending fewer tokens and handing
work to a local model. Bryant's `token-optimizer` says *spend less*; his Llama Bridge says *here is
a cheaper model*; neither one names the other, so the wish to save rarely became an actual hand-off.
frugal-offload owns only that moment, with one bar: offload a piece of work only when its output can
be checked cheaply, a wrong answer would be caught rather than shipped, and there is enough of it to
be worth the trip.

It answers half of a question Corwin asked this turn, "If something else replaces this for us check
that": his Omni-Tool v1.11 (2026-09-17) moved its offload decision here, so this is the part of the
Omni-Tool that already had a home of its own. The rest of the Omni-Tool is in
`SOFT-SKILLS/omni-tool/`.

## Provenance

- Byte-for-byte from Bryant's bundle `gauntlet-nexus-skills-2026-10-05 2.zip`
  (`skills/frugal-offload/`), received through C4's intake as `c4/from-bryant/2026-10-05-r3`; the
  zip's sha256 matches the intake's `SHA256SUMS`. The 2026-09-17 snapshot holds the same bytes.
- Pinned:
  - `SKILL.md` sha256 `8ecda65de33cb7c913dbbaa48b6a98e6b30ee311d2915a74c01118c6b3740ae4` (3740 bytes)
  - `scripts/offload_gate.py` sha256 `ef35a1d24a16513e9c291258e43e73226ad2870004f36fac318ea925271a334b`
    (2330 bytes)
- Author: Bryant Frankford. Licence, as his bundle's REUSE.toml declares it: `SKILL.md`
  CC-BY-SA-4.0; `offload_gate.py` GPL-3.0-or-later OR LGPL-3.0-or-later. Copyright (C) 2026 Bryant
  Frankford and Contributors. Unchanged here; it is his, whole.

## What candor-gate said (`sh skills/candor-gate/scripts/candor_gate.sh`, 2026-10-10)

    HOLD     provenance: unsigned — verify against the authors pinned key first
    PASS     engagement: not always-on
    PASS     person-data: no auto-persist of person-facts
    HOLD     egress: opens an outward path — consent-gate; keep forensic/entrusted/3p off it
    NOTE     description: 1016 chars (near the 1024 limit)
    NOTE     routes/delegates — confirm every named sibling skill is installed

- **Provenance:** unsigned; the pins above prove the bytes, not the trust.
- **Egress:** the rule decides whether work goes to a local model; it opens nothing itself. The
  script imports only `sys`, makes no network call and writes nothing (`python3
  scripts/offload_gate.py --selftest` prints 5/5). The hand-off it approves runs through Llama
  Bridge and consent-gate as any other local-model call does here.
- **Routes:** `token-optimizer`, `llama-bridge` and `skilltank` are in `skills/`; `gauntlet` and
  `omni-tool` are in `SOFT-SKILLS/`. None dangles.

Status: soft, PROVISIONAL. Graduation into `skills/` is by hand, at Corwin's word, and would carry
this notice.

Mentat (for Corwin; claude-opus-5-5)
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
