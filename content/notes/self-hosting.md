---
title: "So You Want to Self-Host a Website"
type: "post"
date: 2023-01-29
tags: "copied", "selfhosting"
---

##So You Want To Self-Host A Website
You'll need:
1) a server
2) a website
3) a Cloudflare account
4) a machine running ngnix propxy manager (can run in the same vm if you want)

This way you're only exposing your public IP address to Cloudflare; Cloudflare points to nginix, and nginix points to the service you want it to have access to

And now: the router (Usual router caveats apply)
Expose ports to the outside world and make sure they're mapped to Nginx

In Cloudflare: create an API token for SSI certificate validation - use template for Edit zone DNS; include all zones (assuming it's an individual account)
       Then: DNS management
       create an A record with the name of the subdomain you want to use and point it to your public IP address - leave it to proxied

At this point: you have a domain with a name service through Cloudflare which points to Nginx
Still need: SSL, Nginx config

SSL: In Nginx, add a Let's Encrypt certificate - you can use a wildcard or use a separate certificate for each website, however you want to use
Set it to Use a DNS challenge - select Cloudflare for your DNS provider and paste in your API token

Then go to: Hosts > Proxy hosts > Create a proxy host source
Put in your site/service with: 
- Domain name
- Scheme: http or https (depends on your site/service) (using http is perfectly fine: it's the traffic between nginx and your local service that isn't encrypted, not the traffic to the outside world), IP address, and the port
- Turn on Block common attacks
- Turn on SSL 

In Cloudflare, set SSL/TLS to Full and Edge Certificates > Always use HTTPS

Now you should be able to put in your URL anywhere and get your website

##When do I virtualize or containerize?
###Definitions
1) bare metal: install with nothing between it and the hardware
2) hypervisor: adds a layer of virtualization, may give access to hardware
3) container: gives access to the kernel but otherwise keeps isolated

###Consider
1) Does it need access to all of the hardware on the machine, or only some of it? If not, you can virtualize
1.5) basically, RaspberryPi projects or anything that uses specific hardware should run bare-metal, but everything else can be virtualized
2) Web servers and APIs are always a good choice
3) Something like a video security system may need direct hardware access - but it can be used entirely over the network, in which case it's a good candidate for virtualization

Rancher > Kubernetes > Docker

(I am not learning anything about how to make these choices but I think I am learning how to get computers to run more smoothly: by isolating things so you can shut them down consistently)

Essentially: if it has a Docker image, containerize it; if it doesn't, but it doesn't need specialized hardware, run a virtual machine.
