#!/usr/bin/env tclsh
# qg1ck-spec.tcl QG1CK -- the Tcl spec for bin/qg1ck (the question gauge), SPEC QG1-QG3 in
# tests/lane-d-SPEC.txt. Tcl, because the work is sh+awk and the frame's writer is Python: a third
# language builds the frame rows from the contract line in design §2, not from anyone's code.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set qg [lindex $argv 0]
set here [file dirname [file normalize [info script]]]
set gram [file join $here fixtures lane-d qg1ck GRAMMARY.md]
set tmp [file join [expr {[info exists ::env(TMPDIR)] ? $::env(TMPDIR) : "/tmp"}] qg1ck-tcl-[pid]]
file mkdir $tmp
set fails 0
# TS KIND SESSION SPAN LABEL TOKENS_LEFT BY KEY VALUE LIKELIHOOD CONFIDENCE NOTE
proc row {kind label key value lik conf note} {
  return [join [list 2026-10-10T09:00:00Z $kind s1 "" $label "" mentat $key $value $lik $conf $note] "\t"]
}
proc frame {name rows} {
  global tmp
  set f [file join $tmp $name]
  set h [open $f w]; foreach r $rows { puts $h $r }; close $h
  return $f
}
proc run {f} {
  global qg gram
  set code [catch {exec sh $qg --frame $f --grammary $gram} out opts]
  if {$code} { set ec [lindex [dict get $opts -errorcode] 2] } else { set ec 0 }
  return [list $ec $out]
}
proc check {ok what} {
  global fails
  if {[uplevel 1 [list expr $ok]]} { puts "  PASS  $what" } else { puts "  FAIL  $what"; incr fails }
}
proc count {out pattern} {
  if {[regexp $pattern $out -> n]} { return $n } else { return -1 }
}

set f18 [frame f18 [list [row gauge q1 question two medium 0.18 "Shall I go on, and shall I write it down?"]]]
lassign [run $f18] ec out
check {$ec == 1 && [string match "*FAULT*q1*0.18*" $out]} "QG1 a two-question frame at 0.18 is a fault (exit 1)"

set f17 [frame f17 [list [row gauge q2 question two medium 0.17 "Shall I go on, and shall I write it down?"]]]
lassign [run $f17] ec out
check {$ec == 0 && ![string match "*FAULT*" $out]} "QG1 a two-question frame at 0.17 passes"

# SPEC F1-3 (pass 2, P6 O5/J4): his bar is written "17% or less", so a percent is read as a
# fraction: "17%" passes (exactly at the bar), "18%" is a fault, and --bar 17% is the same bar.
set fp17 [frame fp17 [list [row gauge q2p question two medium 17% "Shall I go on, and shall I write it down?"]]]
lassign [run $fp17] ec out
check {$ec == 0 && ![string match "*FAULT*" $out]} "QG1 a two-question frame at 17% passes (his own form, at the bar)"
set fp18 [frame fp18 [list [row gauge q1p question two medium 18% "Shall I go on, and shall I write it down?"]]]
lassign [run $fp18] ec out
check {$ec == 1 && [string match "*FAULT*q1p*18%*" $out]} "QG1 a two-question frame at 18% is a fault"
set code [catch {exec sh $qg --frame $f18 --grammary $gram --bar 17%} out opts]
check {$code != 0 && [string match "*FAULT*q1*" $out]} "QG1 --bar 17% is the same bar as 0.17"

set fnn [frame fnn [list [row gauge q3 question two medium low "Two at once?"]]]
lassign [run $fnn] ec out
check {$ec == 1} "QG1 a two-question frame with no number for its confidence is a fault"

set f1 [frame f1 [list [row gauge q4 question one high 0.9 "Shall I go on?"]]]
lassign [run $f1] ec out
check {$ec == 0} "QG1 a one-question frame is never a fault, whatever its numbers"

set fg0 [frame fg0 [list [row gauge q5 question one high 0.5 "Shall I seat (give it a memory home) this folder?"]]]
set fg1 [frame fg1 [list [row gauge q5 question one high 0.5 "Shall I seat this folder?"]]]
set n0 [count [lindex [run $fg0] 1] {(\d+) GRAMMARY term use}]
set n1 [count [lindex [run $fg1] 1] {(\d+) GRAMMARY term use}]
check {$n0 == 0 && $n1 == 1} "QG2 a question with an unglossed tree word moves the count (glossed $n0, unglossed $n1)"

set fp [frame fp [list [row pref "" skill.seatkeeper.ab12 "no: the folder G:/wheels" "" "" ""] \
                       [row pref "" tone.show words "" "" ""] \
                       [row gauge q6 question one high 0.5 "Go on?"]]]
set h [open $fp r]; set before [read $h]; close $h
lassign [run $fp] ec out
set h [open $fp r]; set after [read $h]; close $h
check {[regexp {2 pref mirror row\(s\), 1 of them a seatkeeper} $out]} \
  "QG3 pref mirror rows are counted (2, one a seatkeeper no)"
check {$before eq $after} "QG3 the frame is never changed"

file delete -force $tmp
exit [expr {$fails ? 1 : 0}]
