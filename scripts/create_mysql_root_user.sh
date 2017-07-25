#!/bin/sh

systemctl start mysqld

root_mycnf=$HOME/.tmp.my.cnf
tmp_pass=$(cat /var/log/mysqld.log | grep "temporary password" | awk '{print $11}')
umask 0077
cat > $root_mycnf <<EOF
[client]
user=root
password="$tmp_pass"
connect-expired-password
EOF
