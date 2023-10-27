---
title: vim skeletons
type: post
date: 2023-04-14
tags: 
- vim
---

# Native Vim Templates

* create a directory for the skeleton files (template files)
* add them to your vimrc like so:
```
autocmd BufNewFile README.md 0r ~/.vim/skeletons/readme.md
autocmd BufNewFiles *.sh 0r ~/.vim/skeletons/bash.sh
```

* **autocmd** - do this automatically 
* **BufNewFile** - on creating a new file
* **readme.md** - that matches this pattern
* **0r** - read into the buffer, starting with line 0
* **~/.vim/skeletons/readme.md** - read in this file


