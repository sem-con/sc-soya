#!/usr/bin/env ruby
# encoding: utf-8

# gem install 'json-canonicalization'

require 'Multibases'
require 'Multihashes'
require 'digest'
require 'json/canonicalization'
require 'optparse'

# commandline options
options = { }
opt_parser = OptionParser.new do |opt|

  options[:doc_type] = 0 # 0 = layer
  opt.on("-l","--layer","document is a layer (base or overlay)") do |v|
    options[:doc_type] = 0
  end
  opt.on("-i","--instance","document is an instance") do |v|
    options[:doc_type] = 1 # 1 = instance
  end
end
opt_parser.parse!

input = []
ARGF.each_line { |line| input << line }
input = input.join("\n")
raw = JSON.parse(input)

if options[:doc_type].to_s == "0"
	# document is a layer (base or overlay)
	raw["@context"].delete("@base") rescue nil
else
	# document is an instance
	raw["@graph"].map{|i| i.delete("@id") rescue nil} rescue nil
end
puts Multibases.pack("base58btc", Multihashes.encode(Digest::SHA256.digest(raw.to_json_c14n), "sha2-256").unpack('C*')).to_s