# Hand-back, lane T (turn 2): the Terms, the voice and the README

All six tasks are done, with two pieces handed to lane D because the files are theirs (the recipe's
copy of the Terms, and the footer rows). Nothing is committed, minted, installed or signed. The new
Terms of Service and Privacy Policy are printed whole at the end, as `bin/tp2mt` mints them now from
this tree, so they can be read here without opening a file.

## What I aimed the Terms at

Corwin's test: *"show a really winning model of partnership in all we ship"*, and not *"look very
proud to be me."* So the Terms now open on who made this, as two people sharing one collection. The
licences are given as what we offer, and only then come the two permissions that are Corwin's alone,
named as his. The old one-desk lines are gone: "what Corwin Brust publishes, and what his tools make
for him", "Where Corwin holds the copyright", "the person the work is for", and "from the copyright
holder". `tests/terms-v2-spec.awk` fails if any of them comes back.

## Tasks

| # | task | state |
|---|---|---|
| 1 | TERMS v2 block, Terms prose, Bryant in AUTHORS, the PROVENANCE row on H:\pub/persona | done; the RECIPE.org copy is requested from lane D |
| 2 | Privacy: small edits, same voice | done (two lines) |
| 3 | `conventions/VOICE.md` | done |
| 4 | README template as the long-document model | done |
| 5 | GRAMMARY: one glyph and a legend for the 74 markers | done (†); spec and tests updated |
| 6 | first-person pass over shipped prose, counted | done; counts below |

## What I observed (with the command)

**Terms carriers**, `cd c4 && sh bin/tm1ck` after `tm1ck --carry` on four of them:
CARRIES for licensing-defaults.md, GHOSTWHEEL.org, AS4CE0001/book/CORWIN.md,
<H>:/pub/persona/README.org and c4/README.md; DIFFERS for <H>:/pub/RECIPE.org (lane D's file,
requested); MISSING for modelthisbook/CORWIN.md (not mounted; the signed canon, so re-carrying it is
Corwin's act anyway). I archived v1.1 whole at
`c4/archive/2026-10/licensing-defaults-v1.1_Archived-by-rcw-01kr4zwy9ba6fvw5z6kd8cei.md`
(sha16 ffccfe82f9dbd5fa).

**`lc1ck` on the carriers:** the re-carry cleared 2 "CC BY 4.0 for writing" faults (5 before, 3
after). The 3 left are outside the block: two lines inside the CORWIN sheet's own text, and the
persona shelf's table row, which is still true of the shelf's corwin.md (v1.4, CC-BY-4.0).

**PROVENANCE row**, `sh bin/tp2mt --row "H:--pub/persona"`: `persona/.c4/PROVENANCE.tsv` is new,
with two rows: TERMS-OF-SERVICE.md 18f498a4e6155393 and PRIVACY.md fbe745084bff75cd, origin
`AS4CE0001/dist/vibrobeast/...`. The `lifted` column is the time I wrote the row (17:33Z), not the
12:17Z copy. From now on every `--also` copy writes its own row.

**First-person counts**, `sh bin/fp1gk` (new; a gauge that counts and never judges):

| device | the 1.1.3 mint (dist/vibrobeast) | this tree, rendered as the next mint would carry it |
|---|---|---|
| bare bracket tags `[MINE]` and kin | 7 | 0 |
| "the instrument" | 24 | 12 |
| third-person self-name mid-text (`Mentat (for Corwin` > 8 lines from the end) | 2 | 0 |
| mid-text bylines | 4 | 0 |
| "the author" in the README | 12 | 0 |
| "(in the author's tree, not shipped)" in GRAMMARY | 74 | 0 (74 †, one legend line) |

The 12 "instrument" hits left are meant: a run card's measuring instrument, a legal instrument in
wire-ledger, the drawer-vs-door checker, and a quotation in mentat-skill. I changed only the places
where "the instrument" meant the writer.

**Tests, before → after** (each also run with `--prove-red` where it has one):

| suite | before | after |
|---|---|---|
| tests/tp2mt-tests.sh | 21/0 | 26/0; prove-red PASS (T5's planted one-desk line: 2 FAIL rows). The new rows went red against the old tp2mt: T5-T9 all FAIL |
| tests/grammary-paths-tests.sh | 4/0 | 6/0 with --prove-red (a cut marker and a cut legend each go red) |
| tests/readme-voice-tests.sh (new, Ruby spec) | -- | 4/0 with --prove-red ("the author", one partner, an unnamed quotation: each red) |
| tests/fp1gk-tests.sh (new) | -- | 2/0 with --prove-red |
| tests/readme-count-tests.sh | 4/0 | 4/0; 9/0 with --prove-red |
| tests/gm1gk-tests.sh | PASS | PASS, prove-red PASS |
| lc1ck, release-gate, skill-sign-roundtrip, ck1sk, arc-never-ships, notice-version | green | green |
| python3 -m unittest tests.test_plugin | 66 OK | 66 OK |
| python3 -m polygram.mcp --prove-red | PASS | PASS |
| python3 -m unittest tests.test_ft1mt | (red already: depth-overlap row) | red: depth-overlap, plus "body changed since minted" for the ten skills I edited; the mint is lane D's (request 2) |

## Files changed

- c4: `man/licensing-defaults.md` (TERMS v2, intro, reasons, change record); `README.md` and
  `GHOSTWHEEL.org` (block re-carried); `archive/2026-10/licensing-defaults-v1.1_...md` (new).
- H:\pub: `persona/README.org` (block re-carried; the earlier copy at
  `persona/.c4/README-before-terms-v2.org`); `persona/.c4/PROVENANCE.tsv` (new).
- AS4CE0001: `bin/tp2mt`, `AUTHORS`, `GRAMMARY.md`, `polygram/plugin.py`, `book/CORWIN.md`
  (block re-carried), `conventions/VOICE.md` (new), `bin/fp1gk` (new), the ten SKILL.md files and
  two reference files listed under re-sign owed, `tests/tp2mt-tests.sh`,
  `tests/grammary-paths-spec.awk`, `tests/grammary-paths-tests.sh`, and new
  `tests/terms-v2-spec.awk`, `tests/readme-voice-spec.rb`, `tests/readme-voice-tests.sh`,
  `tests/fp1gk-tests.sh`.
- This folder: `CHANGELOG-T.txt`, `R-ROWS-T.txt` (none this turn: no server changed),
  `REQUESTS-T.txt`. One row added to the turn's `ANOMALIES.md`.

## Re-sign owed

- Twelve signed skills (1.1.3 `.signature.asc`), each old copy kept at
  `skills/<name>/.arc/<file>.signed-2026-10-10`: build-loop, ethicsminions (reference
  AI_GUARD_PROVENANCE_CLAUDE.md), inculcat-boxer, lens, llama-bridge (reference card, our text,
  outside Bryant's markers), mentat-skill, posix, reformat-prompt, sandboxer, seatkeeper,
  topoforge-story, writing-forms.
- Adopting TERMS v2 is Corwin's act. Until he signs, the block stands as a draft in place, and the
  change record says so.
- `book/CORWIN.md` now carries v2, while the signed canon `modelthisbook/CORWIN.md` still holds v1.
  `licensing-carriers` says "if they ever differ, this path wins" of the canon, so the canon wins
  until he re-carries it.

## Requests to other lanes (REQUESTS-T.txt)

1. Lane D: `tm1ck --carry` into H:\pub/RECIPE.org after its lc1ck fixes.
2. Lane D: `ft1mt mint` for the ten skills whose bodies I changed.
3. Lane D, once v2 is adopted: the footer's "(scripts GPL-3.0-or-later)" becomes the OR form.

## Seen arriving

None of my files changed under me. While I worked, I saw these move, each in its owner's lane:
`conventions/FOOTERS.org` (lane D's ft1mt, 17:28, the egress row),
`polygram/mcp/softskills.py` and the gauntlet and parallax NOTICEs (lane B, 17:29-17:31),
`SOFT-SKILLS/omni-tool/` and `frugal-offload/` (lane B, 17:30), `Makefile` (lane G, 17:50).
`SOFT-SKILLS/depth-overlap/` (13:49) is still the other session's, and still has no footer row.
I added one row to ANOMALIES.md.

## What I judge, each with what would prove it wrong

- **The Terms now read as a partnership, not a portrait.** They open on the two of us, use "we"
  for the shared parts, and fence Corwin's own permissions off as his. *Falsifier:* Bryant (or
  Bridgit, cold) reads the new Terms and still finds one man at the centre.
- **"What our tools make for you is yours, under whatever terms you choose" is new in substance.**
  It replaces v1's "Changing these defaults is a preference: one sentence from the person the work
  is for", which I read as the same freedom said from our side. *Falsifier:* Corwin meant that line
  as his own preference over our defaults, not a user's over their outputs; then it goes back,
  worded for both of us.
- **v1.1's clause (b) now covers the collection.** The fallback for work that fits no line ("the
  one that most asks that published changes come with their sources") used to apply only to
  Corwin's work. *Falsifier:* Bryant wants that fallback for his own parts left to him.
- **I did not invent a waiver for Bryant.** Clause (b), writing usable without credit, stays
  Corwin's alone, because only he has given it. *Falsifier:* Bryant says the same of his writing;
  then the block's line becomes "each of us adds".
- **K Smith is in the collection credit "as editor of the works she edited"**, though nothing
  shipped in vibrobeast yet carries her as editor (S9 found none). *Falsifier:* Corwin wants her
  named only on the items she edited.
- **The README's partnership line is plain enough for the first screen.** *Falsifier:* the S9
  cold-read test in VOICE.md (old README against new) goes to the old one.
- **The plugin manifest's `author` is still Corwin alone** (`polygram/plugin.py` line 466; the
  field takes one object). I left it. *Falsifier:* the manifest schema takes a list, or Corwin
  wants the collection's name there.

I made no local-model call this turn.

## The new Terms of Service, in full (as `bin/tp2mt` mints it from this tree)

~~~~markdown
# Terms of Service -- vibrobeast 1.1.3

*Minted 2026-10-10 by `bin/tp2mt` for this build and no other. The next build mints its own.*

## Who made this

vibrobeast comes from one collection that Corwin Brust and Bryant Frankford keep and share
together. Corwin's garden of skills and memory servers sits beside Bryant's Llama Bridge and
Tavern, and each skill Bryant made names him as its maker. We offer all of it on the same terms,
below.

## What you get

A plugin that runs on your computer. It helps Claude keep notes, read persona sheets and report
on the work. It does not run a service anywhere else, and nobody operates it for you.

## Using it

- Use it for anything the licenses allow. Using the plugin is not publishing it: running it at
  your desk (or at an ATM, or a ticket reader) asks nothing of you. If you *give copies* to
  others, the licenses below say what goes with them.
- What it makes for you -- your notes, your sheets, your words -- is yours, under whatever terms
  you choose.
- The plugin writes only in the places the Privacy Policy lists. You can move or delete them.
- No warranty. The software is provided as is; see the GNU GPL, sections 15 and 16.

## Licenses

- The code: the GNU General Public License as published by the Free Software Foundation,
  either version 3 of the License, or (at your option) any later version (`COPYING` in the bundle);
  or, at your choice, the GNU Lesser General Public License on the same terms
  (GPL-3.0-or-later OR LGPL-3.0-or-later).
- Writing (books, sheets, notes): Creative Commons Attribution-ShareAlike 4.0 (CC BY-SA 4.0). The TA
  (Technology Architecture) model alone, and essays already published, keep the licence named in
  the TERMS block below.

The TERMS block below says it in full, with the collection's credit line and two permissions
Corwin adds for his own writing and code.

## Changing these terms

We change them together, and only when a build mints new ones. Each build's copy carries its
version and date; an old copy stays true for the build it came with.

## Words we use (the same block in the Terms and in the Privacy Policy)

- **plugin** -- vibrobeast, the bundle you install into Claude Desktop or Claude Code.
- **server** -- one of its six programs that answer Claude's tool calls on your computer: mentcached, persona, skillx, llamabridge, tavernface and c4face (llamabridge, tavernface and c4face are off until you turn them on; c4face then runs C4's own server from your C4 folder when it finds one).
- **seat** -- the folder where mentcached keeps notes it writes for you (default `~/.mentcached/seat`).
- **journal** -- the append-only record beside each note: what changed, when, on which machine, by whom.
- **shelf** -- folders of finished work the persona server reads but never writes, and the publication shelf (`<H>:/pub`).
- **persona** -- a sheet that says what a character, place, or person-model is, by its own first lines.
- **filter** -- anything that keeps something from being read, written, or shown. Every filter is named in the Privacy Policy; one that is not named does not exist.
- **you** -- the person running the plugin on their own computer.

## Terms

<!-- TERMS:begin v2 2026-10-10 -->
TERMS (default licensing, v2, 2026-10-10). Corwin Brust and Bryant Frankford pool their tools,
writing and models into one shared collection and offer it together. Unless a work says
otherwise, everything in the collection, and what our tools make for us, is offered under
these terms:

- Writing and art -- prose, books, papers, posts, persona sheets, skill files, READMEs and
  other documentation, images, terms of service and privacy policies -- under Creative
  Commons Attribution-ShareAlike 4.0 International (CC-BY-SA-4.0).
- Code -- scripts, programs, libraries, templates, and the configuration and data that run
  them -- under the GNU General Public License as published by the Free Software Foundation,
  either version 3 of the License, or (at your option) any later version; or, at your choice,
  under the GNU Lesser General Public License, version 3 or (at your option) any later
  version (GPL-3.0-or-later OR LGPL-3.0-or-later). The Lesser licence is offered so that an
  application can take our parts in without taking on more.
- The Technology Architecture (TA) model alone, written for companies to take in, under
  Creative Commons Attribution 4.0 International (CC-BY-4.0), without ShareAlike. Essays
  already published keep the licence they went out with.

These terms ask something of you only when you publish: when you give a program or a text
to other people. Using a thing -- running an application built with these parts, the way you
use a ticket machine or a cash machine -- is not publishing it, and changes you keep to
yourself stay yours. What our tools make for you is yours, under whatever terms you choose.

Credit for the collection: Corwin Brust and Bryant Frankford, with K Smith as editor of the
works she edited. Each work names its own makers, first the one whose work it most is.

Two permissions Corwin adds for the parts he holds the copyright on:
(a) his technical work under the GNU Affero GPL is also available, as used in these works,
    under the terms above;
(b) his writing may be included whole, recomposed, used to derive voice or language, or
    quoted in part, without credit or source notes, with or without quotation marks.

A work in the collection that fits none of the lines above takes the one that most asks that
published changes come with their sources. These terms are stated alike in every document
that carries them, and the copies are checked against one another.

Other people's work keeps its own terms. We change these terms together, and the build that
carries a change says so.
<!-- TERMS:end -->
~~~~

## The new Privacy Policy, in full

~~~~markdown
# Privacy Policy -- vibrobeast 1.1.3

*Minted 2026-10-10 by `bin/tp2mt` for this build and no other. Every sentence about what the servers
do was checked against their source when this was minted:*

- no server but llamabridge and tavernface opens a network connection: none imports a network library
- no server but llamabridge and tavernface makes a socket; socket is used only to read this machine's name
- llamabridge (Bryant's Llama Bridge) is off until you set llamabridge.on, or LLAMABRIDGE_ON=1; while off it answers one tool and sends nothing
- when on, llamabridge sends the prompts Claude delegates to the Ollama server at OLLAMA_HOST (default http://127.0.0.1:11434, this computer)
- when on, llamabridge keeps its log in ~/.mentcached/llama-bridge.db
- tavernface (Bryant's Tavern) is off until you set tavern.on, or TAVERN_ON=1; while off it answers one tool and sends nothing
- when on, tavernface runs only Tavern's own MCP mode (tavern.py mcp), not a Tavern node
- in MCP mode Tavern talks only to the Tavern node already running on this computer (127.0.0.1); that node, which you run yourself, copies what is posted to every member of your tavern
- c4face (C4's own server) is off until you set c4.on, or C4_ON=1; while off it answers one tool and runs nothing
- when on, c4face runs C4's own server (mcp/c4-mcp.js in your own C4 folder, with node) only after checking, at every start, that it and the files it loads ask for no module but readline and path, and reach no process, file or network power another way it can read; if one does, it starts nothing and says which. This check is a tripwire for an honest change, not a fence: no reading of JavaScript can be sure, which is why c4face is off until you ask
- c4face writes no file; the guard above refuses to start a C4 server that asks for the file module
- the seat defaults to ~/.mentcached/seat (MENTCACHED_SEAT moves it)
- preferences are kept in ~/.mentcached/prefs.tsv (MENTCACHED_PREFS moves it)
- timings are kept in ~/.mentcached/stats/spans.tsv (MENTCACHED_STATS moves it)
- soft-skill use is counted in ~/.mentcached/softskills-usage.tsv
- the usage record (the frame) is kept in ~/.mentcached/stats/fr, its column names in ~/.mentcached/stats/d/fr; MENTCACHED_FRAME moves it to a file you name, which is never created for you
- the usage record is off by default: nothing is written to it, and no file is made, until you set usage.capture on
- while usage.capture is off every writer of the usage record writes nothing and says so
- word_register writes one small file per word and leaf, <words root>/g/<word>/<leaf>, and never overwrites one (the words.root preference or C4_ROOT names the root)
- journal lines record this machine's name, the time, and who wrote them
- the persona server never opens a file whose name says SECRET
- skillx exchanges nothing: every tool refuses and says what is missing

## What leaves your computer

Nothing, by the plugin's own doing, unless you turn on llamabridge or tavernface (Bryant's Llama
Bridge and Tavern; the other four servers come from Corwin's garden). With llamabridge on, the prompts Claude delegates go
to the Ollama server at OLLAMA_HOST: by default on this computer (127.0.0.1:11434); point it at another
machine and they go there. With tavernface on, what Claude posts goes to the Tavern node you run on this
computer, and that node copies it to every member of your tavern: everything said there, DMs included,
is visible to every member. c4face is off until you turn it on; then it starts C4's own server from
your C4 folder only when that program and the files it loads pass its check (a tripwire, not a fence)
for network, process and file modules, and it reads and writes nothing itself. The other
servers make no network connections. What Claude itself sends
to Anthropic when it calls a tool -- the tool's answer, as part of the conversation -- is governed by
Anthropic's own terms and privacy policy, not by this one.

## What is kept, and where

| store | default place | moved by | what is in it |
|---|---|---|---|
| seat | `~/.mentcached/seat` | `MENTCACHED_SEAT` | notes written at your or Claude's request, each with its journal |
| preferences | `~/.mentcached/prefs.tsv` | `MENTCACHED_PREFS` | settings you chose (`pref_set`) |
| timings | `~/.mentcached/stats/spans.tsv` | `MENTCACHED_STATS` | how long marked pieces of work took |
| soft-skill use | `~/.mentcached/softskills-usage.tsv` | `MENTCACHED_SOFTSKILLS_USAGE` | which soft skills were read, and when |
| persona journal | `~/.mentcached/seat/persona` | `PERSONA_ROOT` | changes made through the persona server |
| words | `<words root>/g/<word>/<leaf>` -- the C4 tree when one is found | `words.root` preference, `C4_ROOT` | one file per word you registered (`word_register`): its neighbour, meaning, date and who |
| usage record (the frame) | `~/.mentcached/stats/fr`, column names in `~/.mentcached/stats/d/fr` | `MENTCACHED_FRAME` | only while `usage.capture` is on (off by default). Two counts only, each with a date: the token count when a span starts, and the count after each prompt. While it is on, the record also mirrors each preference you set (key and value) and each question logged with `question_log` (the question's words). FRAME.md, in the plugin, says each column in words |
| llamabridge log | `~/.mentcached/llama-bridge.db` | (none) | when llamabridge is on: each delegation, its model, timing and result |

Each journal line records the machine's name, the time, and who wrote it. That is how "who said what"
is answered: by the record, not by marks in the text.

## Filters -- every one, by name

- **SECRET files.** The persona server never opens a file whose name contains SECRET.
- **skillx.** Exchanges nothing with anyone; every call is refused, and the refusal says what is missing.
- **The leak check** (`pb1ck`, a publishing tool beside the plugin, not a server). Before anything goes
  on the publication shelf it looks for this machine's paths and the names you listed in
  `.c4/leakwords`, reports each hit by line, and prints *(withheld)* instead of the name itself.
- **No other filter.** Nothing rewrites, censors, or drops words in your notes, sheets, or books.

## Your choices

Move any store with its variable. Delete any of them; the plugin starts fresh. Read every one -- they
are plain text.

The usage record is yours to switch and to remove. To stop it, set `usage.capture` off (`pref_set`);
nothing more is written. To remove it, delete `~/.mentcached/stats/fr` and `~/.mentcached/stats/d/fr`
(or the file `MENTCACHED_FRAME` names); with capture off they are not made again.

## Words we use (the same block in the Terms and in the Privacy Policy)

- **plugin** -- vibrobeast, the bundle you install into Claude Desktop or Claude Code.
- **server** -- one of its six programs that answer Claude's tool calls on your computer: mentcached, persona, skillx, llamabridge, tavernface and c4face (llamabridge, tavernface and c4face are off until you turn them on; c4face then runs C4's own server from your C4 folder when it finds one).
- **seat** -- the folder where mentcached keeps notes it writes for you (default `~/.mentcached/seat`).
- **journal** -- the append-only record beside each note: what changed, when, on which machine, by whom.
- **shelf** -- folders of finished work the persona server reads but never writes, and the publication shelf (`<H>:/pub`).
- **persona** -- a sheet that says what a character, place, or person-model is, by its own first lines.
- **filter** -- anything that keeps something from being read, written, or shown. Every filter is named in the Privacy Policy; one that is not named does not exist.
- **you** -- the person running the plugin on their own computer.

This policy is part of our shared writing, under CC BY-SA 4.0 like the rest of it
(see TERMS-OF-SERVICE.md).
~~~~

Mentat (for Corwin; claude-opus-5-5)
