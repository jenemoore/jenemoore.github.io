---
title: recovering from system compromise
type: post
date: 2023-02-02
tags: 
- linux
- security
---

# CERT Coordination Center Guide to Recovering from a UNIX System Compromise

1. Document all the steps you take--this is a stressful process and you're likely to make hasty decisions
1. Regain control:
1.1. Disconnect all compromised machines from the network
1.1.1. Decide whether you want to check for a network sniffer or other active processes or reboot into single user mode to prevent intruders from changing anything on the compromised machine
1.1. Make an image of the compromised system: use the `dd` command to make an exact copy, if you have a disk big enough
1. Analyze the intrusion
1.1. Look for modifications made to system software and config files
1.1.1. Boot from a trusted kernel and obtain clean copies of testing tools
1.1.1. Binaries in particular to check:
	- telnet
	- in.telnetd
	- login
	- su
	- ftp
	- ls
	- ps
	- netstat
	- ifconfig
	- find
	- du
	- df
	- libc
	- sync
	- inetd
	- syslogd
	(and surely systemd etc.)
	- anything in /etc/inetd.conf
	- any shared object libraries
1.1.1. use `cmp` to make a direct comparison of binaries and original distribution media
1.1.1. Inspect your configuration files:
	- /etc/passwd
	- /etc/inetd.conf
	- /etc/hosts.equiv or .rhosts
	- SUID and SGID files: print all that exist with ` find / \( -perm -004000 -o -perm -002000 \) -type f -print`
1.1.1. Check for odd users or group memberships
1.1.1. Check for changes to systemd files
1.1.1. Check for unauthorized hidden shares with `net share` or the Server Manager tool
1.1. Look for modifications to data
1.1.1. Verify web pages, FTP archives, files in home directories
1.1. Look for tools and data left behind by the intruder
1.1.1. Network sniffers: built to watch for username and password data
1.1.1. Trojan horses
1.1.1. Backdoors
1.1.1. Vulnerability exploits
1.1.1. Log files from any intruder tools
1.1.1. Look for unexpected ASCII files in /dev (many Trojans rely on config files there)
1.1.1. Look for hidden files or directories
1.1.1. Look for files or directories with names like `...` or `.. ` (two dots and whitespace: looks like the filesystem breadcrumb)
1.1. Review log files 
1.1.1. This will help you understand how your machine was compromised, what happened during the compromise, and what remote hosts accessed your machine
1.1.1. Check /etc/syslog.conf to find where the syslog is logging messages
1.1.1. messages: look for anomalies and events around the known time of intrusion
1.1.1. xferlog: logs all ftp transfers
1.1.1. utmp: binary information for every user currently logged in (`who` command)
1.1.1. wtmp: logs every time a user logs in, out, or your machine reboots; use `last` to see user names associated with timestamps and hostnames
1.1.1. Some UNIX systems log tcp wrapper messages to a secure file
1.1. Look for signs of a network sniffer
1.1.1.  Check for any interfaces in promiscuous mode: use `cpm` or `ifstatus`
1.1.1. Use `df` to determine if part of the filesystem is larger than expected (ie contains a growing sniffer log): this utility is commonly replaced, be sure to use a fresh copy
1.1.1. To search for common log patterns:
```
grep PATH: $sniffer_log_file | awk '{print $4}' | \
awk -F\( '{print $1}'| sort -u
```
1.1. Check other systems on your network to be sure no other systems are compromised
1.1. Check for systems involved at remote sites
1. Recover from the intrusion
1.1. Install a clean version of your operating system
1.1. Disable unnecessary services
1.1. Install all vendor security patches
1.1. Check for current warnings and known vulnerabilities
1.1. Be careful when using data from backups
1.1. Change passwords
1. Improve your system and network security
1.1. Review guidelines and best practices
1.1. Install all security tools before connecting to the network again; take an MD5 checksum snapshot
1.1. Enable maximum logging
1.1. Configure firewalls to defend networks
1. Reconnect to the Internet
1. Update your security plan
1.1. Document lessons learned
1.1. Incorporate any changes into processes

