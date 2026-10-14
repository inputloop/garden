#!/usr/bin/env python3
"""Tests for ferry - stdlib unittest. Run: python3 -m unittest test_ferry -v"""
import os
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import ferry  # noqa: E402
import ferry_core as fc  # noqa: E402


def _seat(d, name, data):
    p = os.path.join(d, name)
    with open(p, "wb") as fh:
        fh.write(data if isinstance(data, bytes) else data.encode())
    return p


class TestRoundTrip(unittest.TestCase):
    def test_local_roundtrip_verifies_by_hash(self):
        with tempfile.TemporaryDirectory() as d:
            seat = _seat(d, "note.md", "a copy, never the only copy\n")
            man = os.path.join(d, "m.tsv")
            rec = os.path.join(d, "receipts.log")
            be = ferry.LocalBackend(os.path.join(d, "store"))
            res = ferry.roundtrip(be, [seat], man, rec)
            self.assertEqual(res, [("note.md", True)])
            # manifest row is verified and carries the seat sha (provenance)
            rows = ferry.status(man)
            self.assertEqual(rows[0]["status"], "verified")
            self.assertEqual(rows[0]["sha256"], fc.sha256_file(seat))
            # a verify receipt landed
            with open(rec, encoding="utf-8") as fh:
                self.assertIn("verify\tOK", fh.read())

    def test_graceful_degradation_second_mirror(self):
        # Drive gone? a LocalBackend on another root is still a real 2nd copy.
        with tempfile.TemporaryDirectory() as d:
            seat = _seat(d, "n.md", "durable in its own right\n")
            man = os.path.join(d, "m.tsv")
            rec = os.path.join(d, "r.log")
            mirror = ferry.make_backend("local:" + os.path.join(d, "mirror"))
            res = ferry.roundtrip(mirror, [seat], man, rec)
            self.assertTrue(all(ok for _, ok in res))


class TestIdempotence(unittest.TestCase):
    def test_restage_unchanged_does_not_grow(self):
        with tempfile.TemporaryDirectory() as d:
            seat = _seat(d, "x.md", "grow != trust\n")
            man = os.path.join(d, "m.tsv")
            rec = os.path.join(d, "r.log")
            ferry.stage([seat], man, rec)
            ferry.stage([seat], man, rec)  # same bytes again
            rows = ferry.status(man)
            self.assertEqual(len(rows), 1)          # no duplicate slot
            self.assertEqual(rows[0]["status"], "unchanged")
            # but receipts kept both events (append-only history)
            with open(rec, encoding="utf-8") as fh:
                self.assertEqual(fh.read().count("stage\tOK"), 2)

    def test_changed_bytes_replace_row_new_sha(self):
        with tempfile.TemporaryDirectory() as d:
            seat = _seat(d, "x.md", "v1\n")
            man = os.path.join(d, "m.tsv")
            rec = os.path.join(d, "r.log")
            ferry.stage([seat], man, rec)
            first = ferry.status(man)[0]["sha256"]
            _seat(d, "x.md", "v2 changed\n")
            ferry.stage([seat], man, rec)
            rows = ferry.status(man)
            self.assertEqual(len(rows), 1)
            self.assertNotEqual(rows[0]["sha256"], first)
            self.assertEqual(rows[0]["status"], "staged")

    def test_verify_picks_staged_row_when_id_repeats(self):
        # 2026-09-06 regression: the seat mounts under a new sandbox name each
        # session, so a re-stage lands a SECOND row with the same id and a
        # different seat_path. verify() must read the staged row, not the first.
        with tempfile.TemporaryDirectory() as d:
            a = _seat(os.path.join(d, "old") if os.mkdir(os.path.join(d, "old")) is None else d, "c.md", "v001\n")
            os.mkdir(os.path.join(d, "new"))
            b = _seat(os.path.join(d, "new"), "c.md", "v002 grown\n")
            man = os.path.join(d, "m.tsv")
            rec = os.path.join(d, "r.log")
            ferry.stage([a], man, rec)
            self.assertTrue(ferry.verify("c.md", a, man, rec, ref="old-ref"))
            ferry.stage([b], man, rec)
            rows = ferry.status(man)
            self.assertEqual([r["status"] for r in rows], ["verified", "staged"])
            self.assertTrue(ferry.verify("c.md", b, man, rec, ref="new-ref"))
            rows = ferry.status(man)
            self.assertEqual([r["status"] for r in rows], ["verified", "verified"])
            self.assertEqual(rows[1]["ref"], "new-ref")
            self.assertEqual(rows[0]["ref"], "old-ref")   # v001 row untouched


class TestBoundaries(unittest.TestCase):
    def test_tamper_is_caught(self):
        with tempfile.TemporaryDirectory() as d:
            seat = _seat(d, "n.md", "receipts prove integrity not trust\n")
            man = os.path.join(d, "m.tsv")
            rec = os.path.join(d, "r.log")
            ferry.stage([seat], man, rec)
            # a corrupted 'fetched-back' copy must fail verify
            bad = os.path.join(d, "bad")
            with open(bad, "wb") as fh:
                fh.write(b"tampered\n")
            self.assertFalse(ferry.verify("n.md", bad, man, rec))
            self.assertEqual(ferry.status(man)[0]["status"], "MISMATCH")

    def test_drive_backend_refuses_to_self_drive(self):
        be = ferry.make_backend("drive:ComputerPeople")
        with self.assertRaises(NotImplementedError):
            be.put("x", b"y")


if __name__ == "__main__":
    unittest.main()
