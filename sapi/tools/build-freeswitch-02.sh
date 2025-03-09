#!/usr/bin/env bash

set -exu

__CURRENT__=$(pwd)
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

# https://developer.signalwire.com/freeswitch/FreeSWITCH-Explained/Installation/Linux/Debian_67240088/
# https://freeswitch.org/confluence/display/FREESWITCH/Debian

TOKEN=pat_example

test -f /etc/apt/apt.conf.d/proxy.conf && rm -rf /etc/apt/apt.conf.d/proxy.conf
echo "127.0.0.1 $HOSTNAME" >>/etc/hosts
hostname --fqdn

apt-get update && apt-get install -y gnupg2 wget lsb-release

wget --http-user=signalwire --http-password=$TOKEN -O /usr/share/keyrings/signalwire-freeswitch-repo.gpg https://freeswitch.signalwire.com/repo/deb/debian-release/signalwire-freeswitch-repo.gpg

echo "machine freeswitch.signalwire.com login signalwire password $TOKEN" >/etc/apt/auth.conf
chmod 600 /etc/apt/auth.conf
echo "deb [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ $(lsb_release -sc) main" >/etc/apt/sources.list.d/freeswitch.list
echo "deb-src [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ $(lsb_release -sc) main" >>/etc/apt/sources.list.d/freeswitch.list

cat >/etc/apt/apt.conf.d/proxy.conf <<EOF
Acquire::http::Proxy "http://192.168.56.1:8016/";
Acquire::https::Proxy "http://192.168.56.1:8016/";
Acquire::NoProxy "127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,::1/128,fe80::/10,fd00::/8,ff00::/8,.tsinghua.edu.cn,.ustc.edu.cn,.npmmirror.com,localhost";
EOF
# apt-get -o Acquire::http::proxy=false install <package>

# you may want to populate /etc/freeswitch at this point.
# if /etc/freeswitch does not exist, the standard vanilla configuration is deployed
apt-get update && apt-get install -y freeswitch-meta-all

rm /etc/apt/apt.conf.d/proxy.conf

# tini -- /usr/bin/freeswitch -c
# fs_cli -rRS
