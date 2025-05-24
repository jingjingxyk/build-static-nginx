# strongswan

    strongSwan 是一个完整的 IPSec 协议套件实现  支持 IKEv1/IKEv2 协议
    支持 EAP-TLS 认证
    支持动态配置热加载（通过 swanctl 工具实现）

```shell

ipsec start --nofork
ipsec reload

```

```shell

ipsec status

ipsec listall
ipsec statusall
ipsec listcerts
ipsec listpubkeys
tcpdump port 500 or port 4500

ip addr show


ipsec stroke loglevel cfg 2
```

参考文档： https://www.digitalocean.com/community/tutorials/how-to-set-up-an-ikev2-vpn-server-with-strongswan-on-ubuntu-18-04-2

https://www.gingerdoc.com/tutorials/how-to-set-up-an-ikev2-vpn-server-with-strongswan-on-ubuntu-20-04

https://zhuanlan.zhihu.com/p/632824301

strongSwan配置示例
https://help.aliyun.com/zh/vpn/sub-product-ipsec-vpn/user-guide/configure-strongswan
