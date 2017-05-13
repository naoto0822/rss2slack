#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'json'
require_relative './slack_msg_builder.rb'
require_relative './slack/webhooks.rb'
require_relative './conf.rb'
require_relative './article.rb'

ENV['env'] = 'local'
conf = R2S::Conf.new
slack = Slack::IncomingWebhooks::Client.new(conf.webhook_url)

article = R2S::Article.new(title:"sssssssshoge", url:"http://yahoo.co.jpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
article2 = R2S::Article.new(title:"hogggggggggggggge", url:"http://yahoo.co.jffffffffffffffffffffffffp")
article3 = R2S::Article.new(title:"hoge", url:"http://yahoo.co.jprrrrrrrrrrrrrrrrrrrrrr")

payload = R2S::SlackMsgBuilder.build_for_article_runner([article, article2, article3])
slack.post(payload)

