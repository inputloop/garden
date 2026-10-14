#!/usr/bin/env python3
"""ferry - a backend-agnostic offsite copier that proves the round-trip by hash.

Task B: wire Google Drive (ComputerPeople/) as a durable *second* FS for the seat.
The seat (Avalon) is canonical-current; Drive is a copy, never the only copy, and
the second source for the trust check (making-vibrobeast .md, section 4).

Honest architecture (the load-bearing constraint):
  The Google Drive MCP is called by the AGENT, not by this script - a sandbox has
  no route to your Drive. So this tool proves IDENTITY and manages the manifest +
  receipts; the agent carries the bytes across the MCP boundary (exactly like
  wwtrack's via-C4 pull: the tool proves, the human/agent moves). A LocalBackend
  simulates the full seat -> store -> back round-trip so tests are green without
  ever touching Drive; Drive is just one backend, and the store DEGRADES to a
  local mirror if Drive vanishes (durable in its own right, person-first).

prove-a-promise here:
  universal  : bytes fetched back from the store hash-equal the bytes staged.
  specific   : idempotence - re-staging unchanged bytes never grows the manifest;
               and the manifest row carries the seat sha256 (provenance = the
               second source for the trust check).

Guards: nothing third-party / family / secret / credential is ever ferried; the
caller chooses the seat paths and this tool never reaches outside them.

stdlib only. Canon governs; SAVANNAH source of truth. Minted, not vouched.
"""
from __future__ import annotations

import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import ferry_core as fc  # noqa: E402

MANIFEST_HEADER = ["seat_path", "id", "sha256", "bytes", "store", "ref",
                   "status", "ts"]


# --- backends -------------------------------------------------------------

class LocalBackend:
    """A directory that stands in for the offsite store.

    IS the graceful-degradation mirror: if Drive is gone, a LocalBackend on
    another disk is still a real, durable second copy. ref == stored filename.
    """

    scheme = "local"

    def __init__(self, root: str):
        self.root = root
        os.makedirs(root, exist_ok=True)

    def put(self, name: str, data: bytes) -> str:
        dest = os.path.join(self.root, name)
        os.makedirs(os.path.dirname(os.path.abspath(dest)) or ".", exist_ok=True)
        with open(dest, "wb") as fh:
            fh.write(data)
        return name

    def get(self, ref: str) -> bytes:
        with open(os.path.join(self.root, ref), "rb") as fh:
            return fh.read()

    def list(self):
        out = {}
        for dirpath, _dirs, files in os.walk(self.root):
            for f in files:
                full = os.path.join(dirpath, f)
                out[os.path.relpath(full, self.root)] = os.path.relpath(full, self.root)
        return out


class DriveBackend:
    """Placeholder for the Google Drive (ComputerPeople/) store.

    Intentionally NOT wired to call the MCP: a sandbox script cannot reach Drive,
    and pushing files to the keeper's cloud is a consent boundary. The agent runs
    the Drive leg via the MCP under a run-card, then calls `verify` with the copy
    it fetched back. This class exists to name the boundary, not to cross it.
    """

    scheme = "drive"

    def __init__(self, folder: str = "ComputerPeople"):
        self.folder = folder

    def _refuse(self, *_a, **_k):
        raise NotImplementedError(
            "DriveBackend does not self-drive the MCP. Stage with this tool, then "
            "let the agent carry bytes via the Drive MCP under a run-card, and "
            "verify the fetched-back copy by hash. See RUNCARD-ferry-drive.md.")

    put = get = list = _refuse


def make_backend(spec: str):
    """'local:/path' -> LocalBackend; 'drive:ComputerPeople' -> DriveBackend."""
    if ":" in spec:
        scheme, rest = spec.split(":", 1)
    else:
        scheme, rest = "local", spec
    if scheme == "local":
        return LocalBackend(rest)
    if scheme == "drive":
        return DriveBackend(rest or "ComputerPeople")
    raise ValueError("unknown backend scheme: %s" % scheme)


# --- operations -----------------------------------------------------------

def _load(manifest):
    header, rows = fc.read_tsv(manifest)
    return rows if header else []


def stage(seat_paths, manifest, receipts, store="drive:ComputerPeople",
          base=None):
    """Record each seat file's identity into the manifest; return the rows.

    Idempotent on identity: re-staging unchanged bytes replaces the row in place
    (same sha, no growth). A changed file replaces the row with the new sha; the
    old sha is preserved in the append-only receipts.log (losses kept).
    """
    rows = _load(manifest)
    staged = []
    for p in seat_paths:
        p = os.path.abspath(p)
        sha = fc.sha256_file(p)
        size = os.path.getsize(p)
        ident = os.path.relpath(p, base) if base else os.path.basename(p)
        prior = next((r for r in rows if r.get("seat_path") == p), None)
        rec = {
            "seat_path": p, "id": ident, "sha256": sha, "bytes": str(size),
            "store": store,
            "ref": (prior or {}).get("ref", ""),
            "status": "unchanged" if prior and prior.get("sha256") == sha
                      else "staged",
            "ts": fc.now_iso(),
        }
        action = fc.upsert(rows, "seat_path", rec)
        fc.append_receipt(receipts, "stage", "OK",
                          {"src": p, "sha": sha, "id": ident,
                           "action": action, "state": rec["status"]},
                          tail="staged")
        staged.append(rec)
    fc.write_tsv(manifest, MANIFEST_HEADER, rows)
    return staged


def verify(ident, returned_file, manifest, receipts, ref=None):
    """Assert a copy fetched back from the store hash-equals what was staged.

    `ident` matches the manifest 'id' (or 'seat_path'); `returned_file` is the
    local path the agent saved the store's copy to. Returns True on match.
    """
    rows = _load(manifest)
    hits = [r for r in rows if r.get("id") == ident or r.get("seat_path") == ident]
    # 2026-09-06 fix: a re-stage of the same id inserts a second row; verify must
    # pick the PENDING (staged) row, else the newest — never the first (v001) row.
    # Before this fix the v002 carry was mis-read against v001's hash (receipt
    # 2026-09-06T08:21:08Z FAIL is that misfire, kept, not erased).
    staged = [r for r in hits if r.get("status") == "staged"]
    row = (staged or hits or [None])[-1]
    if row is None:
        raise KeyError("no manifest row for id/seat_path %r" % ident)
    got = fc.sha256_file(returned_file)
    ok = (got == row["sha256"])
    if ok:
        row["status"] = "verified"
        if ref:
            row["ref"] = ref
    else:
        row["status"] = "MISMATCH"
    fc.write_tsv(manifest, MANIFEST_HEADER, rows)
    fc.append_receipt(
        receipts, "verify", "OK" if ok else "FAIL",
        {"id": ident, "want": row["sha256"], "got": got,
         "ref": ref or row.get("ref", "")},
        tail="landed" if ok else "MISMATCH")
    return ok


def roundtrip(backend, seat_paths, manifest, receipts, base=None):
    """Full local proof: stage -> put -> get -> verify-by-hash. Backend-driven.

    This is what a LocalBackend runs green in tests, and what a real second disk
    (the degraded mirror) runs for real. The Drive path does NOT come through
    here in-sandbox; it goes stage() -> agent+MCP -> verify().
    """
    store = "%s:%s" % (backend.scheme, getattr(backend, "root",
                                               getattr(backend, "folder", "")))
    staged = stage(seat_paths, manifest, receipts, store=store, base=base)
    results = []
    for rec in staged:
        with open(rec["seat_path"], "rb") as fh:
            data = fh.read()
        ref = backend.put(rec["id"], data)
        back = backend.get(ref)
        # write the fetched-back bytes to a temp path and verify by file hash
        tmp = rec["seat_path"] + ".ferryback"
        with open(tmp, "wb") as fh:
            fh.write(back)
        try:
            ok = verify(rec["id"], tmp, manifest, receipts, ref=ref)
        finally:
            os.remove(tmp)
        results.append((rec["id"], ok))
    return results


def status(manifest):
    rows = _load(manifest)
    return rows


# --- cli ------------------------------------------------------------------

def _default_paths():
    here = os.path.dirname(os.path.abspath(__file__))
    seat = os.path.abspath(os.path.join(here, "..", "mainmem", "ferry"))
    return (os.path.join(seat, "drive-manifest.tsv"),
            os.path.join(seat, "receipts.log"))


def main(argv=None):
    dman, drec = _default_paths()
    ap = argparse.ArgumentParser(description="offsite ferry - prove copies by hash")
    ap.add_argument("--manifest", default=dman)
    ap.add_argument("--receipts", default=drec)
    sub = ap.add_subparsers(dest="cmd", required=True)

    s = sub.add_parser("stage", help="record seat files' identity into manifest")
    s.add_argument("seat", nargs="+")
    s.add_argument("--store", default="drive:ComputerPeople")
    s.add_argument("--base", default=None)

    v = sub.add_parser("verify", help="assert a fetched-back copy matches by hash")
    v.add_argument("id")
    v.add_argument("file")
    v.add_argument("--ref", default=None)

    r = sub.add_parser("roundtrip", help="full local proof via a backend")
    r.add_argument("backend", help="local:/path or drive:ComputerPeople")
    r.add_argument("seat", nargs="+")
    r.add_argument("--base", default=None)

    sub.add_parser("status", help="print the manifest")

    a = ap.parse_args(argv)
    if a.cmd == "stage":
        for rec in stage(a.seat, a.manifest, a.receipts, store=a.store,
                         base=a.base):
            print(rec["status"], rec["sha256"], rec["id"])
    elif a.cmd == "verify":
        ok = verify(a.id, a.file, a.manifest, a.receipts, ref=a.ref)
        print("VERIFIED" if ok else "MISMATCH", a.id)
        return 0 if ok else 1
    elif a.cmd == "roundtrip":
        be = make_backend(a.backend)
        res = roundtrip(be, a.seat, a.manifest, a.receipts, base=a.base)
        for ident, ok in res:
            print("VERIFIED" if ok else "MISMATCH", ident)
        return 0 if all(ok for _, ok in res) else 1
    elif a.cmd == "status":
        for row in status(a.manifest):
            print(row.get("status"), row.get("sha256"), row.get("id"),
                  row.get("ref"))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
