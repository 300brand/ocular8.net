FROM       docker.ocular8.net/base
MAINTAINER jake@300brand.com

RUN        apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN        echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
RUN        apt-get update
RUN        apt-get install -y mongodb-org
RUN        mkdir /data
VOLUME     ["/data"]
