#!/usr/bin/env bash

set -exu

__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)

# VPS 服务端监听
socat -d -d -d tcp-l:8080,reuseaddr,bind=0.0.0.0,fork tcp-l:80,bind=0.0.0.0,reuseaddr,retry=10
# 测试： curl -v http://127.0.0.1:8080

# 本地被访问的服务 localhost:9502
php sapi/webUI/bootstrap.php
socat -d -d -d -v tcp:socat-r.example.com:80,forever,intervall=10,fork tcp:localhost:9502
