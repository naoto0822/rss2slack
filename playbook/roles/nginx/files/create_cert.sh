#!/bin/bash

# create cert by standalone mode
/usr/local/certbot/certbot-auto certonly --standalone -d rss2slack.com -m n.h.in.m.h@gmail.com --agree-tos -n
