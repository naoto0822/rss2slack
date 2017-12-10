require 'logger'
require 'json'

module R2S
  class Logger < ::Logger
    ROTATE = 5.freeze
    SIZE = (10 * 1024 * 1024).freeze

    def initialize(path)
      super(path, ROTATE, SIZE)
      @formatter = Formatter.new
    end
  end

  class Formatter < ::Logger::Formatter
    def call(severity, time, progname, msg)
      log = {}
      log["level"] = severity
      log["time"] = time
      log["msg"] = msg
      log.to_json + "\n"
    end
  end
end
