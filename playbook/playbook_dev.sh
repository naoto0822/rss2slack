#!/bin/sh

PRIVATE_KEY=$(vagrant ssh-config | grep "IdentityFile" | awk '{print $2}');
ansible-playbook -i hosts \
                 dev_server.yml \
                 --private-key $PRIVATE_KEY;
