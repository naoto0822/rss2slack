require_relative './article'

module R2S
  class ArticleModel
    def initialize(logger:lohher, conf:conf, db:db)
      @logger = logger
      @conf = conf
      @db = db
    end

    def find_all
      #
    end
  end

  class ArticleMapper
    def self.map(results)
      articles = []
      results.each do |row|
        id = row["ARTICLE_ID"]
        title = row["TITLE"]
        desc = row["DESCRIPTION"]
        body = row["BODY"]
        url = row["URL"]
        created_at = row["CREATED_AT"]
        article = R2S::Article.new(id:id, title:title, desc:desc,
                                   body:body, url:url, created_at:created_at)
        articles.push article
      end
      articles
    end
  end
end
