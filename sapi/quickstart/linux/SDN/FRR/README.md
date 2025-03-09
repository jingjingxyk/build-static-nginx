## FRR

    普通的Linux-PC快速转变成一台功能强大的企业级路由器
    https://frrouting.org/

## 路由器组网协议

    OSPF （常用路由器之间组网）
    ISIS  (运营商使用）

    主动路由协议包括RIP协议、IGRP协议、OSPF协议等

FRR + EVPN + GENEVE

## build FRR

```shell

curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/sapi/quickstart/linux/SDN/FRR/install-frr-deps.sh | bash

curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/sapi/quickstart/linux/SDN/FRR/build-libyang2.sh | bash

curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/sapi/quickstart/linux/SDN/FRR/install-frr.sh  | bash -s --

```
