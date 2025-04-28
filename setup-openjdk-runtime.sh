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

https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_osx-x64_bin.tar.gz

https://services.gradle.org/distributions/gradle-8.12.1-bin.zip

EOF

APP_VERSION='24.0.1'
APP_NAME='openjdk'
VERSION='jdk24.0.1'
GRADLE_VERSION='8.12.1'

cd ${__PROJECT__}
mkdir -p runtime/
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

cd ${__PROJECT__}/var/runtime

APP_DOWNLOAD_URL="https://download.java.net/java/GA/jdk11/13/GPL/${APP_NAME}-${APP_VERSION}_${OS}-${ARCH}_bin.tar.gz"

if [ $OS = 'win' ]; then
  APP_DOWNLOAD_URL="https://download.java.net/java/GA/jdk11/13/GPL/${APP_NAME}-${APP_VERSION}_${OS}-${ARCH}_bin.zip"
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
  mkdir -p ${APP_RUNTIME}
  tar --strip-components=2 -C ${APP_RUNTIME} -xf ${APP_RUNTIME}.tar.gz
  # tar -xvf ${APP_RUNTIME}.tar.gz

  test -d ${APP_RUNTIME_DIR} && rm -rf ${APP_RUNTIME_DIR}
  mv ${APP_RUNTIME} ${APP_RUNTIME_DIR}
fi

GRADLE_APP="gradle-${GRADLE_VERSION}-bin"
test -f ${GRADLE_APP}.zip || curl -fSLo ${GRADLE_APP}.zip https://services.gradle.org/distributions/${GRADLE_APP}.zip
unzip -o ${GRADLE_APP}.zip

test -d ${__PROJECT__}/runtime/gradle && rm -rf ${__PROJECT__}/runtime/gradle
mkdir -p ${__PROJECT__}/runtime/gradle
cp -rf gradle-${GRADLE_VERSION}/. ${__PROJECT__}/runtime/gradle

cd ${__PROJECT__}/

set +x

echo " "
echo " USE PHP RUNTIME :"
echo " "
echo " export PATH=\"${APP_RUNTIME_DIR}/bin/:\$PATH\" "
echo " "

cd ${__PROJECT__}
if [ $OS=='macos' ]; then
  export PATH="${__PROJECT__}/runtime/openjdk/Contents/Home/bin/:${__PROJECT__}/runtime/gradle/bin/:$PATH"
  export JAVA_HOME="${__PROJECT__}/runtime/openjdk/Contents/Home/"
else
  export PATH="${__PROJECT__}/runtime/openjdk/bin/${__PROJECT__}/runtime/gradle/bin/:$PATH"
  export JAVA_HOME="${__PROJECT__}/runtime/openjdk/"
fi

which java
which gradle
java -version
gradle --version

# shellcheck disable=SC2217
: <<'EOF'

homepage: https://jdk.java.net/

https://openjdk.org/install/

# old version
https://jdk.java.net/archive/

ls ~/.gradle/
rm -rf ~/.gradle/

# show gradle release archive
# https://services.gradle.org/distributions/

Downloading https://services.gradle.org/distributions/gradle-8.12.1-bin.zip

EOF
