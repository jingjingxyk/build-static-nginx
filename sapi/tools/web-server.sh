#!/usr/bin/env bash

__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)

cd ${__DIR__}

python3 -m http.server 8000 -d .
