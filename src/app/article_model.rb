require_relative './article'

module R2S
  class ArticleModel
    def initialize(logger, db)
      @logger = logger
      @db = db
    end

    #TODO: order, where date
    def find_all
      sql = <<-EOS
        SELECT
          *
        FROM
          ARTICLE;
      EOS
      results = @db.execute(sql)
      ArticleMapper::map(results)
    end

    # insert if not exists url
    def save(article)
      sql = <<-EOS
        INSERT INTO
          ARTICLE (TITLE, BODY, URL, PUB_DATE)
        SELECT
          *
        FROM (
          SELECT
            '#{article.title}', '#{article.body}', '#{article.url}', '#{article.pub_date}'
        ) AS TMP
        WHERE
          NOT EXISTS (
            SELECT
              *
            FROM
              ARTICLE
            WHERE
              URL = '#{article.url}'
          );
      EOS
      re = @db.execute(sql)
    end
  end

  class ArticleMapper
    def self.map(results)
      articles = []
      results.each do |row|
        id = row['ARTICLE_ID']
        title = row['TITLE']
        body = row['BODY']
        url = row['URL']
        pub_date = row['PUB_DATE']
        created_at = row['CREATED_AT']
        article = R2S::Article.new(id: id, title: title, body: body,
                                   url: url, pub_date: pub_date, created_at: created_at)
        articles.push article
      end
      articles
    end
  end
end
