#!/usr/bin/env bash

# Wait for MySQL to come up
while ! mysqladmin ping -u root -phortonworks1 --silent; do
  sleep 5
done

pass="hortonworks1"

# Create an sql file that:
# Creates druid schema and user
cat << EOF > /tmp/sandbox/build/mysql-setup.sql
CREATE DATABASE druid DEFAULT CHARACTER SET utf8;
CREATE USER 'druid'@'%' IDENTIFIED BY "$pass";
GRANT ALL PRIVILEGES ON *.* TO 'druid'@'%' WITH GRANT OPTION;
commit;
EOF

# Execute sql file
mysql -h localhost -u root -p"$pass" < /tmp/sandbox/build/mysql-setup.sql
