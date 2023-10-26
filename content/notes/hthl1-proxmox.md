---
type: "post"
---

# How To Homelab
## Part 1: Proxmox VE

source: https://www.dlford.io/how-to-home-lab-part-1/

1. Turn on virtualization in BIOS
2. Install Proxmox: it's an OS, run it off the installer USB
3. You will use the root password routinely, remember it
4. Configure DHCP/DNS and set an IP address
5. Login to the web interface: https://serverip:8006, u root, p as set
6. Select the server by hostname and then click Shell in the top right
7. Update the repository to draw updates from the free Community edition (update distribution name as necessary):
```
cd /etc/apt/sources.list.d
mv pve-enterprise.list pve-enterprise.list.disabled
echo 'deb http://download.proxmox.com/debian/pve buster pve-no-subscription' > pve-community.list
apt update
apt -y dist-upgrade
```
8. Reboot (or shut down, if you need to unplug and relocate)
9. Create a VM:
    a. upload ISO to local storage
    b. select Create VM
    c. give it a name, select your ISO
    d. select sockets/cores (1 is usually fine), RAM (1024 generally)
    e. finish, then click start
