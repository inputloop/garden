# 2/03 — banter model + a data-quality catch (Task 2)

## The model
`MODEL-banter.md` (skzb/pm) encodes Corwin's doubling ladder as weights —
`:character-solo:`=1, `:amused:`=2, `:character-duet:`=4 — × a 1–3 *punch*,
crossed with dim-2 *categories* (promo-screenshot / doc-illustration / …). It
follows the house `MODEL-<project>.md` shape (tags=dim1, categories=dim2,
compound keys) and phases hits toward a TSV the future pmo `banter` ledger seeds.

## The catch (reusable)
One mining sub-agent returned hits with **swapped session-id ↔ title** (it
attached the credit/FSF exchange to `aa58d047` "We the Funded" when the content
was clearly "Testing session with Erik" = `1875813e`). I corrected by **content
+ title**, since titles matched real sessions while the short-ids didn't.

Lesson: when a child returns a composite key, **cross-check the parts against an
authoritative list** before trusting either. Cheap fix here; in a higher-stakes
pipeline this is where a verification gate earns its keep.

## Output
31 scored hits in `MODEL-banter-hits.tsv`; 6 top-scorers (12/12) are all
`:character-duet:`. The "brochure that swallowed a thesaurus" turn is the
cold-quotable standout.
