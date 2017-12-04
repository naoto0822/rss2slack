#!/bin/bash

# create cert by standalone mode
/usr/local/certbot/certbot-auto certonly --standalone -d rss2slack.com -m n.h.in.m.h@gmail.com --agree-tos -n

# override launch mode to webroot
/usr/local/certbot/certbot-auto certonly --webroot -w /var/www/hogehoge -d rss2slack.com --agree-tos --force-renewal -n
