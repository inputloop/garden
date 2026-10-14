# 2026-07-09 promotions — landing runbook

Two items promoted at the skilltank desk (Corwin, 2026-07-09): the shelf-check
doctrine skill (NEW, grown from the 07-05 draft) and the sandboxer bad-weather
first-read rule (ENHANCE, from the 2026-07-02 memory note). Both staged here per
ready/ convention — nothing auto-installs; the manual grab is the last human gate.

Every signing step below is yours; the agent drafted, you read and sign.
"Have I read this thing I'm going to sign?" applies to each artifact here.

## 1. shelf-check (NEW skill + sign.sh fold + .gate vouch map)

What's here:
- `shelf-check/sign.sh.ready` — live pub/sign.sh (incl. your 07-07 shebang/detach
  guard + cat-over-mv) with the proven `check-shelf` subcommand folded in.
  Rebased 2026-07-09 because the 07-05 draft's base had drifted. `sh -n` clean;
  run against live pub/ it reports exactly the two known gaps and nothing else.
- `shelf-check/gate.ready` — pub/.gate + a SIGN/NOSIG/FURNITURE line for every
  shelf inhabitant (vouch-everything rule: enumerate, don't default).
  hello-world.md is the one NOSIG (the listed Peekable); .gate itself is SIGN —
  it fails its own gate until you clearsign it, which is the fail-closed point.
- `shelf-check/skill/shelf-check/` — the doctrine skill, v0.2 (promoted).

Landing order (each step checkable):
1. Read + diff: `diff pub/sign.sh shelf-check/sign.sh.ready` — the delta is the
   usage block, the check-shelf function block, and one dispatch row. Nothing
   else moved.
2. Copy `sign.sh.ready` → `pub/sign.sh`; re-detach: `sign.sh detach pub/sign.sh`
   (its old .asc is now stale — expected; the re-detach-after-edit workflow).
3. Copy `gate.ready` → `pub/.gate`; clearsign it: `sign.sh sign pub/.gate`.
4. Prove: `pub/sign.sh check-shelf pub/` → `SHELF: PASS n=12`, exit 0.
5. Skill-sign `skill/shelf-check/` and install to the live skill set; add its
   row to build/BryantWorkshopSkills/BUNDLE-MANIFEST.md if it rides that bundle
   ("additions get a new row before they ship anywhere").

v0.3 leads (parked, not lost): wire check-shelf into `incubator/experiments/
publish/bin/publish audit` and the build/→pub/ airlock exit; `--strict` hard-fail
on unsigned .gate once yours is clearsigned; reconcile-log freshness anchor
(vouch-everything eclipse r2).

## 2. sandboxer ENHANCE (bad-weather first-read)

What's here:
- `sandboxer-patch/sandboxer.bad-weather.patch` — append-only unified diff
  adding "## Known bad weather — treat the first read as suspect" after the
  reader-trust rules. Cut from the INSTALLED CACHE copy (303 lines), which is
  newer than the bundle copy — see notice below.
- `sandboxer-patch/patched/sandboxer/` — full patched skill (SKILL.md + the
  three scripts, unmodified), drop-box style per patches/README.md.

Landing: review the patch (it only appends), skill-sign the patched dir, install
via Settings > Capabilities (the in-session cache is read-only). Description left
untouched at 1018/1024 chars — adding a "known bad weather" trigger would bust
the cap; the margin lesson from omni-tool applies. If Bryant wants the section
upstream it's cleanly shareable: it contains only shop-neutral mechanics plus
one dated observation.

## NOTICE (minion, in passing) — stale bundle copy

`build/BryantWorkshopSkills/sandboxer/` (230 lines, bundle of 07-05) is OLDER
than the installed cache (303 lines — the read-side + reader-trust content is
missing from the bundle). BUNDLE-MANIFEST's advice "re-install from these if in
doubt" is currently a downgrade for sandboxer. Worth refreshing the bundle row
(and sha) when you land this patch, or marking the row superseded.

## After landing

Tell Mentat and the notes update: implement-local-to-extern (this is adjacent
progress on the gating plan, not step 1 itself — the touch/don't-touch manifests
are still open), sandboxer-bad-weather-first-read (promoted → landed), and the
skilltank verdicts of 2026-07-09.
