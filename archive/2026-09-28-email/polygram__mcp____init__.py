# polygram -- gated agent-skill synthesis.
# Copyright (C) 2026 Corwin <mplscorwin@gmail.com>.  GPL-3.0-or-later.
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.

"""polygram.mcp -- the three stdio MCP servers the vibrobeast plugin wires.

    mentcached   the memory seat, served          (always on)
    persona      persona sheets, row 0 of mt1pl   (always on)
    skillx       party-to-party skill exchange    (refuses; names its blockers)

All stdlib, all stdio JSON-RPC, all runnable with the python already on the
machine.  Run one with:

    python -m polygram.mcp mentcached
"""

__all__ = ["dl2", "store", "verify", "rpc", "mentcached", "persona", "skillx",
           "SERVERS"]

SERVERS = ("mentcached", "persona", "skillx")
