## DiskGenius软件提供了创建Windows PE环境的功能

    https://www.diskgenius.cn/help/windows_aik_adk_installnotes.php

## Windows PE (WinPE)

    Windows PE (WinPE) 是一种小型操作系统，用于启动没有操作系统的计算机。 Windows PE 可以启动到 以安装新的操作系统、恢复数据或修复现有操作系统

    https://learn.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/winpe-intro?view=windows-11
    https://learn.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/download-winpe--windows-pe?view=windows-11

    https://learn.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/winpe-create-usb-bootable-drive?view=windows-11

```shell


# 不同的系统，对应不同的版本 具体对应版本 https://www.diskgenius.cn/help/windows_aik_adk_installnotes.php

curl.exe -fSLo adksetup.exe https://go.microsoft.com/fwlink/?linkid=2289980
curl.exe -fSLo adkwinpesetup.exe https://go.microsoft.com/fwlink/?linkid=2289981

# 以管理员身份启动部署和映像工具环境。
C:\Windows\system32\cmd.exe /k "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\DandISetEnv.bat"
cd /d "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\"

cd "..\Windows Preinstallation Environment\amd64"

md C:\WinPE_amd64\mount
Dism /Mount-Image /ImageFile:"en-us\winpe.wim" /index:1 /MountDir:"C:\WinPE_amd64\mount"

MakeWinPEMedia /ISO C:\WinPE_amd64 C:\WinPE_amd64\WinPE_amd64.iso



```
