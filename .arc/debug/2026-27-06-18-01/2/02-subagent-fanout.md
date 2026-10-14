# 2/02 — sub-agent fan-out + the AND-gate (Task 2) ★ harvest

**Faculty:** `Agent` (general-purpose, parallel) + `ToolSearch` inside children.

## Two distinct sub-agent patterns used this session
1. **Map/reduce mining** — 5 parallel `general-purpose` agents, each given a
   batch of ~12 session ids and a strict TSV output contract, returning only
   scored hits. I reduced 5 TSV blocks into one ledger.
2. **Cyclic gated QC (AND-gate)** — 2 parallel agents over one artifact: a
   *skillbuilder* gate (skill-creator/skilltank conventions) and an *SRE* gate
   (actually ran the script, tested safety). Ship only if **both** PASS. This is
   the same shape polygram's QC loop used to ship color-theory.

## Economics / nuance (token-awareness)
- Each child **cold-starts** and re-derives context — the expensive path. Worth
  it here because (a) Corwin explicitly invoked the sub-agent pattern and (b) the
  work was embarrassingly parallel and context-heavy (74 transcripts).
- Contract discipline matters: telling children to **load deferred tools via
  ToolSearch first**, cap output, and emit *only* TSV kept the reduce step cheap.
- Children must be told the authoritative key (id, not title) or they drift.

## Reusable "magic word": **pattern-harvesting**
Reap notes from a conversation/corpus *for a named farming program* (here:
sandbox enhancements + skills). Distinct from skill-shaping (is this a skill?)
and skill-farming (grow candidates → skills). Harvest = the gathering step that
*feeds* the farm. Candidate for its own skill once it recurs.
