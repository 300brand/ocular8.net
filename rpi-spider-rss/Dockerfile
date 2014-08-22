FROM       docker.ocular8.net/rpi-base
MAINTAINER jake@300brand.com

RUN        apt-get install -y golang bzr git mercurial libxml2-dev pkg-config libsqlite3-dev
ADD        golang.sh /etc/profile.d/golang.sh

RUN        GOPATH=/usr/local go get -u -v github.com/300brand/spider-rss # v1.0.1
ADD        spider-rss.conf /etc/supervisor/conf.d/spider-rss.conf
ENV        MYSQL_HOST 192.168.20.15:30002
EXPOSE     8080
