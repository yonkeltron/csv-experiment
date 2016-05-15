#!/usr/bin/env ruby

awk = '"x"' + (1..100).to_a.map {|i| "$#{i}" }.join('"x,x"') + '"x"'

puts awk
