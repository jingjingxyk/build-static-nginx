#!/usr/bin/env bash
#set -euo pipefail

set -eux
set -o pipefail

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}


while [ $# -gt 0 ]; do
 case "$1" in
 --proxy)
   export HTTP_PROXY="$2"
   export HTTPS_PROXY="$2"
   NO_PROXY="127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16"
   NO_PROXY="${NO_PROXY},::1/128,fe80::/10,fd00::/8,ff00::/8"
   NO_PROXY="${NO_PROXY},.aliyuncs.com,.aliyun.com,.tencent.com"
   NO_PROXY="${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn,.npmmirror.com"
   NO_PROXY="${NO_PROXY},ftpmirror.gnu.org"
   NO_PROXY="${NO_PROXY},gitee.com,gitcode.com"
   NO_PROXY="${NO_PROXY},.myqcloud.com,.swoole.com"
   NO_PROXY="${NO_PROXY},dl-cdn.alpinelinux.org"
   NO_PROXY="${NO_PROXY},deb.debian.org,security.debian.org"
   NO_PROXY="${NO_PROXY},archive.ubuntu.com,security.ubuntu.com"
   NO_PROXY="${NO_PROXY},pypi.python.org,bootstrap.pypa.io"
   export NO_PROXY="${NO_PROXY},localhost"
   ;;
 --*)
   echo "Illegal option $1"
   ;;
 esac
 shift $(($# > 0 ? 1 : 0))
done

OS_ID=$(cat /etc/os-release | grep '^ID=' | awk -F '=' '{print $2}')
VERSION_ID=$(cat /etc/os-release | grep '^VERSION_ID=' | awk -F '=' '{print $2}' | sed "s/\"//g")

if [ ${OS_ID} = 'debian'  ] || [ ${OS_ID} = 'ubuntu' ] ; then
    echo 'supported OS'
else
    echo 'no supported OS'
    exit 0
fi

CPU_NUMS=$(nproc)
CPU_NUMS=$(grep "processor" /proc/cpuinfo | sort -u | wc -l)

cd ${__DIR__}
if test -d frr
then
    cd ${__DIR__}/frr/
    git   pull --depth=1 --progress --rebase
else
    git clone -b master https://github.com/FRRouting/frr.git --depth=1 --progress
fi

cd ${__DIR__}



cd ${__DIR__}/frr/

sh bootstrap.sh
./configure --help
./configure


make -j $CPU_NUMS
make install


cd ${__DIR__}
rm -rf ${__DIR__}/frr
