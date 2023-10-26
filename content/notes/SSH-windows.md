---
type: "post"
---

# SSH into Windows 10 or 11

## Setup

Check the status of ssh-agent and sshd services using the PowerShell command Get-Service:

`Get-Service -Name *ssh*`

If they're not started, set them up & add them to automatic startup list:

```
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
Start-Service 'ssh-agent'
Set-Service -Name 'ssh-agent' -StartupType 'Automatic'
```

Open the port in Windows Defender Firewall with netsh:

`netsh advfirewall firewall add rule name="SSHD service" dir=in action=allow protocol=TCP localport=22`

Or just use PowerShell:

`New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22`

## Configuration

Lives in %programdata%ssh/sshd_config file

Syntax is the same as on Linux

After making changes, restart the service:

`Get-Service sshd|Restart-Service -force`

## Connect

User must be a member of the Administrators group

Server fingerprints stored in C:\ProgramData\ssh\ssh_host_ecdsa_key.pub




