---
title: home server
type: post
date: 2022-10-16
tags: selfhosting
---

* For the most part, it doesn't matter what OS you use
* Hypervisor = run a number of virtual machines, no desktop GUI
** Proxmox, TureNAS, UNRAID
** you can run these on pretty much anything but min requirements:
*** make sure the CPU supports virtualization (google model number+virtualization)
*** at least 8gb RAM
*** at least 8 CPU threads **not the same as cores ** could be 4 cores with multithreading * again, google

Use Docker to set up either way 
Storage: set up a RAID configuration if you have multiple hard drives * better performance & redundancy (Windows calls them Storage Spaces)

Using Windows:
On your server machine:

* Install Windows Subsystem for Linux
* Install Docker
* Install services *
** NextCloud (home DropBox)
Docker will automatically spin up a container & you can access it in a browser at localhost:<port>
** Portainer * a better Docker manager on Windows * much easier to use if you're not super familiar with Docker
        Portainer is very good for templates & spinning up instances of common services

Using a hypervisor OS (proxmox):
* Install based on documentation: flash the ISO & boot from there, etc. etc. 
* Access web GUI using port # of the machine
* You'll see a menu: datacenter, node (node = machine) * and within that node, containers
** The beautiful thing about a hypervisor is you can set up multiple containers and allocate resources exactly where you want them, dedicate fewer resources to low*demand services and more for higher*demand services
* Node > Local storage > templates > Ubuntu server
* Download & Create CT (or upload the ISO if you want to boot from it)
* Disks: how much storage this service will have access to
* CPU: how many cores(=threads) this service will have access to
* Likewise memory
* Can assign a static IP address in Network but you will have to set it; pick dynamic & set static from the router
* Complete, spin up, log in as root user, install docker

So in other words: you could install something with a GUI and use Docker to manage your services, or you could install something that will manage multiple instances that you can manage via the LAN in a browser, sometimes via a command line and sometimes with a web*based GUI

##Use Cases:
* learn an operating system: a new Linux distro or an old one
* home automation: HomeAssistant can control your devices without sending them to Google
* run a web server: self*host or play with front*end technologies
* run your own API: serve out some data 
* home security: Blue Iris is good, and you just buy the software & don't pay a subscription
* entertainment: run Kodi or Plex
* run a virtual firewall: pfsense is one of the most popular, lots of alternatives
* home network: unify lets you manage your network (more features if you use ubiquity hardware)
* vpn servers: not private VPN, but VPN into your home network when you're away * remote into your home machine, use your network instead of public wifi, print at home from outside
* docker: basically opens up all possibilities 
* database server: persistent storage
* file server: simple as SambaShare on Windows/Linux, as complex as FreeNAS
* ad blocking: set up a Pi*hole and block ads everywhere (yes, you can do this on a VM on your own computer)
* personal cloud: access to your personal documents from anywhere or collaborate * NextCloud is one of the most popular
* ftp server: more of a public cloud, good for sharing large files or securely sharing using SSL
* reporting server: grafana for visualizing
* torrent box: seed Linux distros
* backup server: backup or synchronize files (YourBackup is open source, Duplicati or SyncThing for syncing)
* game server: run minecraft, or set up steam in*home streaming
* crowdsource compute: dedicate some resources to folding@home

###Why run a hypervisor?
You get better access to and control of your hardware
proxmox can also function as a NAS if you want it to 

TrueNAS for storage, but it can also deploy virtual machines * you can use it as a host operating system (aka TrueNAS is a NAS that can function as a hypervisor)
        you can run NextCloud and SyncThing as TrueNAS plugins (also Plex but I like my Kodi)
SyncThing can run in its own virtual machine and back up files for you; very lightweight and easy to use

DEFINITELY use Portainer to deploy Docker containers; it's so much easier

Heimdall * dashboard/launcher
Guacamole * clientless remote desktop gateway: one login for all your different connection types (SSH, VNC, Remote Desktop, etc.)

