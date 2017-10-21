#!/bin/bash
cd /var/www/rss2slack/current
bundle exec ruby ./src/exec/article_worker.rb
