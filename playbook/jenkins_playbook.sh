#!/bin/sh

PRIVATE_KEY=$(vagrant ssh-config | grep "IdentityFile" | grep "/jenkins/" | awk '{print $2}');
ansible-playbook -i hosts \
                 -l jenkins \
                 --private-key $PRIVATE_KEY \
                 jenkins.yml;
