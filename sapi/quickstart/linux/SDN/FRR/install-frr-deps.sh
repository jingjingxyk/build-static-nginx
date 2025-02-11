#!/usr/bin/env bash
#set -euo pipefail

set -eux
set -o pipefail

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}

OS_ID=$(cat /etc/os-release | grep '^ID=' | awk -F '=' '{print $2}')
VERSION_ID=$(cat /etc/os-release | grep '^VERSION_ID=' | awk -F '=' '{print $2}' | sed "s/\"//g")

if [ ${OS_ID} = 'debian'  ] || [ ${OS_ID} = 'ubuntu' ] ; then
    echo 'supported OS'
else
    echo 'no supported OS'
    exit 0
fi



apt update -y

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export DEBIAN_FRONTEND=noninteractive
export TZ="UTC"
export TZ="Etc/UTC"
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt install -y locales tzdata keyboard-configuration

localedef -i en_US -f UTF-8 en_US.UTF-8
dpkg-reconfigure locales

apt install -y git curl python3 python3-pip python3-dev wget   sudo file texinfo
apt install -y libssl-dev ca-certificates

apt install -y  \
git gcc clang make cmake autoconf automake openssl python3 python3-pip  libtool  \
openssl  curl  libssl-dev  libcap-ng-dev uuid uuid-runtime


apt install -y kmod iptables
apt install -y netcat-openbsd
apt install -y tcpdump nmap traceroute net-tools dnsutils iproute2 procps iputils-ping iputils-arping
apt install -y conntrack
apt install -y bridge-utils
apt install -y libelf-dev  libbpf-dev # libxdp-dev
apt install -y graphviz
apt install -y libjemalloc2   libjemalloc-dev  libnuma-dev   libpcap-dev  libunbound-dev  libunwind-dev  llvm-dev
apt install -y bc init ncat
# apt install -y isc-dhcp-server


apt install -y libjson-c-dev
apt install -y libprotobuf-c-dev protobuf-c-compiler
apt install -y libreadline-dev
apt install -y libyang2-dev
apt install -y libyang2
apt install -y libcap-dev
apt install -y sphinx
apt install -y libbison-dev
apt install -y yacc
apt install -y python3-ply
apt install -y flex



