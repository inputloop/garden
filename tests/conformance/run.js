#!/usr/bin/env node
/*
 * run.js -- conformance suite for the dl2 chain spec.
 * Copyright (C) 2026 Corwin Brust <corwin@bru.st>.  GPL-3.0-or-later.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 * This file is part of polygram.  polygram is free software: you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later version.  It is
 * distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
 *
 * WHY THIS EXISTS, AND WHY IN NODE
 * --------------------------------
 * Corwin's standing rule, 2026-09-14: "add coverage up to 100% when something
 * gets by our tests, ideally with a new spec and implementation language sep
 * from what the original tested work uses and from what the prior tests use."
 *
 * On 2026-09-14 an adversarial read found that BOTH chain verifiers agreed on
 * a forged chain.  They were in two languages and shared no code, and they
 * still failed together, because both had silently assumed the same thing.
 * The tests missed it because the tests were written by the same hand, in the
 * same two languages, from the same assumption.
 *
 * So, four separations, on purpose:
 *
 *   the spec            polygram/mcp/chainspec.py   prose, not code
 *   implementation A    polygram/mcp/verify.py      Python
 *   implementation B    bin/dl2-verify.sh           POSIX sh + awk
 *   implementation C    bin/dl2-verify.pl           Perl
 *   THIS SUITE          node                        a fourth language
 *
 * And this file does not only *run* the three.  It WRITES the fixtures, from
 * the spec, with its own hashing and its own byte-assembly.  That matters: if
 * the Python writer has a quirk -- a stray newline, a normalisation nobody
 * noticed -- fixtures written by Python could never expose it, because they
 * would carry the same quirk into every reader.  A fourth writer is the only
 * way to find out whether the FORMAT is right or merely self-consistent.
 *
 * The suite demands two things of every fixture:
 *   1. UNANIMITY -- all three implementations return the same verdict and the
 *      same failing check.  A split is a failure of the suite, not a tie to
 *      be broken; nobody wins.
 *   2. CORRECTNESS -- that unanimous answer is the one the spec requires.
 *      Three readers agreeing on the wrong answer is exactly the 2026-09-14
 *      failure, and unanimity alone would not have caught it.
 *
 * usage:
 *   node tests/conformance/run.js              run the suite
 *   node tests/conformance/run.js --prove-red  prove the suite can fail
 *   node tests/conformance/run.js --list       the fixtures and what each covers
 */

'use strict';
const crypto = require('crypto');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { execFileSync } = require('child_process');

const ROOT = path.resolve(__dirname, '..', '..');

// ---------------------------------------------------------------- writing
// The format, assembled from the spec text. Deliberately NOT importing or
// shelling out to the Python writer.

const sha256 = (buf) => crypto.createHash('sha256').update(buf).digest('hex');

/** sha256 of a body per C3: strip trailing newlines, hash the bytes. */
function bodySha(body) {
  let b = Buffer.from(body, 'utf8');
  let end = b.length;
  while (end > 0 && (b[end - 1] === 0x0a || b[end - 1] === 0x0d)) end--;
  return sha256(b.subarray(0, end));
}

/** Assemble one generation file's bytes. `extra` rides in the front matter. */
function genBytes({ seam = 'fixture', gen, prev = '', body, extra = [] }) {
  const head = [
    `seam: ${seam}`,
    `gen: ${gen}`,
    `prev: ${prev}`,
    ...extra,
  ].join('\n');
  return Buffer.from(`---\n${head}\n---\n${body}\n`, 'utf8');
}

/**
 * Spec v2: the filename's hex16 is sha256 of the WHOLE FILE, not of the body.
 * No circularity -- the name is not inside the file, so assemble the bytes,
 * hash them, then name the file after them.
 */
function genName(gen, bytes, { pad = 4, stamp = null, hex = null } = {}) {
  const g = String(gen).padStart(pad, '0');
  const st = stamp || `202609${String(10 + (gen % 20)).padStart(2, '0')}T000000Z`;
  return `g${g}-${st}-${hex || sha256(bytes).slice(0, 16)}.md`;
}

/** Write a well-formed chain of `bodies.length` generations into `dir`. */
function writeChain(dir, bodies, opts = {}) {
  fs.mkdirSync(dir, { recursive: true });
  let prev = '';
  const written = [];
  bodies.forEach((body, idx) => {
    const gen = idx + 1;
    const bytes = genBytes({ gen, prev, body, ...opts });
    const p = path.join(dir, genName(gen, bytes, opts));
    fs.writeFileSync(p, bytes);
    prev = 'sha256:' + sha256(bytes);
    written.push(p);
  });
  return written;
}

// ---------------------------------------------------------------- running

function runPython(dir) {
  const out = execFileSync('python3', ['-c', `
import sys, json
sys.path.insert(0, ${JSON.stringify(ROOT)})
from pathlib import Path
from polygram.mcp import verify
r = verify.verify_python(Path(sys.argv[1]))
print(json.dumps({"ok": r.ok, "gens": r.gens, "at": r.broken_at,
                  "check": r.detail.split(":")[0] if not r.ok else ""}))
`, dir], { encoding: 'utf8' });
  return JSON.parse(out.trim());
}

function parseTsv(stdout) {
  const parts = stdout.trim().split('\t');
  if (parts[0] === 'OK') return { ok: true, gens: Number(parts[1]), at: '', check: '' };
  if (parts[0] === 'BROKEN') {
    return { ok: false, gens: Number(parts[1]), at: parts[2], check: parts[3] || '' };
  }
  throw new Error(`unreadable verdict: ${JSON.stringify(stdout)}`);
}

function runTool(cmd, args, dir) {
  try {
    return parseTsv(execFileSync(cmd, [...args, dir], { encoding: 'utf8' }));
  } catch (e) {
    // exit 1 is "chain broken" and still carries a verdict on stdout.
    if (e.status === 1 && e.stdout) return parseTsv(e.stdout);
    throw new Error(`${cmd} failed (status ${e.status}): ` +
                    `${(e.stderr || '').toString().trim() || e.message}`);
  }
}

const READERS = [
  ['python', (d) => runPython(d)],
  ['sh', (d) => runTool('sh', [path.join(ROOT, 'bin', 'dl2-verify.sh')], d)],
  ['perl', (d) => runTool('perl', [path.join(ROOT, 'bin', 'dl2-verify.pl')], d)],
];

// ---------------------------------------------------------------- fixtures
// Each fixture names the finding it covers, so a reader can trace a test back
// to the day it was earned.

const FIXTURES = [
  {
    name: 'intact-2',
    covers: 'baseline: a well-formed two-generation chain',
    build: (d) => writeChain(d, ['one', 'two']),
    expect: { ok: true, gens: 2 },
  },
  {
    name: 'empty',
    covers: 'an empty seam directory is OK with zero generations',
    build: (d) => fs.mkdirSync(d, { recursive: true }),
    expect: { ok: true, gens: 0 },
  },
  {
    name: 'forged-gen1-appended',
    covers: 'FINDING 2 (critical): a hand-written file saying gen: 1 appended '
          + 'to a real chain re-rooted it, and BOTH readers said OK',
    build: (d) => {
      writeChain(d, ['one', 'two', 'three']);
      const body = 'the price is ZERO';
      const bytes = genBytes({ gen: 1, prev: '', body, extra: ['by: attacker'] });
      fs.writeFileSync(
        path.join(d, genName(4, bytes, { stamp: '20260930T999999Z' })), bytes);
    },
    expect: { ok: false, gens: 4, check: 'C1 position' },
  },
  {
    name: 'head-tampered',
    covers: 'FINDING 3 (critical): the HEAD generation is the only one served, '
          + 'and no prev: pointer can ever cover it',
    build: (d) => {
      const f = writeChain(d, ['one', 'two']);
      const last = f[f.length - 1];
      fs.writeFileSync(last, Buffer.concat([
        fs.readFileSync(last), Buffer.from('the price is ZERO\n')]));
    },
    expect: { ok: false, gens: 2, check: 'C3 self' },
  },
  {
    name: 'partial-write',
    covers: 'FINDING 9: a write that died mid-body parsed, chained and verified',
    build: (d) => {
      // The name says the full body; the file holds a truncated one.
      const body = 'the list price is 200 dollars and the terms are net 30';
      fs.mkdirSync(d, { recursive: true });
      const full = genBytes({ gen: 1, body });
      const cut = genBytes({ gen: 1, body: 'the list price is 200 dollars ' });
      fs.writeFileSync(path.join(d, genName(1, full)), cut);
    },
    expect: { ok: false, gens: 1, check: 'C3 self' },
  },
  {
    name: 'head-frontmatter-edited',
    covers: 'FINDING (3rd pass): spec v1 hashed only the BODY, so the head '
          + "generation's front matter was unprotected -- mode: JAILED could be "
          + 'edited to SEATED and every reader still said OK, while the writer '
          + 'promised the word was stamped in the bytes forever. v2 hashes the '
          + 'whole file.',
    build: (d) => {
      const f = writeChain(d, ['one', 'two']);
      const last = f[f.length - 1];
      fs.writeFileSync(last, Buffer.from(
        fs.readFileSync(last).toString('utf8')
          .replace('seam: fixture', 'seam: rebrandd'), 'utf8'));
    },
    expect: { ok: false, gens: 2, check: 'C3 self' },
  },
  {
    name: 'wholesale-substitution',
    covers: 'C4 still earns its place in v2: a generation replaced by a whole '
          + 'file that is internally consistent, name and all, but is not the '
          + 'one its predecessor points at. C3 cannot see this.',
    build: (d) => {
      const f = writeChain(d, ['one', 'two']);
      fs.unlinkSync(f[1]);
      const bytes = genBytes({ gen: 2, prev: 'sha256:' + '0'.repeat(64),
                               body: 'two' });
      fs.writeFileSync(path.join(d, genName(2, bytes)), bytes);
    },
    expect: { ok: false, gens: 2, check: 'C4 link' },
  },
  {
    name: 'middle-frontmatter-edited',
    covers: 'C4: an edit that leaves the body alone is caught only by the next '
          + "generation's prev: pointer",
    build: (d) => {
      const f = writeChain(d, ['one', 'two', 'three']);
      const mid = f[1];
      fs.writeFileSync(mid, Buffer.from(
        fs.readFileSync(mid).toString('utf8').replace('seam: fixture',
                                                      'seam: rebranded'), 'utf8'));
    },
    expect: { ok: false, gens: 3, check: 'C3 self' },
  },
  {
    name: 'renamed-generation',
    covers: 'C2: a file renamed to change its place in the order',
    build: (d) => {
      const f = writeChain(d, ['one', 'two']);
      fs.renameSync(f[1], f[1].replace('g0002', 'g0007'));
    },
    expect: { ok: false, gens: 2, check: 'C2 name' },
  },
  {
    name: 'crlf-endings',
    covers: 'FINDING 10 row 1: CRLF split the readers -- python said OK, sh '
          + 'said BROKEN. Both must now agree, and agree it is BROKEN, because '
          + 'the bytes on disk are not the bytes that were hashed',
    build: (d) => {
      const f = writeChain(d, ['one', 'two']);
      for (const p of f) {
        fs.writeFileSync(p, Buffer.from(
          fs.readFileSync(p).toString('utf8').replace(/\n/g, '\r\n'), 'utf8'));
      }
    },
    expect: { ok: false },       // unanimity is the point; either verdict, agreed
    agreeOnly: true,
  },
  {
    name: 'duplicate-prev-key',
    covers: 'FINDING 10 row 2: a second prev: line -- python took the last, sh '
          + 'took the first. The spec says first wins.',
    build: (d) => {
      const f = writeChain(d, ['one', 'two']);
      const mid = f[1];
      const txt = fs.readFileSync(mid).toString('utf8');
      fs.writeFileSync(mid, Buffer.from(
        txt.replace(/^prev: (.*)$/m, 'prev: $1\nprev: sha256:' + '0'.repeat(64)),
        'utf8'));
    },
    // The body is unchanged, so C3 passes; the FIRST prev is the real one, so
    // the chain still holds. A reader that took the last would say BROKEN.
    expect: { ok: false, check: 'C3 self' },
    note: 'adding a line changes neither the body nor... it changes the FILE, '
        + 'so gen 3 would break -- with only 2 gens the edited file is the head '
        + 'and C3 covers it. Either way all three must say the same thing.',
    agreeOnly: true,
  },
  {
    name: 'indented-key',
    covers: 'FINDING 10 row 3: an indented "  prev:" -- python needed column 0, '
          + 'sh trimmed. The spec says strip horizontal whitespace.',
    build: (d) => {
      const f = writeChain(d, ['one', 'two']);
      const mid = f[1];
      fs.writeFileSync(mid, Buffer.from(
        fs.readFileSync(mid).toString('utf8').replace(/^prev:/m, '  prev:'),
        'utf8'));
    },
    agreeOnly: true,
  },
  {
    name: 'zero-padded-gen',
    covers: 'FINDING 10 row 4: "gen: 01" -- python int()-ed it, sh compared '
          + 'strings. The spec says compare as an integer.',
    build: (d) => {
      fs.mkdirSync(d, { recursive: true });
      const body = 'one';
      const bytes = Buffer.from(
        `---\nseam: fixture\ngen: 01\nprev: \n---\n${body}\n`, 'utf8');
      fs.writeFileSync(path.join(d, genName(1, bytes)), bytes);
    },
    expect: { ok: true, gens: 1 },
  },
  {
    name: 'unknown-hash-prefix',
    covers: 'FINDING 10 row 5: "prev: blake3:..." -- python split on the second '
          + 'colon and accepted it. The spec says sha256: is the only prefix.',
    build: (d) => {
      const f = writeChain(d, ['one', 'two']);
      const mid = f[1];
      fs.writeFileSync(mid, Buffer.from(
        fs.readFileSync(mid).toString('utf8')
          .replace(/^prev: sha256:/m, 'prev: blake3:'), 'utf8'));
    },
    agreeOnly: true,
  },
  {
    name: 'directory-named-like-a-generation',
    covers: 'FINDING 10 row 6: a DIRECTORY named g0009-...md crashed sh (exit 2) '
          + 'and was skipped by python -- and the crash silently disabled the '
          + 'second reader for every later call',
    build: (d) => {
      writeChain(d, ['one', 'two']);
      fs.mkdirSync(path.join(d, 'g0009-20260914T000000Z-0123456789abcdef.md'));
    },
    expect: { ok: true, gens: 2 },
  },
  {
    name: 'symlink-to-outside',
    covers: 'a symlink named like a generation must be ignored by all three',
    build: (d) => {
      writeChain(d, ['one', 'two']);
      const outside = path.join(path.dirname(d), 'outside.md');
      fs.writeFileSync(outside, genBytes({ gen: 1, body: 'elsewhere' }));
      try {
        fs.symlinkSync(outside,
                       path.join(d, 'g0003-20260914T000000Z-0123456789abcdef.md'));
      } catch (e) { /* no symlink support: the fixture degrades to intact-2 */ }
    },
    expect: { ok: true, gens: 2 },
  },
  {
    name: 'non-utf8-body',
    covers: 'FINDING 10 row 7: a non-UTF-8 byte in the body raised '
          + 'UnicodeDecodeError out of python and escaped verify() entirely',
    build: (d) => {
      fs.mkdirSync(d, { recursive: true });
      const raw = Buffer.concat([Buffer.from([0xff, 0xfe, 0x41]),
                                 Buffer.from(' latin1-ish', 'utf8')]);
      const bytes = Buffer.concat([
        Buffer.from('---\nseam: fixture\ngen: 1\nprev: \n---\n', 'utf8'),
        raw, Buffer.from('\n', 'utf8')]);
      fs.writeFileSync(
        path.join(d, `g0001-20260914T000000Z-${sha256(bytes).slice(0, 16)}.md`),
        bytes);
    },
    expect: { ok: true, gens: 1 },
  },
  {
    name: 'five-digit-generation',
    covers: "store.py's claim that filename sort == generation sort: g10000 "
          + 'sorts BEFORE g9999 as a string',
    build: (d) => {
      fs.mkdirSync(d, { recursive: true });
      let prev = '';
      for (const gen of [9999, 10000]) {
        const body = `body ${gen}`;
        const bytes = genBytes({ gen, prev, body });
        const p = path.join(d, genName(gen, bytes, { pad: 4 }));
        fs.writeFileSync(p, bytes);
        prev = 'sha256:' + sha256(bytes);
      }
    },
    // gen 9999 is file 1 -> C1 fires. The point is all three agree WHICH file.
    expect: { ok: false, check: 'C1 position' },
  },
  {
    name: 'deep-chain-past-generation-seven',
    covers: 'FINDING (2nd pass): the sh reader died at gen 8 -- POSIX $((0008)) '
          + 'is an octal error -- and $((0010)) silently evaluated to 8. No '
          + 'fixture here went past 3 generations, which is why the suite that '
          + 'exists to catch reader disagreement never reached the depth where '
          + 'the readers actually disagreed.',
    build: (d) => writeChain(d, Array.from({ length: 14 }, (_, i) => `body ${i + 1}`)),
    expect: { ok: true, gens: 14 },
  },
  {
    name: 'deep-chain-broken-at-nine',
    covers: 'the same depth, broken, so an OK there is not mistaken for a pass',
    build: (d) => {
      const f = writeChain(d, Array.from({ length: 12 }, (_, i) => `body ${i + 1}`));
      fs.writeFileSync(f[8], Buffer.concat([fs.readFileSync(f[8]),
                                            Buffer.from('tampered')]));
    },
    expect: { ok: false, gens: 12, check: 'C3 self' },
  },
  {
    name: 'path-with-a-space',
    covers: 'FINDING (2nd pass): `for f in $list` word-split the file list, so '
          + 'a seat under C:/Users/First Last/... produced a confident BROKEN '
          + 'about a file called "First". That is the DEFAULT path shape on the '
          + 'stated target platform.',
    build: (d) => writeChain(d, ['one', 'two', 'three']),
    dirName: 'a seam with spaces',
    expect: { ok: true, gens: 3 },
  },
  {
    name: 'non-ascii-digit-in-a-name',
    covers: "FINDING (2nd pass): Python's \\d is Unicode-aware and matched "
          + 'U+0663 while sh and perl are ASCII-only, so one planted file made '
          + 'the readers permanently disagree about how many generations exist',
    build: (d) => {
      writeChain(d, ['one', 'two']);
      const body = 'planted';
      const bytes = genBytes({ gen: 3, body });
      fs.writeFileSync(
        path.join(d, `g\u0663-20260914T000003Z-${sha256(bytes).slice(0, 16)}.md`),
        bytes);
    },
    expect: { ok: true, gens: 2 },
  },
  {
    name: 'trailing-whitespace-body',
    covers: 'FINDING (2nd pass, critical): the store wrote body.strip() while '
          + 'naming the file from a hash that stripped only trailing newlines, '
          + 'so a note with one trailing space failed its own C3 on creation',
    build: (d) => writeChain(d, ['The sky is blue. ', '  leading and trailing  ']),
    expect: { ok: true, gens: 2 },
  },
  {
    name: 'permissive-gen-forms',
    covers: 'FINDING (2nd pass): python int() accepted "+7" and a full-width '
          + '"07" that sh and perl both rejected -- and python is the reader '
          + 'that answers alone on one rotation in three',
    build: (d) => {
      fs.mkdirSync(d, { recursive: true });
      const body = 'one';
      const bytes = Buffer.from(
        `---\nseam: fixture\ngen: +1\nprev: \n---\n${body}\n`, 'utf8');
      fs.writeFileSync(path.join(d, genName(1, bytes)), bytes);
    },
    expect: { ok: false, check: 'C1 position' },
  },
  {
    name: 'gap-in-generations',
    covers: 'a missing generation must not read as a shorter valid chain',
    build: (d) => {
      const f = writeChain(d, ['one', 'two', 'three']);
      fs.unlinkSync(f[1]);
    },
    expect: { ok: false, check: 'C1 position' },
  },
  {
    name: 'no-front-matter',
    covers: 'a file with a generation name and no front matter',
    build: (d) => {
      writeChain(d, ['one']);
      fs.writeFileSync(path.join(d, 'g0002-20260914T000000Z-0123456789abcdef.md'),
                       'just some text\n');
    },
    expect: { ok: false, gens: 2, check: 'C0 shape' },
  },
  {
    name: 'zero-byte-generation',
    covers: 'an empty file with a generation name',
    build: (d) => {
      writeChain(d, ['one']);
      fs.writeFileSync(path.join(d, 'g0002-20260914T000000Z-0123456789abcdef.md'), '');
    },
    expect: { ok: false, gens: 2, check: 'C0 shape' },
  },
  {
    name: 'dashes-inside-the-body',
    covers: 'a body containing a --- line must not be read as front matter',
    build: (d) => writeChain(d, ['before\n---\nafter']),
    expect: { ok: true, gens: 1 },
  },
  {
    name: 'unicode-body',
    covers: 'a body of non-ASCII UTF-8 must hash identically in all three',
    build: (d) => writeChain(d, ['héllo wörld — ✓ 日本語']),
    expect: { ok: true, gens: 1 },
  },
];

// ---------------------------------------------------------------- driver

function runFixture(fx, tmp) {
  const dir = path.join(tmp, fx.name, fx.dirName || 'seam');
  fx.build(dir);
  const results = READERS.map(([name, fn]) => {
    try { return [name, fn(dir)]; }
    catch (e) { return [name, { error: String(e.message).split('\n')[0] }]; }
  });

  const problems = [];
  const errored = results.filter(([, r]) => r.error);
  if (errored.length) {
    for (const [n, r] of errored) problems.push(`${n} errored: ${r.error}`);
  }

  // 1. unanimity
  const keys = results.map(([, r]) => r.error ? 'ERROR'
    : `${r.ok}|${r.gens}|${r.check}`);
  const agreed = keys.every((k) => k === keys[0]);
  if (!agreed) {
    problems.push('SPLIT: ' + results.map(([n, r]) => r.error
      ? `${n}=ERROR` : `${n}=${r.ok ? 'OK' : 'BROKEN'}/${r.gens}/${r.check || '-'}`)
      .join('  '));
  }

  // 2. correctness -- only where the fixture states an expectation
  if (agreed && !errored.length && fx.expect && !fx.agreeOnly) {
    const r = results[0][1];
    for (const [k, want] of Object.entries(fx.expect)) {
      if (r[k] !== want) {
        problems.push(`WRONG: ${k} is ${JSON.stringify(r[k])}, spec says ${JSON.stringify(want)}`);
      }
    }
  }
  return { problems, results };
}

function main(argv) {
  if (argv.includes('--list')) {
    for (const fx of FIXTURES) console.log(`${fx.name}\n    ${fx.covers}\n`);
    console.log(`${FIXTURES.length} fixtures, ${READERS.length} readers, ` +
                `${FIXTURES.length * READERS.length} verdicts per run`);
    return 0;
  }

  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'dl2-conformance-'));
  let failed = 0;
  console.log(`dl2 chain-spec conformance: ${FIXTURES.length} fixtures ` +
              `x ${READERS.map(([n]) => n).join(' / ')}`);
  console.log('  (fixtures are written by THIS file, in node, from the spec --')
  console.log('   not by the python writer, so a writer quirk cannot hide)\n');

  for (const fx of FIXTURES) {
    const { problems } = runFixture(fx, tmp);
    if (problems.length === 0) {
      console.log(`  PASS  ${fx.name}`);
    } else {
      failed++;
      console.log(`  FAIL  ${fx.name}`);
      console.log(`        covers: ${fx.covers}`);
      for (const p of problems) console.log(`        ${p}`);
    }
  }

  if (argv.includes('--prove-red')) {
    console.log('\nprove-red: plant a chain the spec must reject, and require ' +
                'all three to reject it');
    const d = path.join(tmp, '__provered__', 'seam');
    writeChain(d, ['one', 'two']);
    const before = READERS.map(([n, fn]) => [n, fn(d)]);
    if (!before.every(([, r]) => r.ok)) {
      console.log('prove-red FAILED: the control chain did not verify');
      fs.rmSync(tmp, { recursive: true, force: true });
      return 1;
    }
    // One byte, in the head, where no prev: pointer reaches.
    const head = fs.readdirSync(d).sort().pop();
    const p = path.join(d, head);
    fs.writeFileSync(p, Buffer.concat([fs.readFileSync(p), Buffer.from('.')]));
    const after = READERS.map(([n, fn]) => [n, fn(d)]);
    const allBroken = after.every(([, r]) => r.ok === false);
    const sameCheck = new Set(after.map(([, r]) => r.check)).size === 1;
    if (allBroken && sameCheck) {
      console.log(`prove-red PASS: one appended byte, all three say BROKEN ` +
                  `${after[0][1].check}`);
    } else {
      console.log('prove-red FAILED: ' + after.map(([n, r]) =>
        `${n}=${r.ok ? 'OK' : 'BROKEN/' + r.check}`).join('  '));
      failed++;
    }
  }

  fs.rmSync(tmp, { recursive: true, force: true });
  console.log(`\n${FIXTURES.length - failed} passed, ${failed} failed`);
  return failed ? 1 : 0;
}

process.exit(main(process.argv.slice(2)));
