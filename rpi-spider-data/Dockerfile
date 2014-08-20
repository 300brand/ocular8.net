FROM       docker.ocular8.net/rpi-base
MAINTAINER jake@300brand.net

RUN        apt-get install -y mysql-server

ADD        mysqld.cnf /etc/mysql/conf.d/mysqld.cnf
RUN        chmod 0664 /etc/mysql/conf.d/mysqld.cnf
ADD        mysql_setup.sh /root/mysql_setup.sh
RUN        chmod +x /root/mysql_setup.sh
ADD        mysql.conf /etc/supervisor/conf.d/mysql.conf
ADD        mysql_setup.conf /etc/supervisor/conf.d/mysql_setup.conf
VOLUME     ['/var/lib/mysql']
EXPOSE     3306
