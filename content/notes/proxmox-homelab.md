---
type: "post"
---

3/3/23

* Got about halfway through the web hosting article, including setting up DDNS
* The rest of it involves a huge amount of typing, so rather than actually typing it all I'm...apparently going to do exactly that. Sigh.  

3/25/23

4A:45:39:6F:C7:DF

## Setting up a new VM clone

1. Clone UbuntuServer22.04
1. Options -> Start at boot = yes, Start/Shutdown order = 20
1. Copy mac address from hardware > network device
1. Switch to console, run boilerplate (proxmox-boilerplate.md)
1. Edit /etc/netplan/01-netcft.yaml: change dhcp4: no to yes, remove addresses, save and run sudo netplan apply
1. Set up DHCP assignment in pfSense (192.168.0.56:8080) -> Services -> DHCP server -> MAC address, IP assignment, hostname
1. apt update & apt upgrade
1. Reboot

