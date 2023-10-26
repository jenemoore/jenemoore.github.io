---
type: "post"
---

# Use rsync to move files and folders between machines

## Copy files from a remote machine to your local machine

`rsync username@ip_address:/home/username/filename .`

## Copy files from your local machine to a remote machine

`rsync filename username@ip_address:/home/username`

## Copy directories

use the `-r` flag

## Synopsis

Pull: `rsync [OPTION...] [USER@]HOST:SRC... [DEST]`

Push: `rsync [OPTION...] SRC... [USER@]HOST:DEST`

### Flags

-`-v` verbosity
-`-q` quiet
-`-r` recursive
-`-R` relative file paths
-`-b` make backups
-`-u` update: skip files that are newer on the receiving location
-`-d` transfer directories without recursing
-`-l` copy symlinks as symlinks
-`-L` transform symlinks into referent file/dir
-`-H` preserve hard links
-`-p` preserve permissions
-`-E` preserve executability
-`-t` preserve modification times
-`-n` perform a dry run
-`--remove-source-files` sender removes syncrhonized files
-`--ignore-existing` skip updating files that exist on receiver
-`-z` compress data during transfer
-`-f` add a filtering RULE
-`--stats`
-`-h` human-readable
-`--progress` show progress during transfer
-`-i` itemize changes
-`--log-file=FILE`
-`--list-only` list files instead of copying them

## Use as a daemon
