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
  echo 'no config for macos'
  exit 0
  ;;
*)
  case $OS in
  'MSYS_NT'* | 'CYGWIN_NT'*)
    OS="win"
    ;;
  'MINGW64_NT'*)
    OS="win"
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
  ARCH="64"
  ;;
'aarch64' | 'arm64')
  ARCH="arm64"
  ;;
*)
  echo '暂未配置的 ARCH '
  exit 0
  ;;
esac

APP_VERSION='master'
APP_NAME='ffmpeg'
VERSION='latest'

cd ${__PROJECT__}
mkdir -p runtime/
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/yt-dlp-${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

cd ${__PROJECT__}/var/runtime

# https://github.com/yt-dlp/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-linux64-gpl.tar.xz
# https://github.com/yt-dlp/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-linuxarm64-gpl.tar.xz
APP_DOWNLOAD_URL="https://github.com/yt-dlp/FFmpeg-Builds/releases/download/${VERSION}/${APP_NAME}-${APP_VERSION}-${VERSION}-${OS}${ARCH}-gpl.tar.xz"

if [ $OS = 'win' ]; then
  # https://github.com/yt-dlp/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip
  # https://github.com/yt-dlp/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-winarm64-gpl.zip
  APP_DOWNLOAD_URL="https://github.com/yt-dlp/FFmpeg-Builds/releases/download/${VERSION}/${APP_NAME}-${APP_VERSION}-${VERSION}-${OS}${ARCH}-gpl.zip"
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
  APP_DOWNLOAD_URL="https://php-cli.jingjingxyk.com/${APP_NAME}-${APP_VERSION}-${VERSION}-${OS}${ARCH}-gpl.tar.xz"
  if [ $OS = 'win' ]; then
    APP_DOWNLOAD_URL="https://php-cli.jingjingxyk.com/${APP_NAME}-${APP_VERSION}-${VERSION}-${OS}${ARCH}-gpl.zip"
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
  test -f ${APP_RUNTIME}.tar.xz || curl -LSo ${APP_RUNTIME}.tar.xz ${APP_DOWNLOAD_URL}
  test -f ${APP_RUNTIME}.tar || xz -d -k ${APP_RUNTIME}.tar.xz
  test -d ${APP_NAME} && rm -rf ${APP_NAME}
  tar -xvf ${APP_RUNTIME}.tar
  chmod a+x ${APP_NAME}/bin/ffmpeg
  cp -rf ${__PROJECT__}/var/runtime/${APP_NAME}/. ${APP_RUNTIME_DIR}/
fi

cd ${__PROJECT__}/var/runtime

cd ${__PROJECT__}/

set +x

echo " "
echo " USE FFMPEG RUNTIME :"
echo " "
echo " export PATH=\"${APP_RUNTIME_DIR}:\$PATH\" "
echo " "
echo " ./bin/runtime/yt-dlp-ffmpeg/ffmpeg -h "
echo " "
echo " ffmpeg docs : https://ffmpeg.org/documentation.html "
echo " ffmpeg docs : https://github.com/yt-dlp/FFmpeg-Builds "
echo " "
export PATH="${APP_RUNTIME_DIR}:$PATH"
