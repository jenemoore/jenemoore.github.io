---
title: nginx
type: post
date: 2023-05-23
tags: 
- selfhosting
- config
---

# Nginx
see nginx.conf for server configuration

# Base configuration

`nginx.conf` in the `/etc/nginx` directory

all configuration is set up as directive    parameter; blocks are just directives that enclose other directives to group them together

maintain the config file in a series of separate files for each feature: eg.
    include conf.d/http;
    include conf.d/stream;
    include conf.d/exchange-enhanced;

contexts are top-level directives that group traffic types:
    events for general processing
    http for http traffic
    mail for mail traffic
    stream for TCP and UDP traffic

    anything outside of these is in the main context

in each context, you create one or more server blocks to define virtual servers that handle the processing of requests

## sample w/multiple contexts:
```
user nobody; # main context

events {
    # connection processing
    }

http {
    # http affecting all virtual servers

    server {
    location /one {
    }
    location /two {
    }
    }

    server {
    # second virtual server
    }
}

stream {
    #tcp/udp connection (like logs)
    server {
    }
}
```

a child inherits the configuration from its parent unless it specifies a new parameter, in which case that overrides the parent (see proxy_set_header)

you can restart nginx or send `nginx -s restart` to reload configs

## HTTP configuration

the first matching server in a virtual server list is used as the default; otherwise you can set the default_server parameter

set ssl (eg. listen 443 ssl) to specify that SSL is required for all connections on this port

the most robust way to serve multiple SSL sites is to specify the ip address for each server:

```
server {
    listen          192.168.1.1:443 ssl;
    server_name     www.example.com;
    ssl_certificate www.example.com.crt;
}
server {
    listen          192.168.1.2:443 ssl;
    server_name     www.example.org;
    ssl_certificate www.example.org.crt;
}
```

If you're using a wildcard certificate, put it at the http level of the configuration so all servers inherit it

nginx chooses which server to send packets to based on matching:
1) exact name
2) longest wildcard starting with an asterisk
3) longest wildcard ending in an asterisk
4) first matching regex

### Locations
you can nest location blocks

if you use the top level more often than any other location specified, use the = modifier (`location = / {}` so that it stops searching for other possible matches when an exact match is found

the `return` directive takes a response code and optionally a redirect URL or the text to return in the response body; you can use it at the server or location level

you can also use `error_page` to set custom error pages - eg. `error_page 404 /404.html;`
    this specifies how to treat an error when it happens; if you want to return an error automatically at a specific location, use the return directive in a location block

### Static content

to return a directory listing instead of a 404 code if there isn't an index.html, set `autoindex on`

set `sendfile on` for direct copying without caching (eg. for downloading files); use `sendfile_max_chunk` to set how much one process is allowed to take over; set `tcp_nopush` along with this to send HTTP response headers along with or right after the data


### Reverse Proxy

at the base level all you need is `proxy_pass http://target.uri/;`

there are other directives for non-HTTP servers:
* fastcgi_pass
* uwsgi_pass
* scgi_pass
* memcached_pass

by default, when nginx proxies a request it sets Host to $proxy_host and Connection to close; to change this, use `proxy_set_header` in location or higher (yes you can set it at the HTTP level if all you're doing is reverse proxying)

nginx buffers proxied requests by default; turn it off with `proxy_buffering off` or use `proxy_buffers #buffers buffersize` and `proxy_buffer_size size` to tune (setting size in proxy_buffers sets the size of the first response, while proxy_buffer_size sets the default)

use `proxy_bind` to set the source IP address for your proxy server, if it needs to

### SSL Termination

include the ssl parameter in the listen directive and specify locations of the server certificate and private key (they can be stored in the same file, if access is restricted correctly)

ssl_protocols and ssl_ciphers sets the method of encryption; the defaults are
* ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
* ssl_ciphers HIGH:!aNULL:!MD5;

SSL processes are expensive; optimize them by setting keepalive connections and reusing session parameters
* ssl_session_cache     shared:SSL:10m; # lengthens the cache timeout
* ssl_session_timeout   10m;
* keepalive_timeout     70;

serve both with and without https by using two listen directives, one with and one without SSL

limit the  number of connections:
1) set `limit_conn_zone` - the first parameter is the expression to be evaluated as the key, and the second parameter is the name of the zone and its size
2) set `limit_conn` and specify the name of the shared memory zone and the number of allowed connections

eg. 
```
http {
    limit_conn_zone $server_name zone=servers:10m;

    server {
        limit_conn servers 1000;
    }
}

(you can also use $binary_remote_addr/addr to limit by IP address)

set rate limiting to prevent DDOS attacks: define the parameters of the bucket
    * key
    * shared memory zone
    * rate

`limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;` defines a zone one of a size of ten megabytes, which tracks client IP addresses and allows them to make one request per second
    $binary_remote_addr value is about 4 bytes per IPv4 address, so 16,000 connections can be tracked in one megabyte

once this is set, you can limit requests anywhere in the configuration with `limit_req zone=one`

### Securing access to upstream servers

1) Obtain a client certificate - Let'sEncrypt is free, or create your own, or buy one
2) specify https:// in your proxy_pass directive
3) specify the proxy_ssl_certificate and proxy_ssl_certificate_key
4) add proxy_ssl_trusted_certificate if you're using a self-signed cert
5) set proxy_ssl_session_reuse on to allow NGINX to use an abbreviated handshake to free up resources
6) set proxy_ssl_protocols and/or proxy_ssl_ciphers as above
7) each upstream server should be configured to accept HTTPS connections and have ssl_certificate and ssl_certificate_key specified
8) specify the path to a client certificate with ssl_client_certificate and ssl_verify_client

### Enable conditional logging:
```
map $status $loggable {
    -^[23]  0;
    default 1;
}

access_log /path/to/access.log combined if=$loggable;
```
to disable logging HTTP status codes 2xx and 3xx

