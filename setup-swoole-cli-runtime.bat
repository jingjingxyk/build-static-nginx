rem @echo off

setlocal enableextensions
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d .
set "__PROJECT__=%cd%"

md %__PROJECT__%\var\runtime\

cd %__PROJECT__%\var\runtime\


set "VERSION=v6.0.0.0"
set "APP_VERSION=v6.0.0"
set "APP_RUNTIME=swoole-cli-%APP_VERSION%-cygwin-x64"
set "APP=%APP_RUNTIME%.zip"


set "APP_DOWNLOAD_URL=https://github.com/swoole/swoole-cli/releases/download/%VERSION%/%APP_RUNTIME%.zip"
set "COMPOSER_DOWNLOAD_URL=https://getcomposer.org/download/latest-stable/composer.phar"
set "CACERT_DOWNLOAD_URL=https://curl.se/ca/cacert.pem"


:getopt
if /i "%1" equ "--mirror" (
	if /i "%2" equ "china" (
		set "APP_DOWNLOAD_URL=https://wenda-1252906962.file.myqcloud.com/dist/%APP_RUNTIME%.zip"
		set "COMPOSER_DOWNLOAD_URL=https://mirrors.tencent.com/composer/composer.phar"
	)
)
shift

if not (%1)==() goto getopt


if not exist "%APP_RUNTIME%.zip" curl.exe -fSLo %APP_RUNTIME%.zip %APP_DOWNLOAD_URL%
if not exist "composer.phar" curl.exe -fSLo composer.phar %COMPOSER_DOWNLOAD_URL%
if not exist "cacert.pem" curl.exe -fSLo cacert.pem %CACERT_DOWNLOAD_URL%


if not exist "%APP_RUNTIME%" (
	powershell -command "Expand-Archive -Path .\%APP_RUNTIME%.zip -DestinationPath .\%APP_RUNTIME%"
	copy cacert.pem .\%APP_RUNTIME%"
)


(
echo curl.cainfo=/cygdrive/d/%__PROJECT__%/var/runtime/%APP_RUNTIME%/cacert.pem
echo openssl.cafile=/cygdrive/d/%__PROJECT__%/var/runtime/%APP_RUNTIME%/cacert.pem
echo swoole.use_shortname=off
echo display_errors = On
echo error_reporting = E_ALL

echo upload_max_filesize=128M
echo post_max_size=128M
echo memory_limit=1G
echo date.timezone=UTC

echo opcache.enable=On
echo opcache.enable_cli=On
echo opcache.jit=1225
echo opcache.jit_buffer_size=128M


echo expose_php=Off
echo apc.enable_cli=1
) > php.ini

%__PROJECT__%\var\runtime\%APP_RUNTIME%\%APP_RUNTIME%\bin\swoole-cli.exe -h


%__PROJECT__%\var\runtime\%APP_RUNTIME%\%APP_RUNTIME%\bin\swoole-cli.exe -c %__PROJECT__%\var\runtime\%APP_RUNTIME%\php.ini -v
%__PROJECT__%\var\runtime\%APP_RUNTIME%\%APP_RUNTIME%\bin\swoole-cli.exe -c %__PROJECT__%\var\runtime\%APP_RUNTIME%\php.ini -m
%__PROJECT__%\var\runtime\%APP_RUNTIME%\%APP_RUNTIME%\bin\swoole-cli.exe -c %__PROJECT__%\var\runtime\%APP_RUNTIME%\php.inii --ri swoole
%__PROJECT__%\var\runtime\%APP_RUNTIME%\%APP_RUNTIME%\bin\swoole-cli.exe -c %__PROJECT__%\var\runtime\%APP_RUNTIME%\php.ini --ri openssl


endlocal
