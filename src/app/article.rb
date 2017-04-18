module R2S
  class Article
    attr_reader :id, :title, :desc, :body, :url, :created_at
    def initialize(id:nil, title:nil, desc:nil, body:nil, url:nil, created_at:nil)
      @id = id
      @title = title
      @desc = desc
      @body = body
      @url = url
      @created_at = created_at
    end
  end
end
