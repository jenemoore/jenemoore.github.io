---
title: Vim notes
type: post
date: 2023-02-28
tags: vim
---

# To Do

- create a mapping for paste mode: need to set a toggle
- autocommands (or use filetype plugins?):
    - turn on spellcheck for certain filetypes
	- set comment mapping for certain filetypes
x map .md to markdown syntax
x add word count to statusline
	wordcount() returns bytes-chars-words as a js object: key is words


# Reference
:h map-which-keys shows you available or uncommon keys
:h key-notation for functional/non-character keys

ctrl-o to execute a command and then immediately return to normal mode

## Status line
:set statusline=

Each item of the form: 
	%-0{minwidth}.{maxwidth}{item}
All fields except for the item are optional 
	%!
indicates an expression, which will be evaluated and the result set as the option value (& these can be nested)

Fields:
% - start of item
- - left justify (default is right justify)
0 - leading zeroes (overridden by -)
minwidth - of full item, including padding - must be 50 or less
maxwidth - of full item. truncates with a <on the left
>
Potential items:
f - string - path to the file in the buffer
F - string - full file path
t - string - file name of file in buffer
m/M - flag - indicates if file has been modified but not saved 
r/R - flag - readonly flag 
h/H - flag - help buffer flag 
w/W - flag - preview flag
y/Y - flag - filetype flag
q - string - [quickfix list], [location list], or empty
k - string - value of b:keymap_name when local mappings are being used
n - number - buffer number
b - number - value of character under cursor
B - number - as above, in hexadecimal
o/O - number - byte number in file of byte under cursor (or hex)
N - number - printer page # (in 'printheader' option only)
l - number - line number
L - number - # of lines in buffer
c - number - column number (by byte index)
v - number - column number (screen column)
V - number - virtual column number
p - number - percentage through file in lines as in ctrl-G
P - string - percentage through file of displayed window (as in ruler)
a - string - argument list status as in default title ({current} of {max})

{ - number/flag - evaluate the expression between %{ and } and substitute result
{% - almost the same as above, except result is also evaluated as a statusline format string; must pair with %}
( - start of item group; must be followed by %) somewhere
T - number - for 'tabline' - start of tab page N label
X - number - for 'tabline' - start of close tab N label
< - where to truncate line if too long (default is at the start)
= - separation point between left and right aligned items
# - set highlight group; must end with #
* - set highlight group to user{n}, where n is taken from the minwidth field 

flag styles:
lowercase produces brackets eg. [+]
uppercase produces commas eg. ,+

If no flags are set and no minwidth is indicated, the whole group will disappear

If a statusline error renders vim unusable, hold down : to get a prompt, the quit and relaunch vim with vim --clean to edit vimrc

