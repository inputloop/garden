# DESIGN 2026-10-05: the track (where the garden pushes harder)

**A DIRECTION, NOT A BUILD.** Corwin's track for the garden, given after some days in which he and
Bryant read and watched the recent news about AI and judged it near our work but orthogonal to the
parts of it that matter to us. Each item below carries a reading, what in the garden already pushes
it (with paths), the check that would show we are wrong, and a first experiment. Proofs that we are
wrong are welcome; so are notes, formal writing and experiment plans.

## His words (verbatim, 2026-10-05)

> For a few days Bryant and I have been reading and watching videos and news related to AI.  We
> believe many of the more recent developments are similar too our work but orthoginal to the parts
> of our solution spaces that are important to us -- we're inclined to keep pushing and to push a
> little harder, especially back on things where our defined opportunity spaces don't seem to be
> quite central enough foci, these are:
>
> Track:
>
> * instructions only as tool/semaphore, use slowly changing interlock of natural content and little
>   or no "form for form sake", for example regimented considered structural and unchangeable among
>   any number of future runs
> * ideas: weighted by importance according to context, described by sentences explain each idea
>   from it's own context, each idea from each given context, doubly linked referents (ring)
> * words: each treated as context; maintain a fixed size set rotated per rigid mechanical means
>   forcing slow change over normalized reference paths into a set of (nominally) eventually current
>   documented meanings effecting toward system self description; use four prongs of meaning
>   weighting reference for the other three to drive toward diversity among word choice/selection,
>   for example to minimal support context or make a variety of possible tonal clues available
> * use two separate techniques for establishing relationship between the meaning of terms within the
>   system as they relate to reading (e.g. handing procedures) and for writing (e.g. establishing
>   context): contrast these stores only when judgement is required: balance resolves uncertainty
>   according to preferences that undeniably belong to the user without introducing new risk that
>   was not already shown to the user
> * this last is roughly the operating model design meaning our taxonomies and palaces and
>   mountains, giving context stacking vs word-tensioning and is our "better than math directed
>   endlessly at sha, signature, and "what changed, tho?" AI token expenditure, according to the
>   humans in this project: if we are wrong proofs are very welcome, as are whatever other comments,
>   notes, and more formal writings and experiment planning, of course)

(Line breaks are ours, for width; the words and their spelling are his.)

## The same message also asked, about persona

That the combined garden support differences in how a persona is used with, for, applied to, or
withheld from other people's work: Bryant's Alfred is the voice in his gardens; here Vibrobeast is
the direction, not the voice, and Mentat is the persona of last resort. `skills/vibrobeast/SKILL.md`
(new today) is the first place that is written. The ladder (c4 `man/attribution-ladder.md`) keeps
persona out of attribution entirely: a persona never stands in for a name a person is owed.

## The five items, read

### 1. Instructions only as tool or semaphore

**Reading.** An instruction earns its place by being something a tool runs or a flag a tool reads,
not by its shape. Natural prose that changes slowly carries the meaning; structure that exists for
its own sake, fixed across every future run, does not.
**Already pushing it.** Semaphores in the seat (`semaphore_raise`/`_lower`/`_state`); house numbers
and rules carried by checks rather than by restatement (ft1mt from `conventions/house.env`; colophon
from a parties file; at1ld's 15 is a constant with his name on it).
**We are wrong if** a run that follows a prose instruction with no tool behind it does as well, over
repeated runs, as one whose instruction is a tool or a flag. **Experiment:** pick three standing
rules that today live only as prose in a skill (for example "say NOT CHECKED, never a silent pass");
for each, count misses in saved transcripts (as `sl1gk` counts grown 03's) before and after the
rule becomes a check.

### 2. Ideas: weighted by context, said from their own context, doubly linked

**Reading.** Each idea is written once per context it matters in, in a sentence that explains it
from that context, with a weight for that context; every reference runs both ways, so the ring can
be walked from any idea.
**Already pushing it.** C4's ideas register (`c/i`, rows with his sentence, its id and a TENSION);
`two-columns` (first seen, last used) for the doubly linked half.
**We are wrong if** a reader handed one idea and its ring cannot reach its other contexts without a
search, or the weights do not change what a session reads first. **Experiment:** take one idea that
lives in three contexts today (the attribution ladder: c4 man, colophon's SKILL.md, the letter to
Bryant), write its three sentences and weights, and time a cold reader from each entry point to the
other two.

### 3. Words: each a context, a fixed set rotated slowly, four prongs of meaning

**Reading.** The working vocabulary is a fixed-size set; words enter and leave it only by a rigid
mechanical rotation, so meanings change slowly along normalised reference paths toward documented,
eventually current meanings: the system describing itself. Each word carries four prongs of
meaning, and each prong is weighed against the other three to push word choice toward variety
(a minimal supporting context, or a range of tonal cues).
**Already pushing it.** `intern` (soft): a text is not ingested while one of its essential words is
neither held nor decided; four states (SEATED, MEANT, DECIDED, NEW). The word register
(`word_register`/`word_where`), wwtrack.
**Open, for him:** the four prongs are not yet named by him (the four states of `intern` are states,
not prongs). A candidate found later the same day in his own work: C4's register gives every letter
four roles (scalar, group, command, tag), read as *a thing, a set, an act, a label*. The light-shelf
design (`advice/DESIGN-2026-10-05-a-light-shelf.md`) uses it as a renameable header, with a fixed
set of 17 rotated least-recently-used, until he names them.
**We are wrong if** a fixed, slowly rotated set produces less accurate writing (by a reader's
judgment) than an open vocabulary on the same tasks, or does not reduce drift in what a word means
across sessions. **Experiment:** after the prongs are named, rotate a set of 17 (house number,
invented) over a week of real work and measure word drift with the register's own history.

### 4. Two techniques: meaning for reading, meaning for writing

**Reading.** How a term relates to others when the system reads (following a procedure) is kept
apart from how it relates when the system writes (setting up context). The two stores are compared
only when a judgment is needed, and the balance is struck by preferences that are undeniably the
person's, without bringing in a risk he has not already been shown.
**Already pushing it.** The separation of `reading` and `writing` in C4's spells (`spells/ingest-
writing/`); the preference store (`pref_list`/`pref_set`) as the person's own balance; `prior-
instruction` (soft) for deriving a fork's answer from what he already said.
**We are wrong if** keeping the stores apart makes no difference to the result of a judgment versus
one shared store, or if the balance ever introduces a risk he was not shown (that is a defect,
always). **Experiment:** log every judgment that consults both stores for a week; for each, could
one store alone have decided it?

### 5. The operating model: context stacking against word tensioning

**Reading.** Taxonomies, palaces and mountains stack context; the word set tensions meaning; the
claim is that this spends tokens on meaning, where much of the field spends them on hashes,
signatures and "what changed".
**A data point from today, honestly both ways.** Three drops of one bundle arrived this afternoon;
the first two were read by hand at a cost of many thousands of tokens. `c4 bin/dp1dl` (new) now reads
any such delta in one command, and the model's part shrinks to judging what the delta means (who
made it, what it changes for us). That supports the track if its point is that the mechanical
"what changed" belongs in tools and the tokens belong to meaning; it does not by itself show that
stacking and tensioning beat other ways of spending those tokens.
**We are wrong if** on the same task, with the same checks, a session that spends its tokens on
hashes, signatures and diffs reaches as correct a result for fewer tokens than one that spends them
on context and words. **Experiment (to write as a HYPOTHESIS before running):** one task (intake of
a peer's drop to a decided hand-back), two arms, the span tools (`span_start`/`span_stop`) and the
metrics store counting tokens and time, the outside reader judging the hand-backs cold.

## What comes next

- Name the four prongs (item 3): his word, then a register row. (A candidate: the light shelf.)
- Write the item 5 HYPOTHESIS, with its companion table, before any run.
- Start the vibrobeast decision record: each garden decision in `advice/`, so a character can grow
  from the work if it is there.

---
*Version 1.1.0: item 3 gains a candidate for the prongs; first edition on 2026-10-05; spine:
2026-10-05.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/; Mentat (for Corwin; claude-opus-5-5)
