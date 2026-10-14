produced-by: lens (claudewin, synthesis) · subject: advice/LENS-2026-10-08-topo-pony/{A,B,C-*}.md · 2026-10-08

# Two streams, one run — what the sub-agent LENS found

Wiring: A (TopoForge story) and B (garden-pony registry) designed alone from one packet (00-PACKET.md),
then each read the other's design and wrote a contrast (C-A-reads-B.md, C-B-reads-A.md).

## Converged (both contrast readers found it independently — two runs, one model family)
1. ONE RULE UNDER BOTH: the instrument writes the claims; the reader only quotes them.
   A: story sentences derived from the model, FACT vs GAPS, judgement words banned.
   B: tool receipts written only from the node's own run log (copying how Tavern's searched_recently works).
   -> One shared spec PATTERN (fact line + key into the source + rebuild-and-diff checker + exit 0/1/2),
      not one shared program. A's facts can be rebuilt by anyone; B's receipts only exist in one machine's log.
2. STRONGEST TRANSFER B->A: user labels/notes in a drawing can forge a facts block or an empty "Gaps"
   heading — prompt injection into the AI reader. Same attack as a resident typing its own "Searched:".
   Fix: escape user values, a per-export fence word, a forge.json fixture in the kit.
3. STRONGEST TRANSFER A->B: every tool card gets a FACTS/GAPS section by fixed rules (argv, hash, timeout,
   run-as user | what it reads/writes/reaches: unknown to Tavern), and words like "safe", "sandboxed" banned.
4. Story header carries sha256 of the drawing; a story read beside a different drawing is refused.

## Tensions left open (seams — named, not resolved)
- "identity": A's tf_ref (same thing through edits) vs B's content hash (any byte changes it).
- "tool": Tavern's UI TOOLS array (= tabs), B's runnable programs, TopoForge's pointer/connector buttons.
- "container": TopoForge's Docker/k8s device (l.605) vs its group shapes (l.624-630).
- consent: A writes tf_ref into a user's drawing unasked; B changes nothing without owner approval.
- GAP ("unknown, ask") is not "Not carried out" ("refused").

## Spot-checked by me (OBSERVED)
- TopoForge import mints fresh ids: `uid('n')` at index.html ~2931 and ~3427. Confirms A's point 1.
- Tavern clean_reply (Setup.bat ~9276) strips copied "Files:/Tasks:/Rooms:" lines; its docstring does not
  name "Searched:". garth's self-typed "Searched:" (tavern #931ea781) stood in the room unflagged — consistent
  with B's finding that receipt-shaped lines can be forged today. Untested beyond that one sighting.

## Pending to Corwin (decisions, in common words)
D1 Should TopoForge stamp its own handle into each shape as you draw (costs an undo step) or only at export?
D2 Mention-only tools: count a mention only when a PERSON wrote it (B's proposal) — yes/no?
D3 Tavern MCP into vibrobeast: B recommends leaving it in your Claude config now; later a small launcher
   that finds the installed tavern.py, checks Bryant's SHA256SUMS, runs `mcp`. Accept, or vendor it now?
D4 Name set: garden-pony alone, or siblings? (B's note section 5.)
D5 Which findings go to Bryant (forgeable receipt lines; one shared agent token = any local agent can act as
   another; TopoForge has no licence line in the file)?

LENS · this synthesis · 2026-10-08
a  my view: the two streams are one discipline (claims written by the instrument, quoted by readers) in two places.
b  view ascribed to Corwin (invented wording): decompose to compose; tests with their own spec; outreach to Bryant through tests.
c  his pull on mine: I asked for contrast through tests and falsifiers, not opinion — the converged items are test-shaped.
d  my pull on his: I framed both as "anti-invention" after this morning's tavern; that frame may crowd out usability.
persona/inverse: Mentat says "one spec pattern, two kits" / the inverse says "two features, ship each simply; the
   shared spec is ceremony" — finding: the forged-label attack only surfaced through the contrast, so the wiring paid.
principles: users must be able to read what the tool claims and check it (freedom 1, to study) — a story or receipt
   no one can re-derive or look up fails that, whatever its polish.
notes: written (this folder).
