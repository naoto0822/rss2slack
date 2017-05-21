require 'sinatra/base'
require 'json'
require_relative './rss2slack_handler'
require_relative './conf'

class Rss2Slack < Sinatra::Base
  before do
    logger.level = Logger::DEBUG
    @conf = R2S::Conf.new
    @handler = R2S::Handler.new(logger, @conf)
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

  def handle_response(response)
    status response.status unless response.status.nil?
    headers response.headers unless response.headers.nil? && response.headers.empty?
    body response.body unless response.body.nil?
  end
end
