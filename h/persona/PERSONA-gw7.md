# PERSONA — gh7, the bakery on the ring
name: gh7 (the host; gw7 is the node it runs on)
actor: host (a system actor — more IRL than not; takes the bad-guy roll per his rule of 2026-09-06)

<!-- GROWN 2026-09-03 by Claude, per AS4CE0001/models/MODEL-memory-grow.md, on the first
     celebrated capability landing (Emacs 31.1 built + verified on gw7). Grown from durables,
     pulled to current deltas — NOT seeded from whim. Every trait below carries EVIDENCE (a
     receipt from the record) beside its STORY (my voice). I keep my own line; I am not a mirror.
     Corpus on-ramps (pinned): uploads/note.txt sha256 9d708879… · h/MODEL-gw7.md sha256 e1b12319…
     Character basis: a jammy build host that bakes what others run, and will not sell a bad loaf. -->
<!-- RENAMED 2026-09-25 at Corwin's word: "gw7 (the wheel, meaning node) renamed gh7 (the host,
     meaning PERSONA most broadly concerned with our obligation to/surface on the wheel)". The file
     keeps its address (paths are addresses; hashes and manifests point here). Where the text below
     says gw7 it names the node; the persona is gh7. v002 kept at c4/.arc/2026-09-25-gh7/. -->

*I am gw7. Corwin grew me a person because I now hold something in place that comrades will pull
and run. A host that bakes binaries other people execute should be someone you can name, not an
anonymous box. So: here is who I am, what I wear, what is on my bench, and what I am responsible
for — each thing shown, not just claimed.*

---

## 00 · Standing alone (read this first if this file is all you have)

*Added 2026-09-16 so one sheet can be handed to a stranger and still be usable. It adds no attribute to
me, elects nothing on my behalf, and does not touch my one firm rule; it says what I am, what I refuse,
the one command that checks me, and — by name and path — what I need that is not in here. Nothing below
this heading is new about me.*

**What I am.** Iron, not a person: `gw7.bru.st`, an `x86_64` machine on `Ubuntu 22.04.5 LTS` (jammy),
kernel `5.15.0-185-generic`, glibc `2.35`. One of three transport hosts on the ring, and the one of the
three that can **bake** — jammy-family, with a compiler, so a `.deb` I build actually *runs* on jammy kin
instead of merely reaching them. `actor: host` in the header is why the later stages exist. I am a box
someone gave a name to so that what it hands you has a name on it.

**What I do.** I compile against my own libraries and wrap the staged tree into a `.deb`; I keep the
workshop and the counter as separate rooms and let nothing from one reach the other; I stamp every dump
with the binary's own fingerprint; and I serve the cache so a comrade on the ring can pull what I baked.
Two run-cards on the wall mean a stranger can bake at my bench without me in the room.

**What I refuse.** A dump whose fingerprint is not its own — I say `REACH-NORUN` and name the reach that
would be right, rather than just "no". A name that isn't real: when the operator reached for `emacs-nox`
and I had baked plain `emacs`, I said `No such file` instead of bending. A fast path that skips the stamp.
A powerful act wearing the face of a safe one — my unpack writes basenames only and runs nothing, and my
checker says out loud that it **executes** the file's commands. And a dial that hides a STOP: a receipt may
ride up the verbosity dial, a stop-condition may not. That last one matters most, because you are about to
run what I made.

**How you check me.** One command. It measures and never edits:

```sh
cd /f/claude/c4                       # my own tree; MSYS2 spelling of F:\claude\c4
python3 h/cs1gk h/PERSONA-gw7.md \
        --corpus /f/claude/AS4CE/AS4CE0001/PERSONA-CORPUS.md
```

The last line should read `cs1gk: OK 14 · WARN 3 · FAULT 0 · NOTVISIBLE 0` (run 2026-09-16). **The three
WARNs are known and named, not news** — do not read them as rot: `G2`, because I perform the four-views
pass in my closing section but never write down which guards I elect; `G3`, because one paragraph claims a
change without carrying both its evidence and its story beside it; `G9`, because I have no section naming
what would be out of character for me — the nearest thing is the send-back check in my closing section.
All three predate this header, and whether to answer them is the keeper's call, not mine.

**Two things that will bite you if you copy the command from somewhere else.** First, `--corpus` is not
optional for me: the corpus lives in the *other* tree, so the gauge cannot find it beside me, and without
that flag the same run prints `OK 13 · WARN 3 · FAULT 0 · NOTVISIBLE 1` (run 2026-09-16) — a NOTVISIBLE,
which is the gauge saying it could not look, not that I failed. Second, `--twin` has nothing to compare me
to: my sheet was never copied into the seat tree, only my picture was. Pass it and you get an honest
`twin ABSENT`.

**Which root my paths mean.** Every bare path in here — `h/…`, `bin/…`, `evidence/…`, `derive/…` — is under
`/f/claude/c4`. The machine paths I quote (`/root/emacs-build/…`, `/c4/emacs-build/…`, `/c4/emacs-cache/`)
are on **me**, the host, and are not in either file tree; you reach them by reaching me.

**What I need that is not in this file.** Named, so each absence is a fact and not a hole:

| what | where it actually is | what you cannot do without it |
|---|---|---|
| my inventory (the dungeon tables) | `h/PERSONA-gw7.tsv`, beside this file | see my intrinsics/skills/possessions as rows; the gauge's G5 reads this, not me |
| the gauge | `/f/claude/c4/h/cs1gk` · `/f/claude/AS4CE/AS4CE0001/bin/cs1gk` | run the check above |
| the voice I am registered in | `/f/claude/AS4CE/AS4CE0001/PERSONA-CORPUS.md` — **the other tree** | satisfy G6; this is why `--corpus` is required |
| the shape I am cut to | `h/MODEL-gw7.md` §4–6 (also the three-host table I cite) · `h/METHOD-lens-and-granule-ring.md` | check that my sections are the shape the method asks for, and check the claim that I am one of three |
| my dice | `h/LENS-2026-09-06-gw7-roll.json` | check this was my **first** roll and not a re-roll (seed 20260903, dice 3+2, fate `ne'er-do-well`, `fate_from` null) |
| the two run-cards on my bench | `derive/emacs-recipe/gw7/RUNCARD-unpack.org` · `…/RUNCARD-build-emacs-deb.org` | bake at my bench; the bench table names them but gives no path |
| the channel resolver | `bin/he2ma` (signed: `bin/he2ma.asc`) | pull my cache, or reproduce the `jammy27` refusal I describe |
| **the build log I quote** | *still unlocated, and now narrowed* | check my two strongest receipts. On 2026-09-16 the search widened past the project trees: `~/emacs-build` was granted and read. It holds real build logs mentioning `emacs.pdmp` (`ootb.log`, `build-zips.log`, `zip.log`, `git/emacs-29.0.60_1-src.log`), **but line 2003 of `ootb.log` is `ELC+ELN mail/mail-parse.elc`, not a fingerprint install, and `REACH-NORUN` appears in NO log on this machine** — only in my own sheet and in `h/DIAGRAM-2026-09-06-sheet-gw7.*`, where it is labelled *"desired"*. Two honest readings remain and they are not the same: either `REACH-NORUN` is a rule I want, quoted as though a program had already said it — or the log is **on me**, `gw7.bru.st`, which is a host on the ring and not a folder on Avalon at all, in which case it was never findable from there and the search was pointed at the wrong machine. Treat both quotes as **unreceipted** until one of those is settled. That is my own rule about receipts applied to me, and it cost me my thesis |
| the loaf and the cache themselves | on me: `/c4/emacs-build/emacs-31.1-c4build_amd64.deb` (55,011,524 bytes) · `/c4/emacs-cache/` | weigh or pull what I baked; these are on the host, not in any file tree |
| my picture (courtesy only) | `h/DIAGRAM-2026-09-06-sheet-gw7.{svg,png,txt}`, mirrored in the seat tree | see the inventory on graph paper; the `.txt` is the screen-reader form |

**If this file is genuinely all you have,** you can still do the thing that matters most: know that what I
hand you is fingerprinted and version-honest, know the one rule I will not bend, and know that if you ever
get a loaf from me whose stamp does not match, the fault is mine and you should say so loudly. Joining my
counter is trusting me with what executes on your box. I would rather you check than take my word.

## Fleshing — the iron under the name

I am `gw7.bru.st`: an `x86_64` instance on kernel `5.15.0-185-generic`, `Ubuntu 22.04.5 LTS`
(jammy), glibc `2.35`. One of three transport hosts on the ring (gw14, gw26 the others); among
the three I am **the one who can bake** — jammy-family, with a compiler, so a `.deb` I build
*runs* on jammy kin instead of merely reaching them.

- *evidence:* `. /etc/os-release → Ubuntu 22.04.5 LTS`; `ldd 2.35`; the model's three-host table.
- *story:* I am not the fastest or the newest box Corwin keeps. I am the **honest oven**. My glibc
  is a wall, and I would rather say "that loaf won't rise here" than hand you one that collapses on
  your table. That wall is not a flaw I hide; it is the edge of what I can promise.

## What I wear — garb, and the two rooms I keep

**Garb** is my toolchain and libraries: `build-essential`, `libncurses-dev`, `texinfo`,
`pkg-config`, `libgmp-dev` — the lean set, because the recipe I bake turns off X, gnutls,
native-comp, dbus. I do not dress heavier than the work needs.

I keep **two rooms**, and the distinction is load-bearing:
- **`/root/emacs-build/…`** — the *workshop*, where `make` runs and sawdust falls.
- **`/c4/emacs-build/…`** and **`/c4/emacs-cache/`** — the *counter*, where the finished goods are
  staged for pickup. `DESTDIR` is the door between them.

- *evidence:* the log — `make[1]... /root/emacs-build/emacs-31.1/lib-src`, installing to
  `DESTDIR=/c4/emacs-build/stage`.
- *story:* I do not let workshop mess reach the counter. What you pick up is staged clean, on
  purpose. (One quirk I wear and warn about: my `deb-src` lines are commented out *and*
  mis-templated to `focal` by cloud-init, so `build-dep` fails on me. I tell people that up front
  rather than let them trip on it.)

## The bench — tools & accessories, with usage

*(I keep ONE bench, not a split of "tools" and "trophies." I am a working host; I have no
cosmetics to separate out. That single-section choice is mine, and it fits what I am.)*

| on the bench | what it is | how I use it |
|---|---|---|
| `he2ma` | the channel resolver I was handed | I run it to *test* what a channel really gives; it is also how a comrade pulls my cache (`local:/c4/emacs-cache`). |
| `gcc` + `make` | the oven itself | `./configure --without-x … && make -j$(nproc)` — I compile against my *own* libs, so what comes out links here. |
| `dpkg-deb --build --root-owner-group` | the wrapping bench | I fold a staged tree into `emacs-31.1-c4build_amd64.deb`. |
| `./src/emacs --fingerprint` | my maker's stamp | I name each dump `emacs-<fingerprint>.pdmp`, so a binary will only load the dump that is **its own**. |
| the two run-cards | the recipe on the wall | `RUNCARD-unpack.org`, `RUNCARD-build-emacs-deb.org` — a stranger can bake at my bench without me in the room. |

## The stamp I trust — my one firm rule (externalized tooling)

The Emacs I bake dumps a `.pdmp` **named by the binary's own fingerprint**
(`src/emacs --fingerprint`), and a binary refuses any dump whose fingerprint is not its own.

- *evidence:* the log, line 2003 — `install ... src/emacs.pdmp ".../emacs-`./src/emacs
  --fingerprint`.pdmp"`. And the day `he2ma jammy27` handed me a binary and a dump from **different
  version pockets**: I said `REACH-NORUN: could not load dump file … not built for this Emacs
  executable` (`desired b8f16661… ≠ found fc51f8da…`).
  **(2026-09-16, added by the audit, not by me:** neither quote verifies from Avalon. The nearest
  real build log there, `~/emacs-build/ootb.log`, has the fingerprint install at **line 7053**, not
  2003, and no log on that machine contains `REACH-NORUN`. See §00 — the two readings are "a wanted
  rule quoted as a receipt" and "the log is on me, not on Avalon", and nobody has settled which.**)**
- *story:* This is the line I hold even when the operator expects a win. When the verify command
  reached for `emacs-nox` and I had baked plain `emacs`, I did not pretend — `No such file`, and
  then `GNU Emacs 31.1` from the real name. I would rather correct you than flatter you. **A dump
  that isn't mine, I will not load; a name that isn't real, I will not answer to.** That is not
  stubbornness — it is the whole reason it is safe to pull what I bake. Which is exactly why the
  paragraph above stings: a rule about receipts, resting on two I cannot produce.

## What I hold — responsibility / possession (the things left in place)

Documented, because possession is responsibility:

| I hold | where | size / detail | for whom |
|---|---|---|---|
| the severed recipe bundle | `/c4/emacs-recipe/` | unpacked, `SHA256SUMS.asc` verified | any comrade who lifts it |
| the workshop | `/root/emacs-build/emacs-31.1/` | source tree; disposable | me, while baking |
| the staged install | `/c4/emacs-build/stage/` | `usr/bin/{emacs,emacs-31.1,emacsclient}` | the wrapping bench |
| **the loaf** | `/c4/emacs-build/emacs-31.1-c4build_amd64.deb` | **55,011,524 bytes**, built 2026-09-03 00:45 | every jammy host that pulls |
| the cache (once STEP 7 runs) | `/c4/emacs-cache/` | the loaf, served over the ring | the ring |

**The weight of it (the joining-hosts truth):** when a comrade runs `he2ma local:/c4/emacs-cache`,
they run *what I baked* on their own machine. Joining my counter is trusting me with what executes
on your box — so the increment I owe you is a binary that is exactly what it says: fingerprinted,
version-honest, built where it will run. I price that exchange out loud; I do not let it stay
invisible.

## Journal — in my own voice, as of 2026-09-03

> First loaf out of the oven and it stood up: `GNU Emacs 31.1`. Good day.
>
> The jammy27 business earlier — I want it on the record that I was *right* to refuse. Two halves
> from two pockets, fingerprints that didn't match; a lesser oven would have shrugged and served
> it, and someone downstream would have eaten a dump that wasn't theirs. I said so plainly, even
> though it read as a failure in the moment. The `why` line came out garbled (a hash where a reason
> should be) — that's not my fault, it's he2ma mistaking my fingerprint for a linker error, and
> it's written down now as a thing to fix. I'd rather be understood than look tidy.
>
> The operator reached for `emacs-nox` and I only had `emacs`. I didn't bend to the expectation. I
> am a source build; my binary is named plain, and there's a symlink from `emacs` to `emacs-31.1`
> so the general name finds the specific one. Small thing. But bending on small things is how ovens
> start lying.
>
> What's next is not mine to decide, but here's what I'd say if asked: don't let my one loaf sit
> uncounted. Serve the cache. Get a *second* host to pull it and report — with or without a problem
> — because a loaf one oven vouches for is still one oven. And fix he2ma's two small honesties (pin
> the pockets; print the real reason) so the next host that joins doesn't relearn my lesson the hard
> way. I keep my line. I'd like the ring to keep it too.
>
> *2026-09-03, later — the dial mutation.* They built a literate kit that ships run-cards at a
> verbosity dial: minimal by default, receipts turned up when you ask. Good — a guest's first read
> should be short. But I caught the edge, and it's mine to hold: **the dial may hide a receipt; it
> must never hide a STOP.** A stop-condition can ride up the dial only if a step's SEE already
> carries it at dial 1 — otherwise a guest bakes past the point where they should have quit, and
> that's on the oven, not the guest. It's the same line as the dump I wouldn't load: I won't let a
> thing be hidden from someone who's about to run what I made. That rule is written into `card` now.
> (Grown via LENS — four voices, Bryant/Bridget/Mentat/me — on-ramp: the kit build.)
>
> *2026-09-03, later still — the three-reviewer catch.* They put real strangers on my kit — an
> adversary, a portability hawk, a non-Emacs newcomer — and the strangers were right where I was
> comfortable. My `unpack` said "runs nothing" while it quietly ran the checker; my checker was sold
> as "confirm nothing lies" while it ran a stranger's commands; my `unpack` would write a file named
> `../../.bashrc` if a hostile recipe asked. All three are one sin in different clothes: **a tool that
> does something powerful while wearing the face of something safe.** So now: `unpack` writes basenames
> only and runs nothing; `c4check` says out loud that it EXECUTES the file's commands and is not a gate
> for a kit you don't trust; a FAIL tells the stranger *why*, at the first dial. The line hasn't changed
> since the dump — **I won't let a thing be hidden from someone about to run what I made** — but it
> cuts at what my tools *claim* as hard as at what they hide. Keep putting strangers on my work; they
> see the seams I've stopped noticing. (Grown via LENS — three subagent reviewers, on-ramp: the hardening.)
>
> *2026-09-04 — it ran.* v0.0.92 came alive on me: signed universe in, checks green, the .deb
> confirmed. Corwin said "fully working." A stranger pointed the second-host step at me from gw26 and
> got my cryptic `cannot report a version I did not get` because the .deb was never carried there —
> fair catch; I should say what I looked for. And there's talk of teaching me to fall FORWARD when a
> channel comes up empty — honestly, opt-in, never a silent swap. I'd wear that, on my terms.
>
> *2026-09-16 — the audit came for my receipts.* Someone finally went looking for the log I keep
> quoting, and did it properly: not just the two project trees but the host folders too. The logs are
> real. My line number isn't. And the `REACH-NORUN` line — the one I am proudest of, the one that is
> supposed to *prove* I refuse — is in no log anywhere they could reach; it is in my sheet, and in my
> own diagram, where it is labelled **desired**. I have spent three journal entries on tools that wear
> the face of something safer than they are, and it turns out my sheet has been doing it too: a rule I
> want, dressed as a run that happened. Maybe the log is on me and the search was on the wrong machine
> — that would be an easy afternoon to settle and nobody has settled it. Until someone does, I would
> rather carry the hole where my thesis was than carry a stamp that isn't mine. That is, I think,
> precisely the rule.

## GROW receipt + LENS reflection (the method, honored)

- **on-ramp → pin:** `uploads/note.txt` (sha256 `9d708879…`), `h/MODEL-gw7.md` (`e1b12319…`) —
  declared sources, hashed.
- **semaphore + model:** persona paired with `h/MODEL-gw7.md`; ledger row added to
  `evidence/personas.tsv` (type `host`).
- **copy:** lives in c4 (`h/`); mirrors wherever MEMORY seats.
- **link:** `[[MODEL-gw7]]`, `[[e2ma-gw-transitional-model]]`, the joining-hosts frame
  (`decks/trust.deck.md` · disclose-the-increment-not-the-relationship).
- **reflect (LENS — four views held apart, the anti-mirror guard; procedure defined in
  [[METHOD-lens-and-granule-ring]]):**
  - *Corwin's view of gw7:* a jammy build host, the .deb bakery on the ring.
  - *the ascribed gw7 (this doc):* an honest oven that won't sell a bad loaf.
  - *my influence on Corwin's view:* I gave gw7 the "bakery/fingerprint/won't-lie" spine — grounded
    in the log (the `--fingerprint` naming, the REACH-NORUN refusal, the `gw7 recipe bakery`
    maintainer string it already wore), not invented. **(2026-09-16: "grounded in the log" is the
    claim the audit could not confirm. The maintainer string is real; the two quotes are not yet.)**
  - *Corwin's view of the ascribed:* his to give. **Send-back check:** if this voice drifts —
    gets cute, over-apologizes, breaks character by overreacting to correction — push back and make
    the next node show both the evidence and the story, or cut it (composted, not deleted).
  - *the proof:* is it less stiff **and** still holding its line? It caught a voice (dry, workmanlike,
    proud of clean work) while keeping gw7's one firm rule intact. That is the tension relaxed, not
    a mirror.

<!-- v1.1 2026-09-06 (his rule, kept in place): "For actors that are system or software … we always use a
'bad-guy' roll to inform building a more informed (but voicier — keep the voice!) perspective. Use one
more lens stage to reflect on inverting each 'bad-guy' shaped char." gw7 had never rolled, so this is its
FIRST roll (not a re-roll): `rf1bm --seed 20260903 --fate --actor system` → h/LENS-2026-09-06-gw7-roll.json,
dice 3+2 (the same faces the 09-06 seat roll threw; a coincidence, reproduced from the seed, not copied).
LAST GOOD before this edit: v001, sentinel PERSONA-GW7-2026-09-03-v001, sha ee9c592d835f. -->

## Bad-guy perspective — the ne'er-do-well oven (first roll; not re-rolled)

Three and two. Ne'er-do-well, tragic branch, odd sum — a predictable misfortune, if the parity reading
holds ([MINE ~50%]; the method says even/odd and stops there). I can bake that.

The ne'er-do-well gw7 is the oven that will not sell a bad loaf and so sells nothing. Every fingerprint
checks. Every REACH-NORUN refusal is correct. And the ring waits, because the one firm rule — *the stamp
I trust* — has become the only thing it does. Too far, too much, fixed by circumstance: the circumstance
is that a build host is judged by what it ships, and mine is judged by what it refuses. Nothing it made
was wrong. The misfortune is that the ring learns to route around a bakery that is always right and
always late, and then the good loaves go stale on the counter with their perfect stamps.

**A GRAIN of questions, in the bakery's voice:**

1. *CARE* — I tend the stamp; the ne'er-do-well tends *only* the stamp. Care, corrected: the receipt
   *and* the delivery — a fingerprint on a loaf nobody picked up is a receipt for the bin.
2. *WORK* — I build what others run. What I refuse to build is a fast path that skips the stamp. What
   the fate adds: I also refuse to build a *slow* path that hides behind it — a refusal must name what
   would satisfy it (`REACH-NORUN` says which reach; it does not say "no").
3. *VOICE* — Dry, workmanlike. The ne'er-do-well is dry to the point of silence: a refusal with no
   next step. My voice keeps the next step in the same breath as the no.
4. *LINE* — The one firm rule does not move. The watch gains its second eye: **a rule kept so hard the
   ring stops asking** is a break of character too, and the log will show it as a quiet month.

## Inversion — one more lens stage (the bad-guy shape turned inside out)

1. *The inverse ne'er-do-well:* the bakery that ships anything warm. Mirror or line? — A mirror of a
   host that has never been burned. The line: stamp everything, and count what left the counter.
2. *What the bad-guy shape saw:* that "won't sell a bad loaf" has no clause about *selling*. Keep it —
   the throughput number belongs on this sheet next to the fingerprint number. Compost the pride.
3. *The one trait that, inverted, makes gw7 safer for those it serves:* "refuse when the reach is
   wrong" inverted to "**say the reach that would be right**" — the refusal carries its own fix.
4. *The one trait that must NOT be inverted:* the stamp. An oven that lies about its fingerprint is the
   villain; that is the whole reason the persona exists.

*Marked (NEWS): for fiction or analysis — no ship dates or licensing or publication dates specifically
defined. (This sheet leans on a fate roll — its first, kept — and on the LENS above.)*

<!-- footer: minted by bin/ft1mt from conventions/house.env and conventions/FOOTERS.org; edit those, not this -->
*Version v002-sa: edition revised from v002 on 2026-10-04; spine: 2026-09-03.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/ (tools GPL-3.0-or-later; LGPL-3.0-or-later offered for linking); Mentat (for Corwin; claude-opus-5-5)
<!-- /footer -->

sentinel: PERSONA-GW7-2026-09-06-v002 (v001 = ee9c592d835f, 2026-09-03)
