#!/bin/env bash

set -eux

__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

ovs-vsctl set Open_vSwitch .  external-ids:ovn-bridge-mappings=' '

{
    ip addr add  192.168.1.4/24 dev eth1
    ip route add default via 192.168.1.1 dev eth1

} || {
  echo $?
}


ovs-vsctl --if-exists del-port  eth1

ip addr flush dev br-eth1

ovs-vsctl --if-exists del-br br-eth1

ip a


