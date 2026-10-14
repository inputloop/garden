# polygram -- GNU-style convenience Makefile.
# Copyright (C) 2026 Corwin.  Licensed GPL-3.0-or-later (see COPYING).
.POSIX:
PYTHON  = python3
MAKEINFO = makeinfo
INSTALL_INFO = install-info

.PHONY: all check test doctor info dist release curate skills garden kit kit-quick metrics clean help

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
	@echo "targets: check  doctor  info  dist  release  curate  garden  kit  kit-quick  metrics  skills  clean"

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
export NOTE
dist:
	@# Secrets at this boundary (Corwin 2026-09-26): what ships is scanned before anything is minted.
	@# sb1rn (C4's, else the vendored copy in bin/): one of two checkers at random, the other
	@# confirms a hit; never prints the secret.  tests/sb-vendored-tests.sh keeps bin/ equal to C4.
	@SB=$(C4_ROOT)/bin/sb1rn; [ -f "$$SB" ] || SB=bin/sb1rn; if [ -f "$$SB" ]; then sh "$$SB" skills bin polygram $(wildcard $(CANON)); rc=$$?; \
	  case $$rc in 0) ;; 1) echo "make dist: secret-shaped text in what would ship (above). Fix it, or mark a documentation line sb:allow."; exit 1;; \
	  *) echo "make dist: secrets NOT fully checked (sb1rn exit $$rc; the reason is above)"; exit 1;; esac; \
	else echo "make dist: no sb1rn in $(C4_ROOT)/bin or bin/ -- refusing to mint what was not checked"; exit 1; fi
	sh bin/rl2bp start $(if $(RELEASE),--to $(RELEASE),) $${NOTE:+--note "$$NOTE"}
	@if [ "$(UNSIGNED)" = 1 ]; then \
	  echo "make dist: UNSIGNED=1 -- express manifests only (no key used)"; \
	  for d in skills/*/; do [ -f "$$d/SKILL.md" ] || continue; $(SIGN) manifest "$${d%/}" || true; done; \
	else \
	  set --; for d in skills/*/; do [ -f "$$d/SKILL.md" ] && set -- "$$@" "$${d%/}"; done; \
	  $(SIGN) sign "$$@" || exit 1; \
	fi
	$(PYTHON) -m polygram dist --format all --all-installed --skills-source $(CANON)
	@# Terms of Service and Privacy Policy, minted anew for THIS build from claims checked against the
	@# source (bin/tp2mt); a claim that no longer holds stops the build. The pub shelf gets the pair too.
	@# /h/pub/persona is the author's pub shelf (msys path); it is used only when that directory exists,
	@# like $$PUB_PERSONA only when set, so on any other machine this line mints into dist/ and nothing else.
	sh bin/tp2mt $${PUB_PERSONA:+--also $$PUB_PERSONA} $$( [ -d /h/pub/persona ] && echo --also /h/pub/persona )
	@sh bin/ss2gr 2>/dev/null || true
	@# A named edition beside the signed one (C4's bin/nm1fl, c/skillnames), when your preferred flavor
	@# is not `label`: --flavor on nm1fl, $$POLYGRAM_FLAVOR, ./.c4/flavor, or ~/.config/polygram/flavor.
	@if [ -f $(C4_ROOT)/bin/nm1fl ]; then sh $(C4_ROOT)/bin/nm1fl mint --force dist/vibrobeast; fi
	@# A publication read of the minted plugin (C4's pb1ck, read-only): it reports machine paths and
	@# e-mail addresses for the keeper to look at. A NOTE, never a gate -- it does not stop the build.
	@if [ -f $(C4_ROOT)/bin/pb1ck ]; then sh $(C4_ROOT)/bin/pb1ck dist/vibrobeast || true; \
	else echo "make dist: pb1ck not found under $(C4_ROOT)/bin -- publication read skipped"; fi
	sh bin/rl2bp finish
	@# NOTE="why" (optional): the keeper's word on this build. rl2bp put it in releases/<x.y.z>; here it
	@# is offered to Mentat's seat through the seat's own store code (no MCP needed; never creates a
	@# seat; a seat that cannot be reached is said, and never stops the build).
	@if [ -n "$${NOTE:-}" ]; then $(PYTHON) -m polygram.mcp.seatnote --release-note "$$NOTE" --root . || \
	  echo "make dist: the note is in releases/ only (see the line above)"; fi

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
