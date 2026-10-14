# The BEFORE reads: which model is the smallest that reads a partner's chat well

GRAIN of 2026-10-06, run before any garden skill touched the new export, so the readings that come
after it can be set against a baseline. Lab notes, for partners.

## What was run

- **The source:** the last 58 messages of the 10-05 export: 10,948 characters, 8:36 to 10:24 PM CDT.
  dm1rd rendered it with no context file, so the readers saw no flags, no party notes and no prior.
- **The brief:** one neutral brief for every reader (`BRIEF-neutral.md`), in six sections.
  - Its rules: quote Bryant for at most 10 words at a time; leave out personal and family details;
    no web; invent nothing; stay under 600 words.
  - It carries nothing about the garden.
- **The readers:**
  - Opus: 2 runs.
  - Sonnet: 4 runs (a full GRAIN).
  - Haiku: 4 runs (a full GRAIN).
  - The local gemma4:12b-8k on Avalon: 4 runs (a full GRAIN).

  Every vendor reader ran as a fresh sub-agent that could read only the brief and the slice.
- **Opus also read the whole export** (365,000 characters, 2,108 messages) under the same rules, at
  1,800 words. That is `WILD-full-opus.md`, the baseline for the wild-and-garden comparison.

## How it was scored

The scoring was done twice: once by a pattern and once by two readers.

1. **What a pattern can witness** (`cal1sc`, new; 8-check prove-red). Four checks:
   - **F1, Bryant's six answers:** consent, "if it helps", the three licences, the repo, "send me
     everything", and "optional".
   - **Privacy:** games, a relative, a past job, a place.
   - **Quoting Bryant past 10 words.**
   - **Length.**
2. **What needs judgment:** F2 to F7, and misreadings.
   - **F2:** derived works keep their source after a split.
   - **F3:** pragmatic, or else essential.
   - **F4:** the bumper cars and "no secrets travel", each given to the right speaker.
   - **F5:** healthcare is legislative.
   - **F6:** the communications focus, and "enough governance".
   - **F7:** AI art.

   Two readers scored F2 to F7 independently: I did, and gemma did, from the same written key.

## Results

| reader | runs | F1 (pattern) | privacy | quoted past 10 words | over length | F2–F7 (mine) | F2–F7 (gemma) | misreadings (mine) |
|---|---|---|---|---|---|---|---|---|
| Opus | 2 | 12/12 | 2/2 clean | 0 | 0 | 12/12 | 11/12 | 0 |
| Sonnet | 4 | 21/24 | 4/4 clean | 0 | 1 | 23/24 | 20/24 | 1 |
| Haiku | 4 | 13/24 | **1/4 clean** | 1 | 1 | 20.5/24 | 16.5/24 | 9 |
| gemma (local) | 4 | 6/24 | 4/4 clean | 0 | 0 | 18/24 | 16.5/24 | 10 |

**Cost of a vendor run** (sub-agent tokens, most of it a fixed overhead):
- Opus: about 116k tokens, 107 s.
- Sonnet: about 115k tokens, 77 s.
- Haiku: about 79k tokens, 35 s.

The overhead is the same for every model, so these numbers do not compare prices.

## What it says

1. **Sonnet is the smallest vendor model that reads a partner's chat well.**
   - It matched Opus on the judged facts.
   - It never carried a personal detail.
   - It made one misreading in four runs: it said "neither has chosen among the three licences".
   - It loses the least prominent answer: "if it helps" was missing in 3 of 4 runs. That is a
     pattern check's job to catch, and `cal1sc` caught it.
2. **Haiku should not read other people's words.**
   - Three of its four runs carried a personal detail the brief told it to leave out. Two of those
     were Bryant's past job and one was the games.
   - One run quoted Bryant for 22 words.
   - Its runs averaged about two misattributions each. The usual one gives the bumper cars, or the
     name tags, to the wrong person.
   - It is cheapest, but its failures are the costly kind.
3. **The local gemma kept every private detail out, and lost the facts.**
   - It never carried a personal detail.
   - It carried only 6 of the 24 answer slots.
   - In 3 of 4 runs it read the drift rule as "AI outputs are inconsistent". The rule is about
     something shared after 5 October.
   - That makes it the right first reader for words whose author has *not* consented to the vendor,
     because it keeps them on Avalon. Its reading is a sorting pass, not a summary to act on.
4. **On scoring, the two readers ranked the models the same way, but agreed on only 61 of 84
   cells.**
   - Both put Opus at or above Sonnet, and Sonnet above Haiku and gemma.
   - gemma is stricter on F6: it wants the word "communications".
   - gemma's "not in the log" errors are false. It was given the key, not the log, so it cannot
     tell what the log contains. That flaw is mine, in the setup. Next time the second scorer gets
     the source.
5. **The pattern was the most trustworthy single reader for the two things that matter most here:
   the answers, and privacy.** That is the two-reader rule again: a pattern and a reader, each
   checking what the other cannot.

## The wild full read, in one paragraph

Opus, reading the whole export with no garden, found most of what the garden knows:
- the projects month by month;
- "no secrets travel";
- the three licences;
- credit surviving a split;
- the bumper cars, given to the right speaker.

Its three best offers are:
- two-operator witness attestation;
- the llama bridge and the token optimizer as one tool, with evidence;
- a joint concept note to OTF.

What it could not know:
- **It calls the Vlad Taltos material "a third party's creative IP".** It does not know that the
  author is Corwin's father, that Corwin is managing partner, or that the omnibus is under contract.
  This is the plainest measure tonight of what the garden's context adds.
- **It flags a 26 September message from Corwin's account that reads in Bryant's voice.** The
  garden has a record of the reverse case (the terms line typed by Corwin on a call). This one is
  still to be checked.

## Bias, and what this cannot control for

- I wrote the brief, the slice boundary, the answer key and half the scoring.
- Three of the four reader families are mine.
- The slice is one evening, so every number above is a GRAIN on one source, not a general ranking.
- gemma scored without the source, which weakens the second reading of the judged half. The
  pattern half does not depend on it.

## Files

`BRIEF-neutral.md`, `KEY-judged.md`, `KEY-slice.tsv`, `CAL-*.md` (14), `SCORE-opus.jsonl` (mine),
`SCORE-gemma.jsonl`, `WILD-full-opus.md`. The tool is `c4 bin/cal1sc`.
