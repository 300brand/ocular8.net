FROM       docker.ocular8.net/rpi-base
MAINTAINER jake@300brand.com

RUN        apt-get install -y golang bzr git mercurial libxml2-dev pkg-config libsqlite3-dev
ADD        golang.sh /etc/profile.d/golang.sh

RUN        GOPATH=/usr/local go get -u -v github.com/300brand/spider # v1.3.1
ADD        spider.conf /etc/supervisor/conf.d/spider.conf
ENV        MYSQL_HOST 192.168.20.78:3306
