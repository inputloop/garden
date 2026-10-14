# ENHANCE · llama-bridge: let a caller turn thinking off (and pass Ollama options)

produced-by: hello-taxgnomes east drafts, after the Avalon restart · 2026-10-04 UTC
touches: Bryant's Llama Bridge v1.4.0 (polygram/mcp/llama_bridge.py, kept byte for byte; sha256 in
NOTICE-llama_bridge). A note to offer back to him, not an edit here.

## What happened (receipts)

- `ollama_generate` (line 254) sends model, prompt, stream, keep_alive, and system/format when given.
  It never sends `think` or `options`.
- gemma4:12b reports the `thinking` capability, and Ollama turns thinking on when `think` is not sent.
  In a probe on the same 3-word prompt, the thinking run spent 332 tokens before its first answer
  character, while the whole answer with `think: false` was 92 tokens. Through the bridge, that is the
  difference between a batch that fits the 600 s cap and one that doesn't.
  Numbers and method: projects/hello-taxgnomes/.house/h/PROBE-2026-10-04-ollama-speed.md.
- Because the model's prompt format is built into Ollama (`RENDERER gemma4`), thinking cannot be switched
  off by a Modelfile variant either. A per-request `think` is the only handle.

## Proposed

1. `delegate_task` / `delegate_async` take an optional `think` (bool, or "low"/"medium"/"high" where the
   model supports levels) and pass it through as the request's top-level `think`.
2. They also take an optional `options` object (num_ctx, num_predict, temperature, ...), passed through
   unchanged. A config default (`cfg_get("options")`) would let a keeper set it once, the way keep_alive works.
3. When a model has `thinking` and the caller didn't say, record that thinking was on in the job's
   record, so a slow job can be explained after the fact.

## Falsifier

The same `delegate_async` sent with `think: false` comes back with no `thinking` text, and Ollama's
eval_count is within a quarter of the direct-API `think: false` run (92 on the probe prompt). If it
still thinks, the pass-through is wrong.

## Context length matters more than first thought (added after the clean-card retest)

On a clean RTX 3080 the same no-thinking request ran at 52.6 tok/s with `num_ctx 8192` and at 8.1 tok/s with
no `num_ctx`, because Ollama then uses the model's full 262,144 context (and took 124.6 s to load). So passing
`options.num_ctx` through is a speed fix for gemma4-class models, not a nicety. Until the bridge can pass it,
a local variant (`FROM gemma4:12b` + `PARAMETER num_ctx 8192`) gets the same effect with the bridge unchanged.
