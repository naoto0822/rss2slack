require_relative './slack/webhooks.rb'
require_relative './date'

module R2S
  class SlackMsgBuilder
    def self.build_for_article_runner(articles)
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
      payload
    end

    def self.build_for_success(title)
      payload = Slack::IncomingWebhooks::Payload.new
      attachment = Slack::IncomingWebhooks::Attachment.new
      now = R2S::Date::now

      attachment.fallback = title
      attachment.color = 'good'
      attachment.footer = 'from Rss2Slack'
      attachment.ts = now.to_i

      field = Slack::IncomingWebhooks::Field.new
      field.title = title
      field.short = false

      attachment.fields = [field]
      payload.attachments = [attachment]
      payload.username = 'Rss2Slack'
      payload
    end

    def self.build_for_error(title)
      payload = Slack::IncomingWebhooks::Payload.new
      attachment = Slack::IncomingWebhooks::Attachment.new
      now = R2S::Date::now

      attachment.fallback = title
      attachment.color = 'danger'
      attachment.footer = 'from Rss2Slack'
      attachment.ts = now.to_i

      field = Slack::IncomingWebhooks::Field.new
      field.title = title
      field.short = false

      attachment.fields = [field]
      payload.attachments = [attachment]
      payload.username = 'Rss2Slack'
      payload
    end
  end
end
