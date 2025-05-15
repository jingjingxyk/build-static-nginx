## 安装 wiregaurd

    https://www.wireguard.com/install/

```bash

# debian
apt install wireguard

# alpine
apk add -U wireguard-tools

# macos
brew install wireguard-tools

# windows [support 7, 8.1, 10, 11, 2008R2, 2012R2, 2016, 2019, 2022]
# 下载二进制安装包，
https://download.wireguard.com/windows-client/wireguard-installer.exe
https://download.dengxiaci.com/wireguard-installer.exe

```

## 启动 wiregaurd

```shell
# linux 环境下 启动 停止 重新载入配置
bash start.sh
bash staop.sh
bash reload.sh

# macos 环境下 启动 和 停止
sudo bash start-macos.sh
sudo bash stop-macos.sh

# windows 启动以后导入配置文件 configuration.conf


```

