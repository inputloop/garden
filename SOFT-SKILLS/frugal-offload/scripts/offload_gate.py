#!/usr/bin/env python3
"""
offload_gate.py -- the frugal-offload decision: turn a token-optimizer frugality flag into a VERIFIED
llama-bridge offload, or keep the subtask on Claude. Thin on purpose: it decides only WHEN to cross.

The bar (all must hold to offload): output is objectively CHECKABLE, stakes are LOW, and volume is
real. The reason we are strict: an unverifiable local answer is not savings -- it is a liability that
costs more to clean up (token-optimizer's own premise -- bad output costs more than good output).

Run: python3 offload_gate.py --selftest
"""
import sys


def should_offload(*, checkable: bool, low_stakes: bool, volume: bool, judgment_heavy: bool = False):
    """Return (offload: bool, reason: str)."""
    if judgment_heavy:
        return (False, "judgment-heavy -- keep on Claude; a local model will miss the nuance")
    if not checkable:
        return (False, "output not objectively checkable -- an unverifiable local answer is a liability, not savings")
    if not low_stakes:
        return (False, "high-stakes -- a wrong local answer would ship; keep on Claude")
    if not volume:
        return (False, "one-shot / tiny -- the round-trip costs more than it saves")
    return (True, "checkable + low-stakes + bulk -> offload to llama-bridge WITH a verification gate (require_json / must_include / escalate_to)")


def _selftest():
    P = []; ck = lambda n, c: (P.append(bool(c)), print(("PASS" if c else "FAIL"), n))
    ck("bulk + checkable + low-stakes -> offload", should_offload(checkable=True, low_stakes=True, volume=True)[0] is True)
    ck("unverifiable -> keep", should_offload(checkable=False, low_stakes=True, volume=True)[0] is False)
    ck("high-stakes -> keep", should_offload(checkable=True, low_stakes=False, volume=True)[0] is False)
    ck("one-shot tiny -> keep", should_offload(checkable=True, low_stakes=True, volume=False)[0] is False)
    ck("judgment-heavy -> keep", should_offload(checkable=True, low_stakes=True, volume=True, judgment_heavy=True)[0] is False)
    print("\n%d/%d passed" % (sum(1 for c in P if c), len(P)))
    return all(P)


if __name__ == "__main__":
    if "--selftest" in sys.argv:
        sys.exit(0 if _selftest() else 1)
    print("frugal-offload gate. import should_offload(checkable=, low_stakes=, volume=[, judgment_heavy=]).")
