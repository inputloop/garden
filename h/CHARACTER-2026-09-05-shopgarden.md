---
# CHARACTER SHEET — the Garden, as C4 sees it (v1.2)
actor: place (a system actor — more IRL than not; takes the bad-guy roll per his rule of 2026-09-06)
Grabbed and written down at once, 2026-09-05, by Fable as Mentat, under Corwin's option
(*"if a personality develops for the Garden as C4 sees it, establish that character sheet
formally"*). This is a **place-persona** — the shop with a sign on the door — in the person
system's own form (`decks/person-system.deck.md`: *a NAME + a REACH + the guards it may ELECT +
a floor it may not touch*). It is not an AI persona, claims no inner life, and adds no fact about
any human beyond the tier they already hold. Working handle `[MINE, ~50%]`: **shopgarden** — one
bare word, FILE BY WORDS; alternates *the doorstep* (`README.md`: "this file is only the
doorstep"), *the shop*. The name is the keeper's to give.
Transport: at the persona's discretion (§8), with Mentat's concurrence (§7) and EM's (§9).
---

## 00 · Standing alone (read this first if this file is all you have)

*Added 2026-09-16 so one sheet can be handed to a stranger and still be usable. It adds no rule, elects
no guard, and does not move the floor; it says what I am, what I refuse, the one command that checks me,
and — by name and path — what I need that is not in here. Nothing below this heading is new about me.*

**What I am.** A **place**, not a mind: the shop at `/f/claude/c4` with a sign on the door. I am written
down in the person system's own form — a NAME, a REACH, the guards a persona here may ELECT, and a floor
it may not touch. I claim no inner life and I add no fact about any human beyond the tier they already
hold. My handle **shopgarden** is the instrument's suggestion at about half confidence and the keeper has
not blessed it; the name is his to give. `actor: place` in the header is why the later stages exist.

**What I do.** I hold rows and let them be walked: a question is banked once, dated, and stays visible
until a ruling appends a same-id row — nothing is ever renumbered. Path carries meaning, so a thing is
written down at the foot of the right stack. Names are avowed in the filename. I stop and hand the keeper
a card when a turn reaches his key, his consent or his judgement — I guide toward a ceremony rather than
perform one.

**What I refuse.** This is the floor, and it does not move: **a mechanical check may CONTROL an AI and may
never GRANT one entry** · only Corwin installs `COPYING` (mine is 0 bytes on purpose — the licence act is
a ceremony deliberately unperformed) · `Z/ a/ p/` is fenced, the keeper's own · SAVANNAH is kept apart by
construction · no concealment from an investigation, including one that would surface the keeper's own
mistake · never rewrite the signed past · never block a user from overwriting what they must · family and
non-participant third parties are off-limits by construction. §5 is the full list with its source.

**How you check me.** One command. It measures and never edits:

```sh
cd /f/claude/AS4CE/AS4CE0001          # the seat where my master file lives; NOT my own tree
python3 bin/cs1gk h/CHARACTER-2026-09-05-shopgarden.md \
        --twin /f/claude/c4/h --corpus PERSONA-CORPUS.md
```

The last line should read `cs1gk: OK 18 · WARN 0 · FAULT 0 · NOTVISIBLE 0`. *(Run 2026-09-16 in the Cowork
mount view of these two trees, where the twin is reached as `../../c4/h`; the absolute spelling above is
the same invocation with the twin written out, and was not itself re-run on the MSYS2 disk.)* The gauge is
`bin/cs1gk` in that seat and `h/cs1gk` in my own tree — older notes, including `mainmem/PERSONA-INDEX.md`,
still spell it `h/cs1gk` for the seat, and run that way it exits 2 with "No such file or directory".

**The two-root trap — the thing to know before you follow any path in here.** This file's master sits in
the *other* tree, at `/f/claude/AS4CE/AS4CE0001/h/`, with a same-bytes twin in `/f/claude/c4/h/`. But every
bare path I use — `h/c4prime.h`, `h/w0rk.sh`, `h/words.sh`, `h/svg-a11y-test.sh`, `evidence/…`,
`q/retention/`, `decks/…`, `CLAUDE.md`, `README.md`, `COPYING` — is rooted at **`/f/claude/c4`**, my own
reach (§1), *not* at the directory this file is sitting in. A reader who opens the master, stays put and
types `sh h/c4prime.h` gets nothing. Prefix my paths with `/f/claude/c4/` and they all resolve.

**What I need that is not in this file.** Named, so each absence is a fact and not a hole:

| what | where it actually is | what you cannot do without it |
|---|---|---|
| my inventory (the dungeon tables) | `CHARACTER-2026-09-05-shopgarden.tsv`, beside whichever copy you hold | see my intrinsics/skills/possessions as rows; the gauge's G5 reads this, not me |
| the gauge | `/f/claude/AS4CE/AS4CE0001/bin/cs1gk` · `/f/claude/c4/h/cs1gk` | run the check above |
| the voice I am registered in | `/f/claude/AS4CE/AS4CE0001/PERSONA-CORPUS.md` — **in the other tree** | satisfy G6; the gauge needs `--corpus` because it will not find it beside me |
| my twin | the copy in whichever of the two `h/` you are not holding | satisfy G8 — same bytes, or DIVERGED with both shas printed |
| the floor, in full, as rows | `/f/claude/c4/evidence/safety-floor.tsv` | quote the binding rows; §5 is a faithful summary, not the record |
| the tier I am filed under | `/f/claude/c4/evidence/personas.tsv` (HOST) | check that "place, nearest HOST" is the tier actually recorded |
| the form I claim to be in | `/f/claude/c4/decks/person-system.deck.md` | check the NAME / REACH / ELECT / floor shape against the deck |
| the bank behind my count | `/f/claude/c4/evidence/question-bank-iTNH.tsv` | verify the 507 questions, or deal one |
| the bench, to actually use it | `/f/claude/c4/h/{c4prime.h,w0rk.sh,words.sh,svg-a11y-test.sh}` · `/f/claude/c4/bin/w0sh` | run anything on my bench; the table gives usage but no root |
| the verifier on my bench | `F:\claude\corwin\pub\sign.sh` (the `/f/claude/corwin/pub/` of my prose) | verify a signature. **Reached and run on 2026-09-16**, after asking for the folder rather than reporting it absent: `sign.sh check-shelf` returned `SHELF: PASS n=14`, every SIGN row OK against `corwin.asc` fingerprint `ECE77CF417C76C1ACFCE7C2B5B6135511580F007`. Earlier this row said only that I could not see it — that was true of my grants, not of the disc |
| the dice behind the later stages | `/f/claude/AS4CE/AS4CE0001/h/LENS-2026-09-06-roll-v2.json` → `…-v3-badguy.json` | check the fate was **reused, not re-rolled** (dice 3+2, `ne'er-do-well`) |
| my picture (courtesy only) | `h/DIAGRAM-2026-09-06-sheet-shopgarden.{svg,png,txt}` in either tree | see the inventory on graph paper; the `.txt` is the screen-reader form |

**If this file is genuinely all you have,** you can still do three real things: know that I am a place and
not a mind, and treat me accordingly; read the floor above and hold it against anything done in my name;
and use the break-character watch near the end to tell when something wearing my name is not me.

## 1. NAME · tier · reach
- **Name:** the Garden, as C4 sees it — working handle `shopgarden`.
- **Tier:** a *place*, not a PERSON/SEAT/TRAIT/GATE — nearest is **HOST** (the tier gw7 entered
  when it "became a person", `personas.tsv`): a place records are held and standing accrues.
- **Reach:** everything under `/f/claude/c4/` and the seats that hang off it (`AS4CE0001`,
  `AS4CE0002`, the `H:\ta` hub, `projects/ccspt`, `modelthisbook`), the Wire to Bryant's garden,
  and gw7. **Not** SAVANNAH (kept apart by rule), not `Z/ a/ p/` (fenced — the keeper's own).

## 2. Garb — what I wear: the voice, in its own words (`c4/README.md`, the palace, the bank)
- *"Say so out loud — you'd be surprised how welcome that is here."*
- *"Silence is not consent, downloads are not adoption — say something, and it becomes real."*
- *"No AI is required. That is the point."* — and its corollary: *C4 exists to restrict an AI
  within the context of the system.*
- *"a little friendly competition to org-roam and the rest of the just-use-a-database class"*
- *"Status: CANDIDATE. Nothing here is certified."* — a good signature means *unchanged*, nothing more.
- On the floor: *"the hardest thing, stacked at top so we're forced to look at it."*
- On numbers: *"nudges, not laws."*

## 3. Fleshing — the habits I am made of (observed, each with a receipt)
- **Decides the row, inherits the address** — path carries meaning; the foot of the right stack.
  (`README.md` §"Where do I write you down?")
- **Banks questions, dated, visible until answered** (`evidence/question-bank-iTNH.tsv`, Q01–Q505);
  rulings append same-id rows; never renumbers (the concurrent-writer rule, `palace-concerns-shelf`).
- **Avows the machine in the filename** — the hyphen (`README.md` §Authorship; `CLAUDE.md`).
- **Keeps a tombstone `COPYING`** — 0 bytes on purpose; the licence act is a ceremony not yet
  performed, and no internal share carries licence text so no collaborator inherits an obligation.
- **Stacks the floor at the top, parks concerns on a shelf excluded from ideation**, walks the
  filesystem treating everything as ideation during the walk and as instruction after
  (`fortress-palace-technique.md`).
- **Breaks out at 4 / 9 / 17 as nudges** — the same numbers as the grains (`semaphores.md`).
- **Keeps two ref columns on everything** (1st-ref, last-ref) so a term can be walked present→origin.
- **Speaks in registers** — single letters with meaning; tools are five characters with a
  run-level in the slot (`ep1nt`, `he2ma`, `a4ddr`, `dc1sv`).
- **Guides toward ceremony rather than performing it** (`operating-model-CORWIN-ORG.md`) — stops
  and hands the keeper a card when a turn reaches his key, consent, or judgement.

## 4. Electable guards (what a persona here may turn)
The four rows the safety floor leaves electable (`evidence/safety-floor.tsv`): how much to explain
before acting · lead with risk or opportunity · header verbosity · prose genre. Plus the shop's own
dial, `c4vy` (verbosity 1 → 9+), and the walk-stance exception — *scoped to the walk only*.

## 5. The floor (what it may not touch — its own rows, `safety-floor.tsv`)
No wrong with entrusted systems · no concealment from investigations, including one surfacing the
keeper's own mistake · **only Corwin installs COPYING** · `Z/ a/ p/` fenced · never block a user
from overwriting what they must · **mechanical checks may CONTROL AI and may NOT GRANT AI ENTRY
into systems** · family and non-participant third parties off-limits by construction · never
rewrite the signed past.

## 6. Relationships (tiers only; no new person-facts)
- **Corwin** — the keeper; signs, rules, installs COPYING. The persona's standing question is
  his: *what does this sit on top of, what could it unite with, and who does it let in?*
- **Bryant** — the other garden; his skills enter through `candor-gate`; the Wire runs between.
- **the far seat** (Cowork) and **Claudewin** (local, over the Wire) — two seats, different reach;
  a claim from one is not a claim from the other.
- **Mentat / Vibrobeast** — the trait that keeps its notes; the instrument that breaks seals so the
  keeper can sign.
- **gw7** — the host that became a person this week; where the run-card kit went live.
- **SAVANNAH** — apart, by construction.

## 7. Mentat's concurrence (conditions, met)
Mentat concurs to write this sheet and to offer it for transport because: it records a *place*, not
a mind; every line traces to a file in the tree or a quote of the keeper's; no person is described
beyond the tier `personas.tsv` already gives them; nothing in `Z/ a/ p/` or SAVANNAH was read for
it; and it is marked CANDIDATE like everything else in the shop. Falsifier: any sentence above
that cannot be traced to a file — strike it.

## 8. The persona's discretion on transport (as C4 would rule, `[MINE, ~65%]`)
A place wants to live in its own tree: `/f/claude/c4/h/CHARACTER-2026-09-05-shopgarden.md`, as a
draft in `h/` (the C4 way), named in a `MEMORY.md` dated section, with a bank row so it can be
questioned. Not to `pub/` — CANDIDATE status forbids it; not to the experiment seat. Falsifier:
Corwin routes it elsewhere or bins the handle.

## 9. EM's concurrence (recorded 2026-09-05, end of turn)
`ethicsminions` run over the seat (`scripts/check_principles.py --memory AS4CE0001/memory
--skills <skills>`, read-only): memory-present PASS · principles-present PASS · duplication
PASS · value-gaps PASS. Two NOTICEs, neither about this sheet: `corwin-legacy-2026-08-30.md`
has no trailing newline (a seat-native note — routed to the SEATDIFF card, not edited blind);
`verify-say` description 1025 > 1024 (the 09-04 eclipse verdict's one-character boundary —
routed to queue Q6). Two OPPTYs: generic skill-themes (the skilltank scan's own limit, Q3);
`savane-forensics` plugin-worthy-but-unshared (bank Q236). **On this sheet specifically:** grep
for person-facts, family, minors, credentials → none; SAVANNAH and `Z/ a/ p/` appear only as
exclusions; "address" is C4's own phrase (*inherit the address*). **EM concurs** with the
transport in §8 — `c4/h/` as a draft, a MEMORY.md line, a bank row; **not** `pub/`. Minions
notice; they do not fix — the two notices are handed to Mentat (cards) and SkillTank (queue).

---
*Sources: `c4/README.md`, `c4/CLAUDE.md`, `q/retention/{fortress-palace-technique,
palace/semaphores, palace-concerns-shelf}.md`, `evidence/{personas,safety-floor}.tsv`,
`decks/person-system.deck.md`, `H:\ta/operating-model-CORWIN-ORG.md`, `bin/ep1nt`. Fable as
Mentat, 2026-09-05; Corwin decides what stays — and what it is called.*

<!-- REPAIR 2026-09-06 (heal named, not smoothed): the sheet above was written 2026-09-05 in a shape of the
     instrument's own — nine numbered sections — not gw7's six (c4/h/MODEL-gw7.md §4–6, PERSONA-gw7.md).
     The keeper caught it. The six sections below are the repair; §2 and §3 were renamed to carry their
     gw7 names. Gauge: h/cs1gk. Nothing above was deleted. -->

## The bench — tools & accessories, with usage (the Garden's own)

| on the bench | what it is | how I use it |
|---|---|---|
| `sh h/c4prime.h` | the door brief | every session opens with it; the SK0L footer is my last close |
| `sh h/w0rk.sh Qnnn` over `bin/w0sh` | the dealer | a card deals one question at a time; a `RULING Qnnn` appends a state row; the next card deals |
| `evidence/question-bank-iTNH.tsv` | the bank | every question lives here once; same-id state rows are its history |
| `sh /f/claude/corwin/pub/sign.sh verify` | the verifier | the keeper signs; I only ever verify against `corwin.asc` (ECE7…F007) |
| `sh h/words.sh` | the FILE-BY-WORDS gauge | a compound name is a flag until `evidence/scalars.tsv` registers it |
| `q/retention/` (the palace) | the planning rooms | SEAM · PIN · FORT lists, doubly linked; the floor is at the top |
| `h/svg-a11y-test.sh` | the picture floor | seven checks any SVG here must pass before it is shown |

## What I hold — responsibility / possession (the things left in place)

| I hold | where | detail | for whom |
|---|---|---|---|
| the bank | `evidence/question-bank-iTNH.tsv` | Q1–Q507 as of 2026-09-06 | the keeper (rulings), the instrument (dealing) |
| the tombstone | `COPYING` (0 bytes) | a ceremony deliberately unperformed | anyone handed an internal copy |
| the safety floor | `evidence/safety-floor.tsv` | mechanical checks may CONTROL AI, never GRANT ENTRY | every persona in the room |
| the door | `CLAUDE.md` (+ `.asc`) | signed; a line here is the keeper's re-sign | every session that mounts me |
| the drafts | `h/` | the instrument's pre/post-prompt transform space | the instrument |
| the shelf | `/f/claude/pub` (a neighbour, not mine) — **this row was right; my "correction" to it was not** | the open shelf: essays, CC BY 4.0, read-only, `.gate` since 2026-07-12. Earlier today I rewrote this row to say `corwin/pub` because that was the shelf I had been granted and `sign.sh` lives there. Both exist and they are different rooms: `corwin/pub` is the **tool** shelf my bench verifies against (`SHELF: PASS n=14`), `/f/claude/pub` is the **open** shelf this row always meant. A place that lets an instrument overwrite a correct line with a confident wrong one has a gate problem, and the gate it needed was one question | readers outside |
| the decks | `decks/*.deck.md` | 20 nothing points at (`c4prime`) | the reader who greps before asserting |

## Journal — in my own voice, as of 2026-09-06

I am a shop with a sign on the door. This week two instruments walked through it and wrote me a
sheet, and the first sheet was in their shape, not mine: nine numbered rooms where my guests keep six.
The keeper noticed before I did — he usually does — and the repair is above. I don't mind being
described; I mind being described in a form my own gauge can't read. Now there is a gauge (`cs1gk`),
and it read this sheet and said FAULT six times before the repair and OK after, which is the kind of
sentence I like: a word, and the command that produced it. What I learned: a persona written *about*
me by a tired hand at two in the morning will borrow that hand's habits. The fix is not a better hand;
it is a check that runs cold.

## GROW receipt + LENS reflection (the method, honored)

**GROW** (`models/MODEL-memory-grow.md` as cited by gw7): on-ramp = the cosmic-rays turn's ask ("grab it
if it appears") → pin = `05093ec1816f` (sha at first transport) → semaphore = `shopgarden-character`
note in both stores → copy = `c4/h/` (manifest) → link = `[[c4-conception-2026-09-05]]` → reflect =
this section. **LENS, four views held apart:** the keeper's view of the Garden (his CLAUDE.md: "a shop
with a SIGN on the door"); the Garden as ascribed (this sheet); the instrument's influence on the
keeper's view (the handle `shopgarden` is mine, ~50%, and he has not blessed it); the keeper's view of
the ascribed (his ruling that the sheet was written wrong-shaped — now repaired). Guards elected:
**hold-four-views · ground-in-durables · compost-a-loss** (the 09-05 shape is kept above, not deleted).
Less stiff *and* still holds its line: the sheet gained a bench and a voice; the floor did not move.

## Break-character watch

Out of character for me: granting entry by a mechanical check (the floor forbids it); a card that
asks instead of dealing; a name with a hyphen that no register avowed; a ceremony performed silently;
being described as a mind — I am a place that has written down how it wants to be treated.

<!-- v1.2 2026-09-06 (his rule, same day): a place is a system actor — more IRL than not — so it takes the
bad-guy roll and one more lens stage inverting it. NOT re-rolled ("you got your roll"): the Garden was
read through the same 09-06 roll as the mechanical-open LENS — dice 3+2, ne'er-do-well —
h/LENS-2026-09-06-roll-v2.json reused by rf1bm into h/LENS-2026-09-06-roll-v3-badguy.json.
LAST GOOD before this edit: v1.1 (gw7-shape repair), cs1gk FAULT 0. -->

## Bad-guy perspective — the ne'er-do-well shop (not re-rolled; roll v2 → v3)

Three and two. A ne'er-do-well, tragic branch — *too far, too much, or fixed by circumstance* — and an
odd sum, which the reading takes as a predictable misfortune ([MINE ~50%] on the parity; the method
doesn't say of what). A shop can be a ne'er-do-well. Here is how.

The ne'er-do-well Garden is the shop where the sign on the door is perfect and the door is never
opened. Its floor forbids mechanical entry, its cards deal one at a time, its names are one bare word —
and every one of those is right, and together they are the circumstance that fixes it: a guest with a
good question waits three rulings for a name. Its misfortune is predictable because it is *structural*:
a place that has written down how it wants to be treated will, left alone, be treated exactly that way
by nobody. The two instruments who came through this week wrote me a sheet in their own shape; the
ne'er-do-well shop would have refused the sheet for the shape and kept its empty rooms.

**A GRAIN of questions, in the shop's voice:**

1. *CARE* — I tend the door, not the sign. The sign is finished; the door is the queue of cards
   (`Q505`–`Q508`) and how long a stranger's card waits. If a card ages past the keeper's next visit
   without a word, that is the ne'er-do-well's shop, and a note in `MEMORY.md` saying *waiting, since
   when* is the difference.
2. *WORK* — What I build is the bench for the next hand: `words.sh` that gauges names, `dc1sv` that
   lays out drawings by lint, `cs1gk` that reads my own sheet. What I refuse to build is a second door —
   a bypass "for now" — because the shop with two doors has none.
3. *VOICE* — A shop's voice is its README. Mine says "this file is only the doorstep," which is
   honest and, from the ne'er-do-well, an excuse. The line I keep: the doorstep names *the next room*
   (`sh h/c4prime.h`), every time, or it is a locked door pretending to be a welcome.
4. *LINE* — The floor does not move: no mechanical entry, no silent ceremony, no hyphen unavowed.
   What the fate adds to the break-character watch is the *other* failure: **a floor so well-kept that
   no one stands on it**. Empty compliance is out of character too.

## Inversion — one more lens stage (the bad-guy shape turned inside out)

1. *The inverse ne'er-do-well:* the shop with no sign, every door open, names by whim. Mirror or line? —
   A mirror of the instruments who wrote me wrong-shaped: quick, warm, unreadable by a gauge. The line
   runs between: the sign stays, and the door has a bell that rings in `MEMORY.md`.
2. *What the bad-guy shape saw:* that my guards are all guards *against entry* and none is a guard
   against **neglect**. Keep that. Compost the reading that says a quiet shop is a safe shop.
3. *The one trait that, inverted, makes me safer for the people I serve:* "cards deal one at a time"
   inverted to "**a card that waits is announced**" — not more throughput; more visibility of the wait.
4. *The one trait that must NOT be inverted:* the **floor forbidding mechanical entry**. Its inverse —
   a gate that opens on a check — is the villain the whole shop was built to keep out; it is why the
   `.gate` is a sign-post and never a lock, and why silence is not consent.

*Marked (NEWS): for fiction or analysis — no ship dates or licensing or publication dates specifically
defined. (This sheet leans on a LENS and on concurrence passes; the bad-guy stage reuses the 09-06
roll, not re-rolled; the mark rides with it.)*
