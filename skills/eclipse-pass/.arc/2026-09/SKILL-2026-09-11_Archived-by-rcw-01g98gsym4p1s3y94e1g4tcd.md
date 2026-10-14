---
name: eclipse-pass
description: The "debugger on" critique ritual — stress-test a proposition, design, artifact, or skill until the weak claims break, keeping the losing models instead of discarding them. Use whenever the user says "eclipse this", "eclipse/critique pass", "debug it" (in the critique sense), "debugger on/off", "run it through the ringer", "stress-test this", "poke holes", "red-team this idea", or wants a rigorous PASS/FAIL on whether an idea actually holds. (Legacy "torture this" still means this pass; the old name is renounced.) Checks the target against several seeded-random real projects (so nothing is cherry-picked), runs two opposed biases (doubt-first vs reward-first) and treats their convergence as the stability check, releases ethicsminions before the persona pass, and — debugger on — parks the losing/contrast models in .eclipse-increments/ for later folding. This is Corwin's own extreme-debug discipline (born in the C4/FoaF passes), not a unit-test runner, a code debugger, or a linter.
---

# Eclipse Pass — the "debugger on" critique

An eclipse pass exists to find where an idea is *wrong* before you build on it.
The trap in self-evaluation is that a single reviewer, especially a helpful one,
talks itself into the answer it already likes. This ritual defeats that three
ways at once: it checks the target against **projects it didn't get to pick**, it
runs **two opposed biases** and only trusts what they agree on, and — with the
**debugger on** — it *keeps the losing models* so a contrast that looks wrong
today can be re-examined tomorrow. Born in the C4/FoaF passes; it's how "C4 is
*imposed*" was caught (it broke on the Dragaera project) and how the signed
footprint was found to be the load-bearing pillar.

Naming note: this ritual was first called a "torture pass." Corwin formally
renounced that framing (2026-06-29); kind language only. The mechanics are
unchanged. Pre-existing `.torture-increments/` dirs are his to keep or rename —
read them if present; write new increments to `.eclipse-increments/`.

This skill **runs the pass**; it does not save memory ([[mentat-skill]]), decide
whether something is skill-shaped ([[skilltank]]), or replace the ethics scan —
it **invokes** [[ethicsminions]] as one ordered step. Because it scaffolds files
on mounted folders, it follows the [[sandboxer]] discipline: verify writes land.

## When this applies

- The user says "eclipse this", "critique pass", "debug on", "run it through
  the ringer", "stress-test / red-team this", "poke holes", "does this actually
  hold?" (legacy "torture this" = this pass, answered in eclipse framing) — or asks for a PASS/FAIL on a proposition, design, artifact, or a
  skill under review.
- You're about to build on a claim that hasn't been stress-tested, and want the
  weak parts to break *now*, cheaply, rather than after they're load-bearing.

## The five moves of a pass

Run in order — the order is part of what keeps it honest.

1. **Frame the target as falsifiable claims.** Restate the proposition/design as
   a short list of claims that *could* be shown false. Vague praise can't be
   critiqued; specific claims can. (Watch the verbs — "imposed" vs "offered" was
   the whole bug once.)
2. **Seeded random check.** Pull a few real projects *at random* from the known
   list — seeded and reproducible, so the selection can't be (and can't be
   accused of being) cherry-picked — and test each claim against each project.
   A claim that survives one project but breaks on another has found its edge.
   `scripts/eclipse_pass.sh` does the seeded pull and scaffolds the pass.
3. **Two opposed biases.** Run the claims twice: once **doubt-first** (assume it
   fails; hunt the reason) and once **reward-first** (assume it wins; hunt the
   reason). Where the two *converge* is the stable result; where they diverge is
   an unstable claim that needs more work — convergence is the real verdict, not
   either pass alone.
3a. **Minions before persona.** Release [[ethicsminions]] on the target **before**
   any persona-colored pass, so the ethics read isn't bent by the voice. This
   ordering is deliberate; don't collapse it.
4. **Debugger on: keep the losers.** Default to *debugger on* — do **not** throw
   away the models that lost. Park each as a dated contrast increment under
   `.eclipse-increments/` so a discarded framing can be folded back later if it
   turns out to matter. ("Debugger off" discards them; only choose off when you
   are certain the losers are worthless.)
5. **Verdict.** Write PASS/FAIL plus: which claims survived every strip (the
   load-bearing pillar), which broke and on *which* project, and what the reframe
   should be. Save the framing to a file named for the target (e.g. `C4.md`).

## Using the script

`scripts/eclipse_pass.sh` does the mechanical parts of moves 2 and 4: the
seeded-reproducible project pull and the increment scaffold. It writes nothing
unless `--apply` is given.

```sh
# Show a reproducible random pick of 3 projects to check against (writes nothing):
scripts/eclipse_pass.sh --target C4 --from /f/claude/projects --pick 3 --seed 42

# Scaffold the pass: .eclipse-increments/<date>-C4/ with a filled template:
scripts/eclipse_pass.sh --target C4 --from /f/claude/projects --pick 3 --seed 42 --apply
```

Flags: `--target NAME` (what's under test; required) · `--from PATH` (a file of
candidate projects one-per-line, or a directory whose sub-dirs are the
candidates; required) · `--pick N` (how many to check against, default 3) ·
`--seed S` (integer; omit for a date-derived seed — pass one to reproduce an
earlier pick exactly) · `--out DIR` (where `.eclipse-increments/` lives, default
`.`) · `--apply` (scaffold files; default just prints the pick).

The scaffold drops a `pass.md` (the claims + doubt-first / reward-first sections
+ the minions-before-persona checklist) and a `verdict.md` stub, so the pass has
somewhere to keep both winners and losers from the start.

## After the pass

- The verdict is only trustworthy if the losers were kept — check
  `.eclipse-increments/` actually has the contrast, not just the winner.
- A durable lesson from a pass (a reframe, a broken assumption) is a
  [[mentat-skill]] note; the pass files are working material, not memory.
- If the pass was *about* whether something should be a skill, hand the result
  to [[skilltank]] for the NEW/ENHANCE/LEAVE call — eclipse-pass tests claims,
  skilltank curates the skillset.

