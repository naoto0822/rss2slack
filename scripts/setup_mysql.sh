#!/bin/sh

systemctl start mysqld

root_tmp_mycnf=/tmp/.tmp.my.cnf
tmp_pass=$(cat /var/log/mysqld.log | grep "temporary password" | awk '{print $11}')
umask 0077
cat > $root_tmp_mycnf <<EOF
[client]
user=root
password="$tmp_pass"
connect-expired-password
EOF

root_mycnf=/tmp/.my.cnf
new_pass='Password-0'
mysql --defaults-file=/tmp/.tmp.my.cnf -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$new_pass'"
umask 0077
cat > $root_mycnf <<EOF
[client]
user=root
password="$new_pass"
EOF

mysql --defaults-file=/tmp/.my.cnf < ./create_db_and_user.sql
mysql --defaults-file=/tmp/.my.cnf rss2slack < ./create_tables.sql
