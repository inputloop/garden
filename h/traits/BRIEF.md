# Trait-forest research brief (2026-09-06) — one agent per column; read fully before starting

Goal: 144 human personality/character traits that between them give a good sense of the range of human
behaviour, arranged as 6 columns × 4 tables × 6 traits. YOU own ONE column (24 traits, 4 tables of 6).
This is for a CC-BY-4.0 persona-development reference specification (a tabletop "roll for persona"
grid used to build AI personas that help maintain complex technology). Marked: for fiction or analysis —
no ship dates or licensing or publication dates specifically defined.

## Sourcing rule (HIS): at least THREE formal sources per trait + ONE or TWO "flair" sources.
- FORMAL = peer-reviewed article, validated instrument manual, handbook chapter, or meta-analysis
  (Costa & McCrae NEO-PI-R; Ashton & Lee HEXACO; Peterson & Seligman VIA; Cloninger TCI; Schwartz
  values; Wiggins/Horowitz interpersonal circumplex; Zuckerman sensation seeking; Duckworth grit;
  Kashdan curiosity; Paulhus & Williams dark triad; Holland RIASEC; Haidt moral foundations; etc.).
  A taxonomy-level source may be shared across the traits it defines, but AT LEAST ONE of the three
  must be trait-specific (a study, meta-analysis, or scale paper about that trait).
- FLAIR = a contrasting or non-formal source: Psychology Today, Scientific American Mind, The Atlantic,
  Greater Good Magazine, a health/lifestyle magazine, a well-known blog, a popular book — name it.
- TWO READERS: every formal source is confirmed by two independent routes — (1) the PubMed plugin
  (search_articles / get_article_metadata; PMID + DOI) and (2) a web search or DOI/publisher page.
  Mark each source VERIFIED-2 (both routes), VERIFIED-1 (one route), or UNVERIFIED (neither — keep
  it, say so). Never invent a DOI or PMID; if you cannot find one, leave the field blank and mark it.
  PubMed does not index much social psychology — VERIFIED-1 via publisher/DOI page is expected there.

## What to produce (write these files; the orchestrator assembles them)
1. `h/traits/col-<X>.tsv` — TAB-separated, header row exactly:
   col	table	row	trait	definition	low_pole	high_pole	L1	L2	L3	L4	L5	L6	neighbors	taxonomy	formal_1	formal_2	formal_3	flair_1	flair_2	verify	notes
   - col: your letter. table: 1–4. row: 1–6. trait: a short noun phrase (Title Case, ≤4 words).
   - definition: one sentence, plain, ≤25 words.
   - low_pole / high_pole: one or two words each (e.g. "reserved" / "gregarious").
   - L1..L6: SIX expression words/phrases from the lowest (L1) to the most extreme (L6) expression —
     these are the six cells of the trait's row in a 6×6 table (row = trait, column = level). L3/L4
     are the moderate middle; L1 and L6 are extremes. ≤5 words each.
   - neighbors: 2–3 other trait names (from any column) that sit next to this one by synergy or by the
     words used to describe them — this is how the wheel/ball of persona gets its neighbourness.
   - taxonomy: the instrument/model the trait comes from (or "composite").
   - formal_n: `Author (Year). Title. Journal/Publisher. DOI:… PMID:… [VERIFIED-2|VERIFIED-1|UNVERIFIED]`
   - flair_n: `Publication — Title — URL [VERIFIED-1|UNVERIFIED]`
   - verify: the two routes you actually ran for this row, briefly (e.g. "pubmed:2 web:3").
   - notes: anything the assembler must know (overlap with another column, a contested trait, etc.).
   No TABs inside fields; use " · " to separate items inside a field.
2. `h/traits/col-<X>-sources.md` — the citation list for this column: every source once, with the
   verification state and the route(s) used, grouped formal / flair. This becomes the spec's
   bibliography.
3. Return (as your final message) a ≤25-line summary: table names, trait list, counts of VERIFIED-2 /
   VERIFIED-1 / UNVERIFIED, any trait you could not source to three, and any overlap you noticed.

## Table design for your column (traits are a starting list — refine for neighbourness and coverage;
keep exactly 6 per table, 24 total; if you replace one, say why in notes)
(see the per-column assignment in your prompt)

## Discipline
- Do NOT write anywhere except `h/traits/`. Do not touch memory, CLAUDE.md, signed files, or c4.
- Be frugal: taxonomy-level sources verified once are reused; trait-specific sources are the extra cost.
  ~90–120 tool calls is the expected budget for a column.
- Two piles: what you OBSERVED (a source exists, with its id) vs what you JUDGE (a level word, a
  neighbour). Never let a judgement wear an observation's clothes.
- No case facts, no third parties, no clinical diagnoses as traits (traits, not disorders).
