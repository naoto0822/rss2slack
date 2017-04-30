require_relative './db_client'
require_relative './article_model'
require_relative './slack/webhooks.rb'
require_relative './slack_msg_builder.rb'

module R2S
  class ArticleRunner
    def initialize(logger, conf)
      @logger = logger
      @conf = conf
      @db = R2S::DBClient.new(logger, conf)
      @article_model = R2S::ArticleModel.new(logger, @db)
      @slack = Slack::IncomingWebhooks::Client.new(conf.webhook_url)
    end

    def run
      @logger.debug('start running ArticleRunner')
      articles = @article_model.find_by_date
      post_slack(articles)
      @logger.debug('finish running ArticleRunner')
    end

    private

    def post_slack(articles)
      payload = R2S::SlackMsgBuilder::build_for_article(articles)
      @slack.post(payload)
    end
  end
end

