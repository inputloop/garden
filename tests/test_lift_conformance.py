# polygram -- gated agent-skill synthesis.
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
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

"""LIFT conformance: two independent readers against one prose spec.

Standing practice, his words: *"add coverage up to 100% when something gets by
our tests, ideally with a new spec and implementation language sep from what
the original tested work uses and from what the prior tests use."*

So `lift` arrived with three separate things, not one:

    the spec       polygram/mcp/chainspec.py, LIFT block, checks L1..L5
    reader A       polygram/mcp/dl2.py            (Python)
    reader B       bin/dl2-lift.awk               (awk)

Neither reader is the spec.  That arrangement is the direct product of finding
C9 earlier the same day: the chain's first two "independent" verifiers were in
two different languages, shared no code, and STILL failed together on a forged
chain, because one hand wrote both from one unstated assumption.  Two languages
is not independence.  A common spec that neither reader is, is.

WHY THIS IS DIFFERENTIAL AND RANDOMIZED.  A table of hand-picked cases tests
the cases I thought of, which are the cases both readers already handle,
because I wrote both.  Random inputs with a fixed seed test the cases I did not
think of, reproducibly.  The generator deliberately produces the shapes that
break median arithmetic: even-sized worlds (where lower-median and
mean-of-middles diverge), worlds of size one, ties between citers, zero
pressure, and negative pressure.
"""

import random
import shutil
import subprocess
import unittest
from pathlib import Path

from polygram.mcp import chainspec, dl2

AWK = Path(__file__).resolve().parent.parent / "bin" / "dl2-lift.awk"
ROOT_SRC = Path(__file__).resolve().parent.parent / "polygram" / "mcp"


def _reader_b(pressure, citers, units=None):
    """Run the awk reader and parse its rows back."""
    units = units or {}
    lines = [f"P\t{s}\t{p}" for s, p in sorted(pressure.items())]
    for s, u in sorted(units.items()):
        lines.append(f"U\t{s}\t{u}")
    for s, cs in sorted(citers.items()):
        for c in sorted(cs):
            lines.append(f"C\t{s}\t{c}")
    proc = subprocess.run(
        ["awk", "-f", str(AWK)],
        input="\n".join(lines) + "\n",
        capture_output=True, text=True, encoding="utf-8", check=True)
    out = {}
    for ln in proc.stdout.splitlines():
        if not ln.strip():
            continue
        seam, p, lm, sc, by, state, u, sm = ln.split("\t")
        out[seam] = {"pressure": int(p), "lift_milli": int(lm),
                     "scale": int(sc), "by": by, "state": state,
                     "unit": int(u), "score_milli": int(sm)}
    return out


def _reader_a(pressure, citers, units=None):
    units = units or {}
    raw = dl2.lift(pressure, citers)
    out = {}
    for seam, r in raw.items():
        why = r.get("why", "")
        state = ("NOCITER" if not r["cohorts"] and "no citer" in why
                 else "DAMAGED" if "DAMAGED" in why else "OK")
        u = max(1, int(units.get(seam, 1)))
        out[seam] = {"pressure": r["pressure"], "lift_milli": r["lift_milli"],
                     "scale": r["scale"], "by": r["by"], "state": state,
                     "unit": u, "score_milli": dl2.score(r["pressure"], u)}
    return out


def _cases(seed=20260914, n=250):
    """Shapes chosen to break median arithmetic, not to be realistic."""
    rnd = random.Random(seed)
    for _ in range(n):
        nseams = rnd.randint(1, 9)
        nciters = rnd.randint(0, 4)
        seams = ([f"s{i}" for i in range(nseams)]
                 + [str(100 + i) for i in range(nseams // 3)])   # numeric-looking
        pressure, citers, units = {}, {}, {}
        for s in seams:
            roll = rnd.random()
            if roll < 0.10:
                pressure[s] = -rnd.randint(1, 5)      # L5 damage
            elif roll < 0.30:
                pressure[s] = 0                        # floors the median
            else:
                pressure[s] = rnd.choice([1, 2, 3, 7, 11, 100, 380, 400, 420])
            # Citer names that LOOK numeric are in the pool on purpose: awk
            # compares strnum values numerically, so "9" vs "10" is where the
            # two readers' tie-breaks diverge. A generator that only ever emits
            # "c0".."c3" cannot see that, and it is exactly the kind of split
            # that would sit green for months.
            # Units that make (pressure - u) * 1000 / u NON-EXACT, because
            # that is the only place Python's floor and awk's truncation can
            # disagree -- and score goes negative by design.
            units[s] = rnd.choice([1, 1, 2, 3, 4, 6, 7, 9])
            pool = ([f"c{j}" for j in range(nciters)]
                    + [str(rnd.choice([2, 9, 10, 11, 100]))
                       for _ in range(nciters)])
            # An EMPTY citer set is L4 and must stay reachable in the mix.
            k = rnd.randint(0, len(pool))
            citers[s] = set(rnd.sample(pool, k)) if pool else set()
        yield pressure, citers, units


@unittest.skipIf(shutil.which("awk") is None, "no awk on this host")
class TwoReadersOneSpec(unittest.TestCase):

    def test_readers_agree_on_every_generated_case(self):
        split = []
        for i, (pressure, citers, units) in enumerate(_cases()):
            a = _reader_a(pressure, citers, units)
            b = _reader_b(pressure, citers, units)
            if a != b:
                for seam in sorted(set(a) | set(b)):
                    if a.get(seam) != b.get(seam):
                        split.append((i, seam, a.get(seam), b.get(seam),
                                      pressure, {k: sorted(v) for k, v
                                                 in citers.items()}, units))
                if len(split) > 3:
                    break
        self.assertEqual(
            split, [],
            "CHAIN SPLIT on lift. The two readers disagree, so ONE OF THEM IS "
            "WRONG and neither result is evidence. Do not reconcile by copying "
            "one into the other: read chainspec.py's LIFT block (L1..L5) and "
            "fix whichever reader departed from it.\n"
            + "\n".join(f"  case {i} seam {s}: A={av} B={bv}\n"
                        f"    pressure={p}\n    citers={c}\n    units={u}"
                        for i, s, av, bv, p, c, u in split[:4]))

    def test_prove_red_the_comparison_can_fail(self):
        """A differential test that cannot go red proves nothing."""
        pressure = {"a": 10, "b": 4}
        citers = {"a": {"x"}, "b": {"x"}}
        a = _reader_a(pressure, citers)
        b = _reader_b(pressure, citers)
        self.assertEqual(a, b, "baseline must agree before the red run")
        b_broken = {k: dict(v) for k, v in b.items()}
        b_broken["a"]["lift_milli"] += 1
        self.assertNotEqual(a, b_broken,
                            "PROVE-RED FAILED: the comparison is vacuous")


class TheSpecsNamedChecks(unittest.TestCase):
    """L1..L5 by name, so a failure says which clause was broken."""

    def test_spec_is_present_and_versioned(self):
        self.assertEqual(chainspec.LIFT_SPEC_VERSION, 1)
        self.assertEqual(chainspec.lift_checks,
                         ("L1 world", "L2 scale", "L3 lift",
                          "L4 no citer", "L5 damage"))

    def test_L2_lower_median_not_mean_of_middles(self):
        # The case where the two definitions differ. Mean-of-middles gives 5
        # (a float); the spec says take the lower element, 4.
        self.assertEqual(dl2.lower_median([1, 4, 6, 9]), 4)
        self.assertEqual(dl2.lower_median([1, 4, 6]), 4)
        self.assertEqual(dl2.lower_median([]), 0)

    def test_L2_scale_is_floored_at_one(self):
        r = dl2.lift({"a": 5, "b": 0}, {"a": {"x"}, "b": {"x"}})
        self.assertEqual(r["a"]["scale"], 1, "median 0 must floor to 1")
        self.assertEqual(r["a"]["lift_milli"], 5000)

    def test_L3_is_integer_floor_division(self):
        r = dl2.lift({"a": 1, "b": 3}, {"a": {"x"}, "b": {"x"}})
        # world(x) = {a,b}, pressures {1,3}, lower median = 1
        self.assertEqual(r["a"]["lift_milli"], 1000)
        self.assertEqual(r["b"]["lift_milli"], 3000)
        for row in r.values():
            self.assertIsInstance(row["lift_milli"], int,
                                  "a float here is where readers stop agreeing")

    def test_L3_tie_break_is_deterministic(self):
        # Two citers with identical worlds: `by` must not depend on set order.
        seen = set()
        for _ in range(25):
            r = dl2.lift({"a": 4, "b": 4}, {"a": {"zeta", "alpha"}, "b": {"zeta"}})
            seen.add(r["a"]["by"])
        self.assertEqual(seen, {"alpha"}, "tie must break on name ascending")

    def test_L4_no_citer_is_distinguishable_from_bottom_rank(self):
        r = dl2.lift({"a": 0, "b": 9}, {"a": set(), "b": {"x"}})
        self.assertEqual(r["a"]["scale"], 0)
        self.assertIn("no citer", r["a"]["why"])
        self.assertNotIn("why", r["b"], "a cited seam gets no excuse line")

    def test_L5_damage_is_not_ranked(self):
        r = dl2.lift({"a": -3}, {"a": {"x"}})
        self.assertEqual(r["a"]["lift_milli"], 0)
        self.assertEqual(r["a"]["scale"], 0)
        self.assertIn("DAMAGED", r["a"]["why"])


class WhatLiftIsFor(unittest.TestCase):
    """The behaviour the whole mechanism exists to produce."""

    def test_a_quiet_world_is_not_drowned_by_a_busy_one(self):
        pressure = {"busy-a": 400, "busy-b": 380, "busy-c": 420,
                    "quiet-1": 3, "quiet-2": 1}
        citers = {"busy-a": {"bot"}, "busy-b": {"bot"}, "busy-c": {"bot"},
                  "quiet-1": {"sam"}, "quiet-2": {"sam"}}
        r = dl2.lift(pressure, citers)
        order = sorted(r, key=lambda s: (-r[s]["lift_milli"], s))
        self.assertEqual(
            order[0], "quiet-1",
            "the most-leaned-on note in a small world must float; ranking by "
            "absolute pressure sinks sam's entire world under bot's noise, "
            "which is the availability failure this exists to prevent")
        self.assertLess(r["busy-b"]["lift_milli"], r["quiet-2"]["lift_milli"],
                        "below-median in a busy world must sink below "
                        "at-median in a quiet one")

    def test_one_citer_degenerates_to_the_old_global_order(self):
        pressure = {"a": 9, "b": 4, "c": 1}
        citers = {s: {"only"} for s in pressure}
        r = dl2.lift(pressure, citers)
        by_lift = sorted(r, key=lambda s: (-r[s]["lift_milli"], s))
        by_press = sorted(pressure, key=lambda s: (-pressure[s], s))
        self.assertEqual(by_lift, by_press,
                         "a single-consumer store must rank exactly as before; "
                         "a change there would be a regression dressed as a "
                         "feature")


if __name__ == "__main__":
    unittest.main()


class WhoIsCitingIsNotAnArgument(unittest.TestCase):
    """The citer is the server's identity. A caller may not supply it.

    This became load-bearing the moment buoyancy started ranking a seam
    against the worlds that cite it: a caller-chosen citer is a private world
    of one, and a private world of one floats anything to the top of the
    compaction queue for free.
    """

    def _seat(self):
        import tempfile
        from pathlib import Path as P
        d = P(tempfile.mkdtemp(prefix="cite-"))
        self.addCleanup(shutil.rmtree, d, True)
        return d / "seat"

    def test_a_supplied_citer_is_refused(self):
        from polygram.mcp import mentcached
        from polygram.mcp.rpc import ToolError
        seat = self._seat()
        srv = mentcached.build(by="server-identity", seat=seat, jail=None)
        srv.call("seat_open", {"create": True})
        srv.call("seat_append", {"seam": "s", "text": "x",
                                 "source": "t", "would_change": "first"})
        with self.assertRaises(ToolError) as cm:
            srv.call("seat_cite", {"seam": "s", "by": "somebody-else",
                                   "where": "t"})
        self.assertIn("not a value you pass", str(cm.exception))

    def test_the_servers_own_identity_is_accepted(self):
        """Refusing `by` outright would break an honest caller echoing it."""
        from polygram.mcp import mentcached
        seat = self._seat()
        srv = mentcached.build(by="server-identity", seat=seat, jail=None)
        srv.call("seat_open", {"create": True})
        srv.call("seat_append", {"seam": "s", "text": "x",
                                 "source": "t", "would_change": "first"})
        r = srv.call("seat_cite", {"seam": "s", "by": "server-identity",
                                   "where": "t"})
        self.assertEqual(r["pressure"], 1)

    def test_two_consumers_produce_two_worlds(self):
        """The end-to-end behaviour lift exists for."""
        from polygram.mcp import mentcached
        seat = self._seat()
        bot = mentcached.build(by="build-loop", seat=seat, jail=None)
        sam = mentcached.build(by="at-the-desk", seat=seat, jail=None)
        bot.call("seat_open", {"create": True})
        for seam, srv, n in (("busy-a", bot, 6), ("busy-b", bot, 2),
                             ("busy-c", bot, 7), ("quiet-1", sam, 3),
                             ("quiet-2", sam, 1)):
            srv.call("seat_append", {"seam": seam, "text": f"n {seam}",
                                     "source": "t", "would_change": "first"})
            for _ in range(n):
                srv.call("seat_cite", {"seam": seam, "where": "t"})

        lift_order = [r["seam"] for r in bot.call("seat_buoyancy", {})["queue"]]
        press_order = [r["seam"] for r in
                       bot.call("seat_buoyancy", {"by": "pressure"})["queue"]]
        self.assertEqual(press_order[:2], ["busy-c", "busy-a"])
        self.assertEqual(
            lift_order[0], "quiet-1",
            "the desk's most-leaned-on note must float above the build "
            "loop's ordinary traffic")
        self.assertLess(
            lift_order.index("quiet-2"), lift_order.index("busy-b"),
            "at-median in a quiet world must outrank below-median in a busy "
            "one -- by absolute pressure busy-b (2) beats quiet-2 (1), and "
            "that inversion IS the feature")

    def test_prove_red_the_attack_the_guard_stops_really_works(self):
        """A guard whose attack was never demonstrated is a comment.

        ``Store.cite`` takes the citer as a parameter -- that is the layer the
        server identity is chosen at.  Driving it directly shows what the tool
        guard on ``seat_cite`` is for.

        WHAT THE FIRST VERSION OF THIS TEST GOT WRONG, kept because it is the
        more useful half.  I assumed one fabricated citer and one citation
        would float a worthless note to the top.  It does not, and the reason
        is a property of the arithmetic worth writing down:

            A world of ONE seam has that seam as its own lower median, so the
            seam scores exactly 1000 -- parity with the median, never above
            it.  One fabricated citation buys a seat in the middle of the
            queue and nothing more.

        The real attack needs a SHAPED world: cite a decoy seam once to pull
        your median down to 1, then cite the target repeatedly.  That is what
        is demonstrated below, and it is why the guard lives at the tool layer
        rather than in the arithmetic -- no ranking rule can tell a fabricated
        consumer from a real one, only an identity the caller cannot choose
        can.
        """
        from polygram.mcp import store as _store
        seat = self._seat()
        st = _store.Store(root=seat, by="honest", jail_root=None)
        st.ensure(create=True)
        for seam in ("real-1", "real-2", "real-3", "nobody-wants-this",
                     "decoy"):
            st.append(seam, "x", frm="t", would_change="first")
        for seam, n in (("real-1", 8), ("real-2", 9), ("real-3", 7)):
            for _ in range(n):
                st.cite(seam, "honest", "t")

        # The naive attack, asserted so the property above stays true.
        st.cite("nobody-wants-this", "made-up", "t")
        rows = {r["seam"]: r for r in st.buoyancy()}
        self.assertEqual(rows["nobody-wants-this"]["lift_milli"], 1000)
        self.assertNotEqual(st.buoyancy()[0]["seam"], "nobody-wants-this",
                            "a world of one must score parity, not the top")

        # The shaped attack: one decoy citation drags the median to 1.
        st.cite("decoy", "made-up", "t")
        for _ in range(3):
            st.cite("nobody-wants-this", "made-up", "t")

        self.assertEqual(
            st.buoyancy()[0]["seam"], "nobody-wants-this",
            "PROVE-RED FAILED: a shaped fabricated world did NOT float a "
            "four-citation note above three notes with seven to nine, so the "
            "tool-layer guard on seat_cite is guarding nothing and this suite "
            "proves nothing")
        self.assertEqual(
            st.buoyancy(by="pressure")[0]["seam"], "real-2",
            "and by absolute pressure the fabricated seam ranks near the "
            "bottom -- which is exactly why the guard belongs at the tool "
            "layer and not in the arithmetic")


class TheNeutralBuoyancyLine(unittest.TestCase):
    """chainspec SCORE, U1-U4. His mechanic, 2026-09-14.

    -1 = nothing has leaned on it. 0 = carrying exactly what it was built to
    carry. +1 = act. His examples: a plain term has a mark of 1 and acts at
    two citations; a C4 double-balanced item has a mark of 4 and acts at eight.
    """

    def test_the_spec_is_present_and_versioned(self):
        self.assertEqual(chainspec.SCORE_SPEC_VERSION, 1)
        self.assertEqual(chainspec.ACT_AT_MILLI, 1000)
        self.assertEqual(chainspec.score_checks,
                         ("U1 declared", "U2 floor", "U3 truncation",
                          "U4 act and double"))

    def test_his_two_worked_examples(self):
        self.assertEqual(dl2.score(0, 1), -1000, "nothing has leaned on it")
        self.assertEqual(dl2.score(1, 1), 0, "neutral buoyancy")
        self.assertEqual(dl2.score(2, 1), 1000, "a plain term acts at two")
        self.assertEqual(dl2.score(0, 4), -1000)
        self.assertEqual(dl2.score(4, 4), 0, "the mark is the neutral point")
        self.assertEqual(dl2.score(8, 4), 1000,
                         "a C4 double-balanced item acts at eight")

    def test_U2_the_floor_holds_against_zero_and_nonsense(self):
        for bad in (0, -3, None, ""):
            self.assertEqual(dl2.score(0, bad), -1000,
                             f"unit={bad!r} must floor to 1, never divide")

    def test_U3_truncates_toward_zero_not_toward_minus_infinity(self):
        """The clause that cost LIFT two reader splits, paid up front here.

        Python's // floors; awk, Perl, C and POSIX sh truncate. The score goes
        negative by design, so this is not a corner -- it is most of the line.
        """
        self.assertEqual(dl2.trunc_div(-7000, 3), -2333, "truncate toward 0")
        self.assertEqual((-7000) // 3, -2334, "Python's floor: the odd one out")

        # score(2, 6) = (2-6)*1000/6 = -666.67
        #   truncate toward zero -> -666   (the spec, and awk/perl/C/sh)
        #   floor                -> -667   (Python's //)
        # The first version of this test asserted -667 and passed for the
        # wrong reason in my head: I had written the spec, implemented it
        # correctly, and then written the test from the WRONG side of the
        # very ambiguity the clause exists to close. Left in the record
        # because it is the third time today the check was the thing that
        # was wrong.
        self.assertEqual(dl2.score(2, 6), -666)
        self.assertEqual(((2 - 6) * 1000) // 6, -667)
        self.assertEqual(dl2.score(1, 3), -666)
        self.assertNotEqual(dl2.score(1, 3), ((1 - 3) * 1000) // 3)

    def test_U4_the_act_threshold_is_the_only_verdict_offered(self):
        self.assertLess(dl2.score(7, 4), chainspec.ACT_AT_MILLI)
        self.assertGreaterEqual(dl2.score(8, 4), chainspec.ACT_AT_MILLI)

    def test_score_never_acts_on_its_own(self):
        """A gauge that acts is claiming to be the judgement it feeds."""
        src = (ROOT_SRC / "dl2.py").read_text(encoding="utf-8")
        i = src.index("def score(")
        body = src[i:src.index("\n\n", i)] if "\n\n" in src[i:] else src[i:]
        for forbidden in ("open(", "write", "mkdir", "unlink", "rename"):
            self.assertNotIn(forbidden, body,
                             "score() must compute and return, nothing else")


class TheMarkIsDeclaredNeverInferred(unittest.TestCase):
    """U1, which is store rule 4 wearing arithmetic.

    Deriving the neutral-buoyancy mark from a note's body -- its length, its
    vocabulary, how 'structured' it looks -- would be the store deciding what
    a note is ABOUT and then ranking it on that. The whole point of the mark
    is that the writer declares it.
    """

    def _seat(self):
        import tempfile
        d = Path(tempfile.mkdtemp(prefix="unit-"))
        self.addCleanup(shutil.rmtree, d, True)
        return d / "seat"

    def test_wildly_different_bodies_get_the_same_default_mark(self):
        from polygram.mcp import mentcached
        srv = mentcached.build(by="t", seat=self._seat(), jail=None)
        srv.call("seat_open", {"create": True})
        bodies = {
            "a": "x",
            "b": "Saturday 7pm, bring the good chairs up from the basement.",
            "c": ("# Heading\n\n- one\n- two\n- three\n\n```python\n"
                  "def f():\n    return 1\n```\n" * 20),
            "d": "SKZB panel Friday 14:00 room B; signing to 16:30.",
        }
        for seam, body in bodies.items():
            srv.call("seat_append", {"seam": seam, "text": body,
                                     "source": "him", "would_change": "x"})
        marks = {r["seam"]: r["unit"] for r in srv.call("seat_buoyancy", {})["queue"]}
        self.assertEqual(set(marks.values()), {1},
                         "a longer, more structured or more 'technical' note "
                         "must not earn a bigger mark by looking like one: "
                         f"got {marks}")

    def test_the_declared_mark_is_what_is_stored(self):
        from polygram.mcp import mentcached
        srv = mentcached.build(by="t", seat=self._seat(), jail=None)
        srv.call("seat_open", {"create": True})
        srv.call("seat_append", {"seam": "tiny", "text": "x", "source": "him",
                                 "would_change": "y", "unit": 4})
        srv.call("seat_append", {"seam": "huge", "text": "q " * 5000,
                                 "source": "him", "would_change": "y"})
        marks = {r["seam"]: r["unit"] for r in srv.call("seat_buoyancy", {})["queue"]}
        self.assertEqual(marks, {"tiny": 4, "huge": 1},
                         "one character with a declared 4 outranks ten "
                         "thousand with nothing declared; that is U1")

    def test_a_revision_inherits_rather_than_resetting(self):
        from polygram.mcp import mentcached
        srv = mentcached.build(by="t", seat=self._seat(), jail=None)
        srv.call("seat_open", {"create": True})
        srv.call("seat_append", {"seam": "s", "text": "one", "source": "him",
                                 "would_change": "y", "unit": 4})
        srv.call("seat_append", {"seam": "s", "text": "two", "source": "him",
                                 "would_change": "y"})
        row = srv.call("seat_buoyancy", {})["queue"][0]
        self.assertEqual(row["unit"], 4,
                         "a revision that says nothing about the mark must "
                         "not silently reset a seam's ceiling to 1")

    def test_no_module_derives_the_mark_from_a_body(self):
        """Structural: nothing may compute a unit from note text."""
        import re as _re
        for name in ("dl2.py", "store.py", "mentcached.py"):
            src = (ROOT_SRC / name).read_text(encoding="utf-8")
            for m in _re.finditer(r"unit\s*=\s*([^\n,)]+)", src):
                expr = m.group(1)
                self.assertNotRegex(
                    expr, r"body|text|len\(|split|count",
                    f"{name}: `unit = {expr.strip()}` looks derived from "
                    "content. U1 says the mark is declared by the writer.")
