# build static nginx

构建静态 nginx

## 构建命令

> 复用
> [jingjingxyk/swoole-cli](https://github.com/jingjingxyk/swoole-cli/tree/new_dev)
> 项目的 `new_dev`分支的静态库构建流程

> 本项目 只需要关注 `.github/workflow` 目录里配置文件的变更

## 下载`nginx`发行版

- [https://github.com/jingjingxyk/build-static-nginx/releases](https://github.com/jingjingxyk/build-static-nginx/releases)

## 构建文档

- [linux 版构建文档](docs/linux.md)
- [macOS 版构建文档](docs/macOS.md)
- [构建选项文档](docs/options.md)
- [搭建依赖库镜像服务](sapi/download-box/README.md)
- [quickstart](sapi/quickstart/README.md)

## Clone

```shell

git clone -b main https://github.com/jingjingxyk/build-static-nginx.git

# 或者

git clone --recursive -b nginx  https://github.com/jingjingxyk/swoole-cli.git

```

## 构建命令

```bash

    git clone -b new_dev https://github.com/jingjingxyk/swoole-cli/
    cd swoole-cli
    bash setup-php-runtime.sh
    php prepare.php +nginx --with-c-compiler=gcc
    bash make-install-deps.sh
    bash make.sh all-library
    bash make.sh config
    bash make.sh build
    bash make.sh archive

```

## 一条命令执行整个构建流程

```bash

cp build-release-example.sh build-release.sh

# 按你的需求修改配置  OPTIONS=" +nginx --with-c-compiler=gcc"
vi build-release.sh

# 执行构建流程
bash build-release.sh


```

## nginx 源码构建参考

    http://nginx.org/en/docs/configure.html
