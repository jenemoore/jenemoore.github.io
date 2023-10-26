---
type: "post"
---

# How to Homelab
## Part 2: Managing Proxmox VE

source: https://www.dlford.io/managing-proxmox-how-to-home-lab-part-2/

* Check for updates once a week: select host machine, click updates tab, refresh, then click upgrade
* Update your VMs on a similar schedule
* PVE Version Upgrades come with full instructions; follow those

### Snapshots vs Backups
- Snapshots are a representation of the state of a machine: you can't create a new one, but you can roll one back to a snapshot
- Backups are a complete representation of a machine: you can create a wholly new one off this, on a different host if needed

To determine how many backups to keep, calculate (Backup space available/Total size of one backup for all VMs) - 1 for extra padding

eg. if you have 32GiB of backup space and 3 VMs at 2GiB per backup, you have (32/6)-1 = 4.33 backups = keep 4 backups per machine (adjust when you add more machines to the schedule)


