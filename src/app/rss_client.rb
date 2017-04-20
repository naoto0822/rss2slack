require 'rss'

module R2S
  class RSSClient
    def initialize(logger:logger)
      @logger = logger
    end

    def request(url)
      return nil if url.nil? || url.empty?

      articles = []
      rss = nil
      begin
        @logger.debug("fetch rss feed from #{url}")
        rss = RSS::Parser.parse(url)
      rescue RSS::InvalidRSSError
        rss = RSS::Parser.parse(url, false)
      rescue => e
        @logger.warn("fail rss feed from #{url}", e.message)
        return nil
      end

      begin
        return nil if rss.nil?
        rss.items.each do |item|
          p item
        end
      rescue => e
        @logger.warn("fail parsing feed item", e.message)
      end

      articles
    end

    private

  end
end
