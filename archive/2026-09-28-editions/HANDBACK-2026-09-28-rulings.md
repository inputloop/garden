# HANDBACK: 2026-09-28: your rulings on the hardening hand-back, and the named-not-done list

**What it asks of you: nothing to approve.** Every item you answered is applied; every "named, not
done" is done. No build was run (you build next); nothing was signed. Receipt, from `/f/claude`:
`sha256sum -c AS4CE/AS4CE0001/Inbox/HANDBACK-2026-09-28-rulings.sha256`.

## Your answers, and what each became

| you said (verbatim, abridged) | done |
|---|---|
| candor-gate: "bless" / "i don't see the issue; this is our license for everything?" | No change. Its prose is CC-BY-4.0 and its script GPL-3.0-or-later, which is the TERMS (writing CC BY, software GPL). |
| foaf: "dual license but fine to list him first ... someone has to be first" | `skills/foaf/SKILL.md`: a `license:` line and a footer in Bryant's r2 form: text CC-BY-4.0; code GPL-3.0-or-later with the LGPL permission for linking; Copyright (C) 2026 Bryant Frankford and Corwin Brust. Its old signature moved to `.arc`. |
| "follow Bryant's form in the attached new version and add him to copyright (listing me first in this case) for CORWIN.md" | No file was attached this turn; I read "the attached new version" as Bryant's r2 drop (`c4/from-bryant/2026-09-26-r2`, BRYANT v3.0.1-public), whose front matter carries `license: ... Copyright (C) 2026 Bryant Frankford and Corwin Brust`. CORWIN.md is 1.4 with that line, Corwin first. 1.3 and its signature: `modelthisbook/corwin/CORWIN.md.7` and `.7.asc`; the live `CORWIN.md.asc` (now BAD) removed; book copy updated and logged; pub copy re-landed with `pb2ps --scrub` (PARTIAL: the nick-hash salt is not readable from here, as before). |
| author e-mail: "the plugins author e-mail is wrong. corwin@bru.st" | plugin.json author, and the copyright lines in 62 shipped files (polygram, bin, tests, skills, AUTHORS, README.org). ChangeLog history and records left as written. |
| words server C4 fallback: "that's our C4 root until the turn to the ON position lands" | No change. |
| pb1ck: "Yes, example paths can travel" | pb1ck reads `.c4/examples` (item and every folder above): a match that begins with one reads EXAMPLE, shown with file:line, never a leak; read at the match, so an example never excuses a path beside it. `AS4CE0001/.c4/examples` lists today's. Reserved mail domains read NOTE; a plugin's author e-mail counts as declared. A fresh plugin mint now reads **CLEAN of what was checked** (117 examples shown). |
| PARTIAL for unread binaries: "bless" | No change. |
| signing: "make sure that any skills that are in the garden are minted here" | The 12 canon skills from `c4/dist/skills` are copied, byte for byte, into `skills/` (58 now), so your signed build signs all of them. Copied, not moved: C4's `c4cs make-skill` writes there, and sg1ck reads it. `polygram dist` says any skill still minted from elsewhere, and any garden copy that has moved on from C4's. |
| altorewired / token-optimizer hold: "feels like a misfire" | It was. `c4/h/LENS-2026-09-28-always-on-hold-user-freedom.md`. The hold is the receiving shop's, at its door; the sender's read (`candor_gate.sh --travel`) says the broad engagement and sends it, and the plugin README now names both skills under "Skills that fire broadly". Your two descriptions are unchanged. The same probes found three more misfires, fixed: a credit URL read as egress, "regression" read as egress, an archived `.asc` counted as provenance. |
| unreadable folders: "warn by default ... 1 is the quiet setting and 17 is the STOP and 9 changes the message" | `SB_GAUGE` / `--gauge` on sb1aw, sb1pl, sb1rn: 1 quiet, 4 (default) today's output plus a warning, 9 a tab line per path with its reason and a hint, 17 stop at the first. Exit codes never change with the gauge (not read is exit 2) except at 17, where a hit already printed still exits 1. |
| `git update-index` error | That command only touches files git already tracks, and `bin/sb1aw` (vendored this weekend) is not tracked yet. The one-liner below adds and marks them together. |
| "named not done ... fix please. is that not pretty obvious?" | Yes. Four were done later on 09-27 (the old section now says so); the rest today, below. |

## Named, not done, now done

- The unreadable-path gauge (above). Kits: sb-kit-py 324 pass, sb-kit-js 315 pass, each with a
  mutant that goes red.
- Self-checks for the five scripts that had none (run-card's rc1rn, color-theory, lens's
  ferry_core, bin/freshen, bin/thread.sh), each with mutants. `make kit` now runs every self-check a
  skill carries (sandboxer and instrument-panel's had never run in it). They found: thread.sh
  printed an index subject as live markup, counted non-message files, could not read a clearsigned
  message, and left a header-less message outside any article (all fixed; `site/threads` rebuilt);
  sig-fresh's test failed under a deep temp folder (gpg's socket-path limit; fixed).
- `doc/polygram.info` rebuilt (makeinfo 7.1, in the cloud workspace; it is not on the VM).

## The one command (git, on the host)

    for f in bin/* tests/*.sh skills/*/scripts/* skills/*/tests*.sh skills/*/tests/*.sh; do [ -f "$f" ] && [ "$(head -c2 "$f")" = '#!' ] && ! git check-ignore -q "$f" && printf '%s\0' "$f"; done | xargs -0 git add --chmod=+x --

It stages those scripts with the run bit (new ones included), which a commit then records.

## Tests (run here after everything)

- `python3 -m unittest discover -s tests`: 459 tests, OK.
- 32 of 32 `tests/*-tests.sh` green; every `skills/*/tests*` self-check green.
- candor_gate `--prove-red` (every mutant red, every control green), pb1ck `--prove-red` (63 OK),
  and a mutant for each new promise (listed in ChangeLog).

## JUDGED

- [MINE] At travel, 7 of 58 skills pass candor-gate; all 51 holds are unsigned skills, which your
  signed build clears, and 7 of them also hold on person-data or egress (read by the receiver).
  Before today 37 passed, some only on archived signatures. *Falsifier:* after your signed build,
  `sh skills/candor-gate/scripts/candor_gate.sh --travel skills/lens` still reads HOLD provenance.
- [PLATFORM] `c4/bin/__pycache__` appeared today (a test run); I cannot delete in c4. `make clean`
  in C4, or leave it.

## Later: your build checked, the skill-set design, the roll

- **0.8.90 as you built it:** 58 of 58 skills and 58 of 58 bundles verify against your key; pb1ck
  CLEAN of what was checked; the note is in releases/0.8.90 and in Mentat's seat (dated with the
  shipboard date, 2026-09-24, which no release moves yet: your call).
- **Designed, not built:** c4 `h/DESIGN-2026-09-28-default-skill-set.md`. Two answers of yours
  decide the build: whether the floor of seven sits on top of the percentage (GRAIN 14) or inside it
  (GRAIN 7, no picks), and the floor itself (garden-usage for the ??, consent-gate in drift's slot).
- **Rolled:** this model v17, C4's 0.8.7, both continuity pairs, seven terms as hand-turning.
- The receipt below now also covers these files (`HANDBACK-2026-09-28-rulings.sha256`).

```
LENS · your rulings on the hardening hand-back · 2026-09-28
a  my view: most of what the hand-back left for you was already decided by your TERMS and your earlier words; the rest was work I should have finished.
b  the view I ascribe Corwin: finish it; license it the way we all agreed; let examples and our own skills travel; put the choice at the receiver's door.
c  their pull on mine: made me move the always-on hold to the receiver instead of rewording your skill, and read "the attached new version" from the tree rather than stop to ask.
d  my pull on theirs: asks you to accept that 51 skills read HOLD at travel until your signed build, and that "the attached new version" was my reading of Bryant's r2 drop.
persona / inverse: Bryant says the credit reads the way he writes it / the inverse says a copyright line added by an agent is still the makers' call, so check the two lines read as you meant.
principles reframe: 1. The license names every maker on the door. 2. A check now says where it stands and what it did not read, at every setting.
notes: written
```

Authored by Mentat (for Corwin), 2026-09-28. Unsigned.
