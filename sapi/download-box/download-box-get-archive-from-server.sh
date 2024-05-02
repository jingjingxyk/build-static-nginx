#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../
  pwd
)
cd ${__PROJECT__}

mkdir -p  pool/lib
mkdir -p  pool/ext

mkdir -p ${__PROJECT__}/var/download-box/

cd ${__PROJECT__}/var/download-box/

if [ -f "${__PROJECT__}/sapi/PHP-VERSION.conf"  ] ; then
  DOMAIN='https://github.com/swoole/swoole-cli/releases/download/v5.1.1.0/'
  ALL_DEPS_HASH="1b8bbd1b64e196b1d56c940fc62079fac8c2cd106867f9534fadb40ee02beaec"
else
  DOMAIN='https://github.com/swoole/build-static-php/releases/download/v1.1.0/'
  ALL_DEPS_HASH="49fc4e76422c3b182258c95def6c2cbb45d952bde39cec958f3a17ec0e579116"
fi

while [ $# -gt 0 ]; do
  case "$1" in
  --mirror)
    if [ "$2" = 'china' ] ; then
      DOMAIN='https://swoole-cli.jingjingxyk.com/'
      if [ ! -f "${__PROJECT__}/sapi/PHP-VERSION.conf" ] ; then
         DOMAIN='https://php-cli.jingjingxyk.com/'
      fi
    fi
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done


URL="${DOMAIN}/all-archive.zip"
# URL="${DOMAIN}/all-deps.zip" # 下一个版本启用此命名

test -f  all-deps.zip || curl -Lo  all-deps.zip ${URL}

# https://www.runoob.com/linux/linux-comm-unzip.html
# -o 不必先询问用户，unzip执行后覆盖原有文件。
# -n 解压缩时不要覆盖原有的文件。

# hash 签名
HASH=$(sha256sum all-deps.zip | awk '{print $1}')

# 签名验证失败，删除下载文件
if [ ${HASH} !=	 ${ALL_DEPS_HASH} ] ; then
    echo 'hash signature is invalid ！'
    rm -f all-deps.zip
    echo '                       '
    echo ' Please Download Again '
    echo '                       '
    exit 0
fi

unzip -n all-deps.zip


cd ${__PROJECT__}/

awk 'BEGIN { cmd="cp -ri var/download-box/lib/* pool/lib"  ; print "n" |cmd; }'
awk 'BEGIN { cmd="cp -ri var/download-box/ext/* pool/ext"; print "n" |cmd; }'


echo "download all-archive.zip ok ！"
