require 'mysql2'
require 'sqlite3'

module R2S
  class DBClient
    attr_accessor :db, :logger, :conf
    def initialize(logger, conf)
      @logger = logger
      @conf = conf
      @db = client
    end

    def client
      if @conf.dev?
        return sqlite3_client
      end
      mysql_client
    end

    def mysql_client
      Mysql2::Client.new(host: @conf.db_host,
                         database: @conf.db_name,
                         username: @conf.db_username,
                         password: @conf.db_password)

    end

    def sqlite3_client
      SQLite3::Database.new(@conf.db_name)
    end

    def statement(sql)
      @logger.debug("execute query: #{sql}")
      @db.prepare(sql)
    end

    def execute(sql)
      @logger.debug("execute query: #{sql}")
      @db.query(sql)
    end
  end
end
