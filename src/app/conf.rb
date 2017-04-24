require 'yaml'

module R2S
  class Conf
    attr_accessor :webhook_url, :db_host, :db_name, :db_username, :db_password, :logger_path
    def initialize(env)
      @env = env

      begin
        @conf = YAML.load_file(conf_path())
      rescue => e
        raise ArgumentError, "#{e.class}, #{e.backtrace}"
      end

      @logger_path = @conf["logger"]["path"]
      if local?
        @logger_path = File.expand_path(File.dirname(__FILE__)) + @conf["logger"]["path"]
      end

      @webhook_url = @conf["slack"]["webhook_url"]
      @db_host = @conf["mysql"]["host"]
      @db_name = @conf["mysql"]["database"]
      @db_username = @conf["mysql"]["username"]
      @db_password = @conf["mysql"]["password"]
    end

    def prod?
      @env == "production"
    end

    def dev?
      @env == "development"
    end

    def local?
      @env == "local"
    end

    def conf_path
      case @env
      when "production"
        prod_path
      when "development"
        dev_path
      when "local"
        local_path
      else
        ""
      end
    end

    private

    def prod_path
      "/etc/conf/rss2slack/conf.prod.yml"
    end

    def dev_path
      "/etc/conf/rss2slack/conf.dev.yml"
    end

    def local_path
      File.expand_path(File.dirname(__FILE__)) + '/../../conf/conf.local.yml'
    end
  end
end
