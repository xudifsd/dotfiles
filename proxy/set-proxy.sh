#!/bin/bash

HOME=/tmp/proxy_share/

LOCAL_IP=`./get-lan-ip.sh`

mkdir -p $HOME
sed s/LOCAL_SERVER/$LOCAL_IP/ proxy.pac.tpl > $HOME/proxy.pac

(
    cd $HOME
    python -m SimpleHTTPServer > $HOME/http.log 2>&1 &
)

cp haproxy.conf $HOME
haproxy -d -f $HOME/haproxy.conf > $HOME/haproxy.log 2>&1 &

echo http://$LOCAL_IP:8080/proxy.pac
