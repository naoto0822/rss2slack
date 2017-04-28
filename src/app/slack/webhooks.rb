require 'net/http'
require 'uri'
require 'json'

# TODO: packaging gem.
module Slack
module IncomingWebhooks
  class Client
    attr_reader :url

    def initialize(url)
      @url = url
      @payload = Payload.new
    end

    def post(channel: nil, text: nil, options: nil)
      @payload.channel = channel
      @payload.text = text
      Connection.send(@payload.build(options))
    end
  end

  class Payload
    REQUIRE_PARAMS = [
      'channel', 'text'
    ].freeze

    OPTION_PARAMS = [
      'parse', 'link_names', 'attachments', 'unfurl_links', 'unfurl_media',
      'username', 'as_user', 'icon_url', 'icon_emoji', 'thread_ts', 'reply_broadcast'
    ].freeze

    attr_accessor :channel, :text
                  # :parse, :link_names, :attachments, :unfurl_links, :unfurl_media,
                  # :username, :as_user, :icon_url, :icon_emoji, :thread_ts, :reply_broadcast

    def initialize
      # NOOP
    end

    def valid?(payload)
      REQUIRE_PARAMS.each { |p|
        return false payload[p].nil?
        next
      }
      true
    end

    def build(options)
      params = {}
      params['channel'] = @channel unless @channel.nil?
      params['text'] = @text unless @text.nil?
      params.merge(options) unless options.nil?
      params
    end
  end

  class Connection
    def self.send(url, payload)
      if url.nil? || payload.nil? || payload.empty?
        msg = 'error: url or payload is nil.'
        return Result.new(msg: msg)
      end

      uri = URI::parse(@url)
      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data(payload: payload)
      res = Net::HTTP.start(uri.host, uri.port,
                            use_ssl: uri.scheme == 'https') { |http|
        http.open_timeout = 5
        http.read_timeout = 5
        http.request(req)
      }
      Result.new(code: res.code, header: res.header, body: res.body)
    end
  end

  class Result
    attr_reader :code, :msg, :header, :body
    def initialize(code: nil, msg: nil, header: nil, body: nil)
      @code = code
      @msg = msg
      @header = header
      @body = body
    end
  end
end
end
