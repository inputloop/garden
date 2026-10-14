# What an avoided ask saves — a lab measure (AS4CE0001, not C4)

Started 2026-09-23 from Corwin's correction: don't hand back asks that restate what he has already
written; do everything possible first. His guess: each avoided ask saves about one paragraph of his
typing, roughly 110 words. This folder tracks how good that guess is through the end of 2026. It stays
out of C4 unless it turns into something C4 can use.

## What can and can't be measured

An avoided ask is a counterfactual: nobody types the answer, so there is nothing to count. What *can*
be counted is the ask that was **made**: how many words he wrote to answer it. That is the proxy for
what an avoided ask would have cost. Two columns in `ledger.tsv` keep the two kinds apart.

- `AVOIDED` rows: an ask I was about to make, and the file of his that already answered it (cite it).
- `ANSWERED` rows: an ask that went out, and the word count of his reply to that ask alone
  (`wc -w` on the part of his message that answers it).

The estimate is the mean (and spread) of `ANSWERED` word counts; the saving is that times the number
of `AVOIDED` rows.

## Tools

`sh ask-scan FILE` lists the lines in a draft hand-back that read as asks (a question mark, or
"your call", "can you", "need your", "please confirm", "which do you") and counts them. Run it on the
draft before it goes out, and for each hit look for his words on disk first.

## Where the confidence stands (2026-09-23)

- **That ~110 words is the right mean:** low — about a 1-in-4 chance it's within ±30% of what the
  ledger will show. His long messages suggest it could be high; many answers in the record are a line
  or a word ("yes", "go ahead"), which pulls it down. The spread is probably wide (heavy tail).
- **98% confidence is not a sensible target** for a quantity that is only reachable through a proxy.
  A reachable one: **a 90% interval on the mean words per answered ask, no wider than ±20%.** If the
  spread is about as large as the mean, that needs roughly 70 answered asks. At 3–5 a working day that
  is about three to five weeks: **late October to mid-November 2026.**
- **That the estimate improves over the year:** about 70% — more rows can only tighten it, as long as
  rows keep being written. Whether the *number* of asks per hand-back falls is closer to even: it
  depends on `ask-scan` being run every time, which this folder can't guarantee.

Falsifier for the whole exercise: by 2026-11-15 the ledger has fewer than 30 `ANSWERED` rows. Then
the method is too costly to keep and should be dropped or automated.
