#!/bin/bash

# override launch mode to webroot
/usr/local/certbot/certbot-auto certonly --webroot -w /var/ssl -d rss2slack.com --agree-tos --force-renewal -n
