@echo off

rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\..\

set "__PROJECT__=%cd%"
echo %cd%

set "PATH=%PATH%;%__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin;"
set "PATH=%PATH%;%__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\php;"

cd /d %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\

echo extension_dir=%__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\php\ext\ >> %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\php\php.ini

call phpsdk_buildtree phpdev

call phpsdk_deps -u

cd /d %__PROJECT__%

