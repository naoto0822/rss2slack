require_relative './spec_helper'
require_relative '../src/app/rss2slack_handler'
require 'logger'

class MockOutgoingMessage
  def self.normal_body(other)
    base = {
      'token' => 'TEST_TOKEN', # valid
      'team_id' => 'TEST',
      'team_domain' => 'test.domain', # valid
      'channel_id' => 'channel_id', # valid
      'channel_name' => 'test-rss2slack',
      'timestamp' => 'timestamp_hoge',
      'user_id' => 'user_id_hoge',
      'user_name' => 'me',
      'text' => 'rss2slack_register',
      'trigger_word' => 'rss2slack_register'
    }
    base.merge(other)
  end
end

describe R2S::Handler do
  before(:each) do
    ENV['env'] = 'test'
    @conf = R2S::Conf.new
    @logger = Logger.new(STDOUT)
    @db = Object.new
    @feed_model = R2S::FeedModel.new(@logger, @db)
  end

  after(:each) do
    # NOOP
  end

  it 'valid request' do
    headers = {}
    invalid_token = { 'token' => 'INVALID' }
    body = MockOutgoingMessage::normal_body(invalid_token)

    allow(@feed_model).to receive(:find_by_url).and_return([])
    allow(@feed_model).to receive(:save).and_return(true)

    handler = R2S::Handler.new(@logger, @conf, @feed_model)
    res = handler.handle_slack_feed(headers, body)
  end

  # TODO:
  it 'normal test' do
    result = []
    allow(@feed_model).to receive(:find_by_url).and_return(result)
    allow(@feed_model).to receive(:save).and_return(true)
  end
end
