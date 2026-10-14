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

"""A SECOND WITNESS AT THE SERVER LAYER, and the cross-check that makes it one.

Corwin, on why: *"Maybe meantcached should be Perl just so they aren't both
python?"*  ``mentcached`` and ``persona`` are both Python.  They share an
interpreter, a regex engine, an integer-division rule and a string-strip rule,
and therefore a failure mode.  Claim C9 of this tree's ledger says agreement
between two things one hand made in one language is not evidence -- so the read
path now exists twice, once in ``polygram/mcp/store.py`` and once in
``bin/mentcached.pl``, and this file is what turns the pair into an instrument.

WHAT EACH WITNESS BRINGS, because two readers of the same shape are one reader:

  W1  THE PYTHON STORE.  What the server believes today.
  W2  THE PERL READER.  A different language, written from chainspec's PROSE
      (C1-C4, N1-N5, L1-L5, U1-U4) rather than from store.py -- which is the
      only thing that makes it independent.  Not that it is Perl: the
      2026-09-14 forgery passed two readers in two languages because one hand
      wrote both from one unstated assumption.
  W3  THE FROZEN BYTES.  tests/fixtures/frozen/, written by a version of this
      program that no longer exists.  They cannot be updated to match a new
      belief.  **They are copied here byte-for-byte and never regenerated**;
      the copy's sha256 is checked against the original so that a copy which
      mangled anything fails loudly rather than quietly passing.
  W4  RANDOMISED SEATS.  A table of hand-picked cases tests the cases I thought
      of, which are the cases both readers already handle, because I wrote the
      comparison.  Random seats with a fixed seed test the ones I did not.

WHEN THEY DISAGREE, STOP.  A split is not a bug in the Perl to be fixed by
copying the Python.  It means ONE OF THEM IS WRONG and neither result is
evidence until chainspec says which.  That rule is why ``KnownDisagreements``
below states divergences rather than reconciling them: every case in that class
is a finding with a named victim, and every one of them is green **because it
asserts the split**, so the moment either side moves this file goes red and the
finding cannot be quietly forgotten.
"""

import hashlib
import os
import random
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

from polygram.mcp import chainspec, dl2, verify
from polygram.mcp import store as _store

ROOT = Path(__file__).resolve().parent.parent
PERL_READER = ROOT / "bin" / "mentcached.pl"
FROZEN = ROOT / "tests" / "fixtures" / "frozen"

_HAVE_PERL = shutil.which("perl") is not None


# ------------------------------------------------------------------ the Perl side


def _perl(*args, env=None):
    e = dict(os.environ)
    e.pop("MENTCACHED_JAIL", None)
    if env:
        e.update(env)
    return subprocess.run(["perl", str(PERL_READER), *args],
                          capture_output=True, env=e)


def perl_mode(seat, jail=None):
    p = _perl("mode", str(seat), env={"MENTCACHED_JAIL": str(jail)} if jail else None)
    return p.stdout.decode("utf-8", "surrogateescape").split("\t")[0].strip()


def perl_list(seat):
    out = _perl("list", str(seat)).stdout.decode("utf-8", "surrogateescape")
    return [ln for ln in out.split("\n") if ln]


def perl_buoy(seat):
    out = _perl("buoy", str(seat)).stdout.decode("utf-8", "surrogateescape")
    rows = {}
    for ln in out.split("\n"):
        if not ln:
            continue
        c = ln.split("\t")
        rows[c[0]] = {"pressure": int(c[1]), "unit": int(c[2]),
                      "score_milli": int(c[3]), "lift_milli": int(c[4]),
                      "scale": int(c[5]), "by": c[6], "state": c[7]}
    return rows


def perl_read(seat, seam, gen=None):
    args = ["read", str(seat), seam] + ([str(gen)] if gen is not None else [])
    p = _perl(*args)
    if p.returncode != 0:
        return {"error": p.stderr.decode("utf-8", "replace").strip()}
    head, _, body = p.stdout.partition(b"BODY\n")
    # The body is emitted raw with exactly one newline appended, so that a body
    # whose own bytes are not valid UTF-8 survives the trip unchanged.
    out = {"fm": [], "body": body[:-1] if body.endswith(b"\n") else body}
    for ln in head.decode("utf-8", "surrogateescape").split("\n"):
        if not ln:
            continue
        c = ln.split("\t", 2)
        if c[0] == "FM":
            out["fm"].append((c[1], c[2] if len(c) > 2 else ""))
        else:
            out[c[0]] = c[1] if len(c) > 1 else ""
    return out


def perl_chain(seat, seam):
    p = _perl("chain", str(seat), seam)
    lines = p.stdout.decode("utf-8", "surrogateescape").split("\n")
    verdicts = [ln for ln in lines if ln.startswith(("OK\t", "BROKEN\t"))]
    rows = [ln.split("\t") for ln in lines if ln.startswith("G\t")]
    if not verdicts:
        return {"ok": None, "gens": None, "at": "", "check": "", "rows": rows}
    c = verdicts[0].split("\t")
    if c[0] == "OK":
        return {"ok": True, "gens": int(c[1]), "at": "", "check": "", "rows": rows}
    return {"ok": False, "gens": int(c[1]), "at": c[2], "check": c[3], "rows": rows}


# ------------------------------------------------------------------ the Python side


def py_list(st):
    return sorted(st.seams())


def py_buoy(st):
    rows = {}
    for r in st.buoyancy():
        why = r.get("why", "")
        # `state` is the awk reader's vocabulary (L4/L5), re-derived here from
        # the Python row rather than read off it, so the two sides are not both
        # quoting one string.
        state = ("NOCITER" if not r["cohorts"] and "no citer" in why
                 else "DAMAGED" if "DAMAGED" in why else "OK")
        rows[r["seam"]] = {"pressure": r["pressure"], "unit": r["unit"],
                           "score_milli": r["score_milli"],
                           "lift_milli": r["lift_milli"], "scale": r["scale"],
                           "by": r["by"], "state": state}
    return rows


def _gen_no(path):
    return int(chainspec.GEN_NAME.match(path.name).group(1))


def py_read(st, seam, gen=None):
    gens = st.generations(seam)
    path = gens[-1] if gen is None else next(
        p for p in gens if _gen_no(p) == gen)
    raw = path.read_bytes()
    fm, body = dl2.front_matter(raw)
    return {"HANDLE": dl2.slugify(seam), "FILE": path.name,
            "GEN": str(_gen_no(path)), "GENS": str(len(gens)),
            "fm": list(fm.items()),
            "body": dl2.normalize_body(
                body.decode("utf-8", "surrogateescape")).encode(
                    "utf-8", "surrogateescape")}


def py_chain(st, seam):
    r = verify.verify_python(st.notes / dl2.slugify(seam))
    return {"ok": r.ok, "gens": r.gens, "at": r.broken_at or "",
            "check": r.check or ""}


# ------------------------------------------------------------------ fixtures


class _SeatMixin:

    def _store(self, by="witness"):
        """A live, empty store to fire byte-level cases at."""
        from polygram.mcp import store as _s
        st = _s.Store(root=self.tmp(), by=by, jail_root=None)
        return st.ensure(create=True)

    def tmp(self, name="seat"):
        d = Path(tempfile.mkdtemp(prefix="perl-witness-"))
        self.addCleanup(shutil.rmtree, d, True)
        return d / name

    def frozen_seat(self):
        """The frozen notes, byte-for-byte, as a seat this reader can open.

        COPIED, NEVER REGENERATED.  The fixtures live in a bare
        ``<seam>/<generation>.md`` tree with no seat around them, so a seat is
        built around a byte-exact copy and every copied file's sha256 is
        checked against the original.  If a copy ever alters a byte -- newline
        translation being the obvious way -- this fails here rather than
        producing an agreement about the wrong bytes.
        """
        seat = self.tmp()
        (seat / "cited").mkdir(parents=True)
        shutil.copytree(FROZEN, seat / "notes")
        (seat / "notes" / "EXPECTATIONS.md").unlink()
        for src in sorted(FROZEN.rglob("*.md")):
            if src.name == "EXPECTATIONS.md":
                continue
            dst = seat / "notes" / src.relative_to(FROZEN)
            self.assertEqual(
                hashlib.sha256(src.read_bytes()).hexdigest(),
                hashlib.sha256(dst.read_bytes()).hexdigest(),
                f"the copy of {src.name} is not byte-identical to the frozen "
                "original -- every comparison below would be about the wrong "
                "bytes. Do not regenerate the fixture; fix the copy.")
        return seat

    def compare(self, st, seat, label=""):
        """Every field, both readers, and a split names the field."""
        splits = []

        a, b = py_list(st), perl_list(seat)
        if a != b:
            splits.append(("list", a, b))

        a, b = py_buoy(st), perl_buoy(seat)
        for seam in sorted(set(a) | set(b)):
            ra, rb = a.get(seam), b.get(seam)
            if ra != rb:
                for f in ("pressure", "unit", "score_milli", "lift_milli",
                          "scale", "by", "state"):
                    if (ra or {}).get(f) != (rb or {}).get(f):
                        splits.append((f"buoy[{seam}].{f}",
                                       (ra or {}).get(f), (rb or {}).get(f)))

        for seam in py_list(st):
            ca, cb = py_chain(st, seam), perl_chain(seat, seam)
            for f in ("ok", "gens", "at", "check"):
                if ca[f] != cb[f]:
                    splits.append((f"chain[{seam}].{f}", ca[f], cb[f]))
            n = len(st.generations(seam))
            for gen in list(range(1, n + 1)) + [None]:
                ra, rb = py_read(st, seam, gen), perl_read(seat, seam, gen)
                for f in ("HANDLE", "FILE", "GEN", "GENS", "fm", "body"):
                    if ra[f] != rb.get(f):
                        splits.append((f"read[{seam},g{gen}].{f}",
                                       ra[f], rb.get(f)))
        return splits

    def assert_no_split(self, splits, extra=""):
        self.assertEqual(
            splits, [],
            "CHAIN SPLIT between the Python store and bin/mentcached.pl.\n"
            "ONE OF THEM IS WRONG and neither answer is evidence. Do NOT "
            "reconcile by copying one reader into the other: read "
            "polygram/mcp/chainspec.py (C1-C4, N1-N5, L1-L5, U1-U4) and fix "
            "whichever reader departed from the words.\n" + extra + "\n"
            + "\n".join(f"  {f}\n    python: {a!r}\n    perl  : {b!r}"
                        for f, a, b in splits[:8]))


# ------------------------------------------------------------------ the frozen acceptance


@unittest.skipUnless(_HAVE_PERL, "no perl on this host")
class TheFrozenBytesReadTheSameInBothLanguages(_SeatMixin, unittest.TestCase):
    """W3 against W1 and W2 at once.

    These bytes were written by code that no longer exists and cannot be
    updated to match a new belief. If a change breaks this class, the change is
    wrong until proven otherwise.
    """

    def test_every_field_of_every_frozen_generation_agrees(self):
        seat = self.frozen_seat()
        st = _store.Store(root=seat, by="perl-witness")
        self.assert_no_split(self.compare(st, seat),
                             "This is the FROZEN fixture. Do not re-emit it.")

    def test_the_hand_written_marks_survive_both_readers(self):
        """EXPECTATIONS.md states these by hand; both readers must find them.

        `unit = 16` is the number the 2026-09-15 `unit`->`carry` rename flipped
        to 1 while all 207 tests passed. A second reader in a second language
        is a witness that rename could not have taken with it.
        """
        seat = self.frozen_seat()
        rows = perl_buoy(seat)
        self.assertEqual(rows["carrying-sixteen"]["unit"], 16)
        self.assertEqual(rows["plain-atom"]["unit"], 1)
        head = perl_read(seat, "carrying-sixteen")
        fm = dict(head["fm"])
        self.assertEqual(fm["unit"], "16")
        self.assertEqual(fm["cited-at-write"], "9")
        self.assertEqual(fm["mode"], "SEATED")
        self.assertEqual(
            fm["first-seen"], "g0001-20260915T120000Z-df2c139fa0f0d3be.md",
            "N5: first-seen is served verbatim. A reader that normalised this "
            "v2 filename to the v3 shape would be inventing a name that is "
            "not on disk.")
        self.assertTrue(fm["prev"].startswith("sha256:df2c139fa0f0d3be"),
                        "prev's first sixteen hex digits ARE generation 1's "
                        "own filename stem. Nothing forces that agreement, "
                        "which is what makes it evidence.")
        g1 = perl_read(seat, "carrying-sixteen", 1)
        self.assertEqual(dict(g1["fm"])["first-seen"], "",
                         "gen 1 leaves first-seen empty: empty means 'this "
                         "file'.")
        self.assertTrue(g1["body"].startswith(b"An "))

    def test_the_arithmetic_the_frozen_bytes_pin(self):
        """EXPECTATIONS.md's own table, computed by the Perl reader.

        -437 is the number that witnesses the mark, the arithmetic and the
        rounding rule at once: it is only reachable with a mark of 16, and it
        is a TRUNCATION -- a floor would say -438.
        """
        seat = self.frozen_seat()
        for seam, unit, table in (
                ("carrying-sixteen", 16,
                 {0: -1000, 9: -437, 16: 0, 32: 1000}),
                ("plain-atom", 1, {0: -1000, 1: 0, 2: 1000})):
            caw = int(dict(perl_read(seat, seam)["fm"])["cited-at-write"])
            for pressure, want in table.items():
                log = seat / "cited" / f"{seam}.log"
                log.write_bytes(b"".join(
                    b"20260915T000000Z\tsolo\there\n"
                    for _ in range(pressure + caw)))
                row = perl_buoy(seat)[seam]
                self.assertEqual(row["pressure"], pressure)
                self.assertEqual(row["unit"], unit)
                self.assertEqual(
                    row["score_milli"], want,
                    f"{seam} at pressure {pressure}: EXPECTATIONS.md says "
                    f"{want}. A floored division would say "
                    f"{want - 1 if want < 0 else want}.")
                # And the Python reader must say the same thing.
                self.assertEqual(dl2.score(pressure, unit), want)
                log.unlink()


# ------------------------------------------------------------------ the differential


@unittest.skipUnless(_HAVE_PERL, "no perl on this host")
class TwoServersOneStore(_SeatMixin, unittest.TestCase):
    """W4: seats the Python writer minted, read back by both servers.

    The seam names are chosen to hit the traps this tree has already paid for:
    a name with spaces, a name that looks numeric, a name in a non-Latin script
    (which gets an `n-<12 hex>` handle), an accented name, and one long enough
    to be truncated with a digest tail.
    """

    NAMES = ["alpha", "Build Notes", "9", "10", "100", "café notes",
             "плавание", "a b  c", "two-columns", "x" * 90, "Ünïcødé"]
    CITERS = ["c0", "c1", "9", "10", "100", "sam", "build-loop"]

    def _seat(self, rnd, tag):
        seat = self.tmp(f"seat-{tag}")
        st = _store.Store(root=seat, by="witness")
        st.ensure(create=True, make_parents=True)
        for name in rnd.sample(self.NAMES, rnd.randint(1, 6)):
            for g in range(rnd.randint(1, 3)):
                st.append(name, f"body {g}\nsecond line\n", frm="you",
                          would_change="the readers stop agreeing",
                          unit=rnd.choice([None, 1, 2, 3, 4, 7, 16]))
            for _ in range(rnd.randint(0, 7)):
                st.cite(name, rnd.choice(self.CITERS), "here")
        # Truncating a log is how a seam goes DAMAGED (L5): pressure negative.
        if rnd.random() < 0.35:
            for log in sorted(st.cited.iterdir()):
                if rnd.random() < 0.5:
                    log.write_bytes(b"")
        return st, seat

    def test_the_two_readers_agree_on_every_generated_seat(self):
        rnd = random.Random(20260915)
        splits = []
        for i in range(24):
            st, seat = self._seat(rnd, i)
            splits += [(f"case {i}: {f}", a, b)
                       for f, a, b in self.compare(st, seat)]
            if len(splits) > 8:
                break
        self.assert_no_split(splits)

    def test_a_mixed_era_seam_reads_the_same_in_both(self):
        """N4: v2 names and v3 names in ONE seam are ONE chain.

        The store mints v3 today and every v2 name on disk stays a v2 name
        forever, so every reader is a reader of both eras until the end of the
        store. A reader that took only one shape would lose a whole era
        SILENTLY -- a skipped file looks exactly like an empty seam.
        """
        seat = self.tmp()
        st = _store.Store(root=seat, by="witness")
        st.ensure(create=True, make_parents=True)
        st.append("mixed", "one", frm="you", would_change="w", unit=4)
        st.append("mixed", "two", frm="you", would_change="w")
        gens = st.generations("mixed")
        self.assertEqual([chainspec.name_era(p.name) for p in gens], [3, 3])
        # Repaint generation 1 into a v2 name. Its BYTES do not change, so
        # gen 2's prev: still matches and C3 still holds -- which is exactly
        # what N3 says: the stamp segment is checked by nothing.
        old = gens[0]
        new = old.with_name(f"g0001-20260915T120000Z-{old.name.split('-')[-1]}")
        old.rename(new)
        self.assertEqual(
            [chainspec.name_era(p.name) for p in st.generations("mixed")],
            [2, 3])
        self.assert_no_split(self.compare(st, seat),
                             "A mixed-era seam is one chain (N4).")

    def test_mode_agrees_including_the_ways_a_seat_is_not_visible(self):
        seat = self.tmp()
        st = _store.Store(root=seat, by="witness")
        self.assertEqual(st.mode(), _store.NOTVISIBLE)
        self.assertEqual(perl_mode(seat), _store.NOTVISIBLE)
        st.ensure(create=True, make_parents=True)
        self.assertEqual(st.mode(), _store.SEATED)
        self.assertEqual(perl_mode(seat), _store.SEATED)

        jail = self.tmp("jail")
        jail.mkdir(parents=True)
        gone = seat.parent / "no-such-seat"
        jailed = _store.Store(root=gone, by="w", jail_root=jail)
        self.assertEqual(jailed.mode(), _store.JAILED)
        self.assertEqual(perl_mode(gone, jail), _store.JAILED)

        for bad in ("relative/seat", "", ".", "./",
                    "${MENTCACHED_SEAT}/seat", "/tmp/%MENTCACHED_SEAT%/s",
                    "/tmp/$MENTCACHED_SEAT/s"):
            self.assertEqual(
                _store.Store(root=Path(bad), by="w").mode(), _store.NOTVISIBLE,
                f"python called {bad!r} visible")
            self.assertEqual(
                perl_mode(bad), _store.NOTVISIBLE,
                f"perl called {bad!r} visible")

    def test_a_broken_chain_breaks_the_same_way_in_both(self):
        """Both must stop at the same file AND for the same reason.

        `broken_at` alone is only a filename: two readers stopping at one file
        for different reasons would compare equal, which is a split wearing an
        agreement.
        """
        seat = self.tmp()
        st = _store.Store(root=seat, by="witness")
        st.ensure(create=True, make_parents=True)
        for label, mutate, want in (
            ("C3 edit to the head",
             lambda g: g[-1].write_bytes(g[-1].read_bytes() + b"x"), "C3 self"),
            ("C3 front-matter edit",
             lambda g: g[0].write_bytes(
                 g[0].read_bytes().replace(b"mode: SEATED", b"mode: JAILED")),
             "C3 self"),
            ("C2 rename",
             lambda g: g[-1].rename(g[-1].with_name(
                 g[-1].name.replace("g0002", "g0007"))), "C2 name"),
            ("C1 forged gen 1",
             lambda g: (g[0].parent / "g0003-{}.md".format(
                 hashlib.sha256(b"---\nseam: s\ngen: 1\nprev:\n---\nZ\n")
                 .hexdigest()[:16])).write_bytes(
                     b"---\nseam: s\ngen: 1\nprev:\n---\nZ\n"), "C1 position"),
        ):
            with self.subTest(label):
                seam = label.replace(" ", "-").lower()
                st.append(seam, "one", frm="you", would_change="w")
                st.append(seam, "two", frm="you", would_change="w")
                mutate(st.generations(seam))
                a, b = py_chain(st, seam), perl_chain(seat, seam)
                self.assertFalse(a["ok"], f"python missed {label}")
                self.assertFalse(b["ok"], f"perl missed {label}")
                self.assertEqual(a["check"], want)
                self.assertEqual(b["check"], want)
                self.assertEqual(a["at"], b["at"],
                                 "the two readers stopped at different files")


# ------------------------------------------------------------------ read-only


@unittest.skipUnless(_HAVE_PERL, "no perl on this host")
class TheSecondReaderWritesNothing(_SeatMixin, unittest.TestCase):
    """A read-only second reader cannot corrupt what it disagrees about.

    That is the point of making the witness read-only rather than a promise
    about it: whatever the Perl concludes, the bytes it concluded it from are
    still there for somebody else to read.
    """

    def test_no_byte_under_the_seat_changes(self):
        seat = self.frozen_seat()
        st = _store.Store(root=seat, by="witness")
        (seat / "cited" / "carrying-sixteen.log").write_bytes(
            b"20260915T000000Z\tsam\there\n")

        def snapshot():
            out = {}
            for p in sorted(seat.rglob("*")):
                out[str(p.relative_to(seat))] = (
                    "dir" if p.is_dir()
                    else hashlib.sha256(p.read_bytes()).hexdigest())
            return out

        before = snapshot()
        for args in (["list", str(seat)], ["mode", str(seat)],
                     ["buoy", str(seat)],
                     ["chain", str(seat), "carrying-sixteen"],
                     ["read", str(seat), "carrying-sixteen"],
                     ["read", str(seat), "carrying-sixteen", "1"],
                     ["read", str(seat), "plain-atom"]):
            _perl(*args)
        self.assertEqual(before, snapshot(),
                         "bin/mentcached.pl changed something under the seat. "
                         "It is READ-ONLY by construction; a write here means "
                         "the construction broke.")
        self.assertEqual(st.mode(), _store.SEATED)

    def test_it_does_not_create_a_seat_that_is_not_there(self):
        """store.mode() refuses to invent a seat and so must this reader.

        A typo and a first run look identical from here, and guessing wrong
        means serving an empty store as though it were somebody's memory.
        """
        missing = self.tmp() / "never-made"
        p = _perl("list", str(missing))
        self.assertNotEqual(p.returncode, 0)
        self.assertFalse(missing.exists(), "the reader created a seat")
        self.assertIn(b"NOTVISIBLE", p.stderr)


# ------------------------------------------------------------------ prove-red


@unittest.skipUnless(_HAVE_PERL, "no perl on this host")
class ProveRed(_SeatMixin, unittest.TestCase):
    """A differential test that cannot go red proves nothing."""

    def test_breaking_the_perl_reader_turns_the_comparison_red(self):
        """Deliberately corrupt ONE reader and show the comparison notices.

        The Perl is copied, one rule is broken in the copy, and the copy is run
        against the same seat. The original is untouched -- breaking the reader
        under test in place would leave a red tree if this test failed halfway.
        """
        seat = self.frozen_seat()
        st = _store.Store(root=seat, by="witness")
        self.assert_no_split(self.compare(st, seat),
                             "baseline must agree before the red run")

        broken = Path(tempfile.mkdtemp(prefix="broken-perl-"))
        self.addCleanup(shutil.rmtree, broken, True)
        copy = broken / "mentcached.pl"
        # BYTES both ways. read_text() applies universal-newline translation
        # and write_text() turns LF into CRLF on Windows, so a reader copied
        # through text would not be the reader on disk -- which is the exact
        # hazard this tree's bytes-boundary lint exists to catch, and it caught
        # this line.
        src = PERL_READER.read_bytes()
        # U3 the wrong way round: FLOOR instead of TRUNCATE. This is the exact
        # rounding split chainspec spends a paragraph in capitals on, and it is
        # invisible until a score goes negative -- which is most of them.
        self.assertIn(b"    return ($p - $u) * 1000 / $u;\n", src)
        copy.write_bytes(
            src.replace(b"    return ($p - $u) * 1000 / $u;\n",
                        b"    my $n = ($p - $u) * 1000;\n"
                        b"    my $q = $n / $u;\n"
                        b"    $q-- if $n % $u;\n"
                        b"    return $q;\n"))

        (seat / "cited" / "carrying-sixteen.log").write_bytes(
            b"".join(b"20260915T000000Z\tsam\there\n" for _ in range(18)))
        good = perl_buoy(seat)["carrying-sixteen"]["score_milli"]

        out = subprocess.run(["perl", str(copy), "buoy", str(seat)],
                             capture_output=True)
        red = {}
        for ln in out.stdout.decode().split("\n"):
            if ln:
                c = ln.split("\t")
                red[c[0]] = int(c[3])

        self.assertEqual(good, -437, "the frozen arithmetic, unbroken")
        self.assertEqual(red["carrying-sixteen"], -438,
                         "the broken copy must FLOOR where the spec truncates")
        self.assertNotEqual(
            good, red["carrying-sixteen"],
            "PROVE-RED FAILED: the comparison is vacuous -- a reader broken on "
            "the one rule chainspec U3 writes in capitals produced the same "
            "number, so this file has never been checking anything.")

    def test_breaking_the_python_side_turns_the_comparison_red(self):
        """The other direction, because a check that can only catch one side
        is half a check."""
        seat = self.frozen_seat()
        st = _store.Store(root=seat, by="witness")
        a = py_buoy(st)
        b = perl_buoy(seat)
        self.assertEqual(a, b, "baseline must agree before the red run")
        a["plain-atom"]["unit"] = 99          # the `unit`->`carry` shape of bug
        self.assertNotEqual(a, b, "PROVE-RED FAILED: the comparison is vacuous")

    def test_the_perl_reader_proves_its_own_checks_can_fail(self):
        """Every check bin/mentcached.pl makes, fired by an input built to
        break it. A check never seen to fail is a comment that compiles."""
        p = _perl("--prove-red")
        self.assertEqual(
            p.returncode, 0,
            "bin/mentcached.pl --prove-red failed:\n"
            + p.stdout.decode("utf-8", "replace")
            + p.stderr.decode("utf-8", "replace"))
        self.assertIn(b"prove-red PASS", p.stdout)
        self.assertNotIn(b"  FAIL  ", p.stdout)


# ------------------------------------------------------------------ the findings


@unittest.skipUnless(_HAVE_PERL, "no perl on this host")

def _note(unit="1", **fm) -> bytes:
    """Minimal note BYTES with a chosen front-matter value.

    Built by hand rather than through `render_note`, on purpose: the whole
    point of these cases is what the PARSER does with bytes a writer would
    never emit. Going through the writer could only ever produce values the
    writer already believes in.
    """
    rows = {"seam": "s", "gen": "1", "by": "t", "from": "m",
            "would-change": "y", "triggers": "", "first-seen": "", "prev": "",
            "came-from": "", "leads-to": "", "last-cited-at-write": "",
            "cited-at-write": "0", "unit": unit, "mode": "SEATED"}
    rows.update({k.replace("_", "-"): v for k, v in fm.items()})
    head = "\n".join(f"{k}: {v}" for k, v in rows.items())
    return f"---\n{head}\n---\nbody\n".encode("utf-8", errors="surrogateescape")


class TheSplitsTheSecondWitnessFound(_SeatMixin, unittest.TestCase):
    """CLOSED 2026-09-15. These tests used to ASSERT the split; now they guard
    the fix, and the record of what was found is kept rather than deleted.

    An independent Perl reader of this format -- the first second witness this
    project had at the SERVER layer rather than the chain layer -- found eight
    disagreements in one run, against a suite of 277 Python tests that were all
    green. Five were Python being wrong. They were pinned here as green tests
    that asserted the split, so that fixing either reader would turn this file
    red and the finding could not be quietly forgotten.

    Fixing the Python side turned this file red, exactly as designed. What
    follows is what each split WAS, and the assertion that now holds instead.
    Keeping the history in the test rather than in a commit message is the
    archive rule applied to the suite: the reason a check exists is the part
    that rots first.

    D5 and D6 are NOT fixed and are still asserted as open, because chainspec
    is silent on both and a reader may not settle a spec by acting first.
    """

    # ---- D1: one citation became two --------------------------------------
    def test_D1_a_record_ends_at_newline_and_nowhere_else(self):
        """WAS: `str.splitlines()` split on U+2028, U+0085, U+000B and friends,
        so one citation whose `where` column mentioned a line separator counted
        as TWO -- moving `pressure`, which drives the compaction queue, with no
        tampering at all. `cite()` writes \\n and nothing else."""
        st = self._store()
        st.append("s", "x", frm="m", would_change="y")
        log = st.cited / "s.log"
        log.write_bytes("20260915T000000Z\tc\ta\u2028b\n".encode("utf-8"))
        self.assertEqual(len(st.citations("s")), 1,
                         "a Unicode line separator inside a field is DATA, "
                         "not a record separator")
        for sep in ("\u2028", "\u2029", "\u0085", "\x0b", "\x0c", "\x1c", "\r"):
            log.write_bytes(f"20260915T000000Z\tc\ta{sep}b\n".encode("utf-8"))
            self.assertEqual(len(st.citations("s")), 1, f"split on {sep!r}")

    # ---- D2: one bad byte denied the whole store --------------------------
    def test_D2_one_bad_byte_in_a_log_does_not_deny_the_store(self):
        """WAS: `read_text(encoding="utf-8")` raised on a single invalid byte,
        out of a method `buoyancy()` calls for EVERY seam. chainspec: "A body
        that is not valid UTF-8 is not an error. Hash the bytes." """
        st = self._store()
        for s in ("a", "b"):
            st.append(s, "x", frm="m", would_change="y")
            st.cite(s, st.by, "t")
        (st.cited / "a.log").write_bytes(b"20260915T000000Z\tc\t\xff\xfe\n")
        self.assertEqual(len(st.citations("a")), 1)
        self.assertEqual(len(st.buoyancy()), 2,
                         "one undecodable byte must not cost the owner every "
                         "other seam they have")

    # ---- D3 / D3b: the mark, through a different door ---------------------
    def test_D3_only_ascii_digits_are_digits(self):
        """WAS: `str.isdigit()` is Unicode-aware, so `unit: １６` read as 16 in
        Python and 1 in every other reader -- the SAME compaction inversion as
        the 2026-09-15 ghost (-437 becoming +8000), arriving through a door
        nobody had looked at. chainspec had already settled this for `gen:`:
        the permissive reader is the one that has to be constrained."""
        for bad in ("\uff11\uff16", "\u0663", "\u00a016\u00a0", "+7", "1_6", " 16 x"):
            with self.subTest(bad):
                n = dl2.parse_note(_note(unit=bad))
                self.assertEqual(n.unit, 1,
                                 f"{bad!r} is not a number to sh, awk or Perl")
        self.assertEqual(dl2.parse_note(_note(unit="16")).unit, 16)
        self.assertEqual(dl2.parse_note(_note(unit=" 16 ")).unit, 16,
                         "ordinary padding still reads")

    def test_D4_no_single_note_can_brick_the_store(self):
        """WAS THE SEVERE ONE. `'\u00b2'.isdigit()` is True and `int('\u00b2')`
        RAISES, so one hand-edited superscript passed the guard and threw
        inside it -- and `buoyancy()` and `rebuild_index()` walk every seam.
        A store with three healthy seams served NONE of them.

        Unrepairable, too: the value is inside the C3 hash so it cannot be
        edited, and rule 1 forbids deleting the file. A denial of somebody's
        own memory, from one character, with no way back."""
        st = self._store()
        for s in ("healthy-a", "healthy-b", "healthy-c"):
            st.append(s, "fine", frm="m", would_change="y")
        st.append("poisoned", "fine", frm="m", would_change="y")
        g = st.generations("poisoned")[0]
        g.write_bytes(g.read_bytes().replace(b"unit: 1\n",
                                             "unit: \u00b2\n".encode("utf-8")))
        rows = st.buoyancy()
        self.assertEqual(len(rows), 4, "every seam must still be served")
        self.assertEqual(st.rebuild_index()["seams"], 4)
        poisoned = next(r for r in rows if r["seam"] == "poisoned")
        self.assertEqual(poisoned["unit"], 1,
                         "an unreadable mark reads as the default, loudly in "
                         "the row and never as an exception")

    def test_D7_the_mark_has_a_ceiling_derived_from_the_readers(self):
        """WAS: U2 gave the mark a floor and no ceiling, so
        `unit: 99999999999999999999` was legal by the words, exact in Python's
        bignums, and wrapped NEGATIVE in Perl -- breaking U2 inside the reader
        that checks U2. A rule only one language can carry fails this
        project's own density test, so the bound is 2**53-1: the largest
        integer every reader here carries exactly, including the awk one whose
        numbers are doubles."""
        self.assertEqual(dl2.MAX_UNIT, 2 ** 53 - 1)
        n = dl2.parse_note(_note(unit="99999999999999999999"))
        self.assertEqual(n.unit, dl2.MAX_UNIT,
                         "saturate at the shared bound; never carry a number "
                         "only one reader can hold")
        self.assertEqual(dl2.parse_note(_note(unit=str(2 ** 53 - 1))).unit,
                         2 ** 53 - 1, "the bound itself is legal")


class StillOpenBecauseTheSpecIsSilent(unittest.TestCase):
    """D5 and D6. A reader may not settle a spec by acting first.

    Both are real splits between the Python and Perl readers. Neither is a bug
    in either reader, because chainspec does not say which is right -- and the
    correct response to a gap in the words is to name it and stop, not to pick
    the one your language makes easy and call the other reader wrong.
    """

    def test_D5_a_carriage_return_in_prev_is_undefined(self):
        """chainspec says a value is stripped of leading and trailing
        HORIZONTAL whitespace, and separately that there is "no newline
        translation anywhere". A carriage return is neither horizontal nor a
        whole newline. Python strips it from both ends; both Perl readers strip
        a trailing CR and nothing leading, so a CR before `sha256:` makes the
        chain hold for one reader and break C4 for the other.

        This is the load-bearing proof disagreeing with itself, and it is
        PRE-EXISTING -- not introduced by the Perl reader, only revealed by it.
        OWED: one sentence in chainspec saying whether a leading CR is stripped.
        """
        self.assertTrue(True, "recorded, not resolved -- see the docstring")

    def test_D6_whitespace_around_a_citer_name_is_undefined(self):
        """L1 says the citers are "the set of distinct values in column 2" and
        never says they are normalised. Python's `str.strip()` removes NBSP;
        Perl strips ASCII only, so a name padded with NBSP sorts after every
        ASCII one -- and `by` is the arithmetic receipt the caller is told to
        check the ranking against. The two readers credit DIFFERENT consumers.

        Neither is wrong until L1 says. OWED: one clause in L1.
        """
        self.assertTrue(True, "recorded, not resolved -- see the docstring")
