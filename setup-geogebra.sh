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

mkdir -p ${__PROJECT__}/var/
cd ${__PROJECT__}/var/
# test -d geogebra && rm -rf geogebra
# git clone --depth 1 https://github.com/geogebra/geogebra.git
cd geogebra

if [ $OS=='macos' ]; then
  export PATH="${__PROJECT__}/runtime/openjdk/Contents/Home/bin/:${__PROJECT__}/runtime/gradle/bin/:$PATH"
  export JAVA_HOME="${__PROJECT__}/runtime/openjdk/Contents/Home/"
else
  export PATH="${__PROJECT__}/runtime/openjdk/bin/${__PROJECT__}/runtime/gradle/bin/:$PATH"
  export JAVA_HOME="${__PROJECT__}/runtime/openjdk/"
fi

: <<'COMMENT'

cat >>gradle.properties <<EOF
systemProp.http.proxyHost=127.0.0.1
systemProp.http.proxyPort=8118
systemProp.http.nonProxyHosts="*.tsinghua.edu.cn | *.ustc.edu.cn"
systemProp.https.proxyHost=127.0.0.1
systemProp.https.proxyPort=8118
systemProp.https.nonProxyHosts="*.tsinghua.edu.cn | *.ustc.edu.cn"
# systemProp.socksProxyHost=127.0.0.1
# systemProp.socksProxyPort=2000
EOF

COMMENT

which java
which gradle
java -version
gradle --version

# ./gradlew :web:run --debug
./gradlew :web:run

exit 0
: <<'EOF'
# https://geogebra.github.io/docs/reference/en/GeoGebra_Installation/
# https://geogebra.github.io/integration/example-graphing.html

https://git.geogebra.org/ggb/geogebra.git

./gradlew :desktop:run


EOF
