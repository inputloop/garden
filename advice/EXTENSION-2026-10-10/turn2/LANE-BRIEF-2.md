# Lane brief, turn 2: the partnership edition

## Read first
1. `advice/EXTENSION-2026-10-10/LANE-BRIEF.md`. Its rules still hold: access, spec first,
   prove-red, R-rows and ChangeLog in your lane's files, no commit, no `make dist`, no install, no
   signing, the never-read list, one local-model call at a time.
2. Corwin's words for this turn: `$HOME/mnt/c4/spells/extension/runs/2026-10-10/turn2/BRIEF-study.md`.
3. The four studies in `$HOME/mnt/c4/spells/extension/runs/2026-10-10/turn2/study/`:
   - S6: dist, dist-fam and pub;
   - S7: Bryant's graph and ours;
   - S8: UI threads and the single-page app;
   - S9: voice, the C4QL tag, the Terms and Bryant's skills.

## What changed since turn 1
- Corwin signed and minted 1.1.3, installed it and restarted.
- `G:\dist-fam` is now mounted (`$HOME/mnt/dist-fam`).
- Another session is adding soft skills while we work.

## Voice rules for everything you write (his ask this turn)
- **First person, signed once, at the very end.**
  - Never refer to yourself in the third person mid-text: no "the instrument", no "Mentat
    (for Corwin)" in running prose.
  - No bracket tags such as [MINE].
  - Don't weigh text down with "I wrote this part". Mark only his words as his, and do it by
    quoting them.
- **Quote him so it celebrates the words and the reader.** Use his exact words, inline or as a
  short pull-quote, with no apology and no "(verbatim)" boxing.
  - Spelling may be healed in work products; list each heal in the journal or ChangeLog.
- **Long documents (READMEs, manuals) start general and plain.**
  - Let voice arrive in "drops and dabs" as the context narrows.
  - Unpack each term of art where it first earns its place, showing why it helps.
- **Partnership.** Corwin and Bryant pool all their toys to share under a collective licence,
  with Corwin the more experienced on licensing. Nothing should read as one person's pride.
  - Credit order is Corwin, then Bryant, then Bridgit (K Smith) as editor where she edited.
  - Licences:
    - prose and art: CC-BY-SA-4.0;
    - code: GPL-3.0-or-later OR LGPL-3.0-or-later;
    - the TA model alone: CC BY 4.0.
- **Dates in file names.** Don't add new ones where a stat or the content already carries the
  date. Leave existing names alone.

## Seen arriving
Keep a "Seen arriving" section in your hand-back for any file that changes under you and that you
didn't change. Don't edit it. Also append one row per sighting to
`$HOME/mnt/c4/spells/extension/runs/2026-10-10/turn2/ANOMALIES.md`.

## Lanes (no two share a file)

### Lane G: the garden view and the single-page app
**Files:** `bin/gv1mt`, `site/garden/` (new), the Makefile target `garden` (only lane G edits the
Makefile), `tests/gv1mt-*`.

1. **Build `bin/gv1mt`** (Python stdlib) to the `garden-view/data v1` model in S7. It reads, at
   each build:
   - Bryant's 09-17 skill-tree data and his newest nexus map;
   - our skills, soft skills, the six servers and their state words;
   - the persona ledger edges;
   - the 27 option cards, resolved and open, and the ERRATA open items;
   - our counterparts table (`conventions/bryant-counterparts.tsv`).
   It writes `site/garden/data.json` plus one self-contained `site/garden/index.html`.
2. **The page.**
   - His ring, redrawn, beside ours, with links between them (counterpart, routes-to, wraps,
     checks and falsifies, derived-from). The tensions show as their own marks, open and
     resolved.
   - A compass view with his axes, each placement a guess carrying a likelihood and
     confidence pair:
     - E/W: Accessibility ↔ Interoperability;
     - N/S: capability as imagination, own-ness and freedom of use ↔ conventionality,
       intuitiveness, custom and boundary as signage.
   - Doorway cards for MCP, the Wire, the Tavern and C4. Each shows the snapshot status as
     built, plus the available actions as copy-a-prompt "Ask Claude" buttons (hand-test's
     form). Optional live probes run only where S8 says they can work (c4-serve 8781,
     org-httpd 8042), and every badge says live / as built / not reachable, in words.
   - Follow the accessibility rules in S8 §4:
     - OS light/dark plus a manual switch;
     - colour pairs checked with color-theory;
     - state never shown by colour alone;
     - keyboard reach to everything;
     - a text story of every drawing;
     - no outside fonts or CDNs;
     - the snapshot part works with JavaScript off.
3. **An awk recount check** against the data. Headless Playwright plus axe run in both themes,
   with prove-red; field-comic's `hl1rn.py` is the pattern, and Playwright may already be in the
   VM. If you can't run them, the runner exits 77 with NOT CHECKED.
4. **`make garden`**, and hook it into `dist` so the page is pulled current at every build.
5. Credit Bryant's graph as the starting point, by name, in the page.

### Lane T: the Terms, the voice and the README
**Files:** `bin/tp2mt`, `c4/man/licensing-defaults.md` (a TERMS v2 block; archive v1.1 first) and
the five licence carriers S6 names, `AUTHORS`, `polygram/plugin.py` (the README template),
`GRAMMARY.md`, `conventions/VOICE.md` (new), the shipped prose with [MINE] or "the instrument"
(edit the skills' SKILL.md only where shipped prose says so; list every signed file under
"re-sign owed").

1. **TERMS v2 and the Terms of Service prose.**
   - Start from S9's draft. Make it two partners and one shared collection.
   - Keep the warmth, but make it unboastful and concrete.
   - Add Bryant to AUTHORS.
   - Add the provenance row tp2mt owes to H:\pub/persona (S6).
2. **Privacy:** small edits only, in the same voice.
3. **`conventions/VOICE.md`:** S9's voice guide, in his words where possible, with a falsifier.
4. **The README template.** Rework it as the long-document model: plain at the top, then voice in
   drops and dabs, each term unpacked once.
5. **GRAMMARY.** Replace the 74 "(in the author's tree, not shipped)" markers with one short glyph
   or word plus a legend line. Keep `tests/grammary-paths-*` green by updating the spec.
6. **First-person pass** over the shipped prose. Report the before and after counts of [MINE],
   "the instrument", third-person self-reference and mid-text bylines.

### Lane B: Bryant's skills and the C4QL tag resolver
**Files:** `SOFT-SKILLS/omni-tool/` and `SOFT-SKILLS/frugal-offload/` (new; his bytes, kept whole,
with a NOTICE in the gauntlet/parallax pattern), `polygram/mcp/softskills.py` (the YAML-quote fix
for parallax's name), the NOTICE table for gauntlet and parallax, `bin/tg1rs` (new),
`conventions/C4QL-TAG.md` (new), `tests/tg1rs-*`.

1. **Bring in omni-tool and frugal-offload as soft skills.**
   - Take each from his newest drop, byte for byte, pinned by sha256 in its NOTICE.
   - Never edit his bytes.
   - Run candor-gate's checks (provenance, opt-in, no dangling routes) and report them.
   - Answer his question in the hand-back: is omni-tool still missing (yes, until now), and does
     frugal-offload replace part of it (his own v1.11)?
2. **Fix softskills.py** so it unquotes YAML names, with a test.
3. **Write `bin/tg1rs`**, the C4QL tag resolver from S9:
   - `[PERSONA (ITEM)FACT]` → a row in a core context store;
   - check both directions (entry → persona journal, journal → entry);
   - answer one of LINKED, FORWARD-ONLY, BACK-ONLY, GAP or WORD;
   - n1 time from the persona side.
   Use POSIX sh plus awk; the spec test is in a second language. Run it on today's data and
   report the counts.

### Lane D: dist, dist-fam, pub and the inputloop stages
**Files:** `c4/bin/fm1ct` and its tests, `c4/bin/pb1ck` (the claude.ai-link and embargo checks),
`G:\dist\README.md` (`$HOME/mnt/dist/README.md`), `G:\dist-fam` (`$HOME/mnt/dist-fam`),
`H:\pub/RECIPE.org` (fix the 4 lc1ck faults; it is his file, so edit, record and say so),
`advice/EXTENSION-2026-10-10/turn2/INPUTLOOP-STAGES.md` (new), the egress and family-shelf soft
skills' footer rows via `bin/ft1mt mint` (fold the other session's work in: it is his, it is
uncommitted, and we fold it).

1. **fm1ct** (each with a test):
   - build the promised `--prove-red`;
   - validate the hold class;
   - add a LOCAL-class test;
   - make `check` judge a zip by the holds recorded in it at cut time;
   - write CC-BY-SA-4.0, not CC BY 4.0, in the MANIFEST;
   - add a garden cut (AS4CE0001) beside the C4 cut.
2. **Real parcels.** Read the parcels in G:\dist-fam. Then make one fresh garden cut for Bryant
   into `G:\dist-fam/<peer>/` with `--work` if needed, and run `fm1ct check` on it. Hand back its
   sha256. Sending is Corwin's.
3. **pb1ck:** add checks for claude.ai links and embargo words.
4. **`G:\dist` README:** fix the stale folder list.
5. **Fold in the other session's work.** Mint the footer rows for egress 1.1.0 and family-shelf so
   `test_ft1mt` is green.
6. **`INPUTLOOP-STAGES.md`:** how AS4CE0001 maps to two private repos in the inputloop org.
   - A private stage (`.house/` private) and a public stage (public-stage form; both private to
     start), per `SOFT-SKILLS/public-stage/SKILL.md` and memory area inputloop.
   - What moves where, what each README says, and the checks before each push.
   - Nothing is pushed.

## Hand-back
Write `advice/EXTENSION-2026-10-10/turn2/HANDBACK-<lane>.md`. Your R-rows (from R29 up, in your
lane's block of four: G 29–32, T 33–36, B 37–40, D 41–44) go in `R-ROWS-<lane>.txt`, and your
ChangeLog entries in `CHANGELOG-<lane>.txt`, all in that folder. Sign it once at the end.

Mentat (for Corwin; claude-opus-5-5)
