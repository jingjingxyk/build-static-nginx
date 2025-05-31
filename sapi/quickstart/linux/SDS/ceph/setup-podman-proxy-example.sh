
set -x

export HTTP_PROXY=http://192.168.3.26:8015
export HTTPS_PROXY=http://192.168.3.26:8015
export NO_PROXY=0.0.0.0/8,10.0.0.0/8,100.64.0.0/10,127.0.0.0/8,172.16.0.0/12,192.168.0.0/16,localhost,.aliyuncs.com


podman pull registry.k8s.io/pause:3.9


:<<'EOF'
配置文件优先级
命令行变量 > 用户配置 > 系统配置 > 全局默认

系统全局配置
vim /usr/share/containers/containers.conf
用户级配置：
vim ~/.config/containers/containers.conf
自定义系统配置
vim /etc/containers/containers.conf

[engine]
env = [
  "HTTP_PROXY=http://192.168.3.26:8118",
  "HTTPS_PROXY=http://192.168.3.26:8118",
  "NO_PROXY=127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,localhost,::1/128,fe80::/10,fd00::/8,ff00::/8,.tsinghua.edu.cn,.ustc.edu.cn,.npmmirror.com"
]
EOF
