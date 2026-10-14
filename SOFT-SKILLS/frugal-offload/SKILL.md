---
name: frugal-offload
description: >-
  frugal-offload -- the BRIDGE between token-optimizer (the spend-frugally discipline) and llama-
  bridge (the offload-to-a-local-model mechanism): the routing rule that turns 'spend fewer Claude
  tokens here' into a verified local delegation, then closes the cost loop. Use WHENEVER the ask is
  whether/how to hand bulk or mechanical work to a cheaper local model to save tokens: 'should I
  delegate this to save tokens', 'offload this bulk task', 'is this cheap enough to run local',
  'route the mechanical work to ollama', 'which subtasks are delegation-worthy'. It declares the
  SEAM: token-optimizer flags a subtask as bulk/mechanical/verifiable/low-stakes, frugal-offload
  decides it clears the bar (output CHECKABLE, stakes LOW, volume real), routes it to llama-bridge
  with a verification gate, and the token accounting feeds back to token-optimizer's spend ledger.
  Only offload what you can verify cheaply. NOT token-optimizer, NOT llama-bridge, NOT skilltank --
  frugal-offload owns only the WHEN-to-convert decision.
---
# frugal-offload -- the seam between spending less and offloading

`token-optimizer` decides HOW to spend Claude tokens frugally (its ten moves, "spend like it's your
own money"). `llama-bridge` is one concrete way to spend less: hand a subtask to a local Ollama
model. Neither skill mentions the other, so the frugality *intent* rarely becomes an actual offload.
frugal-offload is the thin routing rule that connects them -- it owns the WHEN that sits between
token-optimizer's WHAT and llama-bridge's HOW.

## The seam

    token-optimizer  flags a subtask as bulk / mechanical / verifiable / low-stakes    (the POLICY)
       to frugal-offload.gate(subtask)  -- THIS bridge: does it clear the offload bar?
            OFFLOAD if:  the output is objectively CHECKABLE (schema / must-include / exact match)
                         AND stakes are LOW (a wrong answer is caught, not shipped)
                         AND volume is real (bulk / repetitive, or a long mechanical transform)
            KEEP on Claude if:  judgment-heavy, ambiguous, high-stakes, or one-shot-tiny
       to llama-bridge  runs it on a local model WITH a verification gate (require_json / must_include / escalate_to)
       cost feedback   llama-bridge's token accounting returns to token-optimizer's spend ledger as evidence

The discipline that makes this safe: **only offload what you can verify cheaply.** An unverifiable
local answer is not frugal -- it is a liability that costs more to clean up, which is token-optimizer's
own premise (bad output costs more than good). `scripts/offload_gate.py` is a ~30-line decision helper
that encodes exactly this bar; run `python3 scripts/offload_gate.py --selftest`.

## When it fires

At the moment token-optimizer would say "this is a candidate to delegate," frugal-offload converts
that intent into a concrete llama-bridge call -- or into a clean "no, keep it here" with the reason.
It does not decide whether to *run* token-optimizer (that discipline is always-on) or how to *drive*
the local model (that is llama-bridge); it decides only whether THIS flagged subtask should cross.

## Boundaries
- The frugality discipline itself -- the ten moves, when to run it -> **token-optimizer**.
- Running / choosing / verifying the local model, the MCP bridge, cost accounting -> **llama-bridge**.
- Whether a repeated procedure should become a skill at all -> **skilltank**.
- General intake routing across all skills -> **omni-tool** / **gauntlet**.

frugal-offload owns exactly one decision: converting a token-optimizer frugality flag into a verified
llama-bridge offload, with the cost loop closed. It reimplements neither side.
