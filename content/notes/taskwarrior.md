---
title: taskwarrior
type: post
date: 2023-07-11
tags: 
- todo
---

# Taskwarrior 

Tue Jul 11 10:37:45 CDT 2023

- updated priority to A/B/C/D
- you can use year, month, and week dates: socw (start of current week), sow (start of next week), soww (start of workwweek), socy, socq (quarter), socm
- you can also use midsommar, for the first Fri/Sat after June 19
- I am simply not going to use projects
# Active reports --
-active, all, blocked, blocking, completed, list, newest, next, oldest, overdue, ready, recurring, timesheet, unblocked, waiting
also: burndown.daily/weekly/monthly; calendar; ghistory.annual/monthly/weekly/daily (history graph); history.annual/weekly/monthly/daily; projects; reports (list of reports); tags; colors (list colors & assignments
Static reports: burndowns, calendar, colors, export, ghistory, history, information, summary, timesheet

- minimal report might be good for wtfutil/other feeds

All others can be tweaked

I use:
    list (default), next
    plus: filtered by tag

I should use: 
    blocked, blocking, calendar, oldest, overdue, recurring, waiting

- you can set a due date of "someday" to set the due date to the end of the UNIX epoch
- virtual tags are:
    * blocked
    * unblocked
    * blocking
    * due (within rc.days)
    * today
    * overdue
    * week (due this week) - also month, quarter, year
    * active (has a start date)
    * scheduled
    * parent (is it a hidden recurring parent task)
    * child (is it a recurring task)
    * until
    * waiting
    * annotated
    * ready (pendng, not blocked, and not scheduled or scheduled date is > today)
    * yesterday (one day overdue)
    * tomorrow
    * tagged
    * pending/completed/deleted
    * uda (does it contain any custom values)
    * priority
    * project
    * latest

- plain text search terms are being deprecated: prefer regex /pattern/
- task log will create a task that's set to status:completed

LetsEncrypt is now supported! The docs for Taskwarrior are garbage:
```
On the Taskserver:
1. Generate a self-signed CA using taskd/pki/generate.ca
2. Get a copy of your domain's TLS certificates from Let'sEncrypt
3. Configure Taskserver:
	ca.cert=ca.cert.pem
	server.cert=example.com.crt
	server.key=example.com.key
	server=0.0.0.0:53589

On each client:
1. Get a self-signed client keypair from the Taskserver (taskd/pki/generate.client
2. Get a copy of the DST Root CA X3
3. Configure Taskwarrior:
	taskd.certificate=client.cert.pem
	taskd.key=client.key.pem
	taskd.ca=DST_ROOT_CA_X3.crt
	taskd.server=fqdn.com:53589
	taskd.credentials=Group/Name/UUID

Client certs can be revoked by generating a CRL file and pointing server.crl to it in the Taskserver config. For personal installations, it's probalby easier to just regenerate the self-signed CA.
```


