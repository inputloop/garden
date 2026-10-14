#!/usr/bin/env perl
# mcp-smoke.pl -- start the minted plugin's MCP servers THE WAY THE DESKTOP DOES, and talk to them.
#
# usage: perl tests/mcp-smoke.pl [PLUGIN_DIR]        (default: dist/vibrobeast, relative to the repo root)
#
# What "the way the desktop does" means here, each a thing that has actually broken:
#   1. read .mcp.json; for each server take `command` + `args` VERBATIM, substituting only
#      ${CLAUDE_PLUGIN_ROOT} -> PLUGIN_DIR.  No -m, no PYTHONPATH, nothing the config does not say.
#   2. REFUSE any server that declares an `env` block.  Claude Desktop will not prepare a plugin
#      server whose env names PYTHONPATH -- its own log, avalon 2026-09-19..23:
#        [PluginMcpHostConfig] ... failed to build host proxy target:
#        env declares reserved variable name "PYTHONPATH"
#      and the only thing a reader sees is `not_started / could_not_prepare`.  This plugin promises
#      no env at all, so ANY env key here is a FAIL, with that line printed beside it.
#   3. spawn with a CLEAN environment (no PYTHONPATH leaking in from a source checkout), cwd = the
#      plugin dir, and speak JSON-RPC over stdio: initialize -> initialized -> tools/list -> one
#      tools/call.  Assert the server names itself, lists at least the tools it shipped with, and
#      answers a call with content.
#   4. afterwards, no __pycache__ anywhere under the plugin dir (the launcher's own promise).
#
# Third language on purpose: the servers are Python, the earlier tests are Python and sh; a spec in a
# third idiom cannot share their blind spots (Corwin's rule, 2026-09-14).  Core Perl only.
#
# Copyright 2026 Corwin Brust <corwin@bru.st> -- GPLv3-or-later.  Authored by Mentat (for Corwin).
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
use strict; use warnings;
use JSON::PP;
use IPC::Open3;
use File::Find;
use File::Spec;
use Cwd qw(abs_path);
use Symbol qw(gensym);

my $dir = $ARGV[0] // 'dist/vibrobeast';
$dir = abs_path($dir) // die "mcp-smoke: no such directory: $dir\n";
my $cfgpath = "$dir/.mcp.json";
my ($pass, $fail) = (0, 0);
sub ok   { $pass++; print "ok   $_[0]\n" }
sub bad  { $fail++; print "FAIL $_[0] -- $_[1]\n" }

# -- expectations: the fewest tools each server has ever shipped with, so a lost tool is a FAIL and a
# gained one is not.  The first call is one that must answer without any seat set up.
my %want = (
  mentcached => { min => 26, call => 'seat_mode',           args => {} },
  persona    => { min => 7,  call => 'persona_list',        args => {} },
  skillx     => { min => 4,  call => 'skillx_capabilities', args => {} },
);

open my $fh, '<:raw', $cfgpath or do { bad('.mcp.json readable', "$cfgpath: $!"); done() };
my $cfg = eval { JSON::PP->new->decode(do { local $/; <$fh> }) };
close $fh;
unless ($cfg && ref $cfg->{mcpServers} eq 'HASH' && %{ $cfg->{mcpServers} }) {
  bad('.mcp.json parses and names servers', $@ || 'no mcpServers'); done();
}
ok('.mcp.json parses and names servers: ' . join(', ', sort keys %{ $cfg->{mcpServers} }));

for my $name (sort keys %{ $cfg->{mcpServers} }) {
  my $s = $cfg->{mcpServers}{$name};

  # 2. the reserved-name refusal, checked before anything is started
  if (exists $s->{env}) {
    my $names = join(', ', sort keys %{ $s->{env} || {} }) || '(empty)';
    bad("$name: no env block", "env declares $names; Claude Desktop refuses to prepare a plugin server "
        . 'whose env names PYTHONPATH ("env declares reserved variable name" -- its log); this plugin promises no env at all');
    next;
  }
  ok("$name: no env block");

  # 1. the argv, verbatim but for the one substitution the app makes
  my @argv = ($s->{command}, @{ $s->{args} || [] });
  my $root = $dir;
  local $ENV{MSYS2_ARG_CONV_EXCL} = $ENV{MSYS2_ARG_CONV_EXCL};
  local $ENV{MSYS_NO_PATHCONV} = $ENV{MSYS_NO_PATHCONV};
  # 2026-10-08: a Windows mint starts each server as `cmd /d /c <root>\servers\launch.cmd NAME`.
  # Only a Windows host can run that.  There the root goes in as a Windows path, and MSYS2 / Git
  # Bash must not rewrite /d and /c into drive letters.  Anywhere else it is said, not counted.
  if (lc($argv[0]) =~ /^cmd(?:\.exe)?$/) {
    if ($^O !~ /^(?:msys|cygwin|MSWin32)$/) {
      print "skip $name: starts through cmd.exe (a Windows mint); not checkable on $^O\n";
      next;
    }
    if ($^O ne 'MSWin32') { chomp($root = `cygpath -w "$dir"`); }
    $ENV{MSYS2_ARG_CONV_EXCL} = '*'; $ENV{MSYS_NO_PATHCONV} = 1;
  }
  s/\$\{CLAUDE_PLUGIN_ROOT\}/$root/g for @argv;
  unless (@argv >= 2) { bad("$name: argv has a command and args", "@argv"); next }

  # 3. clean environment, cwd = plugin dir, stdio JSON-RPC
  local %ENV = %ENV;
  delete @ENV{qw(PYTHONPATH PYTHONDONTWRITEBYTECODE MENTCACHED_SEAT MENTCACHED_JAIL MENTCACHED_BY PERSONA_ROOT)};
  my $w = $want{$name} || { min => 1, call => undef };
  my @req = (
    { jsonrpc => '2.0', id => 1, method => 'initialize',
      params => { protocolVersion => '2024-11-05', capabilities => {}, clientInfo => { name => 'mcp-smoke', version => '1' } } },
    { jsonrpc => '2.0', method => 'notifications/initialized' },
    { jsonrpc => '2.0', id => 2, method => 'tools/list' },
  );
  push @req, { jsonrpc => '2.0', id => 3, method => 'tools/call', params => { name => $w->{call}, arguments => $w->{args} } }
    if $w->{call};
  my $in = join '', map { JSON::PP->new->canonical->encode($_) . "\n" } @req;

  my ($out, $err) = ('', '');
  my $rc = eval {
    local $SIG{ALRM} = sub { die "timeout\n" };
    alarm 30;
    chdir $dir or die "chdir $dir: $!\n";
    my $childerr = gensym;
    my $pid = open3(my $to, my $from, $childerr, @argv);
    print {$to} $in; close $to;
    local $/; $out = <$from> // ''; $err = <$childerr> // '';
    waitpid $pid, 0; alarm 0;
    $? >> 8;
  };
  if ($@) { bad("$name: starts and answers", "$@ (argv: @argv)"); next }
  if ($rc != 0) { bad("$name: exits 0 after EOF", "rc=$rc; stderr: " . substr($err, -300)); next }

  my %by_id;
  for my $line (grep { /\S/ } split /\n/, $out) {
    my $m = eval { JSON::PP->new->decode($line) };
    unless ($m) { bad("$name: every stdout line is JSON", substr($line, 0, 120)); next }
    $by_id{ $m->{id} } = $m if defined $m->{id};
  }
  my $init = $by_id{1};
  # c4face hands its stdio to C4's own server when it finds C4 and node; that one answers as itself.
  my %as = (c4face => qr/^(?:c4face|c4-work-surface)$/);
  my $want_as = $as{$name} || qr/^\Q$name\E$/;
  if ($init && $init->{result} && ($init->{result}{serverInfo}{name} // '') =~ $want_as && $init->{result}{protocolVersion}) {
    ok("$name: initialize answers as itself (protocol $init->{result}{protocolVersion})");
  } else {
    bad("$name: initialize answers as itself", substr(JSON::PP->new->encode($init // {}), 0, 200)); next;
  }
  my $tools = $by_id{2} && $by_id{2}{result} ? ($by_id{2}{result}{tools} || []) : [];
  if (@$tools >= $w->{min}) { ok("$name: tools/list has " . @$tools . " tools (>= $w->{min})") }
  else { bad("$name: tools/list has >= $w->{min} tools", 'got ' . @$tools) }
  if ($w->{call}) {
    my $r = $by_id{3};
    my $text = $r && $r->{result} && ref $r->{result}{content} eq 'ARRAY' ? ($r->{result}{content}[0]{text} // '') : '';
    if (length $text) {
      (my $first = $text) =~ s/\s+/ /g;
      ok("$name: tools/call $w->{call} answers: " . substr($first, 0, 70));
      if ($name eq 'mentcached') {
        $text =~ /\b(SEATED|JAILED|NOTVISIBLE)\b/ ? ok("$name: the answer carries a mode word ($1)")
                                                  : bad("$name: the answer carries a mode word", substr($text, 0, 120));
      }
    } else {
      bad("$name: tools/call $w->{call} answers", substr(JSON::PP->new->encode($r // {}), 0, 200));
    }
  }
}

# 4. the launcher's promise: no bytecode written into the plugin by starting it
my @pyc;
find(sub { push @pyc, $File::Find::name if $_ eq '__pycache__' || /\.pyc$/ }, $dir);
@pyc ? bad('no __pycache__ under the plugin after a run', "@pyc") : ok('no __pycache__ under the plugin after a run');

done();
sub done { print "TOTAL pass=$pass fail=$fail\n"; exit($fail ? 1 : 0) }
