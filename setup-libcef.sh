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

if [ ! -d cef ]; then
  git clone -b master --depth=1 --progress https://bitbucket.org/chromiumembedded/cef.git
fi

# wiki
# https://bitbucket.org/chromiumembedded/cef/src/master/
# https://bitbucket.org/chromiumembedded/cef/wiki/Tutorial
# download cef
# https://cef-builds.spotifycdn.com/index.html

# https://bitbucket.org/chromiumembedded/cef/wiki/MasterBuildQuickStart
# https://bitbucket.org/chromiumembedded/cef/wiki/BranchesAndBuilding

# c++ styleguide
# https://chromium.googlesource.com/chromium/src/+/master/styleguide/c++/c++.md
