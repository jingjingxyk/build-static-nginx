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

APP_VERSION='v2.33.4'
APP_NAME='filebrowser'
VERSION='v2.33.4'

cd ${__PROJECT__}
mkdir -p runtime/
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

cd ${__PROJECT__}/var/runtime

APP_DOWNLOAD_URL="https://github.com/filebrowser/filebrowser/releases/download/${VERSION}/${OS}-${ARCH}-${APP_NAME}.tar.gz"

if [ $OS = 'windows' ]; then
  APP_DOWNLOAD_URL="https://github.com/filebrowser/filebrowser/releases/download/${VERSION}/windows-amd64-filebrowser.zip"
fi

MIRROR=''
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

APP_RUNTIME="${APP_NAME}-${APP_VERSION}-${OS}-${ARCH}"

if [ $OS = 'windows' ]; then
  {
    APP_RUNTIME="${APP_NAME}-${APP_VERSION}-windows-${ARCH}"
    test -f ${APP_RUNTIME}.zip || curl -LSo ${APP_RUNTIME}.zip ${APP_DOWNLOAD_URL}
    test -d ${APP_RUNTIME} && rm -rf ${APP_RUNTIME}
    unzip "${APP_RUNTIME}.zip"
    exit 0
  }
else
  test -f ${APP_RUNTIME}.tar.gz || curl -LSo ${APP_RUNTIME}.tar.gz ${APP_DOWNLOAD_URL}
  test -d ${APP_NAME} && rm -rf ${APP_NAME}
  mkdir -p ${APP_NAME}
  cd ${APP_NAME}
  tar -xvf ${__PROJECT__}/var/runtime/${APP_RUNTIME}.tar.gz
  chmod a+x ${APP_NAME}
  cp -rf ${__PROJECT__}/var/runtime/${APP_NAME}/ ${APP_RUNTIME_DIR}/
fi

cd ${__PROJECT__}/

set +x

echo " "
echo " USE filebrowser :"
echo " "
echo " export PATH=\"${APP_RUNTIME_DIR}:\$PATH\" "
echo " "
echo " filebrowser docs :  https://github.com/filebrowser/filebrowser "
echo " "
echo " dowload script https://github.com/filebrowser/get "
echo " "
echo " filebrowser -r /path/to/your/files"
echo " "
export PATH="${APP_RUNTIME_DIR}:$PATH"
filebrowser --help
