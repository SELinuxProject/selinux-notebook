#!/bin/bash

##
# process the entire document ($1)
#

[[ ! -r $1 ]] && exit 1

sed "s/<!-- %PAGEBREAK% -->/\<div style="page-break-after:always"\>\<\/div\>/g" -i $1
