#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
    cd ${__DIR__}/../../
    pwd
  )
shopt -s expand_aliases
cd ${__PROJECT__}

APP_VERSION='1.0.0'
APP_NAME='phpx'
VERSION='v1.0.0'

cd ${__PROJECT__}
mkdir -p var
APP_RUNTIME_DIR=${__PROJECT__}/var/${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

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

cd ${APP_RUNTIME_DIR}

if [ -d phpx ] ;then
  cd phpx
  git pull
else
  git clone https://github.com/swoole/phpx.git
fi
cd ${APP_RUNTIME_DIR}/
cd phpx
# bash ./build.sh




mkdir -p build
cd build

cmake .. \
-DCMAKE_INSTALL_PREFIX=/usr/local/swoole-cli/phpx \
-DCMAKE_BUILD_TYPE=Release  \
-DBUILD_SHARED_LIBS=OFF  \
-DBUILD_STATIC_LIBS=ON

exit 0

cmake .
make -j 4
sudo make install
sudo ldconfig
