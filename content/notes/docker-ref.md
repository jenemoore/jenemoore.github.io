# Docker Commands

## Launch an interactive shell

### In the docker compose file:
* `stdin_open: true`
* `tty: true`

### When you need it:

`docker exec SERVICENAME bash`

Note that you need to use the name of the SERVICE you're accessing, not the container
