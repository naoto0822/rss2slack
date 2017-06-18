require_relative './spec_helper'
require_relative '../src/app/rss2slack_handler'
require_relative '../src/app/feed'
require 'logger'
require 'json'

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

class MockFeedModel
  def initialize
    @feed_arr = []
  end
  def find_by_url(url)
    re = []
    @feed_arr.each { |feed|
      re.push(feed) if feed.url == url
    }
    re
  end
  def save(name, url)
    feed = R2S::Feed.new(name: name, url: url)
    @feed_arr.push(feed)
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

  describe 'invalid post text' do
    it 'nil text' do
      headers = {}
      nil_text = { :text => nil }
      body = MockOutgoingMessage::body(nil_text)

      allow(@feed_model).to receive(:find_by_url).and_return([])
      allow(@feed_model).to receive(:save).and_return(true)

      handler = R2S::Handler.new(@logger, @conf, @feed_model)
      res = handler.handle_slack_feed(headers, body)

      expect(res.code).to eq 400
      expect(res.headers).to eq nil
      expect(res.body).to eq ''
    end

    it 'empty text' do
      headers = {}
      empty_text = { :text => '' }
      body = MockOutgoingMessage::body(empty_text)

      allow(@feed_model).to receive(:find_by_url).and_return([])
      allow(@feed_model).to receive(:save).and_return(true)

      handler = R2S::Handler.new(@logger, @conf, @feed_model)
      res = handler.handle_slack_feed(headers, body)

      expect(res.code).to eq 400
      expect(res.headers).to eq nil
      expect(res.body).to eq ''
    end

    it 'not command' do
      headers = {}
      not_command_text = { :text => 'hahaha' }
      body = MockOutgoingMessage::body(not_command_text)

      allow(@feed_model).to receive(:find_by_url).and_return([])
      allow(@feed_model).to receive(:save).and_return(true)

      handler = R2S::Handler.new(@logger, @conf, @feed_model)
      res = handler.handle_slack_feed(headers, body)

      expect(res.code).to eq 400
      expect(res.headers).to eq nil
      expect(res.body).to eq ''
    end

    it 'command short args' do
      headers = {}
      shorter_text = { :text => 'rss2slack_register, media' }
      body = MockOutgoingMessage::body(shorter_text)

      allow(@feed_model).to receive(:find_by_url).and_return([])
      allow(@feed_model).to receive(:save).and_return(true)

      handler = R2S::Handler.new(@logger, @conf, @feed_model)
      res = handler.handle_slack_feed(headers, body)

      expect(res.code).to eq 400
      expect(res.headers).to eq nil
      expect(res.body).to eq ''
    end
  end

  describe 'normal request' do
    it 'new register text' do
      headers = {}
      media = 'hoge_media'
      command = { :text => "rss2slack_register, #{media}, http://yahoo.co.jp" }
      body = MockOutgoingMessage::body(command)

      mock_model = MockFeedModel.new
      handler = R2S::Handler.new(@logger, @conf, mock_model)
      res = handler.handle_slack_feed(headers, body)

      expect(res.code).to eq 200
      expect(res.headers).to eq nil

      body = JSON.parse(res.body)
      expect(body['username']).to eq 'Rss2Slack'

      attachments = body['attachments']
      attachment = attachments[0]
      expect(attachment['fallback']).to eq "successflluy registerd #{media}"
      expect(attachment['color']).to eq 'good'
      expect(attachment['fields']).not_to eq nil
      expect(attachment['footer']).to eq 'from Rss2Slack'
    end
  end
end
