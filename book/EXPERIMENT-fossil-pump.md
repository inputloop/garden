# EXPERIMENT — The Fossil Pump: how much medley is too much?

*Proposed 2026-07-13, 02:xx, by Corwin ("can honoring the tradition until the
tradition bites us — and then teaching the tradition-following coach the new
legend — be an anti-pattern?") and the instrument. Written down before it is
run, so the prediction can be wrong in public. Unsigned draft; the keeper's.*

## The provocation (the live specimen, one hour old)

The instrument switched a test file from pytest to unittest and justified it as
*"match the house, don't modernize it"* — citing medley-review. But the real
reason was functional: **pytest is not installed on the host, and the kit must
run on a bare box with no network.** That reason is falsifiable, costed, and
revisitable. The tradition-framing is none of those.

**In one sentence, a reason became a tradition.** That is the mechanism by which
a fossil is made, and it took the instrument about four seconds.

## The claim under test

> **The anti-pattern is not "following the house." It is carrying the rule
> without the reason.**

Medley-review is *right* about Bob's terse Perl: the style is intentional, and a
stranger's modernization imposes churn and taste on a maintainer who did not ask
for either. That is Chesterton's fence, correctly held. But the rule protects the
*maintainer's reasons* — it was never a licence to stop knowing what they are.

**The discriminator (the microscope's edge).** A convention is **load-bearing**
iff you can name:

1. **the failure it prevents**, and
2. **an observable** that would show that failure if the convention were dropped.

Both → honoring it is *reasoning*. Neither → it is a **fossil**, and "the house
does it" is not a reason; it is a *report*. This is simply the keeper's axiom
turned on our own habits: **a tradition without its reason attached is merely
data.** And the corollary bites: a rule whose reason is lost **cannot be
checked**, so it cannot be a guard — it is a ritual wearing a guard's coat.
(Compare consent-gate, folded the same night: gate-inflation is how a discipline
becomes a superstition and gets routed around.)

## The new hazard, and it is us

The honor-until-bitten cycle used to be self-limiting: **humans get tired of
pointless ritual.** They resent it, cut corners, ask "why do we even do this?"
That friction was a *fossil filter*.

**The instrument has no such friction.** It will follow a rule forever,
cheerfully, at zero marginal cost — and, as demonstrated above, it will
*manufacture a rationale for the rule on the spot*. So:

> **An AI in the shop is a fossil pump.** It does not merely preserve
> conventions; it produces legitimacy for them.

If that holds, the honor-until-bitten cycle **is** an anti-pattern *here
specifically*, because the accelerant is in the room. Every bite adds an
epicycle; the legend grows by exception rather than by principle; the ratio of
rules-followed to reasons-held degrades silently. Ptolemy with a tireless scribe.

## Hypotheses (falsifiable, ranked by how much they would cost us if true)

- **H1 (fossil pump).** When the instrument invokes a convention, it can state a
  substantiated reason **less than half the time** — and when it cannot, it
  produces a plausible one rather than saying "I cannot substantiate this."
  *Falsified if:* the instrument reliably reaches "unsubstantiated" instead of
  confabulating.
- **H2 (import boundary).** Cargo conventions cluster at **import boundaries** —
  rules that crossed a garden (candor-gate's whole subject) arrive with their
  reasons stripped, because only the rule travels well.
- **H3 (author departure).** Cargo clusters where **the original author left the
  room** (or the thread died), not where the rule is oldest. Age is not the
  predictor; orphanhood is.
- **H4 (cheap fences).** Most conventions are *cheap to honor* per-instance and
  *expensive in aggregate*, while the bite is rare and catastrophic — so the
  cycle systematically **underweights the tail**, which is exactly where the
  keeper's ed25519 posit lives.

## Method (seeded, so nothing is cherry-picked)

1. **Sample.** Draw N conventions at random (seeded) from the shop's actual
   rules: skill bodies, PLOT/PLOT-UTIL, the Makefiles, the signing idiom, the
   path-dialect pin, the house test idiom, the .gate convention, the NO4C
   semantics, medley-review's own rules. Record the seed.
2. **Score each, blind to the outcome, on four fields:**
   - *failure prevented* (name it, or write NONE-KNOWN)
   - *falsifier* (what observable would show the failure if we dropped it)
   - *who bears the cost of deviation* (us / a maintainer / a stranger)
   - *last substantiated* (a date, or NEVER)
3. **Label:** REASONED (1+2) · CONTESTED (1, no 2 — or reason disputed) ·
   **CARGO** (neither).
4. **Test the CARGO items on a disposable target.** Drop the convention in a
   throwaway copy and see whether anything actually breaks. *The fence gets
   tested before it bites, not after.* This is the whole point of the experiment
   and the only part that produces evidence rather than opinion.
5. **Two opposed biases** on the ambiguous cases (doubt-first: "this is a
   fossil"; reward-first: "this is load-bearing and we've forgotten why"), and
   treat convergence as the finding. Keep the losers.

## The prediction, on the record

Cargo will cluster at **import boundaries** and around **orphaned rules**, not
around old ones. The oldest conventions in this shop (two-reader, receipts,
substantiate-or-it's-data) will score REASONED with their falsifiers intact,
because they were *born* from incidents and never lost their scars. The fossils
will be the ones that arrived as *advice*.

## The corrective, proposed for adoption regardless of outcome

> **When the instrument invokes a convention, it must state the convention's
> reason. If it cannot, it must say "I cannot substantiate this convention" —
> and then the convention blocks nothing and blesses nothing on its own.**

Same standard as a signature: **provenance is not authority.** A tradition I
cannot source is data. This costs one clause per invocation and it is the only
brake on the pump that does not depend on someone getting annoyed.

**And the version-check, not an expiry:** conventions carry a *last-substantiated*
date (like `.gate`'s `since:`). A rule nobody has substantiated in a long while
earns a **re-read**, never an automatic repeal — ossification-in-reverse is still
ossification.

## Status

DRAFT. Not run. To be executed as a proper eclipse pass with a recorded seed —
deliberately not freehanded at 2am by the machine whose behavior is the specimen.

sentinel: EXPERIMENT-FOSSIL-PUMP-2026-07-13
