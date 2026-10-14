# MODEL-session-continuity — cold starts, warm files

**Premise:** the assistant is ephemeral per session; continuity is FILES.
Design every artifact for the next session that lands cold — and for the
next person, who may not be you.

**The resume spine:**
- **A NOW pointer** (one file, newest block on top): where were we, what
  landed, next actions, pointers to depth. It is a pointer to facts, not
  a second copy of them. Guard its structure — a careless splice once
  destroyed the standing queue below the fresh block; edit the top,
  preserve the tail, and re-sign after every edit.
- **Dated seals** (append-only session records): one per declared close,
  signed, never edited after the fact. History lives here; the NOW block
  merely points.
- **A living model file** (model.md): the read-this-first operating
  state, rotated by snapshot — copy to a dated archive, bump the version,
  THEN edit. Silent in-place edits destroy the drift record.

**The close ritual:** a declared close writes the seal, refreshes the NOW
block, updates memory/index lines, and hands the keeper a batched sign
queue. Unclosed sessions are sprawl; the ritual is what makes rapid work
auditable at human pace.

**The journal (cheap continuous capture):** a one-line ledger for
learning moments — hard / oops / yay / ohhh — each with an optional
pointer. Case facts stay out; the moment travels, the pointer stays home.
Jot at the moment, not at the close; close-time memory is already lossy.

**Dropped turns (the painful lesson):** a reply that dies mid-flight
(API error, crash, disconnect) was NEVER SEEN and NEVER LOGGED — state
notes on the surviving side go stale silently, and a settled question can
resurrect sessions later. Recovery discipline: the keeper says "resend"
or "check the transcript" — never retypes from memory; the assistant
audits transcripts before re-asserting stale state; and anything that
binds the keeper across sessions lives as signed data on the keeper's
own surface, where no single dropped turn can freeze it.

**Don't over-compact.** Rich capture now beats clever summary later; the
reader who needs the detail is the one who no longer remembers it.
