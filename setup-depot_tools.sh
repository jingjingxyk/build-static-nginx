#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}
shopt -s expand_aliases
cd ${__PROJECT__}

while [ $# -gt 0 ]; do
  case "$1" in
  --proxy)
    export HTTP_PROXY="$2"
    export HTTPS_PROXY="$2"
    NO_PROXY="127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16"
    NO_PROXY="${NO_PROXY},::1/128,fe80::/10,fd00::/8,ff00::/8"
    NO_PROXY="${NO_PROXY},localhost"
    NO_PROXY="${NO_PROXY},.aliyuncs.com,.aliyun.com,.tencent.com"
    NO_PROXY="${NO_PROXY},.myqcloud.com,.swoole.com"
    export NO_PROXY="${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn,.npmmirror.com"
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

mkdir -p ${__PROJECT__}/var/
cd ${__PROJECT__}/var/

if [ -d depot_tools ]; then
  cd depot_tools
  git pull
else
  git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
fi
cd ${__PROJECT__}/var/

export PATH=${__PROJECT__}/var/depot_tools::$PATH
gn -v

exit 0

if [ -d gn ]; then
  cd gn
  git pull
else
  git clone https://gn.googlesource.com/gn
fi
cd ${__PROJECT__}/var/gn
python3 build/gen.py
ninja -C out

export PATH=${__PROJECT__}/var/depot_tools:${__PROJECT__}/var/gn/out/:$PATH
gn -v
gn --help

# git config --global core.autocrlf false
# git config --global core.filemode false
# and for fun!
# git config --global color.ui true

# wiki
# https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools_tutorial.html#_setting_up

# https://chromium.googlesource.com/chromium/tools/depot_tools.git
# gn
# https://gn.googlesource.com/gn/+/main/docs/quick_start.md
# search gn
# https://source.chromium.org/gn/gn

# Getting gn binary
# https://gn.googlesource.com/gn

# search chromium
# https://source.chromium.org/chromium/chromium/src
