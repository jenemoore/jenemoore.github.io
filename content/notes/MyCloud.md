---
title: MyCloud
type: post
date: 2023-01-29
tags: 
- linux
- debian
- firmware
- mycloud
---


1. BACK UP. All that data needs to go somewhere; fortunately I'm already working on de-duplicating files and settling on backups. Pretend the drive is dying and everything needs to exist somewhere else.

2. Take the drive out of the case—there are four screws behind the rubber feet

3. Connect it to a Linux box using a SATA cable or a USB UART cable to the serial port - black to GND, green to Rx, white to Tx, leave red unattached
    3a. if using the serial connection you'll need to use something that can communicate over the serial port, ie Serial App

4. ALTERNATIVELY: try booting from a USB drive (ONCE BACKED UP)
    a. Create a bootable Debian drive using this file:
        https://linuxserver.tips/en/install-debian-and-openmediavault-on-a-wd-my-cloud-home/
    b. Put it in the USB port, hold the reset switch down while you connect the power and hold it until the light stops flashing (around 20sec)
    IF IT DOESN'T INSTALL— 
    - Telnet into it
    - Execute the makepartshdd.sh script
    - then issue:
        cd / ; umount /mnt/* ; sync ; busybox reboot
    - then reboot and restart as before, holding down the restart button
    - telnet in again and check the partition table:
        sgdisk /dev/sataa -p
        Partition 20 sholuld be 25GB and 24 should cover the rest of the drive
    - if everything looks good, install Debian:
        installdebian11.sh
    - put in the reboot command
    - wait 1 min and telnet back in; if this doesn't work, remove the flash drive and reboot by unplugging the power
    - now you should be able to ssh in as root
    —Now to install OpenMediaVault—
    - run the install script
        /root/installomv6.sh
    - this will take a while. when it's done, reboot—
        systemctl reboot
    - now you can log into MCH in your browser
        user: admin
        pwd: openmediavault
    c. log into the OpenMediaVault interface in your browser; may take a couple of minutes to fully boot up and get assigned an IP

NOTES: 
	stage 1 worked, got the repartitioning done; stage 2 did not and got stuck in a boot loop
	rec: boot from a flash drive, run
	dd if = / dev / zero of = / dev / sataa bs = 2M
	and try again (or at this point, maybe something different)

Ref. URLs:

-- https://nerdprojekte.wordpress.com/2021/02/22/wd-my-cloud-home-to-linux-server-2-installation/
-- https://4pda.to/forum/index.php?showtopic=467828&st=16980#entry110514773

Notes on OMV:
    - HDD and SMART should be visible
    - to see the sataa20 system partition install openmediavault-sharerootfs
    - to see the sataa24 user partition mount 8it in the store>file systems
    - to run Portainer/Yacht/Docker, specify DNS in the network settings
    - to reduce log files:
        echo 'kernel.printk = 3 4 1 3' >> /etc/sysctl.conf
        echo 'debug.exception-trace = 0' >> /etc/sysctl.conf
      and then reload with 
        sysctl -p

OH MY GOD AT LAST--somehow I didn't think to take out the flash drive once I rebooted it into standard Debian, but it's chugging away now, installing OMV!! Finally, my drive will be useful again!!! (And then I'll have to figure out what to do with it...hm......)


