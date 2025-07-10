## windows 终端下载器

### winget

    winget source remove winget
    winget source add winget https://mirrors.ustc.edu.cn/winget-source --trust-level trusted

    https://mirrors.ustc.edu.cn/help/winget-source.html

### scoop

    https://scoop.sh/

## choco

    https://chocolatey.org/install#generic
    https://community.chocolatey.org

## vcpkg

    git clone https://github.com/Microsoft/vcpkg.git
    .\vcpkg\bootstrap-vcpkg.bat
    .\vcpkg\vcpkg.exe install libarchive

```cmd

curl.exe -fSLo Microsoft.WindowsTerminal_1.21.3231.0_8wekyb3d8bbwe.msixbundle https://github.com/microsoft/terminal/releases/download/v1.21.3231.0/Microsoft.WindowsTerminal_1.21.3231.0_8wekyb3d8bbwe.msixbundle
curl.exe -fSLo winget-install.ps1 https://github.com/asheroto/winget-install/releases/latest/download/winget-install.ps1
curl.exe -fSLo chocolatey-install.ps1 https://community.chocolatey.org/install.ps1
curl.exe -fSLo scoop-install.ps1 https://get.scoop.sh


```
