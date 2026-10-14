# LENS — opposed-bias pass on `on1gw`
Read: `on1gw`, `c-en.tsv` (68 rows), `scaffold/page.html`, both shots, the brief, the host contract. Every
measurement below was **run**, not quoted; values I invented are marked *[guess]*.

## (A) FINDINGS — most damaging first

**F1 · The suite goes green on a page missing half its doors.** `--tally` claims "counts by two readers" (`on1gw:19`)
but both readers are the same awk `END` block: `reader tally` (`:104-108`) and the page's `data-tally=` (`:140`) count
the same `ks[]`/`ss[]`; nothing counts what the page *emitted*. **Rule:** brief §e — *"Two independent readers
agreeing is evidence; one reader agreeing with itself is not."* **Falsifier:** I mutated the room loop to skip every
other door — the page emitted **34 of 68**, and `--lint` said 0 faults, `--tally` said "two readers agree",
`--prove-red` said 6/6, exit 0. **Fix:** second reader counts `data-id="` out of the emitted HTML; prove-red mutant
that deletes a door and must go red.

**F2 · SOONEST is hand-typed and drawn as a measurement.** Every value is a literal in the generator
(`build_opps.py:13,20,27,34…` — `help_soonest=5`). No rubric, no derivation, no scale definition anywhere; the page
renders it as a filled five-segment meter `▮▮▮▮▯ 4/5`, `aria-label="helps soonest 4 of 5"` (`on1gw:66,160`). **Rules
2, 6, 8:** show the measure; invented numbers use 4/9/17 *and say so*; "quoted, not run". **Falsifier:** find one
sentence saying who set it and what 3-vs-4 means — there is none. **Fix:** print the rubric in the masthead and stamp
each meter "instrument's guess", or derive it.

**F3 · "His pen" is the instrument's pressure dressed as his queue.** 30 doors in *Awaiting a look — his pen*
(`on1gw:148-153`). Three say in their own WHY that he never asked: o51 *"Claude's own inference, not something Corwin
actually asked for"*; o52 *"my proposed extension, not your ask"*; o53 *"you never asked to reconcile it"*. Parked
**because** he never asked, re-presented as awaiting his decision. **Rule 7.** **Falsifier:** an ASKEDBY column — only
o63/o64 (`SOURCE = chat 2026-09-11 (his words)`) survive it. **Fix:** split it — "you asked for this" above, "the
instrument proposes" below, counts on each.

**F4 · Four of six flavors put state text under WCAG AA; three under 3:1.** Measured in-page, computed colour vs
computed background, 12px text: `studio` held **2.39** · done **2.90** · ruling **2.38**; `blueprint` **1.79 / 2.17 /
1.78**; `console` **2.42 / 2.94 / 2.41**; `illustration` open **3.38**, dim **3.90**, chip **4.09**. Cause: the dark
skins set `--ink/--dim/--accent/--shape` but never `--warn/--danger/--good`, so light-mode `#704900 / #8c3529 /
#1f6b3a` land on near-black panels (`on1gw:195-199` vs `:194,210`). **Rule:** brief §d — `c4show` is the reference,
AAA both schemes, every pair measured. **Falsifier:** the colour tool over 5 state pairs × 6 skins; all ≥4.5 and I am
wrong. **Fix:** define the three role tokens in every skin; assert contrast in `--lint`. *(This page ships exactly the
defect row **o16** exists to catch.)*

**F5 · Every door body and every citation is `display:none` at load.** All 68 doors are closed `<details>` (`:160`),
21 more sit behind a second fold (`:151`), and `.src{display:none}` (`:228`) hides the SOURCE of every row until
`floods` is ticked. **Rule 10:** *"No tabs/carousels/`display:none` during streaming — show all content stacked."*
**Rule 8**, and this page's own row o11: *"a quote wears its citation inline."* **Falsifier:** read one door's plain
words in the host without clicking. **Fix:** source inline always; top nine doors open by default.

**F6 · The "named absences" band is hardcoded fiction.** `◇ unwired: PMO ledger` and `◇ chambered: SAVANNAH` are
literal strings in the renderer (`:146`), derived from nothing, emitted for *any* table, changeable only by editing
the file that `:10-12` says is never edited ("DERIVED from the table, never a fork of it"). **Rule 3** (`unwired` =
honest absence of an *instrument*). **Falsifier:** run it over a one-row synthetic table — the same two absences are
still asserted. **Fix:** absences become rows (`KIND=ABSENT`) with a `d/` twin.

**F7 · The legend is false: 1 and 2 are the same thickness.** Masthead says *"Thicker door = helps sooner"* (`:142`).
CSS gives `.door` 2px, `.m3` 4px, `.m4` 7px, `.m5` 10px — there is **no `.m1`/`.m2` rule** (`:217-218`); in the look
list only `.m4`/`.m5` exist (`:213`), so 1, 2 **and** 3 all render 2px. **Rules 2, 3.** **Falsifier:** measure
`border-left-width` on an m1 and an m2 door. **Fix:** five widths, or cut the sentence.

**F8 · A malformed STATUS is smoothed into `unwired`, and the tally silently loses the row.** I set o01's STATUS to
`opne`: the page emitted `<span class="st s-opne">◇ unwired</span>` — a data fault wearing the honest-absence glyph
(`:64`) — and `--tally` printed `rows=68` with status counts summing to **67**, still reporting "two readers agree"
(`:107,140`). Note `held-by-keeper` and `unwired` already share the glyph ◇, so shape is not a third channel for those
two. **Rules 3, 4;** brief §d: *malformed rows NAMED in the gauges, not smoothed.* **Fix:** `sword()` returns
`MALFORMED` off-list; tally asserts `sum(status)==rows`.

**F9 · `--page` never lints, and interpolates ID/STATUS/KIND unescaped into attributes.** `id[i]`, `st[i]`, `kind[i]`
go into `href`, `id=`, `class=`, `data-*` with no `esc()` (`:152,160,162`). I set one ID to `o02"><img src=x
onerror=alert(1)><b id="x`: it landed three times in the page and `--page` exited **0**; `--lint` alone catches it,
and `:29` implies a faulty table cannot render green. It does. **Rule 10** (validate before acting on input). **Fix:**
lint before render; `esc()` every field.

**F10 · Send fires with nothing chosen and still asks for a register write.** Clicking *Send my inputs* with zero
calls composes: *"…TRACKS: - 09:37Z flavor studio - 09:37Z world fluid … Please: apply the calls above to c/en
(status/owner)"* — an edit instruction with no calls above it and 14 lines of chrome-fiddling as its content
(`:290-297,303-314`). **Rule 10** (validation MUST: inline error, stop). **Fix:** refuse with a 13px `--text-danger`
message; keep flavor/world churn out of TRACKS.

**F11 · The `--text` twin cannot carry a call.** grep over `--text`: `my call` 0, `do next` 0, `ask me` 0, `flavor` 0,
`world` 0, `floods` 0, `wires` 0, `Tracks` 0, `unwired` 0, `SAVANNAH` 0. The twin is read-only, with no wire list and
no absences band (`:120-131` vs `:145-185`) — the page's whole purpose, collecting his calls, has no `-nw` register.
**Rule 9.** **Fix:** print `[ ] next [ ] hold [ ] done [ ] drop [ ] ask ____` per door and accept the filled file
back.

**F12 · Four of the five "worlds" change nothing.** Computed tokens at flavor=host: office / fluid / batcave /
fortress are **identical** on `--bg --ink --accent --panel --shape --font`; matrix differs only in `--font` (`:145`
offers five; `:246-252` is all the CSS there is). `fortress` is invented — brief §a records it as *"not defined as a
palette or rule"*. **Rule:** brief §a, *a toggle with no rule is "a broken promise"*; §h risk 1 predicted this before
the build. **Fix:** ship the two that differ, or author the rest.

**F13 · Touch targets are 32-36px against his own 44px floor.** `min-height:32px` on `summary`, `.ctl select`, `.more
summary`, `fieldset label`; `36px` on `button` (`:206,213,220,232,241`). **Rule:** brief §d, *"44px minimum touch
targets."* **Falsifier:** measure a summary row. **Fix:** 44px.

**F14 · The heaviest type on the page is weight 700.** Measured `font-weight: 700` on `.look li b` (`:152`, no reset)
— the title of each row in his pen. **Rule 10:** *"Two weights only: 400, 500. Never 600 or 700."* **Fix:** `.look
b{font-weight:500}`.

**F15 · `--lint` never checks SOURCE or QUOTE — the one rule that makes a row citable.** Lint covers ID, KIND, STATUS,
OWNER, SOONEST, PLAIN, DEPENDS (`:89-99`); not SOURCE, QUOTE, WHY, TITLE, SKILL. A row with both empty passes "0
faults" and renders `evidence “” `. And SOURCE carries four different kinds of thing in one identical `<span
class="src">`: file:line (o01), a path with no line (o66), a shell command (o61 `c4/o/tr (sh bin/ot3he --held)`), and
"chat 2026-09-11 (his words)" (o63/o64); o30's QUOTE is a bare path, not a quote. **Rule 8.** **Fix:** lint both; mark
the evidence kind (file · command output · his voice).

**F16 · `heat` is hue-only, and it fires when he marks a door *done*.** `toggle('heat', soon>=4 && value!=='drop')`
(`:306`) paints the urgency wash for **done** and **hold** too; the wash (`:219`) carries no word and no glyph. **Rule
3;** brief §c (heat = urgent ∧ cared-about). **Falsifier:** greyscale the page after calling o01 "do next". **Fix:**
heat only for `next`/`ask`, and say the word.

**F17 · The stamp reads as freshness the tool says it does not claim.** *"68 doors in 35 rooms, read from `c/en` at
2026-09-11T09:33Z"* is the **run** time (`:36,142`); `:8` says the tool "claims no freshness". Brief §g: *a board that
claims currency must check it.* **Falsifier:** `touch -t 202501010000 c/en && on1gw --page` — the stamp still says
now. **Fix:** print the table's mtime, or "table age NOT CHECKED".

## (B) RANKING AUDIT — nine rows I would move *[every value below is my guess, marked]*

| row | now | mine *[guess]* | from its own WHY / QUOTE |
|---|---|---|---|
| **o50** | 4 | **5** | *"The tool that signs everything else doesn't currently verify against its own signature — a foundational integrity gap."* o15, o17, o24, o49, o55, o61 are all signing/publishing acts riding on it. Nothing signed before this is worth the signature. |
| **o49** | 4 | **5**, and cut o50's DEPENDS | Its QUOTE is *his own voice*: *"SIGN NOW, not at the next crank."* The only row whose urgency he stated himself, ranked level with instrument-invented 4s — and the integrity fix is held hostage to a typo signing. |
| **o01** | 5 | **4** | The sole 5. Its WHY cites *"marked FIRST in the reclass tree"* — the instrument's earlier ranking as evidence for its current one. Impact is one wrong error string. |
| **o55** | 3 | **5**, or not a door | A standing prohibition: *"awaiting Corwin's explicit GO before any … persona/third-party content publishes."* Rendered as door 11 with a "do next" radio beside it. A consent gate is not an opportunity. |
| **o63 / o64** | 3 / 3 | **4 / 4** | The only rows sourced to *"chat 2026-09-11 (his words)"*. Provenance is not a ranking dimension at all, so the two things he asked for sit below fifteen the instrument surfaced from its own queue notes. |
| **o67** | 2 | **4** | *"this very view is built on an unregistered word."* Until he rules, `on1gw` cannot honestly take a `c/t` row (brief §e:4). A tool ranking its own naming blocker at 2 is grading its own homework. |
| **o16** | 4 | **5** | *"a check that cannot fail"* in the colour tool — precisely the defect F4 found in this page. Blast radius: every surface the shop ships. |
| **o21** | `open` | **`held-by-keeper`** | OWNER is already `keeper`; BLOCKED is *"host-side file lock (editor holding it open?)"* — a question mark, not a diagnosis. Probably the same lock as o66's *"keeper-locked from the sandbox"*; neither names the other in DEPENDS. |
| **o28–o31** | `held-by-keeper` ×4 | **`open`** | All four quote the same boilerplate — *"surfaced by operator flag (no score; lands on HOLD)"*, BLOCKED *"more evidence"*. Nothing waits on his pen; they wait on evidence. Four identical non-findings inflate "68 doors" by 6%. |

**Also disputed:** o09 is `STATUS=done` **and** `KIND=HELD` — mutually exclusive. o41 is a `done` FIX at 1
burying a live caution (*"Never certify red-looking results straight off the mount"*) in a shut row. o43
waits on o42, a keeper ruling, yet renders **● open, 4 of 5** — STATUS has no word for "cannot start". o61
is *four* cite calls behind *one* radio group; he cannot say yes to #13 and no to #14.

## (C) THREE THINGS THE VIEW CLAIMS AND DOES NOT DO

1. **"`--tally` counts by two readers; exit 1 if they disagree" (`:19`).** One reader compared with itself
   (F1) — demonstrated by a page emitting 34 of 68 doors and passing tally, lint and prove-red.
2. **"`--prove-red` plants faults and asserts the suite reports them" (`:21`).** All three reds are *lint*
   faults on a one-row synthetic table; no mutant is planted in the renderer, the ranking, the tally or the
   twin. Green 5 is `[ "$named" -ge "$rows" ]` where `named` counts **98** door-lines (each keeper door
   prints twice) against 68 rows — a twin printing the look list thrice and no rooms would pass. `hdr=$(sed
   -n '1p' "$DS")` (`:343`) is computed and never used.
3. **"DERIVED from the table, never a fork of it … a host restyles by setting variables, never by editing
   this file" (`:10-12`).** Two absences are hardcoded strings (F6) and five complete hex palettes live in
   the file (`:195-199`) — which is also why F4 happens. Free fourth: *"stops rather than degrade"* — a
   descriptor missing one column emits 11,719 bytes of headless partial page to stdout, then exits 1.
   Free fifth: `scaffold/page.html` and both screenshots are one build stale (no look-list fold, no door
   count in the heading, unfixed quote escaping) — what he will look at is not what the tool now emits.

## (D) GRIN OR WINCE

He would grin for ninety seconds — the shape is right, PLAIN is the most humane column in the shop, and
`--lint`, `--tally`, `--text`, `--prove-red` all *exist*, which is four more than most tools carry. Then
Bryant says **prove it**, and the wince lands in one command: I broke the renderer so it dropped **34 of 68
doors** and the tool answered `--lint: 0 faults`, `--tally: two readers agree`, `--prove-red: 6/6`, exit 0.
That is the failure his own house already named — *a green suite that cannot go red is indistinguishable
from a suite that is not running* — sitting inside the tool whose masthead is a count. The rest of this
list is bugs; that one is a **false witness**, and it is why sixteen other faults were found by a stranger
instead of by the suite. **The single change that flips it:** make the second reader actually second —
count `data-id="`, `data-status="` and `data-soon="` out of the *emitted HTML* with a separate program,
compare to the table, and add a prove-red mutant that deletes one door and must go red. Once the tally can
go red for a page that lies, every finding above becomes a test he can write instead of a paragraph I had to.
