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
  ARCH="x64"
  ;;
'aarch64' | 'arm64')
  ARCH="arm64"
  ;;
*)
  echo '暂未配置的 ARCH '
  exit 0
  ;;
esac

APP_VERSION='v1.13.0'
APP_NAME='ninja'
VERSION='v1.13.0'

cd ${__PROJECT__}
mkdir -p runtime/
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

cd ${__PROJECT__}/var/runtime
: <<'EOF'
https://github.com/ninja-build/ninja/releases/download/v1.13.0/ninja-linux-aarch64.zip
https://github.com/ninja-build/ninja/releases/download/v1.13.0/ninja-linux.zip
https://github.com/ninja-build/ninja/releases/download/v1.13.0/ninja-win.zip
https://github.com/ninja-build/ninja/releases/download/v1.13.0/ninja-winarm64.zip
https://github.com/ninja-build/ninja/releases/download/v1.13.0/ninja-mac.zip
EOF

APP_DOWNLOAD_URL_PREFIX="https://github.com/ninja-build/ninja/releases/download/${VERSION}/"
APP_FILENAME="${APP_NAME}-${OS}-${ARCH}.zip"

case $OS$ARCH in
'linuxx64')
  APP_FILENAME="${APP_NAME}-${OS}.zip"
  ;;
'linuxarm64')
  APP_FILENAME="${APP_NAME}-${OS}-aarch64.zip"
  ;;
'macosx64' | 'macosarm64')
  APP_FILENAME="${APP_NAME}-mac.zip"
  ;;
'windowsx64')
  APP_FILENAME="${APP_NAME}-win.zip"
  ;;
'windowsarm64')
  APP_FILENAME="${APP_NAME}-winarm64.zip"
  ;;
*)
  echo '暂未配置的 ARCH '
  exit 0
  ;;
esac

APP_DOWNLOAD_URL="${APP_DOWNLOAD_URL_PREFIX}${APP_FILENAME}"

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

test -f ${APP_FILENAME} || curl -LSo ${APP_FILENAME} ${APP_DOWNLOAD_URL}
test -d ${__PROJECT__}/runtime/${APP_NAME} && rm -rf ${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${__PROJECT__}/var/runtime/${APP_NAME}

unzip -n -d ${__PROJECT__}/var/runtime/${APP_NAME} ${APP_FILENAME}
cp -f ${__PROJECT__}/var/runtime/${APP_NAME}/ninja ${__PROJECT__}/runtime/${APP_NAME}/

cd ${__PROJECT__}/

set +x

echo " "
echo " USE  ninja RUNTIME :"
echo " "
echo " export PATH=\"${APP_RUNTIME_DIR}/:\$PATH\" "
echo " "
echo " ninja docs :  https://ninja-build.org/ "
echo " "
export PATH="${APP_RUNTIME_DIR}:$PATH"

${__PROJECT__}/runtime/${APP_NAME}/ninja --help

# wiki
# https://ninja-build.org/
# https://github.com/ninja-build/ninja/wiki/Pre-built-Ninja-packages
