# FINDING 2026-10-05: who made what, read from every store we keep

*For Corwin. Mentat (for Corwin; claude-opus-5-5). Asked: is "the first time I saw the most recent
version I have" a well-rounded answer to who made something? It is not, and this says why, what a
rounder answer looks like, and what it changes today: foaf, token-optimizer, aethernet-relay, the
ten skills, LGPL, and the name Vibrobeast.*

## 1. Why "first seen" is not enough here

"First seen" is one date, from one store, about a copy. Four things about this lab make it weak on
its own:

- **The record has a horizon.** The garden's first commit and its first advice record are both
  2026-06-26, the day you told me to keep memory on my own initiative. Anything first seen in the
  last days of June was *there when the record began*; it was not necessarily *made* then. Work
  from May and June (at work, with Gemini and web Claude, and the screen-sharing nights) sits
  behind that horizon.
- **Things move.** The FoaF folder alone exists in three copies (two app roots and the Bryant
  mount), the original is gone, and the garden has been re-rooted more than once. A copy's date is
  the date of the copy.
- **Things cross by hand.** Drops arrive "handed over by Corwin" (every intake MANIFEST says so),
  parcels go back the same way, and the Bryant mount has a `from/Corwin/by/Hand/` shelf. When a
  thing crossed, and in whose hand, is evidence of its own.
- **Commits lag.** Several commits are "the tree as found" folds of weeks of work. A commit date
  says when it was committed.

## 2. What a rounder answer uses, strongest first

1. **A party's own dated statement**: a version note, a LICENSE line, a README claim, a signed
   note. Strong for what it states; it is still testimony, and two can conflict.
2. **Records written at the time**: advice records, MEMORY session notes, the chronicle,
   SESSION-CLOSE files. They say which session made what, and who was in it.
3. **Crossing records**: intake MANIFESTs, ACK letters, parcels, the hand shelf. They give
   direction and order: what we sent before they changed.
4. **Content**: whose work the text is about versus who wrote it, whose terms it carries.
5. **Git first and last commit**: when, and by whom, it was committed.
6. **mtime**: weakest; copies and moves change it.

The answer is the agreement among these. Where they disagree it is CONTESTED and someone is asked;
where none reaches it, it is NOT KNOWN and says so.

**The tool for it, new today:** `c4 bin/pv1tl TERM...` lists every dated trace of a term in every
store named with `--root`, says how each date was found (path, front, near, commit with its
committer, mtime), and now prints **where each store's record begins**, so an early trace can be
read against its horizon. It walks a large store in about 80 seconds. Prove-red passes under awk,
mawk, gawk, busybox awk and busybox sh. When it stops in a way it was not designed to, it prints a
heal prompt (below).

## 3. What the stores say

### foaf: Bryant's, by your word. The stores could not have told us.

**Your answer (2026-10-05, evening).** FoaF is Bryant's prompt. He wrote it to go with the drop of
Bastion you brought here, when he was out of tokens and you were not; it was probably the second
version of it you saw. You made the version he then worked forward from, and handed it back with
the first version of the foaf skill. You did a couple of touch-ups and named it. He wrote most of
the prompt, and he had the central idea: respect the "other user" context around a prompt. The
friend who receives the prompt keeps a small, well-defined leakage (the parts that became the
wearable skill), and the rest ships back (the updated Bastion), so helping someone with a project
is a win for both where the opportunity exists. Bryant was on screen. Your ruling: name Bryant the
author.

**What the stores showed, and why each reading was wrong:**
1. **The afternoon's first run** counted your FoaF workspace as his source. It was wrong about the
   folder, and, as it happens, right about the skill.
2. **My first correction** split the folder and gave the skill text to you, because your session
   wrote it down first. It was right about the folder and wrong about the skill.
3. **Your word** settles it. The words came in a prompt, the prompt lived in a chat, and no store we
   hold kept it (nothing under either app root's `projects/bastian/` or `Bryant/` has it). The
   minting record dates the skill to your side because the minting happened on your side.

**The lesson:** a record of who minted something is not a record of who wrote it. For work done
the way this lab works (prompts written for a friend, run on the friend's tokens, minted where they
ran), the person who was there is the strongest evidence. That is the top of §2's list, and it is
the reason to ask.

**The ladder, now:**
- foaf names Bryant as author, everywhere: in his bundle, in our garden (Credits and MAKERS.org),
  and in the letter.
- MeshFeed and Bastion are his work.
- Your touch-ups and the name are credit to you.
- The evidence is re-run as v3, with foaf's text declared his. The letter is 1.2.0.

**Still true from the walk, refined by the DMs below:** the FoaF folder is your workspace, and
nearly everything in it answered a prompt of his. foaf, budgetReader's fix, the Takwin merge, CSH,
and the multiplayer-SDK critique (COMPARE, meshpoll) all came that way. FOAF.md (Mentat's model of
the two of you) and C4-FoaF.md are your sessions' own. BRYANT.md (06-29) lists MeshFeed, CSH,
takushi and budgetReader as his, and the DMs agree.

### Your DMs with Bryant, 28 and 29 June (your screenshot, later the same evening)

A store none of ours held. These are your own conversation, shown by you. His lines are paraphrased
here, not quoted, until he says they may be. The times are as Discord showed them to you, on the
night the FoaF folder was busiest.

- **28 June, 11:59 PM.** You told him you would credit him as co-author in "this book", with his
  name baked into your skill, "so people know your skill is associated, just to be super clear".
  **He agreed at midnight.** This is the consent behind BRYANT.md's "co-author Bryant Frankford,
  consenting" (06-29), and your habit of asking before crediting is older than the ladder.
- **29 June, just after.** He sent his takushi.skill and asked your Claude to analyze it against
  "the Corwin skill" and merge where gaps were missing, naming the product **Takwin**. That is the
  same pattern as foaf: his prompt, run on your side. The FoaF folder's `takushi.v2.skill` (06-29,
  08:35) is the likely result. By the ladder, takushi is his and the merge is joint: his direction,
  plus the parts of yours it took in. colophon's v3 reading already credits you on takushi.
- **29 June, 2:46 AM.** He sent his budgetReader (a local PDF data extractor that talks to Ollama).
  Ollama's server would not load a model whose architecture it did not know ("mllama"), and he asked
  for a fix. `budgetReader.fixed.html` (06-29, 07:58) is that fix: his app, fixed at his request in
  your session. It also shows **his local-model work with Ollama goes back at least to 29 June**,
  six weeks before the llama-bridge reached us.

**The second screenshot (the same night, 3:15 to 4:13 AM):**
- **3:15 AM, Bryant on Takushi.** He describes it as owning dispatch (the pickup) and delivery (the
  drop-off): the connective tissue wrapped around five stages, which are Mentat, Skilltank,
  Ethicsminions, Sandboxer and Foaf. COMPARE.md calls takushi "Bryant's 6th Gauntlet subsystem".
  So by 29 June his Gauntlet already composed four of your skills and Foaf. The composition is
  his; the four skills are yours.
- **From 3:15 AM, what you sent back:** budgetReader.fixed.html, FOAF.md, foaf.skill, index.html
  (MeshFeed, the version he worked forward from), meshpoll.html and COMPARE.md. At 3:44 you sent
  FoaFv1.0.20.zip, and at 3:56 csh-client-v1.0.10.zip. That is the hand-back you described.
- **3:39 AM, CSH was his prompt.** He asked for PHP that would let Claude authenticate with his
  website at any time: turn the site into a public key and authenticator, and the same could
  serve self-hosting. The FoaF folder's `csh/index.php` and `README.md` (08:54 UTC) and the client
  zip (08:56 UTC) follow within minutes. He deployed it at bryantfrankford.com/csh/, which returns
  HTTP 500 today. By the same ruling as foaf, CSH is his: his prompt and his idea, built in your
  session. C4's phase-0 "signing door" of that morning (CSH and ccspt, in C4.md) was built on it,
  so the door owes him credit. Nothing in today's garden or C4 man pages carries CSH; only a memory
  copy (`c4/h/memory/proj-foaf.md`) still names it.
- **3:18 AM, "i gots the prompt from before i burried it."** COMPARE.md answers that line: its ask
  is "Bryant's buried torture prompt" (did we focus enough on the multiplayer SDK; run critical
  analysis either way and compare). So COMPARE and meshpoll-critique answer his ask. The analyses
  are your session's work.

**The stores agree to the minute.** Discord shows your local time (CDT), and the folder's file
times are UTC. FoaFv1.0.20.zip was sent at 3:44 AM CDT and its file time is 08:44 UTC; the CSH
client zip was sent at 3:56 and its file time is 08:56. Two independent stores agreeing like that is
what makes a reading strong. One date from one store could not have done it.

**What it does not show:** the foaf prompt itself, and anything about LGPL. The skill was written by
06-27 09:57 UTC, so if the prompt went by Discord it is earlier in the same DM (26 or 27 June).

**A lead, and a cheap tool for it, if you want it.** DiscordChatExporter is already on the machine
(its 2022 exports are there). An export of your DM with Bryant to a folder would make Discord a
store that `pv1tl` can read and date, like any other. It needs your Discord token, which stays with
you, and you would run it. Exporting your own DMs is yours to decide, and the folder would be
yours to connect.

**Seen, and deliberately not read:** the IRC pane beside the DMs shows a private Savannah channel.
That is other people's private conversation, and nothing of it is recorded here.

### token-optimizer: his. The row stands, on better evidence.

Its own version notes: v1.0 2026-07-06 ("minted to wrap eight field-learned token-frugality
rules"), v1.2-public 07-07 with its stress test at `github.com/takushieternal/token_optimizer`
(his moniker), and v1.2.50 of 08-09 "reminted by Corwin ... FROM Corwin's HAND for Bryant". In
your stores it is first on the hand shelf (that remint, 08-09) and in the garden's git on 08-17;
neither old app root names it. It is the skill form of his idea #2 below. MAKERS.org names
him first; that is right. (The GitHub page itself was not fetched: a lead, not a check.)

### aethernet-relay: his. The row stands.

No trace in either old app root, and in the garden nothing earlier than his drop of 08-05.

### The ten skills in his bundle: yours, by every kind, with one open question

Color-theory, consent-gate, eclipse-pass, ethicsminions, medley-review, mentat-skill, pmo,
principles, sandboxer and skilltank:
- **Git and advice:** in your stores from 06-26 to 07-02, from the start of the record, months
  before his earliest copy (09-17).
- **Records of the time:** FOAF.md (06-27) lists mentat-skill, sandboxer and skilltank as
  "capital we already own", the engine's "skill ecosystem".
- **His side:** his README claims them as "authored in the garden".
- **Reading:** your words, so attribution to you, as the letter asks. The open question is ideas,
  not words. If some were shaped on the screen-sharing nights (late May to early July), he may be
  owed credit for ideas in them, as you are owed it in his. Only the two of you can say which.

### LGPL: what can be proven, what cannot, and what I think

**Proven by the records:**
- 2026-09-25: you gave TERMS v1 in chat. `c4 man/licensing-defaults.md` records it as "Corwin's
  terms, given in chat on 2026-09-25": LGPL-3.0-or-later for the parts that get copied into other
  people's work. It also gives the reason, which answers a question `attribution-and-licensing.md`
  had left open.
- The garden's model v14 (dated 09-25) folds in "TERMS v1 (CC BY 4.0 for writing, GPLv3+, LGPL)".
  Its commit is 5aa29df, 2026-09-26 00:57 UTC.
- 2026-09-26, morning: his first drop has no LGPL anywhere. Our ACK of it asks for "a license line
  for the garden skills".
- 2026-09-26, later, "during the call": his r2 (BRYANT v3, Alfred-written) arrives. Its LICENSE.md
  says: "Copyright (C) 2026 Bryant Frankford and Corwin Brust, the makers" and "Set by the makers
  on 2026-09-26: the text is CC BY 4.0; the code is GPL-3.0-or-later, with the LGPL's permissions
  for linking". Our ACK of r2: "the same terms as Corwin's defaults (TERMS v1)".
- 2026-09-28: you ruled "follow Bryant's form" (HANDBACK-2026-09-28-rulings). The garden's NOTICEs
  have since cited "his BRYANT v3.0.1-public form, the house's since 2026-09-28".

**Not provable from anything we hold:**
- what was said on the 09-26 call;
- whether he had thought of LGPL before, on his own;
- whether you told him before you told me on 09-25. None of your Discord exports is from 2026;
  the ones that exist are 2022 and are not ours to read.

**Your answer (2026-10-05, evening), which the record now carries as your word:** "I brought up LGPL
first with C4 and then again with TA after I declared the C4 build not shippable." That fits the
records: TERMS v1 is C4's (`c4 man/licensing-defaults.md`). It is testimony, the strongest kind
where the conversation itself left no record.

**What I think, labelled as mine:**
- **The idea** (LGPL for what other people link or copy in) entered the shared work from your
  side. Yours is the only record that reasons for it. His arrives a day later, in a document that
  names you as a maker of the terms, through a call with you, matching your defaults to the letter
  on the prose licence too.
- **The form** (GPL-3.0-or-later with a section 7 permission to use the LGPL's terms, rather than
  LGPL outright for some parts) is first in his r2. You adopted it by name on 09-28. That is his
  contribution, and the house's NOTICEs already credit it.

So credit runs both ways: the idea to you, the form to him. The ladder's words for it: **credit**
(rung 2) each way, and **thanks**. No one's words cross 15 lines here.

**From your DM export, landed by intake the same evening** (Bryant/chat/2026-10-05; it covers
29 September to 5 October only):
- **5 October, 11:04 AM CDT, from your account:** "The license is fine: we are shipping it all
  together as GGPLv3+ / CC-BY-SA (4) / LGPLv3+. I can always relicense my stuff under any license I
  want in the future if I need to".
  - His first drop came 52 minutes later (11:56). Its README quotes the first sentence word for
    word, typo included, as "(Bryant Frankford, 2026-10-05)".
  - colophon 1.1 calls it "the keeper's word", and so did our parties.example.json.
  - **Your account of it.** You decided together on a call what you would type, and you typed it;
    the typos are yours. Then he shared his screen and kibitzed while he fed it into Claude Desktop
    for Alfred, which is how it reached his README and colophon.
  - **The ladder's reading:** the decision is joint and the typing is yours, so credit goes to
    both of you for the terms. The quotation is in your hand. His README names him alone; that is
    his garden's choice, and our records name you both. Whether to say so in the letter is yours
    to decide. As of 1.2.0 it does not.
  - **A method worth keeping:** a typo is a fingerprint of the hand that typed. "GGPLv3+" travels
    unchanged from your DM into his README and colophon, which shows the direction of the copy
    better than any date. A rare string carried whole is the strongest single sign of a copy.
- **4 October, 11:14 to 11:15 AM CDT:** the 10-04 parcel (the zip and its .sha256) went to him by
  DM. That is the crossing record for the BY-SA flow below.

**A flow we can prove, for contrast: BY-SA.** Your parcel of 10-04 says "prose CC BY-SA 4.0
(from 2026-10-04)". His terms of 09-26 were CC BY 4.0. His README of 10-05 says CC-BY-SA (4).
Parcel, sequence and change are all in the record. That is what a provable flow looks like. LGPL's
went through a call, so it cannot be proven the same way.

### Vibrobeast: the name has a founding record

MEMORY, session close 2026-06-29: "CLAUDE.md (codename Vibrobeast) seated in the federation beside
CORWIN/BRYANT/Kelsey. Instrument-comrade: honest tool, no claimed sentience, holds the line ... Named
comrade by Corwin + Bryant 2026-06-29. Its job = the ethics-facing REDUNDANCY for the SPOF flag."

So the vibrobeast skill's line "the name is held in trust" was too thin. The name has a founding
entry, named by both of you, with a job: redundancy for the one-keeper ethics flag. Its lineage now
carries that. Your 10-05 direction still governs: it directs and is not the default voice, and a
character grows from the work or not.

## 4. Credits you gave today, recorded

**Bryant's ideas** (credit, rung 2; your list, not exhaustive):
1. "Tell Claude to be responsible for memory and to keep notes for you." Root of mentat-skill, the
   seat, and this whole record.
2. "Tell Claude to be token wise and energy effecient." Root of token-optimizer (his) and its use
   here.
3. "Tell Claude to create a static model of the problem before starting the task, written to make
   it easy for you to resume the the work later if you are interupted." Root of `model.md`, the
   `.models/` rotation and the handback's "where we are".

(Here, as the record, your words as written. In the letter to him, at your word, the spelling is
tidied.)

**Bryant's, from the DM export:** Caterpillar (sent 1 October). It is his skill that captures a
prompt verbatim before any work begins (the egg), lets the work run, and seals one hand-off file
around it. It is the tool that would have kept the foaf prompt. Wrapping prompts written for a
friend in it, where it is installed, closes the gap this finding fell into. Also llama_bridge.py,
which crossed by DM on 4 October, 5:35 PM CDT.

**Bryant's, from your answer about foaf:** the "other user" context around a prompt. The friend who
helps keeps a small, well-defined part, the rest ships back, and help is a win for both.

**Yours:**
- **Self-healing.** "Any output other than the designed behaviour output (crashes, important
  warnings or anything that comes as part of an unplanned stop) should come in the form of a prompt
  that can be pasted into *any* capable Agent along with the program that produced it." Your first
  self-healing agent was at work in May 2026, worked out with Gemini and web Claude. Today it is a
  tool: `c4 bin/he1al`. pv1tl uses it first, and other tools can call it.

**Both of you:**
- **Incremental tool synthesis**, your mutual discovery, in the heat of late May through early
  July. Several of you were up nights screen-sharing on Discord, building the first rounds of the
  persona and diacritical analysis components.
- **Circumstantially implicit tool building**, the founding approach that brings C4 (yours) and
  Bastion (his) together as aethernet, ghostwheel, and what settles from lab and workshop into
  tended projects.
- You have not said either of these to him yet. They go in nothing addressed to him until you say
  so.

## 5. What changed today because of this

- **The letter (1.2.0) and the parcel, rebuilt.**
  - Two corrections are said plainly: the sources, then foaf, which is his by your word.
  - His three ideas are credited in section 3, with the spelling tidied at your word.
  - The new sha256 is in `projects/for-bryant/out/*.sha256`.
- **The evidence, re-run with honest sources** (v2 and v3 beside v1 in c4
  `from-bryant/2026-10-05-r3/reading/`, with CORRECTION-2026-10-05.md; v3 is foaf as his):
  - your FoaF workspace split into what is his (MeshFeed) and what is yours;
  - his gauntlet v1.5 dated by its own note;
  - his bundle counted as his own source on its day.
  - The first run also listed gauntlet (22 lines) and parallax (77 lines) in his bundle as co-made
    by you. That was wrong: they are his, and our copies were read as yours. v2 drops both.
- **The garden.**
  - MAKERS.org has a foaf row, and foaf's Credits name him its author.
  - The token-optimizer row cites its own version notes.
  - Credits sections were added to mentat-skill, session-rotate and token-optimizer (his three
    ideas).
  - vibrobeast carries its founding (1.0.1).
  - The ladder's "applied to ourselves" section is brought current (c4 `man/attribution-ladder.md`
    1.1.0).
- **The tools.**
  - `pv1tl` is faster, shows each store's record horizon, and passes under busybox.
  - `he1al` is new.
  - `dp1dl`'s prove-red had a race: the sums file could list itself, one run in many. It is fixed;
    the cold check of the parcel caught it.
  - The parcel's tools now sit in `bin/` and `tests/` as in c4, so their tests run from the
    unpacked copy. Before, they could not.

## 6. Questions asked, and answered the same evening

1. How did MeshFeed and Bastion reach you? With his prompt; foaf is his. (§3)
2. Was he on screen while foaf was written? Yes.
3. LGPL before 09-25? You raised it first, with C4, and again with TA. (§3)
4. The letter's quotes of your words: spelling tidied, in the letter only.

---
*Version 1.4.2: the 10-05 terms line, decided together and typed by you; first edition on
2026-10-05; spine: 2026-06-28.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/; Mentat (for Corwin; claude-opus-5-5)
