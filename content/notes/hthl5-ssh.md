# How to Homelab
## Part 5: Secure SSH

source: https://www.dlford.io/secure-ssh-access-how-to-home-lab-part-5/

### Set up a secure SSH access point
1. Clone your template VM, set it up & run boilerplate
2. In pfSense, set up an alias and NAT port forwarding (remember you're setting up for port 22, for SSH access)
3. Check sshd status & ensure it's installed and running (install & run if not)
4. Create a key pair: `ssh-keygen -t rsa -b 4096 -C "yourname@devicename"`
5. Copy the keys to the access point VM: `ssh-copy-id username@ip`

### Harden the SSH server
6. Edit `/etc/ssh/sshd_config` and modify or add:
    * LoginGraceTime 2m
    * PermitRootLogin no
    * StrictModes yes
    * MaxAuthTries 1
    * AllowUsers your-username
    * HostbasedAuthentication no
    * IgnoreUserKnownHosts no
    * IgnoreRhosts yes
    * PasswordAuthentication no
    * PermitEmptyPasswords no
    * ChallengeResponseAuthentication no
    * UsePAM no
7. Restart sshd 

### Set up Fail2Ban
8. `sudo apt install -y fail2ban`
9. Create a new configuration: `sudo vim /etc/fail2ban/jail.local`
10. jail.local:
    ```
    [sshd]
    enabled = true
    port = 22
    filter = sshd
    logpath = /var/log/auth.log
    findtime = 3600
    bantime = 300
    maxretry = 2
    ```

This long find time & short ban time sets a rate limit of 12 attempts per hour, which is slow enough to disrupt a brute force attack but short enough to not be a major inconvenience if you screw it up

A potential second jail for persistent attacks might ban, say, for a week after 19 failed attempts per week (at a max 12 per hour, this would be an hour and a half):

    ```
    [sshd-persistent]
    enabled = true
    port = ssh
    logpath = /var/log/auth.log
    filter = sshd
    bantime = 604800
    findtime = 604800
    maxretry = 19
    ```

This jail would need to remember things for a week, aka longer than Fail2Ban's standard 1 day, so edit `/etc/fail2ban/fail2ban.conf` and change `dbpurgeage = 1d` to 8 days.

11. Enable & start

### Access other hosts
You're now configured so that you can SSH into the access point from your home network and into the other Proxmox machines from the access point, but not into the Proxmox machines directly. If you need the IP address, remember you're aiming at the pfSense IP address, and it's forwarding you to the access point machine.

To maintain security on the access point, make sure your access key there uses a passphrase, and do not add its public key to the access point's authorized_keys file.

### Bonus tips
* Use tmux to manage multiple connections
* You can run a command without fully logging in via SSH: just append it to your login command eg. `ssh user@ip-address free`
* Transfer files from a remote host using `scp user@ip-address:filename ./` (Or local to remote; the syntax is scp FROM TO)
* You can create tunnels with the -L flag, eg: `ssh -L localport:remotehost:remoteport user@ip-address`
