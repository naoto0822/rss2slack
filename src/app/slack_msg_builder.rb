require_relative './slack/webhooks.rb'
require_relative './date'

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
      payload = Slack::IncomingWebhooks::Payload.new
      attachment = Slack::IncomingWebhooks::Attachment.new
      now = R2S::Date::now

      attachment.fallback = "Today's Feed"
      attachment.color = 'good'
      attachment.title = "#{now.month}月#{now.day}日の記事 :tada: "
      attachment.footer = 'from Rss2Slack'
      attachment.ts = now.to_i

      fields = []
      articles.each { |a|
        field = Slack::IncomingWebhooks::Field.new
        field.title = a.title
        field.value = a.url
        field.short = false
        fields.push(field)
      }
      attachment.fields = fields

      payload.attachments = [attachment]
      payload.username = 'Rss2Slack'
      payload.text = "Today's Feed :tada: "
      payload
    end
  end
end
