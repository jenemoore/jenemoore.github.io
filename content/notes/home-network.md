---
title: "home networking with a home server"
type: "post"
date: 2022-10-16
tags: "networking", "selfhosting"
---

##Home networking with a home server

Four basic components:
1) Modem
2) Router
3) Switch
4) Access point

Often your ISP will give you a single device that handles all of these

Next step up would be to separate the modem and the router/switch/access point
        But you can have all 4 separate

The modem is the least important/interesting part: it connects you to the internet and gives you a public IP

The router is the *most* important part
        Recommended: NetGate SG-1100 (provides excellent functionality but no switch or access services; designed for small home labs; a little pricey for that)

        What does your router do?
        DHCP server: allocates IP addresses to local devices

        this router is particularly good for setting up VLANs - good for setting up smarthome/IOT devices (which double up nicely with a guest network) - good for security to isolate them from the home server

        PFSense - HAProxy and certificate authority for anything you want to expose to the Internet

Switch: the hub for your hardline devices, eg. everything that plugs into a standard router
        most routers come with 4 plugs; if you have more than 4 devices plugged into it
        recommended: QNAP QSW-M408-4C - 4 dedicated 10gb RJ45 ports + 10 1gb ports - lets you run 10gb to both server and home PC and leaves you room to upgrade

Access points: 
        Recommended: NetGear R6700 v2 - you can use a router or a dedicated access point
        and Asus 10gb network adapter cards - a simple, convenient upgrade - about $100, you can get cheaper ones but this one is well reviewed for both Linux and Windows

Laundry room is a good place to set up a network hub - plenty of shelf space and the noise won't bother anyone


