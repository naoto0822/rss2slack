require_relative './spec_helper'
require_relative '../src/app/rss2slack_handler'
require 'logger'

class MockOutgoingMessage
  def self.body(other)
    base = {
      :token => 'TEST_TOKEN', # valid
      :team_id => 'TEST',
      :team_domain => 'test.domain', # valid
      :channel_id => 'channel_id', # valid
      :channel_name => 'test-rss2slack',
      :timestamp => 'timestamp_hoge',
      :user_id => 'user_id_hoge',
      :user_name => 'me',
      :text => 'rss2slack_register',
      :trigger_word => 'rss2slack_register, hoge, http://hoge.com'
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
    @feed_model = nil
  end

  describe 'invalid request' do
    it 'invalid token' do
      headers = {}
      invalid_token = { :token => 'INVALID' }
      body = MockOutgoingMessage::body(invalid_token)

      allow(@feed_model).to receive(:find_by_url).and_return([])
      allow(@feed_model).to receive(:save).and_return(true)

      handler = R2S::Handler.new(@logger, @conf, @feed_model)
      res = handler.handle_slack_feed(headers, body)
      
      expect(res.code).to eq 400
      expect(res.headers).to eq nil
      expect(res.body).to eq ''
    end

    it 'invalid team domain' do
      headers = {}
      invalid_team_domain = { :team_domain => 'INVALID' }
      body = MockOutgoingMessage::body(invalid_team_domain)

      allow(@feed_model).to receive(:find_by_url).and_return([])
      allow(@feed_model).to receive(:save).and_return(true)

      handler = R2S::Handler.new(@logger, @conf, @feed_model)
      res = handler.handle_slack_feed(headers, body)

      expect(res.code).to eq 400
      expect(res.headers).to eq nil
      expect(res.body).to eq ''
    end

    it 'invalid channel id' do
      headers = {}
      invalid_channel_id = { :channel_id => 'INVALID' }
      body = MockOutgoingMessage::body(invalid_channel_id)

      allow(@feed_model).to receive(:find_by_url).and_return([])
      allow(@feed_model).to receive(:save).and_return(true)

      handler = R2S::Handler.new(@logger, @conf, @feed_model)
      res = handler.handle_slack_feed(headers, body)

      expect(res.code).to eq 400
      expect(res.headers).to eq nil
      expect(res.body).to eq ''
    end
  end

  # TODO:
  it 'normal test' do
  end
end
