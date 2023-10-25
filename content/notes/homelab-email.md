# Homelabbing
## How to send email from a Linux server

source: https://www.dlford.io/send-email-alerts-from-linux-server/

1. Set up an email account 
    * Gmail is a popular service, and other services will work similarly
    * Enable "less secure apps" OR, preferably, an app-specific password (if you're using 2FA)
    
2. Configure Postfix
    * `sudo apt install -y postfix mailutils libsasl2-modules`
        * Postfix is a mail transfer agent
        * Mailutils is a set of command-line utilities for working with email
        * libsasl2 is a module used by Postfix to authenticate an to an external email server
    * Create `/etc/postfix/sasl_passwd` and add your credentials:
        * `[smtp.gmail.com]:587 username@gmail.com:password`
    * `postmap /etc/postfix/sasl_passwd` to convert it to a postfix table
    * Lock down permissions on these files:
        * `chown root. /etc/postfix/sasl_passwd`
        * `chmod 600 /etc/postfix/sasl_passwd`
        * `chown root. /etc/postfix/sasl_passwd.db`
        * `chmod 600 /etc/postfix/sasl_passwd.db`
    * Set up aliases and virtual alias maps to redirect mail to root and then to the external address:
    * Edit `/etc/aliases`
        ```
        postmaster: root
        nobody: root
        hostmaster: root
        webmaster: root
        www: root
        ```
    * Run `newaliases` to parse the file
    * Edit `/etc/postfix/virtual`:
        * `root you@yourdomain.com` - where any mail will be directed
    * Run `postmap /etc/postfix/virtual`
    * Edit `/etc/postfix/main.cf`
        * Use Gmail as relay host:
        ```
        relayhost = [smtp.gmail.com]:587
        smtp_tls_security_level = may
        smtp_sasl_auth_enable = yes
        smtp_sasl_security_options =
        smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
        ```
        * Enable your aliases:
        ```
        alias_maps = hash:/etc/aliases
        alias_database = hash:/etc/aliases
        virtual_alias_maps = hash:/etc/postfix/virtual
        ```
        * Remove all the values for `mydestination` so postfix doesn't try to receive mail on the local system
        * Add `inet_protocols = ipv4` so Gmail doesn't try to use IPv6 and confuse postfix
    * Restart postfix

3. Validate
    * Send a test email with `echo "This is a test email" | mail -s "Testing" root`
        * this sends an email to the root user; postfix should re-route it to our destination
   * pull up `less /var/log/mail.log` to see what happened
   * If you see an error message along the lines of "Authentication failed, please log in to your web browser and try again", log in to Gmail and allow access, then test again

4. Systemd monitoring script
    * This script will send off an email specifying which unit (if any) has failed, and re-check every minute until the issue is resolved
    * Create a file:
    ```
    touch /usr/local/bin/systemd-failed-notifier.sh
    chmod +x /sur/local/bin/systemd-failed-notifier.sh
    ```
    * Paste the following into it:
    ```
    #!/bin/bash
    emailAddress="root"
    statusFile="/tmp/systemd-failed-notifier-status"
    lockFile="/tmp/systemd-failed-notifier-lock"
    
    # Check for lock file and create one or quit
    if [ -f "$lockFile" ]; then
      exit 0
    else
      touch "$lockFile"
    fi
    
    # Read status file if it exists or create it
    if [ -f "$statusFile" ]; then
      source "$statusFile"
    else
      touch "$statusFile"
      lastSystemStatus="unknown"
    fi
    
    doAlert () {
      # If system status has changed, update statusFile and send email
      if [ ! "$systemStatus" = "$lastSystemStatus" ]; then
        if [ "$systemStatus" = "degraded" ]; then
          failedUnits="$(systemctl --failed | grep failed | cut -f2 -d' ')"
        else
          failedUnits=""
        fi
        echo -e \
        "
        Current Status: $systemStatus
        Previous Status: $lastSystemStatus
    
        Failed Units:
        $failedUnits" | \
        mail -s "$(hostname) $systemStatus" $emailAddress
        sleep 5
        lastSystemStatus="$systemStatus"
      fi
    }
    
    # Run once
    systemStatus=$(systemctl is-system-running)
    doAlert
    
    # Loop if system status is not running
    while [ ! "$systemStatus" = "running" ]; do
      sleep 60
      systemStatus=$(systemctl is-system-running)
      doAlert
    done
    
    # Cleanup and exit
    echo lastSystemStatus="$systemStatus" > "$statusFile"
    rm "$lockFile"
    exit 0
    ```
    * Create the service and timer files for systemd to run the script for us:
    * /etc/systemd/system/systemd-failed-notifier.service
    ```
    [Unit]
    Description=Systemd status email alert service

    [Service]
    Type=simple
    ExecStart=/usr/local/bin/systemd-failed-notifier.sh
    ```
    * /etc/systemd/system/systemd-failed-notifier.timer
    ```
    [Unit]
    Description=Systemd status email alert timer

    [Timer]
    OnBootSec=5min
    OnUnitActivateSec=60min
    Unit=systemd-failed-notifier.service

    [Install]
    WantedBy=timers.target
    ```
    * Enable and start the timer

### What if my ISP blocks outgoing email?
Use their email service--they have to allow you access to that. 
