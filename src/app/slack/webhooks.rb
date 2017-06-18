require 'net/http'
require 'uri'
require 'json'

# TODO: packaging gem.
module Slack
module IncomingWebhooks
  class Client
    def initialize(url)
      @url = url
    end

    def post(payload)
      Connection.send(@url, payload.to_params)
    end
  end

  class Payload
    PAYLOAD_PARAMS = %i[
      channel text parse link_names attachments
      unfurl_links unfurl_media username as_user
      icon_url icon_emoji thread_ts reply_broadcast
    ].freeze

    attr_accessor *PAYLOAD_PARAMS

    def to_params
      params = {}
      PAYLOAD_PARAMS.each { |p|
        if "#{p}" == 'attachments'
          attachments = []
          @attachments.each { |a| attachments.push(a.to_params) } unless @attachments.nil?
          params['attachments'] = attachments unless attachments.empty?
          next
        end
        params["#{p}"] = send(p) unless send(p).nil?
      }
      params
    end
  end

  class Attachment
    ATTACHMENT_PARAMS = %i[
      fallback color pretext author_name author_link
      author_icon title title_link text fields image_url
      thumb_url footer footer_icon ts
    ].freeze

    attr_accessor *ATTACHMENT_PARAMS

    def to_params
      params = {}
      ATTACHMENT_PARAMS.each { |p|
        if "#{p}" == 'fields'
          fields = []
          @fields.each { |f| fields.push(f.to_params) } unless @fields.nil?
          params['fields'] = fields
          next
        end
        params["#{p}"] = send(p) unless send(p).nil?
      }
      params
    end
  end

  class Field
    FIELD_PARAMS = %i[
      title value short
    ].freeze

    attr_accessor *FIELD_PARAMS

    def to_params
      params = {}
      FIELD_PARAMS.each { |p| params["#{p}"] = send(p) unless send(p).nil? }
      params
    end
  end

  class Connection
    def self.send(url, payload)
      if url.nil? || payload.nil? || payload.empty?
        msg = 'error: url or payload is nil.'
        return Result.new(msg: msg)
      end

      res = request(url, payload)
      Result.new(code: res.code, msg: res.message,
                 header: res.header, body: res.body)
    end

    def self.request(url, payload)
      uri = URI.parse(url)
      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data(payload: payload.to_json)
      res = Net::HTTP.start(uri.host, uri.port,
                            use_ssl: uri.scheme == 'https') { |http|
        http.open_timeout = 5
        http.read_timeout = 5
        http.request(req)
      }
      res
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

module OutgoingWebhooks
  class Message
    attr_reader :token, :team_id, :team_domain, :channel_id, :channel_name, :timestamp,
                :user_id, :user_name, :text, :trigger_word
    def initialize(body)
      @token = body[:token]
      @team_id = body[:team_id]
      @team_domain = body[:team_domain]
      @channel_id = body[:channel_id]
      @channel_name = body[:channel_name]
      @timestamp = body[:timestamp]
      @user_id = body[:user_id]
      @user_name = body[:user_name]
      @text = body[:text]
      @trigger_word = body[:trigger_word]
    end
  end
end
end
