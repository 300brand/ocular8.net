ocular8.net
===========

Docker.io setup for Ocular8 network

Build Environment
-----------------

See bin/build.sh

Run Environment
---------------

	$ sudo docker.io run --detach --publish 30000:9001 --publish 30001:22 --publish 30002:3306 --publish 30003:11300 --name spider_data --volume .data/spider_data/mysql:/var/lib/mysql ocular8.net/spider_data

	$ sudo docker.io run --detach --publish 30100:9001 --publish 30101:22 --publish 30102:8080 ocular8.net/spider
