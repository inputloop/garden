# retro-apply: the extension prompt, re-read under prior-instruction

**Prompt re-run:** Corwin's prompt of 2026-10-09 that hung the spell, `c4/q/2026-10-09-extension-heavy-lens/PROMPT.md`.
It opens: "Carefully plan and create a Claude extension for our things."

**Skill:** prior-instruction. Search canon, then prompts, then the session, newest first; keep the
three lookups apart.

**Newer sources read for this run:**
- his talk with Bryant over the 1.1.4 hand-back (`c4/transcripts/2026-10-10-partnership-reading/`,
  READING.md and the subjects);
- Bryant's reply (`c4/q/2026-10-10-three-phase-transcription/2026-10-10-to-corwin.md`);
- the Bridgit lab recording's reading (`c4/transcripts/2026-09-19-bridget-lab-part/s2/READING.md`);
- cstk (`c4/framework/cstk/README.md`);
- Anthropic's page on desktop extensions (<https://claude.com/docs/connectors/building/mcpb>).

His question this morning: "In simplest possible terms, considering the reason behind the ask: I
think I was asking for a Claude extension. Can we get there from here?"

## The delta

| # | decision in the original answer | under prior-instruction, newest first | status |
|---|---|---|---|
| 1 | Q572 went ahead on its default: "the extension is the next edition of the vibrobeast plugin, not a new plugin" | The first word of the prompt names a product. Claude Desktop's own installable is an extension: one `.mcpb` file, installed by double-click, with a settings page drawn from its manifest's `user_config`. Our plugin is the Claude Code / Cowork form. | CHANGES: mint a `.mcpb` from the same tree, beside the plugin |
| 2 | Switches are preference rows set by asking Claude (`pref_set`), then "restart Claude" | The extension's settings page carries them: tavern on/off, the Tavern data folder, the agent name, llama on/off, C4 on/off and C4's folder. | CHANGES: each `KNOWN` key with a user meaning becomes a `user_config` field; `pref_set` stays for the rest |
| 3 | `launch.cmd` finds a Python and says what to install | Desktop ships its own Node. Python servers still need a Python, and the manifest says so up front. | CHANGES in part: the requirement goes in the manifest's `compatibility`; whether to port is a density-test question, not this run's |
| 4 | Skills ship inside the plugin; soft skills are served live over MCP | An extension carries servers, not skills. mentcached already serves skills over MCP (`soft_skills_list` / `soft_skill_read`). | STANDS: the extension reaches skills through mentcached |
| 5 | Wire and Tavern connections offered as RECIPES | A RECIPE's settings are exactly what `user_config` is for: a folder picker, a text field, a switch. | CHANGES: recipes with settings become `user_config` groups |
| 6 | Lane T drafted TERMS v2 on his ask that turn | His rule in the talk: "new terms come only from me ... And Claude's job is never to propose terms for us, unless I have assigned it that work." | STANDS for that turn (it was assigned); from now on terms text is never proposed unasked |
| 7 | Every minted footer carries his copyright line | "I don't want Claude to stomp my name on everything unless it's doing so expressly according ..." The footers are minted from `conventions/house.env`, his convention. | STANDS, flagged: the line is expressly by his convention; colophon-style stamping stays out |
| 8 | The hand-back gave sha256 prefixes | Bryant: "a prefix can't be checked." | CHANGES, done below |
| 9 | Public garden view, masked | Bryant asks to look it over before it is shared. | STANDS, with his review added before any share |
| 10 | Six servers in one plugin | One `.mcpb` runs one server. Six installs and six settings pages is the less accessible choice. | GAP, with a default: one extension whose single server hosts the six toolsets, each still off until switched on; by his rule, the more accessible option is the default |

## Done now

Full sha256 values, as Bryant asked:

- `dist/vibrobeast.plugin` (1.1.4): `2c7e3658031c777b4e2a049a974bc1fe82abbeaa2c398587104ee8c445944a63`
- `G:\dist-fam\bryant\2026-10-10-garden-535d010.zip`: `c88249b635f2620c5ef0f5b3e88ebc14dabf55afad68e0e307f4b5b477d3f0bd`

## The obvious build, and its test

`make mcpb` mints `dist/vibrobeast.mcpb` from the same tree:
- `manifest.json` with one server, the existing `polygram.mcp` entry hosting all six toolsets;
- a `user_config` group for each switch and folder;
- `compatibility` for win32 and darwin, and the Python requirement;
- the same Terms and Privacy files.

Its tests:
- `mcpb validate` on the manifest;
- a prove-red that a missing `user_config` field fails;
- an R-row that the extension's server lists the same tools as the plugin's six;
- a hand-test on avalon: double-click, fill the settings page, see the Tavern tools appear with no
  `pref_set` and no hand edit.

## Faculties

- **Used:** prior-instruction (the search order), the transcript layers (tr2sm/tr3rm output, read,
  not re-run), the Anthropic docs page, `sha256sum`.
- **Pruned recipe for next time:** prompt + newest transcript READING.md + the platform page for the
  product word in the prompt.

Mentat (for Corwin; claude-opus-5-5)
