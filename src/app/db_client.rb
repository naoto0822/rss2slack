require 'mysql2'

module R2S
  class DBClient
    attr_accessor :client, :logger, :conf
    def initialize(logger, conf)
      @logger = logger
      @conf = conf

      @client = Mysql2::Client.new(host: conf.db_host,
                                   database: conf.db_name,
                                   username: conf.db_username,
                                   password: conf.db_password)
    end

    def statement(sql)
      @logger.debug("execute query: #{sql}")
      @client.prepare(sql)
    end

    def execute(sql)
      @logger.debug("execute query: #{sql}")
      @client.query(sql)
    end
  end
end
