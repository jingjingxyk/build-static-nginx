#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}
shopt -s expand_aliases
cd ${__PROJECT__}

OS=$(uname -s)
ARCH=$(uname -m)

case $OS in
'Linux')
  OS="linux"
  ;;
'Darwin')
  OS="darwin"
  ;;
*)
  case $OS in
  'MSYS_NT'* | 'CYGWIN_NT'*)
    OS="windows"
    ;;
  'MINGW64_NT'*)
    OS="windows"
    ;;
  *)
    echo '暂未配置的 OS '
    exit 0
    ;;
  esac
  ;;
esac

case $ARCH in
'x86_64')
  ARCH="amd64"
  ;;
'aarch64' | 'arm64')
  ARCH="arm64"
  ;;
*)
  echo '暂未配置的 ARCH '
  exit 0
  ;;
esac

APP_VERSION='3.1.0'
APP_NAME='gost'
VERSION='v3.1.0'

cd ${__PROJECT__}
mkdir -p runtime/
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

cd ${__PROJECT__}/var/runtime

# https://github.com/go-gost/gost/releases/download/v3.1.0/gost_3.1.0_darwin_amd64.tar.gz
# https://github.com/go-gost/gost/releases/download/v3.1.0/gost_3.1.0_darwin_arm64.tar.gz

# https://github.com/go-gost/gost/releases/download/v3.1.0/gost_3.1.0_linux_amd64.tar.gz
APP_DOWNLOAD_URL="https://github.com/go-gost/gost/releases/download/${VERSION}/${APP_NAME}_${APP_VERSION}_${OS}_${ARCH}.tar.gz"

if [ $OS = 'win' ]; then
  # https://github.com/go-gost/gost/releases/download/v3.1.0/gost_3.1.0_windows_amd64.zip
  APP_DOWNLOAD_URL="https://github.com/go-gost/gost/releases/download/${VERSION}/${APP_NAME}_${APP_VERSION}_${OS}_${ARCH}.zip"
fi

MIRROR=''
while [ $# -gt 0 ]; do
  case "$1" in
  --mirror)
    MIRROR="$2"
    ;;
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

case "$MIRROR" in
china)
  APP_DOWNLOAD_URL="https://php-cli.jingjingxyk.com/${APP_NAME}_${APP_VERSION}_${OS}_${ARCH}.tar.gz"
  if [ $OS = 'windows' ]; then
    APP_DOWNLOAD_URL="https://php-cli.jingjingxyk.com/${APP_NAME}_${APP_VERSION}_${OS}_${ARCH}.zip"
  fi
  ;;

esac

APP_RUNTIME="${APP_NAME}-${APP_VERSION}-${OS}-${ARCH}"

if [ $OS = 'win' ]; then
  {
    test -f ${APP_RUNTIME}.zip || curl -LSo ${APP_RUNTIME}.zip ${APP_DOWNLOAD_URL}
    test -d ${APP_RUNTIME} && rm -rf ${APP_RUNTIME}
    unzip "${APP_RUNTIME}.zip"
    exit 0
  }
else
  test -f ${APP_RUNTIME}.tar.gz || curl -LSo ${APP_RUNTIME}.tar.gz ${APP_DOWNLOAD_URL}
  test -f ${APP_NAME} && rm -rf ${APP_NAME}
  test -d ${APP_NAME} && rm -rf ${APP_NAME}
  mkdir -p ${APP_NAME}
  tar -C ${APP_NAME} -xvf ${APP_RUNTIME}.tar.gz
  chmod a+x ${__PROJECT__}/var/runtime/${APP_NAME}/${APP_NAME}
  cp -rf ${__PROJECT__}/var/runtime/${APP_NAME}/. ${APP_RUNTIME_DIR}/
fi

cd ${__PROJECT__}/var/runtime

cd ${__PROJECT__}/

set +x

echo " "
echo " use gost runtime "
echo " "
echo " export PATH=\"${APP_RUNTIME_DIR}:\$PATH\" "
echo " "
echo " ./runtime/gost/gost -h "
echo " "
echo " gost docs : https://github.com/go-gost/gost "
echo " "
export PATH="${APP_RUNTIME_DIR}:$PATH"
gost -h
gost -V
