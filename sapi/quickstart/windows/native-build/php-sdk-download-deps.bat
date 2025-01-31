@echo off

setlocal enabledelayedexpansion
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\..\

set "__PROJECT__=%cd%"
echo %cd%

set "PATH=%PATH%;%__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin;"
set "PATH=%PATH%;%__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\php;"

cd /d %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\

find /C "extension_dir=C" %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\php\php.ini

if %errorlevel%==0 (
    echo "no found str"
    echo extension_dir=%__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\php\ext\ >> %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\php\php.ini
) else (
    echo "find str"
)

cd /d %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\

call .\bin\phpsdk_buildtree.bat phpdev
if not exist ".\phpdev\php-src\" (
    rmdir /s /q ".\phpdev\php-src\"
)

xcopy  %__PROJECT__%\var\windows-build-deps\php-src\ phpdev\php-src\ /E /I /Q /Y

cd /d %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\phpdev\php-src\
set "PHP_RMTOOLS_PHP_BUILD_BRANCH=master"
call .\bin\phpsdk_deps.bat -u

cd /d %__PROJECT__%

endlocal

