#!/usr/bin/env bash

set -exu

__DIR__=$(cd "$(dirname "$0")";pwd)

# 将 Unix Socket 转换为 TCP 连接
# socat TCP-LISTEN:端口号,fork UNIX-CONNECT:/usr/local/var/run/ovn//usr/local/var/run/ovn/ovnsb_db.sock
socat TCP-LISTEN:65528,fork UNIX-CONNECT:/usr/local/var/run/ovn/ovnnb_db.sock

# 将 TCP 转换为 Unix Socket
# socat TCP-CONNECT:目标地址:端口号 UNIX-CLIENT:/usr/local/var/run/ovn/ovnnb_db.sock
socat TCP-CONNECT:ovn-central.jingjingxyk.com:65528 UNIX-CLIENT:/usr/local/var/run/ovn/ovnnb_db.sock

# 本地获得服务器ovn-central 细腻洗
ovn-nbctl show
