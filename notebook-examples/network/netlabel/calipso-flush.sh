#!/bin/sh

netlabelctl map del default
netlabelctl calipso del doi:12345678
netlabelctl map add default protocol:unlbl
