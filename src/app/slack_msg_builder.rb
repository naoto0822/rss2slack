require_relative './slack/webhooks.rb'

module R2S
  class SlackMsgBuilder
    # for feed_runner
    def self.build_for_feed
      payload = Slack::IncomingWebhooks::Payload.new
      payload.username = 'Rss2Slack'
      payload.text = 'Successfully fetched feed :tada: '
      payload
    end

    # for article_runner
    def self.build_for_article(articles)
      # TODO
    end
  end
end
