#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../../
  pwd
)
cd ${__DIR__}

{
  docker stop swoole-cli-ubuntu-dev
  sleep 5
} || {
  echo $?
}
cd ${__DIR__}
IMAGE=ubuntu:22.04
IMAGE=ubuntu:23.10
IMAGE=ubuntu:24.04

MIRROR=''
while [ $# -gt 0 ]; do
  case "$1" in
  --mirror)
    MIRROR="$2"
    case "$MIRROR" in
    china | openatom)
      IMAGE="hub.atomgit.com/library/ubuntu:24.04"
      ;;
    esac
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

cd ${__DIR__}

docker run --rm --name swoole-cli-ubuntu-dev -d -v ${__PROJECT__}:/work -w /work -e TZ='Etc/UTC' --init $IMAGE tail -f /dev/null
