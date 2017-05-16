require 'logger'
require_relative './spec_helper'
require_relative '../src/app/feed_model'
require_relative '../src/app/db_client'

describe R2S::FeedModel do
  before(:each) do
    ENV['env'] = 'local'
    @logger = Logger.new(STDOUT)
    @db = Object.new
  end

  after(:each) do
    # NOOP
  end
end
