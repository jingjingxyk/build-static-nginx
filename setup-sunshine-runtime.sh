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
APP_FILE_NAME=""

case $OS in
'Linux')
  OS="linux"
  APP_FILE_NAME="sunshine.AppImage"
  ;;
'Darwin')
  OS="darwin"
  APP_FILE_NAME="sunshine.rb"
  echo 'no support'
  exit 0
  ;;
*)
  case $OS in
  'MSYS_NT'* | 'CYGWIN_NT'*)
    OS="windows"
    APP_FILE_NAME="sunshine-windows-portable.zip"
    ;;
  'MINGW64_NT'*)
    OS="windows"
    APP_FILE_NAME="sunshine-windows-portable.zip"
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

APP_VERSION='v2025.628.4510'
APP_NAME='sunshine'
VERSION="${APP_VERSION}"

cd ${__PROJECT__}
mkdir -p runtime/
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

cd ${__PROJECT__}/var/runtime

# https://flatpak.org/setup/

# https://github.com/LizardByte/Sunshine/releases/download/v2025.628.4510/flathub.tar.gz
# https://github.com/LizardByte/Sunshine/releases/download/v2025.628.4510/sunshine_x86_64.flatpak
# https://github.com/LizardByte/Sunshine/releases/download/v2025.628.4510/sunshine-windows-portable.zip
# https://github.com/LizardByte/Sunshine/releases/download/v2025.628.4510/sunshine.AppImage
# https://github.com/LizardByte/Sunshine/releases/download/v2025.628.4510/sunshine.rb
APP_DOWNLOAD_URL="https://github.com/LizardByte/Sunshine/releases/download/${VERSION}/${APP_FILE_NAME}"

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
    APP_RUNTIME="sunshine-windows-portable"
    test -f ${APP_RUNTIME}.zip || curl -LSo ${APP_RUNTIME}.zip ${APP_DOWNLOAD_URL}
    test -d ${APP_RUNTIME} && rm -rf ${APP_RUNTIME}
    unzip "${APP_RUNTIME}.zip"
    exit 0
  }
else
  test -f sunshine.AppImage || curl -LSo sunshine.AppImage ${APP_DOWNLOAD_URL}
  chmod a+x sunshine.AppImage
  cp -f sunshine.AppImage ${APP_RUNTIME_DIR}/
fi

cd ${__PROJECT__}/
