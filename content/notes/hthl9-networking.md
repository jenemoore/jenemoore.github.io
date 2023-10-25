# How to Homelab
## Part 9: Expanding Your Home Network

source: https://www.dlford.io/expanding-your-home-network-how-to-home-lab-part-9/

### Hardware
This is a major reconfiguration; it takes work to set up and work to maintain. To make pfSense the edge of your network, you will need:
    * a machine with two or more network interfaces
    * an empty USB stick
    * ideally a layer 2 managed switch with VLAN support (rec. Netgear GS308T) (a standard router could be used, but not a modem/router combo)
    * and a dedicated wifi router

    *DO NOT BRIDGE TO YOUR MODEM,* you must have a separate modem to do this safely!

### Layouts
The most ideal is:
    /*********/
    /  Modem  /
    /*********/
        |
   /*********/
   / pfSense /
   /*********/
        |
   /*********/
   /  Switch /
   /*********/
     |      \_______ 
/*********/     /*********/
/  Wifi   /     / Devices /
/*********/     /*********/

You can skip the switch and go from wifi to devices or you can attach both wifi and devices straight to pfSense, but only pfSense should connect directly to your modem.

### Prepare installation media
1. Take a backup of the current pfSense configuration: Diagnostics > Backup & Restore > Download configuration as XML
2. Set up a fresh installer for pfSense and choose the appropriate architecture, USB Memstick for the installer option, and VGA for the console
3. You can use dd to burn the image:
    ```
    sudo dd \
    if=pfSense-netgate-memstick.img \
    of=/dev/sdXX \
    bs=4M
    ```
4. Copy your configuration backup to the FAT32 partition and rename it to `config.xml`
5. Install pfSense and allow it to restore from configuration
6. After installation, plug a computer into the LAN port and connect to the web interface to make sure it looks good, then connect the WAN port to your modem

### VLANs
A VLAN is essentially a separate network on the same hardware. If you have a managed VLAN switch you should create a new VLAN interface in pfSense for your servers and leave the LAN network for your workstation & phone access (maybe add a VLAN for your IoT devices, to keep them isolated). 

7. Go to Interfaces > Assignments > VLANs and add a new VLAN
8. Choose the parent devices (the LAN port), a VLAN Tag number (anything but 1), and you can leave priority blank unless you're shuffling traffic
9. Go back to Interface Assignments and select the new VLAN next to Available network ports, and click add; change the name if you want and assign an IPv4 address space
10. Services > DHCP Server and select the new VLAN; enable DHCP and set the address pool range
11. Firewall > Rules and add an allow any rule; you can fine-tune it later as needed
12. Plug the switch into your workstation and get it configured:
    * varies depending on your hardware but basically you want to make sure tags (and untagged traffic) are set correctly
    * if Port 1 is the uplink to pfSense and port 2 is on VLAN11, then remove untagged VLAN1 from port 2, add untagged VLAN11 to port 2, add tagged VLAN11 to port 1 
    * Now traffic for a host on VLAN11 can be passed from any LAN port to pfSense, which will tag the packets for VLAN11 and send them back to the switch, which will route the traffic out port 2 to the host (and vice versa)
    * To complete the package, add VLAN tags to your VMs in Proxmox:
        * Host > System > Network > vmbrN

### Migration
13. Plug pfSense into the modem and your switch into pfSense, and everything else on the network except for Proxmox into the switch
14. Put your wifi router in DHCP passthrough mode (or don't use the WAN port, if it doesn't have passthrough mode)
15. Change the IP address and gateway for the Proxmox host to fit into the new pfSense network: Host > System > Network > vmbr0, don't forget to check "VLAN aware" if you'll need it. Save and shutdown.
16. If you don't need to change your Proxmox IP address or enable VLANs, you can move the network cable over now--boot up and log into the web interface.
17. For each VM, under Hardware, change the network device to vmbr0 and shut down the pfSense VM in Proxmox. Check that the VMs are getting the expected IP addresses and are accessible.
18. On your physical pfSense host, go to Services > DNS Resolver and add a host override for each domain that points to the reverse proxy

### Bridge Modem
*Please do not bridge your modem unless the only device plugged into it is the pfSense machine or some other firewall* Bridging your modem essentially disables all its functions other than simply connecting you to the Internet--pfSense will get your public IP directly from your ISP. Configure this in the modem or via your ISP's interface.
