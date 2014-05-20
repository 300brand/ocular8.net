FROM       ocular8.net/base
MAINTAINER jake@300brand.com

RUN        apt-get install -y golang bzr git mercurial libxml2-dev pkg-config libsqlite3-dev
ADD        golang.sh /etc/profile.d/golang.sh

RUN        GOPATH=/usr/local go get -u -v github.com/300brand/coverageservices # LAST_UPDATE: May 19, 2014 13:45
ADD        coverage.toml /etc/coverage.toml

