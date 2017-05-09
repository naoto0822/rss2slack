require 'yaml'

module R2S
  class Conf
    attr_accessor :webhook_url, :db_host, :db_name, :db_username,
                  :db_password, :logger_path, :slack_token, :accept_team_domain,
                  :accept_channel_id
    def initialize
      @env = ENV['env']

      if @env.nil?
        raise RuntimeError, 'environment var of env is not set.'
      end

      begin
        @conf = YAML.load_file(conf_path)
      rescue => e
        raise ArgumentError, "#{e.class}, #{e.backtrace}"
      end

      @webhook_url = @conf['slack']['incoming_webhooks_url']
      @slack_token = @conf['slack']['outgoing_webhooks_token']
      @accept_team_domain = @conf['slack']['accept_team_domain']
      @accept_channel_id = @conf['slack']['accept_channel_id']

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

    def valid_slack_token?(token)
      token == @slack_token
    end

    def valid_accept_team_domain?(domain)
      domain == @accept_team_domain
    end

    def valid_accept_channel_id?(id)
      id == @accept_channel_id
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
      '/etc/rss2slack/conf.prod.yml'
    end

    def dev_conf_path
      '/etc/rss2slack/conf.dev.yml'
    end

    def local_conf_path
      File.expand_path(File.dirname(__FILE__)) + '/../../etc/rss2slack/conf.local.yml'
    end

    def local_logger_path
      File.expand_path(File.dirname(__FILE__)) + @conf['logger']['path']
    end
  end
end
