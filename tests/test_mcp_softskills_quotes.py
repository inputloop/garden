# tier: smoke
# polygram -- softskills reads YAML-quoted front-matter scalars as their contents (spec:
# tests/softskills-quotes-SPEC.txt, Q1-Q5).
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
"""Bryant's parallax writes ``name: "parallax"``; the loader listed it with the quotes on."""

from __future__ import annotations

import unittest

from polygram.mcp import softskills


def fm(body: str) -> dict:
    return softskills._frontmatter("---\n" + body + "\n---\n\n# x\n")


class Quotes(unittest.TestCase):
    def test_q1_double(self):
        self.assertEqual(fm('name: "parallax"')["name"], "parallax")

    def test_q2_escapes(self):
        self.assertEqual(fm(r'description: "say \"hi\" and \\ back"')["description"], 'say "hi" and \\ back')

    def test_q3_single(self):
        self.assertEqual(fm("name: 'it''s'")["name"], "it's")

    def test_q4_blocks_and_plain_unchanged(self):
        f = fm('name: gauntlet\ndescription: >-\n  "quoted inside a block"')
        self.assertEqual(f["name"], "gauntlet")
        self.assertEqual(f["description"], '"quoted inside a block"')

    def test_q5_lone_quote_kept(self):
        self.assertEqual(fm('name: "half')["name"], '"half')
        self.assertEqual(fm('name: a "mid" b')["name"], 'a "mid" b')


if __name__ == "__main__":
    unittest.main()
