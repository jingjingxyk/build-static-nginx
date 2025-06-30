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
  OS="macos"
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

if [ "${OS}" == "linux" ]; then
  OS='unknown-linux-musl'
  case $ARCH in
  'amd64')
    ARCH="max.x86_64"
    ;;
  'arm64')
    ARCH="max.aarch64"
    ;;
  esac
fi

if [ "${OS}" == "macos" ]; then
  OS='apple-darwin'
  case $ARCH in
  'amd64')
    ARCH="x86_64"
    ;;
  'arm64')
    ARCH="aarch64"
    ;;
  esac
fi

APP_VERSION='3.1.0'
APP_NAME='websocat'
VERSION='v1.14.0'

cd ${__PROJECT__}
mkdir -p runtime/
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

cd ${__PROJECT__}/var/runtime

# https://github.com/vi/websocat/releases/download/v1.14.0/websocat.aarch64-apple-darwin
# https://github.com/vi/websocat/releases/download/v1.14.0/websocat.x86_64-apple-darwin
# https://github.com/vi/websocat/releases/download/v1.14.0/websocat.x86_64-unknown-linux-musl
# https://github.com/vi/websocat/releases/download/v1.14.0/websocat_max.aarch64-unknown-linux-musl
# https://github.com/vi/websocat/releases/download/v1.14.0/websocat_max.x86_64-unknown-linux-musl
APP_DOWNLOAD_URL="https://github.com/vi/websocat/releases/download/${VERSION}/${APP_NAME}.${ARCH}-${OS}"

if [ $OS = 'windows' ]; then
  # https://github.com/vi/websocat/releases/download/v1.14.0/websocat.x86_64-pc-windows-gnu.exe
  APP_DOWNLOAD_URL="https://github.com/vi/websocat/releases/download/${VERSION}/${APP_NAME}.${ARCH}-pc-windows-gnu.exe"
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
  APP_DOWNLOAD_URL="https://php-cli.jingjingxyk.com/${APP_NAME}.${ARCH}-${OS}"
  if [ $OS = 'windows' ]; then
    APP_DOWNLOAD_URL="https://php-cli.jingjingxyk.com/${APP_NAME}.${ARCH}-pc-windows-gnu.exe"
  fi
  ;;

esac

APP_RUNTIME="${APP_NAME}.${ARCH}-${OS}"

if [ $OS = 'win' ]; then
  {
    test -f ${APP_NAME}.${ARCH}-pc-windows-gnu.exe || curl -LSo ${APP_NAME}.${ARCH}-pc-windows-gnu.exe ${APP_DOWNLOAD_URL}
    exit 0
  }
else
  test -f ${APP_RUNTIME} || curl -LSo ${APP_RUNTIME} ${APP_DOWNLOAD_URL}
  chmod a+x ${APP_RUNTIME}
  cp -f ${__PROJECT__}/var/runtime/${APP_RUNTIME} ${APP_RUNTIME_DIR}/websocat
fi

cd ${__PROJECT__}/var/runtime

cd ${__PROJECT__}/

set +x

echo " "
echo " use websocat runtime "
echo " "
echo " export PATH=\"${APP_RUNTIME_DIR}:\$PATH\" "
echo " "
echo " ./runtime/websocat/websocat -h "
echo " "
echo " websocat docs : https://github.com/vi/websocat "
echo " "
export PATH="${APP_RUNTIME_DIR}:$PATH"
websocat -h
websocat -V
