#!/usr/bin/env ruby
require_relative './slack/webhooks'

field1 = Slack::IncomingWebhooks::Field.new
field1.title = "Article1"
field1.value = "https://google.com"
field1.short = false
field2 = Slack::IncomingWebhooks::Field.new
field2.value = "http://yahoo.co.jp"
field2.short = false

attachment = Slack::IncomingWebhooks::Attachment.new
attachment.fallback = "Required plain-text summary of the attachment."
attachment.color = "good"
attachment.title = "8月22日の記事"
attachment.fields = [field1, field2]
attachment.footer = "from Rss2Slack"
attachment.ts = 123456789

payload = Slack::IncomingWebhooks::Payload.new
payload.username = "Rss2Slack"
payload.text = "Today's Feed :tada:"
payload.attachments = [attachment]

slack = Slack::IncomingWebhooks::Client.new(ENV['incoming_webhooks_url'])
re = slack.post(payload)
p re
