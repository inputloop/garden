# gv1mt-spec.rb -- the garden view's spec rows GV1-GV5, GV7, GV8, GV10, GV14, GV16, GV18 (tests/gv1mt-SPEC.txt),
# checked in Ruby, a language apart from the builder (Python) and the recount (awk).
# usage: ruby tests/gv1mt-spec.rb OUTDIR      (OUTDIR holds data.json and index.html)
# One line per row, "ok" or "FAIL"; exit 1 on any FAIL.
#
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
require 'json'
require 'digest'

out = ARGV[0] or abort("usage: ruby gv1mt-spec.rb OUTDIR")
data = JSON.parse(File.read(File.join(out, 'data.json'), encoding: 'utf-8'))
page = File.read(File.join(out, 'index.html'), encoding: 'utf-8')
$bad = 0
def row(id, ok, why)
  puts format('%-5s %-4s %s', ok ? 'ok' : 'FAIL', id, why)
  $bad = 1 unless ok
end

# GV1 sources
src = data['sources'] || []
good = src.all? { |s| s['missing'] ? s['path'] && s['reader'] : (s['sha256'].to_s =~ /\A\h{64}\z/ && s['bytes'].is_a?(Integer)) }
row('GV1', !src.empty? && good, "#{src.size} sources, each with sha256 and bytes or marked missing")

# GV2 envelope
keys = %w[format built sources gardens families nodes edges tensions compass doorways terms counts seal]
miss = keys - data.keys
row('GV2', data['format'] == 'garden-view/data v1' && miss.empty?, "format #{data['format'].inspect}; missing keys: #{miss.join(',').then { |m| m.empty? ? 'none' : m }}")

# GV3 nodes
kinds = %w[skill soft server persona external]
badn = data['nodes'].reject { |n| n['id'] =~ /\A[a-z0-9]+:[^\s:]+\z/ && kinds.include?(n['kind']) }
person = data['nodes'].select { |n| n['name'] =~ /person model/ || n['id'] == 'people' }
row('GV3', badn.empty? && person.empty? && data['counts']['people'].is_a?(Integer),
    "#{data['nodes'].size} nodes; #{badn.size} with a bad id or kind; #{person.size} person models drawn; people counted #{data['counts']['people']}")

# GV4 edges
types = %w[counterpart route hand use slot seam mention vs wraps checks derived-from dangling gap]
bade = data['edges'].reject { |e| e.is_a?(Array) && e.size == 5 && types.include?(e[2]) && e[4].is_a?(Hash) }
badc = data['edges'].select { |e| e[2] == 'checks' && !%w[sheet proposed withheld].include?(e[4]['state']) }
row('GV4', bade.empty? && badc.empty?, "#{data['edges'].size} edges; #{bade.size} malformed; #{badc.size} checks edges without a state word")

# GV5 tensions
t = data['tensions']
wrong = t.reject do |x|
  want = x['src'] == 'errata' ? 'open' : (x['edition'].to_s.start_with?('this') ? 'resolved' : 'open')
  x['state'] == want
end
cards = t.count { |x| x['src'] == 'card' }
row('GV5', wrong.empty? && cards > 0, "#{cards} cards and #{t.size - cards} ERRATA entries; #{wrong.size} with the wrong state")

# GV7 seal: sha256 over the data without its seal, keys sorted, compact, non-ASCII kept
def canon(v)
  case v
  when Hash then '{' + v.keys.sort.map { |k| JSON.generate(k) + ':' + canon(v[k]) }.join(',') + '}'
  when Array then '[' + v.map { |x| canon(x) }.join(',') + ']'
  when Float then (v == v.floor && v.abs < 1e16 ? format('%.1f', v) : v.to_s)
  else JSON.generate(v)
  end
end
d = data.reject { |k, _| k == 'seal' }
got = Digest::SHA256.hexdigest(canon(d))
row('GV7', got == data['seal']['sha256'], "seal #{data['seal']['sha256'][0, 16]}, recomputed #{got[0, 16]}")

# GV8 self-contained
loads = page.scan(/<link\b|\ssrc=|@import|url\(/).size
urls = page.scan(/data-url="([^"]+)"/).flatten
offloop = urls.reject { |u| u =~ %r{\Ahttp://127\.0\.0\.1:(8042|8781)/} }
row('GV8', loads.zero? && offloop.empty? && !urls.empty?, "#{loads} outside loads; probes #{urls.join(' ')}; #{offloop.size} not loopback")

# GV10 state never by colour alone
marks = page.scan(%r{<g class="t (open|resolved)"[^>]*>.*?</g>}m)
marktext = page.scan(%r{<g class="t (?:open|resolved)"[^>]*>(.*?)</g>}m).flatten
worded = marktext.count { |m| m =~ /\s(open|resolved)<\/text>/ }
cells = page.scan(%r{<span class="state-(open|resolved)">[^<]*</span>}).size
cellw = page.scan(%r{<span class="state-(?:open|resolved)">([^<]*)</span>}).flatten.count { |s| s =~ /(open|resolved)\z/ }
row('GV10', marks.size == t.size && worded == marks.size && cells == cellw,
    "#{worded} of #{marks.size} tension marks carry a word (#{t.size} tensions); #{cellw} of #{cells} state cells do")

# GV14 credit
cred = page.include?("Bryant Frankford's <strong>Nexus Skill Tree</strong>")
order = page.index('Corwin Brust and Bryant Frankford share') || -1
holders = data['terms']['holders'] == ['Corwin Brust', 'Bryant Frankford']
row('GV14', cred && order >= 0 && holders, "credit by name: #{cred}; makers in order on the page: #{order >= 0}; terms.holders #{data['terms']['holders'].inspect}")

# GV16 probe badges and no probe until asked
badges = page.scan(%r{<span class="badge[^"]*"[^>]*>([^<]*)</span>}).flatten
bw = badges.count { |b| b =~ /\A(live|as built|not reachable)/ }
js = page[/<script>(.*)<\/script><\/body>/m, 1].to_s
fi = js.index('fetch(') || -1
hi = js.index('button[data-probe]') || 0
nfetch = js.scan('fetch(').size
row('GV16', bw == badges.size && !badges.empty? && nfetch == 1 && fi > hi,
    "#{bw} of #{badges.size} badges read live / as built / not reachable; #{nfetch} fetch, inside the press handler: #{fi > hi}")

# GV18 a default is never shown as this machine's state
stale = ['as built: off', 'as built it is off', 'off as built'].select { |w| page.include?(w) }
gated = data['nodes'].select { |n| n['kind'] == 'server' && n['gate'] }
gstate = gated.reject { |n| n['state'] == 'gated' }
live = page.scan(%r{<pre class="prompt"[^>]*>([^<]*)</pre>}).flatten.any? { |x| x.include?('pref_list') }
row('GV18', stale.empty? && page.include?('off by default') && page.include?('cannot see your setting') && live && gstate.empty?,
    "default-as-state words: #{stale.empty? ? 'none' : stale.join(' | ')}; says off by default: #{page.include?('off by default')}; " \
    "says it cannot see the setting: #{page.include?('cannot see your setting')}; a live-read prompt: #{live}; " \
    "#{gated.size - gstate.size} of #{gated.size} gated servers carry state gated")

puts($bad.zero? ? 'gv1mt-spec: GREEN' : 'gv1mt-spec: RED')
exit $bad
