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
  OS="Linux"
  ;;
'Darwin')
  OS="Darwin"
  ;;
*)
  case $OS in
  'MSYS_NT'* | 'CYGWIN_NT'*)
    OS="Windows"
    ;;
  'MINGW64_NT'*)
    OS="Windows"
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

APP_VERSION='v2.10.2'
APP_NAME='goreleaser'
VERSION='v2.10.2'

cd ${__PROJECT__}
mkdir -p runtime/
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

cd ${__PROJECT__}/var/runtime

: <<'EOF'
https://github.com/goreleaser/goreleaser/releases/download/v2.10.2/goreleaser_Linux_x86_64.tar.gz
https://github.com/goreleaser/goreleaser/releases/download/v2.10.2/goreleaser_Linux_arm64.tar.gz
https://github.com/goreleaser/goreleaser/releases/download/v2.10.2/goreleaser_Darwin_arm64.tar.gz
https://github.com/goreleaser/goreleaser/releases/download/v2.10.2/goreleaser_Darwin_x86_64.tar.gz
https://github.com/goreleaser/goreleaser/releases/download/v2.10.2/goreleaser_Windows_x86_64.zip
https://github.com/goreleaser/goreleaser/releases/download/v2.10.2/goreleaser_Windows_arm64.zip
EOF

APP_DOWNLOAD_URL="https://github.com/goreleaser/goreleaser/releases/download/${VERSION}/${APP_NAME}_${OS}_${ARCH}.tar.gz"

if [ $OS = 'windows' ]; then
  APP_DOWNLOAD_URL="https://github.com/goreleaser/goreleaser/releases/download/${VERSION}/${APP_NAME}_${OS}_${ARCH}.zip"
fi

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

APP_RUNTIME="${APP_NAME}_${OS}_${ARCH}"

if [ $OS = 'windows' ]; then
  {
    test -f ${APP_RUNTIME}.zip || curl -LSo ${APP_RUNTIME}.zip ${APP_DOWNLOAD_URL}
    test -d ${APP_RUNTIME} && rm -rf ${APP_RUNTIME}
    unzip "${APP_RUNTIME}.zip"
    exit 0
  }
else
  test -f ${APP_RUNTIME}.tar.gz || curl -LSo ${APP_RUNTIME}.tar.gz ${APP_DOWNLOAD_URL}
  test -f ${APP_RUNTIME} && rm -rf ${APP_RUNTIME}
  mkdir -p ${__PROJECT__}/var/runtime/${APP_NAME}
  tar -C ${__PROJECT__}/var/runtime/${APP_NAME} -xf ${APP_RUNTIME}.tar.gz

  chmod +x ${__PROJECT__}/var/runtime/${APP_NAME}/goreleaser
  cp -rf ${__PROJECT__}/var/runtime/${APP_NAME}/. ${APP_RUNTIME_DIR}/
fi

cd ${__PROJECT__}/var/runtime

cd ${__PROJECT__}/

set +x

echo " "
echo " USE cloudreve RUNTIME :"
echo " "
echo " export PATH=\"${APP_RUNTIME_DIR}:\$PATH\" "
echo " "
echo " goreleaser home :  https://goreleaser.com/intro/#why-we-made-it "
echo " goreleaser source code :  https://github.com/goreleaser/goreleaser/ "
export PATH="${APP_RUNTIME_DIR}:$PATH"
goreleaser --help
