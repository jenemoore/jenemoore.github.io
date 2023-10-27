---
title: ports
type: post
date: 2023-01-29
tags: 
- networking
- windows
---
20 - TCP - FTP data
21 - TCP - FTP control
22 - TCP - SSH
25 - TCP - SMTP
53 - UDP/TCP - DNS
80 - TCP - HTTP
110 - TCP - POP3
443 - TCP - SSL
143 - IMAP
443 - HTTPS

to find open ports on windows:
	Netstat -ab
shows the ports in use
	netsh firewall show state
shows win firewall state
	netstat -ano | findstr -i SYN_SENT
shows ISP/ router blocking

generally, pick something with 5 numbers, starting <6
