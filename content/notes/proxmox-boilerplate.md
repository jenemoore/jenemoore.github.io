---
title: proxmox boilerplate
type: post
date: 2023-05-25
tags: 
- selfhosting
- script
- proxmox
---

# Boilerplate

After setting up a new VM--especially a clone--run the following commands

(these are Ubuntu commands; you may need to tweak them for other os)

```
rm -f /var/lib/dbus/machine-id
rm -f /etc/machine-id
dbus-uuidgen --ensure=/etc/machine-id
ln -s /etc/machine-id /var/lib/dbus
```

And if  SSH is installed:

```
ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa -y
ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa -y
ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa -b 521 -y
```

In Ubuntu, disable Cloud init:

```
touch /etc/cloud/cloud-init.disabled
```

Then set the hostname: as a general pattern, use the name of the template and then the name of the service/use

```
sed -i 's/worceter-01/nginx/g' /etc/hosts
sed -i 's/worceter-01/nginx/g' /etc/hostname
hostname ctl set-hostname nginx
```

Then reboot
