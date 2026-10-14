#!/usr/bin/env node
// A fixture standing in for C4's mcp/c4-mcp.js in tests/c4face-tests.sh (spec: tests/c4face-SPEC.txt).
// Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors.  SPDX-License-Identifier: GPL-3.0-or-later
'use strict';
const readline = require('readline');
const path = require('path');
const M = require(path.join(__dirname, '..', 'lib', 'c4-model.js'));
const TOOLS = [{ name: 'c4_fixture_probe', description: 'Fixture tool.', inputSchema: { type: 'object', properties: {} } }];
function send(o) { process.stdout.write(JSON.stringify(o) + '\n'); }
readline.createInterface({ input: process.stdin }).on('line', function (line) {
  let m; try { m = JSON.parse(line); } catch (e) { return; }
  if (m.method === 'initialize') return send({ jsonrpc: '2.0', id: m.id, result: { protocolVersion: '2024-11-05', capabilities: { tools: {} }, serverInfo: { name: 'c4-fixture', version: M.version } } });
  if (m.method === 'tools/list') return send({ jsonrpc: '2.0', id: m.id, result: { tools: TOOLS } });
  if (m.method === 'tools/call') return send({ jsonrpc: '2.0', id: m.id, result: { content: [{ type: 'text', text: 'fixture says hello' }] } });
  if (m.id !== undefined) send({ jsonrpc: '2.0', id: m.id, error: { code: -32601, message: 'method not found' } });
});
