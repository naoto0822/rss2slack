require 'time'

module R2S
  class Article
    attr_reader :id, :title, :body, :url, :pub_date, :created_at
    def initialize(id: nil, title: nil, body: nil, url: nil,
                   pub_date: nil, created_at: nil)
      @id = id
      @title = title
      @body = body
      @url = url
      @pub_date = convert_date_time(pub_date)
      @created_at = created_at
    end

    private

    def convert_date_time(date)
      return nil if date.nil?
      time = Time.parse(date)
      time.strftime('%Y-%m-%d %H:%M:%S')
    rescue
      return nil
    end
  end
end
