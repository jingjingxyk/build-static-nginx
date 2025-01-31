 rem @echo off

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

find /c  "extension_dir=C" %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\php\php.ini

if %errorlevel%==0 (
    echo "find str"
) else (
	echo "no found str"
	echo \r\nextension_dir=%__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\php\ext\ >> %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\php\php.ini
)

cd /d %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\
call .\bin\phpsdk_buildtree.bat phpdev

cd /d %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\
if not exist ".\phpdev\php-src\" (
    rmdir /s /q ".\phpdev\php-src\"
)

cd /d %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\
xcopy  %__PROJECT__%\var\windows-build-deps\php-src\ .\phpdev\php-src\ /E /I /Q /Y

cd /d %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\phpdev\php-src\
set "PHP_RMTOOLS_PHP_BUILD_BRANCH=master"
call %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\phpsdk_deps.bat -u

cd /d %__PROJECT__%

endlocal

