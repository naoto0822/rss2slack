require_relative './db_client'
require_relative './feed_model'
require_relative './article_model'
require_relative './rss_fetcher'
require_relative './slack/webhooks.rb'
require_relative './slack_msg_builder'

module R2S
  class FeedRunner
    def initalize(logger, conf)
      @logger = logger
      @conf = conf
      @db = R2S::DBClient.new(logger, conf)
      @feed_model = R2S::FeedModel.new(logger, @db)
      @article_model = R2S::ArticleModel.new(logger, @db)
      @rss = R2S::RSSFetcher.new(logger)
      @slack = Slack::IncomingWebhooks::Client.new(ENV['incoming_webhooks_url'])
    end

    def run
      @logger.debug('start running FeedRunner.')
      feeds = @feed_model.find_all
      feeds.each do |f|
        next if f.url.nil?
        articles = @rss.fetch(f.url)
        articles.each { |a| @article_model.save(a) } #TODO: bulk insert
      end

      post_slack
      @logger.debug('finish running FeedRunner.')
    end

    def post_slack
      payload = R2S::SlackMsgBuilder::build_for_feed
      @slack.post(payload)
    end
  end
end
