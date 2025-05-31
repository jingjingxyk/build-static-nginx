## linux GENEVE隧道 配置

```shell
ip addr add 10.23.1.3/24 dev ens192
ip route add 10.12.1.0/24 via 10.23.1.2

ip link add geneve0 type geneve id 100 remote 10.23.1.3
ip link add geneve0 type geneve id 100 remote 10.23.1.3 dstport 6081
ip link show geneve0

ip link set geneve0 up
ip link show geneve0
ip addr add 10.13.1.1/24 dev geneve0
ip addr show geneve0

```

## linux ovs GENEVE隧道

```shell

# 主机192.168.1.21上
ovs-vsctl add-br br-int
# 主机192.168.1.23上
ovs-vsctl add-br br-int

#1主机192.168.1.21上添加连接到1.23的Tunnel Port
ovs-vsctl add-port br-int tun0 -- set Interface tun0 type=geneve options:remote_ip=192.168.1.23

#主机192.168.1.23上添加连接到1.21的Tunnel Port
ovs-vsctl add-port br-int tun0 -- set Interface tun0 type=geneve options:remote_ip=192.168.1.21

```

## GENEVE隧道 指定端口

    在OVS中，我们可以通过配置接口的dst_port选项来动态指定GENEVE隧道的端口；
    在OVN中，我们可以通过设置ovn-encap-port来指定端口

```shell

# 此是指 还没有实现
ovs-vsctl set open . external_ids:ovn-encap-port=6081

ovs-vsctl add-port br-tun geneve0 -- set interface geneve0 type=geneve options=<remote_ip> options=<key> options=<port>

ovs-vsctl add-port br0 geneve0 \
    -- set interface geneve0 type=geneve \
    options:remote_ip=192.168.100.2 \
    options:key=1001 \
    options:dst_port=5000

ovs-vsctl set open . external_ids:ovn-encap-port=6081

```

```shell

 ovn-sbctl set encap $CHASSIS options:dst_port=6083

```
