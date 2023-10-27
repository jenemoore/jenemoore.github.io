---
title: nfs
type: post
date: 2023-02-08
tags: 
- linux
- automation
---

# Automounting NFS shares

## Create the mount to make sure it works:
1. `showmount -e 192.168.0.12`
1. Create a folder for it: `mkdir ~/Network-files`
1. Open the fstab file `sudo vim /etc/fstab` and add:
```
# NFS server share
servername:/data /home/username/Network-files nfs
rsize=8192,wsize8192,timeo=14,_netdev 0 0
```
