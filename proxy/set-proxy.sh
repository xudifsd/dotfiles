#!/bin/bash

GFWLIST=https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt
HOME=/tmp/proxy_share/

LOCAL_IP=`./get-lan-ip.sh`
LOCAL_PROXY=127.0.0.1:1080
SHARED_PROXY=$LOCAL_IP:8080

mkdir -p $HOME

if [ -f $HOME/http.pid ] ;
then
    kill -SIGTERM `cat $HOME/http.pid`
fi

if [ -f $HOME/haproxy.pid ] ;
then
    kill -SIGTERM `cat $HOME/haproxy.pid`
fi

cp haproxy.conf $HOME
haproxy -d -f $HOME/haproxy.conf > $HOME/haproxy.log 2>&1 &
echo $! > $HOME/haproxy.pid

sed s/LOCAL_SERVER/$LOCAL_IP/ global.pac.tpl > $HOME/global.pac

echo "Downloading gfwlist from $GFWLIST"
curl "$GFWLIST" --socks5-hostname "$LOCAL_PROXY" > /tmp/gfwlist.txt
# `pip install gfwlist2pac`
gfwlist2pac \
    --input /tmp/gfwlist.txt \
    --file $HOME/gfw.pac \
    --proxy "SOCKS5 $SHARED_PROXY; SOCKS $SHARED_PROXY; DIRECT" \
    --user-rule user_rule.txt
rm -f /tmp/gfwlist.txt

(
    cd $HOME
    python -m SimpleHTTPServer 8000 > $HOME/http.log 2>&1 &
    echo $! > $HOME/http.pid
)

echo http://$LOCAL_IP:8000/global.pac
echo http://$LOCAL_IP:8000/gfw.pac
