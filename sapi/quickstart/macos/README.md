# macos快速准备构建环境

## 准备依赖

> 系统需要安装 homebrew

```shell
# 安装 homebrew
bash sapi/quickstart/macos/install-homebrew.sh
# 使用镜像源
# bash sapi/quickstart/macos/install-homebrew.sh --mirror china


# brew 安装 依赖库
bash sapi/quickstart/macos/macos-init.sh
# 使用中国大陆镜像
# bash sapi/quickstart/macos/macos-init.sh --mirror china

```

## 清理包

```shell

brew cleanup

```

## [进入构建 PHP 环节](../README.md#构建依赖库-构建swoole-打包)

## macOS 环境 容器访问宿主机

> 用这个名称 `host.docker.internal` 保证本机 IP 变化，服务仍然可用

