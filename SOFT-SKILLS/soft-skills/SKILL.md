---
name: soft-skills
description: >-
  How skills reach a session without being installed: a folder named for the skill, holding a
  SKILL.md in the same format as installed skills, under a SOFT-SKILLS root that mentcached serves
  live. Use when a task wants a skill that is not installed, when asked "what soft skills are
  there", "load the X skill", "read the soft skill for Y", or at session open when the seat_mode
  panel reports soft skills loadable. Lists and reads only; never installs.
---

# soft-skills — the dynaloader, described by its own first entry

This folder is itself a soft skill, and it is the acceptance test: if `soft_skills_list` does not
show `soft-skills`, the loader is not looking where you think.

## The shape

    SOFT-SKILLS/
      <name>/
        SKILL.md          frontmatter (name, description) + body -- the installed-skill format, unchanged
        references/...    optional, read with soft_skill_read {name, file: "references/x.md"}
        scripts/...       optional; served as text, never executed by the loader

One folder per skill, named for it. Nothing is registered, minted, signed or uploaded to make it
appear. Edit the file; the next read is the edit.

## How to use one in a session

1. `soft_skills_list` — every loadable skill with its description, and which roots were looked in.
2. `soft_skill_read {name}` — the SKILL.md text. Read it and follow it as you would an installed
   skill's instructions. The answer lists the other files beside it.
3. `soft_skill_read {name, file}` — one of those files, by relative path.

The `seat_mode` panel (and every `span_start`) says how many are loadable, gated by the preference
`softskills.auto` (on by default; `pref_set` turns it off).

## Where the roots are

In order: the `softskills.roots` preference (`pref_set softskills.roots <path;path>`), else
`$SOFT_SKILLS`, else `~/.mentcached/SOFT-SKILLS` and `<seat>/../SOFT-SKILLS`. Only roots that exist
count. For this workspace: `pref_set softskills.roots F:/claude/AS4CE/AS4CE0001/SOFT-SKILLS` once.

## What the loader refuses, and why

A path outside the skill folder (`..`, absolute) — the folder is the boundary. A file that is not
text, or over 256 KB — this serves instructions, not payloads. Anything that would write — the
loader reads; authoring is the keeper's pen.

## Relation to installed skills

Same format, different pipe. An installed skill is chosen by the app from its description at
trigger time; a soft skill is chosen by you, by name, at call time. When a soft skill has earned
it, it graduates unchanged into `skills/` and the next mint. Until then it costs no ceremony.

<!-- footer: minted by bin/ft1mt from conventions/house.env and conventions/FOOTERS.org; edit those, not this -->
*Version 1.0.1: edition revised from 1.0.0 on 2026-10-04; spine: 2026-10-04.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/ (scripts GPL-3.0-or-later); Mentat (for Corwin; claude-opus-5-5)
<!-- /footer -->
