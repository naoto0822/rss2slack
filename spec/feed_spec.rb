require_relative './spec_helper'
require_relative '../src/app/feed'
require_relative '../src/app/conf'
require 'logger'

describe R2S::Feed do
  before(:each) do
    @logger = Logger.new(STDOUT)
    conf_path = File.expand_path(File.dirname(__FILE__)) + '/../conf/database.yml'
    @conf = R2S::Conf.new(logger:@logger, path:conf_path)
    allow(@conf).to receive(:db_host).and_return("localhost")
    allow(@conf).to receive(:db_name).and_return("rss2slack")
    allow(@conf).to receive(:db_username).and_return("rss2slack_u")
    allow(@conf).to receive(:db_password).and_return("password")
  end
  after(:each) do
    
  end
  it "feed initialize" do
    feed = R2S::Feed.new(id:"1", name:"name", url:"url")

    expect(feed.id).to eq "1"
    expect(feed.name).to eq "name"
  end
  it "feed model initialize" do
    model = R2S::FeedModel.new(logger:@logger, conf:@conf)

  end
end
