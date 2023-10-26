---
type: "post"
---

# How to Homelab
## Part 7: Log Management

source: https://www.dlford.io/log-management-how-to-home-lab-part-7/

1. Set up a new VM -- install updates, run boilerplate configuration (see script)
2. Configure the log server's IP address 
    a. refresh the server's IP address with `ip route` and `sudo ip addr flush ens18 && sudo dhclient ens18`
3. Make sure rsyslog is active
4. Edit `/etc/rsyslog.conf` to accept incoming log messages:
```
# provides UDP syslog reception
module(load="imudp")
input(type="imudp" port="514")

#provides TCP syslog reception
module(load="imtcp")
input(type="imtcp" port="514")
```
(TCP connections are more reliable but UDP is faster and uses fewer resources; use UDP only if you're only using a local network)
5. Configure remote logs to each save into their own file:
```
$template remote-incoming-logs,"/var/log/%HOSTNAME%-rsyslog.log" *.* ?remote-incoming-logs & ~"
```
6. Restart rsyslog
7. Configure log rotation in `/etc/logrotate.d/syslog`: above the line `/var/log/syslog` add `/var/log/*-rsyslog.log`
8. Install `lnav` to view and search logs
    a. running `lnav` alone opens the local syslog; adding the path to a log file opens that one
    b. uses vimish navigation
    c. commands like `filter-in some text` or `filter-out some other text`

## Client configuration
9. create `/etc/rsyslog.d/100-log-server.conf`
    a.  containing `*.* @log-server:514` (or IP address instead of hostname; ping to see what works)
10. Restart rsyslog

There are other visualizations you can use; Graylog really needs 4 cores and 8GB of RAM but there are other options too (I'm sure)


