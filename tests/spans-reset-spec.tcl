#!/usr/bin/env tclsh
# spans-reset-spec.tcl -- the span reset, specified in a third language (extension edition, A1).
#
# SPEC S-R1: a rising token figure is a reset, never a negative count.
#   R1  a mark whose figure rose returns tokens_since_last null and reset true
#   R2  the span's tokens are the sum of its FALLING legs, computed here in Tcl from the ledger bytes
#   R3  the server's report total equals that Tcl sum, and no figure the server returns is negative
#   R4  the server's report says "N resets seen" in words, with the prompt-count caveat
#   R5  bin/sp1rp (awk) gives the same tokens per span as the Tcl sum
#   R6  bin/sp1rp's human view says "N resets seen" too
# Why Tcl: the fault escaped every test before -- the work is Python, the earlier tests Python and
# awk -- so the new spec is in a language that shares no code or habit with either (Corwin's rule,
# 2026-09-14).
#
# usage: tclsh tests/spans-reset-spec.tcl ROOT     (ROOT holds polygram/ and bin/sp1rp)
#        sh tests/spans-reset-tests.sh [--prove-red]  is the wrapper that plants the old subtraction.
# Exit 0 green, 1 red, 2 kit broken.
#
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later

if {[llength $argv] != 1} { puts stderr "usage: tclsh spans-reset-spec.tcl ROOT"; exit 2 }
set root [file normalize [lindex $argv 0]]
set tmp [file join [expr {[info exists ::env(TMPDIR)] ? $::env(TMPDIR) : "/tmp"}] "spans-reset-[pid]"]
file mkdir $tmp [file join $tmp seat]
set ledger [file join $tmp spans.tsv]
close [open $ledger w]
set ::env(MENTCACHED_STATS) $ledger
set ::env(MENTCACHED_SEAT) [file join $tmp seat]
set ::env(MENTCACHED_FRAME) [file join $tmp no-frame]
set ::env(PYTHONDONTWRITEBYTECODE) 1

set red 0
proc ok {id what} { puts "ok   $id $what" }
proc bad {id what why} { global red; incr red; puts "FAIL $id $what -- $why" }

# The calls: W's reproduction (100000, 90000, then 118574 after a user message, stop 110000),
# and a span whose only rise is at the stop.
set calls {[["span_start",{"label":"session","tokens_left":100000}],["span_mark",{"tokens_left":90000}],["span_mark",{"tokens_left":118574}],["span_stop",{"tokens_left":110000}],["span_start",{"label":"tail","tokens_left":50}],["span_stop",{"tokens_left":80}],["span_report",{}]]}
set py [file join $tmp drive.py]
set fh [open $py w]
puts $fh {import json, sys
sys.path.insert(0, sys.argv[1])
from polygram.mcp import mentcached
srv = mentcached.build(by="tcl")
for name, args in json.loads(sys.argv[2]):
    print(json.dumps(srv.call(name, args)))}
close $fh
if {[catch {exec python3 $py $root $calls 2>@1} out]} { puts "kit broken: $out"; exit 2 }
set lines [split [string trim $out] "\n"]
if {[llength $lines] != 7} { puts "kit broken: want 7 answers, got [llength $lines]: $out"; exit 2 }

# R1 -- the second mark (answer 3) rose
set m2 [lindex $lines 2]
if {[regexp {"tokens_since_last": null} $m2] && [regexp {"reset": true} $m2]} {
    ok R1 "a rising mark is flagged, not subtracted"
} else { bad R1 "a rising mark is flagged, not subtracted" [string range $m2 0 200] }

# R2 -- Tcl's own arithmetic from the ledger bytes: per span, sum the falling legs
set fh [open $ledger r]; set rows [split [string trimright [read $fh] "\n"] "\n"]; close $fh
array set last {}; array set spent {}; array set resets {}; set order {}
foreach row $rows {
    set f [split $row "\t"]
    if {[llength $f] < 7 || [lindex $f 0] eq "ts"} continue
    lassign $f ts ev span label tok
    if {$ev eq "start"} { lappend order $span; set spent($span) 0; set resets($span) 0; set last($span) $tok; continue }
    if {$tok eq ""} continue
    if {$last($span) ne "" && $tok > $last($span)} { incr resets($span) } elseif {$last($span) ne ""} { incr spent($span) [expr {$last($span) - $tok}] }
    set last($span) $tok
}
set want_total 0; set want_resets 0
foreach s $order { incr want_total $spent($s); incr want_resets $resets($s) }
set stop1 [lindex $lines 3]
if {[regexp {"tokens_used": (-?\d+)} $stop1 -> u] && $u == $spent([lindex $order 0])} {
    ok R2 "span tokens are the falling legs ($u)"
} else { bad R2 "span tokens are the falling legs" "server said [expr {[info exists u] ? $u : {nothing}}], Tcl sums $spent([lindex $order 0])" }

# R3 -- report total equals the Tcl sum; nothing negative anywhere
set rep [lindex $lines 6]
regexp {"tokens": (-?\d+)} $rep -> rt
if {[info exists rt] && $rt == $want_total && ![regexp {"tokens_(used|since_last|since_start)": -\d} $out]} {
    ok R3 "report total = Tcl sum ($rt), no negative count"
} else { bad R3 "report total = Tcl sum, no negative count" "report [expr {[info exists rt] ? $rt : {?}}] vs Tcl $want_total" }

# R4 -- in words
set w "$want_resets resets seen"
if {[string first $w $rep] >= 0 && [string first "counted from resets; the app's own housekeeping can add a reset, so this count may run high" $rep] >= 0} {
    ok R4 "the report says '$w' with the caveat"
} else { bad R4 "the report says '$w' with the caveat" [string range $rep end-300 end] }

# R5 / R6 -- the awk reader on the same bytes
set sp1rp [file join $root bin sp1rp]
if {[catch {exec sh $sp1rp --ledger $ledger --tsv} tsv]} { bad R5 "sp1rp runs" $tsv } else {
    set agree 1
    foreach l [split $tsv "\n"] {
        set f [split $l "\t"]
        set s [lindex $f 0]; set t [lindex $f 5]
        if {![info exists spent($s)] || $t ne $spent($s)} { set agree 0 }
    }
    if {$agree} { ok R5 "sp1rp agrees with Tcl per span" } else { bad R5 "sp1rp agrees with Tcl per span" $tsv }
}
if {[catch {exec sh $sp1rp --ledger $ledger} human]} { bad R6 "sp1rp human view" $human } elseif {[string first $w $human] >= 0} {
    ok R6 "sp1rp says '$w'"
} else { bad R6 "sp1rp says '$w'" $human }

file delete -force $tmp
if {$red == 0} { puts "GREEN spans-reset: 6/6"; exit 0 }
puts "RED spans-reset: $red failing"; exit 1
