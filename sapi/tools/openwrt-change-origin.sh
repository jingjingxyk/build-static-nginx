#!/usr/bin/env bash

__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)

cd ${__DIR__}

test -f /etc/opkg/distfeeds.conf.back || cp /etc/opkg/distfeeds.conf /etc/opkg/distfeeds.conf.back
sed -i 's/downloads.openwrt.org/mirrors.ustc.edu.cn\/openwrt/g' /etc/opkg/distfeeds.conf
# 更新索引
opkg update
# 安装中文语言包
opkg install luci-i18n-base-zh-cn

# 包安装命令
opkg install luci-theme-material
opkg install curl bash git xz unzip
