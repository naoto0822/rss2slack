require_relative './spec_helper'
require_relative '../src/app/feed'

describe R2S::Feed do
  before(:each) do
    # NOOP
  end

  after(:each) do
    # NOOP
  end

  it "feed initialize" do
    feed = R2S::Feed.new(id:1, name:'name', url:'url')
    expect(feed.id).to eq 1
    expect(feed.name).to eq 'name'
    expect(feed.url).to eq 'url'
  end

  it 'initialize no args' do
    feed = R2S::Feed.new
    expect(feed.id).to eq nil
    expect(feed.name).to eq nil
    expect(feed.url).to eq nil
  end
end
