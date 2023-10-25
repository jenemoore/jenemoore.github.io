# Linux
## Cron jobs

_cron_ is the utility that allows you to schedule tasks

_cron jobs_ are the scheduled tasks

tasks are bash scripts (as a rule)

_crontab_ is the table/configuration file that contains commands for what to run and when - the default is at `/etc/crontab`

### Limitations
* the shortest interval between jobs is 59 seconds: you can't run anything more than once a minute
* you can't distribute jobs across a network, and if the computer running the job crashes, it just misses those jobs unless you re-run them manually
* tasks don't retry if they fail, they just wait for the next run

So: cron is great for simple tasks that run at a specific time at regular intervals of greater than 60 seconds (scans, backups, updates, cache clearing, system monitoring & notification, etc.)

### The Crontabs
* the system crontab runs system-wide and requires root privileges
* the user crontab only applies at the user level
* basic commands:
    * crontab [options] file
    * crontab -n [hostname]
    * -u define user
    * -e edit user's crontab
    * -l list user's crontab
    * -r delete user's crontab
    * -i prompt before deleting
    * -n host set host in cluster to run users' crontabs
    * -c get host in cluster to run users' crontabs
    * -x enable debugging

### Setting up
Run `crontab -e` to create or edit your crontab file; you'll be asked which editor to use

For installations and updates, add a job to the `/etc/cron.d` directory - this is a system crontab
   
   Other system crontabs:
   * /etc/cron.hourly
   * /etc/cron.daily
   * /etc/cron.weekly
   * /etc/cron.monthly

### Syntax
`# m h d m w command to execute`

* 1st column - minute - number 0-59 specifying the minute of the hour to run on
* 2nd column - hour - number 0-23 specifying the hour of the day to run on
* 3rd column - day - number 1-31 specifying the day of the month to run on
* 4th column - month - number 1-12 specifying the month of the year to run on
* 5th column - day of the week - number 0-6, Sunday to Saturday, specifying the day of the week to run on
* You can't leave any column blank but you can use an asterisk to specify all possible values
* Other operators:
    * Use a comma to separate multiple values: eg 1,5 for Monday and Friday
    * Use a hyphen for a range: eg 6-12 for June through December
    * Use a slash to divide a value: eg. */12 for every twelve hours
    * L for Last in the day-of-month and day-of-week fields: eg. 3L for the last Wednesday of the month
    * W for the closest weekday to a given time: eg. 1W for the following Monday if the 1st is a Saturday
    * # for the number of the day of the week: eg 1#2 for the second Monday of the month
    * ? for no specific value, specifically for the day of the  month/day of the week fields

#### Example
`37 17 * * 5 root/backup.sh` will run the backup.sh script at 5:37pm every Friday

### Special Strings
If your recurrence is straightforward and you don't want to deal with the number strings, use:
    * @hourly to run the job once an hour
    * @daily or @midnight to run every day at midnight
    * @weekly to run once a week at midnight on Sunday
    * @monthly to run once at midnight on the first day of each month
    * @yearly to run once a year at midnight on Jan 1
    * @reboot to run only once at startup

### Results
Output from a cron job is automatically sent to your local email account--to stop receiving these messages, add `>/dev/null 2>&1` at the end of a command

### Permissions
* /etc/cron.allow should contain a user's name to allow them to use cron jobs (if it doesn't exist, anyone is allowed)
* /etc/cron.deny will specify which users cannot run cron jobs (if it doesn't exist and cron.allow does, only users listed in cron.allow can run jobs)

### Tools
* [Crontab Generator](https://crontab-generator.org)
* [Crontab.guru](https://crontab.guru)
