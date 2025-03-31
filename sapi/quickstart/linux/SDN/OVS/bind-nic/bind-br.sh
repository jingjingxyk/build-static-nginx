#!/usr/bin/env bash

set -eux

__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

ovs-vsctl --if-exists del-br br-eth0
ovs-vsctl add-br br-eth0 # 添加网桥
ip link set br-eth0 up # 激活网桥

{
    ip addr add  192.168.1.60/24 dev br-eth0
} ||
{
    echo $?
}

ovs-vsctl add-port br-eth0  enp0s8
ovs-vsctl set Open_vSwitch . external-ids:ovn-bridge-mappings=br-provider:br-eth0

ip addr flush dev enp0s8

exit 0

sysctl -w net.ipv4.ip_forward=1
# iptables -t nat -A POSTROUTING -s 10.1.20.0/24 -o br-eth0 -j MASQUERADE

ip a


systemctl stop systemd-resolved

exit 0

ovs-dpctl show
ovs-dpctl dump-flows
ovs-appctl ovs/route/show
ovs-ofctl show br-int

exit 0



iptables -t nat -L -n --line-number

#iptables -t nat -A POSTROUTING -s 10.10.92.1/24 ! -d 10.10.92.1/24 -j SNAT --to-source 172.17.14.125
#iptables -t nat -A POSTROUTING -s 10.10.92.0/24 -o br-eth0 -j MASQUERADE # eth0连接外网
#iptables   -A FORWARD -i eth0 -o veth-a -j ACCEPT
#iptables   -A FORWARD -i veth-a -o eth0  -j ACCEPT

iptables -t nat -L -n --line-number
# iptables -t nat -D POSTROUTING 21

#iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o eth0 -j SNAT --to 你的eth0地址
iptables -t nat -A POSTROUTING -s 10.10.92.0/24 -o br-eth0  -j SNAT --to-source 172.17.14.125
iptables -t nat -A POSTROUTING -s 10.10.92.1 -o br-eth0  -j SNAT --to-source 172.17.14.125
iptables -t nat -A POSTROUTING -s 10.10.92.1/24 -o br-eth0 -j MASQUERADE
iptables -A PREROUTING -t nat -j DNAT  -p tcp --dport 8090 -i $if_oam --to 192.168.9.217:8090

ip route add 192.168.10.0/24 via 172.17.14.125 src 10.10.92.1

iptables -t nat -A PREROUTING -d 10.10.92.1  -j DNAT --to-destination 10.10.92.2

route del default gw 192.168.1.1
ip route add 10.10.92.1 via 172.17.14.125



ip route change  default via   172.17.63.253 dev br-eth0

ip route show | column -t

