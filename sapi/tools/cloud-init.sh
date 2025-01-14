touch network-config
touch meta-data
cat > user-data <<EOF
cloud-config
password: password
chpasswd:
  expire: False
ssh_pwauth: True
EOF


# genisoimage 是一个用于创建ISO 9660映像文件的命令行工具 光盘的复制、备份和使用

genisoimage \
    -output seed.img \
    -volid cidata -rational-rock -joliet \
    user-data meta-data network-config


wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

qemu-system-x86_64 -m 1024 -net nic -net user \
    -drive file=jammy-server-cloudimg-amd64.img,index=0,format=qcow2,media=disk \
    -drive file=seed.img,index=1,media=cdrom \
    -machine accel=kvm:tcg
