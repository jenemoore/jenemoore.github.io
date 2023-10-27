---
title: dnsomatic
type: post
date: 2023-05-29
tags: 
- rough
- dns
- cloudflare
---

! DNSomatic:

* has trouble accepting special characters in the email/password fields:
* make sure your account has a username (not email address) and your password only uses * for special characters

Configuration of DNS-O-Matic requires the following information:

* Email: [CLOUDFLARE ACCOUNT EMAIL ADDRESS] (associated account must have sufficient privileges to manage DNS)
* API Token: [CLOUDFLARE GLOBAL API KEY] 
* Domain: [example.com]
* Hostname: dynamic

! Cloudflare:
!! set the following DNS records
* Type: A             |              Name: dynamic                                |              Value: “your WAN IP” ***
* Type: CNAME |              Name: “yourdomain.xyz”           |              Value: dynamic.”yourdomain.xyz”
* Type: CNAME |              Name: www                                      |              Value: “yourdomain.xyz”

Set the SSL/TLS encryption mode to ''Full (Strict)'' to avoid the "too many redirects" issue

! Router:

Router Settings > DDNS > DNSOMATIC Host Name = all.dnsomatic.com Username = * Password = *
