#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'json'
require 'yaml'
require 'optparse'
require_relative '../src/app/conf'

# valid text
# "rss2slack_register, feed_name, url"

conf = R2S::Conf.new(conf_path: "./conf.test.yml")
secret_var = YAML.load_file("../private/rss2slack/external_vars.yml")
url = 'http://192.168.56.40/v1/slack/feed'

args = ARGV.getopts('t:')

if args['t'].nil?
  puts 'Usage: ruby slack_test_client -t <text>'
  exit 1
end

text = args['t']

body = {
  'token' => secret_var["dev_outgoing_webhooks_token"],
  'team_id' => 'Personal',
  'team_domain' => secret_var["dev_accept_team_domain"],
  'channel_id' => secret_var["dev_accept_channel_id"],
  'channel_name' => 'dev-rss2slack',
  'timestamp' => 'timestamp_hoge',
  'user_id' => 'user_id_hoge',
  'user_name' => 'naoto0822',
  'text' => "#{text}",
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

p ':Response'
p res
p ':Status Code'
p res.code
p ':Header'
res.each { |k, v| p "#{k} => #{v}" }
p ':Body'
p res.body
