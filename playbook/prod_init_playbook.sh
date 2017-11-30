#!/bin/sh

ansible-playbook -i hosts \
                 -l prod \
                 -k \
                 prod_init_server.yml;
