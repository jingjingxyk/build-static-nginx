#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

DOMAIN='http-proxy.example.com'
while [ $# -gt 0 ]; do
  case "$1" in
  --domain)
    DOMAIN="$2"
    ;;
  --*)
    echo "no found mirror option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

if [ ! -f ./runtime/socat/socat ]; then
  curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-socat-runtime.sh | bash -s -- --mirror china
fi

./runtime/socat/socat -d -d TCP4-LISTEN:8016,reuseaddr,fork ssl:${DOMAIN}:8015,verify=1,snihost=${DOMAIN},commonname=${DOMAIN},openssl-min-proto-version=TLS1.3,openssl-max-proto-version=TLS1.3,cafile=./runtime/socat/cacert.pem
