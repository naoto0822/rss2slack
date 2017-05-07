#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'json'

# TODO: yaml load

url = 'http://localhost:8080/v1/slack/feed'

body = {
  'token' => 'token_hoge',
  'team_id' => 'team_id_hoge',
  'team_domain' => 'team_domain_hoge',
  'channel_id' => 'channel_id_hoge',
  'channel_name' => 'channel_name_hoge',
  'timestamp' => 'timestamp_hoge',
  'user_id' => 'user_id_hoge',
  'user_name' => 'user_name_hoge',
  'text' => 'text_hoge',
  'trigger_word' => 'trigger_word_hoge'
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

