---
name: houseboxer
description: "Know the machine local agents run on, cheaply, and fit them to it: the card and its free memory after the desktop's share, each model's real footprint at the window it runs with, whether a load spilled to the CPU, where models are stored and how full that disk is. Use before choosing or tuning a local model (Llama Bridge, Ollama), when a local model is unexpectedly slow, when a card or disk changes, or when asked 'which model fits', 'why is it slow', 'what can this box run', 'houseboxer'. Suggests by default; acts (pull, variant, clear) only with authority stated for that act. Provisional soft skill; houseboxer is his working name."
---

# houseboxer: the machine, known cheaply, and the local agents fitted to it

*A soft skill: read on demand, provisional. The name is Corwin's working name. It sits between
sandboxer (which keeps fingerprints of the runtime) and llama-bridge (which delegates to local
models): the same idea as sandboxer's fingerprints, one layer down, at the hardware.*

## His words (verbatim, 2026-10-05)

> I wonder about a tuning/helper relatiionship between sandboxer and llama-bridge that could be houseboxer,
> working on keeping track of a users specific hardware, carrying tools that can cheeply collect this but also
> offering ways to roll the actual detail back into a bespoke -persona influenced, where available- version of
> the houseboxer (however named) bridge skill that can save result as well as perform inspection hardware, e.g.
> for customization of llama or other local agents according to hardware and, if given appropriate in-fact and
> preference based authorities, can even configure the most effective models as required, keeping track of more
> volatile detals such as disc availability, how to use it, if/how to clear it such as by dumping local agent
> contexts to file or completely, or instituting skill/tool based archiving procedures according to thresholds
> which remain baselines/suggestions even when installed into tool unless users specific ask to have such
> informations more deeply encoded into tool, or unless complex systems such as C4 come along and are able to
> effectuate other integrations that suit our "demands" (lightly: the users demands in the given runtime are the
> firmer sort in context programs to help people program).

A reading (new wording): a skill that knows the machine it runs on. It collects hardware facts
cheaply, keeps them as a profile, uses the profile to fit local agents to the machine, and watches
the facts that change (free disk, where models live, how to clear them). Thresholds stay
suggestions unless the person asks for them to be built in.

## 1. Collect: the cheap facts, and what each one decided on Avalon

| fact | how, cheaply | what it changed (2026-10-04/05) |
|---|---|---|
| card and its memory | `nvidia-smi --query-gpu=name,memory.total,memory.used,driver_version,compute_cap --format=csv` (or Task Manager, Performance, GPU) | 10 GB sets the ceiling |
| the desktop's share | the same, with no model loaded (after an Ollama restart) | 1.6 GB across five monitors: about 8.4 GB left for models |
| a model's own window and abilities | Ollama `/api/show` (`capabilities`, `*.context_length`, `parameters`) | 262,144 by default and `thinking`: the whole slowdown |
| whether the last load let go | `/api/ps` against the card's used memory | a crowded card read 0.77 tok/s; a clean one 52.6 at the same settings |
| a spill to the CPU | `/api/ps` `size_vram` below `size`, or Task Manager's shared GPU memory | Ollama's report looked fine while 5 GB sat in shared memory |
| which spare cards can help | the card's compute capability against what Ollama's runners build for | Pascal (GTX 10xx) still runs on Ollama's CUDA 12 runner, with a driver of 570 or newer |
| where models are stored, and that disk's free space | `/api/show` modelfile paths; `df` or the drive's properties | the disk-pressure watch item |

Llama Bridge 1.4.0-vb.1 already reads two of these for itself: `/api/show` (to size the window and
to send `think` only where it can) and `/api/ps` (its `ollama_status` says when a model spilled).

## 2. Keep: a profile, in words

Write what was found as a short profile in words, one fact per line, each with the command that
produced it and the date: the card, total and free memory, the desktop's share, the models
installed with their sizes and windows, the store's free disk. A profile is data, not a tool.
Where it lives, and who may read it, is the person's call: Corwin shares his specs without embargo;
another person's may not be shared at all. Until he places it, keep it beside the work that needed
it and say where.

## 3. Fit: will this model run here, at this window?

    needs  = weights (the tag page's size) + any draft model loaded with it
             + the context cache at the window it will run with
    fits   if needs <= free memory (the card's total less the desktop's share)

The window is the term that moves. Fit the window first (Llama Bridge vb.1 does this for a model
whose own context is very large), then the model. After the first real run, `ollama_status` is
the measurement: less than 100% in GPU memory means it did not fit, whatever the arithmetic said.

Thinking is a token cost, not a memory cost: off for drafting, extracting and classifying; on for
multi-step reasoning, with room to finish.

## 4. Act only with authority stated for the act

| act | default |
|---|---|
| read the facts, write the profile, recommend a model or a window | do it |
| change a bridge setting (`think_default`, `num_ctx_floor`) | suggest the command; the person runs it, or says "do it" |
| pull a model, make a Modelfile variant, remove one | only on the person's word for that model |
| clear model storage, dump or drop an agent's context | only on the person's word for that act, after saying what goes |

Thresholds (disk free, memory headroom) are suggestions, kept in the profile, unless the person
asks for them to be built into a tool.

## The model scout (his question of the same evening, kept as a candidate)

Off, the bridge does what it does now: use what is installed. On (his shop: on), the scout reads
the machine, reads candidates and their sizes and windows from ollama.com's tag pages, keeps those
that fit with the window the task needs, probes each on the real task, and keeps the best one per
task, logging the rest with their numbers. Missing still: a fit calculator and a ledger.

## Falsifier

On a second machine, the cheap facts alone predict the right window and batch size before the
first slow run. If they do not, the profile is missing a fact that mattered: add it to the table
in section 1.

## Open, for him

The name. Where the profile lives and who may read it. Which acts need standing authority.

The worked example: the delegation skill's `references/PROBE-2026-10-04-ollama-speed.md`.

---
*Version 0.1.0: first edition on 2026-10-05; spine: 2026-10-04.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/; Mentat (for Corwin; claude-opus-5-5)
