#!/bin/sh

netlabelctl calipso add pass doi:12345678
netlabelctl map del default
netlabelctl map add default address:0.0.0.0/0 protocol:unlbl
netlabelctl map add default address:::/0 protocol:unlbl
netlabelctl map add default address:::1 protocol:calipso,12345678
netlabelctl -p map list
