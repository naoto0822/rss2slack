#!/bin/bash
cd /var/www/rss2slack/current
bundle exec ruby ./src/exec/feed_worker.rb
