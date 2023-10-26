---
type: "post"
---

---
type: "post"
---

#! /bin/bash

day=$(date +"%u")

if ((day==1)); then
	echo "Monday toast"
else if ((day==2); then
	echo "Tuesday toast"
	#etc
fi

case syntax:
case $var in
pattern-1)
	commands;;
pattern-2)
	commands;;
pattern-N)
	commands;;
*)
	default commands;;
esac
