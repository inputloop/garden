# Hand-back, lane G: the garden view and the single-page app (turn 2, 2026-10-10)

## What you can open now

`site/garden/index.html` in the garden (on your machine, `/f/claude/AS4CE/AS4CE0001/site/garden/index.html`).
It is one file with nothing fetched from outside. Open it straight from disk. It reads with JavaScript off,
and follows your system's light or dark setting. A button switches the theme by hand.

What's on it, top to bottom:

1. **A read-back in words.** 177 things drawn, 965 links and 40 tensions (29 open, 11 resolved), from 136
   source files read at build time.
2. **Your words** as the page's reason for being. You asked for "the new view that shows the resolved
   and opened tensions across our garden of tools and computer friends".
3. **Two gardens, one ring.** Bryant's ring is redrawn from his own data (his families, his edge types)
   on the left half, and ours is on the right. Our counterparts sit roughly opposite his, so the
   counterpart and derived-from lines cross the middle. The servers (diamonds) and personas (triangles)
   are inside. The inner band carries the tensions, each a mark with its word: "open" (hollow diamond)
   or "resolved" (filled circle).
   - Six kinds of line show at first. The rest (mentions, his use/slot/seam types, his audit's dangling
     and gap) are behind checkboxes.
   - Opening any entry in the story lights its lines in the ring.
4. **The compass.** His axes: west to east is accessibility to interoperability; south to north is
   convention and signage to imagination and own-ness. Each point is numbered against a table that gives
   its likelihood and confidence pair, read from S8 §3 at build time.
5. **Four doorways: MCP, the Wire, the Tavern and C4.** Each shows its status as built in words. Each
   action is an "Ask Claude: copy this prompt" button in hand-test's form (the prompt, then "You should
   see: ..."). The prompt text is also on the page, so it can be selected with JavaScript off.
   - Only C4 has live probes (org-httpd 8042, c4-serve 8781). They run only when you press their button,
     and each badge reads "live", "as built" or "not reachable", with the reason.
   - MCP, the Wire and the Tavern say in words why a page can't reach them.
6. **The tensions table, the story of every node, and the sources table.** The sources table gives each
   file's sha256.
7. **The footer.** "Corwin Brust and Bryant Frankford share these gardens as one collection". It gives
   the terms both offer (code GPL-3.0-or-later OR LGPL-3.0-or-later, words CC-BY-SA-4.0) and Bryant's
   own line on the licence.
   - The credit to his graph is by name, near the top: "This view starts from Bryant Frankford's Nexus
     Skill Tree (built 2026-09-17 by Alfred for Bryant) ... I redrew his ring from his own data".

Screenshots (light, dark, a phone, one node selected) are in `advice/EXTENSION-2026-10-10/turn2/gv-shots/`.

## Per task

| task | state |
|---|---|
| 1. `bin/gv1mt` (Python stdlib) to garden-view/data v1, writing data.json and one index.html | done |
| 2. The page: rings with links, tension marks, compass, doorways, accessibility rules, credit | done |
| 3. awk recount, plus headless Playwright and axe in both themes, with prove-red | done (all ran here; none NOT CHECKED) |
| 4. A make target, hooked into `dist` | done, as `make garden-view` (see the first surprise) |
| 5. Credit Bryant's graph by name in the page | done |

## Files

New:
- `bin/gv1mt`
- `site/garden/{index.html,data.json,garden-view.facts,pairs.txt}` (built)
- `tests/gv1mt-SPEC.txt`, `tests/gv1mt-recount.awk`, `tests/gv1mt-spec.rb`, `tests/gv1mt-browser.py`,
  `tests/gv1mt-tests.sh`
- In this folder: `R-ROWS-G.txt`, `CHANGELOG-G.txt`, `REQUESTS-T-from-G.txt`, `gv-shots/`

Changed:
- `Makefile`: a `garden-view` target, `.PHONY` and `help`, and one report-only line in `dist` before
  `rl2bp finish`.

I wrote the spec rows first, then the tests, then the code. Each check is written in a language other
than the builder's (Python): the recount in awk and the spec rows in Ruby. The browser test is Python
too, but it reads the page through Chromium, not through the builder.

## Tests, as run (OBSERVED)

`GV_LIBDIR=$HOME/gvkit/root/usr/lib/x86_64-linux-gnu sh tests/gv1mt-tests.sh`:
```
ok   GV6 awk recount: gv1mt-recount: GREEN
ok   GV1-5 GV7 GV8 GV10 GV14 GV16 Ruby spec rows: gv1mt-spec: GREEN
ok   GV11 colour pairs (color-theory audit): audit: 58 pair(s) read, 0 failed
ok   GV15 make targets: garden-view runs gv1mt: 1; dist runs gv1mt: 1; garden prints 1 line(s)
ok   GV9 GV12 GV13 browser: gv1mt-browser: GREEN (10 checks, 0 failed)
gv1mt-tests: GREEN
```
The browser leg's lines:
- JS off: every section shown, 4 of 4 doorways say "as built".
- axe-core 4.10.2 finds no critical or serious violation in light, in dark, or after the manual switch
  to dark.
- The page's self-test passes: the seal matches, 177 story entries for 177 nodes, 40 of 40 marks carry
  a word, and 9 of 9 badges read live / as built / not reachable.
- Tab reached 216 of 216 controls, each with a visible focus ring.

`... sh tests/gv1mt-tests.sh --prove-red`, where every planted fault was caught:
- a NODE line cut (awk: nodes claims 177, recounted 176);
- counts.open +1 (awk MISMATCH, and the Ruby seal check red);
- an outside font (GV8);
- the words stripped off the marks (GV10: 0 of 40);
- Bryant's name taken off the credit (GV14);
- a probe on load (GV16: 2 fetch);
- a faint pair (GV11: 1 failed);
- dist without gv1mt (GV15);
- in the browser: a faint muted colour (axe: serious color-contrast x207), doorways shown only by
  JavaScript (GV9: 0 of 4 visible), and copy buttons out of the Tab order (GV13: 209 of 216).

The line ends "gv1mt-tests: PROVE-RED OK".

Without the extra library folder, the same runner prints `NOT CHECKED GV9 GV12 GV13 browser: ...
headless Chromium did not run` and ends "GREEN where checked; NOT CHECKED in part". It exits 77, as
asked.

Existing suites:
- `python3 -m polygram.mcp --prove-red`: "prove-red PASS: every refusal fired on purpose".
- `tests/makefile-c4root-tests.sh`: 5 ok, 0 failed.
- `tests/makefile-bytecode-tests.sh`: GREEN.

I ran these after my change only. My only shared file is the Makefile, and both Makefile suites read it
as changed.

What the browser leg needed in this VM. It's ephemeral, so the next session redoes this:
- `python3 -m playwright install chromium`;
- `apt-get download libxdamage1` unpacked with `dpkg-deb -x` into `~/gvkit/root` (the one library
  Chromium lacked; no root needed);
- `npm install axe-core@4.10.2` in `~/gvkit`.

The runner finds axe there, or wherever `AXE=` points.

## Re-sign owed
None. I touched no signed file.

## Requests to other lanes
`REQUESTS-T-from-G.txt` asks lane T for three GRAMMARY entries (gv1mt, garden view, tension) and the new
make target.

## R-rows
`R-ROWS-G.txt` has two rows, R29 and R30. R29: the page builds and its awk recount agrees. R30: the
recount goes red with a NODE line cut. Both passed in a scratch harness. I left R31 and R32 unused,
because the browser checks need Chromium, which the MCP harness should not assume.

## What surprised me, and what I judge (each with a falsifier)

- **`make garden` was already taken.** It is sg1ck's garden gauge, and `bin/gd1ck` reads it with
  `make -n`, expecting one command (`tests/makefile-c4root-tests.sh` checks it too). So the page is
  `make garden-view`, and `garden` is left exactly as it was.
  - Falsifier: you meant `garden` to become the page and the gauge to move. Then it's a rename in two
    files (Makefile, gd1ck) and one test.
- **The dist hook reports and never stops the mint.** The page is a view beside the plugin, not part of
  it.
  - Falsifier: you want the page shipped inside the plugin or on the pub shelf. Then a failed build
    should stop `dist`, and the line drops its `-`.
- **Our side of the ring shows sibling lanes mid-pass.** Lanes B and T changed files under me (see
  Seen arriving). The page as last built (about 18:00, by the hand-test step I ran) reads whatever was on disk then, and its sources table pins
  each file's sha256 as read.
  - Falsifier: none needed. It's a snapshot by design; `make garden-view` pulls it current.
- **"Resolved" for a card means its edition column begins with "this".** That is S7's stand-in. A card
  can be resolved here while its falsifier has fired.
  - Falsifier: any `this` card whose falsifier is observed. Then the state should come from a check
    (`state_by: "check"`).
- **Counterparts: 10 drawn as counterpart and 21 as derived-from.** Counterparts-file rows marked
  derived-from-his or derived-from-ours become derived-from lines, not counterpart lines. That is why
  S7's "15 names in both" shows here as fewer counterpart lines. omni-tool and frugal-offload now meet
  Bryant's by name, because lane B landed them as soft skills during my build.
  - Falsifier: a name in both gardens with no line between them in the story. Search the story for
    the name.
- **Size.** The page is 756 KB. Most of that is the 649 "named in its text" lines, hidden at first, and
  the embedded data.
  - Falsifier: the page opening slowly on Avalon. If so, the next step is to drop mentions from the
    drawing and keep them in the story only.
- **org-httpd answers any page, POST included** (S8 §4). My probe uses GET only, and I didn't change
  org-httpd, which is not in my lane. The fork S8 names is still yours: drop `*` for POST, or add a
  per-run token.
- **Not used:** the local model. I needed no drafting.

## Seen arriving (files that changed under me; I touched none)

| seen (UTC) | path | what | my reading |
|---|---|---|---|
| 17:22, already there | `SOFT-SKILLS/depth-overlap/SKILL.md` (13:49) | untracked, new today | the other session's additive soft-skill work; already in ANOMALIES at 17:22 |
| 17:30 | `SOFT-SKILLS/omni-tool/`, `SOFT-SKILLS/frugal-offload/` | new, with NOTICE.md | lane B landing Bryant's two skills; the garden view picked both up as soft skills |
| 17:28 | `SOFT-SKILLS/egress/SKILL.md`, `family-shelf/SKILL.md` | rewritten | lane D's footer rows |
| 17:31 | `SOFT-SKILLS/gauntlet/NOTICE.md` (3316 → 3726 bytes), `parallax/NOTICE.md` (1701 → 2208) | changed | lane B's NOTICE table |
| 17:38 | `skills/{build-loop,inculcat-boxer,lens}/SKILL.md`, `skills/ethicsminions/references/AI_GUARD_PROVENANCE_CLAUDE.md`, each with `.arc/*.signed-2026-10-10` beside it | changed, old signed copy archived | lane T's first-person pass |

I added two rows to `c4/spells/extension/runs/2026-10-10/turn2/ANOMALIES.md`: the sibling-lane changes,
and the `garden` name collision.

## A hand-test for you

```
HAND-TEST — the garden view is current and reads without JavaScript (lane G)
Run at /f/claude/AS4CE/AS4CE0001 in your msys2 shell.

① it rebuilds from today's files
   make garden-view | sed -n 4p
   - [ ] SEE `40 tensions: 29 open and 11 resolved.`  → line printed

② it opens offline
   start site/garden/index.html
   - [ ] SEE `Seal: ... (matches)` under the title  → seal matches

③ it reads with JavaScript off (browser setting, or the page in reader view)
   - [ ] SEE four doorway cards, each with `as built`  → four cards

all ✓ ⇒ the garden view is current and stands on its own.
```
Step ① is the only one I ran myself. Its line will move as the gardens change.

## Swing 1 (after the conductor's fold, 6ee9b47)

I worked the conductor's four asks the same way as before: the spec rows first (GV17, GV18 and GV19 in
`tests/gv1mt-SPEC.txt`), then the tests, then the code.

1. **Ring.** Before I touched the layout, the new GV17 check went red on the committed page:
   ```
   FAIL  GV17  compass 19, ring 219 text boxes; 33 overlapping pairs; first: ring: "hooks-to-knowledge" on "27 resolved" (3.4) | ...
   ```
   GV17 reads every `<text>` box in the ring and the compass from getBBox, turns it by its own transform,
   and tests every pair with the separating-axis test.
   - What I changed:
     - The tensions now sit on a track of their own (r=338, drawn dotted), between our ring and the
       middle.
     - Each tension sits at the mean angle of what it touches, spread by a 1-D placer so no two labels
       meet. Its label runs outward, like the ring's labels.
     - The servers and personas moved into two columns of their own, labels to the right.
     - The few things named from elsewhere moved inward (r=265).
   - Now: `ok GV17 compass 19, ring 219 text boxes; 0 overlapping pairs`. Its plant (one ring label
     drawn twice) goes red: `ring: "adapt" on "adapt" (12.6)`.
2. **Compass.** The overlaps the conductor saw were in my first compass. My first swing had already
   swapped the names for numbers keyed to the table beside it. The number labels still crowded, so I
   spread stacked points 30 units apart and moved the axis words out past the plotted area. GV17 covers
   the compass too: 0 overlaps. The names live in the table, which is also the drawing's text story. I
   chose that over leader lines.
3. **Doorways.** The gated servers (llamabridge, tavernface, c4face) used to read "as built: off". Now
   they read:
   - "off by default (preference X); this build cannot see your setting, because your preferences live
     outside what the build reads".
   - Their node state is `gated`, not `off`.
   - The MCP doorway has a new prompt, "Which gated servers are on for me?". It runs `pref_list` and
     reads the settings live.
   - The Tavern and C4 doorways say the same, and their "turn it on" prompts now read the setting first.
   - GV18 (Ruby) checks this. It was red on the committed page ("as built it is off | off as built")
     and goes red again when the old words are planted back.
4. **Masking.**
   - `gv1mt build --public` writes `site/garden/public/` beside the private copy, and nothing is
     dropped. Its four masks:
     - a drive letter `F:` becomes `<F>:`, written with `/` so an escaped copy can't read as a UNC path;
     - msys `/g/` becomes `<G>:/`;
     - a UNC host becomes `<UNC>/`;
     - a claude.ai link becomes `<claude.ai link>`.
   - `data.masked` counts each mask, the footer says so, and the seal is recomputed for the copy.
   - `make garden-view` and `make dist` now pass `--public`.
   - Before: pb1ck on the private copy found 14 drive-letter, 10 msys-path, 8 unc-path and
     2 claude-ai-link LEAK rows (the 8 UNC rows were JSON-escaped `F:\claude\...`).
   - On the public copy: masked 6 drive paths, 4 msys paths, 0 UNC hosts and 1 claude.ai link. pb1ck's
     verdict: "CLEAN of what was checked -- NOT checked: host and user names (no .c4/leakwords)". Its
     remaining NOTE rows are 27 `ip-names-no-machine`, the loopback probe addresses and version-shaped
     numbers.
   - GV19 checks it. Its plant (one `F:\claude` put back) goes red: `pb1ck: 1 LEAK of the masked kinds`.

Tests, run after the swing (OBSERVED):
```
ok   GV6 awk recount: gv1mt-recount: GREEN
ok   GV1-5 GV7 GV8 GV10 GV14 GV16 GV18 Ruby spec rows: gv1mt-spec: GREEN
ok   GV11 colour pairs (color-theory audit): audit: 58 pair(s) read, 0 failed
ok   GV15 make targets: garden-view runs gv1mt: 1; dist runs gv1mt: 1; garden prints 1 line(s)
ok   GV19 the copy for sharing (pb1ck): pb1ck: 0 LEAK of the masked kinds; counts same as private: yes; data.masked present: 1
ok   GV6 awk recount, the copy for sharing: gv1mt-recount: GREEN
ok   Ruby spec rows, the copy for sharing: gv1mt-spec: GREEN
ok   GV9 GV12 GV13 GV17 browser: gv1mt-browser: GREEN (11 checks, 0 failed)
gv1mt-tests: GREEN
```
`--prove-red` caught 11 planted faults in the shell and Ruby legs and 4 in the browser leg, and ended
"gv1mt-tests: PROVE-RED OK (every planted fault was caught)".

New screenshots: `gv-shots/ring-light-r2.png`, `compass-dark-r2.png`, `doors-light-r2.png`.

What I judge:
- **The public copy masks only the four kinds asked for.** The loopback addresses stay: they are what
  the probes call, and pb1ck reads them as naming no machine. E-mail addresses also stay where skill text
  carries them.
  - Falsifier: a pb1ck run with Corwin's `.c4/leakwords` in reach that reports a LEAK in
    `site/garden/public/`. Then that kind joins the masks.
- **GV17 measures text against text, not text against dots or lines.** A tension label can still run
  close to a ring dot.
  - Falsifier: a screenshot where a label is hard to read because of a mark under it. Then the check
    should take the shapes in too.

Files changed in this swing:
- `bin/gv1mt`
- `Makefile` (`--public` on both lines)
- `tests/gv1mt-SPEC.txt`, `tests/gv1mt-spec.rb`, `tests/gv1mt-browser.py`, `tests/gv1mt-tests.sh`
- `site/garden/` (rebuilt, plus `public/`)
- `CHANGELOG-G.txt`

No commit, no dist, nothing signed.

## Reproducing the browser leg (the conductor's question)

The conductor's run said NOT CHECKED because GV_LIBDIR pointed at `~/gvkit/deb`. That folder holds only
the downloaded `.deb`. The library Chromium needs is unpacked in
`~/gvkit/root/usr/lib/x86_64-linux-gnu/libXdamage.so.1`, and nothing in the VM was lost. The browser
test now looks in that folder by itself when GV_LIBDIR is unset.

The command, from the garden folder:
```
GV_LIBDIR=$HOME/gvkit/root/usr/lib/x86_64-linux-gnu sh tests/gv1mt-tests.sh
```
Its last two lines:
```
ok   GV9 GV12 GV13 GV17 browser: gv1mt-browser: GREEN (11 checks, 0 failed)
gv1mt-tests: GREEN
```
Plain `sh tests/gv1mt-tests.sh` ends the same way now.

To set up the kit in a fresh VM (no root needed):
- `python3 -m playwright install chromium`
- `mkdir -p ~/gvkit/deb && cd ~/gvkit/deb && apt-get download libxdamage1 && dpkg-deb -x libxdamage1_*.deb ~/gvkit/root`
- `cd ~/gvkit && npm install axe-core@4.10.2`

The headers of `tests/gv1mt-tests.sh` and `tests/gv1mt-browser.py` give the same steps.

Mentat (for Corwin; claude-opus-5-5)
