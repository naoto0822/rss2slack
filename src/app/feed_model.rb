require_relative './feed'

module R2S
  class FeedModel
    def initialize(logger, db)
      @logger = logger
      @db = db
    end

    # TODO: order
    def find_all
      sql = <<-EOS
        SELECT *
          FROM FEED;
      EOS
      results = @db.execute(sql)
      FeedMapper::map(results)
    end

    def find_by_url(url)
      sql = <<-EOS
        SELECT
          *
        FROM
          FEED
        WHERE
          URL = '#{url}'
        LIMIT 1;
      EOS
      results = @db.execute(sql)
      FeedMapper::map(results)
    end

    # insert if not exists article.url
    def save(name, url)
      sql =  <<-EOS
        INSERT INTO 
          FEED (FEED_NAME, URL) 
        SELECT
          *
        FROM (
          SELECT
            '#{name}', '#{url}'
        ) AS TMP
        WHERE
          NOT EXISTS (
            SELECT
              *
            FROM
              FEED
            WHERE
              URL = '#{url}'
          );
      EOS
      re = @db.execute(sql)
    end
  end

  class FeedMapper
    def self.map(results)
      feed_arr = []
      results.each do |row|
        id = row['FEED_ID']
        name = row['FEED_NAME']
        url = row['URL']
        feed = R2S::Feed.new(id:id, name:name, url:url)
        feed_arr.push feed
      end
      feed_arr
    end
  end
end
