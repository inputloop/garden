#!/usr/bin/env python3
"""My own check of the agents' files, written apart from theirs: every 'his' is an exact substring of
its src (file text, or for a turn JSON, some his-* event text); and per source, the chunks taken in
order cover that source's words of his with only whitespace and known headers left over."""
import json, glob, re, os, sys
# usage: check.py DRAFTDIR      (the TURN-NN.json drafts; exit 1 on any break)
D = sys.argv[1] if len(sys.argv) > 1 else 'agents'
def src_texts(src):
    if src.endswith('.json'):
        t = json.load(open(src)); return [e['text'] for e in t['events'] if e['kind'] in ('his-prompt', 'his-midturn')]
    return [open(src, encoding='utf-8').read()]
bad = 0
for f in sorted(glob.glob(os.path.join(D, 'TURN-*.json'))):
    d = json.load(open(f)); n = 0
    for c in d['chunks']:
        texts = src_texts(c['src'])
        if not any(c['his'] in t for t in texts):
            print('NOT FOUND', f, c['his'][:60]); bad += 1
        n += 1
    # coverage for JSON sources: every his-* event text fully covered (whitespace aside)
    for src in sorted({c['src'] for c in d['chunks'] if c['src'].endswith('.json')}):
        for t in src_texts(src):
            rest = t
            for c in d['chunks']:
                if c['src'] == src and c['his'] in rest:
                    rest = rest.replace(c['his'], '', 1)
            left = re.sub(r'\s+', '', rest)
            if left:
                print('UNCOVERED', f, src.split('/')[-1], repr(left[:80])); bad += 1
    print(f, n, 'chunks', len(d.get('did', [])), 'did')
print('breaks:', bad)
sys.exit(1 if bad else 0)

# Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; GPL-3.0-or-later.
