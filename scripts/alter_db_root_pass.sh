#!/bin/sh

root_mycnf=$HOME/.my.cnf
new_pass='Password-0'
mysql --defaults-file=$HOME/.tmp.my.cnf -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$new_pass'"
umask 0077
cat > $root_mycnf <<EOF
[client]
user=root
password="$new_pass"
EOF
