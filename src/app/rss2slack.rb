require 'sinatra/base'
require 'json'
require 'logger'
require_relative './rss2slack_handler'
require_relative './conf'
require_relative './db_client'

class Rss2Slack < Sinatra::Base
  configure :production, :development do
    # NOOP
  end

  before do
    @conf = R2S::Conf.new if @conf.nil?
    @logger = Logger.new(@conf.logger_path) if @logger.nil?
    @logger.level = Logger::DEBUG
    @db = R2S::DBClient.new(@logger, @conf) if @db.nil?

    @handler = R2S::Handler.new(@logger, @conf, @db)
  end

  get '/v1/hello' do
    status 200
    body 'i_like_sushi'
  end

  post '/v1/slack/feed' do
    res =  @handler.handle_slack_feed(headers, request.params)
    handle_response(res)
  end

  after do
    # NOOP
  end

  # move helper?
  def handle_response(response)
    status response.status unless response.status.nil?
    headers response.headers unless response.headers.nil? && response.headers.empty?
    body response.body unless response.body.nil?
  end
end
