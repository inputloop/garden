# polygram -- gated agent-skill synthesis.
# Copyright (C) 2026 Corwin <mplscorwin@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

"""Mint the vibrobeast plugin: skills + three stdio MCP servers, one install.

``polygram dist --format plugin`` produces

    dist/vibrobeast/
      .claude-plugin/plugin.json     the manifest (name is the only hard field)
      .mcp.json                      the three stdio servers
      README.md                      what it is, and the one line to change
      MANIFEST                       sha256 per file, same format as skill-sign
      skills/<name>/SKILL.md ...     every skill the mint collected
      servers/polygram/...           the servers, importable as polygram.mcp
      servers/bin/dl2-verify.sh      the second, independent chain verifier
      servers/bin/dl2-lift.awk      the second, independent buoyancy reader
      servers/bin/bytes-lint.awk    the text/bytes boundary guard (run it on your own code)
    dist/vibrobeast.plugin           the same tree zipped, ready to install

On "server B optional" -- the PLAN's open falsifier, answered
-------------------------------------------------------------
``h/PLAN-2026-09-11-two-servers-one-plugin.md`` §2.1 says: *"Falsifier: if the
plugin format cannot express 'server B optional', it becomes two plugins
sharing a base, and this row is wrong."*

**The format cannot express it.**  ``.mcp.json`` is a flat map of servers the
app launches; there is no per-server optional flag, enable toggle, or
install-time question.  Read strictly, that falsifier fires.

It fires on the wrong assumption, though, and the fix is cheaper than two
plugins: optionality does not have to live in the manifest, because a server
can decline to be useful on its own.  All three here do, loudly and in
different ways --

  * ``skillx`` refuses every tool and names three blockers with their owners.
    Wired, present, and doing nothing until ccspt is intaken with a durable pin.
  * ``mentcached`` and ``persona`` answer ``NOTVISIBLE`` when no seat is
    reachable, and refuse to write rather than invent a fallback.

So: one plugin, three servers, and the optional half is optional at runtime
where a user can see it refusing, rather than at install time where they would
have to remember what they chose.  That is a change to §2.1's mechanism, not a
retreat from o80 -- and it is written here rather than quietly implemented,
because the falsifier did fire and the record should say so.

The interpreter line
--------------------
``command`` defaults to ``python3``.  On the keeper's host (Windows +
msys2/mingw64) that name may not resolve to the interpreter he means, and the
failure looks like the server simply never starting.  ``--python`` bakes in the
right one at mint time; the README and the install card both point at that one
line first, because it is the most likely thing to be wrong on a first install.

That paragraph was written as a prediction and on 2026-09-16 the prediction was
observed: ``get_device_info`` reported all three servers on the keeper's own
machine as ``not_started / could_not_prepare``.  Two things could produce that
and the fix addresses both, because they are cheap and the diagnosis was not
available from where the observation was made (a Linux VM cannot probe what
``python3`` means on the Windows side of the same box):

  1. the interpreter name -- now probeable at mint time with ``--python auto``,
     which RUNS each candidate rather than trusting ``which``;
  2. four ``${VAR}`` env declarations that bought nothing and had to be
     expanded by the host before any server could launch -- now removed.

The falsifier for (1), which only the keeper can run, is one line in the shell
that starts his Claude Desktop::

    python3 -c "import sys; print(sys.executable, sys.version_info[:2])"

If that prints a real interpreter, (1) is not the cause and (2) was.

Both eliminated, 2026-09-19, and the symptom did not move
---------------------------------------------------------
That last sentence is false.  The prediction above was half right, and the
half that was wrong should read as plainly as the half that was right.

  * **(1) is dead.**  Corwin ran ``sh dist/vibrobeast/check-interpreter.sh``
    on the Windows side of his own machine on 2026-09-19 and got, for all
    three servers, ``OK  <name>: python3 is python 3.14 and imports the
    server``.  The name resolves, the interpreter starts, and it imports the
    shipped package.  The falsifier written just above was run and came back
    clean.
  * **(2) is dead too**, and had been before (1) was tested: the ``env`` block
    of the minted ``.mcp.json`` has carried only ``PYTHONPATH`` and
    ``PYTHONDONTWRITEBYTECODE`` since the four passthroughs came out.

And ``get_device_info`` at 2026-09-19T15:44Z still reported all three servers
``not_started / could_not_prepare``.

Both named causes were eliminated and the symptom stayed.  The paragraph above
named two candidates and said the fix addressed both; what it did not say, and
should have, is that two candidates is not the same as every candidate.  A
third cause is open and this file did not have it.

**HYPOTHESIS -- and no receipt for it is available from this bench.**  The one
host-expanded substitution left anywhere in the file is ``"PYTHONPATH":
"${CLAUDE_PLUGIN_ROOT}/servers"``, and it sits inside ``env``.
``could_not_prepare`` names the desktop failing to PREPARE a launch config,
before any interpreter runs, which is consistent with a substitution the host
will not perform in that position.  It is consistent with other things too.
Nobody here has watched the desktop refuse it, and nothing in this tree can:
a Linux VM cannot observe what Claude Desktop does with a spelling on the
Windows side of the same box.  This is written as a hypothesis because that is
what it is -- the last time this file put a guess in the voice of a diagnosis,
it was wrong in exactly this way.

**FALSIFIER, and only the keeper can run it:** the desktop's own MCP log line
for ``could_not_prepare``.  Whatever that line names is the answer.  If it
names the ``${CLAUDE_PLUGIN_ROOT}`` expansion, the hypothesis holds; if it
names anything else, the hypothesis is dead and joins (1) and (2) here.

**The arm built for it.**  ``--self-locating`` mints a plugin whose
``.mcp.json`` contains no ``${...}`` anywhere -- not in ``env`` (there is no
``env``), not in ``command``, not in ``args``.  A launcher shipped beside the
servers, ``servers/launch.py``, works out its own directory and puts it on
``sys.path`` itself, so nothing has to tell it where it lives; it sets
``sys.dont_write_bytecode`` for the same reason, since the ``env`` that used
to carry ``PYTHONDONTWRITEBYTECODE=1`` is gone.  The cost is real: the
launcher's own path is baked ABSOLUTE at mint time (``--install-root``), so
that one line has to name where the tree will actually live, and a cross-host
mint that forgets it produces a plugin that cannot start for a brand new
reason.  ``check-interpreter.sh`` in that mint checks the baked path first,
for exactly that reason.

Install it BESIDE the default mint rather than over it.  If this arm starts
and the default does not, the substitution was the cause.  If neither starts,
it was not, the hypothesis above is dead, and the next place to look is the
desktop's own log.  Either way the install says something, which is the whole
reason to build an arm you do not know the answer to.

2026-09-23 -- the receipt, and what it changed
----------------------------------------------
The desktop's own log was read (``%LOCALAPPDATA%\\Claude\\Logs\\main*.log`` on
avalon; the app is the Microsoft Store build, so there is no
``%APPDATA%\\Claude``).  It says, once an hour for as long as the plugin was
installed::

    [PluginMcpHostConfig] Plugin "plugin_019U3bNQkGTiXZ6scgwqCx7c" server
    "mentcached": failed to build host proxy target: env declares reserved
    variable name "PYTHONPATH"

So the hypothesis above was right about WHERE (the ``env`` block) and wrong
about WHAT: the app does not refuse to expand ``${CLAUDE_PLUGIN_ROOT}``; it
refuses the NAME ``PYTHONPATH`` in a plugin server's ``env``, before it
prepares anything.  That is the whole of ``could_not_prepare``.  The same log
shows all three servers connecting and announcing 16/7/4 tools on 2026-09-19
12:20 and 2026-09-20 02:20 -- a build without that env line has worked on
this host before -- so the interpreter line was never the problem here either:
``where python3`` on avalon resolves to ``c:\\msys64\\mingw64\\bin\\python3.exe``
(3.14.5), two entries ahead of the Store alias.

What changed, and why this shape rather than the other arm:

  * The DEFAULT mint now launches every server through ``servers/launch.py``
    named as ``${CLAUDE_PLUGIN_ROOT}/servers/launch.py`` in ``args`` -- the
    documented, portable place for that variable -- and writes NO ``env`` key
    at all.  The launcher already puts its own directory on ``sys.path`` and
    sets ``sys.dont_write_bytecode``, so both things the env used to carry are
    carried by the file that needs them.
  * ``--self-locating`` stays as the last-resort arm (an absolute path, no
    ``${...}`` anywhere), for a host that turns out not to expand
    ``${CLAUDE_PLUGIN_ROOT}`` in ``args`` either.  Nothing observed says such
    a host exists.
  * ``validate()`` and ``check-interpreter.sh`` both FAULT on a ``PYTHONPATH``
    env, quoting the log line, so this cannot be re-minted by accident.
  * ``tests/mcp-tests.sh`` (a Perl spec, ``tests/mcp-smoke.pl``) drives the
    minted ``.mcp.json`` the way the desktop does -- substitute the variable,
    spawn ``command`` + ``args`` with no extra environment, speak JSON-RPC --
    and is the smoke tier's reason to exist.

**Falsifier for this section:** ``get_device_info`` on avalon still reporting
``could_not_prepare`` after the no-env plugin is installed.  If that happens,
the next receipt is again the log, and this section joins the two above it.
"""

from __future__ import annotations

import datetime as _dt
import hashlib
import json
import shutil
import zipfile
from dataclasses import dataclass, field
from pathlib import Path

from . import __version__
from .dist import SkillSrc, _is_junk, _sha256, _skill_manifest_text, _staged_files

__all__ = ["PluginResult", "mint_plugin", "SERVERS", "DEFAULT_PYTHON",
           "python_argv", "probe_python", "resolve_python"]

DEFAULT_PYTHON = "python3"

#: Tried in order by ``resolve_python`` when the caller asks for "auto".
#: ``python3`` first because it is the POSIX-correct name and the one a
#: stranger's machine most likely has; ``py -3`` last because it is the
#: Windows launcher and exists nowhere else.
PYTHON_CANDIDATES = ("python3", "python", "py")


def python_argv(spec: str) -> list[str]:
    """The argv prefix *spec* means. THE ONE PLACE THAT DECIDES.

    This exists because for one release the mint PROBED one command and BAKED
    another. ``probe_python`` ran ``py -3``; ``_mcp_json`` wrote ``"command":
    "py"`` with ``args`` starting at ``-m``, so ``--python auto`` on a host
    where only the Windows launcher answers certified ``py -3`` and shipped
    bare ``py`` -- the launcher's DEFAULT interpreter, which is not the one
    that was tested. Both call this now, so the argv probed IS the argv baked.
    No test caught it: tests/test_plugin.py only ever passed single-token
    specs, and the arm that diverges is the multi-token one. A line the tests
    route around is exactly where this kind of fault lives.

    A spec may carry its own flags (``"py -3"``, ``"python3.12 -X utf8"``);
    whitespace separates them. A bare ``py`` still expands to ``py -3``,
    because the launcher is never meant bare -- unqualified it selects
    whatever it feels is default, which is the ambiguity we are removing.
    """
    parts = spec.split()
    if not parts:
        raise ValueError("empty python spec")
    if parts == ["py"]:
        return ["py", "-3"]
    return parts


def probe_python(command: str) -> str:
    """Return "" if *command* starts and reports a python >= 3.8, else why not.

    This is the mint-time half of a two-part check. It answers one question --
    does this exact string, run as a command, produce a usable interpreter --
    and it answers it by RUNNING it, because `shutil.which` says a file exists
    and says nothing about whether it is the interpreter you meant. On Windows
    `python3` is frequently an App Execution Alias that exits without ever
    being python at all, which is exactly the shape of failure that leaves a
    server "not_started" with no error a user can read.
    """
    import subprocess
    argv = python_argv(command)
    try:
        # encoding= is not optional here: with text=True alone Python uses the
        # locale codec, which on Windows is a legacy code page. This function
        # exists to diagnose a Windows-only failure, so decoding its own
        # evidence with a codec that differs by host would be the joke telling
        # itself. errors= keeps a banner with odd bytes from raising.
        r = subprocess.run(argv + ["-c", "import sys;print(sys.version_info[:2])"],
                           capture_output=True, text=True, timeout=20,
                           encoding="utf-8", errors="replace")
    except FileNotFoundError:
        return "not found on PATH"
    except OSError as e:                                  # pragma: no cover
        return f"could not run: {e}"
    except subprocess.TimeoutExpired:
        return "did not answer within 20s"
    if r.returncode != 0:
        tail = (r.stderr or r.stdout or "").strip().splitlines()
        return f"exited {r.returncode}" + (f": {tail[-1][:80]}" if tail else "")
    try:
        major, minor = eval(r.stdout.strip())             # "(3, 11)"
    except Exception:
        return f"did not report a version: {r.stdout.strip()[:80]!r}"
    if (major, minor) < (3, 8):
        return f"is python {major}.{minor}; this needs 3.8+"
    return ""


def resolve_python(candidates=PYTHON_CANDIDATES) -> str:
    """Pick the first candidate that actually runs. Raises if none do."""
    why = []
    for c in candidates:
        bad = probe_python(c)
        if not bad:
            return c
        why.append(f"  {c}: {bad}")
    raise RuntimeError("no working python found. Tried:\n" + "\n".join(why)
                       + "\nPass --python with the interpreter you mean.")

# name -> (module arg, description, always_on)
SERVERS = {
    "mentcached": ("mentcached",
                   "The memory seat, served. Archive-only notes with a "
                   "first-seen/last-cited spine, citation pressure, "
                   "semaphores, and a mode word on every answer.", True),
    "persona": ("persona",
                "Persona sheets: row 0 of bin/mt1pl's resolution order. "
                "Sheets are archived like memory -- a mutation is a "
                "generation and the journal entry is its body.", True),
    "skillx": ("skillx",
               "Party-to-party skill exchange. REFUSES every tool and names "
               "the three blockers that would clear it.", False),
}

# Everything the servers need, and nothing else.  The forge CLI (gate, synth,
# review, externs) is not shipped: a plugin that carries a skill-minting
# pipeline it never runs is surface with no use.
_SERVER_FILES = (
    "polygram/__init__.py",
    "polygram/mcp/__init__.py",
    "polygram/mcp/__main__.py",
    "polygram/mcp/chainspec.py",
    "polygram/mcp/dl2.py",
    "polygram/mcp/shipdate.py",
    "polygram/mcp/store.py",
    "polygram/mcp/verify.py",
    "polygram/mcp/rpc.py",
    "polygram/mcp/mentcached.py",
    "polygram/mcp/persona.py",
    "polygram/mcp/skillx.py",
    # 2026-09-22: mentcached imports this (metrics_read). It was missing from this
    # list on the first mint and the minted mentcached died on import -- caught by
    # tests/test_plugin_imports.py, which now imports every server from a real mint.
    "polygram/mcp/metrics.py",
    # 2026-09-23: span_start / span_mark / span_stop / span_report live here too.
    "polygram/mcp/spans.py",
    "polygram/mcp/freshness.py",
    "polygram/mcp/prefs.py",
    "polygram/mcp/checks.py",
    "polygram/mcp/softskills.py",
    "polygram/mcp/seatnote.py",   # a note into the seat from a plain shell (make dist NOTE=...)
    "polygram/mcp/words.py",
)
# Both non-Python readers ship. The Perl one is not optional decoration:
# on a host where sh is missing (Claude Desktop launched from Explorer on
# Windows, with no msys2 on PATH) it is the only second reader available,
# and without it every verification would silently be a single reader.
_SERVER_AUX = ("bin/dl2-verify.sh", "bin/dl2-verify.pl",
               "bin/dl2-lift.awk", "bin/bytes-lint.awk",
               # A register audit found that the tool answering "WHICH witness
               # dissented" did not ship, while the README told the recipient
               # that only the agreement of independent readers is evidence.
               # Shipping the claim without the instrument is the half of the
               # pair that cannot be checked.
               "bin/witness-signature.sh", "bin/frozen-check.awk",
               "bin/mentcached.pl")


@dataclass
class PluginResult:
    name: str
    version: str
    root: Path
    archive: Path | None = None
    skills: list[SkillSrc] = field(default_factory=list)
    servers: list[str] = field(default_factory=list)
    files: int = 0
    sha256: str = ""
    #: The absolute path baked into .mcp.json by --self-locating, "" otherwise.
    launcher: str = ""
    problems: list[str] = field(default_factory=list)


def _manifest_json(name: str, version: str, description: str) -> dict:
    return {
        "name": name,
        "version": version,
        "description": description,
        "author": {"name": "Corwin Brust", "email": "mplscorwin@gmail.com"},
        "license": "GPL-3.0-or-later",
        "homepage": "https://vibrobeast.bru.st",
        "keywords": ["memory", "persona", "provenance", "skills",
                     "archive", "free-software"],
        "skills": "./skills/",
        "mcpServers": "./.mcp.json",
    }


def _mcp_json(python: str, servers: list[str], launcher: str = "") -> dict:
    out: dict = {}
    for s in servers:
        arg, _desc, _on = SERVERS[s]
        # There is NO env block, and there is history behind that absence.
        #
        # Until 2026-09-23 this wrote {"PYTHONPATH": "${CLAUDE_PLUGIN_ROOT}/servers",
        # "PYTHONDONTWRITEBYTECODE": "1"}. Claude Desktop refuses to prepare a
        # plugin server whose env names PYTHONPATH -- its own log: `failed to
        # build host proxy target: env declares reserved variable name
        # "PYTHONPATH"` -- and every server showed as not_started /
        # could_not_prepare for a week. Both settings now live in
        # servers/launch.py (sys.path, sys.dont_write_bytecode), and the
        # no-bytecode promise still holds: __pycache__ is the one directory
        # python executes without being asked, and check.sh treats any .pyc it
        # finds as hostile rather than tolerating it as residue.
        #
        # NOTHING ELSE GOES IN HERE EITHER. An earlier version declared
        # ${MENTCACHED_SEAT}, ${MENTCACHED_JAIL}, ${MENTCACHED_BY} and
        # ${PERSONA_ROOT} as "passthroughs" so a user who set them would have
        # them honoured. They were never needed: a subprocess inherits the
        # launching environment, so a user who exports MENTCACHED_SEAT gets it
        # either way. What the declarations DID do was make every launch depend
        # on the host expanding four more ${VAR} spellings, and on 2026-09-16
        # `get_device_info` reported all three of this plugin's servers on the
        # keeper's own machine as `not_started / could_not_prepare`.
        #
        # The tests had been saying so for a while and nobody read it: the
        # harness in tests/test_plugin.py::_rpc skips any value that is a bare
        # ${...}, i.e. it deliberately declined to exercise these four. A line
        # that the test suite has to route around is not a feature.
        #
        # The server already resolves its own absolute defaults, and treats an
        # unexpanded ${VAR} as "nobody said" (mentcached._roots). Declaring
        # them here bought nothing and cost the launch.
        # THE ARGV PROBED IS THE ARGV BAKED -- see python_argv's docstring for the
        # release where it was not, and how that reads from outside: three servers
        # `not_started / could_not_prepare` and no error anyone can act on.
        _argv = python_argv(python)
        if not launcher:
            # 2026-09-23: NO env key. The desktop refuses to prepare a plugin
            # server whose env names PYTHONPATH ("env declares reserved
            # variable name" -- its own log), and PYTHONDONTWRITEBYTECODE is
            # set by the launcher itself. ${CLAUDE_PLUGIN_ROOT} lives in args,
            # where the plugin format documents it.
            out[s] = {"command": _argv[0],
                      "args": [*_argv[1:], "${CLAUDE_PLUGIN_ROOT}/servers/launch.py", arg]}
            continue
        # The zero-substitution arm. No env AT ALL -- not an empty one, not a
        # literal one -- and the launcher's own absolute path where
        # `-m polygram.mcp` used to be. servers/launch.py puts its own
        # directory on sys.path and sets sys.dont_write_bytecode, so the two
        # things env was carrying are carried by the file that needs them.
        # See this module's 2026-09-19 docstring section for what this is an
        # experiment about, and for what is NOT claimed.
        out[s] = {"command": _argv[0],
                  "args": [*_argv[1:], launcher, arg]}
    return {"mcpServers": out}


_INTERP_SH = """\
#!/bin/sh
# check-interpreter.sh -- does the interpreter this plugin was minted with
# actually START on THIS machine?
#
# check.sh answers "are these the bytes that were minted". This answers the
# other question, and it is the one that has actually bitten: a plugin whose
# bytes are perfect and whose `command` line names an interpreter this host
# does not have reports `not_started / could_not_prepare` and hands the reader
# no error they can act on. On Windows `python3` is frequently an App
# Execution Alias that exits without ever being an interpreter, which is
# exactly that shape.
#
# The mint cannot answer this for you. It bakes the command on the MINTING
# host; the servers run on the INSTALLING host, and on this estate those are
# not the same machine. So the claim travels as a check you run where it
# lands, rather than as an assertion made somewhere it could not be tested.
#
# No python is needed to READ this file -- it extracts the argv from
# .mcp.json, which this plugin generated itself in a known shape, with sed.
set -eu
cd "$(dirname "$0")"
me=check-interpreter.sh
[ -f .mcp.json ] || { echo "$me: no .mcp.json beside me"; exit 2; }

# The generated shape is one "command" line and one "args" array per server,
# indent=2, no tabs. Anything else is not a file this plugin wrote.
argv_of() {          # server -> argv, one token per line
  sed -n "/\\"$1\\": {/,/^    }/p" .mcp.json |
  sed -n -e 's/.*"command": "\\(.*\\)".*/\\1/p' \\
         -e '/"args": \\[/,/\\]/ s/^ *"\\([^"]*\\)",\\{0,1\\} *$/\\1/p'
}

servers=$(sed -n 's/^    "\\([a-z][a-z0-9_-]*\\)": {$/\\1/p' .mcp.json)
[ -n "$servers" ] || { echo "$me: no servers in .mcp.json"; exit 2; }

# Claude Desktop will not PREPARE a plugin server whose env names PYTHONPATH. Its own log
# (avalon, 2026-09-19..23): `failed to build host proxy target: env declares reserved variable
# name "PYTHONPATH"`, and the servers show as not_started / could_not_prepare with no error
# surfaced anywhere a reader would look. So this is checked before any interpreter is.
if grep -q '"PYTHONPATH"' .mcp.json; then
  printf 'FAULT  .mcp.json declares PYTHONPATH in an env block. Claude Desktop refuses to prepare\n'
  printf '       such a server ("env declares reserved variable name"); re-mint from a polygram\n'
  printf '       checkout dated 2026-09-23 or later, which launches through servers/launch.py.\n'
  exit 1
fi

bad=0; n=0
for s in $servers; do
  n=$((n+1))
  # Only the interpreter prefix -- everything before -m -- is what we test.
  pre=$(argv_of "$s" | awk '$0=="-m"{exit} {print}')
  [ -n "$pre" ] || { printf 'FAULT  %s: could not read a command out of .mcp.json\\n' "$s"; bad=$((bad+1)); continue; }
  shown=$(printf '%s ' $pre); shown=${shown% }
  if ! out=$($pre -c 'import sys;print("%d.%d" % sys.version_info[:2])' 2>&1); then
    printf 'FAULT  %s: `%s` did not run\\n       %s\\n' "$s" "$shown" "$(printf '%s' "$out" | tail -1)"
    bad=$((bad+1)); continue
  fi
  case "$out" in
  3.[89]|3.1[0-9]*) ;;
  *) printf 'FAULT  %s: `%s` reported python %s; this needs 3.8+\\n' "$s" "$shown" "$out"
     bad=$((bad+1)); continue ;;
  esac
  # And the real end to end: can that interpreter IMPORT the shipped server?
  if ! imp=$(PYTHONPATH=servers PYTHONDONTWRITEBYTECODE=1 $pre -c 'import polygram.mcp' 2>&1); then
    printf 'FAULT  %s: `%s` runs, but cannot import the shipped server\\n       %s\\n' \\
           "$s" "$shown" "$(printf '%s' "$imp" | tail -1)"
    bad=$((bad+1)); continue
  fi
  printf 'OK     %s: `%s` is python %s and imports the server\\n' "$s" "$shown" "$out"
done

if [ "$bad" -eq 0 ]; then
  printf '\\nOK  %s server(s) will start with the interpreter this plugin was minted with.\\n' "$n"
  exit 0
fi
cat <<'FIX'

FAULT  The baked interpreter does not work here. Nothing is wrong with the
       bytes -- re-mint with one that does, from the polygram checkout:

           python -m polygram dist --format plugin --python auto
           python -m polygram dist --format plugin --python 'py -3'
           python -m polygram dist --format plugin --python /mingw64/bin/python3

       `auto` probes python3, python, then py -3 ON THE MINTING HOST and bakes
       the first that starts -- so run it on the machine that will RUN the
       plugin, or name the interpreter yourself. A spec may carry its own
       flags; the argv probed is the argv baked.
FIX
exit 1
"""


_INTERP_RED_SH = """\
#!/bin/sh
# --prove-red for check-interpreter.sh: plant an interpreter that cannot work
# and watch the check go red. A check that has never said no carries no news.
set -eu
cd "$(dirname "$0")"
d=$(mktemp -d); trap 'rm -rf "$d"' EXIT
cp check-interpreter.sh "$d/"; cp -r servers "$d/servers"
faults=0; fired=0

plant() {   # name, command-json, args-json
  faults=$((faults+1))
  printf '{\\n  "mcpServers": {\\n    "mentcached": {\\n      "command": %s,\\n      "args": %s,\\n      "env": {}\\n    }\\n  }\\n}\\n' \\
    "$2" "$3" > "$d/.mcp.json"
  if ( cd "$d" && sh check-interpreter.sh >/dev/null 2>&1 ); then
    printf '  MISSED  %s -- the check stayed green\\n' "$1"
  else
    printf '  ok      %s -- went red\\n' "$1"; fired=$((fired+1))
  fi
}

echo "RED -- one planted fault per rule:"
plant "an interpreter that is not on PATH" \\
      '"definitely-not-an-interpreter-xyz"' '["-m", "polygram.mcp", "mentcached"]'
plant "a command that runs but is not python" \\
      '"echo"' '["-m", "polygram.mcp", "mentcached"]'
plant "a bare py, the launcher unqualified" \\
      '"py-that-does-not-exist"' '["-m", "polygram.mcp", "mentcached"]'

echo "GREEN -- what must hold:"
# NOT the baked interpreter. This proves the CHECK can say yes; whether the
# BAKED command works here is what `sh check-interpreter.sh` is for, and on a
# cross-host mint the honest answer to that is often no. Conflating the two
# would make --prove-red fail on exactly the machine that minted correctly.
faults=$((faults+1))
here=""
for c in python3 python "py -3"; do
  if $c -c 'import sys;sys.exit(0 if sys.version_info[:2]>=(3,8) else 1)' >/dev/null 2>&1; then here=$c; break; fi
done
if [ -z "$here" ]; then
  printf '  SKIP    no python on this host to prove the yes-case with\\n'; faults=$((faults-1))
else
  hc=${here%% *}; hrest=${here#"$hc"}
  if [ "$hrest" = "$here" ]; then hargs='"-m", "polygram.mcp", "mentcached"'
  else hargs="\\"${hrest# }\\", \\"-m\\", \\"polygram.mcp\\", \\"mentcached\\""; fi
  printf '{\\n  "mcpServers": {\\n    "mentcached": {\\n      "command": "%s",\\n      "args": [%s],\\n      "env": {}\\n    }\\n  }\\n}\\n' \\
    "$hc" "$hargs" > "$d/.mcp.json"
  if ( cd "$d" && sh check-interpreter.sh >/dev/null 2>&1 ); then
    printf '  ok      an interpreter that DOES work here (%s) passes\\n' "$here"; fired=$((fired+1))
  else
    printf '  MISSED  %s works but the check called it a fault\\n' "$here"
  fi
fi

if [ "$fired" -eq "$faults" ]; then
  printf '\\ncheck-interpreter: --prove-red OK (%s of %s)\\n' "$fired" "$faults"; exit 0
fi
printf '\\ncheck-interpreter: --prove-red FAILED (%s of %s)\\n' "$fired" "$faults"; exit 1
"""


_CHECK_SH = """\
#!/bin/sh
# check.sh -- verify this plugin's bytes against its MANIFEST.
# No gpg, no network, no python: sha256sum and awk. GPL-3.0-or-later.
#
# Three defects an adversarial read found in earlier versions, all fixed:
#
#  * It wrote /tmp/.vb_e.$$ -- a guessable name another user can pre-create as
#    a symlink, so running the check overwrote whatever that link pointed at
#    (CWE-377). There are no temp files now.
#  * Its skip patterns were unanchored, so `servers/check.sh` and
#    `servers/MANIFEST` were invisible to the unlisted-file pass. They are
#    anchored to the plugin root now.
#  * `find . -type f` skipped SYMLINKS, so a *.py symlink planted under
#    servers/ -- which is on PYTHONPATH -- was in no MANIFEST line and in no
#    find line, and therefore invisible to both passes. `store.strays()` was
#    given exactly this fix; this was not.
#  * It split MANIFEST lines on single spaces, so any path containing a space
#    was truncated and reported MISSING. The digest is a fixed 64 hex
#    characters followed by exactly two spaces, so the path is simply
#    everything from column 67 -- no splitting at all.
#
# __pycache__ is NOT skipped. `.mcp.json` sets PYTHONDONTWRITEBYTECODE=1, so
# this plugin should never contain any; anything there was put there by
# something else, and it is the one directory python executes without being
# asked. A planted .pyc runs arbitrary code on import.
set -eu
cd "$(dirname "$0")"
[ -f MANIFEST ] || { echo "no MANIFEST beside check.sh"; exit 2; }
if command -v sha256sum >/dev/null 2>&1; then H() { sha256sum "$1" | cut -d' ' -f1; }
elif command -v shasum >/dev/null 2>&1; then H() { shasum -a 256 "$1" | cut -d' ' -f1; }
else echo "need sha256sum or shasum"; exit 2; fi

bad=0; n=0
while IFS= read -r line; do
  [ -n "$line" ] || continue
  want=$(printf '%s' "$line" | cut -c1-64)
  path=$(printf '%s' "$line" | cut -c67-)
  [ -n "$path" ] || continue
  n=$((n+1))
  if [ ! -f "$path" ]; then printf 'MISSING  %s\\n' "$path"; bad=$((bad+1)); continue; fi
  got=$(H "$path")
  [ "$got" = "$want" ] || { printf 'CHANGED  %s\\n' "$path"; bad=$((bad+1)); }
done < MANIFEST

# Unlisted files, compared in awk so no field-splitting touches a path, and
# with the two skips ANCHORED to the plugin root.
unlisted=$(
  find . \\( -type f -o -type l \\) ! -path './MANIFEST' ! -path './check.sh' \\
  | awk 'NR==FNR { if (length($0) > 66) listed[substr($0, 67)] = 1; next }
         { if (!($0 in listed)) print $0 }' MANIFEST -
) || { echo 'FAULT  could not enumerate files'; exit 1; }

if [ -n "$unlisted" ]; then
  printf 'UNLISTED\\n%s\\n' "$unlisted"
  if printf '%s' "$unlisted" | grep -q '__pycache__\\|\\.pyc$'; then
    printf '\\nSome of those are python bytecode. This plugin sets\\n'
    printf 'PYTHONDONTWRITEBYTECODE=1, so it should never write any, and\\n'
    printf '__pycache__ is the one directory python executes without being\\n'
    printf 'asked. Treat a .pyc you did not put there as hostile.\\n'
  fi
  bad=$((bad + 1))
fi

if [ "$bad" -eq 0 ]; then
  printf 'OK  %s file(s) match MANIFEST\\n' "$n"
  printf 'This proves the bytes are the ones that were minted. It does NOT\\n'
  printf 'prove who minted them -- that needs a signature against a pinned key.\\n'
else
  printf 'FAULT  %s problem(s) across %s listed file(s)\\n' "$bad" "$n"; exit 1
fi
"""

_README = """\
# vibrobeast

One plugin, three stdio MCP servers, and the skill garden.

| server | state | what it is |
|---|---|---|
| `mentcached` | always on | the memory seat, served. Archive-only notes, a
  first-seen/last-cited spine, citation pressure, semaphores, and a mode word
  (`SEATED` / `JAILED` / `NOTVISIBLE`) on every single answer. |
| `persona` | always on | persona sheets. Row 0 of `bin/mt1pl`'s resolution
  order (in the author's tree, not shipped), which that tool has been
  reserving since 2026-09-13. |
| `skillx` | **refuses** | party-to-party skill exchange. Every tool refuses
  and names its blocker. This is on purpose: an absent server teaches a caller
  nothing, a refusing one is a checkable statement of what the design owes. |

Two words used below. **`<your-root>`** is wherever you keep a checkout of the
source tree this was minted from (public at `code.bru.st/corwin/vibrobeast`),
if you keep one at all -- nothing here needs it. **"In the author's tree, not
shipped"** marks a tool this README mentions that lives in that source tree or
in the author's C4 tree and is NOT in this plugin; you can run everything else
from the directory this README is in.

## Install

Claude Desktop: upload `vibrobeast.plugin` where the app installs plugins.
Claude Code: `claude plugin install` (the form it takes depends on your
version; `claude plugin --help` says). Nothing else is needed to start: the
servers need a Python 3.8+ the app can launch (see the next section), and the
checks below need `sh`, `sha256sum` (or `shasum`) and, for signatures, `gpg`.

## Verify

The skills are signed with Corwin Brust's OpenPGP key, fingerprint

    ECE7 7CF4 17C7 6C1A CFCE  7C2B 5B61 3551 1580 F007

Get the key from keys.openpgp.org (search that fingerprint), or from the
source tree as `skills/ECE77CF417C76C1ACFCE7C2B5B6135511580F007.asc`. Import
it, and check that the fingerprint gpg prints is the one above:

    gpg --import ECE77CF417C76C1ACFCE7C2B5B6135511580F007.asc
    gpg --fingerprint ECE77CF417C76C1ACFCE7C2B5B6135511580F007

Then, from the directory this README is in:

    sh check.sh
        every shipped byte matches MANIFEST (no gpg needed)
    sh skills/skill-sign/scripts/skill-sign.sh verify skills/NAME
        "signature valid" for a signed skill; UNVERIFIED-AUTHOR for one that
        carries only a hash manifest (it proves the bytes, not the author);
        TREE CHANGED or SIGNATURE FAILED if something is wrong

## What it reads and writes

`PRIVACY.md` beside this README is the full list, minted for this build from
claims checked against the servers' source: every file the servers write,
where, what moves it, and every filter by name. In short: the servers make no
network connections; they write under `~/.mentcached/` unless you point them
elsewhere, and `word_register` writes under a words root only if one is found.
`TERMS-OF-SERVICE.md` has the licences and the words.

## Before the first run -- what has actually gone wrong, and the one line that might

Two things have stopped this plugin's servers on a real desktop, one of them
for a week. Both are checked by `sh check-interpreter.sh`, and it names which.

**The one that did it (2026-09-16 .. 09-23):** an `env` block naming
`PYTHONPATH`. Claude Desktop refuses to prepare a plugin server whose `env`
declares that name -- its log says `failed to build host proxy target: env
declares reserved variable name "PYTHONPATH"` -- and the only thing a reader
sees is `not_started / could_not_prepare`. This plugin's `.mcp.json` now has
no `env` key at all: each server starts through `servers/launch.py`, named as
`${CLAUDE_PLUGIN_ROOT}/servers/launch.py` in `args`, and the launcher puts its
own directory on `sys.path` and sets `sys.dont_write_bytecode` itself.

**The one that might:** `.mcp.json` launches the servers with `{python}`. If
that name is not an interpreter on the machine that runs the plugin (on
Windows, `python3` can be a Store alias that never starts), re-mint from
`<your-root>` with

    python -m polygram dist --format plugin --python /mingw64/bin/python3

or let the minting host pick one for you:

    python -m polygram dist --format plugin --python auto

which runs `python3`, then `python`, then `py -3`, and bakes in the first that
actually starts and reports 3.8+. It probes by RUNNING each one, because a name
being on PATH is not the same as it being python -- on Windows `python3` is
often an App Execution Alias that exits without ever being an interpreter.

Or edit the three `command` lines in `.mcp.json` by hand. Do not add an
`env` block back: the seat variables below are read from the environment the
app launches the server in, and a subprocess inherits that either way.

## Pointing the seat at your memory

**You do not have to set anything to start.** With nothing set, notes go to
`~/.mentcached/seat`, and your first note creates it. Ask `seat_mode` at any
time and it will tell you the exact directory it is using and who chose it.

Three variables change that:

    MENTCACHED_SEAT    where your notes live
    MENTCACHED_JAIL    a project-local fallback, used only if the seat is
                       unreachable and then said out loud on every answer
    MENTCACHED_BY      who is writing and citing (default: `claude`)

There is one rule worth knowing, because it will look like rudeness the first
time it happens:

> **A path this server chose, it may create. A path YOU named, it never will.**

If you set `MENTCACHED_SEAT` to somewhere that does not exist, you get
`NOTVISIBLE` and a refusal, not a new empty store. That is on purpose. From
inside, a first run and a typo look identical — and if it guessed wrong it
would serve you an empty directory as though it were your memory. So it stops
and shows you the path it was given. Check the spelling, or use `seat_open`
with `create: true` to say you meant it.

`MENTCACHED_BY` should be stable. It is not a display name: buoyancy ranks each
note against the other notes the same party has cited, so if this value changes
every time you restart, every note becomes its own little world and the ranking
stops meaning anything.

## Time and tokens -- span_start / span_mark / span_stop / span_report

Four tools on `mentcached` keep a ledger of how long each piece of work took and
what it cost. The discipline is one line: **call `span_start` when a piece of
work begins and `span_stop` when it ends, passing the token budget you can see
each time.** Time is the server's (host clock, UTC, stamped on arrival --
nothing can backdate a row). Tokens are yours to report: an MCP server cannot
see the model's usage, so pass `tokens_left` -- the running figure your harness
shows you -- and the server subtracts. Leave it out and the span reports time
only, in words. `span_mark` is a checkpoint between steps; `span_report` is the
rollup (per span, per label, in all, and what is still open).

The ledger is one append-only TSV, one row per event, never rewritten:
`~/.mentcached/stats/spans.tsv` (or `$MENTCACHED_STATS`, which must already
exist -- a path you named is never created). `sh bin/sp1rp` (in the author's
tree, not shipped) reads the same file with awk, so the report can be checked
in a second language.

## Am I running the shelf's mint? -- plugin_freshness

The pipe from the shelf (`dist/vibrobeast` in the workspace) to this app is a
manual upload, by your hand, on purpose. `plugin_freshness` (on `mentcached`)
makes the question "did anything change that I need to reinstall for?" a call:
it compares the MANIFEST of the plugin the server is running from with the
shelf's (`shelf` argument, or `$POLYGRAM_DIST`), and answers CURRENT / BEHIND /
UNKNOWN with the files that would change, sorted into servers, skills (by name)
and other, and a one-line `reinstall:` verdict in words. Read-only; hashes
nothing. The same answer from a shell:

    python3 -m polygram.mcp.freshness --shelf dist/vibrobeast --installed <installed tree>
        (run in <your-root>)

## Soft skills -- the dynaloader, and the switches

`SOFT-SKILLS/<name>/SKILL.md` -- a folder per skill, the same frontmatter format
as an installed skill, under a root this server reads live: `soft_skills_list`
scans on every call and `soft_skill_read` returns the text. Nothing is minted,
signed, uploaded or installed for a soft skill to be usable; drop the folder in
and it is there on the next call. Roots: the `softskills.roots` preference, else
`$SOFT_SKILLS`, else `~/.mentcached/SOFT-SKILLS` (and `<seat>/../SOFT-SKILLS`).

`pref_list` / `pref_set` are the switches (append-only, last row wins, says who
and why): `freshness.auto` and `softskills.auto` (both on by default) make
`seat_mode` and every `span_start` carry a `checks` panel -- is the installed
plugin the shelf's mint, and how many soft skills are loadable -- and
`freshness.shelf` / `softskills.roots` say where to look. Set them once:

    pref_set softskills.roots <your-root>/SOFT-SKILLS
    pref_set freshness.shelf  <your-root>/dist/vibrobeast

Every `soft_skill_read` appends one line to `~/.mentcached/softskills-usage.tsv`
(the usage ledger); `bin/ss2gr` (in the author's tree, not shipped) reads it and reports which soft
skills are earning a place in the garden. Skills stay soft until they show
use; graduation is by hand, never by the build.

## Words -- word_where / word_register

"We have defined memory, maybe we need words." `word_where NAME` answers where
a word's meaning lives: the C4 word-path registry (`g/<word>/<leaf>`, the leaf
named for the nearest well-known place toward `m/t`: t z s e d g f c h m) plus a
live check of the short list of places one must always look (the register
table, scalars, terms of art, the G graphs, facts, context). Nothing on the
list holds it -> the answer says PROPER GAP, with every place named.
`word_register` writes one leaf and never overwrites; a second leaf on a word
is a seam, kept. The root: `words.root` preference, else `$C4_ROOT`, else
`/f/claude/c4` (the author's layout), else `~/mnt/c4`; with none of them there,
both tools say no root was found and write nothing. The POSIX twin is
`c4/bin/wd1nn` / `wd2nn` (in the author's tree, not shipped): two readers over
one registry, and a test that they agree.

## The three rules this carries

1. **Nothing is overwritten, simplified or deleted.** A write mints a new
   generation beside the old ones. No code path opens an existing note for
   writing, and a test asserts that rather than a comment promising it.
2. **The index is a cache.** Every forward pointer rebuilds from the note files
   alone; every backward pointer is a hash chain in the bytes. Delete the index
   and run `seat_index`; nothing is lost. Tamper with a generation and every
   later `prev:` stops matching.
3. **The mode is always said out loud.** A write while `JAILED` is refused
   unless you ask for it by name, and an allowed one carries `mode: JAILED` in
   its front matter forever.

## Checking it yourself

Run these from the directory this README is in. Every one of them was once
printed here in a form that did not work, so each is written out in full:

    sh check.sh
        the shipped bytes match MANIFEST

    sh servers/bin/dl2-verify.sh --prove-red
        the second chain reader, made to fail on purpose

    perl servers/bin/dl2-verify.pl --prove-red
        the third chain reader, likewise

    python3 servers/launch.py --list
        the three servers and every tool they offer, started the way the app starts them

    python3 servers/launch.py --prove-red
        fire every refusal on purpose

    sh check-interpreter.sh
        will the interpreter named in .mcp.json start HERE, and is the env block clean

`PYTHONDONTWRITEBYTECODE=1` is not optional in the last two. Without it Python
leaves `.pyc` files inside the bundle, and the next `sh check.sh` reports them
as UNLISTED and tells you to treat a `.pyc` you did not put there as hostile —
which would be sound advice about a file you had in fact just put there
yourself.

The chain check exists twice -- once in Python, once in POSIX shell -- sharing
no code, no parser and no hash implementation. Only the agreement of two
independent readers is evidence; a single implementation checking itself can
only find the bugs it does not have.

## Using it -- the garden's test kit and its metrics

The `skill-metrics` skill in `skills/skill-metrics/` carries a small store of
what each shipped thing was last seen doing: one row per interesting event
(`ITEM STATE CUR LAST DATE NOTE`), one file per item holding its last STATE,
and content-keyed copies of the current and previous version. Its one
implementation is `skills/skill-metrics/scripts/sk2mt` (POSIX sh); its contract
is `skills/skill-metrics/SPEC.md`.

    sh skills/skill-metrics/scripts/sk2mt -C DIR say
        every item, one plain sentence each
    sh skills/skill-metrics/scripts/sk2mt -C DIR state -e '^gf-'
        a POSIX grep pattern over item names
    sh skills/skill-metrics/scripts/sk2mt -C DIR items --state RED
        which items are RED now (patterns match NAMES, never states)
    sh skills/skill-metrics/tests.sh --prove-red
        its suite, made to fail on purpose

`mentcached` also offers **`metrics_read`** (arguments: `view`, `names`,
`pattern`, `state`, and the grep flags), a read-only window on the same store. It runs `sk2mt` rather than parsing the store a second time, so it needs
two things from the environment the app launches it in:

    SKILL_METRICS_ROOT   the store directory (in <your-root>: its metrics/ folder).
                         Unset or missing answers NOTVISIBLE; nothing is created.
    SKILL_METRICS_SH     only if `sh` is not on that PATH -- on Windows, e.g.
                         <msys2-root>/usr/bin/sh.exe. Without an sh it refuses by name.

Rows are written on the host, by the run that measured them:
`sh bin/gd1ck --record` (in the author's tree, not shipped) runs every suite in
that repo and the C4 tree, lints and sizes every skill, checks this plugin's bytes and gauges the
garden, then records each result. Nothing here writes a row from a chat.

## Licence

Every file not otherwise marked is GPL-3.0-or-later (`COPYING`); see
TERMS-OF-SERVICE.md for the writing. Free software: you may run, study, share
and improve it.
"""


_LAUNCH_PY = '''\
#!/usr/bin/env python3
# polygram -- gated agent-skill synthesis.
# Copyright (C) 2026 Corwin <mplscorwin@gmail.com>.
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.  It comes with ABSOLUTELY NO WARRANTY.  You should have
# received a copy of the licence with this program -- see COPYING at the top
# of this plugin; if not, see <https://www.gnu.org/licenses/>.
"""launch.py -- start one of this plugin's MCP servers, owing the host nothing.

Until 2026-09-23 the default mint launched ``python3 -m polygram.mcp NAME``
and told the app where the package was with an ``env`` block,
``PYTHONPATH=${CLAUDE_PLUGIN_ROOT}/servers``.  Claude Desktop refuses to
prepare a plugin server whose env names PYTHONPATH (its log: ``env declares
reserved variable name "PYTHONPATH"``), and the reader sees only
``not_started / could_not_prepare``.

This file exists so that nothing has to be carried by an env block.  A python
file always knows where it is -- ``__file__`` -- so it puts its own directory
on ``sys.path`` and sets ``sys.dont_write_bytecode`` itself, then hands over
to the same entry point ``-m polygram.mcp`` uses.  The default mint names this
file as ``${CLAUDE_PLUGIN_ROOT}/servers/launch.py`` in ``args``; the
``--self-locating`` mint names it by absolute path so that no ``${...}`` is
left anywhere.

    python3 <this file> mentcached     the server, on stdio
    python3 <this file> --list         the three servers and their tools

It is not cleverness for its own sake.  Three servers have reported
``not_started / could_not_prepare`` on the keeper's desktop since 2026-09-16;
the two causes the mint could name have both been eliminated, with receipts,
and one host-expanded substitution was left.  This is the arm that removes it,
so that installing it says something either way.
"""

import os
import sys

# FIRST, before anything beside us is imported.  The default mint says this in
# .mcp.json as PYTHONDONTWRITEBYTECODE=1; this mint has no env block at all, so
# the launcher has to say it itself.  __pycache__ is the one directory python
# executes without being asked, and check.sh is right to treat a .pyc it did
# not mint as hostile -- which it cannot do if we leave one lying about.
sys.dont_write_bytecode = True

_HERE = os.path.dirname(os.path.realpath(__file__))
if _HERE not in sys.path:
    sys.path.insert(0, _HERE)

from polygram.mcp.__main__ import main   # noqa: E402 -- after sys.path, on purpose

if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
'''


_README_SELFLOC = """

## This copy is the zero-substitution arm

`.mcp.json` here contains no `${...}` at all -- no `env` block, and the servers
start through `servers/launch.py`, which works out its own directory and puts
it on `sys.path` itself.  Nothing has to be expanded by the app before a server
can be prepared.

The price is one absolute path, baked at mint time:

    {launcher}

If this tree is not at that path on the machine that RUNS it, nothing starts,
and `sh check-interpreter.sh` says so in as many words before it says anything
else.  Re-mint with the right one:

    python -m polygram dist --format plugin --self-locating --install-root DIR

This arm exists to answer one question the default mint cannot: whether
`not_started / could_not_prepare` is the app declining to expand
`${CLAUDE_PLUGIN_ROOT}` inside `env`.  That is a hypothesis, not a finding --
see the 2026-09-19 section of `polygram/plugin.py`'s module docstring for what
was eliminated, with what receipts, and what is still open.

Install this BESIDE the default mint, not over it.  If this one starts and that
one does not, the substitution was the cause.  If neither starts, it was not,
and the next place to look is the desktop's own MCP log.
"""


# check-interpreter.sh reads argv straight out of the .mcp.json this plugin
# generated, and the zero-substitution mint moves that shape: there is no `-m`
# to stop at any more, there is a launcher path instead.  A parser that did not
# move with it would silently read the WRONG argv -- command plus launcher plus
# server name -- and then "test" an interpreter nobody launches.
#
# These are asserted replacements against the one script, not a second copy of
# it.  A copy drifts; a .replace() whose anchor quietly stopped matching would
# ship exactly the broken parser this comment is about.  So _interp_sh raises
# instead of shipping a miss.
_INTERP_ARGV_OLD = r"""  pre=$(argv_of "$s" | awk '$0=="-m"{exit} {print}')"""

_INTERP_ARGV_NEW = r"""  # Two shapes now: `-m polygram.mcp NAME`, and the zero-substitution
  # `<abs>/servers/launch.py NAME`. Stop at whichever comes first.
  pre=$(argv_of "$s" | awk '$0=="-m"||/\.py$/{exit} {print}')"""

_INTERP_IMPORT_OLD = r"""  # And the real end to end: can that interpreter IMPORT the shipped server?
  if ! imp=$(PYTHONPATH=servers PYTHONDONTWRITEBYTECODE=1 $pre -c 'import polygram.mcp' 2>&1); then
    printf 'FAULT  %s: `%s` runs, but cannot import the shipped server\n       %s\n' \
           "$s" "$shown" "$(printf '%s' "$imp" | tail -1)"
    bad=$((bad+1)); continue
  fi
"""

_INTERP_IMPORT_NEW = r"""  # This mint bakes the launcher's path ABSOLUTE, because nothing in its
  # .mcp.json is expanded by anybody. So where the default shape has one
  # thing to check, this one has two -- and the first is the likelier to be
  # wrong: a tree minted on one host and installed at another path.
  lp=$(argv_of "$s" | awk '/\.py$/{print; exit}')
  if [ -n "$lp" ]; then
    # The default shape names it as ${CLAUDE_PLUGIN_ROOT}/servers/launch.py; the app expands that
    # to the plugin root, which is the directory this script cd'd into.
    case $lp in '${CLAUDE_PLUGIN_ROOT}'/*) lp=$PWD/${lp#'${CLAUDE_PLUGIN_ROOT}'/} ;; esac
    if [ ! -f "$lp" ]; then
      printf 'FAULT  %s: the baked launcher path is not a file on THIS host\n       %s\n' "$s" "$lp"
      printf '       Re-mint naming where this tree really lives:\n'
      printf '       polygram dist --format plugin --self-locating --install-root DIR\n'
      bad=$((bad+1)); continue
    fi
    # And the claim this mint exists to make: the launcher finds the servers
    # with NO PYTHONPATH set, because it works out its own directory.
    if ! imp=$( unset PYTHONPATH; $pre servers/launch.py --list 2>&1 ); then
      printf 'FAULT  %s: `%s` runs, but servers/launch.py could not list\n       %s\n' \
             "$s" "$shown" "$(printf '%s' "$imp" | tail -1)"
      bad=$((bad+1)); continue
    fi
  # A config in the OTHER shape -- `-m polygram.mcp NAME` -- is still a config
  # this script gets handed: check-interpreter-prove-red.sh plants three of
  # them, and so does anyone comparing the two arms by hand. Check it the way
  # the default mint would rather than calling it malformed. This clause was
  # written because prove-red went from 4/4 to 3/4 without it, and a harness
  # that fails for its own reasons stops being read.
  elif ! imp=$(PYTHONPATH=servers PYTHONDONTWRITEBYTECODE=1 $pre -c 'import polygram.mcp' 2>&1); then
    printf 'FAULT  %s: `%s` runs, but cannot import the shipped server\n       %s\n' \
           "$s" "$shown" "$(printf '%s' "$imp" | tail -1)"
    bad=$((bad+1)); continue
  fi
"""


# The shared trailer names the interpreter, because in the default shape the
# interpreter is the only thing that can be wrong. In this shape a second
# thing can, and a trailer that misnames it sends the reader to the wrong
# line.
_INTERP_TAIL_OLD = r"""FAULT  The baked interpreter does not work here. Nothing is wrong with the
       bytes -- re-mint with one that does, from the polygram checkout:"""

_INTERP_TAIL_NEW = r"""FAULT  Something baked at mint time does not work here. Nothing is wrong
       with the bytes.

       If the fault above named the LAUNCHER PATH, the interpreter is fine
       and this tree is not where its .mcp.json says it is. Re-mint with
       --install-root naming where it actually lives.

       If it named the interpreter, re-mint with one that works, from the
       polygram checkout:"""


def _interp_sh(self_locating: bool = True) -> str:
    """check-interpreter.sh for whichever .mcp.json shape this mint wrote.

    Since 2026-09-23 every mint launches through servers/launch.py, so the
    launcher-aware parser is the only one shipped; the flag is kept for the
    one test that still asks for the old `-m` shape, which the parser also
    understands (check-interpreter-prove-red.sh plants that shape).
    """
    if not self_locating:
        return _INTERP_SH
    out = _INTERP_SH
    for old, new in ((_INTERP_ARGV_OLD, _INTERP_ARGV_NEW),
                     (_INTERP_IMPORT_OLD, _INTERP_IMPORT_NEW),
                     (_INTERP_TAIL_OLD, _INTERP_TAIL_NEW)):
        if old not in out:
            raise RuntimeError(
                "check-interpreter.sh no longer contains a block the "
                "self-locating mint must replace; shipping it unchanged would "
                "read the wrong argv out of the new shape. Fix the anchor.")
        out = out.replace(old, new, 1)
    return out


def _rmtree_force(path: Path) -> None:
    """rmtree that survives Windows.

    `make dist` on avalon (2026-09-23) died with `PermissionError: [WinError 5] Access is
    denied` unlinking `dist/vibrobeast/skills/consent-gate/references/CONSENT-RECORD-TEMPLATE.md`.
    copy2 preserves the source file's mode into the mint, and on Windows a read-only file
    cannot be unlinked, where POSIX does not care. So: on any failure, make the path writable
    and try once more; if it still refuses, say which file, because the remaining cause is a
    process holding it open, which no chmod fixes and a traceback does not name.
    """
    import os as _os
    import stat as _stat

    def _onexc(func, p, exc):
        try:
            _os.chmod(p, _stat.S_IWRITE | _stat.S_IREAD)
            func(p)
        except OSError as e2:
            raise PermissionError(
                f"cannot remove {p} even after clearing read-only ({e2}); something "
                "probably has it open -- close it and re-run the mint") from e2

    try:
        shutil.rmtree(path, onexc=_onexc)          # Python >= 3.12
    except TypeError:                              # pragma: no cover -- older python
        shutil.rmtree(path, onerror=lambda f, p, ei: _onexc(f, p, ei[1]))


def mint_plugin(dist_dir: Path, skills: list[SkillSrc], *,
                source_root: Path,
                name: str = "vibrobeast",
                version: str = __version__,
                python: str = DEFAULT_PYTHON,
                servers: list[str] | None = None,
                self_locating: bool = False,
                install_root: str | Path | None = None,
                description: str = ("A memory seat that follows you and a "
                                    "garden you can trust: archive-only notes "
                                    "with provenance, persona sheets, and the "
                                    "skills to work them."),
                now: _dt.datetime | None = None) -> PluginResult:
    """Stage the plugin tree under *dist_dir* and zip it to ``<name>.plugin``."""
    if not name.replace("-", "").isalnum() or name != name.lower():
        raise ValueError(f"plugin name must be kebab-case lowercase: {name!r}")
    if python == "auto":
        python = resolve_python()
    servers = list(servers or SERVERS)
    unknown = [s for s in servers if s not in SERVERS]
    if unknown:
        raise ValueError(f"unknown server(s): {', '.join(unknown)}")

    root = dist_dir / name
    if root.exists():
        _rmtree_force(root)
    (root / ".claude-plugin").mkdir(parents=True)
    (root / "skills").mkdir()
    (root / "servers").mkdir()

    # The zero-substitution arm bakes exactly ONE absolute path: this
    # launcher's. Nothing in its .mcp.json is expanded by the host, so nothing
    # can tell the launcher where it lives -- a python file knows that
    # already -- but the path in `args` still has to be right on the machine
    # that RUNS the plugin, and on this estate that is not the machine that
    # MINTS it. Hence install_root: name where the tree will live, or get the
    # minting tree's own path, which is only correct when they are one box.
    launcher = ""
    if self_locating:
        base = (str(install_root) if install_root is not None
                else root.resolve().as_posix())
        base = base.replace("\\", "/").rstrip("/")
        if not base:
            raise ValueError("install_root cannot be empty")
        launcher = base + "/servers/launch.py"

    res = PluginResult(name=name, version=version, root=root,
                       skills=list(skills), servers=servers,
                       launcher=launcher)

    # -- manifest + mcp config
    (root / ".claude-plugin" / "plugin.json").write_text(
        json.dumps(_manifest_json(name, version, description), indent=2) + "\n",
        encoding="utf-8", newline="")
    (root / ".mcp.json").write_text(
        json.dumps(_mcp_json(python, servers, launcher), indent=2) + "\n",
        encoding="utf-8", newline="")
    readme = _README.replace("{python}", f"`{python}`")
    if launcher:
        readme += _README_SELFLOC.replace("{launcher}", launcher)
    (root / "README.md").write_text(readme, encoding="utf-8", newline="")

    # -- skills
    #
    # A skill that arrives with no .skill-manifest (the canon skills minted by
    # reference from C4's dist/skills are the usual case) gets an EXPRESS one
    # here, in the plugin tree only -- the source tree is never written -- in
    # the exact bytes skill-sign.sh's build_manifest writes (its own manifest
    # and signature names left out), so `skill-sign.sh verify` reads
    # UNVERIFIED-AUTHOR for it, never "no manifest" (audit F2, 2026-09-27).
    for sk in skills:
        staged = _staged_files(sk)
        for abspath, rel in staged:
            dest = root / "skills" / sk.name / rel
            dest.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(abspath, dest)
        rels = {rel for _, rel in staged}
        if ".skill-manifest" not in rels and ".signature.asc" not in rels:
            (root / "skills" / sk.name / ".skill-manifest").write_text(
                _skill_manifest_text(staged), encoding="utf-8", newline="")

    # -- servers
    missing = []
    # GPLv3 COMPLIANCE, found by a register audit: every one of the 24 shipped
    # files ends its header with "You should have received a copy of the GNU
    # General Public License along with this program." The recipient did not.
    # plugin.json declares GPL-3.0-or-later and the licence text was nowhere in
    # the bundle. For an FSF volunteer's project that is not a nicety.
    src_cov = Path(source_root) / "COPYING"
    if src_cov.is_file():
        (root / "COPYING").write_bytes(src_cov.read_bytes())
    else:
        res.problems.append(
            "no COPYING found at the source root: the bundle ships GPLv3 "
            "headers promising the recipient a copy of the licence, and the "
            "recipient will not get one")

    for rel in _SERVER_FILES + _SERVER_AUX:
        src = source_root / rel
        if not src.is_file():
            missing.append(rel)
            continue
        dest = root / "servers" / rel
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dest)
    if missing:
        res.problems.append(
            "server files not found under "
            f"{source_root}: {', '.join(missing)} -- the plugin was minted "
            "WITHOUT them and its MCP servers will not start")

    # -- the launcher: every shape starts through it now (2026-09-23)
    lp = root / "servers" / "launch.py"
    lp.write_text(_LAUNCH_PY, encoding="utf-8", newline="")
    try:
        lp.chmod(0o755)
    except OSError:                                       # pragma: no cover
        pass

    # -- the byte-checker, so a stranger with no gpg can verify the install
    (root / "check.sh").write_text(_CHECK_SH, encoding="utf-8", newline="")
    (root / "check-interpreter.sh").write_text(_interp_sh(True),
                                               encoding="utf-8", newline="")
    (root / "check-interpreter-prove-red.sh").write_text(_INTERP_RED_SH, encoding="utf-8", newline="")
    try:
        (root / "check.sh").chmod(0o755)
        (root / "check-interpreter.sh").chmod(0o755)
        (root / "check-interpreter-prove-red.sh").chmod(0o755)
    except OSError:                                       # pragma: no cover
        pass

    # -- manifest of bytes (same format as skill-sign / .skill-manifest)
    #
    # __pycache__ is excluded, and not only as tidiness: python writes bytecode
    # into the plugin the first time a server starts, so a manifest that listed
    # it would stop matching the moment the plugin was USED. A checksum that
    # goes red on correct use trains its reader to ignore it, which is worse
    # than having none. check.sh skips the same set, and says so out loud.
    entries = []
    for p in sorted(root.rglob("*")):
        if p.is_file() and p.name not in ("MANIFEST",) and not _is_junk(p, root):
            entries.append((f"./{p.relative_to(root).as_posix()}", _sha256(p)))
    entries.sort()
    (root / "MANIFEST").write_text(
        "".join(f"{d}  {a}\n" for a, d in entries), encoding="utf-8", newline="")
    res.files = len(entries) + 1

    # -- the installable
    #
    # Every entry is written as a UNIX entry (create_system 3) with a mode the
    # file's own first bytes earn: 0755 for a "#!" script, 0644 otherwise.
    # zf.write() copied the minting host's st_mode, and on Windows that is a
    # FAT entry reading -rw-rw-rw-: an unzip then dropped the execute bit and
    # the documented `scripts/skill-sign.sh ...` failed with Permission
    # denied (audit F4, 2026-09-27).  The mode is decided here, not inherited.
    archive = dist_dir / f"{name}.plugin"
    with zipfile.ZipFile(archive, "w", zipfile.ZIP_DEFLATED) as zf:
        for p in sorted(root.rglob("*")):
            if p.is_file() and not _is_junk(p, root):
                data = p.read_bytes()
                zi = zipfile.ZipInfo.from_file(str(p), arcname=p.relative_to(root).as_posix())
                zi.compress_type = zipfile.ZIP_DEFLATED
                zi.create_system = 3
                mode = 0o755 if data[:2] == b"#!" else 0o644
                zi.external_attr = (0o100000 | mode) << 16      # S_IFREG | mode
                zf.writestr(zi, data)
    res.archive = archive
    res.sha256 = _sha256(archive)
    return res


def validate(root: Path) -> list[str]:
    """Manual validation, the checks ``claude plugin validate`` would run.

    Returned as a list of problems; empty means it passed.  ``claude`` is not
    on the keeper's path inside Cowork, so this stands in for it -- and unlike
    the CLI it can be run from a test.
    """
    problems: list[str] = []
    mf = root / ".claude-plugin" / "plugin.json"
    if not mf.is_file():
        return [f"missing {mf.relative_to(root)}"]
    try:
        data = json.loads(mf.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        return [f"plugin.json is not valid JSON: {exc}"]

    nm = data.get("name", "")
    if not nm:
        problems.append("plugin.json has no name")
    elif not all(c.islower() or c.isdigit() or c == "-" for c in nm):
        problems.append(f"name is not kebab-case: {nm!r}")

    sk = root / "skills"
    if sk.is_dir():
        for child in sorted(sk.iterdir()):
            if child.is_dir() and not (child / "SKILL.md").is_file():
                problems.append(f"skills/{child.name} has no SKILL.md")

    mcp_ref = data.get("mcpServers")
    if isinstance(mcp_ref, str):
        # removeprefix, NOT lstrip: lstrip strips a SET of characters, so
        # "./.mcp.json".lstrip("./") is "mcp.json" and the check reports a
        # missing file that is right there. Caught by this validator on its
        # own first run against a real mint.
        p = root / mcp_ref.removeprefix("./")
        if not p.is_file():
            problems.append(f"plugin.json points at {mcp_ref} which does not exist")
        else:
            try:
                cfg = json.loads(p.read_text(encoding="utf-8"))
            except json.JSONDecodeError as exc:
                problems.append(f"{mcp_ref} is not valid JSON: {exc}")
            else:
                for sname, sdef in (cfg.get("mcpServers") or {}).items():
                    args = sdef.get("args") or []
                    for a in args:
                        # The zero-substitution shape names a launcher by
                        # absolute path. That path belongs to the INSTALLING
                        # host and cannot be checked from here -- but the file
                        # it names has to ship, and that can be.
                        if a.endswith(".py"):
                            base = a.replace("\\", "/").rsplit("/", 1)[-1]
                            if not (root / "servers" / base).is_file():
                                problems.append(
                                    f"{sname}: args launch {a} and no "
                                    f"servers/{base} ships beside it")
                        if a.startswith("${CLAUDE_PLUGIN_ROOT}"):
                            rel = a.removeprefix("${CLAUDE_PLUGIN_ROOT}/")
                            if not (root / rel).exists():
                                problems.append(
                                    f"{sname}: args reference {rel}, absent")
                    env = sdef.get("env") or {}
                    if "PYTHONPATH" in env:
                        problems.append(
                            f"{sname}: env declares PYTHONPATH -- Claude Desktop "
                            "refuses to prepare a plugin server that does "
                            "('env declares reserved variable name', its own "
                            "log, 2026-09-19); launch through servers/launch.py")
                    for k, v in env.items():
                        if isinstance(v, str) and v.startswith("${CLAUDE_PLUGIN_ROOT}"):
                            rel = v.removeprefix("${CLAUDE_PLUGIN_ROOT}/")
                            if not (root / rel).exists():
                                problems.append(
                                    f"{sname}: env {k} points at {rel}, absent")
    return problems
