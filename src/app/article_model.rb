require_relative './article'
require_relative './date'

module R2S
  class ArticleModel
    def initialize(logger, db)
      @logger = logger
      @db = db
    end

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

    def find_by_date(from = now_time, to = yesterday_time)
      sql = <<-EOS
        SELECT
          *
        FROM
          ARTICLE
        WHERE
          CREATED_AT
        BETWEEN
          ? AND ?;
      EOS
      statement = @db.statement(sql)
      results = statement.execute(from, to)
      ArticleMapper::map(results)
    end

    # insert if not exists url
    def save(article)
      # TODO: ARTICLE -> DUAL?
      sql = <<-EOS
        INSERT INTO
          ARTICLE (TITLE, BODY, URL, PUB_DATE)
        SELECT
          ?, ?, ?, ?
        FROM
          ARTICLE
        WHERE
          NOT EXISTS (
            SELECT
              *
            FROM
              ARTICLE
            WHERE
              URL = ?
          );
      EOS
      statement = @db.statement(sql)
      results = statement.execute(article.title, article.body,
                                  article.url, article.pub_date, article.url)
    end

    private

    def now_time
      time = R2S::Date::now
      R2S::Date::format(time)
    end

    def yesterday_time
      time = R2S::Date::yesterday
      R2S::Date::format(time)
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
                                   url: url, pub_date: pub_date,
                                   created_at: created_at)
        articles.push(article)
      end
      articles
    end
  end
end
