# retro-apply: prior-instruction (and nongnu-steward) over the 2026-09-26 secrets/licence turn

Run 2026-09-26, at Corwin's word ("see if there are advances ... \retro-apply"). The prompt re-run:
this session's own handback of the same evening (two checkers, provenance at intake, wiring at the
boundaries). Skill: prior-instruction (soft skill, AS4CE0001/SOFT-SKILLS). Nothing below is undone;
the delta is the deliverable.

## Delta

    #   decision (original handback)            under prior-instruction                               status
    1   IDENTICAL output for the two checkers    DECIDED-BY default: the house's two-reader rule      STANDS, relabelled
        ("your two minds: I went with")          (seams/dagger: a disagreement must be loud). Not his
                                                 instruction; he was of two minds. [conf 80% · checked:
                                                 the spec's fallback is one line per kit]
        CORRECTION 2026-09-26 (later): "Not his instruction" disowned the call instead of naming its
        source; the row reads: DECIDED-BY default (the house's two-reader rule, for Corwin).
        h/NOTE-2026-09-26-mine-is-for-corwin.md.
    2   "retire or keep secret-sweep is yours"   DECIDED-BY instruction: facts/secret-sweep-before-push  CHANGES -> done
        (ROUTED)                                 (his GO 2026-07-28) and facts/secret-sweep-estate-reach
                                                 (his GO 2026-09-14) name the tool and its interface;
                                                 "support both" is his standing answer. Kept the name,
                                                 interface and HIGH/warn tiers; reading goes through
                                                 sb1rn. [conf 90% · checked: tests/secret-sweep-tests.tcl
                                                 8/8, and v1 FAILS that spec (echoes secrets, '#' bug)]
    3   "please re-sign intake, release,         SEAT, after drawer-vs-door names the reader: intake,   CHANGES
        skill-sign"                              release and pb1ck carry no .asc (no reader asked for
                                                 one). skill-sign is re-signed by his next make dist
                                                 sweep. The one ask left: bin/secret-sweep.asc (door:
                                                 a signed fact of his names the tool).
                                                 CORRECTION 2026-09-26: the original line asked for
                                                 signatures on two files that never had one.
    4   offered "clearance could stop pb1ck"     DECIDED-BY instruction: "the chance to warn a user     CHANGES -> offer
        (a fork)                                 they aren't aligned ... on the way out" (his words,     withdrawn
                                                 this evening). Warn it is.
    5   "chat gate credential-lines: switch to   DECIDED-BY instruction: his newest word to that         CHANGES -> fork
        kept-in-private-work" (a fork)           session, "keep your gates, make them optional", and     withdrawn;
                                                 "when we ingest chat our defaults are toward helping    RETAINED seam
                                                 the user/system guard the privacy of users". Two
                                                 domain-scoped rulings, not a conflict: tech intake
                                                 keeps secrets at ingest, chat intake withholds by
                                                 default. Seam recorded in c4/MEMORY.md.
    6   transcript access (asked for the        SEAT: a folder request refused by an automatic check,   STANDS
        desktop session folder)                  not by the plugin; not retried. He pasted the log.
    7   Makefile patch for make dist            SEAT: the Makefile is write-protected from here.        STANDS
    8   session hand-off hash offered in         DECIDED-BY instruction: "More tests are always          CHANGES -> done
        READING + ACK                            welcome". CORRECTION written in READING (dated, the
                                                 original line kept); ACK now offers the L5 test.
    9   (no row: the search was never run)       GAP: before building, the noun "secret" was not         FOOTNOTED
                                                 looked up. `ls bin facts | grep -i secret` returns
                                                 bin/secret-sweep and two facts of his. The estate-reach
                                                 fact already says "that gap cost a duplicate tool";
                                                 it happened again. The build was still his ask (two
                                                 checkers), so nothing is thrown away; the tool he
                                                 already runs now reads through them.
    10  licence notices on the new files         nongnu-steward ns1hd: 7 findings (3 SHORT-NOTICE, 1     CHANGES -> done
        (not considered)                         NO-COPYRIGHT, 3 NO-NOTICES). Fixed on the 5 project
                                                 files (DECIDED-BY default: house licensing, code
                                                 GPL-3.0-or-later, writing CC BY 4.0). The two letters
                                                 in from-bryant/ are left bare (a letter is not a
                                                 project file; default, named).
    11  next GRAIN (Python, V8, Emacs, Perl)     GAP, and the obvious build: large upstream trees carry  NAMED, not built
        not considered by the boundary design    secret-shaped TEST FIXTURES (CPython's Lib/test holds
                                                 PEM private keys; not checked here: Debian strips that
                                                 folder, so ~95% from memory, not a count). Vendored and
                                                 re-published, they would stop every boundary. Build:
                                                 a hit in a file whose bytes match an intake record
                                                 from a PUBLIC source is reported KNOWN-UPSTREAM, not a
                                                 stop (republishing public bytes discloses nothing
                                                 new). Needs one new intake field, ORIGIN (public URL
                                                 or not). Test: a planted key in a public-origin file
                                                 reads KNOWN-UPSTREAM; the same bytes from a private
                                                 drop still stop.

## Faculties

Flexible: prior-instruction, retro-apply, nongnu-steward (ns1hd, --suggest), drawer-vs-door (by
name only), facts/ grep, the other session's pasted log, tclsh for a fourth test language.
Pruned recipe (reproduces rows 2, 3, 5, 9): `ls bin facts | grep -i <noun>` for every noun of the
decision, then `ls <file>.asc` before any signing ask. Two commands.

## Gap footnote

Checked: c4/facts (2 hits on "secret"), c4/bin (1), c4/h (3 PATCH/NOTE/prefs mentions),
AS4CE0001/advice (none on this topic), this session newest first. Terms: secret, sweep, leak,
licence, license, clearance, credential. Miss chance: about 9% (invented, house set): c4/g and
the registry tables were not searched by noun.

---
Copyright (C) 2026 Corwin Brust <corwin@bru.st>. Authored by Mentat (for Corwin).
SPDX-License-Identifier: CC-BY-4.0 <https://creativecommons.org/licenses/by/4.0/>.
