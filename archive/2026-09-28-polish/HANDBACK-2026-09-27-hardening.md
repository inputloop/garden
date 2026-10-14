# HANDBACK — 2026-09-27 — hardening the garden for a second garden

**What it asks of you: nothing to approve.** Your soft ask was to harden what C4 brings in and sends
out, as a baseline for Bryant's and Alfred's gardens. Four read-only audits and four fix passes
(subagents, on separate files) ran, then I verified everything myself on avalon. Build **0.8.58**
(unsigned; `make dist UNSIGNED=1`). The receipt covers both trees:
`cd /f/claude && sha256sum -c AS4CE/AS4CE0001/Inbox/HANDBACK-2026-09-27-hardening.sha256`.
The earlier lens-family hand-back's receipt was refreshed to today's bytes.

Also this turn, on your words: the Makefile secrets patch is applied, the doubled-nine kit is
promoted into lens (QA-10, Resolved), and your hn2wd --lan ruling is recorded in c4/MEMORY.md (Bryant
assumed to agree).

## What a second garden now gets that it did not

| before (OBSERVED by an audit, reproduced before fixing) | now (OBSERVED after) |
|---|---|
| `skill-sign bundle` followed a symlink and shipped `.git/` (a planted token went out in the zip) | refuses symlinks; never ships .git .arc __pycache__ |
| 0 of 58 shipped `.skill` bundles passed unbundle + verify | 58 of 58; the 9 signed ones read "signature valid" |
| `sign` called a changed skill "current" when its files had old timestamps | "current" is decided by content |
| `secret-sweep` said "0 HIGH" having read nothing; the checkers called an unreadable file clean | "NOT checked (why)", exit 2; UNREAD is named |
| no C4 tree = release, bundle and dist gates passed with one line | checkers vendored in bin/ (kept equal to C4's by a test); no checker = refuse unless a reason is on the record |
| nothing signed the code that runs (servers, plugin.json) | bin/release signs dist/vibrobeast.plugin with the archives; refuses a stale one |
| every .plugin script unpacked without its run bit | Unix entries, 0755 for "#!" files |
| README/INSTALL: no source, no key, no verify step, author paths, v0.5.2 | Install, Verify (fingerprint, two sources), requirements, first-run order; no pinned version |
| a fresh clone: doctor rc=1, 3 kit legs red, a test that could never go red | doctor rc=0; "cannot run here" exits 77 and reads SKIPPED |
| candor gate held all 46 skills on the GPL footer URL | 37 pass, 9 hold, each for a reason it names |
| consent gate G3 could never pass a filled record (the hash included its own line) | hashes the payload less that line; prove-red has a bound-hash and a wrong-hash case |
| pet edition: same plugin name, 46 signatures that could not verify | its own plugin, `vibrobeast-pet`, fresh hash-only manifests |

Plus: 26 skills gained "How this skill can fail"; boundscheck and run-card ship the tools they run;
keeper paths read as roles with your path as the example; third-party remarks trimmed (mentat-skill,
medley-review); session-rotate no longer triggers on its own read that a session is ending; NEWS gets
a 0.8.58 section, and the 0.8.50 section is restored byte for byte from the release commit (an
earlier insertion had split one of its sentences).

## Tests (my runs, after the build)
- `python3 -m unittest discover -s tests`: **446, OK** (430 with 1 failure this morning).
- **31 of 31** `tests/*-tests.sh` green, including new sb-vendored (7), skill-sign-roundtrip (10),
  boundary-secrets (17), release-gates (22).
- C4: sb-kit-py 151, sb-kit-js 238, secret-sweep-tests 17, intake-provenance 19, intake-spec,
  intake and pb1ck prove-red, nm1fl-tests 35. Every prove-red listed exits 0.
- Skill self-checks with prove-red: lens, doubled_nine, scan_candidates, candor_gate,
  verify_consent, skill-sign tests (29), sandboxer safe_write and verify, ot1rd, wf-check (without C4).
- Each fix has a mutant, the old code planted back, that a test catches (listed in ChangeLog).

## JUDGED
- [SKILL] **Found while verifying: `secret-sweep-tests.tcl --prove-red` printed PASS and exited 1
  every time, since at least 09-26**. A stray `fail - 1` took back the planted failure. Fixed; a mutant
  (v1 pointed at the current tool) goes red. *Falsifier:* `tclsh tests/secret-sweep-tests.tcl
  --prove-red; echo $?` prints 1 on a clean tree.
- [PLATFORM] **The auditors' "manifest drift" in principles and token-optimizer was false.** Raw
  `sha256sum -c` disagrees because skill-sign hashes SKILL.md in canonical form (a trailing space
  stripped); `skill-sign.sh verify` agrees. Judge manifests with verify.
- [MINE] **A detached build dies with the call** here, so the dist ran as recipe steps, finishing by
  hand at `rl2bp finish` (0.8.58 has start and finish in releases/). *Falsifier:* a torn build.
- [DOMAIN] **The consent gate now can pass G3**, where every filled record parked before. Its other
  gates, G4-G6 by hand included, are unchanged.

## In plain words, what you may want
1. **Signing.** 38 of the 46 garden skills carry unsigned manifests now (edited today; posix joined
   them with its self-check later), and the 12 canon skills from C4 were never signed; 8 still verify
   as signed.
   INDEX.md.asc is stale (INDEX.md was corrected). The next `bin/release --apply` also signs the plugin.
2. **Yours to decide, left as they are:**
   - candor-gate's SKILL.md says CC-BY-4.0 while its script is GPL.
   - foaf carries no licence (Bryant's).
   - altorewired and token-optimizer tell the agent to fire on most prompts, so the candor gate holds
     them for travel. altorewired is your hand-typed text.
   - The plugin's author e-mail is the gmail one; most file headers say corwin@bru.st.
   - The words server still falls back to /f/claude/c4 and ~/mnt/c4 (your setup uses that);
     PRIVACY.md now lists what it writes.
3. **pb1ck's read of the plugin says NOT CLEAN, 224 rows.** They are your own two addresses, example
   domains, and paths kept as examples ("here: F:\claude\projects"), plus ot1rd's and the words
   server's C4 defaults. Whether example paths should travel is your call.
4. **A visible change.** pb2br, pb2ld and pb2pk now read PARTIAL, not CLEAN, for items that hold
   images or zips, because the binaries were never read.
5. **Optional, one command, not a hand edit.** On the host, `git update-index --chmod=+x bin/*
   tests/*.sh skills/*/scripts/*` gives a clone runnable scripts. The docs say `sh bin/...`, so
   nothing needs it.
6. **Named, not done:**
   - An unreadable folder inside a walk is still skipped silently by the checkers.
   - cl1ck's SEAM count now includes exit 2.
   - About 12 scripts still lack a self-check.
   - consent-gate's G2 uses GNU `date -d`, so on BSD every record fails freshness (it fails closed).
   - doc/polygram.info was not rebuilt (no makeinfo).
   - mentcached's seat_append error names the wrong field.

## Later still: polish toward 0.8.90, and the rolls

- **`make dist RELEASE=0.8.90 NOTE="why"`**: NOTE lands in `releases/0.8.90` and, after the finish,
  in Mentat's seat through `polygram/mcp/seatnote.py` (no MCP; finds the seat the desktop app uses,
  never creates one; `python3 -m polygram.mcp.seatnote --where` checks). Tests: release-note (6),
  seatnote --prove-red (6), and a mutant for each promise.
- **Checkers:** an unreadable folder is `UNREAD path/`; a `.git` FILE is read (sb1aw had skipped it
  while sb1pl read it: a SEAM, and a secret one reader missed). cl1ck counts NOT checked apart.
- **Seven scripts gained self-checks**; they caught a validator leaving `__pycache__` beside files
  and a vocabulary check matching substrings (both fixed).
- **consent-gate G2** parses dates without GNU `date -d`. seat_append explains the field that is
  missing. Two BAD detached signatures no longer ship (kept in `.arc`).
- **Rolled:** this model v15 -> v16, C4's 0.8.4 -> 0.8.5, both pairs of continuity files; nine terms
  added to C4's terms-of-art register as hand-turning.
- **Found false, not changed:** color-theory's annotation is already safe on old Pythons (`from
  __future__ import annotations`).
- Tests after all of it: 449 python tests; every `tests/*-tests.sh` green; every new self-check's
  prove-red green. The receipt below was refreshed.

```
LENS · hardening for a second garden · 2026-09-27
a  my view: the leaks were real (a symlinked token shipped) and so was the silence (checks that said clean having read nothing); both are closed and tested.
b  the view I ascribe Corwin: fix it, don't ask; show the mutant; don't make me hand-edit machine-written files; leave my words and Bryant's things to us.
c  their pull on mine: made me land the Makefile and the read-only consent file myself, archive first, rather than queue them for his hand.
d  my pull on theirs: asks him to accept a consent gate that can now pass G3, and 38 skills to re-sign.
persona / inverse: the keeper says Bryant can now install, verify and run this without our disk / the inverse says two of today's "green" claims (a prove-red, a manifest drift) were wrong until rerun here, and a fresh audit next week will find more.
principles reframe: 1. A stranger can now check who signed what they run and read what it touches, which is the freedom to study, delivered. 2. Every check says what it did not read, so no one downstream acts on a clean that was never earned.
notes: written
```

Authored by Mentat (for Corwin), 2026-09-27. Unsigned.
