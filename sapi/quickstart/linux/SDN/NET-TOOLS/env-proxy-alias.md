## 环境变量快速设置代理

```bash

alias setproxy="export http_proxy=socks5h://127.0.0.1:2000;export https_proxy=socks5h://127.0.0.1:2000;"
alias unsetproxy="unset http_proxy;unset https_proxy;"
alias ipcn='curl myip.ipip.net'
alias ip='curl cip.cc'
alias ip_v6='curl -6 ip.sb'
alias ip_v4='curl -4 ip.sb'

```

```shell
curl myip.ipip.net
curl cip.cc
curl -6 ip.sb
curl -4 ip.sb
curl ip.im
curl ip.im/info
curl cip.cc
curl ip.fht.im
curl https://ip9.com.cn/get
curl https://httpbin.org/ip
curl cloudflare.com/cdn-cgi/trace
curl checkip.dyndns.com
curl ifconfig.co/json | jq

curl -4  -s ifconfig.co/json | jq

time curl -4 ip.sb
time curl -4 ip.im
```
