# HANDBACK · 2026-10-05 · hello-taxgnomes: all 192 east readings in

produced-by: the restart task (`/f/claude/projects/hello-taxgnomes/.house/h/RESTART-2026-10-04-east-drafts.md`)
subject: hello-taxgnomes at ab7e186 · 2026-10-05 UTC

## The word

All 192 east readings are drafted by gemma4:12b on Avalon and on the page: 192 drafted, 69 pooled, 0 templated.
The build loop closed on a clean pass (cycle 2, pass 3 of 3). Committed locally as ab7e186, authored as you
with the Claude trailers. **Not pushed:** pushes are yours.

## In sync, and how sure

- **The page and its data.** `make build page`, `make check`, and both unfolders (awk on Avalon; Emacs 29.3 in
  the cloud sandbox on a staged copy, because Avalon's shell has no Emacs) all agree. The page's 9 inline tests
  pass headless, and T-SIGN reads "0 templated". Sure: each is a check that ran this session.
- **Every draft's story.** `.house/h/drafts-2026-10-04/jobs.tsv` has every bridge job, its id and how it ended;
  `answers/` has every answer, including one not taken in. Sure: sl1gk counts **lost = 0** on this session's
  transcript.
- **Why it was slow.** It was the context, not the card, so the 1060 isn't needed for this. Measured in
  `.house/h/PROBE-2026-10-04-ollama-speed.md`:
  - Thinking multiplies the tokens about 30 times: 2,725 for a 90-token answer.
  - gemma4:12b's default 262,144-token context runs 6.5 times slower than 8k on a clean card: 8.1 against 52.6
    tokens a second.
  - Before your Ollama restart, leftovers made it 0.77.
  Sure: Ollama's own counters, one prompt per setting (a small sample).

## Out of sync, or owed

- **AS4CE0001 was not committed at first.** New here: this hand-back, `advice/20261004-ENHANCE-llama-bridge-think.md`
  and `advice/20261005-ENHANCE-houseboxer.md`. Committed later the same evening, at his word.
- **Models on your Ollama now:** `gemma4:12b` (as before), `gemma4:12b-8k` (my variant: a small model recipe
  file, same weights; `ollama rm gemma4:12b-8k` removes it) and `gemma4:e2b-it-qat` (3.4 GB, the baseline; he
  removed it the same evening).
- **My miss: "a line between polls".** sl1gk counts **quiet = 80 of 97** bridge waits (85 strict). During the
  steady run I posted every few batches instead of between polls, as the note asked.

## What changed in hello-taxgnomes

- `drafts/2026-10-04-gemma4-12b-E.json`: the other 180 sentences. **14 were retired, with reasons kept**:
  11 headwords in capitals, LITHIUM reciting its gloss, MUTED's stray quotation mark, COMMAND as a verb.
  All 14 were redrafted; nothing was dropped.
- The recipe:
  - `tg1dr.py retire MODEL DATE WORD REASON` keeps a bad draft on record and off the page.
  - Taking in an answer notes a word in capitals.
  - The builder passes over a retired draft, and `tg1ck` fails a build that shows one.
  - prove-red plants the case (six plants, all caught).
- Batches went to the bridge as `gemma4:12b-8k`, 6 words each. Thinking overran 8k once (b03b, seen in a
  stream: 8,016 tokens of word-counting); a redraft batch also came back empty (not streamed, so the cause
  there is a guess). Each was split, never skipped.

## Recommendations

1. **Keep gemma4:12b (and its -8k variant) for sense-holding prose.** e2b ran 13 times faster but kept 5 of 6
   on b01a and blurs senses. Remove e2b unless you want it for speed-first jobs.
2. **The bridge** (offer-back to Bryant, in the ENHANCE note): pass `think` and `options` (above all
   `num_ctx`) through. Until then, a `-8k` variant does the context part with the bridge unchanged.
3. **The 1060** is a go whenever you like; your 1250 W supply has room. It's what would put the 14B models on
   your list within reach.

## Questions

- Answered the same evening: the site is **llmconfigurator.com** (`/en/best-models/rtx-3080`), not the
  name I searched for. Its ranking assumes all 10 GB of the card are free; on Avalon the desktop holds about
  1.6 GB, so its largest fit (Qwen 3 14B, 9.7 GB) would spill here. That gap is the houseboxer's job.
- Answered: he said commit. These four files only went in; his other untracked files were left alone.

## Hopes

That the houseboxer note and the scout section become the next small build: the probe we ran by hand today,
turned into a gauge any keeper can run before the first slow night.
