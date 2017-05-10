#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'json'

hash = { "Ocean" => { "Squid" => 10, "Octopus" =>8 }}

p hash.to_json
p JSON.generate(hash)

text = 'hoge, hoge,foo ,aaa'

p text.split(/\s*,\s*/)

def title_url
  ["aaa", "bbbb"]
end

title, url = title_url

p "----------"
p title
p url

