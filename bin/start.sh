#!/bin/bash

DOCKER=/usr/bin/docker.io
DOCKER='echo docker'
DATA_DIR=/home/data
IP=$(ip addr show dev $(ip route list table main | awk '$1 == "default" {print $NF}') | awk '$1 == "inet" { sub(/\/[0-9]+/, "", $2); print $2 }')
FULL_HOST=$(hostname -f)

PORT_PREFIX=500
PRIVATE_PORTS=( 22 9001 4001 7001 $(seq 10000 10007) )
declare -a PORTMAP
declare -a PORT

port () {
	printf "%3d%02d" $PORT_PREFIX $1
}

setports () {
	for I in $(seq 0 $((${#PRIVATE_PORTS[@]} - 1))); do
		P=${PRIVATE_PORTS[$I]}
		PORT[$P]=$(port $I)
		PORTMAP[$P]=${PORT[$P]}:$P
	done
}

docker () {
	$DOCKER $@
	PORT_PREFIX=$(($PORT_PREFIX + 1))
	setports
}

setports

docker run \
	--detach \
	--hostname mongo-data-rs0.$FULL_HOST \
	--memory 16g \
	--name mongod-rs0 \
	--publish ${PORTMAP[22]} \
	--publish ${PORTMAP[9001]} \
	--publish 27017:27017 \
	--env MACHINE_IP=$IP \
	--volume /home/data/mongod-rs0:/data \
	ocular8.net/mongo-data-rs0

docker run \
	--detach \
	--hostname etcd.$FULL_HOST \
	--name etcd \
	--publish ${PORTMAP[22]} \
	--publish ${PORTMAP[4001]} \
	--publish ${PORTMAP[7001]} \
	--publish ${PORTMAP[9001]} \
	--env MACHINE_IP=$IP \
	--env PORT_4001=${PORT[4001]} \
	--env PORT_7001=${PORT[7001]} \
	ocular8.net/etcd

docker run \
	--detach \
	--hostname service-web.$FULL_HOST \
	--memory 512m \
	--name service-web \
	--publish ${PORTMAP[22]} \
	--publish 8080:8080 \
	--publish ${PORTMAP[9001]} \
	--publish ${PORTMAP[10000]} \
	--publish ${PORTMAP[10001]} \
	--env MACHINE_IP=$IP \
	--env PORT_10000=${PORT[10000]} \
	--env PORT_10001=${PORT[10001]} \
	ocular8.net/service-web

docker run \
	--detach \
	--hostname service-processing.$FULL_HOST \
	--memory 2g \
	--name service-processing \
	--publish ${PORTMAP[22]} \
	--publish ${PORTMAP[9001]} \
	--publish ${PORTMAP[10000]} \
	--publish ${PORTMAP[10001]} \
	--publish ${PORTMAP[10002]} \
	--publish ${PORTMAP[10003]} \
	--publish ${PORTMAP[10004]} \
	--publish ${PORTMAP[10005]} \
	--publish ${PORTMAP[10006]} \
	--publish ${PORTMAP[10007]} \
	--env MACHINE_IP=$IP \
	--env PORT_10000=${PORT[10000]} \
	--env PORT_10001=${PORT[10001]} \
	--env PORT_10002=${PORT[10002]} \
	--env PORT_10003=${PORT[10003]} \
	--env PORT_10004=${PORT[10004]} \
	--env PORT_10005=${PORT[10005]} \
	--env PORT_10006=${PORT[10006]} \
	--env PORT_10007=${PORT[10007]} \
	ocular8.net/service-processing

# docker run \
# 	--detach \
# 	--publish 30000:9001 \
# 	--publish 30001:22 \
# 	--publish 30002:3306 \
# 	--publish 30003:11300 \
# 	--name spider_data \
# 	--volume $DATA_DIR/spider_data/mysql:/var/lib/mysql \
# 	--hostname data.spider.ocular8.net \
# 	ocular8.net/spider_data

# docker run \
# 	--detach \
# 	--publish 30100:9001 \
# 	--publish 30101:22 \
# 	--publish 30102:8080 \
# 	--hostname crawler01.spider.ocular8.net \
# 	--name crawler01.spider.ocular8.net \
# 	ocular8.net/spider

# docker run \
# 	--detach \
# 	--publish 53:53 \
# 	--publish 53:53/udp \
# 	--hostname dns.`hostname -f` \
# 	--name dns \
# 	ocular8.net/dns
