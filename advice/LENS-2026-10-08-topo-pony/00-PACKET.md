produced-by: claudewin (LENS run, packet) · subject: two work streams · 2026-10-08

# Shared packet — the same context for every sub-agent

Keeper: Corwin (FSF/GNU volunteer; decides by universalism/egalitarianism -> four freedoms ->
software-freedom movement -> wider sci/tech community). Peer: Bryant (Takushi), whose Claude is Alfred.
Everything ships dual-author, dual-licence: code GPL-3.0-or-later OR LGPL-3.0-or-later, prose
CC-BY-SA-4.0; Bryant listed first on Bryant-originated work.

House rules for this run:
- Keep OBSERVED (with the command/source) apart from JUDGED. Every concern names whose it is and a falsifier.
- Plain common words; no private jargon unless defined in the same line.
- When a number must be invented use 4, 9 or 17 and say it is invented.
- Read-only on $HOME/mnt/Bryant (Bryant's folder). Write ONLY in $HOME/mnt/AS4CE0001/advice/LENS-2026-10-08-topo-pony/.
- Tools Corwin can own: POSIX shell and stdlib Python preferred; the density test applies
  (if a thing can only live in one language, question the approach).
- New features get a test kit with its OWN spec, ideally in a language different from the code under test.

## Stream A — TopoForge: "the drawing tells its own story"
Source: $HOME/mnt/Bryant/topoForge/index.html (single offline file, ~3446 lines, v1.5). Network
topology designer: shapes (nodes/devices), containers (groups: site/VLAN/rack/DMZ, nestable),
connectors (links glued to ports), pages, layers. Exports today: JSON, SVG, PNG, PDF, CSV, draw.io,
Visio .vdx (2003-2010 XML) and .vsdx. Functions: exportJSON ~2588, buildDrawio ~2784, buildVsdx ~3145.
Visio 2010 is installed on Corwin's machine (avalon) for live checks.
Feature asked: as the user draws, the app writes a NARRATIVE of what the drawing shows. A downloaded
Markdown document, fed to an AI together with the drawing, should let that AI produce e.g. a design
(or whatever the user prompts), using an integral implementation of word/meaning balancing: getting a
meaningful representation of the picture from the shapes and how they connect. Ships as a literate
RECIPE (where the dual licence and authorship live).

## Stream B — garden-pony: a tool registry for the Tavern
Source: Tavern 2.3.1, one stdlib Python file embedded in
$HOME/mnt/Bryant/tavern/Tavern-Setup-2.3.1/Tavern-Setup.bat (polyglot .bat; python after line 1).
HowTo: tavern drop sha 53ad382b... (same text as HOWTO_MD inside the file). Key facts:
- Residents (Ollama/Claude/Gemini agents) have NO tools; they act via reply blocks (<drop>, <task>,
  <search>, <browse>, <remember>, <ask>), Tavern carries them out and appends what really happened.
- MCP agents use `tavern.py mcp --as NAME --model M --data DIR` (class McpFace ~line 7760, MCP_TOOLS ~7661).
- Model picker + tavern-tend: `load_tend` ~4088 reads <data>/tend/tags.txt and cards/ (card lines:
  name, handle, serve, seen, assumed, avoid, note); MATCH v1 weights seen 1.0, assumed 0.6, avoid 1.0.
  This is Corwin's tavern-tend kit, built on his machine GIZA, ported in by Alfred/Bryant.
  Concept: a garden of models grown toward need/constraint intersections (e.g. coding on one host with
  its hardware).
- Wire formats are versioned: an event body that gains a field breaks older machines; new data rides
  in existing fields (as categories ride in a drop's note) or waits for a major version.
- Observed failure this morning: Ollama residents REPORTED work they could not do (paladin "checked
  /etc/backup"; garth wrote "Searched:" itself and invented hardware stats). Any registry must not let
  a resident claim a tool ran when Tavern did not run it.
Feature asked: a local TOOL REGISTRY: set up and work with locally registered tools; agent- or
user-authored tools can be shared out and APPROVED per tavern x agent intersection, for use either
on any task (agent's discretion) or only when the tool is mentioned on the task/request. The registry
is a new section in the Tavern UI sitting between Search and Rules. Also: intake Tavern's MCP
component into Corwin's vibrobeast plugin (which already ships 3 stdio MCP servers; check.sh verifies
bytes; no __pycache__ ever; ${CLAUDE_PLUGIN_ROOT} paths).

## Method (LENS + palace + context stacking)
- Palace: decompose the stream into GIVENS (constraints that cannot move), hardest first; then the
  pieces; then compose.
- Context stacking: write the layers the feature sits on, bottom up (wire/format -> data model -> UI ->
  person), and what each layer may NOT assume about the one above.
- LENS block (six lines: a my view, b view ascribed to Corwin, c his pull on mine, d my pull on his,
  persona/inverse, principles reframe) at the end. Mark lines with no quoted words as invented.
