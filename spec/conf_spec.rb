require_relative './spec_helper'
require_relative '../src/app/conf'

describe R2S::Conf do
  before(:each) do
    path = File.expand_path(File.dirname(__FILE__)) + '/conf.test.yml'
    @conf = R2S::Conf.new(conf_path: path)
  end

  after(:each) do
    # NOOP
  end

  it 'env' do
    expect(@conf.prod?).to eq false
    expect(@conf.dev?).to eq false
    expect(@conf.local?).to eq false
    expect(@conf.test?).to eq true
  end

  it 'accessor' do
    expect(@conf.webhook_url).to eq 'https://hooks.slack.com/'
    expect(@conf.db_host).to eq 'localhost'
    expect(@conf.db_name).to eq 'test'
    expect(@conf.db_username).to eq 'test_user'
    expect(@conf.db_password).to eq 'test_pass'
    expect(@conf.slack_token).to eq 'TEST_TOKEN'
    expect(@conf.accept_team_domain).to eq 'test.domain'
    expect(@conf.accept_channel_id).to eq 'channel_id'
    expect(@conf.logger_runner_path).to eq '/var/log/rss2slack/runner.log'
    expect(@conf.logger_app_path).to eq '/var/log/rss2slack/app.log'
  end
end
