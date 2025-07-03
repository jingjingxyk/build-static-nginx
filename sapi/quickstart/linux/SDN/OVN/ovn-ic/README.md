```shell

ovs-vsctl set open_vswitch . other_config:ovn-encap-ip="<Gateway-IP>"
ovs-vsctl set open_vswitch . other_config:ovn-encap-type="geneve,vxlan"

```

```shell
ovn-ic-sbctl show
ovn-ic-nbctl get-connection  # 检查 Northbound 连接状态‌
ovn-ic-sbctl get-connection  # 检查 Southbound

```
