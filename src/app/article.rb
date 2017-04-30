module R2S
  class Article
    attr_reader :id, :title, :body, :url, :pub_date, :created_at
    def initialize(id: nil, title: nil, body: nil, url: nil,
                   pub_date: nil, created_at: nil)
      @id = id
      @title = title
      @body = body
      @url = url
      @pub_date = pub_date
      @created_at = created_at
    end
  end
end
