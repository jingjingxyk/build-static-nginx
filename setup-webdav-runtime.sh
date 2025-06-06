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
  'MSYS_NT'*)
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

APP_VERSION='v5.7.4'
APP_NAME='webdav'
VERSION='v5.7.4'

cd ${__PROJECT__}
mkdir -p runtime/
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

cd ${__PROJECT__}/var/runtime

: <<'EOF'

https://github.com/hacdias/webdav/releases

https://github.com/hacdias/webdav/releases/download/v5.7.4/windows-amd64-webdav.zip
https://github.com/hacdias/webdav/releases/download/v5.7.4/windows-arm64-webdav.zip
https://github.com/hacdias/webdav/releases/download/v5.7.4/linux-arm64-webdav.tar.gz
https://github.com/hacdias/webdav/releases/download/v5.7.4/linux-amd64-webdav.tar.gz
https://github.com/hacdias/webdav/releases/download/v5.7.4/darwin-amd64-webdav.tar.gz
https://github.com/hacdias/webdav/releases/download/v5.7.4/darwin-arm64-webdav.tar.gz

EOF

APP_DOWNLOAD_URL="https://github.com/hacdias/webdav/releases/download/${VERSION}/${OS}-${ARCH}-${APP_NAME}.tar.gz"

if [ $OS = 'windows' ]; then
  APP_DOWNLOAD_URL="https://github.com/hacdias/webdav/releases/download/${VERSION}/${OS}-${ARCH}-${APP_NAME}.zip"
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
  APP_DOWNLOAD_URL="https://php-cli.jingjingxyk.com/${APP_NAME}/${OS}-${ARCH}-${APP_NAME}.tar.gz"
  if [ $OS = 'windows' ]; then
    APP_DOWNLOAD_URL="https://php-cli.jingjingxyk.com/${APP_NAME}/${OS}-${ARCH}-${APP_NAME}.zip"
  fi
  ;;
esac

APP_RUNTIME="${OS}-${ARCH}-${APP_NAME}"
if [ $OS = 'windows' ]; then
  test -f ${APP_RUNTIME}.zip || curl -LSo ${APP_RUNTIME}.zip ${APP_DOWNLOAD_URL}
  test -d ${APP_RUNTIME} && rm -rf ${APP_RUNTIME}
  unzip "${APP_RUNTIME}.zip"
  exit 0
else
  test -f ${APP_RUNTIME}.tar.gz || curl -LSo ${APP_RUNTIME}.tar.gz ${APP_DOWNLOAD_URL}
  test -d ${APP_RUNTIME} && rm -rf ${APP_RUNTIME}
  tar -xvf ${APP_RUNTIME}.tar.gz
  mv webdav ${__PROJECT__}/runtime/${APP_NAME}/
fi

cd ${__PROJECT__}/

set +x

echo " "
echo " USE webdav RUNTIME :"
echo " docs: https://github.com/hacdias/webdav.git"
echo " "
echo " export PATH=\"${APP_RUNTIME_DIR}/:\$PATH\" "
echo " "
echo " ./runtime/webdav --config ./runtime/webdav/webdav.yml"
echo " "
export PATH="${APP_RUNTIME_DIR}/:$PATH"
webdav --help

