module R2S
  class Response
    attr_reader :code, :headers, :body
    def initialize(code, headers, body)
      @code = code
      @headers = headers
      @body = body
    end
  end
end
