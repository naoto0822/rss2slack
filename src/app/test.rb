#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'json'

url = 'http://localhost:8080/v1/slack/feed'

body = {
  "token" => "hogehogetoken",
  "team_id" => "team_id_hoge"
}

uri = URI.parse(url)
req = Net::HTTP::Post.new(uri.path)
req.set_form_data(body)
res = Net::HTTP.start(uri.host, uri.port,
                      use_ssl: uri.scheme == 'https') { |http|
  http.open_timeout = 5
  http.read_timeout = 5
  http.request(req)
}
p res

