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

APP_VERSION='3.12.2'
APP_NAME='python'
VERSION='v0.0.2'

cd ${__PROJECT__}
mkdir -p runtime/
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

cd ${__PROJECT__}/var/runtime

: <<'EOF'

https://github.com/jingjingxyk/build-static-python3/releases/download/v0.0.1/python-3.12.2-linux-arm64.tar.xz
https://github.com/jingjingxyk/build-static-python3/releases/download/v0.0.1/python-3.12.2-macos-x64.tar.xz

EOF

APP_DOWNLOAD_URL="https://github.com/jingjingxyk/build-static-python3/releases/download/${VERSION}/${APP_NAME}-${APP_VERSION}-${OS}-${ARCH}.tar.xz"

if [ $OS = 'windows' ]; then
  APP_DOWNLOAD_URL="https://github.com/jingjingxyk/build-static-python3/releases/download/${VERSION}/${APP_NAME}-${APP_VERSION}-${OS}-${ARCH}.zip"
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

APP_RUNTIME="${APP_NAME}-${APP_VERSION}-${OS}-${ARCH}"

if [ $OS = 'windows' ]; then
  {
    test -f ${APP_RUNTIME}.zip || curl -LSo ${APP_RUNTIME}.zip ${APP_DOWNLOAD_URL}
    test -d ${APP_RUNTIME} && rm -rf ${APP_RUNTIME}
    unzip "${APP_RUNTIME}.zip"
    exit 0
  }
else
  test -f ${APP_RUNTIME}.tar.xz || curl -LSo ${APP_RUNTIME}.tar.xz ${APP_DOWNLOAD_URL}
  test -f ${APP_RUNTIME}.tar || xz -d -k ${APP_RUNTIME}.tar.xz
  mkdir -p ${__PROJECT__}/var/runtime/${APP_NAME}/
  tar -C ${__PROJECT__}/var/runtime/${APP_NAME} -xf ${APP_RUNTIME}.tar
  rm -rf ${__PROJECT__}/var/runtime/${APP_NAME}/.completed
  sed -i.bak "s@/usr/local/swoole-cli/python3@${__PROJECT__}/runtime/python@" ${__PROJECT__}/var/runtime/${APP_NAME}/bin/2to3
  sed -i.bak "s@/usr/local/swoole-cli/python3@${__PROJECT__}/runtime/python@" ${__PROJECT__}/var/runtime/${APP_NAME}/bin/idle3
  sed -i.bak "s@/usr/local/swoole-cli/python3@${__PROJECT__}/runtime/python@" ${__PROJECT__}/var/runtime/${APP_NAME}/bin/pip3
  sed -i.bak "s@/usr/local/swoole-cli/python3@${__PROJECT__}/runtime/python@" ${__PROJECT__}/var/runtime/${APP_NAME}/bin/python3-config
  sed -i.bak "s@/usr/local/swoole-cli/python3@${__PROJECT__}/runtime/python@" ${__PROJECT__}/var/runtime/${APP_NAME}/bin/pydoc3
  sed -i.bak "s@/usr/local/swoole-cli/python3@${__PROJECT__}/runtime/python@" ${__PROJECT__}/var/runtime/${APP_NAME}/lib/pkgconfig/python3.pc
  cp -rf ${__PROJECT__}/var/runtime/${APP_NAME}/. ${APP_RUNTIME_DIR}/
fi

cd ${__PROJECT__}/var/runtime

cd ${__PROJECT__}/

set +x

echo " "
echo " USE python3 RUNTIME :"
echo " "
echo " export PATH=\"${APP_RUNTIME_DIR}/bin/:\$PATH\" "
echo " "
export PATH="${APP_RUNTIME_DIR}/bin/:$PATH"
python3 -V

: <<'EOF'

ls -lh ~/.local/
~/.local/bin/uv
uv python dir
uv tool dir

# 查看默认包安装目录
./runtime/python3/bin/python3 -m site --user-site

# pip3 install --target=/custom/path 指定目录‌
./runtime/python3/bin/pip3 install  uv -i https://pypi.tuna.tsinghua.edu.cn/simple -vv

# pip3 install -v 包名 > install.log 2>&1

# uv docs
# https://docs.astral.sh/uv/getting-started/installation/#pypi

EOF
