test -f /etc/apt/apt.conf.d/proxy.conf && rm -rf /etc/apt/apt.conf.d/proxy.conf

cat >/etc/apt/apt.conf.d/proxy.conf <<EOF
Acquire::http::Proxy "http://192.168.56.1:8118";
Acquire::https::Proxy "http://192.168.56.1:8118";
Acquire::NoProxy "127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,::1/128,fe80::/10,fd00::/8,ff00::/8,.tsinghua.edu.cn,.ustc.edu.cn,.npmmirror.com,localhost";
EOF
