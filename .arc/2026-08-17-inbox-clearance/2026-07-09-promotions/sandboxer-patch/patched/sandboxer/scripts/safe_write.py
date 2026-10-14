#!/usr/bin/env python3
"""Atomically copy SOURCE onto TARGET on a mounted disk, then verify it landed.

Why this exists: the file (Edit/Write) tool's cached view of a mounted
Windows folder can desync from the real disk. It then reports "updated
successfully" while the bytes never reach the mount. bash writes the real
disk, so we cross the sand here and prove the crossing.

Usage:
    python3 safe_write.py [--validate] SOURCE TARGET

Flow: write a staged temp file (same dir, same extension) + fsync. With
--validate, run a language-aware validity check on the STAGED file FIRST
(see validators.py: .el byte-compile, .py py_compile, .html closing tag) and
refuse to promote it if it fails - a broken file never replaces the good
one. Then atomic os.replace, then reopen TARGET and confirm its byte length
and sha256 match SOURCE.

Exit: 0 = verified, byte-identical write. 1 = byte/sha mismatch. 2 = staged
file failed validation (target left untouched).

Stdlib only - no dependencies.
"""
import hashlib
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from validators import validate  # noqa: E402


def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()


def main():
    args = sys.argv[1:]
    do_validate = "--validate" in args
    args = [a for a in args if a != "--validate"]
    if len(args) != 2:
        sys.exit("usage: safe_write.py [--validate] SOURCE TARGET")
    source, target = args

    if not os.path.isfile(source):
        sys.exit("safe_write: SOURCE does not exist: " + source)

    with open(source, "rb") as f:
        data = f.read()

    # Stage in the same directory, preserving the extension so language
    # validators (and emacs byte-compile) recognise the file type.
    root, ext = os.path.splitext(target)
    tmp = root + ".sandboxer.tmp" + ext
    target_dir = os.path.dirname(os.path.abspath(target)) or "."

    with open(tmp, "wb") as f:
        f.write(data)
        f.flush()
        os.fsync(f.fileno())

    # Verify BEFORE promote: gate the staged copy so a broken file never
    # lands on the real path.
    if do_validate:
        status, detail = validate(tmp)
        print("validate: {:<5} ({})".format(status.upper(), detail))
        if status == "fail":
            try:
                os.remove(tmp)
            except OSError:
                pass
            print("RESULT : BLOCKED - staged file failed validation; "
                  "target left untouched")
            sys.exit(2)

    os.replace(tmp, target)

    # Make the rename durable where the filesystem allows it.
    try:
        dfd = os.open(target_dir, os.O_RDONLY)
        try:
            os.fsync(dfd)
        finally:
            os.close(dfd)
    except OSError:
        pass

    src_len, src_hash = len(data), sha256(source)
    dst_len, dst_hash = os.path.getsize(target), sha256(target)
    ok = (src_len == dst_len) and (src_hash == dst_hash)

    print("source : {:>10} bytes  {}".format(src_len, src_hash))
    print("target : {:>10} bytes  {}".format(dst_len, dst_hash))
    if ok:
        print("RESULT : VERIFIED - write landed intact")
    else:
        print("RESULT : MISMATCH - write did NOT land; do not trust it")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
