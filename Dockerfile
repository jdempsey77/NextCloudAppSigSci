# Dockerfile example for debian Signal Sciences agent container

#FROM ubuntu:xenial
FROM nextcloud:apache
MAINTAINER Jerry Dempsey <jerry@stylee.org>

RUN set -exu && \
mkdir -p /etc/dpkg/dpkg.conf.d && \
touch /etc/dpkg/dpkg.conf.d/01_nodoc && \
for e in doc-base doc groff info linda lintian man;\
  do echo "path-exclude /usr/share/${e}/*" >> /etc/dpkg/dpkg.conf.d/01_nodoc;\
done && \
export DEBIAN_FRONTEND=noninteractive && \
apt-get update -qq && \
apt-get install -qqyu --auto-remove --no-install-recommends --no-install-suggests apt-transport-https && \
rm -r /var/lib/apt/lists/* /etc/dpkg/dpkg.conf.d/

RUN apt-get update
RUN apt-get install -y curl gnupg

RUN curl -slL https://apt.signalsciences.net/gpg.key | apt-key add -
RUN echo "deb https://apt.signalsciences.net/release/ubuntu/ xenial main" > /etc/apt/sources.list.d/sigsci-release.list

RUN apt-get update; apt-get install -y sigsci-agent sigsci-module-apache apache2;  apt-get clean; /usr/sbin/a2enmod signalsciences 

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

