# static-nginx

构建静态 nginx

## 构建命令

>
复用 [jingjingxyk/swoole-cli `new_dev`分支](https://github.com/jingjingxyk/swoole-cli/tree/new_dev)
的 静态库构建流程

```bash

    git clone -b new_dev https://github.com/jingjingxyk/swoole-cli/
    cd swoole-cli
    php prepare.php +nginx -with-c-compiler=gcc
    bash make-install-deps.sh
    bash make.sh all-library
    bash make.sh config

```

## nginx 源码构建参考

    http://nginx.org/en/docs/configure.html
