#!/bin/bash

##
# process a single section (stdin -> stdout)
#

var_date="$(date "+%B %-d, %Y")"
var_githead="$(git rev-parse HEAD | cut -c 1-12)"

sed \
	-e "/<!-- %CUTHERE% -->/q" \
	-e "s/<!-- %DATE% -->/${var_date}/g" \
	-e "s/<!-- %GITHEAD% -->/(rev ${var_githead})/g" \
	-e "s/<!-- %STYLESTART%(\(.*\)) -->/\<div style=\"\1\"\>/g" \
	-e "s/<!-- %STYLEEND% -->/\<\/div\>/g" \
