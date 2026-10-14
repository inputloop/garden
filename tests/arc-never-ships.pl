#!/usr/bin/env perl
# arc-never-ships.pl -- the mint and the express manifest agree that a skill's .arc/ (and .git/,
# __pycache__/) is not the skill.
#
# usage: perl tests/arc-never-ships.pl [--prove-red]
#
# The claim (2026-09-24): `.arc/` is the mirror-tree archive of the dormant -- parked copies of
# superseded files, each beside the signature that covered it.  A skill carrying one would ship its
# own history as content, and the SAME mistake could be made twice, because two builders decide what
# a skill is: polygram/dist.py (_staged_files, via _JUNK_DIRS) for the mint, and
# skills/skill-sign/scripts/skill-sign.sh (build_manifest, a find) for the express manifest.  This
# spec plants .arc/, .git/ and __pycache__/ in one throwaway skill, plus a control directory that MUST
# ship, runs both builders, and asserts (1) neither lists a junk path, (2) both list the control, and
# (3) the two file lists are identical -- "together" is the point, not either one alone.
#
# --prove-red: runs the checker over the PRE-FIX find (`find . -type f`, the line that shipped
# .arc/ on 2026-09-24) and passes only if the checker calls it red.  A harness that cannot go red
# is indistinguishable from one that is not running.
#
# Third language on purpose: the work under test is Python and sh; the prior tests are Python and sh;
# a spec in a third idiom cannot share their blind spots (Corwin's rule, 2026-09-14).  Core Perl only.
#
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>.  Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later -- free software, WITHOUT ANY WARRANTY;
# This program is free software: you can redistribute it and/or modify it under the terms
# of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
# <https://www.gnu.org/licenses/>.
use strict; use warnings;
use FindBin qw($RealBin); use File::Temp qw(tempdir); use File::Path qw(make_path); use Cwd qw(abs_path);

my $root = abs_path("$RealBin/..");
my $sign = "$root/skills/skill-sign/scripts/skill-sign.sh";
my $red  = (@ARGV && $ARGV[0] eq '--prove-red');
my ($pass, $fail) = (0, 0);
sub good { $pass++; print "ok   $_[0]\n" }
sub bad  { $fail++; print "FAIL $_[0]: $_[1]\n" }

# -- one throwaway skill: real content, a control dir, three planted junk dirs -------------------
my $ws = tempdir(CLEANUP => 1);
my $sk = "$ws/skills/planted";
make_path("$sk/scripts", "$sk/history", "$sk/.arc", "$sk/.git", "$sk/__pycache__");
spit("$sk/SKILL.md", "---\nname: planted\ndescription: a skill that carries its own history\n---\nbody\n");
spit("$sk/scripts/run.sh", "echo run\n");
spit("$sk/history/keep.md", "not junk: a visible directory ships\n");
spit("$sk/.arc/SKILL-2026-09-01.md", "an old door, parked\n");
spit("$sk/.arc/SKILL-2026-09-01.md.asc", "-----BEGIN PGP SIGNATURE-----\n");
spit("$sk/.git/HEAD", "ref: refs/heads/main\n");
spit("$sk/__pycache__/x.cpython-314.pyc", "bytecode\n");
my @junk    = qw(.arc/ .git/ __pycache__/);
my @must    = qw(SKILL.md scripts/run.sh history/keep.md);

# -- the checker: a list of relative paths is green iff no junk, every must, in any order ---------
sub check_list {
    my ($who, @rel) = @_;
    my %seen = map { $_ => 1 } @rel;
    my @bad  = grep { my $j = $_; grep { index($_, $j) == 0 } @rel } @junk;
    my @miss = grep { !$seen{$_} } @must;
    return (@bad ? "ships junk: @bad" : @miss ? "drops content: @miss" : "");
}

# -- builder 1: the mint (python) -----------------------------------------------------------------
my $py = qq{import sys; sys.path.insert(0, r"$root")
from pathlib import Path
from polygram import dist
sk = dist.collect(Path(r"$ws/skills"))
assert len(sk) == 1, sk
print("\\n".join(rel for _, rel in dist._staged_files(sk[0])))};
my @mint = lines(`python3 -c '$py' 2>&1`);
my $why = check_list('mint', @mint);
$why ? bad("mint (dist._staged_files) skips .arc .git __pycache__ and keeps history/", $why)
     : good("mint (dist._staged_files) skips .arc .git __pycache__ and keeps history/");

# -- builder 2: the express manifest (sh) ---------------------------------------------------------
my $out = `sh "$sign" manifest "$sk" 2>&1`; $? == 0 or bad("skill-sign.sh manifest runs", "exit ".($? >> 8)." $out");
my @man = map { s{^\S+\s+\./}{}r } grep { /^[0-9a-f]{64}\s+\./ } lines(slurp("$sk/.skill-manifest"));
$why = check_list('manifest', @man);
$why ? bad("express manifest (skill-sign.sh build_manifest) skips the same three and keeps history/", $why)
     : good("express manifest (skill-sign.sh build_manifest) skips the same three and keeps history/");

# -- together: the two builders name the same files -----------------------------------------------
my @m1 = sort @mint; my @m2 = sort grep { $_ ne '.skill-manifest' } @man;
"@m1" eq "@m2" ? good("the mint and the express manifest list the same files (@m1)")
               : bad("mint vs manifest agree", "mint=[@m1] manifest=[@m2]");

# -- prove red: the pre-fix find must read as red ------------------------------------------------
if ($red) {
    my @old = map { s{^\./}{}r } lines(`cd "$sk" && find . -type f ! -name .skill-manifest ! -name .signature.asc -print`);
    my $w = check_list('pre-fix', @old);
    if ($w =~ /ships junk/) { print "PASS: harness goes red under the pre-fix builder ($w)\n"; exit 0 }
    print "FAIL: harness did not go red against the pre-fix find (it said: '$w')\n"; exit 1;
}
print "TOTAL pass=$pass fail=$fail\n"; exit($fail ? 1 : 0);

sub spit  { my ($p, $t) = @_; open my $fh, '>', $p or die "$p: $!"; print {$fh} $t; close $fh }
sub slurp { my $p = shift; open my $fh, '<', $p or return ''; local $/; my $t = <$fh>; close $fh; $t }
sub lines { grep { length } map { s/\r?\n\z//r } split /^/m, (join '', @_) }
