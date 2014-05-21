#!/bin/bash

DOCKER=/usr/bin/docker.io
DATA_DIR=/home/data

# $DOCKER run \
# 	--detach \
# 	--publish 30000:9001 \
# 	--publish 30001:22 \
# 	--publish 30002:3306 \
# 	--publish 30003:11300 \
# 	--name spider_data \
# 	--volume $DATA_DIR/spider_data/mysql:/var/lib/mysql \
# 	--hostname data.spider.ocular8.net \
# 	ocular8.net/spider_data

# $DOCKER run \
# 	--detach \
# 	--publish 30100:9001 \
# 	--publish 30101:22 \
# 	--publish 30102:8080 \
# 	--hostname crawler01.spider.ocular8.net \
# 	--name crawler01.spider.ocular8.net \
# 	ocular8.net/spider

# $DOCKER run \
# 	--detach \
# 	--publish 53:53 \
# 	--publish 53:53/udp \
# 	--hostname dns.`hostname -f` \
# 	--name dns \
# 	ocular8.net/dns

$DOCKER run \
	--detach \
	--hostname mongo-data-rs0.`hostname`.ocular8.net \
	--name mongo-data-rs0.`hostname`.ocular8.net \
	--publish 50000:22 \
	--publish 50001:9001 \
	--publish 27017:27017 \
	--memory 16g \
	--volume /home/data/mongo:/data \
	ocular8.net/mongo-data-rs0

$DOCKER run \
	--detach \
	--name beanstalk \
	--publish 50010:22 \
	--publish 50011:9001 \
	--publish 11300:11300 \
	--memory 512m \
	ocular8.net/beanstalk

$DOCKER run \
	--detach \
	--name service-web \
	--publish 50020:22 \
	--publish 50021:9001 \
	--publish 8080:8080 \
	--link beanstalk:beanstalk \
	--memory 512m \
	ocular8.net/service-web

for P in 1; do
	$DOCKER run \
		--detach \
		--name service-process-${P} \
		--publish 500$(($P + 2))0:22 \
		--publish 500$(($P + 2))1:9001 \
		--link beanstalk:beanstalk \
		--memory 2g \
		ocular8.net/service-processing
done
