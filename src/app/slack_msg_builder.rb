require_relative './slack/webhooks.rb'

module R2S
  class SlackMsgBuilder
    def self.build_for_feed
      payload = Slack::IncomingWebhooks::Payload.new
      payload.username = 'Rss2Slack'
      payload.text = 'Successfully fetched feed :tada: '
      payload
    end
  end
end
