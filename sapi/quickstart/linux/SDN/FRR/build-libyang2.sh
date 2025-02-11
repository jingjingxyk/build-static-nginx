#!/usr/bin/env bash

set -eux
set -o pipefail


__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}

while [ $# -gt 0 ]; do
 case "$1" in
 --proxy)
   export HTTP_PROXY="$2"
   export HTTPS_PROXY="$2"
   NO_PROXY="127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16"
   NO_PROXY="${NO_PROXY},::1/128,fe80::/10,fd00::/8,ff00::/8"
   NO_PROXY="${NO_PROXY},.aliyuncs.com,.aliyun.com,.tencent.com"
   NO_PROXY="${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn,.npmmirror.com"
   NO_PROXY="${NO_PROXY},ftpmirror.gnu.org"
   NO_PROXY="${NO_PROXY},gitee.com,gitcode.com"
   NO_PROXY="${NO_PROXY},.myqcloud.com,.swoole.com"
   NO_PROXY="${NO_PROXY},dl-cdn.alpinelinux.org"
   NO_PROXY="${NO_PROXY},deb.debian.org,security.debian.org"
   NO_PROXY="${NO_PROXY},archive.ubuntu.com,security.ubuntu.com"
   NO_PROXY="${NO_PROXY},pypi.python.org,bootstrap.pypa.io"
   export NO_PROXY="${NO_PROXY},localhost"
   ;;
 --*)
   echo "Illegal option $1"
   ;;
 esac
 shift $(($# > 0 ? 1 : 0))
done

export LOGICAL_PROCESSORS=$(`nproc 2> /dev/null || sysctl -n hw.ncpu`)
export CMAKE_BUILD_PARALLEL_LEVEL=${LOGICAL_PROCESSORS}

git clone -b v3.7.8 --depth=1  https://github.com/CESNET/libyang.git

cd libyang
mkdir build
cd build
cmake .. .

cmake --build . --target install
