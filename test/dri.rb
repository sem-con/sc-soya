#!/usr/bin/env ruby
# encoding: utf-8

# gem install 'json-canonicalization'

require 'Multibases'
require 'Multihashes'
require 'digest'
require 'json/canonicalization'

input = []
ARGF.each_line { |line| input << line }
input = input.join("\n")
raw = JSON.parse(input)

puts Multibases.pack("base58btc", Multihashes.encode(Digest::SHA256.digest(raw.to_json_c14n), "sha2-256").unpack('C*')).to_s