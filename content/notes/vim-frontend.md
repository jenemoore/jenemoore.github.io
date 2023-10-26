---
type: "post"
---

# Frontend Development Vim Cheatsheet

## tpope/vim-surround
- delete surroundings: `ds`
- change existing surroundings: `cs[curr][new]` eg. "Hello World" cs"' -> 'Hello World'
- create surroundings: `ys[motion/textobj][surrounding]` eg. Hello world! cursor on Hello ysiw] -> [Hello] world!
	- opening brackets will add a space; use closing bracket to wrap without spaces
	- use `yss` to wrap the entire line
- `S` in visual mode

## tpope/vim-ragtag
- <C-X><Space> at the end of a line will turn that line into an HTML/XML tag
- <C-X>/ will close a tag
- <C-X>@ inserts a stylesheet link
- <C-X>$ inserts a js link
-
