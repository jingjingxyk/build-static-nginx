 rem @echo off

setlocal enabledelayedexpansion
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\..\

set "__PROJECT__=%cd%"
echo %cd%


rem if not exist "php-sdk-binary-tools" git clone -b master --depth=1 https://github.com/php/php-sdk-binary-tools.git
rem if not exist "php-src" git clone -b php-8.4.2 --depth=1 https://github.com/php/php-src.git php-src


set "PATH=%PATH%;%__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin;"
set "PATH=%PATH%;%__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\php;"

cd /d %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\phpdev\php-src\

set CL=/MP
nmake

cd /d %__PROJECT__%

endlocal

