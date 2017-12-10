#!/usr/bin/env ruby
require_relative '../app/logger'
require_relative '../app/conf'
require_relative '../app/article_runner'

conf = R2S::Conf.new
logger = R2S::Logger.new(conf.logger_runner_path)
logger.level = Logger::DEBUG

runner = R2S::ArticleRunner.new(logger, conf)
runner.run
