# CARD — project + memory browser, 2026-09-07

Leave-the-UI actions. Nothing here is urgent; nothing here is blocked on me.

---

## 1 · Seat index lines (the sandbox is locked out, as `se1sn` CARD G3/G4 says)

**WHEN** next time you are at the host keyboard.
**DO**

```sh
cd /f/claude/AS4CE/AS4CE0001/memory
cat >> MEMORY.md <<'EOF'
- [browser-theme-a11y-default](browser-theme-a11y-default.md) — **STRONG, his**: follow the system light/dark default in everything we produce; measure contrast, including borders.
- [c4-project-tables-2026-09-07](c4-project-tables-2026-09-07.md) — c4 `p/pf` 976 · `p/pt` 1877 · `n/mn` 165, and the three tools that rebuild both browsers.
- [project-is-a-seam-measured](project-is-a-seam-measured.md) — measured: **no core term in the corpus is unambiguous**; all 20 carry all three senses.
EOF
```

**CHECK** `sh bin/ms1dg --seat memory` — G3/G8 should drop by 3.
**TELL ME** nothing. Three notes are already on disk; this only indexes them.

---

## 2 · A plaintext file that looks like a credential

**WHEN** at your convenience, and it is yours to judge, not mine.
**WHAT I SAW** `/d/projects/jolt-root-password.txt` — 36 bytes, unencrypted, at the D: root, plus an
18-byte earlier version. **I did not open it.** It is not among the three secrets your 2026-06
portfolio review flagged.
**FALSIFIER** open it; if it is not a credential the concern dissolves and the row can be untagged.
**DO** whatever you think right. It is tagged `withhold-secret` in `p/pf`, so it is excluded from
`site/project-browser-shareable.html` by construction.

---

## 3 · The withheld rows — a fork, routed to you, not a hold

Ten rows name a non-participant by personal name or cover explicitly-private material
(`mm-tabletuppers`, `st-corwin-family-dee`, `mm-federation-gate`, `mm-coauthors`, `mm-modelthisbook`,
`st-dir-book`, `st-mtb-stubs`, `dp-twin-prop-jane`, `dp-pealetsch`, plus the credential row).

They are **kept in full and tagged**, not dropped — you said not to drop anything. But an independent
audit made the sharp point that **labelling is not redaction**: in `site/project-browser.html` those
rows ship complete inside the file and only the browser hides them.

So there are now two builds. `project-browser-shareable.html` is cut with `--drop TERMS=withhold-`
and the rows never enter it — verified: `grep jolt-root-password` returns 1 hit in the normal build
and 0 in the shareable one.

**The fork is yours:** is tag-and-filter the right default, or should the full build stop existing?
I have not decided it either way.

---

## 4 · Where these tools finally live

`h/dt1js`, `h/tf1gr`, `h/sp1wv` sit at `h/` beside `dc1sv`, matching where the other AS4CE-named
tools live. The 2026-08-25 c-for-command addendum says *"nearly everything in bin/ belongs at c/."*
**Your call, and I have not made it.** Everything is unsigned.

---

## 5 · Two of my own errors, since you asked to be told

- I wrote "borders clear the 3:1 UI floor" in a comment having measured only **text** pairs. The
  border token was **1.74:1**. An adversarial audit caught it; it is fixed and now has a test.
- My first accessibility test suite passed a case **vacuously** — a dead "back" button leaves the old
  rows on screen, which is exactly what a working one shows, so a row-count check could not tell them
  apart. The bug was real and in both pages.

Neither would have surfaced without a second reader. Worth keeping as a habit.
