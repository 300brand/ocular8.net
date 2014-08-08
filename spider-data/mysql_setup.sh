#!/bin/bash
/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
	echo "=> Waiting for confirmation of MySQL service startup"
	sleep 5
	mysql -uroot -e "status" > /dev/null 2>&1
	RET=$?
done

/usr/bin/mysql -uroot -e "CREATE USER 'spider'@'%' IDENTIFIED BY PASSWORD '*5C2901F96BBBA397912EF7416EF4BC9B3B2B7672'"
/usr/bin/mysql -uroot -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE ON spider.* TO 'spider'@'%'"
/usr/bin/mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY PASSWORD '*95211EBE089EAED2B3C998E7F0DA9DA4F3E21627'"
/usr/bin/mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"
/usr/bin/mysql -uroot -e "CREATE DATABASE IF NOT EXISTS spider"
/usr/bin/mysqladmin -uroot shutdown
