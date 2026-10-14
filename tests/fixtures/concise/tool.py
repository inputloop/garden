"""Stub tool for the 'concise' skill — synthesized by polygram (stdlib only)."""

from __future__ import annotations

import argparse

KEYWORDS = ['concise']


def run(args: argparse.Namespace) -> int:
    print("polygram stub tool for 'concise'; keywords:", ", ".join(KEYWORDS))
    return 0


def main() -> int:
    p = argparse.ArgumentParser(description="concise tool")
    return run(p.parse_args())


if __name__ == "__main__":
    raise SystemExit(main())
