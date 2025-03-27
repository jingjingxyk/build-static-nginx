
http://www.dest-unreach.org/socat/

https://zhuanlan.zhihu.com/p/8601350507

将 Unix Socket 转换为 TCP 连接

socat TCP-LISTEN:端口号,fork UNIX-CONNECT:/usr/local/var/run/ovn/ovnnb_db.sock:
socat TCP-LISTEN:端口号,fork UNIX-CONNECT:/usr/local/var/run/ovn//usr/local/var/run/ovn/ovnsb_db.sock:


将 TCP 转换为 Unix Socket
socat TCP-CONNECT:目标地址:端口号 UNIX-CLIENT:/path/to/unix/socket

socat TCP-LISTEN:8080,reuseaddr,fork,max-children=5 EXEC:"bash -i",pty,stderr,setsid,sigint,raw,echo=0,crnl

socat - TCP:服务器IP:8080,setsid,crnl
