require_relative './db_client'
require_relative './feed_model'
require_relative './feed.rb'
require_relative './rss_client'

module R2S
  class Runner
    def initalize(logger:logger, conf:conf)
      @logger = logger
      @conf = conf
      @db = R2S::DBClient.new(logger:logger, conf:conf)
      @feed_model = R2S::FeedModel.new(logger:logger, conf:conf, db:@db)
      @rss = R2S::RssClient.new(logger:logger)
    end

    def run
      articles = []
      feeds = @feed_model.find_all
      feeds.each do |f|

      end

      # post slack
    end
  end
end

