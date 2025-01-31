@echo off

setlocal


echo %~dp0


cd /d %~dp0
cd /d ..\..\..\..\..\..\


set "__PROJECT__=%cd%"
echo %cd%

md %__PROJECT__%\var\windows-build-deps\

cd /d %__PROJECT__%\var\windows-build-deps\
dir

rem https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools_tutorial.html#_setting_up
:: depot_tools
git clone -b main --depth=1 --progress https://chromium.googlesource.com/chromium/tools/depot_tools.git

SET "PATH=%PATH%;%__PROJECT__%\var\windows-build-deps\depot_tools;"
echo %PATH%
git config --global user.name "jingjingxyk"
git config --global user.email "zonghengbaihe521@qq.com"
git config --global core.autocrlf false
git config --global core.filemode false
git config --global color.ui true


fetch chromium

gclient sync


endlocal
