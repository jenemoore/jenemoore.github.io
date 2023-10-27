---
title: linux filesize
type: post
date: 2023-02-11
tags: linux
---

# Find large files

`du -cha --max-depth=1 / | grep -E "M|G"`

This will search the root directory and return directories with sizes in the megabyte or gigabyte range--pick the largest of them and do this again, eg.

`du -cha --max-depth=1 /var | grep -E "M|G"`
