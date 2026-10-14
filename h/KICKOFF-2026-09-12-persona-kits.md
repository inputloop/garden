# KICKOFF — build the four persona kits (the main book + three expansions)

*A small kick-off prompt, ready to paste into the session that does the main work. Drafted by Fable
(Mentat/Vibrobeast) 2026-09-12 from the planning turn; everything it points at is on disk. Sub-agents up
to GREAT (9) are approved for this work by Corwin (chat, 2026-09-12). Marked: for fiction or analysis —
no ship dates or licensing or publication dates specifically defined.*

---

Mentat — build the persona kits. Open with `sh bin/se1sn`. Then read, in this order, and nothing else
first: `h/MODEL-2026-09-12-persona-mechanics.md` (all of it; §9 supersedes §1–8 where they differ),
`h/IDEAS-2026-09-12-persona-engine.md` (three piles — keep them separate as you go),
`h/KITS-2026-09-12-usage.tsv` (the usage sketches; `python3 h/pk1tv --text` reads it), and
`modelthisbook/news/PERSONA-TRAITS-GRID.md` §How to play (the v1.0 rules you are replacing).

**Build, in this order, tests first each time:**

1. `h/pg1rl` v2 — `--kit main|simple|hench|classic` (classic = the v1.0 rules kept as-is), `--weather
   SHEET.tsv`, `--sheet` (draft the skeleton from a roll; never the journal). Rules exactly per §9.3 of the
   model; every rate in the model asserted statically from the tables, every sweep at ≥2000 seeds with a
   binomial bound (F10). The JSON is the contract for a later MCP/skill: `kit`, `seed`, `engine`, `trace`,
   `results`, `mark` — freeze it in a fixture. Tests: `tests/pg1rl-tests.sh` grows; `--prove-red` stays.
2. `PERSONA-TRAITS-GRID.md` v1.1 — the **main book**: the one-page *Roll a Persona* first (§9.3), the
   worked example (one persona rolled end to end, dice shown), the character sheet (four traits × level ×
   LB/BG, ladder side + rung, calling, circumstance, the watch column, three weathering boxes), a
   first-session walkthrough, the numbered table index, a glossary, the edge rules. Then the three
   expansions as their own sections: SIMPLE, HENCH TO MENCH (a gate mode of MAIN with its own page), the
   WEATHERING DECK. The two ladders and three shaping tables are generated from a new `PERSONA-LADDERS.tsv`
   (poles his, middles marked `[MINE]`). The template stays hand-written; the tables stay generated.
3. `h/cs1gk` G11 — every sheet opens with a **founding journal entry** (how the persona happened); G12 —
   `wired: yes` requires a named watcher contract file or FAULTs; the BAD-ladder row for a system actor
   is in the enum {perspective, watch}.
4. The governance lift lands as **table rows and lints**, never a paragraph (model §9.2). The kit names the
   watcher contract and does not ship it; write `h/CONTRACT-watcher.stub.md` naming the four fields and
   saying it is out of scope and whose call it is.

**Verify** with eclipse-pass (doubt-first / reward-first, losers kept), one LENS at GRAIN on the main book
(a new player, a game master, a sysop, doubt-first), ethicsminions over memory + skills, and the human-
scored A/B the engine exists for (H11): roll one persona with MAIN and one with the jumbled twin from the
same seed and hand both to the keeper unlabelled — the tool does not score its own work.

**Land:** masters in `AS4CE0001/h/` and `modelthisbook/news/`, same bytes in `c4/h/`, a DELTAS manifest,
a bank row (Q518 follows Q509/Q517), a MEMORY.md section, memory notes A + seat, journal 004 in the Grader's
Tales voice, the usage table regenerated with `h/pk1tv`, and the Drive carry of the record (the .xz at
`mainmem/ferry/persona-2026-09-12.tar.xz` from the host, or the col TSVs by hand). Modify signed files in
place and queue them; do not talk about signatures.

**Do not:** mint or name a systemic persona (the kit says *when* and *how*, never *whom*); re-roll a roll
you have; read SAVANNAH or the experiment seat; write a paragraph where a row will do.

**Forks to carry to him unresolved:** F9 (low-first entry seven: −1 or +1), the Hench/Mench name, the
watcher contract's home, the ladders' middle rungs.
