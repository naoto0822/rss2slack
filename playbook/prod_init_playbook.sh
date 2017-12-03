#!/bin/sh

ansible-playbook -i hosts \
                 -l prod_init \
                 -k \
                 prod_init_server.yml;
