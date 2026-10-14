# last response -- 2026-09-28 (rolled: AS4CE0001 v17, C4 0.8.7)

## The build he made and wears: no issues
0.8.90 (note "C4 PRE-RELEASE"): 58 of 58 garden skills and 58 of 58 `.skill` bundles verify against the
pinned key; pb1ck reads the plugin CLEAN of what was checked (117 examples shown); 51 of 58 pass
candor-gate `--travel`, 7 hold on person-data or egress (the receiver's call); the README names the two
broad skills; author corwin@bru.st. The note reached Mentat's seat (seam polygram-releases), stamped with
the shipboard date, still 2026-09-24: whether a release moves it forward is his call. This chat still
runs the plugin it started with; new sessions get 0.8.90. My stray `advice/` record from a check-mint
the turn before was removed (his word: "you have rm already").

## The writing: the default skill set (designed, not built)
c4 `h/DESIGN-2026-09-28-default-skill-set.md`, plan `h/QAPLAN-2026-09-28-default-skill-set.md`, loop
`h/SWING-2026-09-28-default-skill-set` (sw1ng: one redesign, three passes by fresh readers, final swing
kept). FULL stays the default here. A new place is offered `vibrobeast-grain`; GREAT for a declared team,
GRAND for a build from a published literate org such as GHOSTWHEEL.org. Sizes are 4 / 9 / 17 percent of
a population of 167 (58 plugin skills, 8 soft, 73 decks not yet minted, 28 tools), with a floor of seven
on top: GRAIN 14, GREAT 22, GRAND 35. Floor: mentat-skill, principles, skilltank, sandboxer, lens,
garden-usage (the pick for ??, the finder), consent-gate (in drift's slot until drift is minted). Picks
from the 43 non-floor, non-broad, non-door-held plugin skills, by distinct days used in 90 (health first,
shorter description breaks ties). Everything else goes to the edition's `SOFT-SKILLS/`, found through a
new last root in every branch of mentcached's `roots()`.

## Routed to him
1. "disc counting": the floor on top (GRAIN 14) or inside (GRAIN 7, no picks).
2. The floor's shake-up (garden-usage; consent-gate for drift's slot).
3. GREAT as its own edition, or GRAIN plus a setup step.
4. Whether the manifest's "skills" key can name a subset.
5. The shelf's first download for a new place.
Found on the way: soft skills prior-instruction (description 1190 > 1024) and build-loop (frontmatter
fails strict YAML) could not be installed as they stand.

## Rolled
AS4CE0001 model v16 -> v17 (snapshot `.models/model-2026-09-28.md`); C4 model 0.8.6 -> 0.8.7 (another
session had rolled 0.8.6 the same day; its section sits below mine, untouched; the
priors kept by `c4 archive keep`); both continuity pairs archived; seven terms into C4's terms-of-art
as hand-turning. The build of the size machinery waits for his answers to 1 and 2.

## Then: blessed, built, and the ERRATA
His answers: the floor list blessed (consent-gate in drift's seat), the floor on top, and a fourth
option, RANDOM. Built, packaging only: `polygram/editions.py`, `polygram edition`, `make edition
SIZE=grain|great|grand RANDOM=yes|<size>|all SEED=...` (and `make dist SIZE=...` calls it after the
finish). An edition installs the floor plus its picks (by distinct days used in 90, health first,
shorter description on a tie; RANDOM adds a seeded draw), puts every other garden skill in its own
SOFT-SKILLS/ with the reason in its README, and its launcher points mentcached there. Broad,
door-held and RED skills are never picked, not even by RANDOM=all. The full plugin's bytes did not
move: minted with the code before and after, `diff -r` identical. `ERRATA` (E1-E11) holds what the
checked 0.8.90 build still owes, for the C4 ON rebuild. Tests: test_editions 13, editions-tests 20
(four planted mutants all red), 472 python tests OK, 33 of 33 shell suites green.
