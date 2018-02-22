#!/bin/sh
#DOCKERID=`hostname`
#INSTHOST="$SIGSCI_HOSTNAME-$DOCKERID"
#SIGSCI_SERVER_HOSTNAME=$INSTHOST
#
#service apache2 start
#/usr/sbin/sigsci-agent 
#/usr/sbin/apache2 -DFOREGROUND

#!/usr/bin/env bash
#change this variable so that you can better which container is running your agent
# in the agent tab on the signal science dashboard
CONTAINER_NAME="nextcloud-sigsci"

pid=0

# SIGTERM-handler
term_handler() {
  echo "start.sh got sigterm"
  if [ $pid -ne 0 ]; then
    kill "$pid"
    wait "$pid"
  fi
  exit 143; # 128 + 15 -- SIGTERM
}
trap 'kill ${!}; term_handler' TERM

# run your application, customize this next line to launch your app
service apache2 start

pid="$!"

DOCKERID=`hostname`
INSTHOST="$CONTAINER_NAME-$DOCKERID"
export SIGSCI_SERVER_HOSTNAME=$INSTHOST

/usr/sbin/sigsci-agent &

# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done
