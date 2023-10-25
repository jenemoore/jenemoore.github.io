Create the instruction in configuration.yaml:


`mount_nas_folder: mkdir -p /media/leopard;mount NFS_SERVER:EXPORTED_DIRECTORY /media/leopard`


Then add this automation in automations.yaml:

```
- id: "mount_nas"
  alias: Mount Leopard Media Folder
	description: Mounts for use with Music Assistant
	trigger:
	  - platform: homeassistant
		  event: start
	condition: []
	action:
	  - service: shell_command.mount_nas_folder
		  data: {}
```

Then restart and check for Leopard in the Media browser
