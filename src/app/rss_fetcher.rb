require 'rss'

module R2S
  class RSSFetcher
    def initialize(logger)
      @logger = logger
      @rss = nil
    end

    def fetch(url)
      return nil if url.nil? || url.empty?
      begin
        @logger.debug("start fetch rss feed from #{url}")
        @rss = request(url)
      rescue => e
        @logger.warn("fail rss feed from #{url}, #{e.message}")
        return nil
      end

      return nil if @rss.nil?
      begin
        results = parse(@rss)
        @logger.debug("success fetch rss feed from #{url}")
        return results
      rescue => e
        @logger.warn("fail parsing feed item", e.message)
        return nil
      end
    end

    private

    def request(url)
      begin
        RSS::Parser.parse(url)
      rescue RSS::InvalidRSSError
        RSS::Parser.parse(url, false)
      rescue => e
        raise e
      end
    end

    def parse(rss)
      article_arr = []
      begin
        rss.items.each do |item|
          title = item.title
          body = item.description
          url = item.link
          pub_date = item.pubDate
          article = R2S::Article.new(title: title, body: body, url: url, pub_date: pub_date)
          article_arr.push article
        end
      rescue => e
        return e
      end
      article_arr
    end
  end
end
