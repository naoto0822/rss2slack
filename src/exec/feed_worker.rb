#!/usr/bin/env ruby
require 'logger'
require_relative '../app/conf'
require_relative '../app/feed_runner'

logger = Logger.new(conf.logger_path)
logger.level = Logger::DEBUG
conf = R2S::Conf.new(logger)

runner = R2S::FeedRunner.new(logger, conf)
runner.run
