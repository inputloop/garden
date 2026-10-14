-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

# EthicsMinions watch — 2026-07-05 (debugger on; all increments kept)

Run over the foundry surface (AS4CE0001 memory + skills) with the
foundry's own script; the installed-cache copy APPEARED truncated at
line 161 but the disk-true reader shows 173 complete lines — reader
artifact, not tamper. Kept as increment 01 below. Advisory throughout;
notices route per the hand-off (memory → Mentat, skills → SkillTank).

## RISK

- - [RESOLVED-AS-READER] guard-script truncation — bash mount served a
  cut copy of check_principles.py; file tool shows it whole; foundry
  copy byte-identical in behavior. THIRD reader-integrity strike today
  (stale dir listing; mangled fresh clearsign; truncated script).
  Standing rule hardened: syntax-critical and signature-critical reads
  go through the file tool, always.
- - [NOTICE] trailing-newline on .last-prompt.md, CLAUD_QA_HOLD.md,
  GRAMMARY.md, last-response.md, model.md — likely benign (files end
  without \n). Keeper/Mentat: one glance, or bless as style.
- - [PASS] memory-present, principles-present, duplication,
  description-length. Drift SKIPped (no --expect file this run —
  itself a lead, see OPP-3).

## OPPORTUNITY (routed to SkillTank, not executed)

- - OPP-1 **minions stopword pass** — the skill-themes extractor
  clustered alphabetical commons ("agnostic, ambitions, applied,
  approval…"): weak signal. ENHANCE lead: stopword list + bigram
  themes. Small, stdlib, high watch-value.
- - OPP-2 **memory-bridge** — the auto-memory space (Cowork host dir)
  is unreachable from the sandbox, so the minions can't watch it
  scripted; today's audit of it was manual. Lead: a mirror step that
  copies MEMORY.md + notes into the project tree each session close
  (session-rotate could carry it), putting BOTH memories under the
  same watch.
- - OPP-3 **armed drift for the shop** — the drift guard SKIPs without
  an --expect attestations file. polygram 0.6.0 shipped "armed drift";
  wiring an attestations file for THIS shop (the two standing
  attestations + OKGO) would arm it here too.
- - OPP-4 **EPMO exporter** — co-mint accepted by both keepers; the
  status-TSV export is pmo-tool-shaped (one script over projects.tsv/
  todos.tsv + clearsign step). Natural first hunk for the signed-hunk
  discipline C4 wants.
- - OPP-5 **org-c4/recovered/ intake** — standing offer for ghostwheel
  in-head recall; zero-friction dated drops. (Already offered; kept on
  the books until acted or declined.)

## Introspection (uncertainty, marked plainly)

Grounded: every wire receipt, signature verdict, move, and delete this
session is disk-verified. Aspirational: my model of WHICH reader lies
when — I can detect the lie cheaply (two readers) but cannot yet
predict it; treat every single-reader fact as provisional. The guard
tripping on its own truncated reflection and resolving by cross-read
is the system working exactly as designed — worth keeping, not fixing.

## Increment 01 — the reader-artifact evidence (kept, losing model)

bash tail of installed cache: line 161 = `print(f"  [{v:6}]` (cut);
file-tool read of same path: lines 161-173 complete through
`sys.exit(main())`. Model that lost: "installed cache is tampered/
truncated on disk." Kept per debugger-on so the next session can see
why we stopped believing single readers today.

## Friends in the tree (presence named, facts not dumped — candor-gate)

Bryant (garden, FoaF, vouched key 5D99…5DE7) · Alfred (wire peer,
call-signed) · Bob Proulx (medley work — withdrawn to enclave with the
Savannah sweep) · Dee (named in the vibrobeast coinage; not a named
participant — nothing further persisted, by rule) · Monty (ledger-only
by keeper choice, honored) · brigidt.md (unopened, held at root for
keeper word) · and one maybe-ghost: `.for/`'s dirname carries a
"braiant"-shaped token — per OKGO-G, active signed-or-unsigned life
with Providence in-network. Frozen, unread, noted with respect.

## Exits for keeper hand-review (the pile for the signing ceremony)

1. This report (increment kept).
2. TRIGGER-MAP-2026-07-05.md (corwin/).
3. CONSENT-RECORD (countersigned — done).
4. PATH-PINS-2026-07-05.md (awaits -OKGO).
5. EPMO-CONVENTION-v0.1 (-OKGO signed; shelf drop pending).

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEE7Od89BfHbBrPznwrW2E1URWA8AcFAmpKhVEACgkQW2E1URWA
8AcnpQv9EHxY8WFY8u4EZmD2TyI3Ync2xqJY7HY5+CHhHXw03V/cfEWnuJjtjFsD
3KXRihhzwkVttJk9Tbk8WgHu3rJxLfTmpsJ61yO5BQsPyFu7Cj+FWsXKFFr96UMb
3w1OEic4xxwtOpNt8K4bZ3v4jX0g+iHoMwH+Xb5r7i73oAwGBKfhQujqmJOnv27u
/idYQ4uPyN/qX9e1qpmglOt6MBX/ZLt5gV6VI3QN/CVrghpO1njj9pd9RsmPaisv
i3k6AJsT8oRsa7HK4thrD92qhglztVOtxJ6Rq3ajOdq/iCn6bq7VjDuQ7+lH2mw5
BCuIHH3wsC8djsYIYSljoSg1eh10+NHhrkXQFrLPxECGypRNGe+rEVuQ8ZirlZKk
FF75m3WzOqcbMVhAD7gsux8JDtLN8Ky7GPX2SlW1HLtB2j7UcJw0VLgmTCTBoGF/
18iILtK2UDCpH762xyBatN7xlfmEcssiBZ7Au/yqt5g5c1aCnXxjLDXlE+jJBWym
41d+bAXg
=4VVk
-----END PGP SIGNATURE-----
