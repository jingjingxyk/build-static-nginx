#!/usr/bin/env bash
#set -euo pipefail

set -eux
set -o pipefail

__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LANG="en_US.UTF-8"

install_deps() {

  apt update -y
  apt install -y locales
  echo 'en_US.UTF-8 UTF-8' >>/etc/locale.gen
  locale-gen
  localedef -i en_US -f UTF-8 en_US.UTF-8
  locale -a | grep en_US.utf8
  export LANGUAGE="en_US.UTF-8"
  export LC_ALL="en_US.UTF-8"
  export LC_CTYPE="en_US.UTF-8"
  export LANG="en_US.UTF-8"

  # update-locale LANG=en_US.UTF-8

  apt install -y git curl python3 python3-pip python3-dev wget sudo file
  apt install -y libssl-dev ca-certificates

  apt install -y \
    git gcc clang make cmake autoconf automake libssl3 openssl libssl-dev python3 python3-pip libtool \
    openssl curl libcap-ng-dev uuid uuid-runtime

  apt install -y ntp ntpsec

  apt install -y kmod iptables
  apt install -y netcat-openbsd
  apt install -y tcpdump nmap traceroute net-tools dnsutils iproute2 procps iputils-ping iputils-arping
  apt install -y conntrack
  apt install -y bridge-utils
  apt install -y libelf-dev libbpf-dev # libxdp-dev
  apt install -y graphviz
  apt install -y libjemalloc2 libjemalloc-dev libnuma-dev libpcap-dev libunbound-dev libunwind-dev llvm-dev
  apt install -y bc init ncat
  apt install -y lshw
  # apt install -y isc-dhcp-server
  # apt install -y libdpdk-dev

  # apt install -y ntp ntpdate
  # ‌手动强制同步‌
  # ntpdate ntp.ntsc.ac.cn  # 使用国家授时中心服务器
  # ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

  # apt install ntp systemd-timesyncd -y
  # timedatectl set-ntp true
  # systemctl disable systemd-timesyncd
  # timedatectl status
  # timedatectl set-timezone Asia/Shanghai
  # timedatectl set-timezone UTC
  # timedatectl set-local-rtc 0  # 将硬件时钟设为UTC

  # apt install ntp ntpsec -y
  ntpq -pn

  # debian.map.fastlydns.net

}

MIRROR=''
FORCE_INSTALL_DEPS=0
while [ $# -gt 0 ]; do
  case "$1" in
  --mirror)
    MIRROR="$2"
    ;;
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
  --install-deps)
    FORCE_INSTALL_DEPS=1
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

OS_ID=$(cat /etc/os-release | grep '^ID=' | awk -F '=' '{print $2}')
VERSION_ID=$(cat /etc/os-release | grep '^VERSION_ID=' | awk -F '=' '{print $2}' | sed "s/\"//g")

if [ ${OS_ID} = 'debian' ] || [ ${OS_ID} = 'ubuntu' ]; then
  echo 'supported OS'
else
  echo 'no supported OS'
  exit 0
fi

if test -n "$MIRROR"; then
  {
    OS_ID=$(cat /etc/os-release | grep '^ID=' | awk -F '=' '{print $2}')
    VERSION_ID=$(cat /etc/os-release | grep '^VERSION_ID=' | awk -F '=' '{print $2}' | sed "s/\"//g")
    case $OS_ID in
    debian)
      case $VERSION_ID in
      11 | 12)
        # debian 容器内和容器外 镜像源配置不一样
        if [ -f /.dockerenv ] && [ "$VERSION_ID" = 12 ]; then
          test -f /etc/apt/sources.list.d/debian.sources.save || cp -f /etc/apt/sources.list.d/debian.sources /etc/apt/sources.list.d/debian.sources.save
          sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources
          sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources
          test "$MIRROR" = "tuna" && sed -i "s@mirrors.ustc.edu.cn@mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list.d/debian.sources
          # 云服务内网镜像源
          test "$MIRROR" = "aliyuncs" && sed -i "s@mirrors.ustc.edu.cn@mirrors.cloud.aliyuncs.com@g" /etc/apt/sources.list.d/debian.sources
          test "$MIRROR" = "tencentyun" && sed -i "s@mirrors.ustc.edu.cn@mirrors.tencentyun.com@g" /etc/apt/sources.list.d/debian.sources
          test "$MIRROR" = "huaweicloud" && sed -i "s@mirrors.ustc.edu.cn@repo.huaweicloud.com@g" /etc/apt/sources.list.d/debian.sources
        else
          test -f /etc/apt/sources.list.save || cp /etc/apt/sources.list /etc/apt/sources.list.save
          sed -i "s@deb.debian.org@mirrors.ustc.edu.cn@g" /etc/apt/sources.list
          sed -i "s@security.debian.org@mirrors.ustc.edu.cn@g" /etc/apt/sources.list
          test "$MIRROR" = "tuna" && sed -i "s@mirrors.ustc.edu.cn@mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
          test "$MIRROR" = "aliyuncs" && sed -i "s@mirrors.ustc.edu.cn@mirrors.cloud.aliyuncs.com@g" /etc/apt/sources.list
          test "$MIRROR" = "tencentyun" && sed -i "s@mirrors.ustc.edu.cn@mirrors.tencentyun.com@g" /etc/apt/sources.list
          test "$MIRROR" = "huaweicloud" && sed -i "s@mirrors.ustc.edu.cn@repo.huaweicloud.com@g" /etc/apt/sources.list
        fi
        ;;
      *)
        echo 'no match debian OS version' . $VERSION_ID
        ;;
      esac
      ;;
    ubuntu)
      case $VERSION_ID in
      20.04 | 22.04 | 22.10 | 23.04 | 23.10)
        test -f /etc/apt/sources.list.save || cp /etc/apt/sources.list /etc/apt/sources.list.save
        sed -i "s@security.ubuntu.com@mirrors.ustc.edu.cn@g" /etc/apt/sources.list
        sed -i "s@archive.ubuntu.com@mirrors.ustc.edu.cn@g" /etc/apt/sources.list
        test "$MIRROR" = "tuna" && sed -i "s@mirrors.ustc.edu.cn@mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
        test "$MIRROR" = "aliyuncs" && sed -i "s@mirrors.ustc.edu.cn@mirrors.cloud.aliyuncs.com@g" /etc/apt/sources.list
        test "$MIRROR" = "tencentyun" && sed -i "s@mirrors.ustc.edu.cn@mirrors.tencentyun.com@g" /etc/apt/sources.list
        test "$MIRROR" = "huaweicloud" && sed -i "s@mirrors.ustc.edu.cn@repo.huaweicloud.com@g" /etc/apt/sources.list
        ;;
      24.04)
        test -f /etc/apt/sources.list.d/ubuntu.sources.save || cp /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.save
        sed -i "s@security.ubuntu.com@mirrors.ustc.edu.cn@g" /etc/apt/sources.list.d/ubuntu.sources
        sed -i "s@archive.ubuntu.com@mirrors.ustc.edu.cn@g" /etc/apt/sources.list.d/ubuntu.sources
        ;;
      *)
        echo 'no match ubuntu OS version' . $VERSION_ID
        ;;
      esac
      ;;
    *)
      echo 'NO SUPPORT LINUX OS'
      exit 0
      ;;
    esac
  }
fi

if [[ "$FORCE_INSTALL_DEPS" -eq 1 ]]; then
  install_deps
else
  # test $(dpkg-query -l graphviz | wc -l) -eq 0 && install_deps
  test $(command -v bc | wc -l) -eq 0 && install_deps
fi

OVS_TAG='v3.4.2'
OVN_TAG='v24.09.2'
# OVN_TAG='v25.03.0'

CPU_NUMS=$(nproc)
CPU_NUMS=$(grep "processor" /proc/cpuinfo | sort -u | wc -l)

cd ${__DIR__}
if test -d ovs; then
  cd ${__DIR__}/ovs/
  # git   pull --depth=1 --progress --rebase
else
  if [[ "$MIRROR" == "china" ]]; then
    git clone -b ${OVS_TAG} https://gitee.com/jingjingxyk/ovs.git --depth=1 --progress
  else
    git clone -b ${OVS_TAG} https://github.com/openvswitch/ovs.git --depth=1 --progress
  fi
fi

cd ${__DIR__}

if test -d ovn; then
  cd ${__DIR__}/ovn/
  # git   pull --depth=1 --progress --rebase
else
  if [[ "$MIRROR" == "china" ]]; then
    git clone -b ${OVN_TAG} https://gitee.com/jingjingxyk/ovn.git --depth=1 --progress
  else
    git clone -b ${OVN_TAG} https://github.com/ovn-org/ovn.git --depth=1 --progress
  fi

fi

cd ${__DIR__}

cd ${__DIR__}/ovs/
./boot.sh
cd ${__DIR__}/ovs/

./configure --help

sed -i '5i\touch $stamp ; exit 0 ;' ./build-aux/cksum-schema-check

./configure --enable-ssl
make -j $CPU_NUMS
sudo make install

cd ${__DIR__}/ovn/

./boot.sh
cd ${__DIR__}/ovn/
sed -i '5i\touch $stamp ; exit 0 ;' ./build-aux/cksum-schema-check
./configure --help
./configure --enable-ssl \
  --with-ovs-source=${__DIR__}/ovs/ \
  --with-ovs-build=${__DIR__}/ovs/

make -j $CPU_NUMS
sudo make install

cd ${__DIR__}
rm -rf ${__DIR__}/ovn
rm -rf ${__DIR__}/ovs

# sed -i "s@mirrors.tuna.tsinghua.edu.cn@mirrors.ustc.edu.cn@g" /etc/apt/sources.list
# sed -i "s@mirrors.tuna.tsinghua.edu.cn@archive.debian.org@g" /etc/apt/sources.list

: <<'COMMENT'
test -f /etc/apt/apt.conf.d/proxy.conf && rm -f /etc/apt/apt.conf.d/proxy.conf



cat > /etc/apt/apt.conf.d/proxy.conf <<EOF
Acquire::http::Proxy  "http://127.0.0.1:8016";
Acquire::https::Proxy "http://127.0.0.1:8016";
Acquire::NoProxy "127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,::1/128,fe80::/10,fd00::/8,ff00::/8,.tsinghua.edu.cn,.ustc.edu.cn,.npmmirror.com,localhost";
EOF



COMMENT
