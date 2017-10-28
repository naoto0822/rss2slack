#!/bin/sh

PRIVATE_KEY=$(vagrant ssh-config | grep "IdentityFile" | grep "/staging/" | awk '{print $2}');
ansible-playbook -i hosts \
                 -l dev \
                 --private-key $PRIVATE_KEY \
                 staging_server.yml;
