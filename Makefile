# polygram -- GNU-style convenience Makefile.
# Copyright (C) 2026 Corwin.  Licensed GPL-3.0-or-later (see COPYING).
.POSIX:
PYTHON  = python3
# No __pycache__ from any recipe (2026-10-08, QA1 row 16): the torn 1.0.4 build's own
# `$(PYTHON) -m polygram dist` wrote polygram/__pycache__/{__init__,plugin}.cpython-314.pyc at
# 08:05:18, one minute after rl2bp start, and tripped the QA plan's WARN.  Exported, so every
# python a recipe starts (dist, seatnote, edition, test) inherits it.  tests/makefile-bytecode-tests.sh.
export PYTHONDONTWRITEBYTECODE = 1
MAKEINFO = makeinfo
INSTALL_INFO = install-info

.PHONY: all check test doctor info dist mcpb edition release curate skills garden garden-view kit kit-quick metrics clean help

# The skill garden (Corwin, 2026-09-11: "skills where they belong in the garden ... calling make
# dist will DTRT meaning mint each .skill file we curate"). skills/ is the garden: one directory
# per curated skill, and `make dist` mints every one of them. Deck-derived canon skills live in
# C4_ROOT/dist/skills (c4cs make-skills) and are minted by reference, not copied.
#
# C4_ROOT auto-detects (2026-09-12, closing a recurring sandbox first-run miss): it prefers his
# real host path when present, and falls back to a mounted sandbox copy otherwise, so a fresh
# session's first `make garden` no longer dies on a hard-coded host-only path. Either an
# environment variable or a command-line override still wins over both, e.g.
#   make C4_ROOT=$$HOME/mnt/c4 garden          # explicit override, as before
#   C4_ROOT=/some/other/tree make garden       # environment override (new: was `=`, now `?=`)
# See tests/makefile-c4root-tests.sh for the three cases this covers.
C4_ROOT  ?= $(if $(wildcard /f/claude/c4/.),/f/claude/c4,$(HOME)/mnt/c4)
CANON     = $(C4_ROOT)/dist/skills
SG1CK     = $(C4_ROOT)/bin/sg1ck
LIVE      = $(C4_ROOT)/../.claude/skills
INSTALLED = $(if $(wildcard $(LIVE)/.),$(LIVE),$(lastword $(sort $(wildcard h/INSTALLED-*.tsv))))

help:
	@echo "targets: check  doctor  info  dist  mcpb  release  curate  garden  garden-view  kit  kit-quick  metrics  skills  clean"

all: check info

check test:
	$(PYTHON) -m unittest discover -s tests -v

doctor:
	$(PYTHON) -m polygram doctor

# Build the Texinfo manual to Info (requires GNU Texinfo / makeinfo).
info: doc/polygram.info
doc/polygram.info: doc/polygram.texi
	$(MAKEINFO) --no-split -o $@ $<

# Mint distributable archives + installable .skill bundles into dist/: every skill in skills/
# (the garden) plus every canon skill under $(CANON), one .skill each, plus the aggregates.
#
# Around the mint (Corwin, 2026-09-24): `bin/rl2bp start` bumps z in x.y.z and writes
# releases/<x.y.z> with the start time (a start with no finish = a torn build: no second bump);
# the SIGNING TOOL runs over every skill in the garden unless UNSIGNED=1 -- either
#   UNSIGNED=1 make dist        (environment; the instrument's own spelling: the VM has no key)
#   make dist UNSIGNED=1        (make variable)
# -- and `bin/rl2bp finish` appends the finish time. Unsigned skills still carry an EXPRESS
# manifest (skill-sign.sh manifest), so verify reads UNVERIFIED-AUTHOR, never BAD. Every skill in the
# garden is minted HERE (Corwin, 2026-09-28: "any skills that are in the garden are minted here"):
# the twelve canon skills C4 derives from its decks (c4cs make-skill, into $(CANON)) were copied into
# skills/ that day, so the loop below signs them with the rest. $(CANON) is still read, and skills/
# wins a name; `polygram dist` says each skill that still comes from there and each garden copy
# whose SKILL.md has moved on from C4's (dist.minted_elsewhere). A ceremony is
# a hook the user holds (analysis/ceremony/PAPER-2026-09-24-users-pick-ceremonies.md in C4).
SIGN      = sh skills/skill-sign/scripts/skill-sign.sh
UNSIGNED ?=
# RELEASE=X.Y.Z names the version instead of z+1 (rl2bp start --to): make dist RELEASE=0.8.50
RELEASE  ?=
# NOTE="why" records the keeper's word on the build: releases/X.Y.Z gets a `note` line, and Mentat's
# seat gets the same note when it can be reached (polygram/mcp/seatnote.py; no MCP needed):
#   make dist RELEASE=0.8.90 NOTE="the build we send to Bryant"
NOTE     ?=
# LAUNCH=python|cmd|auto: how the plugin's .mcp.json starts its servers (2026-10-08). Default auto:
# cmd.exe + servers\launch.cmd (finds Python by itself) when this host is Windows, else python.
#   make dist LAUNCH=python     the shape every mint had before 2026-10-08
LAUNCH   ?=
export NOTE
dist:
	@# Secrets at this boundary (Corwin 2026-09-26): what ships is scanned before anything is minted.
	@# sb1rn (C4's, else the vendored copy in bin/): one of two checkers at random, the other
	@# confirms a hit; never prints the secret.  tests/sb-vendored-tests.sh keeps bin/ equal to C4.
	@# Someone else's bytes kept whole (a NOTICE-* pins their sha256: Bryant's Tavern, 2026-10-08) are
	@# checked against the pin first and then left out of the scan: bin/pn1ck. A pin that is off stops here.
	@sh bin/pn1ck check polygram || { echo "make dist: a pinned (vendored) file is not the bytes its NOTICE pins (above)"; exit 1; }
	@SB=$(C4_ROOT)/bin/sb1rn; [ -f "$$SB" ] || SB=bin/sb1rn; if [ -f "$$SB" ]; then sh "$$SB" skills bin $$(sh bin/pn1ck unpinned polygram 2>/dev/null) $(wildcard $(CANON)); rc=$$?; \
	  case $$rc in 0) ;; 1) echo "make dist: secret-shaped text in what would ship (above). Fix it, or mark a documentation line sb:allow."; exit 1;; \
	  *) echo "make dist: secrets NOT fully checked (sb1rn exit $$rc; the reason is above)"; exit 1;; esac; \
	else echo "make dist: no sb1rn in $(C4_ROOT)/bin or bin/ -- refusing to mint what was not checked"; exit 1; fi
	sh bin/rl2bp start $(if $(RELEASE),--to $(RELEASE),) $${NOTE:+--note "$$NOTE"}
	@if [ "$(UNSIGNED)" = 1 ]; then \
	  echo "make dist: UNSIGNED=1 -- express manifests only (no key used)"; \
	  for d in skills/*/; do [ -f "$$d/SKILL.md" ] || continue; $(SIGN) manifest "$${d%/}" || true; done; \
	  sh bin/ps1sg check || true; \
	else \
	  set --; for d in skills/*/; do [ -f "$$d/SKILL.md" ] && set -- "$$@" "$${d%/}"; done; \
	  $(SIGN) sign "$$@" || exit 1; \
	  sh bin/ps1sg sign; rc=$$?; [ $$rc = 1 ] && { echo "make dist: a persona sheet could not be signed (above)"; exit 1; }; true; \
	fi
	$(PYTHON) -m polygram dist --format all --all-installed --skills-source $(CANON) $(if $(LAUNCH),--launch $(LAUNCH),)
	@# A Windows mint (cmd.exe + servers\launch.cmd) cannot start on macOS or GNU/Linux (QA1 row 15).
	@# When this one is that shape, the other shape is minted beside it, same name, its own folder:
	@# dist/posix/vibrobeast.plugin.  Its README says which is which.
	@if grep -q '"command": "cmd"' dist/vibrobeast/.mcp.json 2>/dev/null; then \
	  echo "make dist: dist/vibrobeast.plugin is for Windows; minting the macOS/GNU-Linux shape in dist/posix/"; \
	  $(PYTHON) -m polygram dist --format plugin --all-installed --skills-source $(CANON) --launch python --out dist/posix || exit 1; \
	fi
	@# Terms of Service and Privacy Policy, minted anew for THIS build from claims checked against the
	@# source (bin/tp2mt); a claim that no longer holds stops the build. The pub shelf gets the pair too.
	@# /h/pub/persona is the author's pub shelf (msys path); it is used only when that directory exists,
	@# like $$PUB_PERSONA only when set, so on any other machine this line mints into dist/ and nothing else.
	sh bin/tp2mt $${PUB_PERSONA:+--also $$PUB_PERSONA} $$( [ -d /h/pub/persona ] && echo --also /h/pub/persona )
	@# Prose gauges after the mint (2026-10-10, extension edition): report only, never a stop here;
	@# bin/release is where they refuse.  NEWS lag, then licence lines on prose (lc1ck).
	-@sh bin/release --gauge
	-@sh bin/lc1ck dist/vibrobeast | tail -3
	@sh bin/ss2gr 2>/dev/null || true
	@# A named edition beside the signed one (C4's bin/nm1fl, c/skillnames), when your preferred flavor
	@# is not `label`: --flavor on nm1fl, $$POLYGRAM_FLAVOR, ./.c4/flavor, or ~/.config/polygram/flavor.
	@if [ -f $(C4_ROOT)/bin/nm1fl ]; then sh $(C4_ROOT)/bin/nm1fl mint --force dist/vibrobeast; fi
	@# A publication read of the minted plugin (C4's pb1ck, read-only): it reports machine paths and
	@# e-mail addresses for the keeper to look at. A NOTE, never a gate -- it does not stop the build.
	@if [ -f $(C4_ROOT)/bin/pb1ck ]; then sh $(C4_ROOT)/bin/pb1ck dist/vibrobeast || true; \
	else echo "make dist: pb1ck not found under $(C4_ROOT)/bin -- publication read skipped"; fi
	@# The garden view (bin/gv1mt, 2026-10-10 turn 2, lane G): site/garden/ rebuilt from the files as they are
	@# now, so the page is current at every build.  A view, not part of the plugin: said if it fails, never a stop.
	-@$(PYTHON) bin/gv1mt build --public --c4 $(C4_ROOT) >/dev/null && echo "make dist: garden view rebuilt (site/garden/index.html)" || echo "make dist: the garden view was not rebuilt (above)"
	@# The desktop extension (2026-10-11): the same servers as one .mcpb, minted beside the plugin.
	$(MAKE) --no-print-directory mcpb
	sh bin/rl2bp finish
	@# NOTE="why" (optional): the keeper's word on this build. rl2bp put it in releases/<x.y.z>; here it
	@# is offered to Mentat's seat through the seat's own store code (no MCP needed; never creates a
	@# seat; a seat that cannot be reached is said, and never stops the build).
	@if [ -n "$${NOTE:-}" ]; then $(PYTHON) -m polygram.mcp.seatnote --release-note "$$NOTE" --root . || \
	  echo "make dist: the note is in releases/ only (see the line above)"; fi
	@if [ -n "$(SIZE)$(RANDOM)" ]; then $(MAKE) --no-print-directory edition; fi

# The Claude Desktop extension (2026-10-11): dist/vibrobeast.mcpb, the plugin's six servers behind one
# stdio door (polygram/mcp/hub.py), with a settings page for the doors and their folders.  Checked twice:
# by polygram/mcpb.py itself and by bin/mb1ck (sh + awk, reading the bytes that ship).  Prints the sha256.
mcpb:
	$(PYTHON) -m polygram.mcpb --out dist
	sh bin/mb1ck dist/vibrobeast.mcpb

# A sized edition beside the full plugin (2026-09-28; c4 h/DESIGN-2026-09-28-default-skill-set.md,
# polygram/editions.py). SIZE=grain|great|grand installs the floor plus that share of the population
# beyond it, by use; RANDOM=yes|grain|great|grand|all draws that many more at random (his fourth
# option: to surface skills the ranking under-favours); SEED= repeats a draw. The settings are the
# house numbers. `make dist` never mints one unless SIZE or RANDOM is given, and the full edition's
# bytes do not change either way.
SIZE       ?=
RANDOM     ?=
SEED       ?=
SIZE_GRAIN  = 4
SIZE_GREAT  = 9
SIZE_GRAND  = 17
FLOOR       = mentat-skill,principles,skilltank,sandboxer,lens,garden-usage,consent-gate
# USAGE_DIRS: where the session transcripts are (os.pathsep-separated); default ~/.claude/projects
USAGE_DIRS ?=
edition:
	@if [ -z "$(SIZE)$(RANDOM)" ]; then echo "make edition: name SIZE=grain|great|grand and/or RANDOM=yes|grain|great|grand|all"; exit 2; fi
	POLYGRAM_USAGE_DIRS="$(USAGE_DIRS)" $(PYTHON) -m polygram edition $(if $(LAUNCH),--launch $(LAUNCH),) $(if $(SIZE),--size $(SIZE),) \
	  $(if $(RANDOM),--random $(RANDOM),) $(if $(SEED),--seed $(SEED),) \
	  --house grain=$(SIZE_GRAIN),great=$(SIZE_GREAT),grand=$(SIZE_GRAND) --floor $(FLOOR) \
	  $(if $(wildcard $(C4_ROOT)/c/t),--c4 $(C4_ROOT),)

# What did `make dist` do to the version, and when? (releases/<x.y.z>: start · from · finish)
release:
	sh bin/rl2bp show

# Which soft skills have earned a place in the garden, on the dynaloader's usage ledger? A report;
# graduation is by hand: sh bin/ss2gr --graduate NAME (copies into skills/, express manifest).
curate:
	sh bin/ss2gr

# Where does every skill live, and is the worn copy the curated copy? A gauge (exit 1 = look).
# The worn side is the app's installed store when it is reachable (bin/skill's LIVE dir), else the
# newest h/INSTALLED-*.tsv written by `sg1ck --list-installed DIR` from a session that can see it.
# Without a C4 tree there is nothing to gauge against: said, and not a failure. Decided by make, so
# the recipe stays ONE simple command: bin/gd1ck reads it with `make -n` and runs it under `timeout`.
garden:
	$(if $(wildcard $(SG1CK)),sh $(SG1CK) --garden skills --c4 $(C4_ROOT) --installed $(INSTALLED),@echo "make garden: needs C4's bin/sg1ck at $(C4_ROOT); not found -- skipped")

# The garden view (2026-10-10): Bryant's garden and ours side by side, with the tensions, the compass and the
# doorways, one self-contained page at site/garden/index.html, and a copy for sharing at site/garden/public/
# (this machine's paths and claude.ai links masked; check it with C4's pb1ck before it travels).  Not `garden`: that name is the sg1ck gauge
# above, which bin/gd1ck reads with `make -n` and expects to be one command.  tests/gv1mt-tests.sh.
garden-view:
	$(PYTHON) bin/gv1mt build --public --c4 $(C4_ROOT)

# The whole-garden test + benchmark kit (2026-09-22): every suite in this repo and the C4 tree, each
# skill's lint and size, the plugin's bytes, the garden gauge -- one verdict, results recorded to
# metrics/ (interesting-only). `kit-quick` skips the two slow legs. See bin/gd1ck --help.
kit:
	sh bin/gd1ck --record --c4 $(C4_ROOT)

kit-quick:
	sh bin/gd1ck --record --quick --c4 $(C4_ROOT)

# The metrics store read back: latest row per item, columns aligned. `sh bin/sk2mt say` for words.
metrics:
	sh bin/sk2mt table

skills:
	$(PYTHON) -m polygram synth

clean:
	rm -rf dist doc/polygram.info
	find . -name __pycache__ -type d -prune -exec rm -rf {} +
	find . -name '*.pyc' -delete
