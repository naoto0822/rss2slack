require_relative './article'

module R2S
  class ArticleModel
    def initialize(logger:lohher, conf:conf, db:db)
      @logger = logger
      @conf = conf
      @db = db
    end

    def find_all
      sql = <<-EOS
        SELECT *
          FROM ARTICLE;
      EOS
      results = @db.execute(sql)
      ArticleMapper::map(results)
    end

    def save(article)
      sql = <<-EOS
        INSERT INTO
          ARTICLE (TITLE, DESCRIPTION, BODY, URL)
          VALUES ("#{article.title}", "#{article.desc}", "#{article.body}", "#{article.url}");
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
