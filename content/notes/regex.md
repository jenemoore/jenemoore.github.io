# Regexes

+ add quotes around all fields with a space in them in a CSV
```
s/[^,]* [^,]*/"&"/g
```
