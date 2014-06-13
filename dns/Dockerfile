FROM       ubuntu:latest
MAINTAINER jake@300brand.com

ENV        DEBIAN_FRONTEND noninteractive

RUN        ping -c1 -w1 192.168.20.21 && echo 'Acquire::http { Proxy "http://192.168.20.21:3142"; };' >> /etc/apt/apt.conf.d/01proxy || true
RUN        sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN        apt-get update
RUN        apt-get install -y bind9

ADD        named.conf.options /etc/bind/named.conf.options
RUN        chown bind:bind /etc/bind/named.conf.options

ADD        db.ocular8.net /etc/bind/db.ocular8.net
RUN        chown bind:bind /etc/bind/db.ocular8.net

ADD        20.168.192.IN-ADDR.ARPA /etc/bind/20.168.192.IN-ADDR.ARPA
RUN        chown bind:bind /etc/bind/20.168.192.IN-ADDR.ARPA

ADD        named.conf.local /etc/bind/named.conf.local
RUN        chown bind:bind /etc/bind/named.conf.local

EXPOSE     53

CMD        ["/usr/sbin/named","-c","/etc/bind/named.conf","-f"]
