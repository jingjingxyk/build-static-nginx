#!/bin/bash

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}
set -uex



# 路由出口
ovn-nbctl lr-route-add lr01  "0.0.0.0/0" 10.1.30.1


