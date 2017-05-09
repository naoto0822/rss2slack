#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'json'
require 'yaml'

conf_path = '../deploy/rss2slack/conf.local.yml'
conf = YAML.load_file(conf_path)
token = conf['slack']['outgoing_webhooks_token']

url = 'http://localhost:8080/v1/slack/feed'

body = {
  'token' => "#{token}",
  'team_id' => 'Personal',
  'team_domain' => 'personal-naoto0822.slack.com',
  'channel_id' => 'channel_id_hoge',
  'channel_name' => 'dev-rss2slack',
  'timestamp' => 'timestamp_hoge',
  'user_id' => 'user_id_hoge',
  'user_name' => 'naoto0822',
  'text' => 'text_hoge',
  'trigger_word' => 'rss2slack_register'
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

