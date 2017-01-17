#!/bin/sh
DOCKERID=`hostname`
INSTHOST="$SIGSCI_HOSTNAME-$DOCKERID"
SIGSCI_SERVER_HOSTNAME=$INSTHOST

service apache2 start
/usr/sbin/sigsci-agent 
#/usr/sbin/apache2 -DFOREGROUND
