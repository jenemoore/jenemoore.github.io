---
title: Linux quickref
type: post
date: 2023-02-25
tags: 
- linux
- quickref
---

# Linux Quickref

## IP info:
`ip-h address` or `hostname -I`

## User creation

`useradd USERNAME`

### Options:
* `-r` system user
* `-g` primary group
* `-G` additional groups
* `-c` comment

Set password with `passwd`

### Add user to group:

`usermod -aG group user`

### Lock a user account by expiring it

`change -EO user`

### List all users

`cat /etc/passwd`

## Search within current directory for text in a file:

`grep -nr 'search string' .`

## Add a directory to PATH:

`export PATH: /new/dir:$PATH`

## Networking

### Display listening sockets

`ss -trp` will display TCP sockets, resolves addresses/ports to services, and shows the associated processes

## Symlinks

### Create a link:

`ln -s /path/to/target /path/to/source`

## Passwordless SSH login

### Create keys:

* `ls -al ~/.ssh/id_*.pub` to check for preexisting keys
* `ssh-keygen -t rsa -b 4096 -C "comment"` to create keys

### Install keys:

`ssh-copy-id -i /path/to/key user@server`

## SSH Tunnelling

`ssh -L localport:remotehost:remoteport -f user@host`

* You can attach multiple tunnels at once on different ports
* -f runs the tunnels in the background
* You can do this in reverse to give someone on the outside temporary access to your network
* You can also launch Chrome from the command line or install a proxy plugin to proxy the whole browser

## Inventory

### List all services

`sudo systemctl list-unit-files --type service --all`

### List active services

`sudo systemctl | grep running`

## Copy files to a remote server

`scp -P port file user@destination:destinationfile`

## Launch x11vnc server

`x11vnc -bg -o ~/x11logfile.log -usepw -clip xineramoa0`
