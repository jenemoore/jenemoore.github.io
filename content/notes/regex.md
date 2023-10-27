---
title: regex
type: post
date: 2023-02-06
tags: 
- script
- quickref
---

# Regexes

+ add quotes around all fields with a space in them in a CSV
```
s/[^,]* [^,]*/"&"/g
```
