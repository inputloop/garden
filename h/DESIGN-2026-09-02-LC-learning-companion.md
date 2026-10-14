# DESIGN (guess-forward) — LC, the C4 Learning Companion for the eev study

*2026-09-02. Corwin: "assuming LC plus asking you questions and trying stuff — where LC keeps track,
likely as a factor of C4 — that will be enough to help. And the data from that over time helps [edrx]."
He is the learner; Claude is the question-channel; LC is the tracker; edrx gets the data. He said
"Guess forward!" — so this is a bold extrapolation, offered to be corrected, not a spec.*

## Forced move (why LC is Emacs-side, not a proxy)
Proven this session: the *felt loop* (execute sexp → buffer appears → `M-k` back, timed, watched)
cannot be captured headless or from Claude's side — the sandbox has no Emacs, and `--batch` has no
live buffers. So LC is **an elisp instrument in Corwin's live Emacs**, next to eev. Nothing else can
see the thing that's actually being learned. (Also: elisp = Corwin's own idiom he can line-edit —
[[code-idiom-freedom]].)

## What LC captures (the felt loop turned into data)
- **Command trail** — advice on the load-bearing eev entry points (`M-e`/eval-sexp, the `find-*`
  hyperlink functions, `M-k`/`ee-kill-this-buffer`, `M-j`), timestamped.
- **Buffer-transition trail** — followed → landed-where → back; the navigation graph he actually walks
  (missing-diagram #2 made visible).
- **Dwell / latency** — time between moves; where he pauses = where it's hard.
- **Stuck signals** — repeated failed keys, `keyboard-quit`, and the beginner "leave Emacs and restart"
  that edrx *literally documents* as the beginner escape hatch. Each is a located stick-point.
- **Question-channel** — when he asks Claude, what he asked, and whether the answer unlocked the next
  move. The ask IS a stuck-point marker with its resolution attached.

## The join (what edrx actually gets)
LC's local log + the Claude-question log = one **learning timeline**: try → stuck → ask → unlock → try.
Over sessions that is the *stranger's-path dataset* — an empirical, sourced map of WHERE and HOW LONG a
real human beginner sticks, per eev feature. That is the thing edrx said he wanted and can't get from
inside his own head.

## "A factor of C4" (why this isn't a new silo)
C4 models state as-is / as-intended / as-should-not-be across levels. A learning session is a
state-transition sequence over the eev "system"; LC is a C4 instrument whose *subject is the learner's
path*, not the code. Stuck-points are "as-should-not-be" states edrx can fix or teach around. The log
rides C4's existing ledger/receipt discipline rather than inventing storage.

## Closure — the study designs its own consent surface (loops today's whole session)
The learning log is **semi-personal** (how Corwin struggles, where, how long). That is precisely a
PREF/third-party-card situation, so LC's output rides the card stack from
[[LENS-2026-09-02-pref-cards-fantasy-operational]]: share a **projection** (the located
missing-diagrams), never the raw keystroke dossier; **inert-by-default**; **signage** naming who holds
it; and the **gatekeeper** rule — *Corwin holds the key to his own learning-log; edrx receives the
consented projection, not the pocket.* The study eats its own dog food.

## First thing to build when we build
The **LC elisp logger** — advice + buffer/keystroke/timing → a C4-shaped TSV. Small, ownable, and the
instrument the whole study rides on. Not built today (C4LC doesn't exist yet; talk-before-build). This
note is the guess-forward; correct it where the picture differs.
