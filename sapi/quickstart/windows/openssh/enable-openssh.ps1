Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

Start-Service sshd

Set-Service -Name sshd -StartupType Automatic

Get-Service sshd

New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# New-Item -Path "~\.ssh\" -ItemType Directory -Force
New-Item -Path "$env:USERPROFILE\.ssh\" -ItemType Directory -Force

Set-Content -Path "$env:USERPROFILE\.ssh\authorized_keys" -Value ""

Add-Content -Path "$env:USERPROFILE\.ssh\authorized_keys" -Value "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICl2QAvQ5YF2b6omciFh98UNsFyHlpfgrtkuom2Gsih+ Windows-SSH-Key"

Add-Content -Path "$env:ProgramData\ssh\sshd_config" -Value "PubkeyAuthentication yes"
Add-Content -Path "$env:ProgramData\ssh\sshd_config" -Value "PasswordAuthentication no"
Add-Content -Path "$env:ProgramData\ssh\sshd_config" -Value "PermitRootLogin yes"
# Add-Content -Path "$env:ProgramData\ssh\sshd_config" -Value "AcceptEnv PROMPT"
# Add-Content -Path "$env:ProgramData\ssh\sshd_config" -Value "Shell C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -NoLogo -NoProfile"



Restart-Service sshd

<#

md  ~\.ssh\
mkdir  ~\.ssh\

# echo.命令用来输出一个空行

echo. >  ~\.ssh\authorized_keys

## 配置所在目录
C:\ProgramData\ssh

notepad $env:ProgramData\ssh\sshd_config

Get-Content $env:ProgramData\ssh\sshd_config

# ProgramData‌是Windows系统中的一个系统文件夹 ProgramData文件夹是隐藏的，默认情况下不会在文件资源管理器中显示

# 禁止密码登录（配置sshd_config)
PasswordAuthentication no
PermitRootLogin no
ChallengeResponseAuthentication no

# 使用密钥认证
RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys

#注释掉默认授权文件位置，确保以下条目被注释
#Match Group administrators
#       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys

# 重启 sshd
Restart-Service sshd

# 添加密钥
ssh-add %USERPROFILE%\.ssh\id_rsa

cmd /c set "PATH=%PATH%;C:\Program Files\Git\bin\;"

$env:PATH += ";C:\Program Files\Git\bin;"

#>
