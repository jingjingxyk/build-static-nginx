#!powershell

$__DIR__ = Split-Path -Parent $MyInvocation.MyCommand.Definition
$__PROJECT__ = ( Convert-Path "$__DIR__\..\..\..\")

Write-Host  $__DIR__
Write-Host  $__PROJECT__
Write-Host (Get-Location).Path

if (Test-Path -Path “$__PROJECT__\prepare.php")
{
    Write-Host "文件存在"
}
else
{
    $__PROJECT__ = ( Convert-Path "$__DIR__")
}

cd $__PROJECT__

$url = "https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/sapi/quickstart/windows/http-proxy.bat"
if (Test-Path -Path http-proxy.bat)
{
    irm $url -outfile http-proxy.bat
}
$text < http-proxy.bat
$newText = $text -replace "apple", "orange"

# $newText | Out-File -FilePath "$__PROJECT__\http-proxy.bat" -Encoding UTF8
$newText | Out-File -FilePath "$__PROJECT__\http-proxy.bat"

Invoke-Expression "cmd /c $__PROJECT__\http-proxy.bat"




