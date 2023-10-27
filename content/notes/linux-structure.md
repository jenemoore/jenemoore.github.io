---
title: Linux structure
type: post
date: 2023-07-23
tags: 
- linux
---

# Directory structure & rules

## Top-level directories:
- / 					root of everything
- /bin				essential command binaries for all users: eg. cat, ls, cp
- /boot 			bootloader files, kernel; often a separate partition
- /dev				essential devices: eg. /dev/null, /dev/sdb
								- /dev/null can be sent to destroy any file or string
								- /dev/zero contains an infinite sequence of zero
								- /dev/random contains an infinite sequence of random(ish) values
- /etc				host-specific system-wide config files: eg. /etc/hostname
- /etc/opt		configuration files for /opt
- /etc/X11		configuration files for the X Window System, version 11
							(et cetera)
- /home				users' home directories; often a separate partition
- /lib				libraries essential for binaries in /bin and /sbin
- /lost+found	automatically created to store corrupted files
- /media			mount points for removable media like CD-ROMs and USB drives
- /mnt				temporarily mounted filesystems
- /opt				optional application software packages
- /proc				virtual filesystem documenting kernel and process status (in Linux, a procfs mount)
- /root				home directory for the root user
- /run				runtime variable data: may be a tmpfs (a newer convention to accommodate ssd: the idea is to have a read-only ssd boot drive and writeable folders on the hdd)
- /sbin				essential system binaries: eg. init, ip, mount (generally can only be run by sudo user: s for sudo)
- /srv				site-specific data which is served by the system: eg. git repos, FTP locations, and web server data (it's best practice to host your website from here, if you're not using apache and its insistence on /var/www)
- /tmp				temporary files; often purged on reboot
- /usr				secondary hierarchy for read-only user data; contains most user utilities and applications
- /usr/bin		non-essential command binaries for all users
- /usr/sbin		non-essential system binaries: eg. daemons for network-services
- /usr/share	architecture-independent data
- /usr/src		source code, eg. kernel source with header files
- /usr/local	tertiary hierarcy for local data, specific to this host (traditionally distinct because /usr may be shared across a network): this is where locally compiled applications install to by default, preventing them from interfering with other users
- /var				variable files whose content is expected to change continually during operation: eg. logs, spool files, temporary email; often a separate partition
- /var/lib		state information; persistent data modified by programs as they run: eg. databases, packaging system metadata, etc.
- /var/lock		lock files (tracking resources currently in use)
- /var/mail		users' mailboxes
- /var/run		information about the running system since last boot; in 3.0 replaced by /run and can be symlinked for backwards compatibility
- /var/spool	spool for tasks waiting to be processed: eg. print queues and unread mail
- /var/www		website file hierarchies


### General themes
- if you're installing software and you have a choice where, /opt is the best choice: normal practice is to keep the code in /opt and symlink it to /bin so all users can run it
- otherwise just put everything in /home/user
 
## Shorter list
- /bin		binaries for all users
- /sbin		binaries for system users
- /etc		configuration files
- /dev		device files
- /proc		process files
- /var		variable files
- /tmp		temporary files
- /usr		user programs
- /home		home directories
- /boot		bootloader files
- /lib		system libraries
- /opt		3rd party software
- /mnt		manual mount directory
- /media	removable devices
- /srv		service data
