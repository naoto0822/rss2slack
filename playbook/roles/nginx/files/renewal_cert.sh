#!/bin/bash

/usr/local/certbot/certbot-auto renew
sudo systemctl restart nginx
