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

cd ${__DIR__}
cd ${__PROJECT__}

test -d var/build-tini-aline-container/ && rm -rf var/build-tini-aline-container/
mkdir -p var/build-tini-aline-container/
cd ${__PROJECT__}/var/build-tini-aline-container/

cat >Dockerfile <<'EOF'
FROM alpine:3.20

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG MIRROR=""
RUN test -f /etc/apk/repositories.save || cp /etc/apk/repositories /etc/apk/repositories.save
RUN if [ "${MIRROR}" = "ustc" -o "${MIRROR}" = "china"   ]; then { sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories ; } fi
RUN if [ "${MIRROR}" = "tuna" ]; then { sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories ; } fi

RUN apk add ca-certificates tini bash

RUN mkdir /work
WORKDIR /work
ENTRYPOINT ["tini", "--"]

EOF

PLATFORM=''
ARCH=$(uname -m)
case $ARCH in
'x86_64')
  PLATFORM='linux/amd64'
  ;;
'aarch64')
  PLATFORM='linux/arm64'
  ;;
esac

while [ $# -gt 0 ]; do
  case "$1" in
  --platform)
    PLATFORM="$2"
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

TIME=$(date -u '+%Y%m%dT%H%M%SZ')
ARCH=$(uname -m)
VERSION="1.0.0"
TAG="alpine-3.20-v${VERSION}-${ARCH}-${TIME}"
IMAGE="docker.io/jingjingxyk/alpine-tini:${TAG}"

MIRROR='china'
docker buildx build -t ${IMAGE} -f ./Dockerfile . --platform ${PLATFORM} --build-arg="MIRROR=${MIRROR}"

echo ${IMAGE}
docker save -o "alpine-tini-image.tar" ${IMAGE}

docker run --rm --name demo ${IMAGE} tini --version
