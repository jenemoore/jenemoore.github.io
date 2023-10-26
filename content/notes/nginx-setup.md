---
title: "subdomains on nginx"
type: "post"
date: 2023-05-22
tags: "selfhosting", "config"
---

# NGINX
## setting up multiple domain names each with multiple subdomains for reverse proxy

- take advantage of includes; there's no need to have half a dozen files with the same items
- one file per domain name, list each subdomain as a server block:
```
server {
    server_name subdomain1.example.com;
    location / {
        proxy_pass       http://hostname1:port1;
    }
}
server {
    server_name subdomain2.example.com;
    location / {
        proxy_pass       http://hostname2:port2;
    }
}
```

