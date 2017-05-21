require_relative './db_client'
require_relative './feed_model'
require_relative './article_model'
require_relative './slack/webhooks'
require_relative './response'
require_relative './slack_msg_builder'

module R2S
  class Handler
    def initialize(logger, conf)
      @logger = logger
      @conf = conf
      @db = R2S::DBClient.new(logger, conf)
      @feed_model = R2S::FeedModel.new(logger, @db)
    end

    def handle_slack_feed(headers, body)
      @logger.debug('start handle_slack_feed()')
      data = Slack::OutgoingWebhooks.new(body)

      unless valid_outgoing_webhook?(data)
        msg = "invalid request: #{data}"
        @logger.warn(msg)
        return bad_request_response(msg)
      end

      if split_post_text(data.text).nil?
        msg = "invalid text: #{data.text}"
        @logger.warn(msg)
        return bad_request_response(msg)
      end
      
      title, url = split_post_text(data.text)
      feeds = @feed_model.find_by_url(url)
      if feeds.length >= 1
        msg = "already registerd url: #{url}"
        @logger.warn(msg)
        return ok_response(msg)
      end

      @feed_model.save(title, url)
      @logger.debug("finish handle_slack_feed(), text: #{text}")
      ok_response("successflluy registerd #{title}")
    end

    private

    def ok_response(msg)
      body = R2S::SlackMsgBuilder.build_for_success(msg).to_params.to_json
      R2S::Response::create_ok(nil, body)
    end

    def bad_request_response(msg)
      body = R2S::SlackMsgBuilder.build_for_error(msg).to_params.to_json
      R2S::Response::create_bad_request(nil, body)
    end

    # text: 'rss2slack_register, feed_name, url'
    def split_post_text(text)
      arr = text.split(/\s*,\s*/)
      return nil if arr.nil? || arr.empty? || arr.size < 3
      title = arr[1]
      url = arr[2]
      [title, url]
    rescue
      @logger.warn("failure split post text")
      nil
    end

    def valid_outgoing_webhook?(data)
      false unless @conf.valid_slack_token?(data.token)
      false unless @conf.valid_accept_team_domain?(data.team_domain)
      false unless @conf.valid_accept_channel_id?(data.channel_id)
      true
    end
  end
end
