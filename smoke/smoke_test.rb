#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'json'
require 'yaml'
require 'optparse'
require 'openssl'
require 'logger'

# constants
TARGET_DOMAIN = 'staging.rss2slack.co.jp'.freeze
SECRET_VAR_FILE = '../private/rss2slack/external_vars.yml'.freeze
CHANNEL_NAME = 'dev-rss2slack'.freeze
TRIGGER_WORD = 'rss2slack_register'.freeze
CERT_FILE_PATH = '../private/rss2slack/staging_rss2slack.crt'.freeze

def secret_var(path:nil)
  path = SECRET_VAR_FILE if path.nil?
  YAML.load_file(path)
rescue => e
  e
end

def make_body(vars, text)
  now = Time.now.to_i
  {
    'token' => vars["dev_outgoing_webhooks_token"],
    'team_id' => 'Personal',
    'team_domain' => vars["dev_accept_team_domain"],
    'channel_id' => vars["dev_accept_channel_id"],
    'channel_name' => CHANNEL_NAME,
    'timestamp' => "#{now}",
    'user_id' => '1234567890',
    'user_name' => 'naoto0822',
    'text' => "#{text}",
    'trigger_word' => TRIGGER_WORD
  }
end

def get(url)
  uri = URL.parse(url)
  req = Net::HTTP::Get.new(uri.path)
  request(uri, req)
end

def post(url, body)
  uri = URI.parse(url)
  req = Net::HTTP::Post.new(uri.path)
  req.set_form_data(body)
  request(uri, req)
end

def request(uri, req)
  res = Net::HTTP.start(uri.host, uri.port,
                        use_ssl: uri.scheme == 'https') { |http|
    http.open_timeout = 5
    http.read_timeout = 5
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http.ca_file = CERT_FILE_PATH
    http.request(req)
  }
  res
rescue => e
  e
end

def fail(e, logger)
  logger.fail(["#{e.class}", "#{e.message}"].join(': '))
  exit 1
end

def output_res(res, logger)
  logger.debug(':Response')
  logger.debug(res)
  logger.debug(':Status Code')
  logger.debug(res.code)
  logger.debug(':Header')
  res.each { |k, v| logger.debug("#{k} => #{v}") }
  logger.debug(':Body')
  logger.debug(res.body)
end

# valid text
# "rss2slack_register, feed_name, url"
def work
  args = ARGV.getopts('t:')

  if args['t'].nil?
    puts 'Usage: ruby slack_test_client -t <text>'
    exit 1
  end

  text = args['t']

  logger = Logger.new(STDOUT)
  base_url = "https://#{TARGET_DOMAIN}"

  # status
  status_url = url + "/status"
  res = get(status_url)
  output_res(res, logger)

  # slack/feed


end

work

