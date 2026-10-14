---
name: garden-usage
description: >-
  Answer "what is this, and how do I use it?" about anything in the vibrobeast garden (a skill by any
  of its four names, a C4 tool by its plain or coded name, a C4 entity) in one plain sentence, then
  how to use it and where to read more. Use when someone asks what a skill or tool is, which skill
  fits a task, what a strange name means, "what is moon-bite", "what does nm1fl do", "which skill
  checks signatures", "how do I use the garden", or when acting as a support persona for someone with
  a simple plugin install and no C4 tree. When one word means two things here it says so (a SEAM)
  instead of choosing. Reads the registers and skill descriptions; never invents an answer.
---

# garden-usage — say what a thing is, then how to use it

**The rule this skill carries.** Every thing in the garden has a handy sentence that says what it is.
Give that sentence first, then how to use it, then its other names, then where to read more. Never
invent a sentence: if the garden does not say what something is, say that, offer the closest names,
and suggest writing the sentence (an entity's first line, a skill's description).

## Look it up

    sh scripts/whatis.sh NAME          every meaning NAME has here, one sentence each
    sh scripts/whatis.sh NAME --json   the same, for a program
    sh scripts/whatis.sh --list        every installed skill, one line each

It reads, first found first: the four-name register (C4 `c/skillnames`: label, persona, standard and
pet names), the tool register (C4 `c/names`: plain and coded names), the skills installed beside this
one, and C4 entities under `Z/` (their first lines). It finds C4 at `$C4_ROOT`, else `/f/claude/c4`,
else `~/mnt/c4`. With no C4 tree (a simple plugin install), it answers from the installed skills alone,
and that is still a full answer for anything the plugin ships.

## Answer in this order

1. **The sentence**, as the garden has it. If the name was a persona, standard or pet name, say which
   skill it names ("moon-bite is eclipse-pass").
2. **How to use it**: a skill loads when you ask for it by any of its names or describe its task; a
   tool runs with `--help` first.
3. **Its other names**, so the person can use whichever they like (`nm1fl show` lists all four sets;
   `~/.config/polygram/flavor` picks one for minted editions).
4. **Where to read more**: the skill's SKILL.md, the tool's header, the entity file.

## Seams, said out loud

A name that means two things here is reported as a SEAM with both meanings. The known near-seam is
the word **usage**: the C4 tool registered as `usage` (`us1ct`) counts token usage, grouped by skill,
tool, sub-agent or turn, while this skill, `garden-usage`, is about how to use things. When someone
says "usage", ask which they mean; do not guess.

## When you are a support persona

Speak in plain words, one step at a time, and assume nothing about the person's setup beyond what they
say. If they have only the plugin, answer from the installed skills and say that the fuller registers
live in a C4 tree they do not need. If an answer needs a tool they do not have, say so and give the
nearest skill instead.

---
Copyright (C) 2026 Corwin Brust <corwin@bru.st>
Authored by Mentat (for Corwin).
SPDX-License-Identifier: GPL-3.0-or-later
This file is part of vibrobeast.  vibrobeast is free software: you can redistribute it and/or
modify it under the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later version.  It is
distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
