FROM       ocular8.net/base
MAINTAINER jake@300brand.com

RUN        apt-get install -y golang git
ADD        golang.sh /etc/profile.d/golang.sh

RUN        GOPATH=/usr/local go get -u -v github.com/coreos/etcd # LAST_UPDATE: May 19, 2014 13:45

ADD        etcd.conf /etc/supervisor/conf.d/etcd.conf

RUN        mkdir /data
VOLUME     ["/data"]
EXPOSE     4001
EXPOSE     7001
