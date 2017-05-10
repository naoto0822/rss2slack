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
      @feed_model = R2S::FeedModel.new(logger, conf)
    end

    def handle_slack_feed(header, body)
      @logger.debug('handle_slack_feed()')
      msg = Slack::OutgoingWebhooks.new(body)

      unless valid_outgoing_webhook?(msg)
        e_msg = "invalid request: #{msg}"
        @logger.warn(e_msg)
        fail_body = R2S::SlackMsgBuilder.build_for_error(e_msg).to_params.to_json
        return R2S::Response.new(400, nil, fail_body)
      end

      if split_post_text(msg.text).nil?
        e_msg = "invalid text: #{msg.text}"
        @logger.warn(e_msg)
        fail_body = R2S::SlackMsgBuilder.build_for_error(e_msg).to_params.to_json
        return R2S::Response.new(400, nil, fail_body)
      end
      
      title, url = split_post_text(msg.text)
      feeds = @feed_model.find_by_url(url)
      if feeds.length >= 1
        e_msg = "already registerd url: #{url}"
        @logger.warn(e_msg)
        fail_body = R2S::SlackMsgBuilder.build_for_error(e_msg).to_params.to_json
        return R2S::Response.new(400, nil, fail_body)
      end

      @feed_model.save(title, url)

      # TODO: return success response
    end

    private

    # text: 'rss2slack_register, feed_name, url'
    def split_post_text(text)
      arr = text.split(/\s*,\s*/)
      return nil if arr.nil? || arr.empty? || arr.size < 3
      title = arr[1]
      url = arr[2]
      [title, url]
    rescue
      @logger.warn("")
      nil
    end

    def valid_outgoing_webhook?(msg)
      false unless @conf.valid_slack_token?(msg.token)
      false unless @conf.valid_accept_team_domain?(msg.team_domain)
      false unless @conf.valid_accept_channel_id?(msg.channel_id)
      true
    end
  end
end
