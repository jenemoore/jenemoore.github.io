---
type: "post"
---

# Tmux

## Configuration

* `.tmux.conf`
* `.tmux` (directory)

## Bindings

All tmux bindings start with the prefix: currently bound to ctrl+j (default is ctrl+b)

* prefix+`|` for a new vertical split
* prefix+`-` for a new horizontal split
* prefix+`,` to rename the current window
* prefix+arrow keys to move between windows
* `Ctrl-d` or type `exit` to close a window
* prefix+`c` to create a new window
* prefix+`p` for previous window, `n` for next, or give its specific number
* prefix+`C`-arrowkey to resize the pane in that direction
* prefix+space to open the command prompt (like in Vim)

## Commands

### Sessions
`tmux new -s session_name` to start a new session

`tmux attach -t session_name` to attach to an existing/saved session

`tmux switch -t session_name` to switch to an existing session

`tmux list-sessions` or `tmux ls` to list all existing sessions

`tmux detach` or prefix+d to detach the currently attached session (or prefix+D to specify which session)

`tmux source-file ~/.tmux.conf` to reload the config file

### Help
`tmux list-keys` to list all current bindings and the command it runs

`tmux list-commands` to list every tmux command and the arguments it takes

`tmux info` lists every session, window, pane, pid, etc.


