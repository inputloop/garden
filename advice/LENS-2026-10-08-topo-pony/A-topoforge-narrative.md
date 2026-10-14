produced-by: claudewin sub-agent A (LENS run) · subject: TopoForge narrative ("the drawing tells its own story") · 2026-10-08
status: DESIGN, nothing built; Bryant's file read-only, not edited

# A — TopoForge: the drawing tells its own story

## 1. OBSERVED — the data model as it really is

Source: `$HOME/mnt/Bryant/topoForge/index.html`. `wc -l` says **3536 lines** (packet said ~3446;
the file has grown, or the packet counted an older copy). Commands used: `grep -n`, `sed -n A,Bp`.

| What | Where | What it says |
|---|---|---|
| Document | 756 `newDoc()` | `{format:'topoforge', version:1, name, settings, pages:[...], cur}` |
| Page | 752-754 `newPage()` | `{id, name, nodes:[], links:[], layers:[L], activeLayer}` |
| Layer | 753, 795 | `{id, name, visible, locked}`; order in the array = stacking order |
| Node (every shape) | 761-773 `normNode()` | `{id, type, x, y, w, h, text, layer, parent, props, data, style, geom?}` |
| Network props | 742 `NET_PROPS` | `hostname ip mac vlan status vendor model subnet notes` (nothing else survives `normNode`) |
| Free fields | 770 | `data` = any key/value strings the user adds ("Custom data", 2008) |
| Kind of shape | 584-588 `defShape`, 645-647 | `SHAPES[type].kind` is `device`, `container` or `basic`; `isContainer` = kind container |
| Device types | 591-622 | 33 keys, each with a plain name ("Firewall"), a category, a `tier` 0 (WAN) .. 7 (endpoints) |
| Container types | 624-630 | `zone site vlan subnet dmz vpc rack` |
| Containment | 767, 797-802, 830-834 | `node.parent` = id of a container, or null. Parent cycles are broken (801); a parent that is missing or not a container is set to null at every `reindex()` (831) |
| Connector | 782-791 `normLink()` | `{id, a:{id,port}, b:{id,port}, route, text, layer, arrows, props, style, data}` |
| Connector end | 776-780 `normEnd()` | glued: `{id, port}` with port in `t r b l` or null (= auto); free: `{id:null, x, y}` |
| Connector props | 788 | only `speed medium ifA ifB notes` survive |
| Media words | 681-689 `MEDIA` | copper, fiber, wireless, vpn, wan, serial, logical, each with a plain name |
| Display name | 845 `nodeName()` | first line of `text`, else `props.hostname`, else the type's name |
| Default labels | 870-876 `defaultLabel()` | new devices get "PC 2", "Core Switch 1" etc.; new VLAN containers get `props.vlan` = 10, 20, ... (879-880) **without the user typing it** |
| Existing checks | 1869-1905 `computeIssues()` | bad/duplicate IPs, IP outside the nearest ancestor subnet, VLAN range/mismatch, duplicate hostnames, free connector ends, self-loops, duplicate interface names |
| Live hooks | 1426 `afterChange()`; 866 `scheduleSave = debounce(saveNow, 600)`; 2078 `refreshPanels()`; 271-276 side tabs props/layers/issues |
| JSON export | 2588 `exportJSON()` | `JSON.stringify({...DOC, exported: ISO-time})` — the whole model, all pages, one line of code |
| draw.io export | 2784-2845 `buildDrawio()` | ids are **renamed** to `tf2, tf3, ...` (2791); type rides in style `vcType=` (2819); `props` and `data` ride as XML attributes on `UserObject` (2792-2795) |
| draw.io import | 2902-2931 | every node gets a **fresh** `uid('n')` (2931); type comes back from `vcType` (2911) |
| Visio import | 3401-3427 | type from Shape Data `VCType` (3401); every node gets a **fresh** `uid('n')` (3427) |
| Ids | 298 `uid()` | time + counter + random — not derived from content |
| Licence / author line | grep for `license`, `Copyright`, `SPDX`, `Bryant` | **none found** in the file |

Two observed facts carry most of the design weight:
- **O1.** Node and link ids do not survive a draw.io or Visio round trip (2791, 2931, 3427). `data` does
  (exported as attributes 2794, read back as non-reserved attributes 2902).
- **O2.** `parent` is the only containment truth in the model. A shape drawn on top of a DMZ box but
  never dropped into it has `parent: null`. The picture and the model can disagree.

## 2. Palace — GIVENS hardest first, then pieces

GIVENS (cannot move):
1. **The narrative never invents.** Every sentence is a pure function of the model. Same JSON in, same
   bytes out. No AI inside TopoForge writes the story; the AI only reads it later.
2. **Ids are not stable across round trips** (O1). Anything that points back at a shape must ride in a
   field that already survives: `data`. Per the packet's wire rule, new data rides in an existing field.
3. **Single offline file, no network.** The feature lives inside `index.html`; no library, no fetch.
4. **Must survive Visio (2010 on avalon) and draw.io round trips** without the story changing meaning.
5. **The model can disagree with the picture** (O2, hidden layers 2110). The story must say so, not
   smooth it.
6. **Some values are not the user's** (default labels, auto VLAN 10/20). The model cannot tell typed
   from defaulted, so the story cannot either; it must say that plainly once.
7. **Bryant owns the file.** Smallest possible footprint; one new section, one new tab, one new export.

Pieces:
- P1 `storyRef` — a stable handle per shape, kept in `data.tf_ref`.
- P2 `factsOf(doc)` — the fact list (section 6 pins its grammar).
- P3 `storyOf(facts)` — sentences built only from facts.
- P4 `exportStory()` — the Markdown document, with the facts embedded verbatim.
- P5 the "Story" side tab, live, with a change list.
- P6 the test kit (jq + POSIX sh), outside the file.
- P7 the RECIPE that carries licence and authorship.

## 3. Context stack, bottom up

| Layer | Holds | May NOT assume about the layer above |
|---|---|---|
| L0 model (`DOC`) | shapes, parents, links, props, layers | that anyone will read it as a network; a "Firewall" shape is only `type:'firewall'` |
| L1 graph facts | containment tree, adjacency, roles from `tier`, gaps | that a sentence will be written for every fact; facts are complete, the story may group them |
| L2 sentences | one sentence per fact group, each with refs | that the reader sees the picture; or that the reader sees *only* the picture |
| L3 Markdown document | sections, ref table, embedded facts | that the reader is an AI, or a person; it must read for both |
| L4 AI reader + drawing | the document, maybe a PNG/SVG of the page | that the picture and the facts agree (O2, hidden layers); that a GAP may be filled |
| L5 user's prompt | "design the IP plan", "write a firewall policy" | that the document answered anything it lists as a GAP |

The arrow only goes up: L1 is computed from L0 and nothing else; L2 only from L1. The test kit (6)
checks L1; L2 and L3 are checked by "every sentence carries refs that exist in L1".

## 4. Word/meaning balancing

**4.1 Links back to shapes.** On first story build, each node and link without `data.tf_ref` gets one:
`<typekey>-<4 chars>` (e.g. `firewall-k3qa`), the 4 chars taken from its current id, extended until
unique on the page. It is written into `data`, so it survives JSON, draw.io (attribute) and Visio (Shape
Data) the same way the user's own custom fields do. Every sentence ends with the refs it rests on, in
square brackets: `... [firewall-k3qa, dmz-8h2c]`. A reader (or a script) can always go from a word to a
shape. Duplicating a page (2166) copies `data`, so refs repeat across pages; refs are page-scoped and
written `Page-1/firewall-k3qa` when the document holds more than one page.
Falsifier [MINE]: export a 4-node drawing to .vsdx, open and save in Visio 2010 on avalon, re-import;
if any `tf_ref` is missing or changed, P1 fails and refs must move into the shape's text instead.

**4.2 Vocabulary.** Two kinds of words, never blended:
- *Type words* come from TopoForge's own table (`SHAPES[type].name`, `MEDIA[m].name`): "a Firewall",
  "over Fiber". These are the app's claims about what kind of thing it is.
- *User words* are the label (first line of `text`), hostname, notes, data: always in quotes —
  `"Edge FW"`. These are the user's claims; the story repeats them, never interprets them.
- A label that only repeats the type (`"Firewall 1"`, `"PC 2"`) is still quoted; the GAP section lists
  it as "may be a default name".
- Roles come from `tier` (0 outside world, 1 perimeter, 2 gateway, 3 core, 4 access, 6 server,
  7 endpoint). The story uses tier only to *order* sentences outside-in, and says "TopoForge files this
  as a perimeter device", never "this protects the LAN".
- Words never used: "secure", "redundant", "protected", "behind", "trusted". These are judgements; the
  drawing does not contain them. (A small banned-word grep in the test kit enforces this.)

**4.3 FACT vs GAP.** The document has two named halves. FACTS are things the model states. GAPS are
things a design would need that the model does not state, each computed by a fixed rule:

| Gap kind | Rule |
|---|---|
| FREE_END | a link end with no `id` |
| SELF_LOOP | `a.id == b.id` |
| NO_MEDIUM / NO_SPEED | link without `props.medium` / `props.speed` |
| UNLABELED_LINK | link with empty `text` and no `ifA`/`ifB` |
| NO_IP | device (not WAN tier 0) without `props.ip` |
| NO_SUBNET | container without `props.subnet` |
| LOOSE_IN_BOX | node with `parent` null whose box lies wholly inside a container's box (O2) |
| HIDDEN | node or link on a hidden layer (not in a PNG/SVG the reader may be given) |
| ISSUE | every message `computeIssues()` already produces, copied, not re-judged |
| MAYBE_DEFAULT | label matches `^<default base> \d+$` from `defaultLabel` |

The document tells the reader in one line: "Treat every GAP as unknown. Ask, or say you are assuming."

**4.4 Section layout of the exported Markdown** (`<docname>-story.md`):

```
# <doc name> — what this drawing shows
> Made by TopoForge <version> from the drawing alone, <date>. Words in "quotes" are the
> author's; other words are TopoForge's shape names. [refs] point at shapes (data field tf_ref).
> Treat every GAP as unknown: ask, or say you are assuming.
## Pages            (one line per page: name, counts)
## <page name>
### Outside in      (sentences ordered by tier, then by containment depth)
### Groups          (containment tree, one sentence per container)
### Connections     (one sentence per link, or per bundle of identical links)
### Gaps            (bulleted, one per gap, with refs)
## Reference table  (ref | type word | "label" | page | container ref)
## Facts            (fenced block "facts": the exact fact list from section 6)
```

**4.5 Worked example — small office.** Invented data; refs use invented 4-char tails, said so.
Shapes: router "Gateway" (ip 203.0.113.1), firewall "FW1", DMZ container "DMZ" holding servers "Web1",
"Mail1"; VLAN container "LAN" (auto VLAN 10) holding switch "SW1" and desktops "PC 1", "PC 2". Links:
Gateway–FW1 (fiber, 1G); FW1–Web1; FW1–Mail1; FW1–SW1 (copper 1G, text "trunk"); SW1–PC 1; SW1–PC 2.

```markdown
# Small office — what this drawing shows
> Made by TopoForge 1.5 from the drawing alone, 2026-10-08. ...
## Pages
- "Page-1": 7 devices, 2 groups, 6 connections.
## Page-1
### Outside in
- "Gateway" is a Router (TopoForge files it as a gateway device), address 203.0.113.1. [router-a1b2]
- "FW1" is a Firewall (perimeter device). [firewall-c3d4]
- "Web1" and "Mail1" are Servers. [server-e5f6, server-g7h8]
- "SW1" is a Switch (access device). [switch-i9j0]
- "PC 1" and "PC 2" are Desktop PCs (endpoints). [desktop-k1l2, desktop-m3n4]
### Groups
- "DMZ" is a DMZ group holding "Web1" and "Mail1". It is not inside any other group. [dmz-p5q6]
- "LAN" is a VLAN group, VLAN 10, holding "SW1", "PC 1" and "PC 2". [vlan-r7s8]
- "Gateway" and "FW1" are not inside any group. [router-a1b2, firewall-c3d4]
### Connections
- "Gateway" connects to "FW1" over Fiber at 1G. [link-t9u0]
- "FW1" connects to "Web1" and to "Mail1"; medium and speed not given. [link-v1w2, link-x3y4]
- "FW1" connects to "SW1" over Copper / Ethernet at 1G, labelled "trunk". [link-z5a6]
- "SW1" connects to "PC 1" and to "PC 2"; medium and speed not given. [link-b7c8, link-d9e0]
### Gaps
- NO_IP: "FW1", "Web1", "Mail1", "SW1", "PC 1", "PC 2" have no address. [...]
- NO_SUBNET: "DMZ" and "LAN" have no subnet. [dmz-p5q6, vlan-r7s8]
- NO_MEDIUM, NO_SPEED: 4 connections. [link-v1w2, link-x3y4, link-b7c8, link-d9e0]
- UNLABELED_LINK: 5 connections have no label or interface names. [...]
- MAYBE_DEFAULT: "PC 1", "PC 2" may be default names; VLAN 10 may be a default value.
- Not stated anywhere: which FW1 interface faces which group; any rule, policy or route.
## Reference table
| ref | is a | label | page | inside |
| firewall-c3d4 | Firewall | "FW1" | Page-1 | — |
...
## Facts
(fenced block, see section 6)
```

Note what it does **not** say: that FW1 "separates" DMZ from LAN. The picture suggests it; the model
only says FW1 has links to both. An AI asked for a firewall policy gets the links as FACT and the
policy as GAP, and is told to ask.

## 5. Live as you draw

- New side tab **Story** next to Properties / Layers / Issues (271-276), built by `buildStory()`.
- `refreshPanels()` (2078) gets one branch: `if (tab === 'story') scheduleStory();` with
  `scheduleStory = debounce(buildStory, 600)` — same 600 ms the autosave uses (866), so typing a label
  does not rebuild on every key. 600 is observed, not invented.
- `buildStory()` computes facts for the current page only (cheap); the export computes all pages.
- **Change list:** keep the last fact set (a sorted array of lines). On rebuild, diff the two sets
  (lines added, lines removed) and show at the top, newest first, at most 9 rows (invented number):
  `+ "PC 3" joined "LAN"` / `− connection "FW1"–"SW1" removed`. A label rename shows as one removal
  plus one addition with the same ref, rendered as `"PC 2" renamed "Reception PC"`.
- Clicking a sentence selects the shapes in its refs (same path the Issues list uses to jump to shapes).
- Undo/redo (856-860) need nothing extra: they call `afterChange`, which refreshes the tab.
- Writing `tf_ref` into `data` is a model edit; it happens inside `edit()` once per new shape so undo
  stays honest. Judged [MINE]: this adds one undo step the user did not ask for; falsifier — if Bryant
  finds that step confusing in use, assign refs at export time only and show bare ids live.

## 6. Test kit — its own spec, in jq + POSIX shell

Folder (proposed): `topoforge-story-kit/` beside the recipe. Files: `SPEC.md`, `facts.jq`,
`check.sh`, `fixtures/*.json`, `fixtures/*.facts`.

**SPEC (fact grammar v1).** One fact per line, words separated by one space, `key=value` pairs,
values with spaces or quotes written `"..."` with `\"` and `\\` escapes; label = first line of `text`.
Output sorted with `LC_ALL=C sort`, no blank lines.

```
DOC name="<doc name>"
PAGE p=<page id> name="<name>"
LAYER p=<pid> id=<layer id> visible=<0|1>
NODE p=<pid> ref=<tf_ref or id> kind=<device|container|basic> type=<key> label="<label>"
IN p=<pid> ref=<child> parent=<container ref>
TOP p=<pid> ref=<ref>
LINK p=<pid> ref=<ref> a=<ref|-> b=<ref|-> medium=<key|-> speed=<text|->
PROP p=<pid> ref=<ref> key=<NET_PROPS key> value="<value>"
GAP p=<pid> kind=<gap kind from 4.3, except ISSUE> ref=<ref>
```

`ISSUE` gaps are left out of v1 (they repeat `computeIssues`, which has its own logic); kind and type
tables in `facts.jq` are copied from `index.html`, and `check.sh --tables` re-greps `defShape(` lines
(584-640) to prove the copy still matches. That is the density test passing: the rules fit in ~60 lines
of jq because they are table lookups and comparisons, not cleverness.

**Agreement test.** The JS side embeds its fact list in the exported Markdown under `## Facts` in a
fenced block tagged `facts`. So no JavaScript runtime is needed to test it:

```sh
# check.sh <drawing.json> <story.md>   exit 0 = agree, 1 = disagree
jq -r -f facts.jq "$1" | LC_ALL=C sort > ref.facts
sed -n '/^```facts$/,/^```$/p' "$2" | sed '1d;$d' | LC_ALL=C sort > js.facts
diff ref.facts js.facts && echo "AGREE $(wc -l < ref.facts) facts" || { echo DISAGREE; exit 1; }
```

Second check: every `[ref]` in the story's sentences appears as a `ref=` in the facts (grep + sort +
comm). Third: banned-word grep (4.2) over the sentence sections only.

**Fixtures** (each with a hand-written `.facts` file, so jq is itself tested): `office.json` (section
4.5); `loose.json` (a server drawn over a DMZ with `parent:null` → `GAP kind=LOOSE_IN_BOX`);
`hidden.json` (one hidden layer); `free-end.json`; `two-pages.json` (duplicated page, same refs).

**Prove red** (`check.sh --prove-red`): copies `office.md`, deletes one `LINK` line from its facts
block, runs the check, and **must** get exit 1; then flips one `parent` in `office.json` and must get
exit 1 again. If either run exits 0, the kit reports `KIT BROKEN` and fails. A green kit that cannot go
red is not running.

## 7. RECIPE — how it ships

One literate file, `RECIPE-topoforge-story.md`, written in order: what it is, the givens, the fact
spec (section 6 verbatim), the JS pieces P1-P5 as fenced blocks with the line in `index.html` each
attaches after, the kit, and how to try it. Header, top of file, before anything else:

```
TopoForge — the drawing tells its own story (a recipe)
Copyright (C) 2026 Bryant Frankford (Takushi)
Copyright (C) 2026 Corwin Brust <corwin@bru.st>
Code blocks: GPL-3.0-or-later OR LGPL-3.0-or-later
Prose: CC-BY-SA-4.0
TopoForge itself is Bryant's; this recipe adds to it and changes nothing else.
```

Bryant first: TopoForge is his. The same two copyright lines and the SPDX line
`SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later` go at the top of `facts.jq` and
`check.sh`. When the pieces are pasted into `index.html`, each block opens with a one-line comment
naming the recipe, so the origin is findable from the code. OBSERVED: `index.html` has no licence line
today (section 1); adding one to the whole file is Bryant's call, not this recipe's, and is left to him.

## 8. LENS

- a (mine): the story is a pure function of the model with refs in `data`; that is the whole trick, and its weakest joint is the Visio 2010 round trip of `data`, untested.
- b (ascribed to Corwin, invented, no quoted words): he will care most that the AI is told where the drawing is silent, and that the kit runs in a language he can line-edit.
- c (his pull on mine): moved the test from "run the JS in node" to "the export carries its own facts; jq checks them" — no JS runtime, POSIX he owns.
- d (my pull on his): asking him to accept that picture and model can disagree (LOOSE_IN_BOX) and that the story follows the model, not the eye.
- persona/inverse: a network designer wants "the firewall separates DMZ from LAN"; the inverse, a strict auditor, wants only "FW1 has links to both" — the design sides with the auditor and lists the separation as a GAP.
- principles reframe: freedom to study means the user can trace every sentence to a shape and every fact to a jq line; nothing in the story is the tool's opinion.
