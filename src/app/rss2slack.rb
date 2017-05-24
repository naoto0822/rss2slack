require 'sinatra/base'
require 'sinatra/reloader'
require 'json'
require 'logger'
require_relative './rss2slack_handler'
require_relative './conf'
require_relative './db_client'
require_relative './slack_msg_builder'

class Rss2Slack < Sinatra::Base
  configure :production, :development do
    set :show_exceptions, false
  end

  configure :development do
    register Sinatra::Reloader
  end

  before do
    @conf = R2S::Conf.new if @conf.nil?
    @logger = Logger.new(@conf.logger_app_path) if @logger.nil?
    @logger.level = Logger::DEBUG
    @db = R2S::DBClient.new(@logger, @conf) if @db.nil?

    @handler = R2S::Handler.new(@logger, @conf, @db)
  end

  get '/v1/hello' do
    status 200
    body 'i_like_sushi'
  end

  post '/v1/slack/feed' do
    begin
      res =  @handler.handle_slack_feed(headers, request.params)
      handle_response(res)
    rescue => e
      raise e
    end
  end

  after do
    # NOOP
  end

  error do |e|
    if request.path.include?('slack')
      title = env['sinatra.error'].message
      payload = R2S::SlackMsgBuilder::build_for_error("#{title}").to_params.to_json

      status 200
      body payload
    else
      states 500
      body env['sinatra.error'].message
    end
  end

  helpers do
    def handle_response(response)
      status response.code unless response.code.nil?
      headers response.headers unless response.headers.nil?
      body response.body unless response.body.nil?
    end
  end
end
