https://www.virtualbox.org/wiki/Downloads

下载包
https://download.virtualbox.org/virtualbox/

共享目录 加载USB
https://www.virtualbox.org/manual/ch04.html

network modes
https://www.virtualbox.org/manual/ch06.html

RemoteBox 是一个开源 VirtualBox 客户端 ,不是基于浏览器的
https://remotebox.knobgoblin.org.uk/?page=about

phpvirtualbox 是一个开源 WEB VirtualBox 客户端
https://github.com/phpvirtualbox/phpvirtualbox.git
https://github.com/studnitskiy/phpvirtualbox.git

proxmox vs virtualbox
https://www.diskinternals.com/vmfs-recovery/proxmox-vs-virtualbox/

download virtualbox mirror
https://mirrors.tuna.tsinghua.edu.cn/virtualbox/7.1.4/

## virtualbox 源码

    https://www.virtualbox.org/wiki/Source_code_organization

    https://download.virtualbox.org/virtualbox/7.1.4/
    https://mirrors.tuna.tsinghua.edu.cn/virtualbox/7.1.4/

    https://download.virtualbox.org/virtualbox/7.1.0/UserManual.pdf

    搜索关键字： web service 找到启动virtualbox web 接口

## 开启嵌套虚拟化

    从 VirtualBox 列表中获取的正确名称
    VBoxManage list vms
    # VBoxManage modifyvm "VM_NAME" --nested-hw-virt on
    VBoxManage modifyvm ""pve"" --nested-hw-virt on

## 检查CPU是否支持虚拟化。使用命令

    cat /proc/cpuinfo | egrep 'vmx|svm'
    lsmod | grep kvm

## 查看仅主机网络

    VBoxManage natnetwork list
    VBoxManage list hostonlynets
    VBoxManage list hostonlyifs （新版本，此功能已被弃用）
    VBoxManage list dhcpservers
    VBoxManage hostonlynets

## alpine 初始化

    https://cloud-atlas.readthedocs.io/zh-cn/latest/linux/alpine_linux/alpine_install.html
    setup-alpine   （磁盘选择sys 写入磁盘)
    setup-bootable  (写入引导）
    setup-desktop   （配置桌面) ('gnome', 'plasma', 'xfce', 'mate', 'sway', 'lxqt')

    # install VBoxGuestAdditions
    # https://mirrors.tuna.tsinghua.edu.cn/virtualbox/7.1.4/VBoxGuestAdditions_7.1.4.iso

    mkdir -p /mnt/cdrom
    mount /dev/cdrom /mnt/cdrom

## macos

    在macOS中，ifconfig命令已经被推荐使用的netstat和networksetup命令所取代

    查看网络设备
    networksetup -listallhardwareports
    networksetup -listallnetworkservices
    networksetup -getinfo Wi-Fi

    常看路由表
    netstat -nr

    设置网关
    route add -net 0.0.0.0 192.168.1.1

## host-only-network 模式 (虚拟机和宿主机可以互相访问)

    默认宿主机IP: 192.168.56.1
    虚拟机IP: 192.168.56.x


## ip monitor

    - all：监视所有对象的变化。
    - route：监视路由表的变化。
    - link：监视网络接口（如 eth0, wlan0 等）状态的变化。
    - address：监视网络接口地址的变化。
    - label：监视标签对象的变化。
    - rule：监视路由规则的变化。
    - netconf：监视网络配置的变化。
    - mroute：监视多播路由表的变化。
    - neigh：监视邻居表（ARP 表）的变化。
