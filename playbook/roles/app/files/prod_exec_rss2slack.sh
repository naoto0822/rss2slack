#!/bin/bash

PID_COUNT=$(ps aux | grep "unicorn master" | grep -v grep | wc -l)

if [ $PID_COUNT -eq 0 ]; then
  if [ -e /tmp/unicorn.pid ]; then
    PID=$(cat /tmp/unicorn.pid)
    kill $PID
    rm -f /tmp/unicorn.pid
  fi
  if [ -e /tmp/unicorn.sock ]; then
    rm -f /tmp/unicorn.sock
  fi
  cd /var/www/rss2slack/current
  /usr/local/rbenv/bin/rbenv exec bundle exec unicorn -c /etc/unicorn/unicorn_conf.rb -E production -D
fi
