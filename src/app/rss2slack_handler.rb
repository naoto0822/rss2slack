require_relative './db_client'
require_relative './feed_model'
require_relative './article_model'
require_relative './slack/webhooks'

module R2S
  class Handler
    def initialize(logger, conf)
      @logger = logger
      @conf = conf
      @db = R2S::DBClient.new(logger, conf)
      @feed_model = R2S::FeedModel.new(logger, conf)
    end

    # text
    # 'rss2slack_register, feed_name, url'
    def handle_slack_feed(header, body)
      msg = Slack::OutgoingWebhooks.new(body)

    end

    private

    def validation_outgoing_webhook(msg)

    end

    def handle_response(response)
      status response.status unless response.status.nil?
      headers response.headers unless response.headers.nil? && response.headers.empty?
      body response.body unless response.body.nil?
    end
  end
end
