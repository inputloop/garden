#!/usr/bin/env python3
"""extract.py -- reformat-session, step 1: extract the visible session (no thinking blocks) from the harness JSONL, as one JSON line per
event: his messages (prompts and mid-turn), my visible text, my tool calls (name and a short form of
the input), and short tool-result excerpts.  Then split into turns at each prompt of his."""
import json, sys, os
# usage: extract.py SESSION.jsonl OUTDIR      (writes OUTDIR/visible-events.jsonl and OUTDIR/turn-NN.json)
SRC, OUTDIR = sys.argv[1], sys.argv[2]
out = []
def short(x, n):
    s = x if isinstance(x, str) else json.dumps(x, ensure_ascii=False)
    return s if len(s) <= n else s[:n] + ' [...]'
for i, l in enumerate(open(SRC, encoding='utf-8')):
    try: o = json.loads(l, strict=False)
    except Exception: continue
    ts = o.get('timestamp'); t = o.get('type')
    if o.get('isCompactSummary'):
        c = o['message']['content']; txt = c if isinstance(c, str) else ' '.join(x.get('text', '') for x in c if x.get('type') == 'text')
        out.append({'i': i, 'ts': ts, 'kind': 'summary', 'text': txt}); continue
    if t == 'attachment':
        a = o.get('attachment', {})
        if a.get('type') == 'queued_command':
            p = a.get('prompt')
            if isinstance(p, list):
                txt = ' '.join(x.get('text', '') for x in p if x.get('type') == 'text')
                imgs = sum(1 for x in p if x.get('type') == 'image')
            else:
                txt, imgs = p or '', 0
            out.append({'i': i, 'ts': ts, 'kind': 'his-midturn', 'text': txt, 'images': imgs})
        continue
    if t == 'user':
        c = o['message']['content']
        if isinstance(c, str):
            out.append({'i': i, 'ts': ts, 'kind': 'his-prompt', 'text': c, 'images': 0}); continue
        if any(x.get('type') == 'tool_result' for x in c):
            for x in c:
                if x.get('type') == 'tool_result':
                    out.append({'i': i, 'ts': ts, 'kind': 'tool-result', 'id': x.get('tool_use_id'), 'text': short(x.get('content'), 400)})
        else:
            txt = ' '.join(x.get('text', '') for x in c if x.get('type') == 'text')
            out.append({'i': i, 'ts': ts, 'kind': 'his-prompt', 'text': txt, 'images': sum(1 for x in c if x.get('type') == 'image')})
        continue
    if t == 'assistant':
        for x in o['message'].get('content', []):
            if x.get('type') == 'text' and x.get('text', '').strip():
                out.append({'i': i, 'ts': ts, 'kind': 'my-text', 'text': x['text']})
            elif x.get('type') == 'tool_use':
                inp = x.get('input', {})
                if 'command' in inp: s = inp['command']
                elif 'file_path' in inp: s = inp['file_path']
                elif 'message' in inp: s = inp['message']
                else: s = inp
                out.append({'i': i, 'ts': ts, 'kind': 'my-tool', 'tool': x.get('name'), 'id': x.get('id'), 'text': short(s, 1500)})
# drop the system-injected "classifier stopped" notices into their own kind
for e in out:
    if e['kind'] == 'his-prompt' and e['text'].startswith('Your response above was stopped by a safety classifier'):
        e['kind'] = 'harness-notice'
os.makedirs(OUTDIR, exist_ok=True)
with open(os.path.join(OUTDIR, 'visible-events.jsonl'), 'w', encoding='utf-8') as fh:
    for e in out: fh.write(json.dumps(e, ensure_ascii=False) + '\n')
# turns
turns, cur = [], None
for e in out:
    if e['kind'] in ('his-prompt', 'summary'):
        cur = {'start': e['ts'], 'events': [e]}; turns.append(cur)
    elif cur is not None:
        cur['events'].append(e)
for n, tr in enumerate(turns):
    with open(os.path.join(OUTDIR, 'turn-%02d.json' % n), 'w', encoding='utf-8') as fh:
        json.dump(tr, fh, ensure_ascii=False, indent=1)
    first = tr['events'][0]
    print('%02d %s %-12s events=%d  %s' % (n, tr['start'], first['kind'], len(tr['events']), first['text'][:70].replace('\n', ' ')))
print(len(out), 'events')

# Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; GPL-3.0-or-later.
