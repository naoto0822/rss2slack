require 'yaml'

module R2S
  class Conf
    ENV_PROD = 'production'.freeze
    ENV_DEV = 'development'.freeze
    ENV_LOCAL = 'local'.freeze
    ENV_TEST = 'test'.freeze

    attr_accessor :webhook_url, :db_host, :db_name, :db_username,
                  :db_password, :slack_token, :accept_team_domain,
                  :accept_channel_id, :logger_runner_path, :logger_app_path
    def initialize
      @env = current_env

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

      @logger_runner_path = @conf['logger']['runner']['path']
      @logger_app_path = @conf['logger']['app']['path']

      @db_host = @conf['mysql']['host']
      @db_name = @conf['mysql']['database']
      @db_username = @conf['mysql']['username']
      @db_password = @conf['mysql']['password']
    end

    def current_env
      ENV['env']
    end

    def prod?
      @env == ENV_PROD
    end

    def dev?
      @env == ENV_DEV
    end

    def local?
      @env == ENV_LOCAL
    end

    def test?
      @env == ENV_TEST
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
      when ENV_PROD
        prod_conf_path
      when ENV_DEV
        dev_conf_path
      when ENV_LOCAL
        local_conf_path
      when ENV_TEST
        test_conf_path
      else
        nil
      end
    end

    private

    def prod_conf_path
      '/etc/rss2slack/conf.production.yml'
    end

    def dev_conf_path
      '/etc/rss2slack/conf.development.yml'
    end

    def local_conf_path
      '/etc/rss2slack/conf.local.yml'
    end

    def test_conf_path
      File.expand_path(File.dirname(__FILE__)) + '/../../spec/conf.test.yml'
    end
  end
end
