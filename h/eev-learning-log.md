# eev-learning-log — a stranger learns eev, instrumented (the edrx study)

*Pilot per Corwin's go, 2026-09-02. Learner = Claude (an LLM — a proxy for a human beginner, NOT the
same; validity caveat rides every entry). Subject = edrx's own primary material,
find-eev-quick-intro (angg.twu.net). Method: log attempt → what clicked → the LOCATED MISSING DIAGRAM
(the tacit gap edrx assumes you reconstruct) → what would unlock it. Deliverable edrx wanted: an
empirical map of where a non-edrx learner gets stuck. Keep his words unsmoothed.*

## Session 0 — first contact, §§1–4 of the quick-intro (read as static text; NOT run in a live Emacs)

**What clicked, fast.** The core is clean and even elegant: Lisp can appear anywhere; put point after
a sexp, `M-e`, it runs. Some sexps *navigate* (`(find-file "~/")`, `(find-node "(emacs)Lisp Eval")`)
— "elisp hyperlinks"; some *act* like buttons (`(eek "...")`); some *print*. Go back with `M-k`. The
browser analogy (`M-e` = follow, `M-k` = back) is a well-chosen bridge. As an LLM I get the *semantics*
instantly — which is exactly why I'm a suspect proxy: concept-difficulty is not the barrier here.

**LOCATED MISSING DIAGRAM #1 — the felt execute-loop.** The whole pedagogy is that *the document IS the
running environment*: "This buffer is temporary and editable... a tutorial and a sandbox." You learn by
`M-e`-ing the very sexps in the tutorial and watching a buffer appear, then `M-k` back. Reading it as
text, I understand the *description* of that loop; I have not *felt* it. The tutorial's real "diagram"
is the live buffer-state transition (execute → new buffer → M-k → back), which the prose can only
gesture at ("it creates a new buffer and displays it... try it!"). This is edrx's OWN missing-diagrams
thesis turned on his own tutorial: the projection (text) cannot carry the lifting (the live loop);
access requires being *in* Emacs. **This is the access=heuristic gap, sourced and concrete.**

**LOCATED MISSING DIAGRAM #2 — the traversal graph.** The intro is a dense mesh of forward elisp-links
to *other* intros (`find-eev-levels-intro`, `find-video-links-intro`, `find-links-conv-intro`). It is a
hypertext meant to be traversed non-linearly by executing links, NOT read top-to-bottom. A linear
reader experiences branchy overwhelm; a live eev user experiences navigability. The missing diagram is
**the map of which link to follow when** — invisible to edrx because he lives inside the graph.

**Sourced find that lands on Corwin's gatekeeper point.** §3 links to `find-links-conv-intro`,
titled **"1. Security vs. transparency"** — because an elisp hyperlink is *executable code you run by
pressing one key*. eev's own design confronts the exact gate tension: maximal transparency/power vs.
"you are executing arbitrary code from a buffer." edrx did not dodge the enforcement/transparency
seam; he named it in the docs. (Follow-up: read find-links-conv-intro verbatim; do NOT smooth.)

**Honest caveat, restated.** I am not edrx's target human beginner. My stuck-points are LLM-shaped
(I over-index on semantics, under-index on the muscle-memory / live-loop that is the actual barrier).
The two located missing-diagrams are *author-side* and so partly learner-agnostic — but "how a human
beginner learns it" needs a human beginner, or C4LC as the instrumented vehicle. This pilot proves the
*method* (locate + source the gaps) and produces two real gaps; it does not stand in for the human.

**Next increments:** (1) read find-links-conv-intro (the security/transparency section) verbatim;
(2) actually RUN eev in a live Emacs (sandbox has emacs) and log the felt loop vs. the read loop — the
first real test of missing-diagram #1; (3) render the stuck-point map as a learning boxscore/band.
