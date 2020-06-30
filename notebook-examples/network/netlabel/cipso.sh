#!/bin/sh

netlabelctl cipsov4 add pass doi:87654321 tags:5
netlabelctl map del default
netlabelctl map add default address:0.0.0.0/0 protocol:unlbl
netlabelctl map add default address:::/0 protocol:unlbl
netlabelctl map add default address:127.0.0.1 protocol:cipsov4,87654321
netlabelctl -p map list
