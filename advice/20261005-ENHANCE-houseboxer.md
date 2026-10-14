# ENHANCE · houseboxer (his working name): a hardware-aware helper between sandboxer and llama-bridge

produced-by: hello-taxgnomes east drafts, after the Avalon restart · 2026-10-05 UTC · a candidate, not a build

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

## A reading (new wording, labelled as such)

A skill that knows the machine it runs on. It (1) collects hardware facts cheaply, (2) keeps them as a profile
that can be folded back into a bespoke copy of itself (persona-coloured where one is in force), (3) uses the
profile to tune local agents such as llama-bridge's models, and, with real and stated authority, to set them up,
and (4) watches the facts that change, such as free disk, where models live and how to clear them (dump or drop
local agent contexts, archive by threshold). Thresholds stay suggestions unless the user asks for them to be
built in, or C4 later offers a firmer integration.

## The worked example this session gives it

What decided the outcome, and how cheaply each fact could have been known:

| fact | cost to collect | what it changed |
|---|---|---|
| card and VRAM (RTX 3080, 10 GB) | one OS call or Task Manager | sets the ceiling |
| desktop baseline (1.6 GB in use, five monitors) | Task Manager after an Ollama restart | leaves about 8.4 GB for models |
| the model's default context (262,144) and capabilities (thinking, a draft model) | `/api/show` | the whole slowdown; 6.5× on a clean card |
| whether the last load let go of its memory | `/api/ps` against Task Manager | 0.77 vs 8.1 tok/s at the same settings |
| the driver quietly spilling into shared memory | Task Manager "shared GPU memory" | why Ollama's own report looked fine |
| which spare cards can help (only Pascal and newer here) | a photo and a lookup | a hardware decision avoided |
| where models are stored (C:, under the user's profile) | `/api/show` modelfile paths | the disk-pressure watch item |

Numbers and method: projects/hello-taxgnomes/.house/h/PROBE-2026-10-04-ollama-speed.md.

## Fit with what exists

- sandboxer already keeps fingerprints of the runtime; a hardware profile is the same idea one layer down.
- llama-bridge picks models by family and size; a profile would let it pick by what fits (VRAM, context).
- The ENHANCE for the bridge (`20261004-ENHANCE-llama-bridge-think.md`) is the first thing such a profile would feed.
- Tool homing: the collector belongs in C4 if possible, else Avalon (house rule); the profile is data, not a tool.

## Open, for him

- The name (houseboxer is his working name).
- Where the profile lives, and who may read it (his specs are shared without embargo; another user's may not be).
- Which actions need standing authority (creating model variants, pulling models, clearing caches) and which stay
  suggestions.

## Falsifier

On a second machine, the cheap probes alone predict the right `num_ctx` and batch size before the first slow run.
If they don't, the profile is missing a fact that mattered.

## Added the same evening: the model scout (his question, 2026-10-05)

His words (verbatim): "can we easily use our bridge skill to reference llmconfiguration.com and ollama.com to
try and find best fitting (not just a working) fit to task, making this something that must be enabled (here:
yes, unless otherwise said) so the default is to use the available models or pick one that works, as we have
done, but with the settings wide open as I will start with them idealing in a range of models of which some
number (for us, just one at a time right now) will be kept at a time because the worked out for one or several
tasks."

A reading (new wording): an opt-in scout, on in his shop. Off, the bridge does what it does now: use what is
installed, or pick one that works. On, it:
1. reads the machine (free VRAM after the desktop's share; RAM; the model store's free disk);
2. reads candidates and their sizes, context windows and capabilities from ollama.com's tag pages
   (`/library/<model>/tags`; read in the browser pane this session);
3. keeps those that fit with the context the task needs (weights + draft model + KV at the chosen `num_ctx`);
4. pulls and probes each on the real task (rate, thinking tokens, how many drafts the intake keeps, sense);
5. keeps the best N (one, for now) per task, logs the rest with their numbers, and removes them on his word.

What exists already: the bridge can list, pull and warm models; the ollama.com read works; the 3-word probe
and the b01a side-by-side (PROBE file) are the fitness test in small. Missing: a fit calculator and a ledger.

His candidate list, as checked against the RTX 3080 (about 8.4 GB free): fits: qwen3:8b (5.2 GB, from ollama.com),
DeepSeek R1 Distill Llama 8B (about 5 GB, an estimate); borderline: Gemma 3 12B; not without the GTX 1060:
the 14Bs (qwen3:14b 9.3 GB). Qwen3-Coder 8B fits but is tuned for code.

The site he meant is llmconfigurator.com (https://llmconfigurator.com/en/best-models/rtx-3080). Read 2026-10-05:
it ranks models per card at Q4_K_M ("weights plus KV cache plus runtime overhead") and assumes "Usable memory is
10 GB of the card's 10 GB". On Avalon the desktop and five monitors hold about 1.6 GB, so its largest fit (Qwen 3
14B, 9.7 GB) would spill here. The scout should take such a site's list as candidates and correct it with the
measured baseline: the houseboxer's first job. (llmfit, an open-source tool in the same spirit, turned up in a
search on the way; noted, not used.)
