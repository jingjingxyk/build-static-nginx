#!/usr/bin/env bash

set -xu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../
  pwd
)

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

VERSION='1.1.0'
MIRROR=''
FORCE=0
while [ $# -gt 0 ]; do
  case "$1" in
  --mirror)
    MIRROR="$2"
    ;;
  --force)
    FORCE=1
    ;;
  --proxy)
    export HTTP_PROXY="$2"
    export HTTPS_PROXY="$2"
    NO_PROXY="127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16"
    NO_PROXY="${NO_PROXY},::1/128,fe80::/10,fd00::/8,ff00::/8"
    NO_PROXY="${NO_PROXY},localhost"
    export NO_PROXY="${NO_PROXY},.myqcloud.com,.swoole.com"
    ;;
  --*)
    echo "Illegal option $1"
    exit 0
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

mkdir -p ${__PROJECT__}/var/runtime-scripts/${VERSION}
mkdir -p ${__PROJECT__}/pool/runtime-scripts

cd ${__PROJECT__}/var/runtime-scripts/${VERSION}

DOWNLOAD_RUNTIME_SCRIPT() {
  local name="$1"
  local RUNTIME_SCRIPT_DOWNLOAD_URL="https://github.com/jingjingxyk/swoole-cli/blob/new_dev/${name}?raw=true"
  if [ "$MIRROR" == "china" ]; then
    local RUNTIME_SCRIPT_DOWNLOAD_URL="https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/${name}"
  fi
  if [ $FORCE -eq 1 ]; then
    test -f ${name} && rm -f ${name}
  fi
  test -f ${name} || curl -fSLo ${name} ${RUNTIME_SCRIPT_DOWNLOAD_URL}
}

DOWNLOAD() {
  local CACERT_DOWNLOAD_URL="https://curl.se/ca/cacert.pem"
  if [ $FORCE -eq 1 ]; then
    test -f cacert.pem && rm -f cacert.pem
  fi
  test -f cacert.pem || curl -LSo cacert.pem ${CACERT_DOWNLOAD_URL}
  local CURRENT_DIR=$(pwd)

  cd ${__PROJECT__} || exit 0
  local DOWNLOAD_COMMANDS=''
  # RUNTIME_SCRIPTS=$(ls setup-*)
  # ls setup-* | xargs  -I {} echo {}
  RUNTIME_SCRIPTS=$(
cat <<EOF
setup-aria2-runtime.sh
setup-casdoor-runtime.sh
setup-cloudreve-bin-runtime.sh
setup-cloudreve-runtime.sh
setup-coturn-runtime.sh
setup-depot_tools.sh
setup-drawdb.sh
setup-drawio.sh
setup-electron.sh
setup-ffmpeg-runtime.sh
setup-filebrowser-runtime.sh
setup-geogebra.sh
setup-go-gost-runtime.sh
setup-go-runtime.sh
setup-goreleaser-runtime.sh
setup-immich.sh
setup-iperf3-runtime.sh
setup-libcef.sh
setup-linyaps-runtime.sh
setup-localsend-runtime.sh
setup-moonlight-runtime.sh
setup-nginx-runtime.sh
setup-ninja-runtime.sh
setup-nodejs-runtime.sh
setup-openjdk-runtime.sh
setup-openssh-runtime.sh
setup-php-cli-7.3-runtime.sh
setup-php-cli-7.4-runtime.sh
setup-php-cli-runtime.sh
setup-php-fpm-7.4-runtime.sh
setup-php-fpm-runtime.sh
setup-php-runtime.sh
setup-privoxy-runtime.sh
setup-python3-runtime.sh
setup-runtime.md
setup-seaweedfs-runtime.sh
setup-socat-runtime.sh
setup-sunshine-runtime.sh
setup-supervisord.sh
setup-swoole-cli-pre-runtime.sh
setup-swoole-cli-runtime.bat
setup-swoole-cli-runtime.ps1
setup-swoole-cli-runtime.sh
setup-swoole-docs.sh
setup-swow-cli-runtime.sh
setup-threejs-editor.sh
setup-ttyd-runtime.sh
setup-webBenchmark-runtime.sh
setup-webdav-runtime.sh
setup-websocat-runtime.sh
setup-wstunnel-runtime.sh
setup-yt-dlp-ffmpeg-runtime.sh
EOF
)
  cd $CURRENT_DIR || exit 0

  for NAME in $RUNTIME_SCRIPTS; do
    echo "NAME: $NAME "
    DOWNLOAD_RUNTIME_SCRIPT $NAME
  done
}

DOWNLOAD

cp -rf ${__PROJECT__}/var/runtime-scripts/${VERSION}/. ${__PROJECT__}/pool/runtime-scripts
