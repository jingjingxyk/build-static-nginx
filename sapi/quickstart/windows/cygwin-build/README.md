## cygwin workdir

```shell

  DISK_DRIVE=$( df -h / | sed -n '2p' | awk '{ print $1 }' )$(pwd)
  echo $DISK_DRIVE
  WIND_DIR=$(echo $DISK_DRIVE | sed 's/\//\\/g')

```

## install cygwin

```bash

# 自动安装 cygwin 和  cygwin 依赖项
.\sapi\quickstart\windows\cygwin-build\download-cygwin.bat
.\sapi\quickstart\windows\cygwin-build\install-cygwin.bat
```

## 使用镜像 安装　cygwin 环境依赖包

```
.\sapi\quickstart\windows\cygwin-build\install-cygwin.bat --mirror china

```

## powershell 环境中调用批处理命令

```powershell

cmd /c .\sapi\quickstart\windows\cygwin-build\install-cygwin.bat --mirror china

```

## 进入cygwin 环境

```
C:\cygwin64\bin\mintty.exe -i /Cygwin-Terminal.ico -

```

### cygwin mirror

    https://cygwin.com/mirrors.html

