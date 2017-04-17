#!/usr/bin/env ruby
require 'logger'
require_relative '../app/db_client'
require_relative '../app/feed_model'
require_relative '../app/feed'
require_relative '../app/conf'

conf = R2S::Conf.new(env:ENV["env"])
logger = Logger.new(conf.logger_path)
logger.level = Logger::DEBUG

db = R2S::DBClient.new(logger:logger, conf:conf)
feedmodel = R2S::FeedModel.new(logger:logger, conf:conf, db:db)
feedmodel.save("google", "https://google.com")

