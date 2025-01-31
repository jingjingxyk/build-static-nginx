Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

Start-Service sshd

Set-Service -Name sshd -StartupType Automatic

Get-Service sshd

New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22


<#

md ~\.ssh\
echo 'ssh key' > ~\.ssh\authorized_keys

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


#>
