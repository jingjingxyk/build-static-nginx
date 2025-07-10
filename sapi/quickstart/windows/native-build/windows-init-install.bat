@echo off

setlocal


echo %~dp0


cd /d %~dp0
cd /d ..\..\..\..\


set "__PROJECT__=%cd%"
echo %cd%

md %__PROJECT__%\var\windows-build-deps\
md %__PROJECT__%\bin\runtime\

cd /d %__PROJECT__%\var\windows-build-deps\
dir


msiexec /i strawberry-perl-5.38.2.2-64bit.msi  /passive

:: .\vc_redist.x64.exe /install /passive /norestart

.\7z2409-x64.exe /S


set "PATH=%ProgramFiles%\7-Zip;%PATH%;"
set "PATH=%__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\;%__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\msys2\bin;%PATH%;"
echo "%PATH%"
echo %ProgramFiles%\7-Zip

cd /d %__PROJECT__%\bin\runtime\
if  exist ".\nasm\" (
   rd /s /q ".\nasm\"
)

if  exist ".\libarchive\" (
   rd /s /q ".\libarchive\"
)

if  exist ".\php\" (
   rd /s /q ".\php\"
)

cd /d %__PROJECT__%\var\windows-build-deps\


if  exist ".\nasm\" (
   rmdir /s /q ".\nasm\"
)
if  exist ".\libarchive\" (
   rmdir /s /q ".\libarchive\"
)

if  exist ".\php-nts-Win32-x64" (
   rmdir /s /q ".\php-nts-Win32-x64"
)

cd /d %__PROJECT__%\var\windows-build-deps\

7z.exe x -onasm nasm-2.16.03-win64.zip
7z.exe x -ophp-nts-Win32-x64 php-nts-Win32-x64.zip

rem 7z.exe x -olibarchive libarchive-3.8.1.tar.gz
rem choco install archive

:: set CMAKE_BUILD_TYPE=Release
:: vcpkg install libarchive
:: vcpkg install libarchive:x64-linux-release
:: powershell -command "irm asheroto.com/winget | iex "
powershell -command "winget search libarchive --accept-source-agreements"
powershell -command "winget install libarchive "


move nasm\nasm-2.16.03 %__PROJECT__%\bin\runtime\nasm
move libarchive\libarchive %__PROJECT__%\bin\runtime\libarchive
move php-nts-Win32-x64 %__PROJECT__%\bin\runtime\php
move cacert.pem %__PROJECT__%\bin\runtime\cacert.pem

(
echo extension_dir="%__PROJECT__%\bin\runtime\php\ext\"
echo extension=php_curl.dll
echo extension=php_bz2.dll
echo extension=php_openssl.dll
echo extension=php_fileinfo.dll
echo extension=php_exif.dll
echo extension=php_gd.dll
echo extension=php_gettext.dll
echo extension=php_gmp.dll
echo extension=php_intl.dll
echo extension=php_mbstring.dll
echo extension=php_pdo_mysql.dll
echo extension=php_pdo_pgsql.dll
echo extension=php_sqlite3.dll
echo extension=php_sockets.dll
echo extension=php_sodium.dll
echo extension=php_xsl.dll
echo extension=php_zip.dll

echo curl.cainfo="%__PROJECT__%\bin\runtime\cacert.pem"
echo openssl.cafile="%__PROJECT__%\bin\runtime\cacert.pem"
echo display_errors = On
echo error_reporting = E_ALL

echo upload_max_filesize="128M"
echo post_max_size="128M"
echo memory_limit="1G"
echo date.timezone="UTC"

echo opcache.enable_cli=1
echo opcache.jit=1254
echo opcache.jit_buffer_size=480M

echo expose_php=Off
echo apc.enable_cli=1

) > %__PROJECT__%\bin\runtime\php.ini

call %__PROJECT__%\sapi\quickstart\windows\native-build\windows-init-show-install-result.bat


endlocal
