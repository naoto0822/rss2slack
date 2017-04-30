require 'yaml'

module R2S
  class Conf
    attr_accessor :webhook_url, :db_host, :db_name, :db_username,
                  :db_password, :logger_path
    def initialize(logger)
      @logger = logger

      @env = ENV['env']
      @webhook_url = ENV['incoming_webhooks_url']

      if !@env.nil? || !@webhook_url.nil?
        @logger.warn('environment var of env, webhook_url is not set.')
        raise RuntimeError, 'environment var of env, webhook_url is not set.'
      end

      begin
        @conf = YAML.load_file(conf_path)
      rescue => e
        @logger.warn("error loading conf yaml")
        raise ArgumentError, "#{e.class}, #{e.backtrace}"
      end

      @logger_path = @conf['logger']['path']
      if local?
        @logger_path = local_logger_path
      end

      @db_host = @conf['mysql']['host']
      @db_name = @conf['mysql']['database']
      @db_username = @conf['mysql']['username']
      @db_password = @conf['mysql']['password']
    end

    def prod?
      @env == 'production'
    end

    def dev?
      @env == 'development'
    end

    def local?
      @env == 'local'
    end

    def conf_path
      case @env
      when 'production'
        prod_conf_path
      when 'development'
        dev_conf_path
      when 'local'
        local_conf_path
      else
        nil
      end
    end

    private

    def prod_conf_path
      '/etc/conf/rss2slack/conf.prod.yml'
    end

    def dev_conf_path
      '/etc/conf/rss2slack/conf.dev.yml'
    end

    def local_conf_path
      File.expand_path(File.dirname(__FILE__)) + '/../../conf/conf.local.yml'
    end

    def local_logger_path
      File.expand_path(File.dirname(__FILE__)) + @conf['logger']['path']
    end
  end
end
