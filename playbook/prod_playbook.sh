#!/bin/sh

PRIVATE_KEY="$HOME/.ssh/id_rsa_rss2slack";
ansible-playbook -i hosts \
                 -l prod \
                 --private-key $PRIVATE_KEY \
                 prod_server.yml;
