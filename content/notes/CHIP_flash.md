---
title: CHIP flashing
type: post
date: 2023-07-05
tags: 
- firmware
- chip
- debian
- polished
---

u Setting up the CHIP to run Debian Bullseye

NB: For what it's worth, I think the HDMI adapter is broken, or is breaking the CHIP, don't use it if you can at all avoid it

## Prerequisites
- fastboot (android-tools)
- sunxi-tools
- uboot-tools

## Flashing the original firmware
(This is almost always necessary because the solid-state storage of the CHIP wipes itself if it's left untouched for too long...which it probably has been)

- Use a virtual machine to avoid dependency conflicts: 
    - `sudo add-apt-repository -y ppa:apptainer/ppa`
    - `sudo apt install -y apptainer`
- Plug in the CHIP with a data-capable USB-micro cable
- Download c.h.i.p.-flasher from https://cloud.sylabs.io/library/bpietras/bpietras/c.h.i.p-flasher
- Download the stable-server-b149 collection from https://mega.nz/file/97phVRTB#s4e2FWfajnNf4qshi-0DzyTyshG4t7kGJfoLC5Hreqs
- Unzip the stable-server-b149 image
- Run the command to flash: 
    ```
    apptainer exec bpietras_bpietras_c.h.i.p-flasher.sif chip-update-firmware.sh -L stable-server-b149
    ```
- When the console outputs `waiting for fel......` short the FEL and ground pins
- Follow the prompts to choose your version


## Updating Debian

- Connect to the CHIP as a serial device: 
    - run `sudo dmesg | grep tty` to identify the port
    - connect to it using screen: `sudo screen /dev/[port] 9600`

- Connect to wifi: `nmtui`
- Open a terminal and edit /etc/apt/sources.list
    - ```
    deb http://archive.debian.org/debian jessie main

    deb http://chip.jfpossibilities.com/chip/debian/repo jessie main
    ```
- Edit /etc/apt/preferences and replace `opensource.nextthing.co` with `chip.jfpossibilities.com`
- Edit /etc/apt/apt.conf and add the line `Acquire::Check-Valid-Until false;` to get around the expired key
- `sudo apt update && sudo apt full-upgrade -y --force-yes`
- `sudo apt-get autoremove --purge`
- `sudo apt-get clean`

### Updating to Stretch

- Do this from tmux or a COM port, it will disconnect your ssh session and corrupt your install
- Edit /etc/apt/sources.list again:
    - delete the jfpossibilities line
    - replace 'jessie' with 'stretch'
- `sudo apt update && sudo apt full-upgrade`
- Files are safe to replace if you're not intending to use a PocketCHIP (if you are, don't let it overwrite /etc/lightdm/lightdm.conf)

- Fix MAC address randomization, which the CHIP wifi card doesn't support: edit /etc/NetworkManager/NetworkManager.conf and after the [main] block add:
    - ```
    [connection]
    wifi.mac-address-randomization=1

    [device]
    wifi.scan-rand-mac-address=no
    ```
- `wget -O ~/.config/awesome/rc.lua https://raw.githubusercontent.com/mackemint/PocketCHIP-buster-update/main/assets/rc.lua`
- Reboot
- At this point you can remove the /etc/apt/apt.conf line

## Updating to Buster

- Edit /etc/apt/sources.list again, commenting out all but the first line
    ```
    deb http://deb.debian.org/debian buster main
    deb http://security.debian.org/debian-security buster/updates main
    ```

- Remove the old o-marshmallow repo:
    - `sudo rm /etc/apt/sources.list.d/marshmallow-pocket-chip-home.list`
- `sudo apt update && sudo apt full-upgrade`
    - Don't replace /etc/security/limits.conf or /etc/plymouth/plymouthd.conf
- Disable wpa_supplicant in systemd
- Reboot

## Updating to Bullseye
- Buster is still technically under LTS so you can be patient about this if you want
- deb http://deb.debian.org/debian bullseye main
- deb http://security.debian.org/debian-security bullseye-security main
- deb http://deb.debian.org/debianbullseye-updates main


## Configuring

- Turn off root login and (if you've copied over ssh keys) password login in /etc/ssh/sshd_config
- restart ssh
- Lock the root account with `sudo passwd -l root` 
- Change the chip user password with `passwd`
- Set up locales:
    - `sudo apt install locales`
    - `sudo locale-gen en_US en_US.UTF-8`
    - `sudo dpkg-reconfigure locales`
    - `sudo dpkg-reconfigure tzdata`
- Change the hostname:
    - `sudo sed -i 's/chip/new-hostname/g' /etc/hostname`
    - `sudo sed -i 's/chip/new-hostname/g' /etc/hosts`
- Install utilities:
    - `sudo apt install vim git libx11-dev libxtst-dev software-tools-common`

Now you can unplug it from data and power it using a wall outlet and a cheaper cable

## Sources
- 'a comprehensive guide to setting up a pocketchip'
- https://github.com/Thore-Krug/Flash-CHIP
- https://www.reddit.com/r/ChipCommunity/comments/qc2jtl/resurrected_chip_for_hass_project/
- https://www.reddit.com/r/ChipCommunity/comments/z73f21/new_chip_flashing_method/
- https://www.reddit.com/r/ChipCommunity/comments/rhqgkj/i_just_ordered_a_pocket_chip/
