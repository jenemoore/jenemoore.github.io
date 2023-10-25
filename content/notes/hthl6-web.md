# How to Homelab
## Part 6: Hosting on the Open Web

source: https://www.dlford.io/hosting-on-the-web-how-to-home-lab-part-6/

### Get a domain name
1. What to look for in a registrar: free dynamic dns, free whois privacy, TOTP (2fa app) support
    * Namecheap is a decent one

### Configure pfSense
2. Create an alias for non-public addresses, which we'll prevent the internal VMs from accessing in order to protect your home network.
    * Name: Non_Public
    * Type: Networks
    * Network:
        * 10.0.0.0/8
        * 172.16.0.0/12
        * 192.168.0.0/16
        * 169.264.0.0/16
        * 127.0.0.0/8
        * 255.255.255.255/32
        * 224.0.0.0/4
3. Create a rule to allow internal traffic on the LAN network
    * Action: Pass
    * Interface: LAN
    * Address Family: IPV4
    * Protocol: Any
    * Source LAN network
    * Destination: LAN network
    * Log: unchecked
4. Create a rule to allow outbound DNS for apps that require it
    * Action: Pass
    * Interface: LAN
    * Address Family: IPV4
    * Protocol: TCP/UDP
    * Source: LAN net
    * Destination: any
        * Destination port range from DNS (53) to DNS (53)
    * Log: Unchecked
5. Create a rule to allow outbound NTP (network time protocol)
    * Action: Pass
    * Interface: LAN
    * Address Family: IPV4
    * Protocol: TCP/UDP
    * Source: LAN net
    * Destination: any
        * Destination port range from NTP (123) to NTP (123)
    * Log: Unchecked
6. pfSense matches rules top-down, so from this rule on any rules will only apply to public IP addresses, since non-public ones are already being blocked
    * Action: Reject
    * Interface: LAN
    * Address Family: IPV4
    * Protocol: Any
    * Source: LAN net
    * Destination: Single host or alias, Non_Public
    * Log: Checked
    * Description: Reject non-public access
7. Allow ICMP (handles pings and other forms of communication)
    * Action: Pass
    * Interface: LAN
    * Address Family: IPV4
    * Protocol: ICMP
    * ICMP Subtypes: Any
    * Source: LAN net
    * Destination: Any
    * Log: Unchecked
8. Allow web ports (gotta access it somehow)
    * Action: Pass
    * Interface: LAN
    * Address Family: IPV4
    * Protocol: TCP
    * Source: LAN net
    * Destination: Any
        * Destination Port Range: from/to web_ports
    * Log: Unchecked
9. You can now delete any default rules and apply changes. Make sure the rules are in this order.
10. You may also want to add a rule to allow outbound Git (port 9418) access - format it the same way as the ICMP and web port access
11. Disable IPv6: System > Advanced > Networking
12. Disable the anti-lockout rule: System > Advanced > Admin Access (we don't need this because we're technically using the WAN to access it)
13. Moment of truth: forward the web ports on your router
    * Host: IP address of pfSense VM
    * Port: 80 / 443 (for HTTP and HTTPS respectively)
    * Protocol: TCP
14. If you ever need to break open access, disable these port forwards first
15. Use [https://www.yougetsignal.com/tools/open-ports/](a port forwarding tester) to be sure both ports are open to the outside world

### Set up DDNS
16. At your registrar, add a new DNS record:
    * Type: A + Dynamic DNS Record
    * Host: @
    * Value: 0.0.0.0
    * TTL: Automatic
17. Add a CNAME record:
    * Type: CNAME 
    * Host: www
    * Value: mydomain.tld.
    * TTL: Automatic

Don't forget the extra dot at the end of your domain name - that will direct requests for www.domain.tld to domain.tld, which has the dynamic DNS entry. You could use * instead of www here, which would direct all subdomains to the apex domain name.
18. Delete all other DNS records
19. Retrieve your app password, key, or API token to configure a DDNS script
20. Configuring this depends on your registrar; you can use either your NGINX machine or (technically more secure) a separate VM as the DNS's target

### Reconfigure NGINX
21. Set up a self-signed certificate just to get something running on 443:
    ```
    openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365000 -nodes
    mv key.pem /etc/ssl/private/ssl-cert-snakeoil.key
    mv cert.pem /etc/ssl/certs/ssl-cert/snakeoil.pem
    ```
22. Run `openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096`
23. Create the file `/etc/nginx/snippets/ssl-params.conf`
    ```
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'TLS13-AES-256-GCM-SHA384:TLS-CHACHA20-POLY1305-SHA256:TLS-AES-256-GCM-SHA384:TLS-AES-128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256';
    ssl_prefer_server_ciphers on;
    ssl_ecdh_curve secp384r1;
    ssl_session_cache shared:SSL:50m;
    ssl_session_timeout 1d;
    ssl_session_tickets off;
    ssl_stapling on;
    ssl_stapling_verify on;
    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 5s;
    # add_header Strict-Transport-Security "max-age=31536000; includeSubdomains" always;
    add_header X-Frame-Options SAMEORIGIN;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    ssl_dhparam /etc/ssl/certs/dhparam.pem;
    ```
24. In your sites-available directory configs, make some changes:
    * change `listen 80;` to `listen 443 ssl;`
    * change the server_name to a FQDN: your domain n ame or a subdomain, followed by www+FQDN
        * eg. `server_name mysite.com www.mysite.com;`
    * add the following five lines right after that (the first two are for the self-signed certs, the next two are for the LetsEncrypt certificate we'll set up) - be sure to change the domain names
        ```
        ssl_certificate /etc/ssl/certs/ssl-cert-snakeoil.pem;
        ssl_certificate_key /etc/ssl/private/ssl-cert-snakeoil.key;
        # ssl_certificate /etc/letsencrypt/live/4t.mydomain.com/fullchain.pem;
        # ssl_certificate_key /etc/letsencrypt/live/4t.mydomain.com/privkey.pem;
        include /etc/nginx/snippets/ssl-params.conf;
        ```
    * Add the following to the very top of the file, to redirect HTTP traffic to HTTPS:
        ```
        server {
            listen 80;
            server_name mysite.com www.mysite.com;
            return 301 https://www.mysite.com$request_uri;
            }
        ```
    * Add a location block at the end of the server block, inside the last curly brace:
        ```
        #letsencrypt validation
        location '/.well-known/acme-challenge' {
            default_type "text/plain";
            root /var/www/html;
        }
        ```
25. Run `nginx -t` and restart to lad the changes.
26. Run `apt install -y certbot` and do a dry run to be sure everything's configured correctly:
    ```
    certbot certonly --webroot -w /var/www/html -d 4t.mydomain.com -d www.4t.mydomain.com --dry-run
    ```
27. If you get any errors, check the DNSreport from [https://tools.dnsstuff.com](DNSstuff) to diagnose; if everything worked, run the same command again but without the `--dry-run` flag. 
28. Now that you have a valid certificate, remove the two snakeoil certificate lines and uncomment the letsencrypt lines from  your configuration file; test and restart NGINX again.
29. Run `systemctl list-timers | grep certbot` to be sure the automatic renewal timer is set up.

