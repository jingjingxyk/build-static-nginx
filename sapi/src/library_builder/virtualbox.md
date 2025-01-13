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

    https://download.virtualbox.org/virtualbox/7.1.0_BETA2/

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



