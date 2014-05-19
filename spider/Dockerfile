FROM       ocular8.net/base
MAINTAINER jake@300brand.com

RUN        apt-get install -y golang bzr git mercurial
ADD        golang.sh /etc/profile.d/golang.sh

RUN        GOPATH=/usr/local go get github.com/300brand/spider

ADD        spider.conf /etc/supervisor/conf.d/spider.conf
