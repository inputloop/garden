#!/usr/bin/env python3
"""Tests for ferry_core - stdlib unittest, no deps. Run: python3 -m unittest -v"""
import os
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import ferry_core as fc  # noqa: E402


class TestIdentity(unittest.TestCase):
    def test_bytes_matches_known_vector(self):
        # sha256("") is the canonical empty-string digest
        self.assertEqual(
            fc.sha256_bytes(b""),
            "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
        )

    def test_file_equals_bytes(self):
        with tempfile.TemporaryDirectory() as d:
            p = os.path.join(d, "x")
            data = b"grow from durables, pulled to current deltas\n"
            with open(p, "wb") as fh:
                fh.write(data)
            self.assertEqual(fc.sha256_file(p), fc.sha256_bytes(data))


class TestReceipts(unittest.TestCase):
    def test_line_shape_matches_wordwise(self):
        line = fc.receipt_line(
            "pull", "OK",
            {"src": "/a", "dest": "/b", "sha": "0" * 64},
            ts="2026-09-01T22:45:57Z",
        )
        cols = line.split("\t")
        self.assertEqual(cols[0], "2026-09-01T22:45:57Z")
        self.assertEqual(cols[1], "pull")
        self.assertEqual(cols[2], "OK")
        self.assertEqual(cols[3], "src=/a")
        self.assertEqual(cols[4], "dest=/b")
        self.assertEqual(cols[5], "sha=" + "0" * 64)
        self.assertEqual(cols[6], "landed")

    def test_append_creates_and_grows(self):
        with tempfile.TemporaryDirectory() as d:
            log = os.path.join(d, "sub", "receipts.log")
            fc.append_receipt(log, "stage", "OK", {"sha": "a" * 64})
            fc.append_receipt(log, "verify", "OK", {"sha": "a" * 64})
            with open(log, encoding="utf-8") as fh:
                lines = [ln for ln in fh.read().splitlines() if ln]
            self.assertEqual(len(lines), 2)
            self.assertTrue(lines[0].endswith("landed"))


class TestManifestRoundTrip(unittest.TestCase):
    def test_write_read_identity(self):
        header = ["id", "path", "sha256", "bytes"]
        rows = [
            {"id": "n1", "path": "/seat/a.md", "sha256": "1" * 64, "bytes": "10"},
            {"id": "n2", "path": "/seat/b.md", "sha256": "2" * 64, "bytes": "20"},
        ]
        with tempfile.TemporaryDirectory() as d:
            p = os.path.join(d, "m.tsv")
            fc.write_tsv(p, header, rows)
            h2, r2 = fc.read_tsv(p)
            # prove-a-promise: data in == data out after there-and-back
            self.assertEqual(h2, header)  # leading '# ' stripped on read
            self.assertEqual(r2, rows)

    def test_upsert_is_idempotent_on_identity(self):
        rows = []
        rec = {"id": "n1", "sha256": "1" * 64}
        self.assertEqual(fc.upsert(rows, "sha256", rec), "insert")
        # same identity again -> replace, ledger does not grow
        self.assertEqual(fc.upsert(rows, "sha256", dict(rec)), "replace")
        self.assertEqual(len(rows), 1)
        # different identity -> insert
        self.assertEqual(fc.upsert(rows, "sha256", {"id": "n2", "sha256": "2" * 64}),
                         "insert")
        self.assertEqual(len(rows), 2)


if __name__ == "__main__":
    unittest.main()
