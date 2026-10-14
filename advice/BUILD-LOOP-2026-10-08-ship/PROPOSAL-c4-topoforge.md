produced-by: P2 (Mentat for Corwin; claude-opus-5-5) · 2026-10-08 · a PROPOSAL, nothing built
SPDX-License-Identifier: CC-BY-SA-4.0

# TopoForge drawings, transacted in C4's terms, through C4's own MCP server

His question (DESIGN-plugin.md): can c4's MCP server be "an effective work around for the Filesystem
connector bug ... to the extent shapes known to C4 can be transacted in terms of C4"?

## OBSERVED (read today, not run beyond what is said)
- `c4/mcp/c4-mcp.js` holds ONE canonical diagram document in memory (`dgram`) and offers
  `c4_diagram_new / _props / _set / _door`. It requires only `readline`, `path` and three `lib/*.js`;
  it reads and writes no file. Its tool arguments are JSON, its answers are text.
- The canonical document (`c4/h/MODEL-diagram.md`): `{v:1, treatment, paradigm, anchor, shapes, edges,
  systems}`; shape `{id,label,kind,x,y,face,group?,_expr?}` with kind box|decision|actor|node|note;
  edge `{from,to,fromCP?,toCP?,fromFree?,toFree?,style?,nib?}`; a system is the shapes sharing `group`.
  `lib/c4-diagram-model.js` has newDoc / propsOf / applyProp / validateDoc (pure, no dependencies).
- TopoForge 1.6 (`projects/topoforge/index.html`): a saved drawing is JSON `{name, pages:[{name, layers,
  nodes:[{id,type,text,x,y,w,h,parent,layer,props,data}], links:[{id,a:{id},b:{id},text,props,data}]}]}`.
  Every shape and connector carries a lasting handle `data.tf_ref` (D1). `factsOf()` turns a drawing
  into FACTS v=1 lines (spec/FACTS-v1.md): DOC, PAGE, LAYER, NODE, TEXT, IN, TOP, LINK, PROP, DATA, GAP.
  FACTS carry no coordinates.
- c4face (built today) serves c4-mcp.js from the person's own C4 folder, so whatever c4-mcp.js learns
  reaches Claude with no install step beyond the plugin.

## JUDGED: why this is a workaround for the Filesystem connector
The connector bug is about moving FILES between Claude and the person's disk. A drawing passed as a
tool ARGUMENT (JSON) and answered as tool TEXT never touches a file: Claude reads the drawing out of
the conversation (or out of TopoForge's own Export), hands it to C4 in C4's terms, edits it there with
the tools that already exist, and hands it back as TopoForge JSON the person opens with File > Open.
The file system is only the person's own Save/Open, which already works.

## The proposal (Corwin's file to change; c4face needs no change)
1. `c4/lib/c4-topoforge.js` -- pure, no requires, two functions:
   - `fromTopoForge(json, page=1) -> canonical doc`: node -> shape with `id = data.tf_ref` (fallback the
     internal id, said in a `notes` list), `label` = first line of `text`, `x,y` as drawn, `kind` by
     TopoForge's shape kind (device -> `node`, basic -> `box`, a `note` type -> `note`); a container ->
     a SYSTEM (`group` on each member from `parent`, `systems[gid]` for the box); link -> edge
     `{from: ref(a), to: ref(b)}`, a free end -> `fromFree/toFree {x,y}`.
   - `toTopoForge(doc, base?) -> TopoForge JSON`: the inverse; when `base` (the drawing it came from)
     is given, every field C4 does not model (props, data, layers, w/h, link text past line 1) is
     carried over from `base` by `tf_ref`, so a round trip loses nothing C4 did not touch.
2. Two tools in `c4-mcp.js`: `c4_diagram_from_topoforge {json, page?}` (loads into the held doc,
   answers the doc plus what it could not map) and `c4_diagram_to_topoforge {base?}`.
   Both pure; nothing written. The c4face guard keeps holding (no new requires).
3. FACTS as the check, not the carrier: FACTS have no coordinates, so they are not a load format.
   They ARE the right gauge: `factsOf(toTopoForge(fromTopoForge(d), d))` must equal `factsOf(d)`
   line for line. TopoForge's own `tests/facts.jq` computes FACTS from JSON with jq, so the
   round-trip check runs in a language other than the converter (house test rule), with a prove-red
   that plants a dropped `IN` (group lost) and a swapped LINK end.

## What maps, and what does not (said now, so nobody calls the converter lossless by accident)
| TopoForge | C4 canonical | |
|---|---|---|
| node, tf_ref, first text line, x, y | shape id, label, x, y | maps |
| container + IN/TOP | system (group) | maps |
| link a/b | edge from/to | maps; free ends -> fromFree/toFree |
| w, h, layers, PROP, DATA, multi-line TEXT, style | none | carried only via `base` |
| GAP | none | recomputed by TopoForge, never stored |
| C4 `_expr`, nibs, treatment, paradigm | none in TopoForge | kept in C4 only; to TopoForge drops them (said) |

## Pending (his)
- Whether to add the two tools to c4-mcp.js (his file; c4face only serves it).
- Shape-kind mapping for TopoForge's 40-odd device types beyond device/basic/note (proposed: all
  devices -> `node`, with `type` kept in a `data`-style passthrough if he wants it visible in C4).
- Falsifier for the whole idea: if a drawing as a tool argument exceeds what a tool call carries in
  practice (large pages), the workaround needs paging by `page` / by system; measure on GIZA's biggest
  drawing before building.
