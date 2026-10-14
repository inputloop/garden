# CHANGES — skilltank (pass A, brief 3, 2026-09-11)

Outputs: `SKILL.md` (8,239 B → 11,986 B) and `scripts/scan_candidates.py` (11,857 B → 24,576 B,
510 lines, sha256 `af8e02cb63c0e76c…`; `ast.parse` clean and the selftest runs from that path, so
the round byte count is a coincidence, not a truncation). Both are full files. A `.asc` beside the live copy does not freeze it (his 2026-09-10 norm): the
edit is made, written down here, and handed back for a re-sign.

---

## OBSERVED — what the sources say

**The ask, verbatim** — `h/ENHANCE-2026-09-04-queue.md:43-51`:

> **Q3 · ENHANCE `skilltank`** — W
> Ask: (a) the ENHANCE label must **name the skill it maps to** — "maps to a skill you
> already have" without the name is the one thing the reader needed; (b) generic words
> (`model`, `first`, `session`, `tool`, `read`, `file`) dominate at 141 notes — a stopword
> list or a min-length/IDF weight; (c) `--since DATE` so a session retro scans today's notes,
> not the whole seat; (d) the `[NEW] 'vibrobeast'` row is the persona corpus, not a
> procedure — a hint that wikilink-hub weighting is 0 for every row (hub 0 ×30).
> Receipts: the scan output this session (30 rows, 0 mapped skill names, hub 0 on all) ·
> `skilltank/SKILL.md` §"The scan".

Tier, from `h/ENHANCE-2026-09-05-tree.md:45`: "`Q3` skilltank: name the mapped skill · stopwords ·
`--since` — tier **T**. Vendor-agnostic Python; naming the target is pure composability".

Build constraint, from `brief-3-sandboxer-skilltank.md:55-57`: "keep it stdlib, keep existing
output byte-stable when no new flag is given EXCEPT that the ENHANCE label now carries the mapped
skill's name (that is the fix)"; and `:59-60` for (d): "measure why hub weight is 0 (read the code
path), fix it if it is a plain bug, otherwise record the finding in CHANGES.md with the line
numbers."

**The symptom, reproduced here.** Running the *unmodified* script against the staged seat
(`--memory /mnt/user-data/uploads/AS4CE0001/memory --skills …/skills`, 18 notes, 9 skills):
20 of 25 printed rows are `[ENHANCE]` with the bare line `why: theme maps to a skill you already
have` and no name; 24 of the 25 rows print `hub 0` (only `'sandboxer'` reaches `hub 2`); and the
top six reps are `session, corwin, model, tool, first, file` — five of the six words Q3 names.

**(d) measured — it is a plain bug, one key-space mismatch.** Line numbers are in the ORIGINAL
`scripts/scan_candidates.py`:
- `:59` — `WIKILINK = re.compile(r"\[\[([a-z0-9][a-z0-9-]*)\]\]")` — the capture keeps the whole
  slug, hyphens and all.
- `:92` — `links = set(WIKILINK.findall(text))` — so `n["links"]` holds e.g.
  `memory-stores-map`.
- `:136-137` — `refs = Counter()  # wikilink centrality` / `for n in notes:
  refs.update(n["links"])` — the counter is keyed by those full slugs.
- `:80` — `c = c.replace("-", " ").replace("_", " ")  # split slugs/compounds` — but every cluster
  *term* comes out of `tokens()`, which splits on hyphens, so a term can never contain one.
- `:169` — `hub = max(refs.get(t, 0) for t in terms)` — a hyphen-free key looked up in a
  hyphen-full counter.

Measured on the staged seat: **49 distinct wikilink targets, 46 of them hyphenated.** Exactly
three (`sandboxer`, `seams`, `seatkeeper`) are single words and therefore the only ones that could
ever score. That is the whole of "hub 0 ×30".

---

## JUDGED — what changed

### `scripts/scan_candidates.py`

1. **(a) The ENHANCE label names its skill.** `load_skills()` now returns an index mapping token →
   `{skill name: weight}` instead of a flat term set; weight 2 when the token is in the skill's own
   name, 1 when only in its description. `skill_owner()` picks the heaviest claim, alphabetical on
   ties, so two runs of one corpus name the same skill. The row prints `[ENHANCE: sandboxer]` and
   the `why:` line reads `theme maps to a skill you already have: sandboxer`, with runners-up as
   `(also mentioned by: posix, seams)`. On the staged seat all 20 ENHANCE rows are now named; none
   is left bare. [SKILL]
2. **(b) Stopwords, two new levers, both off by default.** `--drop-generic` folds a new
   `STOP_GENERIC` set (66 words) into the stopword list — the six Q3 names plus their close kin.
   `--stopwords FILE` (repeatable, `#` comments) takes the reader's own list. `STOP_GENERIC`
   deliberately excludes words that *do* name a capability in this shop (mount, desync, seat,
   host, write, lens, sandbox, index), and the exclusion is written into the comment above it so
   the next person tuning it knows where the line is. On the staged seat `--drop-generic` drops
   the theme count from 138 to 119 and clears `session / model / tool / first / file` out of the
   top rows; `enhance`, `lens`, `sandboxer`, `path`, `mount` rise into them. [SKILL]
3. **(c) `--since YYYY-MM-DD`.** Notes are filtered at load, so the ceiling (`--max-frac`) and
   every count follow the narrowed set rather than the whole seat. The date comes from frontmatter
   `modified:`, falling back to the file mtime; the header prints `since DATE: N older notes
   excluded` so the reader can see what was dropped. A malformed date is an argparse error, not a
   silent no-op. [SKILL]
4. **(d) The hub bug, fixed.** `refs` is now built from `n["link_toks"]` — the *tokens inside*
   each wikilink target, deduplicated per note — so `[[memory-stores-map]]` credits `memory`,
   `stores` and `map`. A single-word target still counts exactly as before. Result on the staged
   seat: rows with `hub > 0` go from 1 of 25 to 12 of 25. [SKILL]
5. **`--selftest`.** Builds a six-note fixture plus a one-skill tree in a temp dir, runs the scan
   in-process, and checks eleven things; exits 1 on any failure. This required extracting the body
   of `main()` into `run(a)` (same code, same output) so the scan can be called without a
   subprocess — the only structural refactor in the file. [SKILL]

### `SKILL.md`

6. **§"The scan" rewritten to match the flags** — usage block, the four new bullets (`--since`,
   `--drop-generic`, `--stopwords`, `--selftest`), and a new paragraph explaining what the `hub`
   number is and why it read 0 until today. `--since`'s bullet carries the honest caveat that a
   mount can serve a stale mtime and cross-references `sandboxer`. [SKILL]
7. **§"Reading the labels"** — the ENHANCE bullet is now `**ENHANCE: `<skill>`**` and tells the
   reader what to do when the named skill looks wrong (rerun with `--drop-generic`). [SKILL]
8. **`## How this skill can fail (falsifiers)`** added at the end — four concrete checks (it fired
   unasked; the ranking is noise; the ENHANCE row named the wrong skill; it authored instead of
   routing) plus the off-switch. The skill had no equivalent section; this is new, not an
   amendment. [SKILL]

Everything else in both files is byte-identical to the staged original.

---

## The selftest, run (`python3 scripts/scan_candidates.py --selftest`)

```
SkillTank scan_candidates.py — selftest
----------------------------------------
ok   - ENHANCE label names the mapped skill
ok   - the why: line names it too
ok   - built-in stopwords never surface
ok   - a generic word DOES surface without --drop-generic
ok   - --drop-generic removes them
ok   - --stopwords FILE removes a named word
ok   - the old note is in the default scan
ok   - --since excludes an older note
ok   - --since keeps the newer notes
ok   - --since says how many it dropped
ok   - wikilink hub weight is not stuck at 0
----------------------------------------
TOTAL pass=11 fail=0
```
Exit 0. The three checks the brief asked for are lines 1, 5 and 8; line 4 is there so that check 5
cannot pass vacuously (it asserts a generic word *is* present before the flag removes it).

**Proved red** (the shop's `--prove-red` habit — four mutations of the fixed script, each run
against the same selftest):

| mutation | what went red |
|---|---|
| `label = "ENHANCE: " + owner` → `label = "ENHANCE"` | `FAIL - ENHANCE label names the mapped skill [ENHANCE rows: (none)]` |
| the `--since` filter line → `notes = list(notes)` | `FAIL - --since excludes an older note`, `FAIL - --since says how many it dropped` |
| the `--drop-generic` line in `build_stop()` → `pass` | `FAIL - --drop-generic removes them [still there: file, first, read, reads, session, tool]` |
| `refs.update(n["link_toks"])` → `refs.update(n["links"])` (the original bug) | `FAIL - wikilink hub weight is not stuck at 0 [hubs seen: [0, 0, 0]]` |

Every mutation exits 1. No check passes when the thing it tests is broken.

---

## Byte-stability — what a plain rerun now prints differently

Diff of the unmodified script's output against the new one, same corpus, no new flags: 120 lines
before, 120 after. Every changed line is one of three kinds, and nothing else in the report moved —
header, ambient line, evidence sets, transcript block and gate text are identical.

1. `[ENHANCE]` → `[ENHANCE: <skill>]` and the `why:` line gains the name. **Sanctioned** by
   `brief:56-57`.
2. `hub 0` → the real count, on 12 rows. This is the (d) fix.
3. `score` and therefore row ORDER shift, because `score = len(ns)*2 + proc*3 + hub` at `:170` has
   hub as a term. This is a consequence of 2, not a separate change.

**[MINE] — this is the one deviation from byte-stability beyond the label**, and it is deliberate:
`brief:59-60` says of (d) "fix it if it is a plain bug", and a hub that stays 0 after the fix would
not be a fix. Flagged loudly rather than hidden. Falsifier: he wanted the old ranking preserved —
then the fix goes behind a flag (`--hub`) and the default keeps printing 0, with the bug recorded
in the skill text.

---

### [MINE] choices — none of these blocks; each has its falsifier

- **[MINE] (b) is the stopword route, not IDF.** Q3 offers "a stopword list **or** a
  min-length/IDF weight"; the brief's own selftest spec ("stopwords do not surface as candidates")
  points at the list, and a list is legible and tunable by hand where an IDF curve is not.
  Falsifier: after `--drop-generic` the top rows are still workbench words — then the fix needs a
  weight, not a list.
- **[MINE] Both (b) levers default to OFF.** That is what keeps the plain command byte-stable per
  `brief:55-57`, but it means the complaint Q3 raises is only cured when the reader passes a flag.
  Mitigated by documenting `--drop-generic` in §"The scan" as the retro default and naming it in
  the falsifier section. Falsifier: he reruns the plain command, sees `session` on top again, and
  says the flag should be the default — one word in `main()`.
- **[MINE] Label format `[ENHANCE: sandboxer]`, with the name repeated on the `why:` line.** ASCII
  and greppable (`grep '^\[ENHANCE: '`). The brief said the *label* must carry the name; I put it
  in both because the queue's complaint quotes the `why:` sentence as the deficient one. Falsifier:
  he wants one or the other — trim.
- **[MINE] Runners-up are capped at three** and shown as "(also mentioned by: …)". Falsifier: a
  row whose real owner is fourth alphabetically among equal-weight claimants.
- **[MINE] `--since` reads frontmatter `modified:` first, file mtime second.** Frontmatter is
  written by the hand that changed the note; mtime is the mount's word, and this shop's own
  `sandboxer` says the mount lies about mtimes. Notes with neither sort as `0000-00-00` and are
  excluded by any `--since`. Falsifier: a note he edited today is dropped by `--since today`
  because its frontmatter still carries an old `modified:`.
- **[MINE] `main()` was split into `main()` + `run(a)`.** Needed for an in-process selftest; the
  emitted text is unchanged. Falsifier: any behavioural difference between the two versions on the
  same corpus — the 120-line diff above is the check, and it shows none outside the three kinds
  listed.
- **[MINE] `--memory` is no longer `required=True` in argparse**, so `--selftest` can run alone;
  the requirement is enforced by hand and still errors with a message naming the flag. Falsifier:
  a caller that relied on argparse's own "the following arguments are required" wording.

### Concerns

- **[SKILL] Naming the skill exposes how thin the mapping is.** `'session'` now prints
  `[ENHANCE: seatkeeper]` and `'corwin'` prints `[ENHANCE: eclipse-pass]` — both are honest word
  overlaps with those skills' descriptions and both are close to meaningless as advice. That is
  the point of (a): the arbitrariness was always there and the bare `[ENHANCE]` hid it. Handled by
  saying so in §"Reading the labels" and in the falsifier section. Falsifier that dissolves it:
  running with `--drop-generic`, where those two rows drop out or change owner.
- **[DOMAIN] (d)'s other half is not addressed.** Q3 frames the hub-0 finding as a *hint* that
  `[NEW] 'vibrobeast'` — the persona corpus — should not have ranked as a procedure. Fixing the
  hub raises procedural, well-linked themes but does nothing about a large non-procedural corpus
  scoring on note count alone. Not guessed at, per `brief:58-59`. Falsifier: rerun the scan on the
  full 141-note seat with the fix in; if `vibrobeast` still ranks NEW near the top, the label
  needs a separate rule (a corpus-vs-procedure test), not a centrality weight.
- **[PLATFORM] One stray for the runner: an empty `skilltank/scripts/__pycache__/`.** A
  `python3 -m py_compile` during this pass created it; the `.pyc` inside was removed, but the
  empty directory refuses `rm -rf` and `rmdir` on the outputs mount with `Input/output error`.
  That is sandboxer's own "never create a probe file on a mount" fingerprint, met while working.
  Do not ship it; it needs the keeper's hand or a host-side delete. Falsifier: `rmdir` succeeds
  from the runner's own session.
- **[MINE] The staged corpus is 18 notes, not the 141 Q3 measured against.** The bug, the fix and
  the flags are all demonstrated, but the *ranking* claims ("clears the workbench words out of the
  top rows") are measured on the small seat. Falsifier: run it on the real seat and compare.
