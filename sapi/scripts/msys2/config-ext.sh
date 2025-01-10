#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../../
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
BUILD_DIR=${__PROJECT__}/var/msys2-build/
mkdir -p ${BUILD_DIR}
mkdir -p ${BUILD_DIR}/ext/

test -d ext && rm -rf ext
mkdir -p ext

cd ${__PROJECT__}/pool/ext
if [ ! -f redis-${REDIS_VERSION}.tgz ]; then
  curl -fSLo ${BUILD_DIR}/redis-${REDIS_VERSION}.tgz https://pecl.php.net/get/redis-${REDIS_VERSION}.tgz
  mv ${BUILD_DIR}/redis-${REDIS_VERSION}.tgz ${__PROJECT__}/pool/ext
fi
mkdir -p ${__PROJECT__}/ext/redis/
tar --strip-components=1 -C ${__PROJECT__}/ext/redis/ -xf redis-${REDIS_VERSION}.tgz

cd ${__PROJECT__}/pool/ext
if [ ! -f yaml-${YAML_VERSION}.tgz ]; then
  curl -fSLo ${BUILD_DIR}/yaml-${YAML_VERSION}.tgz https://pecl.php.net/get/yaml-${YAML_VERSION}.tgz
  mv ${BUILD_DIR}/yaml-${YAML_VERSION}.tgz ${__PROJECT__}/pool/ext
fi
mkdir -p ${__PROJECT__}/ext/yaml/
tar --strip-components=1 -C ${__PROJECT__}/ext/yaml/ -xf yaml-${YAML_VERSION}.tgz

cd ${__PROJECT__}/pool/ext
if [ ! -f imagick-${IMAGICK_VERSION}.tgz ]; then
  curl -fSLo ${BUILD_DIR}/imagick-${IMAGICK_VERSION}.tgz https://pecl.php.net/get/imagick-${IMAGICK_VERSION}.tgz
  mv ${BUILD_DIR}/imagick-${IMAGICK_VERSION}.tgz ${__PROJECT__}/pool/ext
fi
mkdir -p ${__PROJECT__}/ext/imagick/
tar --strip-components=1 -C ${__PROJECT__}/ext/imagick/ -xf imagick-${IMAGICK_VERSION}.tgz
if [ "$X_PHP_VERSION" = "8.4" ]; then
  sed -i.backup "s/php_strtolower(/zend_str_tolower(/" ${__PROJECT__}/ext/imagick/imagick.c
fi

cd ${__PROJECT__}/pool/ext
if [ ! -f swoole-${SWOOLE_VERSION}.tgz ]; then
  test -d ${BUILD_DIR}/swoole && rm -rf ${BUILD_DIR}/swoole
  git clone -b ${SWOOLE_VERSION} https://github.com/swoole/swoole-src.git ${BUILD_DIR}/swoole
  cd ${BUILD_DIR}/swoole
  tar -czvf ${BUILD_DIR}/swoole-${SWOOLE_VERSION}.tgz .
  mv ${BUILD_DIR}/swoole-${SWOOLE_VERSION}.tgz ${__PROJECT__}/pool/ext
fi
cd ${__PROJECT__}/pool/ext
mkdir -p ${__PROJECT__}/ext/swoole/
tar --strip-components=1 -C ${__PROJECT__}/ext/swoole/ -xf swoole-${SWOOLE_VERSION}.tgz

# download php-src source code
cd ${__PROJECT__}/pool/php-tar
if [ ! -f php-${PHP_VERSION}.tar.gz ]; then
  curl -fSLo php-${PHP_VERSION}.tar.gz https://github.com/php/php-src/archive/refs/tags/php-${PHP_VERSION}.tar.gz
fi
test -d ${BUILD_DIR}/php-src && rm -rf ${BUILD_DIR}/php-src
mkdir -p ${BUILD_DIR}/php-src
tar --strip-components=1 -C ${BUILD_DIR}/php-src -xf php-${PHP_VERSION}.tar.gz

cd ${__PROJECT__}
