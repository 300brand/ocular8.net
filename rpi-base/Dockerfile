FROM       resin/rpi-raspbian:latest
MAINTAINER jake@300brand.com

ENV        DEBIAN_FRONTEND noninteractive

RUN        ping -c1 -w1 192.168.20.21 && echo 'Acquire::http { Proxy "http://192.168.20.21:3142"; };' >> /etc/apt/apt.conf.d/01proxy || true
RUN        sed 's/main$/main contrib non-free/' -i /etc/apt/sources.list
# NOTE     To cause an update (and upgrade), change the date below to today
RUN        apt-get update # LAST_UPDATE: Aug 08, 2014
RUN        apt-get upgrade -y

RUN        apt-get install -y supervisor openssh-server

RUN        echo 'root:Ocular8' | chpasswd
RUN        mkdir /var/run/sshd
RUN        sed -e 's/UsePAM yes/UsePAM no/' -i /etc/ssh/sshd_config
RUN        sed -e 's/PermitRootLogin without-password/PermitRootLogin yes/' -i /etc/ssh/sshd_config
ADD        sshd.conf /etc/supervisor/conf.d/sshd.conf
EXPOSE     22

RUN        mkdir -p /var/log/supervisor
RUN        chown nobody:nogroup /var/log/supervisor
ADD        supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD        inet_http_server.conf /etc/supervisor/conf.d/inet_http_server.conf
EXPOSE     9001

ONBUILD CMD ["/usr/bin/supervisord", "--configuration", "/etc/supervisor/supervisord.conf"]
