#!/usr/bin/env bash

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

PHP_VERSION='8.2.27'
SWOOLE_VERSION='v6.0.0'
X_PHP_VERSION='8.2'

while [ $# -gt 0 ]; do
  case "$1" in
  --php-version)
    PHP_VERSION="$2"
    X_PHP_VERSION=$(echo ${PHP_VERSION:0:3})
    ;;
  --swoole-version)
    SWOOLE_VERSION="$2"
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

REDIS_VERSION=6.1.0
YAML_VERSION=2.2.2
IMAGICK_VERSION=3.7.0

mkdir -p pool/ext
mkdir -p pool/lib
mkdir -p pool/php-tar
mkdir -p var/cygwin-build/

test -d ext && rm -rf ext
mkdir -p ext

cd ${__PROJECT__}/pool/ext
if [ ! -f redis-${REDIS_VERSION}.tgz ]; then
  curl -fSLo redis-${REDIS_VERSION}.tgz https://pecl.php.net/get/redis-${REDIS_VERSION}.tgz
fi
mkdir -p ${__PROJECT__}/ext/redis/
tar --strip-components=1 -C ${__PROJECT__}/ext/redis/ -xf redis-${REDIS_VERSION}.tgz

cd ${__PROJECT__}/pool/ext
if [ ! -f yaml-${YAML_VERSION}.tgz ]; then
  curl -fSLo yaml-${YAML_VERSION}.tgz https://pecl.php.net/get/yaml-${YAML_VERSION}.tgz
fi
mkdir -p ${__PROJECT__}/ext/yaml/
tar --strip-components=1 -C ${__PROJECT__}/ext/yaml/ -xf yaml-${YAML_VERSION}.tgz

cd ${__PROJECT__}/pool/ext
if [ ! -f imagick-${IMAGICK_VERSION}.tgz ]; then
  curl -fSLo imagick-${IMAGICK_VERSION}.tgz https://pecl.php.net/get/imagick-${IMAGICK_VERSION}.tgz
fi
mkdir -p ${__PROJECT__}/ext/imagick/
tar --strip-components=1 -C ${__PROJECT__}/ext/imagick/ -xf imagick-${IMAGICK_VERSION}.tgz
if [ "$X_PHP_VERSION" = "8.4" ]; then
  sed -i.backup "s/php_strtolower(/zend_str_tolower(/" ${__PROJECT__}/ext/imagick/imagick.c
fi

cd ${__PROJECT__}/pool/ext
if [ ! -f swoole-${SWOOLE_VERSION}.tgz ]; then
  test -d ${__PROJECT__}/var/cygwin-build/swoole && rm -rf ${__PROJECT__}/var/cygwin-build/swoole
  git clone -b ${SWOOLE_VERSION} https://github.com/swoole/swoole-src.git ${__PROJECT__}/var/cygwin-build/swoole
  cd ${__PROJECT__}/var/cygwin-build/swoole
  tar -czvf ${__PROJECT__}/pool/ext/swoole-${SWOOLE_VERSION}.tgz .
  cd ${__PROJECT__}/pool/ext
fi
mkdir -p ${__PROJECT__}/ext/swoole/
tar --strip-components=1 -C ${__PROJECT__}/ext/swoole/ -xf swoole-${SWOOLE_VERSION}.tgz

cd ${__PROJECT__}/pool/php-tar
# download php-src source code
if [ ! -f php-${PHP_VERSION}.tar.gz ]; then
  curl -fSLo php-${PHP_VERSION}.tar.gz https://github.com/php/php-src/archive/refs/tags/php-${PHP_VERSION}.tar.gz
fi
test -d ${__PROJECT__}/var/cygwin-build/php-src && rm -rf ${__PROJECT__}/var/cygwin-build/php-src
mkdir -p ${__PROJECT__}/var/cygwin-build/php-src
tar --strip-components=1 -C ${__PROJECT__}/var/cygwin-build/php-src -xf php-${PHP_VERSION}.tar.gz

cd ${__PROJECT__}
