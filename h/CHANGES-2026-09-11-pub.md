# CHANGES — Brief 3 (H:/pub RECIPE + leak check), pass B

Files written:

- `/mnt/user-data/outputs/passB/pub/RECIPE.org` (new, 1,483 body words)
- `/mnt/user-data/outputs/passB/pub/bin/pb1ck` (new, POSIX sh, `dash -n` clean)
- `/mnt/user-data/outputs/passB/pub/CHANGES.md` (this file)

`bin/pb1ck` needs `chmod +x` when it lands: this output mount silently ignores mode changes
(`chmod +x` returns success, the mode stays 644). Run it as `dash bin/pb1ck …` until then.

Nothing under `/mnt/user-data/uploads/` was modified. No existing file was restyled or
reorganised; both outputs are new. Note: this CHANGES file quotes run output that contains
sandbox paths (`/mnt/user-data/...`). Those are the runner's, not his machine's, and this
file is not a travelling artifact.

---

## OBSERVED — what the sources say

Quoted, with path:line.

1. `/mnt/user-data/uploads/pub/.seed:3-4` — the surface model:
   > `- **`/`** (this folder): finished publications stage, instructions`
   > `- **<item>/** (a sub-folder): for publication stage, may be a work surface`

2. `/mnt/user-data/uploads/pub/.seed:6-11` — protection and the tombstone:
   > "Materials in the top level folder ... should be protected via dot folder, gate/tunnel or
   > otherwise safe for general use/reuse.  Materials not intended for COPYING/LICENSE
   > branding ... may so indicate with a "tombstone" (zero byte) COPYING or by creating that
   > file with whatever informational context is needed to scope these contexts."

3. `/mnt/user-data/uploads/pub/.seed:41` — the release shape and the janitorial side:
   > "In the top level folder the set of latest distributable paired archive/sig (given I do
   > signing) unless for I share as text with integrial sig, and then whatever packaging
   > instructions and support mostly perhaps within README.org"
   > "C4 or other automation can have the janatorial side helping to sync common use tools out
   > for these working-group and/or staging area stages."

4. `/mnt/user-data/uploads/pub/.seed:45` — what makes a duplicate keepable:
   > "if instruments tell the story of the duplicates/mutated clones, then that is story and we
   > keep it around -at least in journaled out or archived form- in case we want to tell it later"

5. `/mnt/user-data/uploads/pub/.seed:47` — the signing key:
   > "Find my signing key at GNU Savannah: https://savannah.gnu.org/u/carlc"

6. Brief 3 header (o64, his words) — the ask this recipe exists for:
   > "handles the local transport concerns smartly, meaning not leaking details of my systems
   > unnecessarily with these materials in publication apparatus (nor content proper, obviously,
   > unless such detail happens to form some material record and so we shrug at leaving whatever
   > path showing for that reason)"

7. `/mnt/user-data/uploads/pub/motive-inversion/.c4/PROVENANCE.tsv:5-10` — the sync model:
   > "SYNC MODEL (currency-pull, not a daemon): at the moment of inception of a mutation, pull a
   > cloak of currency over the file (bring it current); that pull IS the only local lock.
   > Reads always win the read-first battles. Write-races are governed by PRIORITY / value-
   > weighting (C4's, or the personal lens "until on"), by Corwin's deliberation — never a mutex.
   > There is no fixed source folder: currency is whatever pulled it last at a mutation; drift
   > stays legible here so a race is a story, never a silent loss."

8. `/mnt/user-data/uploads/pub/motive-inversion/.c4/PROVENANCE.tsv:3-4,11,12` — duplication, the
   tear, and the columns:
   > "Duplication is fine because this file tells its story (Corwin's rule); a silent clone is
   > the only sin."
   > "On a re-lift, re-sha the lab origin; a changed sha is the observable tear, not a surprise."
   > "# columns: local_copy <TAB> lab_origin <TAB> sha256_16_at_lift <TAB> lifted <TAB> note"

9. `/mnt/user-data/uploads/pub/motive-inversion/.c4/PROVENANCE.tsv:14-30` — every `lab_origin`
   in the one existing item is already tree-relative (`c4/h/…`, `c4/facts/…`, `c4/decks/…`) or
   the literal `(authored in this item)`. The practice the brief asks me to write down is
   already the practice in use.

10. `/mnt/user-data/uploads/pub/motive-inversion/README.org:60-64` — self-containment:
    > "*Self-contained is the rule.* Everything this paper needs sits /right here/ — the sources
    > are lifted into =.c4/sources/= as byte-verified copies"

11. `/mnt/user-data/uploads/c4/bin/sc3dm:55-56` — the sibling discipline:
    > "A PROOF-BEARING SET MUST BE PROVEN PER MEMBER, NEVER IN AGGREGATE, IF ANY MEMBER MIGHT
    > EVER BE HELD BACK."
    and `sc3dm:73-76` — "NEVER BLOCKS ... It reports, it verifies, it emits."

12. `/mnt/user-data/uploads/c4/bin/aw2ri:20-31, 74, 171-176` — the house tool shape I copied:
    the AS4CE name declaration with run-level in the middle, the `exit 0/1/2` line, and the
    prove-red idiom ("scratch in the PARENT, body in a SUBSHELL, cleanup in the parent ... NOT
    `( body ) || rc=$?`").

13. Brief preamble (o32, his rule 2026-09-11) —
    > "add falsifiers for each skill as we take a next turn with it"

---

## JUDGED — my reading and the choices I made

### The shape of the answer

- **[DOMAIN]** "Unnecessarily" (OBSERVED 6) is the whole problem. A leak and a material record
  are byte-identical; only he knows which is which. So the check **reports and never fixes**,
  which is also the posture `sc3dm` already takes in this shop (OBSERVED 11). *Falsifier:* if he
  says he wants a release blocked or a path stripped automatically, this reading was wrong.
- **[SKILL]** I made the check a sibling of `sc3dm`, not a rival, as the brief directs: `sc3dm`
  asks whether a member may travel and keeps the proof intact; `pb1ck` asks whether what travels
  says too much, and re-verifies the lift hashes. No overlap in what they read or emit.
  *Falsifier:* a job either tool can do that the other now duplicates.
- **[MINE]** RECIPE.org gets a `## How this recipe can fail (falsifiers)` section even though it
  is a recipe, not a skill. The rule (OBSERVED 13) names skills; I applied it by extension
  because the recipe is the thing that will be followed. *Falsifier:* he says falsifier sections
  belong only in `SKILL.md` files.
- **[MINE]** RECIPE.org writes the surface as `<H>:/pub/` (the `.seed`'s own notation) and elides
  drive letters in examples, so the recipe does not itself contain the thing it hunts. One quote
  from `.seed:37` was paraphrased for the same reason. *Falsifier:* he finds the elision precious
  and would rather read a real path.

### The tool

- **[MINE]** Name `pb1ck` = PUB / BOUNDARY / run-level 1 / CHECK / KEEPER, declared as my reading
  in the header and marked **PROVISIONAL** with a do-not-sign-while-provisional note, per the
  brief. *Falsifier:* he reads the letters differently, or B/K do not fit the m/t register table.
- **[MINE]** `.c4/leakwords` hits report `leakword-N` and **withhold the matched word**. His host
  and user names are exactly the strings he marked as not-for-travel; a report that echoes them
  has re-leaked them into something pasteable. Built-in pattern hits *do* echo the match, because
  there the match is the actionable part. *Falsifier:* he finds the withholding unhelpful — "just
  show me what it found".
- **[MINE]** `.c4/travels` is the mechanism for "the `.c4/` dot-folder never travels unless the
  item says so". The brief names the rule but not the file. Paths relative to the item root, one
  per line, `#` comments, a directory means everything under it. *Falsifier:* he already has a
  name or a mechanism for this elsewhere in the tree.
- **[MINE]** `.c4/mail-ok` widens the allowed-address list beyond the README `#+AUTHOR:`/`#+EMAIL:`
  lines. Without it, `motive-inversion` reports his own `corwin@gnu.org` as undeclared (it does —
  see the real run below). *Falsifier:* he'd rather fix the README author line than carry a second
  file.
- **[MINE]** A fourth provenance state, `NOHASH`, for rows whose `sha256_16_at_lift` is `-`
  (authored in the item, never lifted). The brief names MATCH / CHANGED / MISSING; these rows fit
  none of them and silently calling them MATCH would be a lie. `NOHASH` never sets the exit code.
  *Falsifier:* he wants those rows to carry a hash after all.
- **[MINE]** A non-fatal `WARN` when a `lab_origin` is not tree-relative. `PROVENANCE.tsv` does not
  travel, so this cannot set the exit code without breaking the brief's exit contract — but a bad
  origin gets quoted into a README later, and then it does travel. *Falsifier:* he considers
  `PROVENANCE.tsv` entirely out of scope for this check.
- **[MINE]** Binary files are skipped and the skip is printed (`SKIP … binary`). A binary can carry
  a leak; grep over one is noise. Saying nothing would have been the dishonest option.
  *Falsifier:* a real leak ships inside an image or PDF and this line is why nobody looked.
- **[PLATFORM]** The tool needs GNU grep (`-o`, `-E`, `\b`) and `sha256sum`. The shell is strict
  POSIX and runs under `dash`; the utilities are not. Stated in the header. *Falsifier:* it is run
  somewhere with busybox grep and silently finds nothing.
- **[MINE]** Two readers, as the brief requires: the scan is grep-driven, and the final tally is
  recounted by `awk -F'\t'` over the emitted report. They are compared out loud (`AGREE` /
  `DISAGREE`), and a DISAGREE forces exit 1 — a tally nobody checked is not a tally.
  *Falsifier:* the two readers can never disagree because they share a parser (they do not: grep
  matches line prefixes, awk splits fields).

---

## The leak patterns, each with its falsifier

A falsifier here = a piece of legitimate content the pattern would flag anyway.

| # | class | pattern | falsifier (a false positive it would raise) |
|---|-------|---------|---------------------------------------------|
| 1 | `drive-letter` | `(^\|[^A-Za-z0-9_])[A-Za-z]:[\\/]` | A quoted Windows path that **is** the record — e.g. `README.org:84` pins a model at a `F:/…` location; flagging it is correct, removing it would destroy the pin. |
| 2 | `unc-path` | `\\\\[A-Za-z0-9_.-]+\\` | A code sample or regex literal containing doubled backslashes, e.g. `\\d\\w` in documented shell or LaTeX. |
| 3 | `session-path` | `/sessions/` | A documented REST route (`POST /sessions/`) or a public URL path in a paper about web APIs. |
| 4 | `home-path` | `/home/[A-Za-z0-9._-]+\|/Users/[A-Za-z0-9._-]+` | A tutorial's deliberately generic example, `/home/user/project` — no one's machine. |
| 5 | `home-var` | `\$\{?HOME\}?\|%USERPROFILE%\|%HOMEPATH%\|%HOMEDRIVE%` | Any prose *about* shell variables. **Confirmed:** RECIPE.org trips this on its own pattern list. |
| 6 | `mount-path` | `/mnt/` | Prose about Linux mount conventions. **Confirmed:** same, RECIPE.org's own pattern list. |
| 7 | `ip-v4` | `\b([0-9]{1,3}\.){3}[0-9]{1,3}\b` | A four-part version string. **Confirmed by test:** `version 1.2.3.4 of the tool` is reported as `ip-v4`. |
| 8 | `ip-v6ish` | `\b[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){4,7}\b` | A MAC address, or any colon-separated hex field with five or more groups in a dump. Also a *false negative*: compressed IPv6 (`fe80::1`) is **not** matched. |
| 9 | `email-undeclared` | `[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+` minus the declared set | A co-author's or upstream maintainer's public address that belongs in the text. **Confirmed:** his own `corwin@gnu.org` at `README.org:111`. Widen via `.c4/mail-ok`. |
| 10 | `leakword-N` | fixed text, case-insensitive, from `.c4/leakwords` | A leakword that is also an ordinary substring — a host named `forge` matches "forged", "forgery". No word boundary is applied, deliberately: a hostname inside a longer token is still a hostname. |

Two gaps named rather than papered over: **binaries are skipped** (reported as `SKIP`), and a
**missing `.c4/leakwords` file means host and user names are not checked at all** — the report
prints `ABSENT` on that line so a clean run cannot be mistaken for a thorough one.

---

## Runs (all under `/usr/bin/dash`)

### `dash -n bin/pb1ck` → clean.

### `bin/pb1ck --prove-red` → exit 0

```
  RED OK   a clean item exits 0
  RED OK   ...with no LEAK line
  RED OK   ...and the two readers AGREE
  RED OK   ...the present lifted source is MATCH
  RED OK   ...the absent one is MISSING
  RED OK   ...the declared address is NOT a LEAK
  RED OK   ...and it IS shown as the declared one
  RED OK   a planted drive-letter path is REPORTED
  RED OK   a planted /sessions/ path is REPORTED
  RED OK   ...and the run exits 1
  RED OK   ...at the right line numbers
  RED OK   a corrupted lifted source reads CHANGED
  RED OK   ...and the run exits 1
  RED OK   a leakword hit is REPORTED
  RED OK   ...and the word itself is NOT in the report
  RED OK   an undeclared e-mail is REPORTED
  RED OK   a leak inside .c4/ is NOT scanned by default
  RED OK   ...and IS scanned once .c4/travels names it
  RED OK   a missing item does not pass silently
  (no ITEMDIR given: the scrubbed-real-item control was not run)
prove-red OK: planted paths are seen, a tear reads CHANGED, the keeper's own
              words are reported without being echoed, and .c4/ stays home.
```

### `bin/pb1ck --prove-red /mnt/user-data/uploads/pub/motive-inversion` → exit 0

The green control the brief asks for: a **scrubbed copy** of the real item passes clean. (The
real item as it stands does not — see below. `--prove-red ITEM` copies it, blunts every pattern
class in the travelling files, and asserts the copy comes back clean; the original is never
touched.)

```
  RED OK   a SCRUBBED copy of the real item passes clean
  RED OK   ...with no LEAK line left
  RED OK   ...even though MISSING rows remain (they never set the exit code)
prove-red OK: planted paths are seen, a tear reads CHANGED, the keeper's own
              words are reported without being echoed, and .c4/ stays home.
```

### `bin/pb1ck /mnt/user-data/uploads/pub/motive-inversion` → exit 1

**Real hits in the existing item. Not fixed — his call, since a path may be the record.**

```
-- WHAT WOULD TRAVEL --
   files outside .c4/, plus whatever .c4/travels names:  2
   .c4/travels        absent (so .c4/ does not travel)
   .c4/leakwords      ABSENT -- host and user names are NOT being checked
   declared e-mail    corwin@bru.st

-- LEAK SCAN --  file, line, pattern, match. Nothing either side of the match.
LEAK	COPYING	1	drive-letter	 H:/
LEAK	README.org	9	drive-letter	=H:/
LEAK	README.org	48	drive-letter	=H:/
LEAK	README.org	84	drive-letter	=F:/
LEAK	README.org	111	email-undeclared	corwin@gnu.org

-- TALLY, counted twice --
   leak hits          5   grep 5 / awk 5   AGREE
   CHANGED rows       0   grep 0 / awk 0   AGREE
   MISSING rows      16   local_copy named in provenance, not on disk
   verdict         NOT CLEAN -- see above. Nothing was changed; the calls are yours.
```

The five, as `file:line`, with what each one actually is:

- `COPYING:1` — "TOMBSTONE — pre-branding placeholder (per H:/pub/.seed)". Scaffolding: the
  tombstone could cite "the pub seed" and lose nothing.
- `README.org:9` — "The =H:/pub/motive-inversion/= item is the ...". Scaffolding.
- `README.org:48` — "* Surface model (per =H:/pub/.seed=)". Scaffolding.
- `README.org:84` — "Model pinned at =F:/claude/c4/facts/self-contained-and-currency-is-pulled-at-mutation=".
  **Arguably the record** — it names where the model was fixed, which is the kind of detail his
  own rule says we shrug at. His call.
- `README.org:111` — `corwin@gnu.org`, his own second address, next to the key fingerprint. Not a
  leak in any real sense; either add it to `.c4/mail-ok` or put it on the `#+AUTHOR:` line.

Also standing, and reported but not fatal: **16 MISSING rows** — every `.c4/sources/…` file named
in `PROVENANCE.tsv` is absent from the staged copy of the item. On his disk they presumably exist;
if they do not, the item is no longer self-contained and the README's central claim is stale. Worth
a look, and a MISSING row is deliberately not a failure (the brief's exit contract, and a
half-lifted item is a normal in-progress state).

### Two extra checks I ran against a scratch item (not part of prove-red)

- A binary file (`logo.png`) → `SKIP logo.png 0 binary`, scan continues.
- A `lab_origin` written as a drive path → `WARN .c4/PROVENANCE.tsv 2 lab-origin-not-tree-relative`,
  exit unaffected.
- `version 1.2.3.4 of the tool` → reported as `ip-v4`. This is the confirmed false positive in
  row 7 above.
