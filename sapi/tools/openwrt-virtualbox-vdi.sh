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

while [ $# -gt 0 ]; do
  case "$1" in
  --proxy)
    export HTTP_PROXY="$2"
    export HTTPS_PROXY="$2"
    NO_PROXY="127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16"
    NO_PROXY="${NO_PROXY},127.0.0.1,localhost"
    NO_PROXY="${NO_PROXY},.aliyuncs.com,.aliyun.com"
    NO_PROXY="${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn"
    NO_PROXY="${NO_PROXY},.tencent.com"
    NO_PROXY="${NO_PROXY},.sourceforge.net"
    NO_PROXY="${NO_PROXY},.npmmirror.com"
    export NO_PROXY="${NO_PROXY}"
    ;;

  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

mkdir -p ${__PROJECT__}/var/openwrt/

cd ${__PROJECT__}/var/openwrt/

# 参考
# https://openwrt.org/docs/guide-user/virtualization/virtualbox-vm#convert_openwrtimg_to_vbox_drive


APP=openwrt-23.05.5-x86-generic-generic-ext4-combined.img.gz
APP_IMG=$(echo $APP | sed 's/.\{3\}$//')
APP_URL="https://downloads.openwrt.org/releases/23.05.5/targets/x86/generic/openwrt-23.05.5-x86-generic-generic-ext4-combined.img.gz"
# mirror
# https://mirrors.ustc.edu.cn/openwrt/
APP_URL_MIRROR=$(echo $APP_URL | sed  's/downloads.openwrt.org/mirrors.ustc.edu.cn\/openwrt/g')

# test -f ${APP} || curl -fSLo ${APP} ${APP_URL}https://downloads.openwrt.org/releases/24.10.0-rc5/targets/x86/generic/openwrt-24.10.0-rc5-x86-generic-generic-ext4-combined.img.gz
# test -f ${APP} || curl -fSLo ${APP} ${APP_UR}
test -f ${APP} || curl -fSLo ${APP} ${APP_URL_MIRROR}

test -f ${APP_IMG} && rm -f ${APP_IMG}
{
  gzip -k -d  ${APP}
} || {
  echo $?
}

test -f openwrt.img && rm -f openwrt.img
dd if=${APP_IMG} of=openwrt.img bs=128000 conv=sync

test -f openwrt.vdi && rm -f openwrt.vdi

VBoxManage convertfromraw --format VDI openwrt.img openwrt.vdi


# VBoxManage modifymedium openwrt.vdi --resize 128
