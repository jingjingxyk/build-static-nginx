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


${__PROJECT__}/runtime/swoole-cli/php  -c ${__DIR__}/php.ini  -S 0.0.0.0:8000 -t ${__DIR__}

