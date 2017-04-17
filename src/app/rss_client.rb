require 'rss'

module R2S
  class RSSClient
    def initialize(logger:logger)
      @logger = logger
    end

    def request(url)
      return nil if url.nil? || url.empty?

      articles = []
      rss = RSS::Parser.parse(url)
      begin
        @logger.debug("fetch from #{url}")
        rss.items.each do |item|
          
        end
      rescue

      end
    end

    private

  end
end
