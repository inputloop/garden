produced-by: builder B1 (browser QA; Mentat, for Corwin; claude-opus-5-5) · 2026-10-08
licence of this note: CC-BY-SA-4.0

# B1 hand-back: real-browser QA of TopoForge 1.6 and the Tavern Tools tab

## What we handled
- Two browser test kits written as plain Node + Playwright scripts. They are kept, and each prints one line per check (exit 0 green, 1 red, 2 kit broken):
  - `projects/topoforge/tests/browser/topoforge.browser.mjs` (sha256 1d80a676...)
  - `projects/garden-pony/tests/browser/tavern-tools.browser.mjs` (sha256 d8fe6247...). It starts and stops its own fresh tavern.
- A `RESULT.txt` beside each kit. Both have **RED** on the first line, and each lists its findings in plain words. sha256 dd545327... (topoforge) and f6799b23... (garden-pony).
- The apps were not changed. Nothing was written in Bryant/ or upstream/.

## OBSERVED (what was run, and what came back)
- Environment: cloud workspace with Chromium 141.0.7390.37 headless, Playwright 1.56.0, axe-core 4.14.0 (npm), Node 22.22.0, Python 3.13.16.
- Files staged from the device: index.html sha256 3aec5110...7b6cc, tavern.py 4b8ecbf0...c5a5, upstream topoforge-1.5.html 6a76e9ca... and tavern-2.3.1.py 6ffaa566... The last two were used only to see which findings are old and which are new.
- `node topoforge.browser.mjs index.html`: 24 pass, 4 fail, exit 1.
  - Functional checks all pass:
    - The office drawing (9 shapes clicked from the palette, then named, grouped and given 6 links) gets 15 unique tf_ref handles.
    - The Story panel names every shape and says it is a text alternative. Its live region is role=status, polite, and it announced `Story updated: "PC 2" renamed "Reception PC". And 1 more.`
    - Download saves the .json and the -story.md. The .md has one facts block, a sha256 header line and a "## Gaps" section, and its drawing-sha256 equals the saved JSON's sha256.
  - Keyboard checks all pass:
    - Tab reaches the tab row in 35 presses. Right arrow moves to Story. Enter and Space work on the tabs and on Download.
    - The focus ring is visible. 300 Tab presses never got stuck.
  - No console errors.
  - The 4 failures are all from the axe scan, listed below.
- One-off axe run on upstream 1.5: the main-page findings are identical, and the Properties-panel findings are the same kind.
- `node tavern-tools.browser.mjs tavern.py`: 28 pass, 7 fail, exit 1.
  - The Tools tab sits between Search and Rules. Tab reaches it in 8 presses and Enter opens it.
  - All 10 register fields are labelled and can be reached by keyboard.
  - Registered an echo tool by keyboard. The live status gave its sha256 prefix.
  - The card shows FACTS and GAPS and uses no judgement words.
  - Approved alpha for use and delegate by keyboard. Alpha then gave beta use through the agent API.
  - Alpha's run printed `echo-tool says: HELLO GARDEN`.
  - After revoke, alpha shows "revoked" and beta shows "lapsed: ...". Alpha's next run was refused, and the run log shows "not carried out: not approved for alpha here".
  - No keyboard trap and no console errors.
- One-off axe run on stock Tavern 2.3.1, Search and Drops tabs: the same critical `aria-required-children` on the tab nav, plus a moderate missing h1.

## RED findings
1. **TopoForge, new in 1.6 (serious, color-contrast).** On the Story panel, the `#storyAbout` hint and its `<code>tf_ref</code>` are #8a93a1 on white. That is 3.1:1 contrast, and the rule asks for 4.5:1.
2. **TopoForge, old in 1.5 (Bryant's).**
   - critical: `#menubar` has role=menubar but holds plain buttons.
   - critical: label / select-name. The document name, page name, grid and default-route fields have no label tied to them, and neither do 10 inspector fields and 3 inspector selects when a shape is selected.
   - serious: the same grey hint/heading contrast in other places.
   - New only because tf_ref now shows in the Custom data panel: serious `label-title-only` on custom-field inputs. Any custom field in 1.5 does the same.
3. **Tavern Tools tab, new in patch 02 (keyboard).** After Register, Approve, Revoke and Refresh, focus drops to `<body>`, because the view is rebuilt. That is 4 failed checks. The status line still announces the result.
4. **Tavern Tools tab, new in patch 02 (serious, label-content-name-mismatch).** On each card, the visible text of the "Share in Drops" button is not inside its aria-label ("Share echo in Drops. Other machines ...").
5. **Tavern, old in 2.3.1 (critical, aria-required-children).** The tab-bar nav holds the "+" button among the role=tab buttons. Also moderate: no h1.

## JUDGED
- [SKILL] The focus loss is probably Tavern's general re-render pattern, which the new tab inherits. Falsifier: press a button by keyboard on another tab, such as Tasks or Drops. If focus stays put there, the loss is new to the Tools tab.
- [MINE] The card shows only the first 12 hex of the sha256. A person checking the exact file by hand cannot compare all 64. Falsifier: the full hash can be reached elsewhere on the card.
- [MINE] An agent appears in the Approve list only after it has introduced itself through the agent API (/api/ident). Until then, nobody can approve it ahead of time.
- [PLATFORM] Tavern's page has a strict CSP (script-src 'self'), which is good. The kit's browser context bypasses it only so it can inject axe.
- [MINE] The fixes for Bryant's old findings are his calls. The two new contrast/label items (1 and 4) and the focus loss (3) are ours to fix.

## Not done / not tested
- A real screen reader (NVDA/Narrator), Windows browsers, and TopoForge's dark-theme contrast.
- Tavern: the Offered table / "Copy to my tools" (needs a second machine), clicking Share, Rank, and mention-only scope from the UI.
- Kit dependency: axe-core is not vendored. Run `npm install axe-core` beside the kit, or set AXE=path.

## Pending for Bryant
- The TopoForge 1.5 menubar role and the unlabelled inspector/document fields. The Tavern tab-nav "+" button inside the tab list. The site-wide grey hint contrast.
