FROM       ocular8.net/base
MAINTAINER jake@300brand.com

RUN        wget https://mms.mongodb.com/download/agent/monitoring/mongodb-mms-monitoring-agent_2.2.0.70-1_amd64.deb
RUN        apt-get install -y libsasl2-2
RUN        dpkg -i mongodb-mms-monitoring-agent_2.2.0.70-1_amd64.deb
RUN        sed -i s/mmsApiKey=$/mmsApiKey=ef1902f7952505e222109bfb38f68b1a/ /etc/mongodb-mms/monitoring-agent.config
ADD        mongomms.conf /etc/supervisor/conf.d/mongomms.conf
