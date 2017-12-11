require_relative './db_client'
require_relative './feed_model'
require_relative './article_model'
require_relative './slack/webhooks'
require_relative './response'
require_relative './slack_msg_builder'

module R2S
  class Handler
    REGISTER_COMMAND = 'rss2slack_register'.freeze
    UPDATE_COMMAND = 'rss2slack_update'.freeze
    DELETE_COMMAND = 'rss2slack_delete'.freeze
    HELP_COMMAND = 'rss2slack_help'.freeze

    def initialize(logger, conf, feed_model)
      @logger = logger
      @conf = conf
      @feed_model = feed_model
    end

    def handle_slack_feed(headers, body)
      @logger.debug('start handle_slack_feed()')
      if body.nil?
        @logger.warn('request body is nil')
        return bad_request_response
      end

      data = Slack::OutgoingWebhooks::Message.new(body)

      unless valid_outgoing_webhook?(data)
        @logger.warn("invalid request: #{data.inspect}")
        return bad_request_response
      end

      if split_post_text(data.text).nil?
        @logger.warn("invalid text: #{data.text}")
        return bad_request_response
      end

      texts = split_post_text(data.text)

      res = nil
      case texts[0]
      when REGISTER_COMMAND
        res = handle_slack_register_feed(data, texts)
      when UPDATE_COMMAND
        res = handle_slack_update_feed(data, texts)
      when DELETE_COMMAND
        res = handle_slack_delete_feed(data, texts)
      when HELP_COMMAND
        res = handle_slack_help
      else
        res = bad_request_response
      end

      @logger.debug('finish handle_slack_feed()')
      res
    rescue => e
      @logger.error("error handle_slack_feed(), #{e}")
      raise e
    end

    private

    def handle_slack_register_feed(data, texts)
      @logger.debug('start handle_slack_register_feed()')
      # FIXME: 3?
      if texts.length < 3
        @logger.warn('texts size shorter than 3')
        return bad_request_response
      end

      title = texts[1]
      url = texts[2]
      valid_url = wash_url(url)
      if valid_url.nil?
        @logger.warn("failure replace unnecessary char: #{url}")
        return bad_request_response
      end

      feeds = @feed_model.find_by_url(valid_url)
      if feeds.length >= 1
        return ok_response("already registerd url: #{valid_url}")
      end

      @feed_model.save(title, valid_url)
      @logger.debug("finish handle_slack_register_feed(), text: #{data.text}")
      ok_response("successflluy registerd #{title}")
    end

    # TODO:
    def handle_slack_update_feed(data, texts)
      ok_response('Unimplemented rss2slack_update command')
    end

    # TODO:
    def handle_slack_delete_feed(data, texts)
      ok_response('Unimplemented rss2slack_delete command')
    end

    # TODO:
    def handle_slack_help
      ok_response('Unimplemented rss2slack_help command')
    end

    def ok_response(msg)
      body = R2S::SlackMsgBuilder.build_for_success(msg).to_params.to_json
      R2S::Response::create_ok(nil, body)
    end

    def bad_request_response
      # return empty body
      body = ''
      R2S::Response::create_bad_request(nil, body)
    end

    # example:
    #   'rss2slack_register, feed_name, url'
    #   'rss2slack_update, url'
    #   'rss2slack_delete, url'
    #   'rss2slack_help'
    def split_post_text(text)
      arr = text.split(/\s*,\s*/)
      return nil if arr.nil? || arr.empty?
      arr
    rescue
      @logger.warn('failure split post text')
      nil
    end

    def wash_url(url)
      url.gsub!(/</, "")
      url.gsub!(/>/, "")
      url
    rescue
      nil
    end

    def valid_outgoing_webhook?(data)
      return false unless @conf.valid_slack_token?(data.token)
      return false unless @conf.valid_accept_team_domain?(data.team_domain)
      return false unless @conf.valid_accept_channel_id?(data.channel_id)
      true
    end
  end
end
