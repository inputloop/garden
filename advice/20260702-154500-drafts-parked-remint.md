---
kind: advice
scope: dist 0.5.4, curation integrity
recorded: 2026-07-02T15:45:00
---

# 0.5.4 first mint over-shipped: 6 synth skeletons parked

First 0.5.4 mint packaged 17 skills; curation of record is 11. The six
extras were raw synth skeletons from Corwin's play session — including
`concise`, previously QC-REJECTED — living in `skills/` because synth
writes skeletons directly into the curation directory. Parked to
`.synth-drafts/` (see its README); push held before artifacts shipped.

Two systemic gaps, both PMO-worthy (ledger not mounted this session):

1. **REJECT isn't durable.** review --reject records advice, but synth
   happily re-materializes the same candidate next scan. The gate should
   consult past REJECT advice and hold (not skeleton) repeat offenders.
2. **synth writes into the shipping directory.** Skeletons should land
   in `.synth-drafts/` (or dist should refuse/warn on
   `source: polygram-synth` frontmatter without a promotion marker).
   Either makes "play with polygram" safe against "publish polygram".

Host: delete dist/polygram-curation-0.5.4.{tar.gz,zip,MANIFEST} from the
17-skill mint, remint (`bin/polygram dist`), expect 11 skills, then push.
