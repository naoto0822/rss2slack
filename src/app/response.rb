module R2S
  class Response
    OK_CODE = 200.freeze
    BAD_REQUEST_CODE = 400.freeze

    attr_reader :code, :headers, :body

    def initialize(code, headers, body)
      @code = code
      @headers = headers
      @body = body
    end

    def self.create_ok(headers, body)
      Response.new(OK_CODE, headers, body)
    end

    def self.create_bad_request(headers, body)
      Response.new(BAD_REQUEST_CODE, headers, body)
    end
  end
end
