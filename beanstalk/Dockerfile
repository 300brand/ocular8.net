FROM       ocular8.net/base
MAINTAINER jake@300brand.net

RUN        apt-get install -y beanstalkd

ADD        beanstalkd.conf /etc/supervisor/conf.d/beanstalkd.conf
EXPOSE     11300
