#!/usr/bin/env bash

set -exu
__CURRENT__=`pwd`
__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}/

bash bin/runtime/privoxy/privoxy-start.sh
