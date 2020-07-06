#!/bin/bash

##
# process a single section (stdin -> stdout)
#

sed '/<!-- %CUTHERE% -->/q'
