#!/bin/sh

PRIVATE_KEY=$(vagrant ssh-config | grep "IdentityFile" | grep "/dev/" | awk '{print $2}');
ansible-playbook -i hosts \
                 -l dev \
                 --private-key $PRIVATE_KEY \
                 dev_server.yml;
