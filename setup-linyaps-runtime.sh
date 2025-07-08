#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}
shopt -s expand_aliases
cd ${__PROJECT__}

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

OS=$(uname -s)
if [ "${OS}" = 'Linux' ]; then
  OS_RELEASE=$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '\n' | tr -d '\"')
  case "$OS_RELEASE" in
  'rocky' | 'almalinux' | 'alinux' | 'anolis' | 'fedora' | 'openEuler' | 'hce') # |  'amzn' | 'ol' | 'rhel' | 'centos'  # 未测试
    yum update -y
    yum install -y which
    ;;
  'ubuntu') ;;

  'alpine')
    apk update
    apk add bash
    ;;
  'arch')
    pacman -Syyu --noconfirm
    pacman -Sy --noconfirm which
    ;;
  esac
fi

if [ "${OS}" = 'Linux' ]; then
  OS_RELEASE=$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '\n' | tr -d '\"')
  case "$OS_RELEASE" in
  'rocky' | 'almalinux' | 'alinux' | 'anolis' | 'fedora' | 'openEuler' | 'hce') # |  'amzn' | 'ol' | 'rhel' | 'centos'  # 未测试

    ;;
  'debian') # | 'ubuntu' | 'kali' | 'raspbian' | 'deeping'| 'uos' | 'kylin'
    export DEBIAN_FRONTEND=noninteractive
    export TZ="Etc/UTC"
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ >/etc/timezone
    apt update -y
    echo "deb [trusted=yes] https://ci.deepin.com/repo/obs/linglong:/CI:/release/Debian_12/ ./" | sudo tee /etc/apt/sources.list.d/linglong.list
    sudo apt update
    sudo apt install linglong-builder linglong-box linglong-bin

    ;;
  'alpine') ;;

  'arch') ;;

  esac

fi

# homepage
# https://linyaps.org.cn/

# wiki
# https://linyaps.org.cn/guide/start/whatis.html
# https://linyaps.org.cn/guide/start/install.html

# app store
# https://store.linyaps.org.cn/

ll-cli --help
ll-builder --help
