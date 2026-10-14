produced-by: claudewin (hand-off, rewritten after QA pass 2) · 2026-10-08 · supersedes the 07:34 draft

# For Bryant (and Alfred): what Corwin's shop did with TopoForge and Tavern, then what is yours

Both live as private repos in github.com/inputloop (topoforge, tavern). In each, commit 1 is your
bytes, byte for byte, under your name; our work sits on top as separate commits, so `git log -p` and
`git blame` show exactly what is ours. Dual author, dual licence as always: code GPL-3.0-or-later OR
LGPL-3.0-or-later, prose CC-BY-SA-4.0, you first. Flip visibility as you like.

## TopoForge 1.6 (inputloop/topoforge)
What we added
- Story tab: a live plain-English account of the drawing (also its text alternative), downloadable as
  Markdown for an AI reader: FACTS v=1 block (spec/FACTS-v1.md), sentences that cite their shapes,
  Gaps by fixed rules (treat as unknown), your users' labels escaped so they can't forge facts, sha256 of
  drawing and facts. Lasting handles data.tf_ref stamped as you draw.
- Kits: tests/ (POSIX sh + jq, prove-red 14 cases), tests/browser (Playwright + axe; GREEN 34/34, no axe
  findings light or dark), RECIPE.org (literate ship recipe), project files.
What we changed in YOUR 1.5 code (accessibility, so you can take or leave each)
- role="menubar" removed; each menu button says it opens a menu and whether it is open; Escape returns focus.
- every document/inspector field and select tied to its visible label (incl. X/Y/W/H); Custom data boxes
  named by visible "Field name"/"Value" words, not a tooltip.
- faint grey --text-3 darkened (light #646d7a, dark #868f9c) to reach 4.5:1; an h1; panel headings h3 -> h2
  (CSS selectors moved with them, same look).
Yours to decide
1. Import/export quirks the round trips exposed (left as they were): draw.io turns spaces in custom field
   names into "_"; a connector field "cable" is lost from .vsdx; draw.io/.vsdx flatten newlines; Visio import
   adopts a shape drawn loose over a group box into the group.
2. Show or hide tf_ref in the Custom data panel; an ISSUE fact kind in a FACTS v2?
3. Visio 2010 live trip of 1.6 (Corwin has it on avalon) is not yet done.

## Tavern 2.3.1+gp.1 (inputloop/tavern) — four patches on your 2.3.1, each its own commit
- 01 receipt forgery: a "Searched:/Read:/Tools:/Not carried out:/..." line an AGENT types is marked
  "(typed by the agent, not a Tavern receipt)" (residents and MCP say/dm); people unchanged. (garth #931ea781)
- 02 garden-pony tool registry: tools under <data>/tools; approvals local per tavern x agent x sha with
  use / delegate / scope (any task | only when named); delegation can't exceed the grantor and lapses with
  it; <tool name=...> for residents, tavern_tools for MCP; "Tools:" receipts only from Tavern's own run log;
  tools travel as NAME.tool.json drops tagged #tool, offered, never runnable until the owner approves and
  the sha matches; Tools tab between Search and Rules. No new event kinds or fields.
- 03 a11y + version: VERSION "2.3.1+gp.1" (handshake compares PROTO only, checked); Tools tab keeps focus;
  button names start with their visible words. In YOUR code: the "+" new-room button moved out of the
  tablist (rooms and views are now two tablists, same place on screen); a visually hidden h1.
- 04 focus + headings, in YOUR code: a redraw from someone else's activity (presence, state) keeps keyboard
  focus on the same control (tab row, every view, side panel; new focusMark/focusBack); side panel headings
  h3 -> h2 (same look).
- Five of your lines carry `# sb:allow:` comments (they make or write fresh random tokens; no value in the file).
Checks: selftest 170/170 GREEN (was 147); tests/gp-check.sh 14/14 incl. K7 (a stock 2.3.1 peer joins,
links, takes the #tool drop); browser kit 40/40, axe clean; scan CLEAN with your upstream pinned.
Yours to decide
1. All local agents share one token, so per-agent approval is only as strong as that. Per-agent tokens?
2. Marking happens on the writing machine; unpatched machines' agents can still forge receipts.
3. Agents can still type "Question for"/"Note for" lines; a resident's own "skipped" items are taken on its word.
4. Tools run as the user with no sandbox (each tool card says so in words).
5. Version naming going forward (we used 2.3.1+gp.1 so share_source never labels our file as yours).

## Also from our side
- The vibrobeast plugin can now carry your stock Tavern 2.3.1 (byte for byte, off until a person asks
  Claude to turn it on; no JSON editing) and C4's MCP server; it tells people the patched build lives here.
- Local-model residents reported work they could not do (paladin's backup "check", garth's "Searched:" and
  hardware stats); patch 01 makes the forged receipt visible, it does not stop the model inventing.
