---
type: "post"
---

# How to Homelab
## Part 4: NGINX Reverse Proxy

source: https://www.dlford.io/nginx-reverse-proxy-how-to-home-lab-part-4/

### Set up a web endpoint
1. Create a new VM: clone your template, start it up and run the boilerplate from part 3
2. Install dependencies: for this example, NodeJS and PM2. Run in the console:
    ```
    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
    sudo apt dist-upgrade -y
    sudo apt install -y nodejs git
    npm install -g pm2
    ```

### Add disk space
3. Whoops, running out of disk space--in Proxmox, go to Datacenter > Host > VM > Hardware > Add > Hard Disk
    * Bus/device: SCSI
    * Storage: local-lvm
    * Disk size: as needed
    * Check Discard
4. Back in the console, run `lsblk` to see the new disk available
5. To provision the new disk as an LVM physical volume and extend the volume group--
    * Get the names of the VG and LV - `sudo vgs` and `sudo lvs`
    * Run:
    ```
    sudo pvcreate /dev/[diskname]
    sudo vgextend [vgs-name] /dev/[diskname]
    sudo lvextend [vgs-name]/[lv-name] -l+100%FREE
    sudo resize2fs /dev/[vgs-name]/[lv-name]
    reboot
    ```
6. After rebooting, your base disk should be larger; of course you can always leave it as is, just like adding a physical disk to a machine

### Provision web app
7. Grab the app and set it up:
    ```
    git clone https://github.com/dlford/4t.git
    cd 4t
    npm install
    ```
8. Change the `homepage` value in `package.json` to `http://127.0.0.1`
9. `npm run build`
10. Write a quick script to start the app with NPM:
    ```
    touch startup.sh
    chmod +x startup.sh
    vim startup.sh
        
        npx serve --single --no-clipboard build
    ```
11. Start the script with PM2
    ```
    pm2 start startup.sh --name 4t-app --watch
    ```
12. Run `pm2 startup` for pm2 to give you the command it needs to start itself at boot
13. Save the current configuration with `pm2 save`

### DHCP Reservation
14. Follow the DHCP reservation steps from part 3 

### Reverse Proxy
15. On your NGINX VM, create a new configuration file:
    ```
    sudo vim /etc/nginx/sites-available/4t-app.conf
    ```
16. 4t-app.conf:
    ```
    server {
        listen 80;
        server_name 4t.homelab.name;
        location / {
            proxy_read_timeout 36000s;
            proxy_http_version: 1.1;
            proxy_buffering off;
            client_max_body_size 0; 
            proxy_redirect off;
            proxy_set_header Connection "";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_hide_header X-Powered-By;
            proxy_pass_header Authorization;
            proxy_pass http://yourip:port;
        }
    }
    ```

Note: Remember that client_max_body_size is the limit for uploads: if you're setting up a Git or similar app that allows/requires uploads, this needs to be increased

17. Symlink the file into the directory where NGINX looks for config files: `sudo ln -s /etc/nginx/sites-available/4t-app.conf /etc/ngix/sites-enabled/4t-app.conf`
18. Test the config with `sudo nginx -t`; if that's successful, restart NGINX
19. Add the new URL to your DNS settings
20. Open `http://4t.homelab.name` in a browser and marvel at your skillz
