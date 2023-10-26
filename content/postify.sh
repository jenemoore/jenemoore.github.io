#!/bin/bash

# insert Hugo boilerplate into the beginning of every file in this folder
for filename in *; do
		sed -i '1i\
				---\
				date: 2023-10-25\
				type: "post"\
				---\
				' file
done




