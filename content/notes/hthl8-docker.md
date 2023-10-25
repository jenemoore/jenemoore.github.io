# How to Homelab
## Part 8: Docker

sources: 
    https://www.dlford.io/docker-basics-how-to-home-lab-part-8/
    https://www.reddit.com/r/Proxmox/comments/yy0kha/confused_on_when_to_use_vm_vs_lxc/
    https://www.wundertech.net/how-to-set-up-docker-containers-in-proxmox/

### Containers vs VMs
* Think of a container like a snapshot: it's not a full system, but it's enough of one
* Because it's not fully isolated, low memory will kill off processes in a container (while a VM isn't bothered by other systems using memory)
* Live migrations aren't possible: you need to stop the container to move it
* Containers use the host's kernel, so they can only run Linux
* Containers can share volumes/mount points without needing to set up synchronization or NFS
* The host has direct access to the container's data
* Containers generally consume fewer resources to run but can be more fragile
* VMs are a better option for something that won't tolerate downtime
* VMs have better passthrough access to hardware (esp. USB devices attached to the host)
* If an app in a container causes a kernel panic, it can bring down the whole server; a VM will only bring down itself

### Add Disk Space: Grow Hard Disk
1. Clone and set up a new VM (up the RAM and CPU count)
2. Add disk space: VM > Hardware > Hard disk > Resize Disk, whatever number you enter will be added to the existing size
3. In the VM, run `sudo parted /dev/sda` and type `p` to print the partition table--it should give you a warning that not all space is available. Tell it to fix it.
4. Quit parted and run `sudo fdisk /dev/sda` and type `p` for the current table. Delete partition 3:
    * type `d` and `3`
    * type `n` to create a new partition, and enter 3 times to accept defaults
    * Do not remove the existing filesystem signature - `n`
    * Type `p` and ensure everything looks good, then `wq` to write changes and quit
    * You should see a message that it's syncing disks
5. Run `sudo pvresize /dev/sda3`; it should show you that the physical volume has been resized
6. Run `sudo lvs` to get the vg and lv names; run `sudo lvresize -l +100%FREE /dev/vg-name/lv-name` to extend the logical volume
7. Run `sudo resize2fs /dev/vg-name/lv-name`

### Install Docker
8. Follow instructions from [https://docs.docker.com/engine/install/ubuntu](Docker.com)
9. Add your user to the docker group: `sudo usermod -aG docker USERNAME`
10. Install Portainer:
    ```
    docker pull portainer/portainer
    docker volume create portainer_data
    docker run -d --name portainer_gui \
        --restart always \
        -e "CAP_HOST_MANAGEMENT=1" \
        -p 9000:9000 \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v portainer_data:/data \
        -v /:/host \
        portainer/portainer
    ```
11. Log in and set up a username and password, and set upp the public IP at Endpoints > local so you can click straight through to a container

