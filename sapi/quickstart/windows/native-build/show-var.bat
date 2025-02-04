@echo off

setlocal enabledelayedexpansion
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\..\

set "__PROJECT__=%cd%"
echo %cd%


cd %__PROJECT__%\var\windows-build-deps\php-src\


set X_MAKEFILE=%__PROJECT__%\var\windows-build-deps\php-src\Makefile

dir  %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\bin\php
dir  %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\msys2\usr\bin\
where sed.exe
vswhere.exe
::vswhere.exe -products* -requires
:: vswhere.exe -legacy -prerelease -format json
:: vswhere.exe -legacy -prerelease -format json | jq
:: vswhere.exe -legacy -prerelease

echo %INCLUDE%
echo %LIB%
echo %LIBPATH%


nmake /f Makefile x-show-var

cd %__PROJECT__%



endlocal

