require_relative './db_client'
require_relative './feed_model'
require_relative './feed.rb'
require_relative './article_model'
require_relative './article'
require_relative './rss_fetcher'

module R2S
  class FeedRunner
    def initalize(logger: logger, conf: conf)
      @logger = logger
      @conf = conf
      @db = R2S::DBClient.new(logger: logger, conf: conf)
      @feed_model = R2S::FeedModel.new(logger: logger, db: @db)
      @article_model = R2S::ArticleModel.new(logger: logger, db: @db)
      @rss = R2S::RSSFetcher.new(logger: logger)
    end

    def run
      @logger.debug('start running FeedRunner.')
      feeds = @feed_model.find_all
      feeds.each do |f|
        next if f.url.nil?
        articles = @rss.fetch(f.url)
        articles.each { |a| @article_model.save(a) } #TODO: bulk insert
      end

      # fetch today article.

      # post slack
      
      @logger.debug('finish running FeedRunner.')
    end

    def fetch_articles

    end

    def post_slack

    end
  end
end

