#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}
shopt -s expand_aliases
cd ${__PROJECT__}

APP_VERSION='3.0.4'
APP_NAME='blender'
VERSION="v3.0"
APP_FILE_NAME=""

OS=$(uname -s)
ARCH=$(uname -m)

case $OS in
'Linux')
  OS="linux"
  APP_FILE_NAME="AppImage"
  ;;
'Darwin')
  OS="darwin"
  APP_FILE_NAME="dmg"
  ;;
*)
  case $OS in
  'MSYS_NT'* | 'CYGWIN_NT'* | 'MINGW64_NT'*)
    OS="windows"
    APP_FILE_NAME="dmg"
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
  ARCH="x86_64"
  ;;
'aarch64' | 'arm64')
  ARCH="arm64"
  ;;
*)
  echo '暂未配置的 ARCH '
  exit 0
  ;;
esac

cd ${__PROJECT__}
mkdir -p runtime/
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

cd ${__PROJECT__}/var/runtime

# homepage
# https://www.blender.org
# https://www.blender.org/download/

# https://www.blender.org/download/release/Blender4.4/blender-4.4.3-macos-x64.dmg/
# https://www.blender.org/download/release/Blender4.4/blender-4.4.3-macos-arm64.dmg/

#  https://www.blender.org/download/release/Blender4.4/blender-4.4.3-windows-x64.zip/

# https://www.blender.org/download/release/Blender4.4/blender-4.4.3-linux-x64.tar.xz/

exit 0
APP_DOWNLOAD_URL="https://download.gimp.org/gimp/${VERSION}/${OS}/${APP_NAME}-${APP_VERSION}-${ARCH}.${suffix}"

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

if [ $OS = 'windows' ]; then
  {
    APP_RUNTIME="${APP_NAME}"
    test -f ${APP_RUNTIME}.zip || curl -LSo ${APP_RUNTIME}.zip ${APP_DOWNLOAD_URL}
    test -d ${APP_RUNTIME} && rm -rf ${APP_RUNTIME}
    unzip "${APP_RUNTIME}.zip"
    exit 0
  }
else
  test -f ${APP_FILE_NAME} || curl -LSo ${APP_FILE_NAME} ${APP_DOWNLOAD_URL}
  cp -rf ${APP_FILE_NAME} ${APP_RUNTIME_DIR}/
fi

cd ${__PROJECT__}/

ls -lha ${APP_RUNTIME_DIR}
