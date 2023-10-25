# How to Homelab
## Part 3: Hosting an Intranet Site with pfSense and NAT

source: https://www.dlford.io/pfsense-nat-how-to-home-lab-part-3/

Proxmox provides good firewall features but you'll need more configuration options for DHCP, DNS, and NAT

This configuration will keep your VM network contained within the host

### Install pfSense
1. Download an ISO and upload it to your host
2. Configure an internal network: 
    * Datacenter > hostname > Network, click Create > Linux Bridge
    * Restart Proxmox
3. Create a new VM with auto-start settings:
    * start at boot
    * start/shutdown order: give it a low number
    * startup delay: seconds to wait after booting this VM before booting the next (30)
    * shutdown timeout: 5 min. is fine
    * OS settings: ISO image pfSense, Guest OS Type Other
    * Hard Disk: change Bus/Device to VirtIO Block & check discard
    * CPU: 1 or 2 cores, 2048 units (more units gives priority to this machine)
    * Memory: 512MiB
    * Network: VirtIO (paravirtualized), leave Bridge on vmbr0 for now
    * Finish
4. Open pfSense VM Hardware, choose Add Network Device
    * Bridge vmbr1 (internal private network), Model VirtIO
5. Start machine and run through installer; reboot
6. Final config: 
    * Should VLANs be set up now? (n)
    * Enter the WAN interface: vtnet0
    * Enter the LAN interface: vtnet1

### Configure pfSense
7. When bootup is finished, choose option 8 and press enter to open a shell session
8. Disable the firewall temporarily for setup: run `pfctl -d`
9. Note the IP address of the WAN interface
10. In a browser, open [https://ipaddr] - accept the invalid SSL certificate and login with default credentials (u admin p pfsense)
11. Configure hostname and DNS server, timezone
12. Configure the WAN interface with a static IP address within your home network (just like your Proxmox host); match subnet mask and upstream gateway
13. Configure LAN IP address and subnet mask for the internal network side -- I used 192.168.1.1/24
14. Set up an alias for pfSense admin ports: 
    * Firewall > Aliases > Ports > Add
    * Name and description that makes sense; add ports 80 (HTTP), 443 (HTTPS), 22 (SSH), and 8080 (Alt HTTP)
15. Add a firewall rule to allow home network access to the interface:
    * Firewall > Rules > WAN > Add
    * Action: Pass
    * Interface: WAN
    * Address Family: IPv4
    * Protocol: TCP
    * Source: Network (home network)
    * Destination: This firewall
    * Destination Port Range: from/to pfSenseAdminPorts (alias from 14)
16. Save and apply changes
17. Go to Interfaces > WAN and uncheck "Block private networks and loopback addresses" and "Block bogon networks", save and apply
18. In the console session, run `pfctl -e` to turn the firewall back on
19. Change your password
20. System > Advanced > Networking, check "Disable hardware large receive offload", recommended setting for VMs
21. Move the interface to port 8080: System > Advanced > Admin Access, webConfigurator TCP Port 8080 and save

### Set up a template server
Setting up a template allows you to install required software just once and to use linked clones to save on disk space and RAM usage as virtual machines share these resources 

22. Download and upload your favorite server ISO
23. Create a new VM:
    * ID: 1001 (high enough to keep it at the bottom of the list)
    * Name: include OS & version, maybe date?
    * OS: CD ISO; Guest OS: Linux/5.x
    * System: defaults
    * Hard disk: 8GiB (I found Ubuntu Server wanted more, 20ish to install); always check Discard
    * CPU: 2 cores (can be changed on clones as needed)
    * Memory: 1024 (can be changed on clones as needed)
    * Network: Bridge vmbr1 (private VM network)
24. Install as usual; make sure the IP address is in the network range you set in pfSense
25. Run all available updates `sudo apt update && sudo apt -y dist-upgrade`
26. `sudo apt install -y qemu-guest-agent`, this communicates with Proxmox and lets the host run commands on the guest. 
27. Install any other core software you know you'll always want, and shut down when finished.
28. Go to your VM > Options and double click on Qemu Agent; tick both boxes and click OK
29. Right-click on the name of the template VM and choose `Convert to template`

### Create a web server VM
30. Right-click on template and choose Clone
31. Choose a name for the new VM and use Linked Clone for the Mode
32. Go to Options and select Start at Boot, choose a number for the order after pfSense, then set it to Yes
33. Under the Hardware tab, double-click on Network Device and copy the MAC address
34. Start up the machine and run some boilerplate code to make sure it's seen as a new machine and not identical hardware to the original template:

Run as root:
```
rm -f /var/lib/dbus/machine-id
rm -f /etc/machine-id
dbus-uuidgen --ensure=/etc/machine-id
ln -s /etc/machine-id /var/lib/dbus/
ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa -y
ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa -y
ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa -b 521 -y
sudo touch /etc/cloud/cloud-init.disabled
sed -i 's/$HOSTNAME/$newhostname/g' /etc/hosts
sed -i 's/$HOSTNAME/$newhostname/g' /etc/hostname
hostnamectl set-hostname $newhostname
```
--And whatever customization you need to do for networking!
/etc/netplan/01-netcfg.yaml

upd: `curl -s https://gitea.quadrifrons.online/jen/

35. `sudo apt install -y nginx`
36. Configure the DHCP reservation:
    * In pfSense, Services > DHCP Server
    * Change the values for Range to leave some addresses open for reservations
    * Click Add under DHCP Static Mappings
    * Paste in your MAC address and give it an identifier (usually hostname); choose an IP address in the range  you reserved
    * Description, save & apply
37. Configure port forwarding to use NGINX as a reverse proxy:
    * Firewall > Aliases > IP, add your NGINX server as an alias
    * Firewall > Aliases > Ports, add 80 and 443 as web_ports
    * Firewall > NAT > Port Forward
        * Interface: WAN (forward requests to this port coming from the WAN interface, aka your home network)
        * Protocol: TCP
        * Destination: WAN address (forward requests destined for the IP address of pfSense on your home network)
        * Destination port range: to/from web_ports (alias from above)
        * Redirect target IP: nginx (alias from above)
        * Redirect target port: web_ports (alias from above)
        * Description, save & apply
38. Reboot the NGINX VM and confirm the new IP address
39. Test: go to http://pfsenseip (without a port assigned) - if you see the default NGINX page, your NAT port forward is working as expected!
40. Take a snapshot of the NGINX server before you start tinkering


