---
title: "Securing an SSH Server"
type: "post"
date: 2023-02-02
tags: "selfhosting", "networking", "security", "polished"
---

# Securing an SSH Server

## Redhat checklist:

1. Back up the config file:
```
cp /etc/ssh/sshd_config ~/sshd_config_original
```
2. Set a banner message: add a note in `/etc/issue.net` and then add to the sshd_config file:
```
Banner /etc/issue.net
```
3. Set `PermitEmptyPasswords no`
4. Set `PermitRootLogin no`
5. Whitelist specific users--
```
AllowUsers username username2
```
6. Change the port to run SSH on
7. Time out logins: check every 60 seconds and after the third time, logout:
```
ClientAliveInterval 60
ClientAliveCountMax 3
```
8. Use key-based authentication
```
# create the key pair on your client machine:
ssh-keygen

# send the public key to the server:
ssh-copy-id user@hostname

#test the connection
ssh user@hostname

# turn off password authentication in sshd_config
PasswordAuthentication no
PublicKeyAuthentication yes

## Additional notes from How-To Geek
+ Add `Protocol 2` to the config file to force the newer protocol
+ Use tcp_wrappers to create an access control list - lives in `/etc/hosts.deny` and `/etc/hosts.allow`
** Add `ALL : ALL` to the deny file to block access by default; add hosts you do want to accept to the allow file
+ Set `PermitEmptyPasswords no`
+ Set `MaxAuthTries 3` to prevent brute force password attacks

