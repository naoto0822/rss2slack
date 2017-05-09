require_relative './slack/webhooks.rb'
require_relative './date'

module R2S
  class SlackMsgBuilder
    # for feed_runner
    # TODO: rename
    def self.build_for_feed
      payload = Slack::IncomingWebhooks::Payload.new
      payload.username = 'Rss2Slack'
      payload.text = 'Successfully fetched feed :tada: '
      payload
    end

    # for article_runner
    # TODO: rename
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

    # invalid: POST v1/slack/feed
    def self.build_for_invalid_feed(title, url)
      payload = Slack::IncomingWebhooks::Payload.new
      attachment = Slack::IncomingWebhooks::Attachment.new
      now = R2S::Date::now

      attachment.fallback = "Failure register Feed: #{url}"
      attachment.color = 'danger'
      attachment.title = '記事の登録が失敗しました'
      attachment.footer = 'from Rss2Slack'
      attachment.ts = now.to_i

      field = Slack::IncomingWebhooks::Field.new
      field.title = title
      field.value = url
      field.short = false

      attachment.fields = [field]
      payload.attachments = [attachment]
      payload.username = 'Rss2Slack'
      payload.title = 'Failure :tada:'
      payload
    end
  end
end
