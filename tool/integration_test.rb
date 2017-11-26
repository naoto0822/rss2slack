#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'json'
require 'yaml'
require 'openssl'
require 'logger'

# constants
TARGET_DOMAIN = 'staging.rss2slack.co.jp'.freeze
SECRET_VAR_RELATIVE_PATH = '../private/rss2slack/secret_vars.yml'.freeze
CHANNEL_NAME = 'dev-rss2slack'.freeze
TRIGGER_WORD = 'rss2slack_register'.freeze
CERT_FILE_RELATIVE_PATH = '../private/rss2slack/staging_rss2slack.crt'.freeze

def secret_var
  path = File.expand_path(SECRET_VAR_RELATIVE_PATH, File.dirname(__FILE__))
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

def cert_file
  File.expand_path(CERT_FILE_RELATIVE_PATH, File.dirname(__FILE__))
end

def get(url)
  uri = URI.parse(url)
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
  https = Net::HTTP.new(uri.host, uri.port)
  https.open_timeout = 5
  https.read_timeout = 5
  https.use_ssl = (uri.scheme == "https")
  https.verify_mode = OpenSSL::SSL::VERIFY_PEER
  https.verify_depth = 5
  https.ca_file = cert_file
  res = https.start { |h|
    h.request(req)
  }
  res
rescue => e
  e
end

def failure(msg, logger)
  logger.error("#{msg}")
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

def setup
  @logger = Logger.new(STDOUT)
  @base_url = "https://#{TARGET_DOMAIN}"
  @var = secret_var
end

# valid text
# "rss2slack_register, feed_name, url"
def work
  setup

  # status
  status_url = @base_url + "/status"
  res = get(status_url)
  output_res(res, @logger)

  if res.code.to_i != 200
    msg = 'resposne code is not 200'
    failure(msg, @logger)
  end

  if res.body != 'ok'
    msg = 'response body is not ok'
    failure(msg, @logger)
  end

  # slack/feed
  register_url = @base_url + '/v1/slack/feed'
  text = 'rss2slack_register, markezine, https://markezine.jp/rss/new/20/index.xml'
  body = make_body(@var, text)
  res = post(register_url, body)
  output_res(res, @logger)
  # {"attachments":[{"fallback":"successflluy registerd markezine","color":"good","fields":[{"title":"successflluy registerd markezine","short":false}],"footer":"from Rss2Slack","ts":1511707196}],"username":"Rss2Slack"}

  @logger.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@')
  @logger.debug('@                                @')
  @logger.debug('@ Successfully integration test! @')
  @logger.debug('@                                @')
  @logger.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@')
end

work
