## 使用 bash shell实现curl

```shell

function __curl() {
    read proto server path <<<$(echo ${1//// })
    DOC=/${path// //}
    HOST=${server//:*}
    PORT=${server//*:}
    [[ x"${HOST}" == x"${PORT}" ]] && PORT=80

    exec 3<>/dev/tcp/${HOST}/$PORT
    echo -en "GET ${DOC} HTTP/1.0\r\nHost: ${HOST}\r\n\r\n" >&3
    (while read line; do
    [[ "$line" == $'\r' ]] && break
    done && cat) <&3
    exec 3>&-
}
__curl http://192.168.3.100/index.html


```
