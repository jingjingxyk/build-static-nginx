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

cd /d %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\

find /c  "extension_dir=C" %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\php\php.ini

if %errorlevel%==0 (
    echo "find str"
) else (
	echo "no found str"
rem add line break
	echo. >> %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\php\php.ini
::	type nul  >> %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\php\php.ini
	echo extension_dir=%__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\php\ext\ >> %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\php\php.ini
)

cd /d %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\
call .\bin\phpsdk_buildtree.bat phpdev

cd /d %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\
if not exist ".\phpdev\php-src\" (
    rmdir /s /q ".\phpdev\php-src\"
)

cd /d %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\
if not exist ".\phpdev\php-src\" (
	xcopy  %__PROJECT__%\var\windows-build-deps\php-src\ .\phpdev\php-src\ /E /I /Q /Y
)

cd /d %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\phpdev\php-src\
set "PHP_RMTOOLS_PHP_BUILD_BRANCH=master"
call %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\phpsdk_deps.bat -u

cd /d %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\phpdev\php-src\

configure.bat ^
--with-php-build="c:\php-cli" ^
--with-extra-includes='' ^
--with-extra-libs='' ^
--with-toolset=vs ^
--disable-all         --disable-cgi      --enable-cli   ^
--enable-sockets      --enable-ctype     --enable-pdo    --enable-phar  ^
--enable-filter ^
--enable-xmlreader   --enable-xmlwriter ^
--enable-tokenizer

cd /d %__PROJECT__%


endlocal

