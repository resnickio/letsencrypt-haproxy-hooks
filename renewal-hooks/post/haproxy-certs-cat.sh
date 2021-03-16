#!/bin/bash

DATE=`date +"%Y-%m-%d %T"`
LIVE_CERT_DIR=/etc/letsencrypt/live
HAPROXY_CERT_DIR=/etc/haproxy/certs

mkdir -p $HAPROXY_CERT_DIR
mkdir -p $HAPROXY_CERT_DIR/logs

# Concatenate new cert files
for FILE in $LIVE_CERT_DIR/*; do
	if [ -d "$FILE" ]; then
		cd $FILE
		domain=${PWD##*/}
		cat fullchain.pem privkey.pem > $HAPROXY_CERT/$domain.pem
		echo $domain: $DATE >> $HAPROXY_CERT_DIR/logs/$domain.log
	fi
done

# Reload HAProxy if started
if ( systemctl -q is-active haproxy.service ); then
	systemctl reload haproxy
fi
