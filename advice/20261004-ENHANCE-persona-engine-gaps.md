# ENHANCE 2026-10-04: what the persona-engine research found between the sources

A sub-agent read the persona MCP server, the gauges, the sheets and the memory notes, read-only,
to build the persona-engine skill.  These are the places the sources disagree or stop short.  Each
names what would show it fixed.

1. **The refusals' authority.**  polygram/mcp/persona.py said its refusals were "mt1pl's, kept
   word-for-word"; mt1pl states three, the server five.  *Done here:* the comment now says which
   are mt1pl's (1 and 3) and where 2, 4 and 5 come from.  Open: persona_refusals still answers
   "if these diverge from its copy, mt1pl wins"; mt1pl could carry all five (fixed when
   `sh bin/mt1pl --explain` prints five).
2. **Dice parity.**  bin/pg1rl:30 says the JavaScript roller gives "same seed = same dice"; the
   memory note on the traits grid says the two differ for one seed.  Fixed when a test rolls one
   seed in both and compares.
3. **The Mentat sheet's sidecar.**  The notes say each sheet got a TSV sidecar; there is none
   for the Mentat sheet, and cs1gk WARNs (G5).  Fixed when cs1gk gives it no WARN.
4. **The persona-link design's home.**  Memory cites h/PERSONA-LINK-2026-09-13.md here; it lives
   at c4/h/ (and in the archive).  Fixed when the citation and the file agree.
5. **Two named checks that are not built.**  A founding-journal check in cs1gk, and the use-count
   the affix rule reads (named in mt1pl, not implemented).  pe1gt takes the second use as an
   answer (`--second-use yes`) until a count exists.
6. **No sheet of the fourth use** (tensions at an intersection) exists, and chained mutation has
   never been exercised (0 generations).  pe1gt's use 4 makes no new sheet, on purpose; the first
   chained generation should come from a persona's own session, with evidence.
7. **CORWIN.md ships now.**  An older note said it never ships; it is in the persona-shelf send
   manifest under CC BY-SA 4.0 on his word of 2026-10-04.  The older note is superseded.
