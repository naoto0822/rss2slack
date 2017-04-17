module R2S
  class Feed
    attr_reader :id, :name, :url
    def initialize(id:nil, name:nil, url:nil)
      @id = id
      @name = name
      @url = url
    end
  end
end
