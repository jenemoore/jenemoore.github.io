---
title: Vim notes
type: post
date: 2023-02-28
tags: 
- vim
---

- use non-recursive mapping (nore) if you're using standard commands; use recursive mapping (?map) if you're including other mappings in your map
- quickref to mapping modes:
    nnoremap - normal mode
    inoremap - insert mode
    xnoremap - visual mode
- the right side of a mapping is a macro

- convert a column to a comma-separated row:
	- 1G to move to the first line
	- CTRL+G to get the number of lines (or check bar)
	- (n)J to convert (n) lines to a space separated list
	- :s/ /,/g to convert spaces to commas

