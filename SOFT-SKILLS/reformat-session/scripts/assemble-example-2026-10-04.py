"""Assemble TURN-NN.md files: his words in chunks, each with its reading; what was done; what was
said (verbatim from the transcript where the transcript has it)."""
import json, os, re, glob
OUT = '/mnt/user-data/outputs/session-2026-10-04'
os.makedirs(OUT, exist_ok=True)
EV = 'out'
# which transcript turn files hold each log turn's events, for "what I told him"
said_from = {'TURN-03': ['turn-00.json', 'turn-01.json'], 'TURN-04': ['turn-02.json'], 'TURN-05': ['turn-03.json'],
             'TURN-06': ['turn-04.json', 'turn-05.json', 'turn-06.json'], 'TURN-07': ['turn-07.json']}
def quote(s):
    return '\n'.join('> ' + l if l.strip() else '>' for l in s.rstrip('\n').split('\n'))
def told(files):
    mid, final, stopped = [], None, False
    for f in files:
        t = json.load(open(os.path.join(EV, f)))
        evs = t['events'] if f != 'turn-00.json' else t['events'][1:]
        for e in evs:
            if e['kind'] == 'my-tool' and e.get('tool') == 'SendUserMessage':
                mid.append(e['text'])
            if e['kind'] == 'my-text':
                final = e['text']
            if e['kind'] == 'harness-notice':
                stopped = True
    return mid, final, stopped
extra = {
 'TURN-02': ('His card (my transcription; the photograph is egad/.house/q/2026-10-04-CARD.jpg)',
             '/mnt/user-data/uploads/claude--projects/egad/.house/q/2026-10-04-PROMPT-2.md', '## The card, transcribed'),
}
index = []
for f in sorted(glob.glob('agents/TURN-0*.json')):
    d = json.load(open(f)); name = d['turn']
    L = ['# %s · %s' % (name, d['title']), '', '*%s*' % d.get('when', ''), '',
         '## What he said, and what I took it to mean', '']
    for c in d['chunks']:
        if name == 'TURN-06' and c['src'].endswith('.txt'):
            continue
        L += [quote(c['his']), '', c['reading'], '']
    if name == 'TURN-06':
        L += ['The same text was saved as `/f/claude/AS4CE/AS4CE0001/fix-comic-rewrite-session-improve-orgvm.txt`; it is identical to the second message, so it is not repeated here.', '']
    if name == 'TURN-04':
        L += ['(His message came with two photographs of a hand-written card; the card and its reading are at `kid-glove/.house/q/2026-10-04-CARD.jpg` and `2026-10-04-CARD-READING.md`.)', '']
    if name == 'TURN-05':
        L += ['(The CORWIN.md message came with a photographed page of notes; it and its reading are at `ghostwheel-nodes/.house/q/2026-10-04-NOTES-person-community.jpg` and `2026-10-04-NOTES-READING.md`.)', '']
    if name in extra:
        title, src, head = extra[name]
        txt = open(src, encoding='utf-8').read(); sec = txt[txt.index(head):].split('\n', 1)[1]
        L += ['### ' + title, '', '```', sec.strip('\n'), '```', '']
    L += ['## What I did', '']
    L += ['- ' + x for x in d['did']] + ['']
    L += ['## What I told him', '']
    if name in said_from:
        mid, final, stopped = told(said_from[name])
        for m in mid:
            L += ['Sent while working:', '', quote(m), '']
        if stopped:
            L += ['Each reply in this turn was stopped by a safety classifier before it was finished; the partial text is not reproduced.', '']
        elif final:
            L += ['At the end (verbatim):', '', quote(final), '']
    else:
        L += [d['said'], '', '(The chat reply itself is not in this session\'s transcript, which begins after a context compaction; the hand-back named above is the record.)', '']
    L += ['---', '', '*Assembled 2026-10-04 by reformat-session: his words verbatim (checked), readings and "what I did" drafted by sub-agents from the transcript and the hand-backs, chosen and assembled by Claude.*', '']
    open(os.path.join(OUT, name + '.md'), 'w', encoding='utf-8').write('\n'.join(L))
    index.append((name, d['title'], d.get('when', ''), len(d['chunks'])))
with open(os.path.join(OUT, 'README.md'), 'w', encoding='utf-8') as fh:
    fh.write('# The session of 2026-10-04, turn by turn\n\nEach file: his words in order, broken into chunks, each followed by what I took it to mean; then what I did; then what I told him. His words are verbatim and checked (check-coverage.py). No account of how conclusions were reached is given, on purpose.\n\n| turn | title | when |\n|---|---|---|\n')
    for n, t, w, c in index:
        fh.write('| [%s](%s.md) | %s | %s |\n' % (n, n, t, w))
print('\n'.join('%s %s (%d chunks)' % (n, t, c) for n, t, w, c in index))
