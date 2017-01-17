# Dockerfile example for debian Signal Sciences agent container

FROM ubuntu:xenial
MAINTAINER Signal Sciences Corp. 

COPY contrib/sigsci-release.list /etc/apt/sources.list.d/sigsci-release.list
RUN  apt-get update; apt-get install -y apt-transport-https curl ; curl -slL https://apt.signalsciences.net/gpg.key | apt-key add -; apt-get update; apt-get install -y sigsci-agent sigsci-module-apache apache2;  apt-get clean; /usr/sbin/a2enmod signalsciences; mkdir /var/lock/apache2
COPY contrib/index.html /var/www/html/index.html
COPY contrib/signalsciences.png /var/www/html/signalsciences.png


WORKDIR /app
ADD . /app

env APACHE_RUN_USER    www-data
env APACHE_RUN_GROUP   www-data
env APACHE_PID_FILE    /var/run/apache2.pid
env APACHE_RUN_DIR     /var/run/apache2
env APACHE_LOCK_DIR    /var/lock/apache2
env APACHE_LOG_DIR     /var/log/apache2
env LANG               C

#CMD ["-D", "FOREGROUND"]
# Start agent
#ENTRYPOINT ["/usr/sbin/apache2"]
ENTRYPOINT ["./start.sh"]

