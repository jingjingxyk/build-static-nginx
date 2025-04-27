#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd "${__DIR__}/"
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
  OS="osx"
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
  ARCH="aarch64"
  ;;
*)
  echo '暂未配置的 ARCH '
  exit 0
  ;;
esac

: <<'EOF'
https://download.java.net/java/GA/jdk24.0.1/24a58e0e276943138bf3e963e6291ac2/9/GPL/openjdk-24.0.1_linux-x64_bin.tar.gz
https://download.java.net/java/GA/jdk24.0.1/24a58e0e276943138bf3e963e6291ac2/9/GPL/openjdk-24.0.1_linux-aarch64_bin.tar.gz
https://download.java.net/java/GA/jdk24.0.1/24a58e0e276943138bf3e963e6291ac2/9/GPL/openjdk-24.0.1_macos-aarch64_bin.tar.gz
https://download.java.net/java/GA/jdk24.0.1/24a58e0e276943138bf3e963e6291ac2/9/GPL/openjdk-24.0.1_macos-x64_bin.tar.gz
https://download.java.net/java/GA/jdk24.0.1/24a58e0e276943138bf3e963e6291ac2/9/GPL/openjdk-24.0.1_windows-x64_bin.zip

https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_macos-aarch64_bin.tar.gz
https://download.java.net/java/GA/jdk9/9.0.4/binaries/openjdk-9.0.4_osx-x64_bin.tar.gz
EOF

APP_VERSION='9.0.4'
APP_NAME='openjdk'
VERSION='jdk21.0.2'

cd ${__PROJECT__}
mkdir -p runtime/
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

cd ${__PROJECT__}/var/runtime

APP_DOWNLOAD_URL="https://download.java.net/java/GA/jdk9/9.0.4/binaries//${APP_NAME}-${APP_VERSION}_${OS}-${ARCH}_bin.tar.gz"

if [ $OS = 'win' ]; then
  APP_DOWNLOAD_URL="https://download.java.net/java/GA/jdk9/9.0.4/binaries//${APP_NAME}-${APP_VERSION}_${OS}-${ARCH}_bin.zip"
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
    export NO_PROXY="${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn,.npmmirror.com"
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

APP_RUNTIME="${APP_NAME}-${APP_VERSION}-${OS}-${ARCH}"
if [ $OS = 'win' ]; then
  {
    test -f ${APP_RUNTIME}.zip || curl -fSLo ${APP_RUNTIME}.zip ${APP_DOWNLOAD_URL}
    test -d ${APP_RUNTIME} && rm -rf ${APP_RUNTIME}
    unzip "${APP_RUNTIME}.zip"
    exit 0
  }
else
  test -f ${APP_RUNTIME}.tar.gz || curl -fSLo ${APP_RUNTIME}.tar.gz ${APP_DOWNLOAD_URL}
  test -d ${APP_RUNTIME} && rm -rf ${APP_RUNTIME}
  # mkdir -p ${APP_RUNTIME}
  # tar --strip-components=1 -C ${APP_RUNTIME} -xf ${APP_RUNTIME}.tar.gz
  tar -xvf ${APP_RUNTIME}.tar.gz

  test -d ${APP_RUNTIME_DIR} && rm -rf ${APP_RUNTIME_DIR}
  # mv jdk-24.0.1.jdk ${APP_RUNTIME_DIR}
  # mv jdk-21.0.2.jdk ${APP_RUNTIME_DIR}
  mv jdk-9.0.4.jdk ${APP_RUNTIME_DIR}
fi

cd ${__PROJECT__}/

set +x

echo " "
echo " USE PHP RUNTIME :"
echo " "
echo " export PATH=\"${APP_RUNTIME_DIR}/bin/:\$PATH\" "
echo " "

cd ${__PROJECT__}
if [ $OS=='macos' ]; then
  export PATH="${APP_RUNTIME_DIR}/Contents/Home/bin/:$PATH"
  export JAVA_HOME="${APP_RUNTIME_DIR}/"
else
  export PATH="${APP_RUNTIME_DIR}/bin/:$PATH"
  export JAVA_HOME="${APP_RUNTIME_DIR}/"
fi

java -version

# shellcheck disable=SC2217
: <<'EOF'

homepage: https://jdk.java.net/

https://openjdk.org/install/

# old version
https://jdk.java.net/archive/

EOF
