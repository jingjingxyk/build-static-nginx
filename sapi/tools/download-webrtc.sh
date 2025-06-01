#!/usr/bin/env bash

set -x
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../
  pwd
)
cd ${__PROJECT__}
mkdir -p ${__PROJECT__}/var/

while [ $# -gt 0 ]; do
  case "$1" in
  --proxy)
    export HTTP_PROXY="$2"
    export HTTPS_PROXY="$2"
    NO_PROXY="127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16"
    NO_PROXY="${NO_PROXY},::1/128,fe80::/10,fd00::/8,ff00::/8"
    NO_PROXY="${NO_PROXY},localhost"
    export NO_PROXY="${NO_PROXY}"
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

cd ${__PROJECT__}/var/

if [ -d webrtc ]; then
  cd webrtc
  git pull
else
  git clone https://webrtc.googlesource.com/src webrtc
  cd webrtc
  git remote add gitee git@gitee.com:jingjingxyk/webrtc.git
fi
cd ${__PROJECT__}/var/webrtc
git push gitee

exit 0

if [ -d webrtc ]; then
  cd webrtc
  git fetch --all
  #  等同于同于使用 git fetch --mirror
  # git remote update --prune
  git for-each-ref --format 'delete %(refname)' refs/pull | git update-ref --stdin
  git push --mirror
else

  git clone --mirror --progress https://webrtc.googlesource.com/src webrtc
  cd webrtc
  git remote set-url --push origin git@gitee.com:jingjingxyk/webrtc.git
  git remote -v
  git fetch -p origin
  git for-each-ref --format 'delete %(refname)' refs/pull | git update-ref --stdin
  git push --mirror
fi

cd ${__PROJECT__}/var/

du -sh ${__PROJECT__}/var/webrtc

# 有访问原始仓库的权限，并且想要快速且完整地镜像，可以使用 rsync
# rsync -av --delete git://url-to-original-repo/ /path/to/your/mirror/
