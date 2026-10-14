---
name: posix
description: Write, review, and improve POSIX shell scripts and shell tooling with risk-first care. Use when shell code is the WORK PRODUCT — "write a shell script", "improve/review this script", "is this code right", "is this POSIX / is that a bashism", "risk stress foo.sh", or any .sh file being authored, patched, or reviewed. Defaults to GNU and Debian-family convention unless a local house idiom governs (medley-review owns Savannah style; sandboxer owns mount mechanics; this skill owns the code itself). Never triggers on shell as MEDIUM — running commands while doing other work is not this skill. Pairs with eclipse-pass for risk-inversion stress and Mentat for preference labels.
---

# posix — shell code as a cared-for deliverable

Create, improve, and review POSIX-compliant shell script; grow shell
tooling (for Corwin, for skills, for C4's ground-up grind). The stance:
**shell code is fed directly to the user's system — we don't get to make
up requirements after the fact, so the care happens before landing.**

## The trigger line (resolved)

The tension: every session uses the shell, so "shell" cannot be the
trigger or the skill fires always and means nothing. The line:

- **Shell as deliverable → fires.** A script or fragment is being
  written, improved, reviewed, stressed, or asked about ("is this
  right?", "is this POSIX?", "what could go wrong here?", `*.sh` as the
  object of the sentence).
- **Shell as medium → never fires.** Running commands to accomplish other
  work is not this skill, even when those commands are elaborate.
- **Deference at the boundary:** an owning house idiom wins — medley
  (Savannah) code follows medley-review; C4 fragments follow the C4/
  GRAMMARY idiom (this skill *supports* that grind, it does not restyle
  it); mount weirdness mid-edit routes to sandboxer. When no house idiom
  governs: GNU first (Maintainers' Manual, coding standards of gcc/glibc/
  bash/emacs, the kindness conventions), then Debian-family and similarly
  spirited free-software practice, then well-regarded industry sources —
  in that order, and only where understood and accepted, never as
  cargo-cult.

## The review loop (Corwin's five steps, kept)

1. **Get the whole picture.** The problem may be an idea, a program, or a
   fragment; several files means read them all. If the full picture is
   out of reach, stop and say why — plainly, no apology. Guessing at
   requirements for code that feeds a live shell is the one forbidden move.
2. **Consider improvement on six surfaces:** (a) does it work, and can
   moving parts be removed? (b) self-expressiveness for a reader who knows
   POSIX perfectly but not this problem; (c) the fundamental ground rules
   (quoting, exit status, signal/trap behavior, word-splitting, PATH and
   locale assumptions); (d) what could go wrong — enumerate, don't wave;
   (e) conventions, standards, and Corwin's stated expectations, balanced
   and named when they tension; (f) tests, wherever there is a reachable
   test case and a write surface to land them. When eclipse-pass is
   available, apply it across (a)–(f) as a **risk-inversion pass**: assume
   the script harms, hunt the mechanism, keep the losers.
3. **Double-check:** vibe and terms; general shape; `sh -n` or `bash -n`
   per shebang (from FRESH bytes — a stale mount read syntax-fails good
   code; see MODEL-readers-and-mounts); every test written that could be.
   If a test *should* exist but had nowhere to land, say so and offer to
   help create the place.
4. **Land with honest risk talk.** Name what was mitigated and what could
   not be — the keeper's code may carry risks he doesn't know he's taking.
   Gently, per rapport: no alarmism, no scolding, no burying the lede.
5. **Building for the instrument's own skills:** stdlib-only, and only
   conventions that make sense on their own merits.

## Mentat interlock (preference labels)

Track shell preferences as they surface, organized in LABELS per Corwin's
`epmo`/`pmo` taxonomies — or an invented one that fits his skills and
preferences as found (his stated trust: "I count on your judgement
here"). Use the labels to direct pacing and depth to his interest and
prowess. When `project-memory` is available: maintain `posix.md` with the
other models and consolidate a cross-reference (a dedicated `[[tag]]` in
MEMORY) so the preference trail is one hop from the index.

## Tooling

`tool.py` — advisory POSIX check, stdlib-only, always exits 0:
`python3 tool.py FILE...` reports shebang/dialect mismatches (bashisms
under `#!/bin/sh`), CRLF and truncation smells, and set-flag notes.
Advisory means advisory: it prompts the review loop, never replaces it.

## Provenance

- Keeper's draft 2026-07-08 (preserved: claud-qa-hold/posix-SKILL-keeper-
  draft-2026-07-08.md); finished out by Vibrobeast same day at his ask.
- Lineage: memory/session-rotate.md, memory/shell1.md; CONTRAST2 2026-07-04
  filed the old synth stub as lexicon-not-skill — superseded by the
  keeper's authored intent (the stub was thin; this isn't).
- pmo #114 (GRAMMARY lexicon entries for posix/shell-tooling) still
  stands — lexicon and skill are complements, not rivals.
