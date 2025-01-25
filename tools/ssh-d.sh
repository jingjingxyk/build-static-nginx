
ip='123.56.19.139'
keyfile=/home/yaokun/beijing-2022-05-27.pem
keyfile=/Users/wenba/Downloads/beijing-2023-12-01.pem

{
  #其中 -C 为压缩数据，-q 安静模式，-T 禁止远程分配终端，-n 关闭标准输入，-N 不执行远程命令。此外视需要还可以增加 -f 参数，把 ssh 放到后台运行。
  ssh -o StrictHostKeyChecking=no \
    -o ExitOnForwardFailure=yes \
    -o TCPKeepAlive=yes \
    -o ServerAliveInterval=15 \
    -o ServerAliveCountMax=3 \
    -i $keyfile \
    -v -CTgN \
    -D  \
    root@$ip
} || {
  echo $?

}
