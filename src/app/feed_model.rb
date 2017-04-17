require_relative './feed'

module R2S
  class FeedModel
    def initialize(logger:logger, conf:conf, db:db)
      @logger = logger
      @db = db
    end

    def find_all
      sql = <<-EOS
        SELECT *
          FROM FEED;
      EOS
      results = @db.execute(sql)
      FeedMapper::map(results)
    end

    def save(name, url)
      sql =  <<-EOS
        INSERT INTO 
          FEED (FEED_NAME, URL) 
          VALUES ('#{name}', '#{url}');
      EOS
      re = @db.execute(sql)
    end
  end

  class FeedMapper
    def self.map(results)
      items = []
      results.each do |row|
        id = row["FEED_ID"]
        name = row["FEED_NAME"]
        url = row["URL"]
        feed = R2S::Feed.new(id:id, name:name, url:url)
        items.push feed
      end
      items
    end
  end
end
