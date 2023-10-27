---
title: haos mount drive
type: post
date: 2023-08-15
tags: 
- homeassistant
---

Create the instruction in configuration.yaml:


`mount_nas_folder: mkdir -p /mount/folder;mount NFS_SERVER:EXPORTED_DIRECTORY /mount/folder


Then add this automation in automations.yaml:

```
- id: "mount_nas"
  alias: Mount Media Folder
	description: Mounts for use with Music Assistant
	trigger:
	  - platform: homeassistant
		  event: start
	condition: []
	action:
	  - service: shell_command.mount_nas_folder
		  data: {}
```

Then restart and check for the drive in the Media browser
