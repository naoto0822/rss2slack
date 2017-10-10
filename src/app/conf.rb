require 'yaml'

module R2S
  class Conf
    ENV_PROD = 'production'.freeze
    ENV_DEV = 'development'.freeze
    ENV_LOCAL = 'local'.freeze
    ENV_TEST = 'test'.freeze

    DEFAULT_CONF_PATH = '/etc/rss2slack/rss2slack_conf.yml'.freeze

    attr_reader :conf_path

    attr_accessor :webhook_url, :db_host, :db_name, :db_username,
                  :db_password, :slack_token, :accept_team_domain,
                  :accept_channel_id, :logger_runner_path, :logger_app_path
    def initialize(conf_path:nil)
      if conf_path.nil?
        @conf_path = DEFAULT_CONF_PATH
      else
        @conf_path = conf_path
      end

      begin
        @conf = YAML.load_file(@conf_path)
      rescue => e
        raise ArgumentError, "#{e.class}, #{e.backtrace}"
      end

      @env = @conf['app']['env']

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
  end
end
